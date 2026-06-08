# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L141
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
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
library(lubridate)
library(pharmaRTF)
 
 
source("./ADaM_C1010_L141_data.r")
 
step01 <- adre %>%
 arrange(usubjid,paramcd,avisitn,adt) %>%
 group_by(usubjid,paramcd) %>%
 mutate(
 orig_aval=aval,
 prev_aval=aval,
 next_aval=aval
 ) %>%
 fill(prev_aval,.direction="down") %>%
 fill(next_aval,.direction="up")
 
step02 <- step01 %>%
 mutate(
 aval = if_else(is.na(orig_aval) & !is.na(prev_aval) & !is.na(next_aval),
 round((prev_aval+next_aval)/2,digits=1),aval),
 dtype = if_else(is.na(orig_aval) & !is.na(aval), "INTERPOL","")
 )
 
 
output <- step02 %>%
 select(-prev_aval, -next_aval, -orig_aval)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================