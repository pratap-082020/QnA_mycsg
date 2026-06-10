# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L201
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

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
 
 
source("./TASKS_SDTMGEN_L201_data.r")
 
 
suppec01<-suppec %>%
 pivot_wider(id_cols=c(usubjid,idvarval),values_from = c(qval), names_from = qnam,values_fill=NULL) %>%
 mutate(ecseq=as.numeric(idvarval)) %>%
 select(-idvarval)
 
ec01<-ec %>%
 left_join(suppec01,by=c("usubjid","ecseq"))
 
 
output<-ec01
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================