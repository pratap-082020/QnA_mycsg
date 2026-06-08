# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1012_L102
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
 
 
source("./ADaM_C1012_L102_data.r")
 
 
#==============================================================================;
#Read input dataset;
#==============================================================================;
 
 
lb01 <- adlb
 
#==============================================================================;
#Create shift1 variable;
#==============================================================================;
 
 
lb02 <- lb01 %>%
 mutate(shift2 = ifelse(avisitn > 0 & atoxgrn != "" & btoxgrn != "",
 paste0(btoxgrn, " to ", atoxgrn), ""))
 
output <- lb02
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================