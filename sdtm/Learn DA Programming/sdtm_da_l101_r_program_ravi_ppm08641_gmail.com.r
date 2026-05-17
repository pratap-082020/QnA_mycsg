# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_DA_L101
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
 
 
source("./SDTM_DA_L101_data.r")
 
 
 
#==============================================================================;
#Create required variables in domain;
#==============================================================================;
 
domain01<-bind_rows(
 mutate(drugacc,datestcd="DISPAMT",daorres=dispamt,daorresu=dispamtu,
 dastat=if_else(dispamt=="","NOT DONE",""),rawdate=dispamt_dadat),
 mutate(drugacc,datestcd="RETAMT",daorres=retamt,daorresu=retamtu,
 dastat=if_else(retamt=="","NOT DONE",""),rawdate=retamt_dadat)
 
) %>%
 mutate(
 studyid = "MYCSG",
 domain = "DA",
 usubjid = paste(studyid, subject, sep = "-"),
 daspid = str_pad(recordposition,width=3,pad="0"),
 darefid = refid,
 dadtc = ifelse(rawdate != "", format(as.Date(rawdate, format = "%d/%b/%Y"), "%Y-%m-%d"), ""),
 visitnum = folderseq,
 visit = foldername,
 dastresc=daorres,
 dastresu=daorresu,
 dastresn=suppressWarnings(as.numeric(daorres))
 )
 
#==============================================================================;
#Fetch RFSTDTC into parent data ;
#==============================================================================;
 
domain02<-domain01 %>%
 left_join(select(dm,usubjid,rfstdtc),by=c("usubjid"))
 
#==============================================================================;
#Derive other dependent variables;
#==============================================================================;
 
domain03 <- domain02 %>%
 mutate(datest = case_when(
 datestcd == "DISPAMT" ~ "Dispensed Amount",
 datestcd == "RETAMT" ~ "Returned Amount",
 TRUE ~ ""
 ),
 dadt = as.Date(dadtc, format = "%Y-%m-%d"),
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 dady = ifelse(!is.na(dadt) & !is.na(rfstdt), dadt - rfstdt + (dadt >= rfstdt), NA),
 )
 
#==============================================================================;
#Create EPOCH variable;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Process SE dataset such that start and end dates of all epochs are present
#side by side;
#------------------------------------------------------------------------------;
 
se02 <- se %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1)))
 
epochstart <- se02 %>%
 pivot_wider(id_cols=c("studyid","usubjid"),names_from = short, values_from = sestdtc, names_prefix = "s")
 
epochend <- se02 %>%
 pivot_wider(id_cols=c("studyid","usubjid"),names_from = short, values_from = seendtc, names_prefix = "e")
 
epochdates <- left_join(epochstart, epochend, by = c("studyid", "usubjid"))
 
#------------------------------------------------------------------------------;
#Compare date and assign epoch;
#------------------------------------------------------------------------------;
 
domain04 <- merge(domain03, epochdates, by = c("studyid", "usubjid"))
 
domain05 <- domain04 %>%
 mutate(
 ymd = dadtc,
 epoch = case_when(
 ("" < ss & ss <= ymd & ymd < es) | (st == "" & "" < ss & ss <= ymd & ymd <= es) ~ "SCREENING",
 "" < st & st <= ymd & ymd <= et ~ "TREATMENT",
 "" < sf & sf <= ymd & ymd <= ef ~ "FOLLOW-UP",
 TRUE ~ ""
 )
 )
 
 
#==============================================================================;
#Create --SEQ variable;
#==============================================================================;
 
domain06 <- domain05 %>%
 arrange(studyid, usubjid, darefid, datestcd, dadtc) %>%
 group_by(studyid, usubjid) %>%
 mutate(daseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
#==============================================================================;
#keep only required variables ;
#==============================================================================;
davarlist <- c("STUDYID", "DOMAIN", "USUBJID", "DASEQ", "DAREFID", "DASPID",
 "DATESTCD", "DATEST", "DAORRES", "DAORRESU", "DASTRESC",
 "DASTRESN", "DASTRESU", "DASTAT", "EPOCH", "DADTC", "DADY")
 
da <- domain06 %>%
 select(all_of(davarlist))
 
 
output<-da
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================