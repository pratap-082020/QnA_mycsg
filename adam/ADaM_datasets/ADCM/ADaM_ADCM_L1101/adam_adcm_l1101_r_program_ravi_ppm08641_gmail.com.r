# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADCM_L1101
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
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
library(lubridate)
library(pharmaRTF)
 
 
source("./ADaM_ADCM_L1101_data.r")
 
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
# Step 1: Sorting data frames
cm01 <- cm %>% arrange(studyid, usubjid)
adsl <- adsl %>% arrange(studyid, usubjid) %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"),
 trtedt=as.Date(trtedt,origin="1960-01-01"))
 
# Step 2: Merging data frames
cm02 <- inner_join(cm01, adsl, by = c("studyid", "usubjid"))
 
#==============================================================================;
#Create derived variables;
#==============================================================================;
cm03 <- cm02 %>%
 mutate(
 # ASTDT/ASTDTF
 astdt = case_when(
 nchar(cmstdtc) == 10 ~ as.Date(cmstdtc, format = "%Y-%m-%d"),
 is.na(cmstdtc) | cmstdtc == "" ~ trtsdt,
 nchar(cmstdtc) == 7 ~ as.Date(paste(cmstdtc, "01", sep = "-"), format = "%Y-%m-%d"),
 nchar(cmstdtc) == 4 ~ as.Date(paste(cmstdtc, "01-01", sep = "-"), format = "%Y-%m-%d")
 ),
 astdtf = case_when(
 nchar(cmstdtc) == 10 ~ " ",
 is.na(cmstdtc) | cmstdtc == "" ~ "Y",
 nchar(cmstdtc) == 7 ~ "D",
 nchar(cmstdtc) == 4 ~ "M"
 ),
 # AENDT/AENDTF
 aendt = case_when(
 !is.na(trtedt) & (is.na(cmendtc)|cmendtc=="") ~ trtedt,
 nchar(cmendtc) == 10 ~ as.Date(cmendtc, format = "%Y-%m-%d"),
 nchar(cmendtc) == 7 ~ ceiling_date(as.Date(paste(cmendtc, "01", sep = "-"), format = "%Y-%m-%d"), "month"),
 nchar(cmendtc) == 4 ~ if_else(cmendtc == as.character(year(trtedt)), trtedt, as.Date(paste(cmendtc, "12-31", sep = "-"), format = "%Y-%m-%d"))
 ),
 aendtf = case_when(
 is.na(cmendtc)|cmendtc=="" ~ "Y",
 nchar(cmendtc) == 7 ~ "D",
 nchar(cmendtc) == 4 ~ "M",
 TRUE ~ ""
 ),
 # ONTRTFL/PREFL
 ontrtfl = if_else(
 (!is.na(astdt) & !is.na(trtsdt) & !is.na(trtedt) & trtsdt <= astdt & astdt <= trtedt)|
 (!is.na(aendt) & !is.na(trtsdt) & !is.na(trtedt) & trtsdt <= aendt & aendt <= trtedt) |
 (!is.na(astdt) & !is.na(aendt) & !is.na(trtsdt) & !is.na(trtedt) & astdt<trtsdt & aendt > trtedt), "Y",""),
 
 prefl = if_else(!is.na(aendt) & !is.na(trtsdt) & aendt < trtsdt, "Y", ""),
 # Other variables
 trtan = trt01an,
 trta = trt01a,
 astdy = if_else(!is.na(astdt) & !is.na(trtsdt), astdt - trtsdt + (astdt >= trtsdt), NA),
 aendy = if_else(!is.na(aendt) & !is.na(trtsdt), aendt - trtsdt + (aendt >= trtsdt), NA),
 astdy=as.numeric(astdy),
 aendy=as.numeric(aendy)
 ) %>%
 rename_all(toupper)
 
 
 
#==============================================================================;
#Keep only required variables and sort the final dataset;
#==============================================================================;
varlist <- c("STUDYID", "USUBJID", "CMSEQ", "CMTRT", "CMMODIFY", "CMDECOD", "ATC1CD", "ATC2CD", "ATC3CD",
 "ATC1", "ATC2", "ATC3", "CMINDC", "CMDOSFRM", "CMDOSE", "CMDOSU", "CMDOSFRQ", "CMROUTE",
 "CMSTDTC", "ASTDT", "ASTDTF", "ASTDY", "CMENDTC", "AENDT", "AENDTF", "CMENRF", "AENDY",
 "ONTRTFL", "PREFL", "SAFFL", "TRTA", "TRTAN", "TRTSDT", "TRTEDT", "AGE", "AGEGR1", "SEX", "RACE")
 
adcm <- cm03 %>%
 select(all_of(varlist))
 
adcm <- adcm %>%
 arrange(STUDYID, USUBJID, ASTDT, CMDECOD, AENDT)
 
output <- adcm
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================