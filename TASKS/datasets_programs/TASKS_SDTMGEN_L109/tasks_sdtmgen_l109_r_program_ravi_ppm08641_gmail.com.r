# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L109
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
 
 
source("./TASKS_SDTMGEN_L109_data.r")
 
 
#==============================================================================;
#Load the data from cv02;
#==============================================================================;
 
cv03 <- cv02 %>%
 mutate(
 visitnum = folderseq,
 visit = str_to_upper(foldername)
 )
 
#==============================================================================;
#Split into sched01 and unsched01;
#==============================================================================;
 
sched01 <- cv03 %>%
 filter(!str_detect(visit, "UNSCHEDULED"))
 
unsched01 <- cv03 %>%
 filter(str_detect(visit, "UNSCHEDULED"))
 
sv01<-sv %>%
 select(usubjid,visitnum,visit,svstdtc,svendtc)
 
#==============================================================================;
#Join unsched01 with sv based on conditions;
#==============================================================================;
 
unsched02 <- unsched01 %>%
 select(-visitnum,-visit) %>%
 left_join(sv01, by = c("usubjid"),relationship = "many-to-many") %>%
 filter(svstdtc <= cvdtc, cvdtc <= svendtc) %>%
 select(-svstdtc,-svendtc)
 
#==============================================================================;
#Combine sched01 and unsched02 into cv04;
#==============================================================================;
 
cv04 <- bind_rows(sched01, unsched02) %>%
 arrange(studyid, usubjid, cvtestcd, cvdtc)
 
 
output<-cv04
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================