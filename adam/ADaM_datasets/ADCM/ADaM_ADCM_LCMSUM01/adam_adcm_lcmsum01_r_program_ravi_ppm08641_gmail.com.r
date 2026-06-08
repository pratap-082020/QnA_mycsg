# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADCM_LCMSUM01
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
 
 
source("./ADaM_ADCM_LCMSUM01_data.r")
 
 
library(dplyr)
library(tidyr)
 
#==============================================================================;
# Process input datasets
#==============================================================================;
 
adsl01 <- adsl %>%
 filter(!is.na(trtsdt))
 
#==============================================================================;
# Create a dataset to hold the list of all derived parameters to be created
#==============================================================================;
 
 
template01 <- tibble(
 paramcd = c('W4VIS', 'W12VIS', 'W18VIS', 'W26VIS', 'W32VIS', 'W39VIS', 'W45VIS', 'W52VIS',
 'W4RESC', 'W12RESC', 'W18RESC', 'W26RESC', 'W32RESC', 'W39RESC', 'W45RESC', 'W52RESC'),
 start = c(1, 58, 107, 156, 205, 251, 296, 342, 1, 58, 107, 156, 205, 251, 296, 342),
 end = c(57, 106, 155, 204, 250, 295, 341, 372, 57, 106, 155, 204, 250, 295, 341, 372)
)
 
#------------------------------------------------------------------------------;
# Create a separate grouping variable for CM and SV based parameters
#------------------------------------------------------------------------------;
 
 
 
template02 <- template01 %>%
 mutate(
 group = case_when(
 str_detect(paramcd, "RESC") ~ "CM",
 str_detect(paramcd, "VIS") ~ "SV",
 TRUE ~ NA_character_
 ),
 param = case_when(
 paramcd == 'W4VIS' ~ 'Baseline to Week 4 Visit',
 paramcd == 'W12VIS' ~ 'Week 4 to Week 12 Visit',
 paramcd == 'W18VIS' ~ 'Week 12 to Week 18 Visit',
 paramcd == 'W26VIS' ~ 'Week 18 to Week 26 Visit',
 paramcd == 'W32VIS' ~ 'Week 26 to Week 32 Visit',
 paramcd == 'W39VIS' ~ 'Week 32 to Week 39 Visit',
 paramcd == 'W45VIS' ~ 'Week 39 to Week 45 Visit',
 paramcd == 'W52VIS' ~ 'Week 45 to Week 52 Visit',
 paramcd == 'W4RESC' ~ 'Baseline to Week 4 Rescue Therapy',
 paramcd == 'W12RESC' ~ 'Week 4 to Week 12 Rescue Therapy',
 paramcd == 'W18RESC' ~ 'Week 12 to Week 18 Rescue Therapy',
 paramcd == 'W26RESC' ~ 'Week 18 to Week 26 Rescue Therapy',
 paramcd == 'W32RESC' ~ 'Week 26 to Week 32 Rescue Therapy',
 paramcd == 'W39RESC' ~ 'Week 32 to Week 39 Rescue Therapy',
 paramcd == 'W45RESC' ~ 'Week 39 to Week 45 Rescue Therapy',
 paramcd == 'W52RESC' ~ 'Week 45 to Week 52 Rescue Therapy',
 TRUE ~ NA_character_
 ),
 paramn = case_when(
 paramcd == 'W4VIS' ~ 101,
 paramcd == 'W12VIS' ~ 102,
 paramcd == 'W18VIS' ~ 103,
 paramcd == 'W26VIS' ~ 104,
 paramcd == 'W32VIS' ~ 105,
 paramcd == 'W39VIS' ~ 106,
 paramcd == 'W45VIS' ~ 107,
 paramcd == 'W52VIS' ~ 108,
 paramcd == 'W4RESC' ~ 201,
 paramcd == 'W12RESC' ~ 202,
 paramcd == 'W18RESC' ~ 203,
 paramcd == 'W26RESC' ~ 204,
 paramcd == 'W32RESC' ~ 205,
 paramcd == 'W39RESC' ~ 206,
 paramcd == 'W45RESC' ~ 207,
 paramcd == 'W52RESC' ~ 208,
 TRUE ~ NA_integer_
 )
 )
 
#==============================================================================;
# Create a record for each paramcd for all required subjects
#==============================================================================;
 
template03 <- adsl %>%
 filter(!is.na(trtsdt)) %>%
 select(studyid, usubjid, trtsdt) %>%
 crossing(template02) %>%
 arrange(usubjid, start, paramcd)
 
#==============================================================================;
# Pool required records from SV and CM datasets
#==============================================================================;
 
days01 <- bind_rows(
 sv %>%
 select(studyid, usubjid, svstdy) %>%
 rename(day = svstdy) %>%
 mutate(group = "SV"),
 cm %>%
 filter(rescmed == "Y") %>%
 select(studyid, usubjid, cmstdy) %>%
 rename(day = cmstdy) %>%
 mutate(group = "CM")
)
 
#==============================================================================;
# Derive AVALC
#==============================================================================;
 
sum01 <- template03 %>%
 left_join(days01,
 by = c("studyid", "usubjid", "group")
 ,relationship = "many-to-many") %>%
 mutate(met = ifelse(!is.na(day) & start <=day & day <=end, 1, 2)) %>%
 arrange(usubjid, group, paramcd, met, day)
 
#==============================================================================;
# Choose latest date of all available transfusion dates
#==============================================================================;
 
sum02 <- sum01 %>%
 group_by(usubjid, group, paramcd) %>%
 slice(1) %>%
 ungroup() %>%
 mutate(avalc = ifelse(!is.na(day) & start <=day & day <=end, "Y", "N")) %>%
 arrange(usubjid,paramn) %>%
 rename_all(toupper)
 
#==============================================================================;
# Keep only required variables
#==============================================================================;
 
 
varlist <- c("STUDYID", "USUBJID", "PARAM", "PARAMCD", "PARAMN", "AVALC")
 
adcmsum <- sum02 %>%
 select(all_of(varlist))
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================