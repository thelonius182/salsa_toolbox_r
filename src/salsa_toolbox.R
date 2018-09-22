# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Knip het schijfnummer uit een albumnaam. 
# 
# Voorbeeld: v1 <- getDiskNr_in_albumNaam(c("CD-1", "Beethoven", "cd2", "Fantasy [Disc 3]"))
#            v1 : "1" "0"  "2" "3"
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
getDiskNr_in_albumNaam <- function(albumnaam){
  result <- sub("^.*(cd-?(\\d+)|dis[ck] ?(\\d+)).*$", "\\2\\3", albumnaam, perl=TRUE, ignore.case=TRUE)
  if_else(result == albumnaam, "0", result)
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Harmoniseer catalogusnummer en schijfnummer in de naam vd uitzendmac-directory
# Vb. 1123 -> 1123¶0; 1123-2 -> 1123¶2; 1123 CD 4 -> 1123¶4
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
harmoniseer_catDskNr_dir <- function(uzm_dir_fragment){
  result <- sub("^(\\d+) ?(-|cd) ?(\\d+).*$", "\\1¶\\3", uzm_dir_fragment, perl=TRUE, ignore.case=TRUE)
  if_else(result == uzm_dir_fragment, paste0(uzm_dir_fragment, "¶0"), result)
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Harmoniseer schijfnummer en tracknummer in de tracknaam
# Vb. 12 -> 0-12; 1-16 -> 1-16;
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
harmoniseer_dskTrkNr <- function(track_fragment){
  result <- sub("^\\d{1,3}(-)\\d{1,3}.*$", "\\1", track_fragment, perl=TRUE)
  if_else(result == track_fragment, paste0("0-", track_fragment), track_fragment)
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Harmoniseer catalogusnummer en schijfnummer in een czID van Filemaker
# 
# Voorbeeld: zie unittests
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
harmoniseer_catDskNr_in_FM_czID <- function(fm_czid){
  result <- sub("^C0*(\\d+)(-+(\\d+))?.*$", "\\1 \\3", fm_czid, perl=TRUE) %>% trimws
  if_else(str_detect(result, pattern = "^\\d+$"), paste0(result, " 0"), result)
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Harmoniseer schijfnummer en tracknummers in trackreeks van Filemaker
# 
# Voorbeeld: zie unittests
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
harmoniseer_catTrcks_in_FM_tracks <- function(fm_tracks){
  result <- sub("^(cd)? ?((\\d+): ?)?(\\d+)( ?- ?(\\d+))?$", "0\\3¶\\4¶0\\6", 
                fm_tracks, perl=TRUE, ignore.case=TRUE)
}

