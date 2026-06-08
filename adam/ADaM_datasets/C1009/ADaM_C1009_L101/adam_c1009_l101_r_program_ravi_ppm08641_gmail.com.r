# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1009_L101
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
 
 
source("./ADaM_C1009_L101_data.r")
 
 
 
#==============================================================================;
#Derive AWTDIFF;
#==============================================================================;
 
advs01<-advs %>%
 mutate(
 awtdiff=if_else(!is.na(ady)&!is.na(awtarget),abs(ady-awtarget),NA),
 adt=as_date(adt,origin='1960-01-01'),
 tempseq=row_number()
 )
 
#==============================================================================;
#Filter the required record and use the tempseq on that record to populate anl01fl
#==============================================================================;
 
 
#------------------------------------------------------------------------------;
#Identify the record;
#------------------------------------------------------------------------------;
 
req01<-advs01 %>%
 filter(!is.na(avisitn)) %>%
 arrange(usubjid,paramcd,avisitn,awtdiff,ady) %>%
 group_by(usubjid,paramcd,avisitn) %>%
 slice(1) %>%
 select(usubjid,paramcd,avisitn,tempseq) %>%
 mutate(anl01fl="Y")
 
#------------------------------------------------------------------------------;
#Populate the flag on the selected record;
#------------------------------------------------------------------------------;
 
advs02<-advs01 %>%
 left_join(req01,by=c("usubjid","paramcd","avisitn","tempseq")) %>%
 arrange(usubjid,paramn,adt,avisitn) %>%
 select(-tempseq) %>%
 mutate(anl01fl=if_else(is.na(anl01fl),"",anl01fl))
 
output<-advs02 %>%
 arrange(usubjid,paramn,adt)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================