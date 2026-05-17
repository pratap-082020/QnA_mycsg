# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TV_LCSG801
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
 
 
# source("./SDTM_TV_LCSG801_data.r")
 
tv <- tibble(
 STUDYID = rep("CSG801", 9),
 DOMAIN = rep("TV", 9),
 VISITNUM = 1:9,
 VISIT = c("Visit 1", "Visit 2", "Visit 2", "Visit 4", "Visit 5",
 "Visit 6", "Visit 7", "Visit 8", "Visit 9"),
 VISITDY = c(-14, 1, 15, 29, 43, 57, 71, 85, 106),
 ARMCD = rep("", 9),
 ARM = rep("", 9),
 TVSTRL = c("Start of screening epoch", "Start of treatment epoch", "2 Weeks after start of treatment",
 "4 Weeks after start of treatment", "6 Weeks after start of treatment",
 "8 Weeks after start of treatment", "10 Weeks after start of treatment",
 "12 Weeks after start of treatment", "3 Weeks after end of treatment"),
 TVENRL = c("End of all screening procedures",rep("", 8))
)
 
output <- tv
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================