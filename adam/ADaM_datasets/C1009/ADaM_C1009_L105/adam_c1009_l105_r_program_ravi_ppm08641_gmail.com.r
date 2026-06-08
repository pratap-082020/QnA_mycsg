# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1009_L105
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
 
 
source("./ADaM_C1009_L105_data.r")
 
library(dplyr)
library(tidyr)
 
 
eg01 <- adeg
 
# Identify the subjects who shifted to abnormal in postbaseline
abnormal_records <- eg01 %>%
 filter(paramcd == "INTP" & adt > trtsdt & avalc == "ABNORMAL" & basec == "NORMAL")
 
abnormal_subjects <- abnormal_records %>%
 select(studyid, usubjid) %>%
 distinct() %>%
 mutate(inabn=1)
 
# Create ANL03FL
eg02 <- eg01 %>%
 left_join(abnormal_subjects, by = c("studyid", "usubjid")) %>%
 mutate(anl03fl = ifelse(inabn==1, "Y", "")) %>%
 select(-inabn)
 
# Keep only required variables
output <- eg02 %>%
 select(studyid, usubjid, paramcd, adt, avalc, ablfl, basec, trtsdt, anl03fl)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================