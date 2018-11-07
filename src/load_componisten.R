library(data.table)
path_componisten <- "f:/documenten/cz_docs/Salsa/Nipper/componistennamen uit Musicalics rev-2.txt"
componisten <- fread(file = path_componisten, sep = "\t", header = F, stringsAsFactors = F, encoding = "UTF-8")

source("src/transform_componisten.R")
componisten <- trf_componisten(componisten)
