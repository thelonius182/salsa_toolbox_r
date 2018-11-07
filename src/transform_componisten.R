trf_componisten <- function(object) {
  colnames(object) <- c("id", "achternaam", "voornaam", "dummy-1", "dummy-2", "dummy-3", "dtm_van", "dtm_tem", "periode")
  object %<>% select(-starts_with("dummy")) %>% 
    mutate(periode = factor(periode, 
                            levels = c("Middeleeuwen", 
                                       "Renaissance", 
                                       "Barok", 
                                       "Klassiek", 
                                       "Romantiek", 
                                       "Modern"), 
                            ordered = T)
    ) %>% 
    arrange(periode, achternaam, dtm_van)
}