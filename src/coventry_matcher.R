pacman::p_load(tidyr, dplyr, stringr, readr, lubridate, fs, futile.logger, purrr)
               
log_dir_uzm <- "//UITZENDMAC-2/macOS/Users/tech_1/Library/Logs/Radiologik/Play Logs/2026"

logs_raw_uzm <- tibble(log_file = list.files(log_dir_uzm,
                                             pattern = "\\.(log|txt|csv)$",
                                             full.names = TRUE,
                                             recursive = TRUE,
                                             ignore.case = TRUE)) |>
  mutate(log_date_from_name = str_extract(basename(log_file), "\\d{8}|\\d{4}-\\d{2}-\\d{2}"),
         log_date_from_name = 
           case_when(str_detect(log_date_from_name, "^\\d{8}$")               ~ ymd(log_date_from_name),
                     str_detect(log_date_from_name, "^\\d{4}-\\d{2}-\\d{2}$") ~ ymd(log_date_from_name),
                     TRUE                                                     ~ as.Date(NA))) |>
  mutate(lines = map(log_file, read_lines, progress = TRUE)) |>
  unnest_longer(lines, values_to = "line") |>
  mutate(line_nr = row_number(),
         line = str_squish(line)) |>
  filter(line != "")

played_audio_uzm <- logs_raw_uzm |>
  mutate(audio_path = str_extract(line, "(/[^\"']+\\.(mp3|m4a|wav|aif|aiff|flac))")) |>
  filter(!is.na(audio_path)) |>
  distinct(audio_path, .keep_all = TRUE) |>
  mutate(audio_dir = dirname(audio_path),
         audio_file = basename(audio_path),
         date_from_audio_file = str_extract(audio_file, "^\\d{8}"),
         broadcast_date = ymd(date_from_audio_file),
         hour_from_audio_file = str_extract(audio_file, "^\\d{8}[-_ ]?\\d{2}") |>
           str_extract("\\d{2}$") |>
           as.integer())

needed_dirs_uzm <- played_audio_uzm |>
  filter(str_starts(audio_path, "/Volumes/Avonden/")) |>
  mutate(needed_dir = str_match(audio_path, "^(/Volumes/Avonden/[^/]+)")[, 2]) |>
  filter(!is.na(needed_dir)) |>
  count(needed_dir, sort = TRUE) |> 
  filter(n > 5)
