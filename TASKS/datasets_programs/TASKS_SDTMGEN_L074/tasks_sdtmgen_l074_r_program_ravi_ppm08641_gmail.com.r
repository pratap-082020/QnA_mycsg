# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L074
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.R")
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
 
 
source("./TASKS_SDTMGEN_L074_data.r")
 
 
#==============================================================================;
#RFICDTC;
#==============================================================================;
 
rficdtc<-enrlment %>%
 mutate(rficdtc=format(as.Date(icdt_raw,format="%d/%b/%Y"),format="%Y-%m-%d")) %>%
 select(study,pt,rficdtc)
 
#==============================================================================;
#RANDDTC;
#==============================================================================;
 
randdtc<-enrlment %>%
 mutate(randdtc=format(as.Date(randdt_raw,format="%d/%b/%Y"),format="%Y-%m-%d")) %>%
 select(study,pt,randdtc)
 
#==============================================================================;
#IP admin date in iso 8601 format;
#==============================================================================;
 
ipadmin01<-ipadmin %>%
 mutate(ipstdtc=format(as.Date(ipstdt_raw,format="%d/%b/%Y"),format="%Y-%m-%d")) %>%
 select(study,pt,ipstdtc)
 
#==============================================================================;
#End of study date;
#==============================================================================;
 
eosdtc <- eos %>%
 mutate(
 eosdtc=format(as.Date(eostdt_raw,format="%d/%b/%Y"),format="%Y-%m-%d")
 ) %>%
 select(study,pt,eosdtc)
 
#==============================================================================;
#Earliest exposure date;
#==============================================================================;
 
ipstdtc<-ipadmin01 %>%
 filter(ipstdtc != " ") %>%
 group_by(study,pt) %>%
 arrange(study,pt,ipstdtc) %>%
 slice(1) %>%
 select(study,pt,ipstdtc)
 
#==============================================================================;
#Bring dates together;
#==============================================================================;
 
alldates01<-demog %>%
 left_join(rficdtc,by=c("study","pt")) %>%
 left_join(randdtc,by=c("study","pt")) %>%
 left_join(ipstdtc,by=c("study","pt")) %>%
 left_join(eosdtc,by=c("study","pt"))
 
#==============================================================================;
#Replace NAs with blanks for key variables
#==============================================================================;
 
 
alldates02 <- alldates01 %>%
 mutate(across(c(rficdtc, randdtc, ipstdtc, eosdtc),
 ~ if_else(is.na(.), "",.)))
 
#==============================================================================;
#Dependent variable derivations;
#==============================================================================;
 
dm01<-alldates02 %>%
 mutate(rfendtc=eosdtc,
 rfstdtc=ifelse(ipstdtc!="",ipstdtc,randdtc))
 
 
output<-dm01 %>%
 select(study,pt,rficdtc,rfstdtc,rfendtc)
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================