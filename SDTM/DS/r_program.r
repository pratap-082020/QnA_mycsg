# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_DS_LCSG001
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

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
 
 
source("./SDTM_DS_LCSG001_data.r")
 
 
#==============================================================================;
#Create rows for protocol milestones from enrlment dataset;
#==============================================================================;
 
library(dplyr)
 
protmil01 <- bind_rows(
 enrlment %>% filter(!is.na(icdt_raw), icdt_raw!="") %>%
 mutate(
 studyid = study,
 usubjid = paste(study, pt, sep = "-"),
 dsstdtc = if_else(!is.na(icdt_raw), format(as.Date(icdt_raw, format = "%d/%b/%Y"), "%Y-%m-%d"), ""),
 dsterm = if_else(!is.na(icdt_raw), "INFORMED CONSENT OBTAINED", ""),
 dsdecod = if_else(!is.na(icdt_raw), dsterm, ""),
 dscat = if_else(!is.na(icdt_raw), "PROTOCOL MILESTONE", ""),
 protvers = if_else(!is.na(icdt_raw), prtvers, ""),
 cnstvers = if_else(!is.na(icdt_raw), icvers, "")
 ),
 enrlment %>% filter(!is.na(enrldt_raw), enrldt_raw!="") %>%
 mutate(
 studyid = study,
 usubjid = paste(study, pt, sep = "-"),
 dsstdtc = if_else(!is.na(enrldt_raw), format(as.Date(enrldt_raw, format = "%d/%b/%Y"), "%Y-%m-%d"), ""),
 dsterm = if_else(!is.na(enrldt_raw), "ENROLLED", ""),
 dsdecod = if_else(!is.na(enrldt_raw), "ELIGIBILITY CRITERIA MET", ""),
 dscat = if_else(!is.na(enrldt_raw), "PROTOCOL MILESTONE", "")
 ),
 enrlment %>% filter(!is.na(randdt_raw), randdt_raw!="") %>%
 mutate(
 studyid = study,
 usubjid = paste(study, pt, sep = "-"),
 dsstdtc = if_else(!is.na(randdt_raw), format(as.Date(randdt_raw, format = "%d/%b/%Y"), "%Y-%m-%d"), ""),
 dsterm = if_else(!is.na(randdt_raw), "RANDOMIZED", ""),
 dsdecod = if_else(!is.na(randdt_raw), "RANDOMIZED", ""),
 dscat = if_else(!is.na(randdt_raw), "PROTOCOL MILESTONE", ""),
 dsrefid = if_else(!is.na(randdt_raw), randno, "")
 )
)
 
#==============================================================================;
#Create disposition event for treatment;
#==============================================================================;
 
dispevnt01 <- eoip %>%
 filter(!is.na(eostdt_raw),eostdt_raw!="") %>%
 mutate(
 studyid = study,
 usubjid = paste(study, pt, sep = "-"),
 dsstdtc = format(as.Date(eostdt_raw, format = "%d/%b/%Y"), "%Y-%m-%d"),
 dsterm = eoterm,
 dsdecod = toupper(dsterm),
 dscat = "DISPOSITION EVENT",
 dsscat = "END OF INVESTIGATIONAL PRODUCT"
 ) %>%
 select(studyid, usubjid, dsstdtc, dscat, dsscat, dsdecod, dsterm)
 
#==============================================================================;
#Create disposition event for study;
#==============================================================================;
 
 
dispevnt02 <- eos %>%
 filter(!is.na(eostdt_raw), eostdt_raw != "") %>%
 mutate(
 studyid = study,
 usubjid = paste(study, pt, sep = "-"),
 dsstdtc = format(as.Date(eostdt_raw, format = "%d/%b/%Y"), "%Y-%m-%d"),
 dsterm = eoterm,
 dsdecod = toupper(eoterm),
 dscat = "DISPOSITION EVENT",
 dsscat = "END OF STUDY"
 ) %>%
 select(studyid, usubjid, dsstdtc, dscat, dsscat, dsdecod, dsterm)
 
#==============================================================================;
#Combine protocol milestones and disposition events;
#==============================================================================;
 
 
ds01<-bind_rows(protmil01,dispevnt01,dispevnt02) %>%
 mutate(domain="DS")
 
#==============================================================================;
#Create study day;
#==============================================================================;
 
ds02 <- left_join(ds01, select(dm,usubjid,rfstdtc) , by = "usubjid") %>%
 filter(!is.na(usubjid) & !is.na(rfstdtc)) %>%
 mutate(
 rfstdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"),
 dsstdt = as.Date(substr(dsstdtc, 1, 10), format = "%Y-%m-%d"),
 dsstdy = if_else(!is.na(dsstdt) & !is.na(rfstdt), dsstdt - rfstdt + (dsstdt >= rfstdt), NA),
 dsstdy = as.numeric(dsstdy)
 )
 
#==============================================================================;
#Create seq variable;
#==============================================================================;
 
ds03 <- ds02 %>%
 arrange(usubjid, dsstdt) %>%
 group_by(usubjid) %>%
 mutate(dsseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
#==============================================================================;
#Keep only required variables;
#==============================================================================;
 
keepvars <- c("STUDYID", "DOMAIN", "USUBJID", "DSSEQ", "DSREFID", "DSTERM", "DSDECOD",
 "DSCAT", "DSSCAT", "DSSTDTC", "DSSTDY", "PROTVERS", "CNSTVERS")
 
ds04 <- ds03 %>%
 select(all_of(keepvars))
 
output<-ds04;
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================