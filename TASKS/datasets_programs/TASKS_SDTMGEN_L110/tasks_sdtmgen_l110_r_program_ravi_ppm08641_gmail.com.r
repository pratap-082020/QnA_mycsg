# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L110
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
 
 
source("./TASKS_SDTMGEN_L110_data.r")
 
 
se01<-se %>%
 mutate(short = case_when(
 epoch == "SCREENING" ~ "SCR",
 epoch == "TREATMENT" ~ "TRT",
 epoch == "FOLLOW-UP" ~ "FU",
 TRUE ~ ""
 )
 )
 
se02<-se01 %>%
 pivot_wider(id_cols=c(usubjid),values_from=c(sestdtc),names_from = c(short))
 
cv01<-cv %>%
 left_join(se02,by=c("usubjid"))
 
cv02<-cv01 %>%
 mutate(epoch=case_when(
 !is.na(cvdtc) & (SCR <= cvdtc) & (cvdtc < TRT) ~ "SCREENING",
 !is.na(cvdtc) & (TRT <= cvdtc) & (cvdtc < FU) ~ "TREATMENT",
 !is.na(cvdtc) & (cvdtc > FU) ~ "FOLLOW-UP"
 ))
 
output <- cv02 %>%
 select(-TRT,-SCR,-FU)
#==============================================================================;
;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================