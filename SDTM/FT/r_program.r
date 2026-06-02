# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_FT_L6MWT
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
 
 
source("./SDTM_FT_L6MWT_data.r")
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
ft01 <- smwt
 
dm01 <- dm
 
#==============================================================================;
#Create required variables in ft;
#==============================================================================;
 
ft02<-bind_rows(
 mutate(ft01,fttestcd="SIXMW101",ftorres=smwt_1),
 mutate(ft01,fttestcd="SIXMW102",ftorres=smwt_2),
 mutate(ft01,fttestcd="SIXMW103",ftorres=smwt_3),
 mutate(ft01,fttestcd="SIXMW104",ftorres=smwt_4),
 mutate(ft01,fttestcd="SIXMW105",ftorres=smwt_5),
 mutate(ft01,fttestcd="SIXMW106",ftorres=smwt_6),
) %>%
 mutate(
 studyid = "MYCSG",
 domain = "FT",
 usubjid = paste(studyid, subject, sep = "-"),
 ftdtc = ifelse(ftdat_raw != "", format(as.Date(ftdat_raw, format = "%d %b %Y"), "%Y-%m-%d"), ""),
 ftcat = "SIX MINUTE WALK",
 fteval = "INVESTIGATOR",
 visitnum = folderseq,
 visit = foldername,
 ftstresc=ftorres,
 ftorresu=if_else(ftorres!="","m",""),
 ftstresu=ftorresu,
 ftstresn=suppressWarnings(as.numeric(ftorres))
 )
 
 
#==============================================================================;
#Create --LOBXFL;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Fetch RFXSTDTC into ft data;
#------------------------------------------------------------------------------;
ft03 <- ft02 %>%
 arrange(studyid, usubjid) %>%
 left_join(dm01 %>% select(studyid, usubjid, rfstdtc, rfxstdtc),
 by = c("studyid", "usubjid"))
 
#------------------------------------------------------------------------------;
#Filter qualifying records;
#------------------------------------------------------------------------------;
base01 <- ft03 %>%
 filter(ftdtc != "", ftdtc <= rfxstdtc, ftorres != "")
 
#------------------------------------------------------------------------------;
#Pick latest record;
#------------------------------------------------------------------------------;
base02 <- base01 %>%
 arrange(studyid, usubjid, fttestcd, ftdtc) %>%
 group_by(studyid, usubjid, fttestcd) %>%
 filter(row_number() == n()) %>%
 ungroup() %>%
 select(studyid, usubjid, fttestcd, ftdtc)
 
#------------------------------------------------------------------------------;
#populate --lobxfl on the timepoint identified above;
#------------------------------------------------------------------------------;
 
ft04 <- ft03 %>%
 left_join(base02 %>% mutate(ftlobxfl = "Y"),
 by = c("studyid", "usubjid", "fttestcd", "ftdtc")) %>%
 mutate(ftlobxfl = if_else(!is.na(ftlobxfl), ftlobxfl, ""))
 
 
#==============================================================================;
#Derive other dependent variables;
#==============================================================================;
 
ft05 <- ft04 %>%
 mutate(fttest = case_when(
 fttestcd == "SIXMW101" ~ "SIXMW1-Distance at 1 Minute",
 fttestcd == "SIXMW102" ~ "SIXMW1-Distance at 2 Minutes",
 fttestcd == "SIXMW103" ~ "SIXMW1-Distance at 3 Minutes",
 fttestcd == "SIXMW104" ~ "SIXMW1-Distance at 4 Minutes",
 fttestcd == "SIXMW105" ~ "SIXMW1-Distance at 5 Minutes",
 fttestcd == "SIXMW106" ~ "SIXMW1-Distance at 6 Minutes",
 TRUE ~ ""
 ),
 ftdt = as.Date(ftdtc, format = "%Y-%m-%d"),
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 ftdy = ifelse(!is.na(ftdt) & !is.na(rfstdt), ftdt - rfstdt + (ftdt >= rfstdt), NA),
 ftdt = format(ftdt, "%d%b%Y"),
 rfstdt = format(rfstdt, "%d%b%Y"),
 ftasstdv = smwt_device)
 
#==============================================================================;
#Create --SEQ variable;
#==============================================================================;
 
ft06 <- ft05 %>%
 arrange(studyid, usubjid, fttestcd, ftdtc) %>%
 group_by(studyid, usubjid) %>%
 mutate(ftseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
#==============================================================================;
#keep only required variables ;
#==============================================================================;
ft_varlist <- c("STUDYID", "DOMAIN", "USUBJID", "FTSEQ", "FTTESTCD", "FTTEST", "FTCAT", "FTORRES",
 "FTORRESU", "FTSTRESC", "FTSTRESN", "FTSTRESU", "FTLOBXFL", "FTEVAL", "VISITNUM",
 "VISIT", "FTDTC", "FTDY", "FTASSTDV")
 
ft <- ft06 %>%
 select(all_of(ft_varlist))
 
output <- ft
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================