# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1002_L102
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
 
 
source("./ADaM_C1002_L102_data.r")
 
 
adcm01<-cm %>%
 mutate(
 stlen=str_length(cmstdtc),
 astdt=case_when(
 stlen>=10 ~ suppressWarnings(ymd(cmstdtc)),
 stlen==7 ~ suppressWarnings(ymd(str_c(cmstdtc,"-01"))),
 stlen==4 ~ suppressWarnings(ymd(str_c(cmstdtc,"-01-01"))),
 TRUE~NA
 ),
 astdtf=case_when(
 stlen>=10 ~ "",
 stlen==7 ~ "D",
 stlen==4 ~ "M",
 TRUE~""
 )
 )
 
output<-select(adcm01,usubjid,cmstdtc,astdt,astdtf)
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================