#### Setup ---------------------------------------------------------------

pacman::p_load(dplyr, stringr, purrr, tibble, fs, futile.logger,
               lubridate, readr, keyring, RMySQL)

#### Logging setup --------------------------------------------------------

log_file <- "c:/Users/nipper/Logs/nas_rename.log"

# Send logs to file (root logger)
fa <- flog.appender(appender.file(log_file))

fth <- flog.threshold(INFO)

#### Functions ------------------------------------------------------------

get_wp_conn <- function() {
  db_type <- "prd"
  db_host <- key_get(service = paste0("sql-wp", db_type, "_host"))
  db_user <- key_get(service = paste0("sql-wp", db_type, "_user"))
  db_password <- key_get(service = paste0("sql-wp", db_type, "_pwd"))
  db_name <- key_get(service = paste0("sql-wp", db_type, "_db"))
  db_port <- 3306
  
  result <- tryCatch( {
    grh_conn <- dbConnect(drv = MySQL(), user = db_user, password = db_password,
                          dbname = db_name, host = db_host, port = db_port)
  },
  error = function(e1) {
    flog.error("Verbinden met Wordpress database is mislukt: %s", conditionMessage(e1))
    return("connection-error")
  }
  )
  
  result
}

format_dutch <- function(x) {
  # ensure in desired timezone if needed
  x <- with_tz(x, "Europe/Amsterdam")
  
  date_part  <- format(x, "%Y%m%d")
  dow_abbr   <- c("zo", "ma", "di", "wo", "do", "vr", "za")[wday(x, week_start = 7)]
  nth_in_mon <- ((mday(x) - 1) %/% 7) + 1
  hour_part  <- format(x, "%H")
  
  sprintf("%s_%s%d_%su", date_part, dow_abbr, nth_in_mon, hour_part)
}

move_with_retry <- function(src, dst, tries = 3, wait = 0.5) {
  
  for (i1 in seq_len(tries)) {
    
    move_ok <- tryCatch({
      file_move(src, dst)
      TRUE
    }, error = function(e) {
      
      if (grepl("busy or locked", conditionMessage(e), ignore.case = TRUE) && i1 < tries) {
        Sys.sleep(wait)
        FALSE
      } else {
        stop(e)
      }
    })
    
    if (move_ok) return(TRUE)
  }
}

#### Configuration --------------------------------------------------------

# -. path to Synology ----
base_dir <- "//CZ-synology/WoJ HH/Mazen"

# -. dry-run ----
# set to FALSE when satisfied with preview
dry_run <- FALSE

if (dry_run) {
  
  #### 1. Collect files -----------------------------------------------------
  
  flog.info("Scanning directory: %s", base_dir)
  
  all_files <- dir_ls(
    path    = base_dir,
    recurse = TRUE,
    type    = "file",
    fail    = FALSE
  )
  
  # mark any non-matching file names, and split into significant parts
  pat <- "^(\\d{8})[- ._](?:\\D{2}(\\d{2})|(\\d{2})\\d{2})[- ._](.*)$"
  
  lacie_replays_synology <- tibble(path = all_files) |> 
    mutate(fnu = path_file(path), # fnu = FileNameUnqualified
           matching = str_detect(fnu, pat),
           bc_date_chr = if_else(matching, sub(pat, "\\1", fnu, perl = TRUE), NA_character_),
           bc_time_chr = if_else(matching, sub(pat, "\\2\\3", fnu, perl = TRUE), NA_character_),
           bc_ts_chr = if_else(matching, paste0(bc_date_chr, bc_time_chr), NA_character_),
           bc_ts = if_else(!is.na(bc_ts_chr), ymd_h(bc_ts_chr), NA_Date_),
           bc_title = if_else(matching, sub(pat, "\\4", fnu, perl = TRUE), NA_character_),
           fnu_ext = path_ext(fnu))
  
  if (nrow(lacie_replays_synology) == 0L) {
    flog.info("No files found under %s", base_dir)
  } else {
    flog.info("Found %d files", nrow(lacie_replays_synology))
  }
  
  #### 2. Build rename plan -------------------------------------------------
  
  # Connect to database 
  wp_conn <- get_wp_conn()
  
  # connection type S4 indicates a valid connection; other types indicate failure
  if (typeof(wp_conn) != "S4") { 
    flog.error("Wordpress database niet beschikbaar")
    stop()
  }
  
  # select replay and original attributes from WordPress database
  sql_stmt <- read_file("src/get_lacie_replays.sql")
  lacie_replays_wp <- dbGetQuery(wp_conn, sql_stmt)
  
  dbd <- dbDisconnect(wp_conn)
  
  lacie_replays_wp <- lacie_replays_wp |> mutate(replay_date_ymd = ymd_hms(replay_date))
  
  # combine FS and WP attributes
  lacie_replays_combi <- lacie_replays_synology |> 
    left_join(lacie_replays_wp, by = join_by(bc_ts == replay_date_ymd))
  
  # -. apply wysiwyg ----
  # and keep valid ones only
  plan_prep <- lacie_replays_combi |> mutate(fnu_wysiwyg = paste0(format_dutch(original_date), 
                                                                  "_060_door_de_mazen_vh_net.", fnu_ext),
                                             new_path = paste0(path_dir(path), "/", fnu_wysiwyg)) |> 
    filter(!is.na(original_id)) 
  
  plan_log <- plan_prep |> select(original_id, original_date, new_path, replay_id, replay_date, old_path = path)
  plan <- plan_prep |> select(old_path = path, new_path)
  
  flog.info("Dry run mode: no files renamed. Set dry_run <- FALSE to apply.")
  
  write_tsv(plan_log, "dry_run_log.tsv")
  
  flog.info("View results in <R-project folder>/dry_run_log.tsv")
  
} else {
  
  # assuming dry-run completed succesfully
  flog.info("Applying renames...")
  
  # Perform renames ----
  result <- map2_lgl(plan$old_path, plan$new_path, move_with_retry)
  
  # Verify results
  renamed_tbl <- plan |> mutate(existed_before = file_exists(old_path),
                                exists_after   = file_exists(new_path))
  
  failed <- renamed_tbl |> filter(!exists_after)
  
  if (nrow(failed) == 0L) {
    flog.info("All files renamed successfully.")
  } else {
    flog.warn("Some files could not be verified after renaming:")
    failed |>
      select(old_path, new_path, existed_before, exists_after) |>
      print(n = nrow(failed))
  }
}
