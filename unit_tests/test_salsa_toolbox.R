# Load the libraries
library(testthat)

# Source the scripts
source("f:/documenten/ws_rstudio/salsa_toolbox_r/salsa_toolbox.R")

# Define the context
context("Utilities voor Salsa")

# Define the tests
test_that("knip schijfnummer uit een string", {
  schijfnummer <- getDiskNr_in_albumNaam("H O L N D F S T V L - A Dutch Miracle 1947-1997 (Disc 4b) Royal Concertgebow Orchestra CD2")
  expect_equal(schijfnummer, "2")
  schijfnummer <- getDiskNr_in_albumNaam(c("H O L N D F S T V L - A Dutch Miracle 1947-1997 (Disc 410b) Royal Concertgebow Orchestra"))
  expect_equal(schijfnummer, "410")
  schijfnummer <- getDiskNr_in_albumNaam("Mahler Symphony No. 9 - Klemperer PO (CD-3)")
  expect_equal(schijfnummer, "3")
  schijfnummer <- getDiskNr_in_albumNaam(c("Mahler (CD-5)", "Klemperer Disk6"))
  expect_equal(schijfnummer, c("5", "6"))
  schijfnummer <- getDiskNr_in_albumNaam("Steve Dobogasz - my rose")
  expect_equal(schijfnummer, NA)
})

