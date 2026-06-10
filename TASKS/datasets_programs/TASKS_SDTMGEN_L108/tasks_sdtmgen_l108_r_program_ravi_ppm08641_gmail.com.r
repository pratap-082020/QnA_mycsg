# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L108
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
 
 
source("./TASKS_SDTMGEN_L108_data.r")
 
#==============================================================================;
#Create rows from variables;
#==============================================================================;
 
 
cv01 <- bind_rows(
 mutate(echo %>% filter(echo_yn=="Yes"), cvtestcd = "LVEF", cvorres = lvef, ),
 mutate(echo %>% filter(echo_yn=="Yes"), cvtestcd = "RVEF_E", cvorres = rvef, ),
 mutate(echo %>% filter(echo_yn=="No"), cvtestcd = "CVALL", cvorres = "",cvstat="NOT DONE"),
)
 
#==============================================================================;
#Create other common variables;
#==============================================================================;
 
cv02<-cv01 %>%
 mutate(
 cvstresc=cvorres,
 cvorresu=if_else(cvtestcd %in% c("LVEF","RVEF_E") & cvorres !="","%",""),
 cvstat=if_else(cvtestcd %in% c("LVEF","RVEF_E") & cvorres =="","NOT DONE",cvstat),
 cvstresu=cvorresu,
 cvstresn=as.numeric(cvstresc),
 cvdtc=format(as.Date(echodat,format="%d/%b/%Y"),format="%Y-%m-%d")
 )
 
#==============================================================================;
#Keep only required variables;
#==============================================================================;
 
output<-cv02 %>%
 select(c("project","subject","cvtestcd","cvorres","cvorresu","cvstresn","cvstat","cvdtc","foldername")) %>%
 arrange(project,subject,cvtestcd,cvdtc)
 
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================