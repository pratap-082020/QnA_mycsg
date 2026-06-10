# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L111
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.R")
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
 
 
source("./TASKS_SDTMGEN_L111_data.r")
 
 
 
suppec01<-bind_rows(
 
ec %>% filter(!is.na(ecdosint)) %>%
 mutate(idvar = "ECSEQ",idvarval = as.character(ecseq),qnam = "ECDOSINT",
 qlabel = "Dose interrupted",qval = ecdosint,qorig = "CRF",qeval = "",
 rdomain="EC"),
 
ec %>% filter(!is.na(ecintrs),ecintrs!="") %>%
 mutate(idvar = "ECSEQ",idvarval = as.character(ecseq),qnam = "ECINTRS",
 qlabel = "Reason for dose interruption",qval = ecintrs,qorig = "CRF",
 qeval = "",rdomain="EC"),
 
ec %>% filter(!is.na(ecdosres),ecdosres!="") %>%
 mutate(idvar = "ECSEQ",idvarval = as.character(ecseq),qnam = "ECDOSRES",
 qlabel = "Dose resumed",qval = ecdosres,
 qorig = "CRF",qeval = "",rdomain="EC")
) %>%
 select(studyid,usubjid,rdomain,idvar,idvarval,qnam,qlabel,qval,qorig,qeval)
 
 
suppec<-suppec01 %>%
 arrange(studyid,usubjid,rdomain,idvar,idvarval,qnam)
 
output<-suppec
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================