# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# Knip het schijfnummer uit een albumnaam. 
# 
# Voorbeeld: v1 <- getDiskNr_in_albumNaam(c("CD-1", "Beethoven", "cd2", "Fantasy [Disc 3]"))
#            v1 : "1" NA  "2" "3"
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
getDiskNr_in_albumNaam <- function(albumnaam){
  result <- sub("^.*(cd-?(\\d+)|dis[ck] ?(\\d+)).*$", "\\2\\3", albumnaam, perl=TRUE, ignore.case=TRUE)
  ifelse(result == albumnaam, NA, result)
}
