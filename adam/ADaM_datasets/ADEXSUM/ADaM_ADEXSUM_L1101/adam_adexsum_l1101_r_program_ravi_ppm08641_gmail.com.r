# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADEXSUM_L1101
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
 
rm()
 
source("./ADaM_ADEXSUM_L1101_data.r")
 
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Convert dates to numeric format and calculate duration;
#------------------------------------------------------------------------------;
 
ec01 <- ec %>%
 mutate(ecstdt = as.Date(ecstdtc),
 ecendt = as.Date(ecendtc),
 dur = ifelse(!is.na(ecstdt) & !is.na(ecendt), as.numeric(ecendt - ecstdt + 1), NA))
 
#==============================================================================;
#Create dataset to Combine start and end dates into a single variable;
#this will be used in downstream processing for different parameters;
#==============================================================================;
proc01 <- bind_rows(
 rename(ec01, date = ecstdt),
 rename(ec01, date = ecendt)
)
 
#==============================================================================;
#Create a record for each subject present in EC - this will be used as a
#template in downstream processing;
#==============================================================================;
 
template01 <- ec01 %>%
 distinct(studyid, usubjid)
 
#==============================================================================;
#Create parameter - TRTDURD;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Get the earliest and latest dates;
#------------------------------------------------------------------------------;
trtdurd01 <- proc01 %>%
 arrange(studyid, usubjid, date) %>%
 filter(ecoccur == "Y" & !is.na(date))
 
trtdurd_first <- trtdurd01 %>%
 group_by(studyid, usubjid) %>%
 slice(1) %>%
 rename(start = date) %>%
 ungroup() %>%
 select(studyid, usubjid, start)
 
trtdurd_last <- trtdurd01 %>%
 group_by(studyid, usubjid) %>%
 slice(n()) %>%
 rename(end = date) %>%
 ungroup() %>%
 select(studyid, usubjid, end)
 
#------------------------------------------------------------------------------;
#Bring first and last date into a single dataset and calculate duration;
#------------------------------------------------------------------------------;
trtdurd <- merge(trtdurd_first, trtdurd_last, by = c("studyid", "usubjid")) %>%
 mutate(aval = end - start + 1,
 aval = as.numeric(aval),
 paramcd = "TRTDURD") %>%
 select(studyid, usubjid, paramcd, aval)
 
#==============================================================================;
#Create parameter - NADMIN;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Sum of duration per subject where ecoccur='Y';
#------------------------------------------------------------------------------;
nadmin01 <- ec01 %>%
 filter(ecoccur == "Y") %>%
 group_by(studyid, usubjid) %>%
 summarise(sumdur = sum(dur)) %>%
 ungroup() %>%
 select(studyid, usubjid, sumdur)
 
nadmin <- nadmin01 %>%
 mutate(paramcd = "NADMIN",
 aval = sumdur) %>%
 select(studyid, usubjid, paramcd, aval)
 
#==============================================================================;
#Create parameter - TOTPLDOS;
#==============================================================================;
 
totpldos <- template01 %>%
 mutate(aval = 1500,
 paramcd = "TOTPLDOS") %>%
 select(studyid, usubjid, paramcd, aval)
 
#==============================================================================;
#Create parameter - TOTACDOS;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#use NADMIN dataset;
#------------------------------------------------------------------------------;
totacdos <- nadmin %>%
 rename(ndoses = aval) %>%
 mutate(paramcd = "TOTACDOS") %>%
 mutate(aval = if_else(!is.na(ndoses), ndoses * 100, NA)) %>%
 select(studyid, usubjid, paramcd, aval)
 
#==============================================================================;
#Create parameter - NMISSDOS;
#==============================================================================;
 
 
#------------------------------------------------------------------------------;
#Sum of duration per subject where ecoccur='N';
#------------------------------------------------------------------------------;
nmissdos01 <- ec01 %>%
 filter(ecoccur == "N") %>%
 group_by(studyid, usubjid) %>%
 summarise(sumdur = sum(dur)) %>%
 ungroup()
 
#------------------------------------------------------------------------------;
#Merge with template - to get a row for all subjects and populate 0 when no doses
#missed;
#------------------------------------------------------------------------------;
 
nmissdos02 <- nmissdos01 %>%
 full_join(template01, by = c("studyid", "usubjid")) %>%
 mutate(sumdur = if_else(is.na(sumdur), 0, sumdur))
 
nmissdos <- nmissdos02 %>%
 mutate(aval = sumdur,
 paramcd = "NMISSDOS") %>%
 select(studyid, usubjid, paramcd, aval)
 
#==============================================================================;
#Create parameter - RDOSINT;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Combine TOTACDOS and TOTPLDOS datasets such tha planned and actual doses
#appear side by side;
#------------------------------------------------------------------------------;
rdosint01 <- totacdos %>%
 select(studyid, usubjid, aval) %>%
 rename(actual = aval) %>%
 full_join(totpldos %>% rename(planned=aval) %>%
 select(studyid, usubjid, planned), by = c("studyid", "usubjid"))
 
rdosint <- rdosint01 %>%
 mutate(
 paramcd = "RDOSINT",
 aval = if_else(!is.na(planned) & !is.na(actual), round(actual / planned * 100, 2), NA_real_)
 ) %>%
 select(studyid, usubjid, paramcd, aval)
#==============================================================================;
#Combine the data for all parameters and create dependent variables;
#==============================================================================;
allparams01 <- bind_rows(trtdurd, nadmin, totpldos, totacdos, nmissdos, rdosint) %>%
 mutate(
 paramn = case_when(
 paramcd == "TRTDURD" ~ 1,
 paramcd == "NADMIN" ~ 2,
 paramcd == "TOTPLDOS" ~ 3,
 paramcd == "TOTACDOS" ~ 4,
 paramcd == "NMISSDOS" ~ 5,
 paramcd == "RDOSINT" ~ 6,
 TRUE ~ NA_real_
 ),
 param = case_when(
 paramcd == "TRTDURD" ~ "Treatment Duration in days",
 paramcd == "NADMIN" ~ "Nr of Actual Study Drug Administrations",
 paramcd == "TOTPLDOS" ~ "Total Planned Dose (mg)",
 paramcd == "TOTACDOS" ~ "Total Actual Dose (mg)",
 paramcd == "NMISSDOS" ~ "Number of missed doses",
 paramcd == "RDOSINT" ~ "Relative Dose Intensity (%)",
 TRUE ~ NA_character_
 )
 ) %>% rename_all(toupper)
 
#==============================================================================;
#Keep required variables and sort as per requirement;
#==============================================================================;
varlist <- c("STUDYID", "USUBJID", "PARAM", "PARAMCD", "PARAMN", "AVAL")
 
adexsum <- allparams01 %>%
 select(all_of(varlist)) %>%
 arrange(STUDYID, USUBJID, PARAMN)
 
output <- adexsum
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================