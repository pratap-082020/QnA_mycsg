# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1004_L103a
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
 
 
source("./ADaM_C1004_L103a_data.r")
 
 
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
# Create the new parameter- BMI
#=========================================================
 
hgt01 <- vs02 %>%
 filter(paramcd == "HEIGHT") %>%
 select(usubjid, aval) %>%
 rename(height = aval)
 
bmi03 <- vs02 %>%
 filter(paramcd == "WEIGHT") %>%
 select(usubjid, adt, aval) %>%
 rename(weight = aval) %>%
 left_join(hgt01, by = "usubjid") %>%
 mutate(
 aval = if_else(!is.na(height) & !is.na(weight), round(weight / ((height / 100)^2), 2), NA_real_),
 paramcd = "BMI",
 param = "Body Mass Index (kg/m2)",
 paramtyp = "DERIVED"
 )
 
#=========================================================
# Combine the derived parameter records with records of source parameters
#=========================================================
 
vs03 <- bind_rows(vs02, bmi03) %>%
 arrange(usubjid, paramcd, adt)
 
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