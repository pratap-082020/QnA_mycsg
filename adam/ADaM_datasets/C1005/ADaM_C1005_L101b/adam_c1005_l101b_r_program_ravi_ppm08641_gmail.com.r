# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1005_L101b
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
 
 
source("./ADaM_C1005_L101b_data.r")
 
#==============================================================================;
#Variables which need direct mapping and basic transformations;
#==============================================================================;
vs01<-vs  %>%
 mutate(adt=as_date(vsdtc),
 param=str_c(str_to_sentence(vspos)," ", vstest, " (",vsstresu,")"),
 paramcd=case_when(
 vstestcd=="DIABP" & vspos=="SITTING" ~ "STDBP",
 vstestcd=="SYSBP" & vspos=="SITTING" ~ "STSBP",
 TRUE~""
 ),
 paramn=case_when(
 paramcd=="STSBP"~1,
 paramcd=="STDBP"~2,
 TRUE~NA
 ),
 aval=vsstresn,
 avisit=case_when(
 visit=="SCREEN" ~ "Screening",
 TRUE~str_to_sentence(visit)
 ),
 avisitn=visitnum)
#==============================================================================;
#derived records;
#==============================================================================;
 
vs02<-vs01 %>%
 left_join(dm,by="usubjid") %>%
 mutate(trtsdt=as_date(rfstdtc))
 
postbase01<-vs02 %>%
 filter(!is.na(adt), !is.na(trtsdt), !is.na(aval), adt>trtsdt)
 
#------------------------------------------------------------------------------;
#minimum postbaseline;
#------------------------------------------------------------------------------;
 
min01<-postbase01  %>%
 arrange(usubjid,paramcd,aval,adt) %>%
 group_by(usubjid,paramcd) %>%
 slice(1) %>%
 mutate(avisitn=98,
 avisit="Minimum value postbaseline",
 dtype="MINIMUM")
#------------------------------------------------------------------------------;
#maximum postbaseline;
#------------------------------------------------------------------------------;
 
max01<-postbase01  %>%
 arrange(usubjid,paramcd,aval,desc(adt)) %>%
 group_by(usubjid,paramcd) %>%
 slice(n()) %>%
 mutate(avisitn=99,
 avisit="Maximum value postbaseline",
 dtype="MAXIMUM")
 
 
#==============================================================================;
#Append min and max records to parent records;
#==============================================================================;
 
vs03<-bind_rows(vs02,min01,max01) %>%
 arrange(usubjid,paramn,avisitn,adt) %>%
 select(usubjid,paramn,paramcd,param,avisitn,avisit,adt,aval,dtype)
 
output<-vs03
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================