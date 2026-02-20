# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Pak bestelde audio uit en verplaats naar MAC
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
pacman::p_load(readr, futile.logger, dplyr, yaml, fs, magrittr, lubridate, zip, stringr, rlang)

fa <- flog.appender(appender.file("g:/salsa/Logs/muw_unzpd_audio2mac.log"), name = "muz2m_log")
flog.info("Running unzipped Audio-mover", name = "muz2m_log")

# start MCL
repeat { 
  
  muw_zips <- dir_ls(path = "C:/Users/gergiev/Downloads/", type = "file", regexp = "Bestelling#.*\\.zip") 
  
  if (length(muw_zips) == 0) {
    flog.info("No MuW-zips found.", name = "muz2m_log")
    break
  }
  
  for (f1 in muw_zips) {
    muw_zips_file <- path_file(f1)
    flog.info("Found %s", muw_zips_file, name = "muz2m_log")
    
    tmp_dir <- path_temp("unzip_")
    dir_create(tmp_dir)

    tryCatch(
      {
        flog.info("Extracting files in %s to %s", muw_zips_file, tmp_dir, name = "muz2m_log")
        cmd  <- "C:/Program Files/7-Zip/7z.exe"
        args <- c("x", f1, paste0("-o", tmp_dir), "-y", "-bb3")
        out  <- system2(cmd, args, stdout = TRUE, stderr = TRUE)
        status <- attr(out, "status") %||% 0
        out_msg <- paste0(paste(out, collapse = "\n"), "\nEXIT=", status, "\n")
        flog.info(out_msg, name = "muz2m_log")
        flog.info("Finished extracting files in %s", muw_zips_file, name = "muz2m_log")
      },
      error = function(e1) {
        flog.info("Unpacking on Nipper failed: %s", conditionMessage(e1), name = "muz2m_log")
        break
      }
    )
    
    flog.info("Moving files in %s to Mac", muw_zips_file, name = "muz2m_log")
    tryCatch(
      {
        tgt_audio <- "//uitzendmac-2/Data/Nipper/muziekweb_audio"
        
        # Copy extracted content to the share
        file_copy(dir_ls(tmp_dir, recurse = TRUE, type = "file"), tgt_audio, overwrite = TRUE)
        
        # Cleanup
        dir_delete(tmp_dir)
        file_delete(f1)
      },
      error = function(e1) {
        flog.info("Moving to Mac failed: %s", conditionMessage(e1), name = "muz2m_log")
        break
      }
    )
    
    flog.info("Finished moving files in %s to Mac", muw_zips_file, name = "muz2m_log")
  }
  
  flog.info("Audio-mover completed normally", name = "muz2m_log")
  
  # leave MCL
  break
}
