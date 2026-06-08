# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1011_L201
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
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
library(lubridate)
library(pharmaRTF)
 
 
source("./ADaM_C1011_L201_data.r")
 
 
# Assuming adlb is a dataframe
lb01 <- adlb
 
lb02 <- lb01 %>%
 mutate(
 chgtoxgrn = ifelse(!is.na(atoxgrn) & !is.na(btoxgrn), atoxgrn - btoxgrn, NA),
 mcrit1 = ifelse(paramcd == "ALT", "ALT Grade Increase", NA),
 mcrit1ml = case_when(
 avisitn > 0 & (!is.na(chgtoxgrn) & chgtoxgrn <= 0) ~ "No Grade Increase",
 chgtoxgrn == 1 ~ "Increase of 1 Grade",
 chgtoxgrn >= 2 ~ paste0("Increase of ", chgtoxgrn, " Grades"),
 TRUE ~ NA
 ),
 mcrit1mn = case_when(
 mcrit1ml=="No Grade Increase" ~ 0,
 mcrit1ml=="Increase of 1 Grade" ~ 1,
 mcrit1ml=="Increase of 2 Grades" ~ 2,
 mcrit1ml=="Increase of 3 Grades" ~ 3,
 mcrit1ml=="Increase of 4 Grades" ~ 4,
 mcrit1ml=="Increase of 5 Grades" ~ 5,
 TRUE ~ NA
 )
 )
 
output <- lb02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================