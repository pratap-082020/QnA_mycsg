# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1002_L103
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
 
 
source("./ADaM_C1002_L103_data.r")
 
# Load necessary libraries
library(dplyr)
library(lubridate)
 
#=========================================================
# Read input datasets
#=========================================================
 
ae01 <- ae
 
#=========================================================
# Create ASTDT and ASTDTF variables
#=========================================================
 
ae02 <- ae01 %>%
 mutate(
 aest_year = as.numeric(substr(aestdtc, 1, 4)),
 aest_month = as.numeric(substr(aestdtc, 6, 7)),
 aest_day = as.numeric(substr(aestdtc, 9, 10)),
 
 trtsdt=as.Date(trtsdt,"1960-01-01"),
 # Extracting year, month and day from trtsdt
 trtst_year = ifelse(!is.na(trtsdt), year(trtsdt), NA),
 trtst_month = ifelse(!is.na(trtsdt), month(trtsdt), NA),
 trtst_day = ifelse(!is.na(trtsdt), day(trtsdt), NA),
 
 # Converting trtsdt to character format
 trtsdtc = ifelse(!is.na(trtsdt), format(as.Date(trtsdt, format = "%Y-%m-%d"),format = "%Y-%m-%d"), NA),
 trtstym = substr(trtsdtc, 1, 7),
 # Defining astdt and astdtf based on the length of aestdtc
 astdt = case_when(
 nchar(aestdtc) == 10 ~ as.Date(aestdtc, format = "%Y-%m-%d"),
 nchar(aestdtc) == 7 ~ case_when(
 aestdtc == substr(trtsdtc, 1, 7) ~ as.Date(paste0(aestdtc, "-", trtst_day), format = "%Y-%m-%d"),
 aestdtc > substr(trtsdtc, 1, 7) ~ as.Date(paste0(aestdtc, "-01"), format = "%Y-%m-%d"),
 aestdtc < substr(trtsdtc, 1, 7) ~ as.Date(paste0(aestdtc, "-01"), format = "%Y-%m-%d") %>% ceiling_date("month") - days(1),
 TRUE ~ NA_Date_
 ),
 nchar(aestdtc) == 4 ~ case_when(
 aest_year > trtst_year ~ as.Date(paste0(aestdtc, "-01-01"), format = "%Y-%m-%d"),
 aest_year == trtst_year ~ as.Date(trtsdt, format = "%Y-%m-%d"),
 aest_year < trtst_year ~ as.Date(paste0(aestdtc, "-12-31"), format = "%Y-%m-%d"),
 TRUE ~ NA_Date_
 ),
 TRUE ~ NA_Date_
 ),
 
 # Defining astdtf based on the length of aestdtc
 astdtf = case_when(
 nchar(aestdtc) == 7 ~ "D",
 nchar(aestdtc) == 4 ~ "M",
 TRUE ~ NA_character_
 )
 )
 
#=========================================================
# Keep only the required variables and order the variables in a logical sequence
#=========================================================
 
output <- ae02 %>%
 select(usubjid, aestdtc, astdt,trtsdt, astdtf)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================