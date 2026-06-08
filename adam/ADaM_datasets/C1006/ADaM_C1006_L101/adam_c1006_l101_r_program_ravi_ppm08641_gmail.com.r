# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1006_L101
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
 
 
source("./ADaM_C1006_L101_data.r")
 
 
# Read input dataset and create analysis variables
vs01 <- vs %>%
 mutate(
 paramcd = if_else(vstestcd == "SYSBP" & vspos == "SITTING", "STSBP",
 if_else(vstestcd == "DIABP" & vspos == "SITTING", "STDBP", NA_character_)),
 paramn = if_else(vstestcd == "SYSBP" & vspos == "SITTING", 1,
 if_else(vstestcd == "DIABP" & vspos == "SITTING", 2, NA_real_)),
 param = str_c(str_to_title(vspos), " ", vstest, " (", vsstresu, ")"),
 adt = if_else(nchar(vsdtc) >= 10, ymd(substr(vsdtc, 1, 10)), NA_Date_),
 aval = vsstresn,
 avisit = if_else(visit == "SCREEN", "Screening", str_to_title(visit)),
 avisitn = if_else(visit == "SCREEN", -1, visitnum)
 )
 
# Fetch the treatment start date into vital signs dataset for comparison of dates
adsl01 <- adsl %>%
 mutate(trtsdt = as.Date(trtsdt,origin="1960-01-01"))
 
# Merge the datasets
vs02 <- vs01 %>%
 left_join(adsl01, by = "usubjid")
 
# Derive the baseline flag
base01 <- vs02 %>%
 filter(adt <= trtsdt & !is.na(aval)) %>%
 arrange(usubjid, paramn, adt, visitnum)
 
base02 <- base01 %>%
 group_by(usubjid, paramn) %>%
 slice(n()) %>%
 mutate(ablfl = "Y") %>%
 select(usubjid,paramn,visitnum,adt,ablfl)
 
# Merge the baseline flag back onto the parent dataset
vs03 <- vs02 %>%
 left_join(base02, by = c("usubjid", "paramn", "adt", "visitnum")) %>%
 mutate(
 avisitn = if_else(ablfl == "Y", 0, avisitn,avisitn),
 avisit = if_else(ablfl == "Y", "Baseline", avisit,avisit)
 )
 
# Keep only the required variables and order them in a logical sequence
output <- vs03 %>%
 arrange(usubjid,paramn,adt) %>%
 select(usubjid, paramn, paramcd, param, adt, aval, avisit, avisitn, trtsdt, ablfl)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================