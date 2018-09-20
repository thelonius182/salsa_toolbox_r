source(config$toolbox, encoding = "UTF-8")

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
  expect_equal(schijfnummer, "0")
})

test_that("Harmoniseer catalogusnummer en schijfnummer in de naam vd uitzendmac-directory", {
  catDskNr <- harmoniseer_catDskNr_dir("3467")
  expect_equal(catDskNr, "3467¶0")
  catDskNr <- harmoniseer_catDskNr_dir("3467-2")
  expect_equal(catDskNr, "3467¶2")
  catDskNr <- harmoniseer_catDskNr_dir("3467 - 23")
  expect_equal(catDskNr, "3467¶23")
  catDskNr <- harmoniseer_catDskNr_dir("3467CD6")
  expect_equal(catDskNr, "3467¶6")
  catDskNr <- harmoniseer_catDskNr_dir("3467 cd 45")
  expect_equal(catDskNr, "3467¶45")
})

test_that("Harmoniseer schijfnummer tracknummer in de tracknaam", {
  dskTrkNr <- harmoniseer_dskTrkNr(c("12", "1-1"))
  expect_equal(dskTrkNr, c("0-12", "1-1"))
  dskTrkNr <- harmoniseer_dskTrkNr("02")
  expect_equal(dskTrkNr, "0-02")
  dskTrkNr <- harmoniseer_dskTrkNr("2-1")
  expect_equal(dskTrkNr, "2-1")
  dskTrkNr <- harmoniseer_dskTrkNr("678")
  expect_equal(dskTrkNr, "0-678")
})

