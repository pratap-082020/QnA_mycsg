# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1011_L101c
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
 
 
source("./ADaM_C1011_L101c_data.r")
 
vs01 <- vs %>%
 mutate(adt=as.Date(adt,origin="1960-01-01"),
 trtsdt=as.Date(trtsdt,origin="1960-01-01")
 )
 
vs02 <- vs01 %>%
 mutate(
 crit1 = if_else(paramn == 1, "Systolic Pressure > 160 and CHG > 15", NA_character_),
 crit1fl = case_when(
 paramn == 1 & aval > 160 & chg > 15 ~ "Y",
 paramn == 1 & !is.na(chg) ~ "N",
 TRUE ~ NA_character_
 )
 )
 
output <- vs02 %>%
 select(usubjid, paramcd, param, paramn, avisitn, avisit, adt, ady, aval,
 base, chg, crit1, crit1fl, trtsdt)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================