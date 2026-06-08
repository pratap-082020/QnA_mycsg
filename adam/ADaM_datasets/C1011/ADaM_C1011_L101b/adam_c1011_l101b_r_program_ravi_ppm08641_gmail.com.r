# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1011_L101b
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
 
 
source("./ADaM_C1011_L101b_data.r")
 
 
 
vs01<-vs %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"),
 adt=as.Date(adt,origin="1960-01-01"))
 
 
vs02 <- vs01 %>%
 mutate(
 crit1 = case_when(
 paramn == 1  ~ "Systolic Pressure < 100",
 paramn == 2  ~ "Diastolic Pressure < 60",
 TRUE ~ NA_character_
 ),
 crit1fl = case_when(
 paramn == 1 & (!is.na(aval) & aval < 100) ~ "Y",
 paramn == 2 & (!is.na(aval) & aval < 60) ~ "Y",
 TRUE ~ "N"
 )
 )
 
 
output <- vs02 %>%
 select(usubjid, paramcd, param, paramn, avisitn, avisit, adt, ady, aval, crit1, crit1fl, trtsdt)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================