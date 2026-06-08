# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1011_L101d
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
 
 
source("./ADaM_C1011_L101d_data.r")
 
library(dplyr)
 
vs02 <- vs %>%
 mutate(crit1 = case_when(
 paramn == 1 ~ "Systolic Pressure > 160",
 paramn == 2 ~ "Diastolic Pressure > 90",
 TRUE ~ NA_character_
 ),
 crit2 = case_when(
 paramn == 1  ~ "Change from baseline in Systolic Pressure > 15",
 paramn == 2  ~ "Change from baseline in Diastolic Pressure > 10",
 TRUE ~ NA_character_
 ),
 crit1fl = case_when(
 paramn == 1 & aval > 160 ~ "Y",
 paramn == 2 & aval > 90 ~ "Y",
 TRUE~""
 ),
 crit2fl = case_when(
 paramn == 1 & chg > 15 & !is.na(chg) ~ "Y",
 paramn == 2 & chg > 10 & !is.na(chg) ~ "Y",
 TRUE~""
 ),
 )
 
 
output<-vs02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================