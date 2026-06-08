# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L111
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
 
 
source("./ADaM_C1010_L111_data.r")
 
vs01<-vs %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"),
 adt=as.Date(adt,origin="1960-01-01"))
#separate baseline record
 
baseline <- vs01 %>%
 filter(avisitn == 0) %>%
 select(usubjid, paramn, tempaval = aval)
 
# Merge vs01 and baseline datasets
vs02 <- vs01 %>%
 left_join(baseline, by = c("usubjid", "paramn")) %>%
 mutate(
 dtype = ifelse(is.na(aval) & avisitn > 0 & !is.na(tempaval), "BLOCF", ""),
 aval = ifelse(is.na(aval) & avisitn > 0, tempaval, aval)
 ) %>%
 select(-tempaval)
 
output<-vs02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================