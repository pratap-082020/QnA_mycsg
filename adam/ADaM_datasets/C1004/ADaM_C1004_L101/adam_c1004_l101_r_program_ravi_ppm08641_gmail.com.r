# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1004_L101
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
 
 
source("./ADaM_C1004_L101_data.r")
 
 
#=========================================================
# Read input datasets
#=========================================================
 
vs01 <- vs
 
#=========================================================
# Create variables and parameters which are directly based on source records
#=========================================================
 
vs01 <- vs %>%
 mutate(
 paramcd = vstestcd,
 param = paste0(str_trim(vstest), " (", str_trim(vsstresu), ")"),
 adt = as.Date(vsdtc,"%Y-%m-%d"),
 aval = vsstresn
 )
 
#=========================================================
# Create the new parameter- log10(weight)
#=========================================================
 
weight_data <- vs01 %>%
 filter(paramcd == "WEIGHT") %>%
 mutate(
 aval = if_else(aval >= 0, round(log10(aval), 2), aval),
 paramcd = "L10WT",
 param = "Log10(Weight (kg))"
 )
 
vs02 <- bind_rows(
 vs01,
 weight_data
)
 
#=========================================================
# Keep only the required variables and order the variables in logical sequence
#=========================================================
 
output <- vs02 %>%
 select(usubjid, paramcd, param, adt, aval)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================