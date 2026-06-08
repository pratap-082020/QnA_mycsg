# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1013_L101
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
 
 
source("./ADaM_C1013_L101_data.r")
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(saffl=="Y") %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"),
 trtedt=as.Date(trtedt,origin="1960-01-01"))
 
cm01<-cm %>%
 mutate(cmstdt=as.Date(cmstdtc))
 
#==============================================================================;
#Keep only the subjects which are present in adsl in cm dataset;
#==============================================================================;
 
cm02<-cm01 %>%
 inner_join(adsl01,by=c("usubjid"))
 
#==============================================================================;
#Get the earliest rescue medication start date after treatment start;
#==============================================================================;
 
resmed01<-cm02 %>%
 filter(str_to_lower(cmdecod)=="insulin")
 
resmed02<-resmed01 %>%
 arrange(usubjid,cmstdt) %>%
 group_by(usubjid) %>%
 slice(1) %>%
 ungroup() %>%
 mutate(resmeddt=cmstdt) %>%
 select(usubjid,resmeddt)
 
 
#==============================================================================;
#Get rescue medication start date into adsl;
#==============================================================================;
 
adsl02<-adsl01 %>%
 left_join(resmed02,by=c("usubjid"))
 
 
 
#==============================================================================;
#Create PARAMCD,PARAM,STARTDT,ADT,AVAL and CNSR Variables;
#==============================================================================;
 
t2resmed<-adsl02 %>%
 mutate(paramcd="T2RESMED",
 param="Time to first Rescue Medication",
 startdt=trtsdt,
 adt = if_else(!is.na(resmeddt), resmeddt, trtedt),
 cnsr = if_else(!is.na(resmeddt), 0, 1),
 aval = if_else(!is.na(startdt) & !is.na(adt), adt - startdt + 1, NA),
 aval = as.numeric(aval)
 )
#==============================================================================;
#Keep only required variables and order the variables in a logical sequence;
#==============================================================================;
 
output<-t2resmed %>%
 select(usubjid,paramcd,param,startdt,adt,aval,cnsr,trtsdt,trtedt)
 
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================