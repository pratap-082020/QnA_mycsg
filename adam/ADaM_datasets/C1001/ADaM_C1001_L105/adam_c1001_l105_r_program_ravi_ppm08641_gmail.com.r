# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1001_L105
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
 
 
source("./ADaM_C1001_L105_data.r")
 
# Read input datasets
adsl01 <- adsl
 
# Create the new grouping variables
adsl02 <- adsl01 %>%
 mutate(
 bmigr1 = case_when(
 !is.na(bmibl) & bmibl < 18.5 ~ "Underweight",
 bmibl >= 18.5 & bmibl < 24.9999 ~ "Normal weight",
 bmibl >= 25 & bmibl < 30 ~ "Overweight",
 bmibl >= 30 ~ "Obesity",
 TRUE ~ NA_character_
 ),
 bmigr1n = case_when(
 !is.na(bmibl) & bmibl < 18.5 ~ 1,
 bmibl >= 18.5 & bmibl < 24.9999 ~ 2,
 bmibl >= 25 & bmibl < 30 ~ 3,
 bmibl >= 30 ~ 4,
 TRUE ~ NA_real_
 ),
 agegr1 = case_when(
 !is.na(age) & age < 60 ~ "< 60 years",
 age >= 60 & age <= 75 ~ "60 - 75 years",
 age > 75 ~ "> 75 years",
 TRUE ~ NA_character_
 ),
 agegr1n = case_when(
 !is.na(age) & age < 60 ~ 1,
 age >= 60 & age <= 75 ~ 2,
 age > 75 ~ 3,
 TRUE ~ NA_real_
 ),
 agegr2 = case_when(
 !is.na(age) & age < 79.9999 ~ "< 80 years",
 age >= 80 ~ ">= 80 years",
 TRUE ~ NA_character_
 ),
 agegr2n = case_when(
 !is.na(age) & age < 79.9999 ~ 1,
 age >= 80 ~ 2,
 TRUE ~ NA_real_
 )
 )
 
# Create SITEGR1 variable based on the number of subjects within a site
siteid01 <- adsl02 %>%
 group_by(siteid) %>%
 summarise(count = n())
 
siteid02 <- siteid01 %>%
 mutate(sitegr1 = if_else(count < 10, "Pooled Group", as.character(siteid)))
 
# Merge back the SITEGR1 variable
adsl03 <- adsl02 %>%
 left_join(siteid02, by = "siteid")
 
# Keeping only the required variables and ordering them
adsl04 <- adsl03 %>%
 arrange(usubjid) %>%
 select(usubjid, siteid, sitegr1, age, agegr1, agegr1n, agegr2, agegr2n,
 bmibl, bmigr1, bmigr1n, weightbl, heightbl)
 
output<-adsl04
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================