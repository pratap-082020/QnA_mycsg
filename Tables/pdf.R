#LD
#SASVID
#SASPROG
#SASDATA
#TIDYVERSEPROG
#CD
#IMG

library(chromote)
getwd()
#=====================================================
# OUTPUT FOLDER
#=====================================================


outdir <- "TFL_PDFs"
dir.create(outdir, showWarnings = FALSE)

#=====================================================
# URLS
#=====================================================

urls <- c(
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L201",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L202",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L301",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L302",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L401",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L100",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L103",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L103a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L103b",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L104",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L105",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L105a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L105a1",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L106",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L107",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L107a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L108",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L108a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L109",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L110",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L111",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L112",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L113",
  "https://mycsg.in/tfl.php?area=tfl&concept=TCM&lesson=TFL_TCM_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TCM&lesson=TFL_TCM_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDM&lesson=TFL_TDM_L100",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDM&lesson=TFL_TDM_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDS&lesson=TFL_TDS_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDS&lesson=TFL_TDS_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDS&lesson=TFL_TDS_L102a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L103",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L104",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L105",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L106",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L106a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L106b",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEX&lesson=TFL_TEX_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L103",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L104",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L105",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L106",
  "https://mycsg.in/tfl.php?area=tfl&concept=TMH&lesson=TFL_TMH_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TPC&lesson=TFL_TPC_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TPE&lesson=TFL_TPE_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TPP&lesson=TFL_TPP_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TRS&lesson=TFL_TRS_L103"
)

#=====================================================
# DOWNLOAD PDFS
#=====================================================

b <- ChromoteSession$new()

for(i in seq_along(urls)) {
  
  url <- urls[i]
  
  lesson <- sub(".*lesson=", "", url)
  
  pdf_file <- file.path(
    outdir,
    paste0(lesson, ".pdf")
  )
  
  cat("Downloading:", lesson, "\n")
  
  b$Page$navigate(url)
  
  Sys.sleep(5)
  
  pdf_data <- b$Page$printToPDF(
    printBackground = TRUE,
    paperWidth = 8.27,
    paperHeight = 11.69
  )
  
  writeBin(
    jsonlite::base64_dec(pdf_data$data),
    pdf_file
  )
  
  Sys.sleep(2)
}

cat("Done!\n")