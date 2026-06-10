# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L075
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
 
 
source("./TASKS_SDTMGEN_L075_data.r")
 
 
#Get death related from eos dataset and convert the date to iso format
 
eos01<-eos %>%
 mutate(dthdtc=format(as.Date(eostdt_raw,format="%d/%b/%Y"),format="%Y-%m-%d"),
 ineos=1) %>%
 filter(str_to_lower(eoterm)=="death") %>%
 select(study,pt,dthdtc,ineos)
 
#bring this information into demog dataset
 
dm01<-demog %>%
 left_join(eos01,by=c("study","pt")) %>%
 mutate(dthdtc=if_else(is.na(dthdtc),"",dthdtc),
 dthfl=if_else(ineos==1,"Y",""))
 
output<-dm01 %>%
 select(study,pt,dthfl,dthdtc)
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================