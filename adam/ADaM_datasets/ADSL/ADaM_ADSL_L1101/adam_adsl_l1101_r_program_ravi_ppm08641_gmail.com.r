# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADSL_L1101
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
 
 
source("./ADaM_ADSL_L1101_data.r")
 
 
#==============================================================================;
#Merge DM and SUPPDM;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Transponse SUPPDM data such that each QNAM becomes a variable;
#------------------------------------------------------------------------------;
 
suppdm01 <- suppdm %>%
 mutate(qnam=str_to_lower(qnam)) %>%
 group_by(studyid, usubjid) %>%
 pivot_wider(id_cols=c(studyid,usubjid),names_from = qnam, values_from = qval)
 
dm01 <- left_join(dm, suppdm01, by = c("studyid", "usubjid"))
 
#==============================================================================;
#create variables that are directly based on input variables;
#==============================================================================;
 
adsl01 <- dm01 %>%
 #------------------------------------------------------------------------------;
 #Planned and actual treatment values;
 #------------------------------------------------------------------------------;
 
 
 mutate(trt01p = if_else(armcd == "PBO", "Placebo", if_else(armcd == "ACTIVE", "Active", "")),
 trt01a = if_else(actarmcd == "PBO", "Placebo", if_else(actarmcd == "ACTIVE", "Active", "")),
 trt01pn = if_else(armcd == "PBO", 1, if_else(armcd == "ACTIVE", 2, NA)),
 trt01an = if_else(actarmcd == "PBO", 1, if_else(actarmcd == "ACTIVE", 2, NA))) %>%
 
 #------------------------------------------------------------------------------;
 #Date conversions;
 #------------------------------------------------------------------------------;
 
 
 mutate(tr01sdt = as.Date(rfxstdtc),
 tr01edt = as.Date(rfxendtc),
 rficdt = as.Date(rficdtc),
 lstalvdt = as.Date(rfpendtc),
 dthdt = as.Date(dthdtc),
 trtsdt = tr01sdt,
 trtedt = tr01edt) %>%
 #------------------------------------------------------------------------------;
 #Grouping variables;
 #------------------------------------------------------------------------------;
 
 
 mutate(agegr1 = if_else(!is.na(age) & age < 60, "< 60 Years",
 if_else(age >= 60, ">= 60 Years", "")),
 agegr1n = if_else(!is.na(age) & age < 60, 1, if_else(age >= 60, 2,NA)))
 
 
 
#==============================================================================;
#Process disposition data for treatment and study status;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Enrollment;
#------------------------------------------------------------------------------;
 
enrl01 <- ds %>%
 filter(dsterm == "ENROLLED") %>%
 mutate(enrldt = as.Date(dsstdtc)) %>%
 select(studyid, usubjid, enrldt)
 
#------------------------------------------------------------------------------;
#Randomization;
#------------------------------------------------------------------------------;
 
rand01 <- ds %>%
 filter(dsterm == "RANDOMIZED") %>%
 mutate(randdt = as.Date(dsstdtc)) %>%
 select(studyid, usubjid, randdt)
 
 
#------------------------------------------------------------------------------;
#End of treatment;
#------------------------------------------------------------------------------;
eot01 <- ds %>%
 filter(dsscat == "END OF TREATMENT") %>%
 mutate(
 eotstt = case_when(
 dsdecod == "COMPLETED" ~ "COMPLETED",
 dsdecod != "" ~ "DISCONTINUED",
 TRUE ~ NA
 ),
 dctreas = if_else(dsdecod != "COMPLETED", dsdecod, NA),
 ineot = 1
 ) %>%
 select(studyid, usubjid, eotstt, dctreas, ineot)
 
#------------------------------------------------------------------------------;
#End of study;
#------------------------------------------------------------------------------;
 
eos01 <- ds %>%
 filter(dsscat == "END OF STUDY") %>%
 mutate(
 eosstt = case_when(
 dsdecod == "COMPLETED" ~ "COMPLETED",
 dsdecod != "" ~ "DISCONTINUED",
 TRUE ~ NA
 ),
 dcsreas = if_else(dsdecod != "COMPLETED", dsdecod, NA),
 eosdt = as.Date(dsstdtc),
 ineos = 1
 ) %>%
 select(studyid, usubjid, eosstt, dcsreas, eosdt, ineos)
 
#==============================================================================;
#Baseline variables from vital signs;
#==============================================================================;
heightbl <- vs %>%
 filter(vsblfl == "Y" & vstestcd == "HEIGHT") %>%
 select(studyid, usubjid, vsstresn) %>%
 rename(heightbl = vsstresn)
 
weightbl <- vs %>%
 filter(vsblfl == "Y" & vstestcd == "WEIGHT") %>%
 select(studyid, usubjid, vsstresn) %>%
 rename(weightbl = vsstresn)
 
 
#==============================================================================;
#Bring disposition and vital signs related info into parent dataset;
#==============================================================================;
 
library(purrr)
 
data_frames <- list(adsl01, eot01, eos01, enrl01, rand01, heightbl, weightbl)
 
adsl02 <- reduce(data_frames, left_join, by = c("studyid", "usubjid"))
 
#==============================================================================;
#create variables/assign values to existing variables which are dependent on
#other variables;
#==============================================================================;
 
adsl03 <- adsl02 %>%
 mutate(
 saffl = if_else(!is.na(trtsdt), "Y", "N"),
 randfl = if_else(!is.na(randdt), "Y", "N"),
 enrlfl = if_else(!is.na(enrldt), "Y", "N"),
 complfl = if_else(eosstt == "COMPLETED", "Y", "N", "N"),
 eotstt = if_else((eotstt == "" | is.na(eotstt))  & is.na(ineot) & saffl == "Y", "ONGOING", eotstt),
 eosstt = if_else((eosstt == "" | is.na(eosstt)) & is.na(ineos) & saffl == "Y", "ONGOING", eosstt),
 trtdurd = if_else(!is.na(trtsdt) & !is.na(trtedt), trtedt - trtsdt + 1, NA),
 trtdurd = as.numeric(trtdurd)
 )
 
adsl03 <- adsl03 %>%
 mutate(across(where(is.character), ~if_else(is.na(.), "", .)))
 
#==============================================================================;
#Keep only required variables;
#==============================================================================;
 
varlist <- c("STUDYID", "USUBJID", "SUBJID", "SITEID", "AGE", "AGEU", "AGEGR1", "AGEGR1N", "SEX", "RACE", "RACE1", "RACE2", "RACESP", "SAFFL", "COMPLFL", "RANDFL", "ENRLFL", "ARM", "ACTARM", "TRT01P", "TRT01PN", "TRT01A", "TRT01AN", "TRTSDT", "TRTEDT", "TR01SDT", "TR01EDT", "EOSSTT", "EOSDT", "DCSREAS", "EOTSTT", "DCTREAS", "RFICDT", "ENRLDT", "RANDDT", "LSTALVDT", "TRTDURD", "DTHDT", "HEIGHTBL", "WEIGHTBL")
 
adsl <- adsl03 %>%
 rename_all(toupper) %>%
 select(all_of(varlist))
 
output<-adsl
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================