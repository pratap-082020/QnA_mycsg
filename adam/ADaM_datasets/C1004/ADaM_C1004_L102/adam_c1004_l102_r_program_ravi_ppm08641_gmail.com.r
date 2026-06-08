# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1004_L102
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
 
 
source("./ADaM_C1004_L102_data.r")
 
 
#=========================================================
# Read input datasets
#=========================================================
 
vs01 <- vs
 
#=========================================================
# Create variables and parameters which are directly based on source records
#=========================================================
 
vs02 <- vs01 %>%
 mutate(
 paramcd = vstestcd,
 param = paste0(str_trim(vstest), " (", str_trim(vsstresu), ")"),
 adt = if_else(nchar(vsdtc) >= 10, as.Date(substr(vsdtc, 1, 10), "%Y-%m-%d"), NA),
 aval = vsstresn
 )
 
#=========================================================
# Create the new parameter- Height (m)
#=========================================================
 
height_data <- vs02 %>%
 filter(paramcd == "HEIGHT") %>%
 mutate(
 aval = if_else(aval > 0, round(aval / 100, 2), aval),
 paramcd = "HEIGHTMT",
 param = "Height (m)"
 )
 
vs03 <- bind_rows(
 vs02,
 height_data
)
 
#=========================================================
# Keep only the required variables and order the variables in logical sequence
#=========================================================
 
output <- vs03 %>%
 select(usubjid, paramcd, param, adt, aval)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================