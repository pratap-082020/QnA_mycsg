# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L071
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
 
 
source("./TASKS_SDTMGEN_L071_data.r")
 
 
#==============================================================================;
#Get randno for each subject;
#==============================================================================;
 
 
dm01<-demog %>%
 left_join(select(enrlment,c("study","pt","randno")),by=c("study","pt"))
 
#==============================================================================;
#Fetch tx_cd as armcd;
#==============================================================================;
 
dm02<-dm01 %>%
 left_join(select(rand,rand_id,tx_cd),by=join_by(randno==rand_id)) %>%
 rename(armcd=tx_cd) %>%
 mutate(armcd=ifelse(is.na(armcd),"",armcd),
 arm=case_when(
 armcd=='PBO'~"Placebo",
 armcd=="ACTIVE"~"Active",
 TRUE~""
 ))
 
output<-dm02 %>%
 select(study,pt,randno,armcd,arm) %>%
 arrange(study,pt)
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================