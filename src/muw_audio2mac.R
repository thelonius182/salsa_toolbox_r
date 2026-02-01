# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Verplaats bestelde audio naar MAC en pak uit
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
pacman::p_load(readr, futile.logger, dplyr, yaml, fs, magrittr, lubridate, zip, stringr, rlang)

fa <- flog.appender(appender.file("g:/salsa/Logs/muw_audio2mac.log"), name = "m2m_log")
flog.info("Running Audio-mover", name = "m2m_log")

# start MCL
repeat { 
  
  src_audio <- dir_ls(path = "C:/Users/gergiev/Downloads/", type = "file", regexp = "Bestelling#.*\\.zip") 

  if (length(src_audio) == 0) {
    flog.info("No MuW-zips found.", name = "m2m_log")
    break
  }
  
  for (f1 in src_audio) {
    src_audio_file <- path_file(f1)
    flog.info("Found %s", src_audio_file, name = "m2m_log")
    tryCatch(
      {
        tgt_audio <- path_join(c("//uitzendmac-2/Data/Nipper/muziekweb_audio/", src_audio_file))
        file_move(f1, tgt_audio)
      },
      error = function(e1) {
        flog.info("Moving to Mac failed: %s", conditionMessage(e1), name = "m2m_log")
        break
      }
    )
    
    tryCatch(
      {
        cmd  <- "C:/Program Files/7-Zip/7z.exe"
        args <- c("x", tgt_audio, paste0("-o", path_dir(tgt_audio)), "-y", "-bb3")
        out  <- system2(cmd, args, stdout = TRUE, stderr = TRUE)
        status <- attr(out, "status") %||% 0
        out_msg <- paste0(paste(out, collapse = "\n"), "\nEXIT=", status, "\n")
        flog.info(out_msg, name = "m2m_log")
      },
      error = function(e1) {
        flog.info("Unpacking on Mac failed: %s", conditionMessage(e1), name = "m2m_log")
        break
      }
    )
    
    file_delete(tgt_audio)
  }
  
  # leave MCL
  break
}
