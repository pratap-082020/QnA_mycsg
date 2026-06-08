# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1002_L101
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

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
 
 
source("./ADaM_C1002_L101_data.r")
 
 
adae01 <- ae %>%
 mutate(
 date = word(aestdtc, 1, sep = fixed("T")),
 time = word(aestdtc, 2, sep = fixed("T")),
 time = if_else(is.na(time), "", time),
 time1 = if_else(nchar(time) == 5, str_c(time, ":00"), time),
 astdt = if_else(nchar(date) == 10, suppressWarnings(ymd(date)), NA),
 asttm = if_else(nchar(time1) > 0, suppressWarnings(parse_time(time)), NA),
 astdtm = if_else(nchar(aestdtc) >= 16, suppressWarnings(ymd_hms(aestdtc)), NA),
 )
 
output<-select(adae01,usubjid,aestdtc,astdt,asttm,astdtm)
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================