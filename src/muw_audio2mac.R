# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Verplaats bestelde audio naar MAC en pak uit
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
pacman::p_load(readr, futile.logger, dplyr, yaml, fs, magrittr, lubridate, zip, stringr)

src_audio <- dir_ls(path = "C:/Users/gergiev/Downloads/", type = "file", regexp = "Bestelling#.*\\.zip") 

for (f1 in src_audio) {
  src_audio_file <- path_file(f1)
  tgt_audio <- path_join(c("//uitzendmac-2/Data/Nipper/muziekweb_audio/", src_audio_file))
  file_move(f1, tgt_audio)
  command <- paste0("7z.exe x ", tgt_audio, " -o", path_dir(tgt_audio), " -y")
  system(command)
  file_delete(tgt_audio)
}
