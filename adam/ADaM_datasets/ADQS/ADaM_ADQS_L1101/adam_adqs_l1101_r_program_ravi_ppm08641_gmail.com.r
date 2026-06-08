# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADQS_L1101
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
 
 
source("./ADaM_ADQS_L1101_data.r")
 
 
# Step 1: Get treatment start date into VS
 
adsl<-adsl %>% mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"))
qs01 <- qs %>%
 inner_join(adsl %>% select(studyid, usubjid, trtsdt), by = c("studyid", "usubjid")) %>%
 filter(qsstat != "NOT DONE")
 
# Step 2: Create variables directly based on input variables
source01 <- qs01 %>%
 mutate(
 paramcd = qstestcd,
 param = case_when(
 qstest == "MOBILITY" ~ "Mobility",
 qstest == "SELF-CARE" ~ "Self-care",
 qstest == "USUAL ACTIVITIES" ~ "Usual activities",
 qstest == "PAIN / DISCOMFORT" ~ "Pain/discomfort",
 qstest == "ANXIETY / DEPRESSION" ~ "Anxiety/depression",
 qstest == "YOUR HEALTH TODAY" ~ "Your health today",
 TRUE ~ NA_character_
 ),
 paramn = as.numeric(substr(paramcd, nchar(paramcd), nchar(paramcd))),
 parcat1 = qscat,
 parcat1n = if_else(qscat == "EQ5D-5L", 1, NA_integer_),
 adt = as.Date(qsdtc, format = "%Y-%m-%d"),
 ady = if_else(!is.na(adt) & !is.na(trtsdt), if_else(adt < trtsdt, adt - trtsdt, adt - trtsdt + 1), NA),
 ady=as.numeric(ady),
 avisitn = if_else(tolower(visit) != "unscheduled", visitnum, NA_integer_),
 avisit = visit,
 aval = qsstresn,
 avalc = qsstresc
 )
 
# Step 3: Create the derived parameter CHI
chi01 <- source01 %>%
 mutate(
 score = case_when(
 paramn == 1 ~ (aval == 1) * 0 + (aval == 2) * 0.051 + (aval == 3) * 0.063 + (aval == 4) * 0.212 + (aval == 5) * 0.275,
 paramn == 2 ~ (aval == 1) * 0 + (aval == 2) * 0.057 + (aval == 3) * 0.076 + (aval == 4) * 0.181 + (aval == 5) * 0.217,
 paramn == 3 ~ (aval == 1) * 0 + (aval == 2) * 0.051 + (aval == 3) * 0.067 + (aval == 4) * 0.174 + (aval == 5) * 0.190,
 paramn == 4 ~ (aval == 1) * 0 + (aval == 2) * 0.060 + (aval == 3) * 0.075 + (aval == 4) * 0.276 + (aval == 5) * 0.341,
 paramn == 5 ~ (aval == 1) * 0 + (aval == 2) * 0.079 + (aval == 3) * 0.104 + (aval == 4) * 0.296 + (aval == 5) * 0.301,
 TRUE ~ NA_real_
 )
 )
 
# Transpose the data to have all scores side by side
chi02 <- chi01 %>%
 filter(paramn %in% 1:5) %>%
 pivot_wider(
 id_cols = c(studyid, usubjid, qsdtc, epoch, visitnum, visit, avisitn, avisit, adt, ady, trtsdt),
 names_from = paramcd,
 values_from = score
 )
# Create aval and other related variables
chi03 <- chi02 %>%
 mutate(
 non_missing_count = rowSums(!is.na(select(., EQ5D5L01, EQ5D5L02, EQ5D5L03, EQ5D5L04, EQ5D5L05))),
 aval = if_else(non_missing_count==5, round(1 - 0.9675 * rowSums(across(starts_with("EQ5D5L"))), digits=3), NA),
 paramcd = "CHI",
 paramn = 7,
 param = "Composite health index",
 paramtyp = "DERIVED",
 avalc=as.character(aval)
 )
 
# Combine derived parameter records with source parameter records
adqs01 <- bind_rows(source01, chi03)
 
# Create baseline flag and dependent variables
base01 <- adqs01 %>%
 filter(!is.na(aval) & adt <= trtsdt)
 
base02 <- base01 %>%
 group_by(usubjid, paramn, adt, visitnum, qsseq) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(
 ablfl = "Y",
 base = aval,
 basec = avalc
 )
 
# Merge baseline flag back onto the parent dataset
adqs02 <- adqs01 %>%
 left_join(base02 %>% select(usubjid, paramn, adt, visitnum, qsseq, ablfl),
 by = c("usubjid", "paramn", "adt", "visitnum", "qsseq"))
 
adqs03 <- adqs02 %>%
 mutate(
 avisitn = if_else(ablfl == "Y", 0, avisitn,avisitn),
 avisit = if_else(ablfl == "Y", "Baseline", avisit,avisit)
 )
 
# Derive base, chg, and pchg variables
# Continuing from the previous code
 
# Derive base, chg, and pchg variables
adqs04 <- adqs03 %>%
 left_join(base02 %>% select(usubjid, paramn, base, basec), by = c("usubjid", "paramn"))
 
adqs05<-adqs04 %>%
 mutate(
 anl02fl = if_else(adt > trtsdt & !is.na(adt) & !is.na(trtsdt), "Y", ""),
 chg = if_else(anl02fl=="Y" & !is.na(aval) & !is.na(base), aval - base, NA_real_)
 )
 
# Create anl01fl
adqs05 <- adqs05 %>%
 arrange(usubjid, paramcd, avisitn, avisit, desc(adt)) %>%
 group_by(usubjid, paramcd, avisitn, avisit) %>%
 mutate(anl01fl = "Y") %>%
 ungroup()
 
# Merge with adsl to fetch other subject-level variables
adqs06 <- adqs05 %>%
 left_join(adsl, by = c("studyid", "usubjid")) %>%
 arrange(studyid,usubjid,paramn,avisitn,avisit,adt) %>%
 rename_all(toupper)
 
 
# Keep only the required variables
varlist <- c("STUDYID", "USUBJID", "SUBJID", "ADT", "ADY", "AVISIT", "AVISITN",
 "PARAM", "PARAMCD", "PARAMN", "PARAMTYP", "PARCAT1", "PARCAT1N",
 "AVAL", "AVALC", "BASE", "BASEC", "CHG", "ABLFL", "ANL01FL",
 "ANL02FL", "EPOCH", "VISITNUM", "VISIT", "SITEID", "AGE",
 "AGEU", "SEX", "RACE", "QSSEQ", "SAFFL", "RANDFL", "ENRLFL")
 
adqs <- adqs06 %>%
 select(all_of(varlist))
 
output<-adqs
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================