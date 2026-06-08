# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1003_L101
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
 
 
source("./ADaM_C1003_L101_data.r")
 
# Read input data
ae01 <- ae %>%
 mutate(trtsdt = as.Date(trtsdt,origin="1960-01-01"))
 
# Create ASTDT, AENDT, and TRTEMFL variables
ae02 <- ae01 %>%
 mutate(
 astdt = ifelse(nchar(aestdtc) == 10, as.Date(aestdtc, format = "%Y-%m-%d"), NA),
 aendt = ifelse(nchar(aeendtc) == 10, as.Date(aeendtc, format = "%Y-%m-%d"), NA),
 trtemfl = ifelse(!is.na(astdt) & !is.na(trtsdt) & astdt >= trtsdt, "Y", "N")
 ) %>%
 select(usubjid, aedecod, astdt, aendt, trtemfl, trtsdt, aestdtc, aeendtc) %>%
 mutate(across(ends_with("dt"), ~as.Date(., format = "%Y-%m-%d")))
 
 
# Keep only required variables and order the variables in a logical sequence
output <- ae02
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================