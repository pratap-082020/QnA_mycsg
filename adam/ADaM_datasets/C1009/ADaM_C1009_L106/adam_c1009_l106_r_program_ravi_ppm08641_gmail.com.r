# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1009_L106
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
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
library(lubridate)
library(pharmaRTF)
 
 
source("./ADaM_C1009_L106_data.r")
 
 
lb01 <- adlb
 
# Identify the worst record for ANL04FL
anl04_1 <- lb01 %>%
 filter(atoxgrl != "" & avisitn > 1) %>%
 arrange(studyid, usubjid, paramcd, atoxgrl, desc(avisitn))
 
anl04_2 <- anl04_1 %>%
 group_by(studyid, usubjid, paramcd) %>%
 slice(n())   # Get the last record in each group
 
 
anl04_3 <- anl04_2 %>%
 select(studyid, usubjid, paramcd, avisitn) %>%
 mutate(inanl04=1)
 
# Identify the worst record for ANL05FL
anl05_1 <- lb01 %>%
 filter(atoxgrh != "" & avisitn > 1) %>%
 arrange(studyid, usubjid, paramcd, atoxgrh, desc(avisitn))
 
anl05_2 <- anl05_1 %>%
 group_by(studyid, usubjid, paramcd) %>%
 slice(n())  # Get the last record in each group
 
anl05_3 <- anl05_2 %>%
 select(studyid, usubjid, paramcd, avisitn)%>%
 mutate(inanl05=1)
 
# Using the key variables identified for anl04fl and anl05fl populate the flags
lb02 <- lb01 %>%
 left_join(anl04_3, by = c("studyid", "usubjid", "paramcd", "avisitn")) %>%
 left_join(anl05_3, by = c("studyid", "usubjid", "paramcd", "avisitn")) %>%
 mutate(
 anl04fl = ifelse(inanl04==1, "Y", ""),
 anl05fl = ifelse(inanl05==1, "Y", "")
 )
 
output<-lb02 %>%
 select(-inanl04,-inanl05) %>%
 arrange(studyid,usubjid,paramcd,avisitn)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================