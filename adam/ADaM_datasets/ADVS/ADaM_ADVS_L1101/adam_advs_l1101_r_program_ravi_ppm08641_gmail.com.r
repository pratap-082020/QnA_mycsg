# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADVS_L1101
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
 
 
source("./ADaM_ADVS_L1101_data.r")
 
 
#==============================================================================;
#Convert SAS dates to R format;
#==============================================================================;
 
adsl<-adsl %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"))
#==============================================================================;
#Get treatment start date into VS;
#==============================================================================;
 
vs01 <- vs %>%
 left_join(adsl %>% select(studyid, usubjid, trtsdt), by = c("studyid", "usubjid")) %>%
 filter(vsstat != "NOT DONE")
 
 
#==============================================================================;
#Create variables which are directly based on input variables;
#==============================================================================;
 
advs01 <- vs01 %>%
 #------------------------------------------------------------------------------;
 #parameter related variables;
 #------------------------------------------------------------------------------;
 mutate(
 paramcd = vstestcd,
 param = case_when(
 paramcd == "SYSBP" ~ "Systolic Blood Pressure (mmHg)",
 paramcd == "DIABP" ~ "Diastolic Blood Pressure (mmHg)",
 paramcd == "HR" ~ "Heart Rate (beats/min)",
 paramcd == "RESP" ~ "Respiratory Rate (breaths/min)",
 paramcd == "TEMP" ~ "Temperature (C)",
 paramcd == "HEIGHT" ~ "Height (cm)",
 paramcd == "WEIGHT" ~ "Weight (kg)",
 TRUE ~ NA
 ),
 paramn = case_when(
 paramcd == "SYSBP" ~ 1,
 paramcd == "DIABP" ~ 2,
 paramcd == "HR" ~ 3,
 paramcd == "RESP" ~ 4,
 paramcd == "TEMP" ~ 5,
 paramcd == "HEIGHT" ~ 6,
 paramcd == "WEIGHT" ~ 7,
 TRUE ~ NA
 ),
 parcat1 = vscat,
 parcat1n = case_when(
 vscat == "VITAL SIGNS" ~ 1,
 vscat == "PHYSICAL MEASUREMENTS" ~ 2,
 TRUE ~ NA
 ),
 
 #------------------------------------------------------------------------------;
 #timing variables;
 #------------------------------------------------------------------------------;
 
 adt = as.Date(vsdtc),
 ady = if_else(!is.na(adt) & !is.na(trtsdt), if_else(adt < trtsdt, adt - trtsdt, adt - trtsdt + 1), NA),
 ady=as.numeric(ady),
 avisitn = if_else(!grepl("unscheduled", visit, ignore.case = TRUE), visitnum, NA),
 avisit = if_else(!grepl("unscheduled", visit, ignore.case = TRUE), visit, ""),
 
 #------------------------------------------------------------------------------;
 #other variables;
 #------------------------------------------------------------------------------;
 
 aval=vsstresn
 )
 
 
#==============================================================================;
#Create baseline flag and dependent variables;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Subset the records with non-missing result which are on or before treatment start
#Create ABLFL variable by assiging a value of "Y" on the latest record identified;
#------------------------------------------------------------------------------;
base01 <- advs01 %>%
 filter(!is.na(adt)  & !is.na(trtsdt) & adt <= trtsdt & !is.na(aval)) %>%
 arrange(usubjid, paramn, adt, visitnum, vsseq)
 
 
base02 <- base01 %>%
 group_by(usubjid, paramn) %>%
 filter(row_number() == n()) %>%
 ungroup() %>%
 select(usubjid, paramn, adt, visitnum, vsseq, base = aval) %>%
 mutate(ablfl = "Y")
 
#------------------------------------------------------------------------------;
#Merge the baseline flag back onto the parent dataset using appropriate by variables
#Assign AVISIT/AVISITN with appropriate values as per specification.;
#------------------------------------------------------------------------------;
 
advs02 <- advs01 %>%
 left_join(base02 %>% select(usubjid, paramn, adt, visitnum, vsseq, ablfl),
 by = c("usubjid", "paramn", "adt", "visitnum", "vsseq"))
 
advs03 <- advs02 %>%
 mutate(avisitn = if_else(ablfl == "Y" & !is.na(ablfl), 0, avisitn),
 avisit = if_else(ablfl == "Y" & !is.na(ablfl), "Baseline", avisit))
 
#------------------------------------------------------------------------------;
#Deriving base, chg, and pchg variables;
#------------------------------------------------------------------------------;
 
advs04 <- left_join(advs03, base02 %>% select(usubjid, paramn, base),
 by = c("usubjid", "paramn"))
 
advs05 <- advs04 %>%
 mutate(anl02fl = if_else(adt > trtsdt & !is.na(trtsdt) & !is.na(adt), "Y", ""),
 chg = if_else(!is.na(aval) & !is.na(base) & base != 0 & adt > trtsdt
 & !is.na(trtsdt) & !is.na(adt), aval - base, NA),
 pchg = if_else(!is.na(chg) & base != 0 & adt > trtsdt
 & !is.na(trtsdt), chg / base * 100, NA))
 
 
#==============================================================================;
#Create anl01fl;
#==============================================================================;
advs05 <- advs05 %>%
 arrange(usubjid, paramcd, avisitn, avisit, desc(adt)) %>%
 group_by(usubjid, paramcd, avisitn, avisit) %>%
 mutate(anl01fl = if_else(row_number() == 1 & !is.na(avisitn), "Y", "")) %>%
 ungroup() %>%
 arrange(usubjid,parcat1n,paramn,adt)
 
#==============================================================================;
#Merge with adsl to fetch other subject level variables;
#==============================================================================;
 
advs06 <- left_join(advs05, adsl, by = c("studyid", "usubjid")) %>%
 rename_all(toupper)
 
 
#==============================================================================;
#keep only required variables;
#==============================================================================;
 
varlist <- c("STUDYID", "USUBJID", "SUBJID", "PARAM", "PARAMCD", "PARAMN",
 "PARCAT1", "PARCAT1N", "AVISIT", "AVISITN", "AVAL", "ADT", "ADY",
 "VSORRESU", "AVAL", "BASE", "CHG", "PCHG", "ABLFL", "ANL01FL",
 "ANL02FL", "EPOCH", "VISITNUM", "VISIT", "VSPOS", "VSORRES",
 "VSSEQ", "SITEID", "AGE", "AGEU", "SEX", "RACE", "SAFFL",
 "RANDFL", "ENRLFL")
 
advs <- advs06 %>% select(all_of(varlist))
 
output <- advs
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================