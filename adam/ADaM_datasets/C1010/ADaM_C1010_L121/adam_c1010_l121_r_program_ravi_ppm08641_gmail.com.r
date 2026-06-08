# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L121
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
 
 
source("./ADaM_C1010_L121_data.r")
 
wocf01 <- adre %>%
 arrange(usubjid, paramn, avisitn) %>%
 group_by(usubjid, paramn) %>%
 mutate(
 orig_aval = aval,
 temp_aval = if_else(!is.na(aval), aval, Inf),
 minaval = cummin(temp_aval),
 aval = if_else(is.na(aval),minaval,aval),
 dtype = if_else(is.na(orig_aval) & !is.na(aval),"WOCF", "")
 ) %>%
 ungroup()
 
wocf02 <- wocf01 %>%
 select(-temp_aval, -minaval,-orig_aval)
 
output <- wocf02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================