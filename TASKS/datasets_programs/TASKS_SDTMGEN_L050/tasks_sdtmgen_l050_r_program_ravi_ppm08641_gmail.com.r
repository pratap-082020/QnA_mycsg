# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L050
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.R")
#rmac1-std1
#rmac1-std2
#rmac1-std3
 
 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
 
 
library(glue)
library(tidyverse)
library(haven)
library(assertthat)
library(huxtable)
library(data.table)
library(hms)
library(lubridate)
library(pharmaRTF)
 
 
source("./TASKS_SDTMGEN_L050_data.r")
 
 
library(dplyr)
library(stringr)
 
 
ae01 <- ae %>%
 mutate(
 stdayn = suppressWarnings(as.numeric(word(aestdat_raw, 1))),
 stday = if_else(!is.na(stdayn), str_pad(stdayn, width = 2, pad = "0"), "-"),
 stmonthc = str_to_upper(word(aestdat_raw, 2)),
 stmonth = case_when(
 stmonthc == "JAN" ~ "01",
 stmonthc == "FEB" ~ "02",
 stmonthc == "MAR" ~ "03",
 stmonthc == "APR" ~ "04",
 stmonthc == "MAY" ~ "05",
 stmonthc == "JUN" ~ "06",
 stmonthc == "JUL" ~ "07",
 stmonthc == "AUG" ~ "08",
 stmonthc == "SEP" ~ "09",
 stmonthc == "OCT" ~ "10",
 stmonthc == "NOV" ~ "11",
 stmonthc == "DEC" ~ "12",
 TRUE ~ "-"
 ),
 styear = word(aestdat_raw,3),
 styear1 = if_else((styear == "UNK") | (is.na(styear)), "-", styear),
 aestdate = str_c(styear1, stmonth, stday, sep = "-"),
 aestdtc = if_else(aesttm != "", str_c(aestdate, aesttm, sep = "T"), aestdate),
 
 aestdtc = if_else(str_sub(aestdtc, -5) == "-----","",aestdtc),
 aestdtc = if_else(str_sub(aestdtc, -4) == "----",str_sub(aestdtc,end=-5),aestdtc),
 aestdtc = if_else(str_sub(aestdtc, -2) == "--",str_sub(aestdtc,end=-3),aestdtc)
 )
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================