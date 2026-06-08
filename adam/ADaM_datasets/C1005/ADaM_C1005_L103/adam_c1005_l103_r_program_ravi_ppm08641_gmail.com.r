# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1005_L103
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
 
 
source("./ADaM_C1005_L103_data.r")
 
library(dplyr)
 
#==============================================================================
# Read input data
#==============================================================================
eg01 <- adeg
 
#==============================================================================
# Create average record
#==============================================================================
avg01 <- eg01 %>%
 group_by(studyid, usubjid, paramcd, param, avisitn, avisit, adt, ady) %>%
 summarize(mean = mean(aval), count = n()) %>%
 ungroup()
 
avg02 <- avg01 %>%
 mutate(
 dtype = "AVERAGE",
 aval = round(mean, 2)
 )
 
#==============================================================================
# Append the average record to the parent dataset
#==============================================================================
eg02 <- bind_rows(eg01, avg02)
 
#==============================================================================
# Sort the dataset
#==============================================================================
eg02 <- eg02 %>%
 arrange(usubjid, paramcd, adt, !is.na(dtype), atm)
 
#==============================================================================
# Select the required variables and order them
#==============================================================================
output <- eg02 %>%
 select(studyid, usubjid, paramcd, param, avisitn, avisit, adt, atm, ady, aval, dtype)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================