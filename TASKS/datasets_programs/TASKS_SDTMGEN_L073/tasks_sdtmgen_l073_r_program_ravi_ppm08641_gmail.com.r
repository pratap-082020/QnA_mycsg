# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L073
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
 
 
source("./TASKS_SDTMGEN_L073_data.r")
 
#==============================================================================;
#Create ISO date;
#==============================================================================;
 
ip01<-ipadmin %>% mutate(dtn=as.Date(ipstdt_raw,format="%d/%b/%Y"),
 dtc=format(dtn,format="%Y-%m-%d"))
 
#==============================================================================;
#rfxstdtc;
#==============================================================================;
 
rfxstdtc<-ip01 %>%
 filter(as.numeric(ipqty_raw)>0 & dtc != "") %>%
 arrange(study,pt,dtc) %>%
 group_by(study,pt) %>%
 slice(1) %>%
 rename(rfxstdtc=dtc) %>%
 select(study,pt,rfxstdtc)
 
#==============================================================================;
#rfxendtc;
#==============================================================================;
 
 
rfxendtc<-ip01 %>%
 filter(as.numeric(ipqty_raw)>0 & dtc != "") %>%
 arrange(study,pt,dtc) %>%
 group_by(study,pt) %>%
 slice(n()) %>%
 rename(rfxendtc=dtc) %>%
 select(study,pt,rfxendtc)
 
#==============================================================================;
#bring rfxstdtc and rfxendtc into demog dataset;
#==============================================================================;
 
 
dm01<-demog %>%
 left_join(rfxstdtc,by=c("study","pt")) %>%
 left_join(rfxendtc,by=c("study","pt")) %>%
 mutate(rfxstdtc=ifelse(is.na(rfxstdtc),"",rfxstdtc),
 rfxendtc=ifelse(is.na(rfxendtc),"",rfxendtc))
 
 
output<-dm01 %>%
 arrange(study,pt) %>%
 select(study,pt,rfxstdtc,rfxendtc)
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================