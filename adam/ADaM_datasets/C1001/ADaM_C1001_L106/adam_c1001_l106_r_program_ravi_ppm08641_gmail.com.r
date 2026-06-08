# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1001_L106
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
 
 
source("./ADaM_C1001_L106_data.r")
 
# Derive EOSSTT, EOSDT, and DCSREAS
# Subset and process the End of Study related record from Disposition data
# Create EOSDT and DCSREAS variables.
# DSSTDC on END OF STUDY record is EOSDT
# Any value in DSDECOD variable other than 'COMPLETED' is DCSREAS.
# EOSSTT will be partially derived in a later step using this data as we need to check for the absence of record (which can only be checked by comparing the subjects in this subset with DM dataset).
 
eos01 <- ds %>%
 filter(dscat == "DISPOSITION EVENT" & dsscat == "END OF STUDY") %>%
 mutate(
 eosdt = as.Date(dsstdtc, format = "%Y-%m-%d"),
 dcsreas = case_when(
 dsdecod != "COMPLETED" ~ dsdecod,
 TRUE ~ NA
 ),
 eosstt = case_when(
 dsdecod != "COMPLETED" ~ "DISCONTINUED",
 dsdecod == "COMPLETED" ~ "COMPLETED",
 TRUE ~ NA
 )
 ) %>%
 select(usubjid, eosstt, dcsreas, eosdt)
 
# Derive EOTDT and DCTREAS
# Subset and process the End of Treatment related record from Disposition data
# Create EOTDT and DCTREAS variables.
# DSSTDC on END OF TREATMENT record is EOTDT
# Any value in DSDECOD variable other than 'COMPLETED' is DCTREAS.
# EOTSTT will be partially derived in a later step using this data as we need to check for the absence of record (which can only be checked by comparing the subjects in this subset with DM dataset).
 
eot01 <- ds %>%
 filter(dscat == "DISPOSITION EVENT" & dsscat == "END OF TREATMENT") %>%
 mutate(
 eotdt = as.Date(dsstdtc, format = "%Y-%m-%d"),
 dctreas = case_when(
 dsdecod != "COMPLETED" ~ dsdecod,
 TRUE ~ NA_character_
 ),
 eotstt = case_when(
 dsdecod != "COMPLETED" ~ "DISCONTINUED",
 dsdecod == "COMPLETED" ~ "COMPLETED",
 TRUE ~ NA_character_
 )
 ) %>%
 select(usubjid, eotstt, eotdt, dctreas)
 
# Bring the processed EOT and EOS related variables into DM dataset
# Sort the datasets before merging at the subject level
# Use in= dataset operator to identify if a dataset is contributing to a particular observation in the merged dataset
# If a subject exists in DM but not in EOS - ONGOING in study
# If a subject exists in DM but not in EOT - ONGOING in treatment
 
adsl01 <- dm %>%
 left_join(eos01, by = "usubjid") %>%
 left_join(eot01, by = "usubjid") %>%
 mutate(
 eosstt = ifelse(is.na(eosstt), "ONGOING", eosstt),
 eotstt = ifelse(is.na(eotstt), "ONGOING", eotstt)
 ) %>%
 select(usubjid, eotstt, eotdt, dctreas, eosstt, eosdt, dcsreas)
 
# Arrange variables in a logical sequence for easy review
adsl <- adsl01 %>%
 select(usubjid, eotstt, eotdt, dctreas, eosstt, eosdt, dcsreas)
 
# Create output dataset
output <- adsl
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================