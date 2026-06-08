# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADAE_L1101
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
library(stringr)
 
source("./ADaM_ADAE_L1101_data.r")
 
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
ae01 <- ae %>% arrange(studyid, usubjid)
adsl <- adsl %>%
 arrange(studyid, usubjid) %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"),
 trtedt=as.Date(trtedt,origin="1960-01-01"))
 
ae02 <- inner_join(ae01, adsl, by = c("studyid", "usubjid"))
 
check<-ae02 %>%
 mutate(nchar=nchar(aestdtc), astdt=as.Date(aestdtc, format = "%Y-%m-%d"))
#==============================================================================;
#Create derived variables;
#==============================================================================;
 
ae03 <- ae02 %>%
 mutate(
 # ASTDT/ASTDTF
 astdt = case_when(
 nchar(aestdtc) == 10 ~ as.Date(aestdtc, format = "%Y-%m-%d"),
 is.na(aestdtc) | aestdtc == "" ~ trtsdt,
 nchar(aestdtc) == 7 ~ as.Date(paste(aestdtc, "01", sep = "-"), format = "%Y-%m-%d"),
 nchar(aestdtc) == 4 ~ as.Date(paste(aestdtc, "01-01", sep = "-"), format = "%Y-%m-%d")
 ),
 astdtf = case_when(
 nchar(aestdtc) == 10 ~ " ",
 is.na(aestdtc) | aestdtc == "" ~ "Y",
 nchar(aestdtc) == 7 ~ "D",
 nchar(aestdtc) == 4 ~ "M"
 ),
 # AENDT/AENDTF
 aendt = case_when(
 !is.na(trtedt) & (is.na(aeendtc)|aeendtc=="") ~ trtedt,
 nchar(aeendtc) == 10 ~ as.Date(aeendtc, format = "%Y-%m-%d"),
 nchar(aeendtc) == 7 ~ ceiling_date(as.Date(paste(aeendtc, "01", sep = "-"), format = "%Y-%m-%d"), "month")-1,
 nchar(aeendtc) == 4 ~ if_else(aeendtc == as.character(year(trtedt)), trtedt, as.Date(paste(aeendtc, "12-31", sep = "-"), format = "%Y-%m-%d"))
 ),
 aendtf = case_when(
 is.na(aeendtc)|aeendtc=="" ~ "Y",
 nchar(aeendtc) == 7 ~ "D",
 nchar(aeendtc) == 4 ~ "M",
 TRUE ~ ""
 ),
 # TRTEMFL/PREFL/FUPFL
 trtemfl = if_else(!is.na(trtsdt) & trtsdt <= astdt & astdt <= (trtedt + 14), "Y", ""),
 prefl = if_else(!is.na(trtsdt) & astdt < trtsdt, "Y", ""),
 fupfl = if_else(as.Date(astdt) > (trtedt + 14), "Y", ""),
 # ASEV/ASEVN
 asev = if_else(is.na(aesev)|aesev=="", "Severe", str_to_title(aesev)),
 asevn = case_when(
 asev == "Mild" ~ 1,
 asev == "Moderate" ~ 2,
 asev == "Severe" ~ 3
 ),
 # RELGR1/RELGR1N
 relgr1 = case_when(
 is.na(aerel) ~ "Related",
 aerel %in% c("NOT RELATED", "UNLIKELY RELATED") ~ "Not Related",
 aerel %in% c("POSSIBLY RELATED", "PROBABLY RELATED", "DEFINITELY RELATED") ~ "Related"
 ),
 relgr1n = case_when(
 is.na(aerel) ~ 1,
 aerel %in% c("NOT RELATED", "UNLIKELY RELATED") ~ 0,
 aerel %in% c("POSSIBLY RELATED", "PROBABLY RELATED", "DEFINITELY RELATED") ~ 1
 ),
 # Other variables
 trtan = trt01an,
 trta = trt01a,
 
 astdy = ifelse(!is.na(astdt) & !is.na(trtsdt), astdt - trtsdt + (astdt >= trtsdt), NA),
 aendy = ifelse(!is.na(aendt) & !is.na(trtsdt), aendt - trtsdt + (aendt >= trtsdt), NA),
 
 aphase = case_when(
 !is.na(astdt) & astdt < trtsdt ~ "PRE-TREATMENT",
 !is.na(trtsdt) & trtsdt <= astdt & astdt <= (trtedt + 14) ~ "TREATMENT",
 as.Date(astdt) > (trtedt + 14) ~ "FOLLOW-UP"
 )
 )
 
#==============================================================================;
#Occurrence flags;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#AOCCFL;
#------------------------------------------------------------------------------;
 
aocc01 <- ae03 %>%
 arrange(studyid, usubjid, astdt, aeseq) %>%
 filter(trtemfl == "Y") %>%
 group_by(studyid, usubjid) %>%
 slice(1) %>%
 mutate(aoccfl = "Y") %>%
 ungroup()
 
aocc02 <- aocc01 %>%
 select(studyid, usubjid, aeseq, aoccfl)
 
#------------------------------------------------------------------------------;
#AOCCSFL;
#------------------------------------------------------------------------------;
aoccs01 <- ae03 %>%
 arrange(studyid, usubjid, aebodsys, astdt, aeseq) %>%
 filter(trtemfl == "Y") %>%
 group_by(studyid, usubjid, aebodsys) %>%
 slice(1) %>%
 mutate(aoccsfl = "Y") %>%
 ungroup()
 
aoccs02 <- aoccs01 %>%
 select(studyid, usubjid, aeseq, aoccsfl)
 
#------------------------------------------------------------------------------;
#AOCCPFL;
#------------------------------------------------------------------------------;
aoccp01 <- ae03 %>%
 arrange(studyid, usubjid, aebodsys, aedecod, astdt, aeseq) %>%
 filter(trtemfl == "Y") %>%
 group_by(studyid, usubjid, aebodsys, aedecod) %>%
 slice(1) %>%
 mutate(aoccpfl = "Y") %>%
 ungroup()
 
aoccp02 <- aoccp01 %>%
 select(studyid, usubjid, aeseq, aoccpfl)
 
#------------------------------------------------------------------------------;
#Bring all flags into ae03;
#------------------------------------------------------------------------------;
data_list <- list(ae03, aocc02, aoccs02, aoccp02)
ae04 <- reduce(data_list, left_join, by = c("studyid", "usubjid", "aeseq")) %>%
 mutate(across(where(is.character), ~ if_else(is.na(.), "", .))) %>%
 rename_all(toupper)
 
#==============================================================================;
#Keep only required variables and sort as per requirement;
#==============================================================================;
varlist <- c("STUDYID", "USUBJID", "AESEQ", "AETERM", "AEDECOD", "AEBODSYS", "TRTEMFL", "PREFL", "FUPFL", "AESTDTC",
 "ASTDT", "ASTDTF", "ASTDY", "AEENDTC", "AENDT", "AENDTF", "AENDY", "AESER", "APHASE", "AESEV", "ASEV", "ASEVN", "AEREL",
 "RELGR1", "RELGR1N", "SAFFL", "AOCCFL", "AOCCSFL", "AOCCPFL", "TRTA", "TRTAN", "TRTSDT", "TRTEDT", "AGE",
 "AGEGR1", "SEX", "RACE")
 
adae <- ae04 %>%
 select(all_of(varlist))
 
adae <- adae %>%
 arrange(STUDYID, USUBJID, ASTDT, AEDECOD, AESEQ)
 
 
 
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================