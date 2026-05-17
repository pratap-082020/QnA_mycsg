# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_IS_LADAB
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
 
 
source("./SDTM_IS_LADAB_data.r")
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
is01 <- isada
dm01 <- dm
 
#==============================================================================;
#Create required variables in is;
#==============================================================================;
is02 <- is01 %>% mutate(
 studyid = "MYCSG",
 domain = "IS",
 usubjid = paste(studyid, subject, sep = "-"),
 isdtc = ifelse(isdat_raw != "", format(as.Date(isdat_raw, format = "%d %b %Y"), "%Y-%m-%d"), ""),
 visitnum = folderseq,
 visit = foldername,
 istestcd = "ADA",
 istest = "AntiDrug Antibody",
 isorres = istiter,
 isstresc = isorres,
 isstresn = suppressWarnings(as.numeric(isstresc)),
 isorresu = "Titer",
 isstresu = isorresu,
 isspec = "SERUM",
 ismethod = "ELECTROCHEMILUMINESCENCE IMMUNOASSAY"
 )
 
 
#==============================================================================;
#Create --LOBXFL;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Fetch RFXSTDTC into is data;
#------------------------------------------------------------------------------;
 
is03 <- is02 %>%
 arrange(studyid, usubjid) %>%
 left_join(dm01 %>% select(studyid, usubjid, rfstdtc, rfxstdtc), by = c("studyid", "usubjid"))
 
 
#------------------------------------------------------------------------------;
#Filter qualifying records;
#------------------------------------------------------------------------------;
base01 <- is03 %>%
 filter(isdtc != "", isdtc <= rfxstdtc, isorres != "")
 
#------------------------------------------------------------------------------;
#Pick latest record;
#------------------------------------------------------------------------------;
base02 <- base01 %>%
 arrange(studyid, usubjid, istestcd, isdtc) %>%
 group_by(studyid, usubjid, istestcd) %>%
 filter(row_number() == n()) %>%
 ungroup() %>%
 select(studyid, usubjid, istestcd, isdtc)
 
#------------------------------------------------------------------------------;
#populate --lobxfl on the timepoint identified above;
#------------------------------------------------------------------------------;
 
is04 <- is03 %>%
 left_join(base02 %>% mutate(islobxfl = "Y"),
 by = c("studyid", "usubjid", "istestcd", "isdtc")) %>%
 mutate(islobxfl = if_else(!is.na(islobxfl), islobxfl, ""))
 
 
 
#==============================================================================;
#Derive other dependent variables;
#==============================================================================;
is05 <- is04 %>%
 mutate(
 isdt = as.Date(isdtc, format = "%Y-%m-%d"),
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 isdy = if_else(!is.na(isdt) & !is.na(rfstdt), isdt - rfstdt + (isdt >= rfstdt), NA),
 isdy=as.numeric(isdy),
 isdt = format(isdt, "%Y-%m-%d"),
 rfstdt = format(rfstdt, "%Y-%m-%d")
 )
 
 
#==============================================================================;
#Create --SEQ variable;
#==============================================================================;
is06 <- is05 %>%
 arrange(studyid, usubjid, istestcd, isdtc) %>%
 group_by(studyid, usubjid) %>%
 mutate(isseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
 
#==============================================================================;
#keep only required variables ;
#==============================================================================;
varlist <- c("STUDYID", "DOMAIN", "USUBJID", "ISSEQ", "ISTESTCD", "ISTEST", "ISORRES", "ISORRESU",
 "ISSTRESC", "ISSTRESN", "ISSTRESU", "ISSPEC", "ISMETHOD", "ISLOBXFL", "VISITNUM", "VISIT", "ISDTC", "ISDY")
 
is <- is06 %>%
 select(all_of(varlist))
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================