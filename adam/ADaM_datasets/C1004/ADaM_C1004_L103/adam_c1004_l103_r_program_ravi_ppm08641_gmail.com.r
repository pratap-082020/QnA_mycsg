# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1004_L103
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
 
 
source("./ADaM_C1004_L103_data.r")
 
 
vs01<-vs  %>%
 mutate(adt=as_date(vsdtc),
 param=str_c(str_to_sentence(vspos)," ", vstest, " (",vsstresu,")"),
 paramcd=case_when(
 vstestcd=="DIABP" & vspos=="SITTING" ~ "STDBP",
 vstestcd=="SYSBP" & vspos=="SITTING" ~ "STSBP",
 TRUE~""
 ),
 aval=vsstresn)
 
#==============================================================================;
#Create rows for MAP;
#==============================================================================;
 
map01<-vs01 %>% pivot_wider(id_cols=c(usubjid,adt,vsdtc,visitnum,visit),names_from = paramcd, values_from=aval)
 
map02<-map01 %>%
 mutate(aval=ifelse(!is.na(STDBP)&!is.na(STSBP),round((STSBP+STDBP*2)/3,digits=2),NA),
 paramcd="STMAP",
 param="Sitting Mean Arterial Pressure (mmHg)",
 paramtyp="DERIVED") %>%
 select(-STSBP,-STDBP)
 
#==============================================================================;
#append map rows to original rows;
#==============================================================================;
 
vs02<-bind_rows(vs01,map02) %>%
 mutate(paramn = case_when(
 paramcd == "STSBP" ~ 1,
 paramcd == "STDBP" ~ 2,
 paramcd == "STMAP" ~ 3,
 TRUE ~ NA_real_
 )) %>%
 select(usubjid,paramn,paramcd,param,paramtyp,adt,aval,visitnum,visit) %>%
 arrange(usubjid,adt,paramn)
 
output<-vs02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================