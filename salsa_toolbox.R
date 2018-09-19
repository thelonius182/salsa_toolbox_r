# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Knip het schijfnummer uit een albumnaam. 
# 
# Voorbeeld: v1 <- getDiskNr_in_albumNaam(c("CD-1", "Beethoven", "cd2", "Fantasy [Disc 3]"))
#            v1 : "1" "0"  "2" "3"
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
getDiskNr_in_albumNaam <- function(albumnaam){
  result <- sub("^.*(cd-?(\\d+)|dis[ck] ?(\\d+)).*$", "\\2\\3", albumnaam, perl=TRUE, ignore.case=TRUE)
  ifelse(result == albumnaam, "0", result)
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Harmoniseer catalogusnummer en schijfnummer in de naam vd uitzendmac-directory
# Vb. 1123 -> 1123¶0; 1123-2 -> 1123¶2; 1123 CD 4 -> 1123¶4
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
harm_catdsk <- function(uzm_dir_fragment){
  result <- sub("^(\\d+) ?(-|cd) ?(\\d+).*$", "\\1¶\\3", uzm_dir_fragment, perl=TRUE, ignore.case=TRUE)
  ifelse(result == uzm_dir_fragment, paste0(uzm_dir_fragment, "¶0"), result)
}
