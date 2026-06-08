# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1013_L103
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
 
 
source("./ADaM_C1013_L103_data.r")
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
adsl01 <- adsl %>%
 filter(saffl == "Y")%>%
 mutate(
 across(c(trtsdt, eosdt, dthdt), ~ as.Date(., origin = "1960-01-01"))
 )
 
#==============================================================================;
#Create records for T2DEATH;
#==============================================================================;
 
tte01 <- adsl01 %>%
 mutate(
 paramcd = "T2DEATH",
 param = "Time to Death (Days)",
 startdt = trtsdt,
 evntdesc = if_else(!is.na(dthdt), "Death", dcsreas),
 cnsr = if_else(!is.na(dthdt), 0,
 if_else(dcsreas == "Completed the study", 1,
 if_else(dcsreas == "Adverse Event", 2,
 if_else(dcsreas == "Lost to follow-up", 3,
 if_else(dcsreas != "", 4, NA))))
 ),
 adt = if_else(!is.na(dthdt), dthdt, eosdt),
 aval = if_else(!is.na(startdt) & !is.na(adt), adt - startdt + 1, NA),
 aval=as.numeric(aval)
 )
 
#==============================================================================;
#Keep only required variables;
#==============================================================================;
 
tte02 <- tte01 %>%
 select(studyid, usubjid, paramcd, param, aval, startdt, adt, cnsr,
 evntdesc, saffl)
 
output <- tte02
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================