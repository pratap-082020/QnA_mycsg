# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L101
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.R")
#rmac1-std1
#rmac1-std2
#rmac1-std3
 
rm(list = ls())
 
 
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
 
 
source("./ADaM_C1010_L101_data.r")
 
 
vs01 <- vs %>% arrange(usubjid, paramn, avisitn, adt) %>%
 mutate(orig_aval=aval)
 
 
vs02<-vs01 %>%
 group_by(usubjid,paramn) %>%
 fill(aval, .direction = "down") %>%
 mutate(dtype = if_else(!is.na(aval) & is.na(orig_aval), "LOCF", " "),
 ) %>%
 ungroup()
 
output<-vs02 %>%
 select(-orig_aval)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================