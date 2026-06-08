# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADIS_LVAC01
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
 
 
source("./ADaM_ADIS_LVAC01_data.r")
 
#==============================================================================;
#Convert SAS date into R date;
#==============================================================================;
 
adsl <- adsl %>% mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"))
#==============================================================================
# Get treatment start date into IS
#==============================================================================
 
 
# Merging datasets
is01 <- is %>%
 left_join(adsl %>% select(studyid, usubjid, trtsdt), by = c("studyid", "usubjid"))
 
#==============================================================================
# Create variables which are directly based on input variables
#==============================================================================
 
adis01 <- is01 %>%
 mutate(
 # Parameter related variables
 paramcd = istestcd,
 param = case_when(
 paramcd == "TITER" ~ "Titer (GCE/ml)",
 TRUE ~ NA_character_
 ),
 paramn = case_when(
 paramcd == "TITER" ~ 1,
 TRUE ~ NA_real_
 ),
 # Timing variables
 adt = if_else(nchar(isdtc) >= 10, ymd(isdtc), NA_Date_),
 ady = case_when(
 !is.na(adt) & !is.na(trtsdt) & adt < trtsdt ~ as.numeric(adt - trtsdt),
 !is.na(adt) & !is.na(trtsdt) & adt >= trtsdt ~ as.numeric(adt - trtsdt + 1),
 TRUE ~ NA_real_
 ),
 avisitn = case_when(
 !is.na(ady) & ady <= -1 ~ -1,
 !is.na(ady) & ady == 1 ~ 1,
 !is.na(ady) & ady >= 7 & ady <= 9 ~ 2,
 !is.na(ady) & ady >= 25 & ady <= 33 ~ 3,
 !is.na(ady) & ady >= 78 & ady <= 92 ~ 4,
 !is.na(ady) & ady >= 166 & ady <= 194 ~ 5,
 !is.na(ady) & ady >= 351 & ady <= 379 ~ 6,
 TRUE ~ NA_real_
 ),
 avisit = case_when(
 avisitn == -1 ~ "Screening",
 avisitn == 1 ~ "Visit 1",
 avisitn == 2 ~ "Visit 2",
 avisitn == 3 ~ "Visit 3",
 avisitn == 4 ~ "Visit 4",
 avisitn == 5 ~ "Visit 5",
 avisitn == 6 ~ "Visit 6",
 TRUE ~ NA_character_
 ),
 awtarget = case_when(
 avisitn == 1 ~ 1,
 avisitn == 2 ~ 8,
 avisitn == 3 ~ 29,
 avisitn == 4 ~ 85,
 avisitn == 5 ~ 180,
 avisitn == 6 ~ 365,
 TRUE ~ NA_real_
 ),
 awlo = case_when(
 avisitn == 1 ~ 1,
 avisitn == 2 ~ 7,
 avisitn == 3 ~ 25,
 avisitn == 4 ~ 78,
 avisitn == 5 ~ 166,
 avisitn == 6 ~ 351,
 TRUE ~ NA_real_
 ),
 awhi = case_when(
 avisitn == -1 ~ -1,
 avisitn == 1 ~ 1,
 avisitn == 2 ~ 9,
 avisitn == 3 ~ 33,
 avisitn == 4 ~ 92,
 avisitn == 5 ~ 194,
 avisitn == 6 ~ 379,
 TRUE ~ NA_real_
 ),
 awtdiff = if_else(!is.na(awtarget) & !is.na(ady), abs(awtarget - ady), NA_real_),
 awu = if_else(!is.na(avisit), "DAYS", NA_character_),
 aval = isstresn
 )
 
#==============================================================================
# Create baseline flag and dependent variables
#==============================================================================
 
# Subset the records with non-missing result which are on or before treatment start
base01 <- adis01 %>%
 filter(!is.na(adt) & adt <= trtsdt & !is.na(aval)) %>%
 arrange(usubjid, paramn, adt, visitnum, isseq)
 
# Identify the latest record
base02 <- base01 %>%
 group_by(usubjid, paramn) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(ablfl = "Y", base = aval) %>%
 select(usubjid, paramn, adt, visitnum, ablfl, isseq, base)
 
# Merge the baseline flag back onto the parent dataset
adis02 <- adis01 %>%
 left_join(base02 %>% select(usubjid,paramn,adt,visitnum,isseq,ablfl), by = c("usubjid", "paramn", "adt", "visitnum", "isseq")) %>%
 mutate(
 avisitn = if_else(ablfl == "Y", 0, avisitn,avisitn),
 avisit = if_else(ablfl == "Y", "Baseline", avisit,avisit)
 )
 
#==============================================================================
# Deriving base, chg, and pchg variables
#==============================================================================
 
adis04 <- adis02 %>%
 left_join(base02 %>% select(usubjid, paramn, base), by = c("usubjid", "paramn")) %>%
 mutate(
 anl02fl = if_else(adt > trtsdt, "Y", NA_character_),
 chg = if_else(!is.na(aval) & !is.na(base) & anl02fl=="Y", aval - base, NA_real_),
 r2base = if_else(!is.na(aval) & base != 0 & anl02fl=="Y", round(aval / base, 2), NA_real_),
 crit1 = if_else(paramcd == "TITER", "Seroresponse - Titer >=200", NA_character_),
 crit2 = if_else(paramcd == "TITER", "Seroconversion - > 4 fold increase from baseline", NA_character_),
 crit1fl = if_else(paramcd == "TITER" & aval >= 200, "Y", if_else(paramcd == "TITER", "N", NA_character_)),
 crit2fl = if_else(anl02fl == "Y" & r2base > 4, "Y", if_else(anl02fl == "Y", "N", NA_character_))
 )
 
#==============================================================================
# Create anl01fl
#==============================================================================
 
adis05 <- adis04 %>%
 arrange(usubjid, paramcd, avisitn, avisit, awtdiff, desc(adt)) %>%
 group_by(usubjid, paramcd, avisitn) %>%
 mutate(anl01fl = if_else(row_number() == 1 & !is.na(avisitn), "Y", NA_character_)) %>%
 ungroup() %>%
 arrange(usubjid, paramn, avisitn, avisit, adt)
 
#==============================================================================
# Merge with adsl to fetch other subject level variables
#==============================================================================
 
adis06 <- adis05 %>%
 left_join(adsl, by = c("studyid", "usubjid")) %>%
 arrange(usubjid,isseq) %>%
 rename_all(toupper)
 
#==============================================================================
# Keep only required variables
#==============================================================================
 
varlist <- c("STUDYID", "USUBJID", "ISSEQ", "ADT", "ADY", "VISITNUM", "VISIT", "AVISIT", "AVISITN",
 "PARAM", "PARAMCD", "PARAMN", "AVAL", "BASE", "CHG", "R2BASE", "CRIT1", "CRIT1FL",
 "CRIT2", "CRIT2FL", "AWTARGET", "AWTDIFF", "AWLO", "AWHI", "AWU", "ABLFL", "ANL01FL", "ANL02FL")
 
adis <- adis06 %>%
 select(all_of(varlist))
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================