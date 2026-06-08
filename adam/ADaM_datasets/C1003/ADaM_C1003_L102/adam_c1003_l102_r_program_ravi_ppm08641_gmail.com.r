# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1003_L102
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
 
 
source("./ADaM_C1003_L102_data.r")
 
# Read input data and format trtsdt
ae01 <- ae %>%
 mutate(trtsdt = as.Date(trtsdt, origin = "1960-01-01"))
 
# Create ASTDT and AENDT variables
ae02 <- ae01 %>%
 mutate(
 astdt = ifelse(nchar(aestdtc) == 10, as.Date(aestdtc, format = "%Y-%m-%d"), NA),
 aendt = ifelse(nchar(aeendtc) == 10, as.Date(aeendtc, format = "%Y-%m-%d"), NA)
 ) %>%
 mutate(across(ends_with("dt"), ~ as.Date(., format = "%Y-%m-%d"))) %>%
 select(usubjid, aedecod, aesev, astdt, aendt, trtsdt, aestdtc, aeendtc)
 
# Get the maximum severity per AEDECOD for events occurred prior to treatment start
base01 <- ae02 %>%
 filter(!is.na(astdt) & !is.na(trtsdt) & astdt < trtsdt) %>%
 arrange(usubjid, aedecod, aesev) %>%
 group_by(usubjid, aedecod) %>%
 slice(n())
 
# Populate Maximum severity observed for a decod for a subject across all records of that decod of that subject
base02 <- base01 %>%
 select(usubjid, aedecod, basesev=aesev)
 
ae03 <- ae02 %>%
 left_join(base02, by = c("usubjid", "aedecod"))
 
# Create TRTEMFL variable
ae04 <- ae03 %>%
 mutate(
 trtemfl = if_else(astdt >= trtsdt & (is.na(basesev) | aesev > basesev), "Y", "N","N")
 ) %>%
 arrange(usubjid,aedecod,aestdtc)
 
# Keep only required variables and order the variables in a logical sequence
output <- ae04 %>%
 select(usubjid, aedecod, aesev, astdt, aendt, trtemfl, trtsdt, aestdtc, aeendtc)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================