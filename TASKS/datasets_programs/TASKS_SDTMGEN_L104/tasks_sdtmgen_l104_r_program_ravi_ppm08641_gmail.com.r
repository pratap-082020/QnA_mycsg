# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L104
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

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
 
 
source("./TASKS_SDTMGEN_L104_data.r")
 
 
echo01 <- echo %>%
 left_join(visit_mapping,by = c("folderseq" = "collected_visitnum","foldername" = "collected_visit")
 ) %>%
 arrange(pt,folderseq)
 
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================