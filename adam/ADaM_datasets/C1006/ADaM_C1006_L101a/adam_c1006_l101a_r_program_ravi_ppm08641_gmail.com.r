# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1006_L101a
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
 
 
source("./ADaM_C1006_L101a_data.r")
 
#==============================================================================;
#convert sas date values to r date values;
#==============================================================================;
 
adsl01<-adsl %>%
 mutate(trtsdt=as_date(trtsdt,origin='1960-01-01'))
 
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
 paramcd=="STSBP" ~ 1,
 paramcd=="STDBP" ~ 2,
 TRUE~NA
 ),
 aval=vsstresn,
 avisit=case_when(
 visit=="SCREEN 1" ~ "Screening 1",
 visit=="SCREEN 2" ~ "Screening 2",
 TRUE~str_to_sentence(visit)
 ),
 avisitn=case_when(
 visit=="SCREEN 1" ~ -2,
 visit=="SCREEN 2" ~ -1,
 TRUE~visitnum
 ))
#==============================================================================;
#Fetch trtsdt into vs;
#==============================================================================;
vs02<-vs01 %>%
 left_join(adsl01,by="usubjid") %>%
 mutate(tempseq=row_number())
 
 
#==============================================================================;
#baseline related variables;
#==============================================================================;
 
base01<-vs02 %>%
 filter(!is.na(adt),!is.na(trtsdt),!is.na(aval),adt<=trtsdt)
 
base02<-base01 %>%
 arrange(usubjid,paramcd,adt,tempseq) %>%
 group_by(usubjid,paramcd) %>%
 slice(n()) %>%
 mutate(base=aval,ablfl="Y") %>%
 select(usubjid,paramcd,base,tempseq,ablfl)
 
#------------------------------------------------------------------------------;
#populate baseline flag;
#------------------------------------------------------------------------------;
 
vs03<-vs02 %>%
 left_join(select(base02,usubjid,paramcd,ablfl,tempseq), by=c("usubjid","paramcd", "tempseq"))
 
#------------------------------------------------------------------------------;
#Populate base;
#------------------------------------------------------------------------------;
 
vs04<-vs03 %>%
 left_join(select(base02,usubjid,paramcd,base),by=c("usubjid","paramcd"))
 
vs05<-vs04 %>%
 mutate(
 chg=case_when(
 adt>trtsdt ~ aval-base,
 TRUE~NA
 ),
 pchg=case_when(
 !is.na(chg) & !is.na(base) & base !=0 ~ chg/base*100,
 TRUE~NA
 ),
 ablfl=if_else(is.na(ablfl),"",ablfl),
 avisit=if_else(ablfl=="Y","Baseline",avisit,""),
 avisitn=if_else(ablfl=="Y",0,avisitn,NULL),
 )
 
#==============================================================================;
#keep only required vaiables;
#==============================================================================;
 
vs06<-vs05 %>%
 select(usubjid,paramn,paramcd,param,avisitn,avisit,adt,aval,ablfl,base,chg,
 pchg,trtsdt,visitnum,visit) %>%
 arrange(usubjid,paramn,adt)
 
output<-vs06
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================