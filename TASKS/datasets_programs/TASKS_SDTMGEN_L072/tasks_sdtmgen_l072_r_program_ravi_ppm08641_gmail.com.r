# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L072
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
 
 
source("./TASKS_SDTMGEN_L072_data.r")
 
#==============================================================================;
##Get the first box id from which a dose is consumed;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Convert the raw date value to iso format;
#------------------------------------------------------------------------------;
 
ip01<-ipadmin %>% mutate(dtn=as.Date(ipstdt_raw,format="%d/%b/%Y"),
 dtc=format(dtn,format="%Y-%m-%d"))
 
#------------------------------------------------------------------------------;
#Get the first box id;
#------------------------------------------------------------------------------;
 
ip02<-ip01 %>%
 filter(as.numeric(ipqty_raw)>0) %>%
 arrange(study,pt,dtc) %>%
 group_by(study,pt) %>%
 slice(1) %>%
 select(study,pt,ipboxid)
 
#==============================================================================;
#fetch the box contents of the above boxids;
#==============================================================================;
 
 
ip03<-ip02 %>%
 left_join(box,by=join_by(ipboxid==kitid))
 
#==============================================================================;
#bring this info into demog and create actarm and actarmcd variables;
#==============================================================================;
 
dm01<-demog %>%
 left_join(ip03,by=c("study","pt")) %>%
 mutate(actarmcd=ifelse(is.na(content),"",content),
 actarm=case_when(
 actarmcd=="PBO" ~ "Placebo",
 actarmcd=="ACTIVE" ~ "Active",
 TRUE ~ ""
 ))
 
output <- dm01 %>%
 arrange(study,pt) %>%
 select(study,pt,ipboxid,actarmcd,actarm)
 
 
 
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================