pacman::p_load(readr, tidyr, dplyr, stringr, optparse)

# Define the options
moro_options <- list(
  make_option(c("-v", "--version"), type = "character", default = NULL,
              help = "date of the new modelrooster", metavar = "character")
)

# Parse the command-line arguments
opt_parser <- OptionParser(option_list = moro_options)
opts <- parse_args(opt_parser)

# Check if required arguments are provided
if (is.null(opts$version)) {
  stop("missing argument(s). Please provide the version, using '-v' or --version'.", call. = FALSE)
}

moro_def_qfn <- "C:/Users/nipper/r_projects/run_weekschema.bat"
moro_def <- read_file(moro_def_qfn)
moro_def_upd <- moro_def |> 
  str_replace(pattern = "set_mr_version\\.R \\d{8}", paste0("set_mr_version.R ", opts$version))
write_file(moro_def_upd, moro_def_qfn, append = F)
sprintf("Updated %s", moro_def_qfn)

moro_def_qfn <- "C:/Users/nipper/r_projects/run_mtrooster.bat"
moro_def <- read_file(moro_def_qfn)
moro_def_upd <- moro_def |> 
  str_replace(pattern = "set_mr_version\\.R \\d{8}", paste0("set_mr_version.R ", opts$version))
write_file(moro_def_upd, moro_def_qfn, append = F)
sprintf("Updated %s", moro_def_qfn)

moro_def_qfn <- "C:/Users/nipper/r_projects/cz_studiomails/config.yaml"
moro_def <- read_file(moro_def_qfn)
moro_def_upd <- moro_def |> 
  str_replace(pattern = "modelrooster_versie: .\\d{8}.", paste0('modelrooster_versie: "', opts$version, '"'))
write_file(moro_def_upd, moro_def_qfn, append = F)
sprintf("Updated %s", moro_def_qfn)

moro_def_qfn <- "C:/Users/nipper/r_projects/released/cz_rlsched_compiler/config.yaml"
moro_def <- read_file(moro_def_qfn)
moro_def_upd <- moro_def |> 
  str_replace(pattern = "cz_modelrooster_versie: .\\d{8}.", paste0('cz_modelrooster_versie: "', opts$version, '"'))
write_file(moro_def_upd, moro_def_qfn, append = F)
sprintf("Updated %s", moro_def_qfn)

moro_def_qfn <- "C:/Users/nipper/r_projects/released/cz_wpgidsweek/config_prd.yaml"
moro_def <- read_file(moro_def_qfn)
moro_def_upd <- moro_def |> 
  str_replace(pattern = "modelrooster_versie: .\\d{8}.", paste0('modelrooster_versie: "', opts$version, '"'))
write_file(moro_def_upd, moro_def_qfn, append = F)
sprintf("Updated %s", moro_def_qfn)
