# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADEG_L1101
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
 
 
source("./ADaM_ADEG_L1101_data.r")
 
# Load the tidyverse library for data manipulation
library(tidyverse)
 
 
adsl <- adsl %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"))
 
eg01 <- merge(eg, adsl %>% select(studyid, usubjid, trtsdt), by = c("studyid", "usubjid")) %>%
 filter(!is.na(trtsdt))
 
# Create variables which are directly based on input variables
adeg01 <- eg01 %>%
 mutate(
 paramcd = egtestcd,
 param = case_when(
 paramcd == 'HR' ~ 'Heart Rate (beats/min)',
 paramcd == 'PR' ~ 'PR Interval (msec)',
 paramcd == 'QT' ~ 'QT Interval (msec)',
 paramcd == 'RR' ~ 'RR Interval (msec)',
 paramcd == 'QRS' ~ 'QRS Interval (msec)',
 paramcd == 'INTP' ~ 'Interpretation'
 ),
 paramn = case_when(
 paramcd == 'HR' ~ 1,
 paramcd == 'PR' ~ 2,
 paramcd == 'QT' ~ 3,
 paramcd == 'RR' ~ 4,
 paramcd == 'QRS' ~ 5,
 paramcd == 'INTP' ~ 6
 ),
 adt = as.Date(egdtc, format = "%Y-%m-%d"),
 ady = if_else(!is.na(adt) & !is.na(trtsdt) & adt < trtsdt, adt - trtsdt, adt - trtsdt + 1),
 ady = as.numeric(ady),
 avisit = case_when(
 ady >= 2 & ady <= 127 ~ "Week 12",
 ady >= 128 & ady <= 210 ~ "Week 24",
 TRUE ~ ""
 ),
 avisitn = case_when(
 ady >= 2 & ady <= 127 ~ 12,
 ady >= 128 & ady <= 210 ~ 24,
 TRUE ~ NA
 ),
 awtarget = case_when(
 ady >= 2 & ady <= 127 ~ 85,
 ady >= 128 & ady <= 210 ~ 169,
 TRUE ~ NA
 ),
 awlo = case_when(
 ady >= 2 & ady <= 127 ~ 2,
 ady >= 128 & ady <= 210 ~ 128,
 TRUE ~ NA
 ),
 awhi = case_when(
 ady >= 2 & ady <= 127 ~ 127,
 ady >= 128 & ady <= 210 ~ 210,
 TRUE ~ NA
 ),
 awtdiff = abs(awtarget - ady),
 awu = if_else(!is.na(awtarget) & !is.na(ady), "DAYS", ""),
 aval = egstresn,
 avalc = if_else(paramcd=="INTP",egstresc," "),
 avalcat1 = case_when(
 paramcd == "HR" & aval < 50 ~ "< 50 bpm",
 paramcd == "HR" & aval >= 50 & aval <= 100 ~ "50 - 100 bpm",
 paramcd == "HR" & aval > 100 ~ "> 100 bpm",
 (paramcd %in% c("PR", "QRS")) & aval < 200 ~ "< 200 msec",
 (paramcd %in% c("PR", "QRS")) & aval >= 200 ~ ">= 200 msec",
 paramcd == "QT" & aval < 450 ~ "< 450 msec",
 paramcd == "QT" & aval >= 450 & aval < 480 ~ ">= 450 - <480 msec",
 paramcd == "QT" & aval >= 480 & aval < 500 ~ ">= 480 - < 500 msec",
 paramcd == "QT" & aval >= 500 ~ ">= 500 msec",
 TRUE ~ NA_character_
 ),
 avalca1n = case_when(
 paramcd == "HR" & aval < 50 ~ 1,
 paramcd == "HR" & aval >= 50 & aval <= 100 ~ 2,
 paramcd == "HR" & aval > 100 ~ 3,
 (paramcd %in% c("PR", "QRS")) & aval < 200 ~ 1,
 (paramcd %in% c("PR", "QRS")) & aval >= 200 ~ 2,
 paramcd == "QT" & aval < 450 ~ 1,
 paramcd == "QT" & aval >= 450 & aval < 480 ~ 2,
 paramcd == "QT" & aval >= 480 & aval < 500 ~ 3,
 paramcd == "QT" & aval >= 500 ~ 4,
 TRUE ~ NA_integer_
 )
 
 )
 
# Create baseline flag and dependent variables
base01 <- adeg01 %>%
 filter((!is.na(aval) | !is.na(avalc)), !is.na(adt), !is.na(trtsdt), adt <= trtsdt ) %>%
 arrange(usubjid, paramcd, adt, visitnum, egseq)
 
base02 <- base01 %>%
 group_by(usubjid, paramcd) %>%
 slice(n()) %>%
 mutate(ablfl = "Y",
 base = aval,
 basec = avalc,
 basecat1 = avalcat1,
 baseca1n = avalca1n) %>%
 select(usubjid, paramcd, adt, visitnum, ablfl, egseq, base, basec, basecat1, baseca1n)
 
# Merge the baseline flag back onto the parent dataset
adeg02 <- adeg01 %>%
 left_join(base02 %>% select(usubjid, paramcd, adt, visitnum, ablfl),
 by = c("usubjid", "paramcd", "adt", "visitnum"))
 
adeg03 <- adeg02 %>%
 mutate(
 avisitn = if_else(ablfl == "Y", 0, avisitn, avisitn),
 avisit = if_else(ablfl == "Y", "Baseline", avisit, avisit)
 )
 
adeg04 <- left_join(adeg03,
 base02 %>% select(usubjid, paramcd, base, basec, basecat1, baseca1n),
 by = c("usubjid", "paramcd"))
# Derive base, chg, and pchg variables
adeg05 <- adeg04 %>%
 arrange(usubjid, paramcd) %>%
 group_by(usubjid, paramcd) %>%
 mutate(
 anl02fl = ifelse(adt > trtsdt & !is.na(trtsdt), "Y", ""),
 chg = ifelse(anl02fl == "Y", aval - base, NA),
 pchg = ifelse(anl02fl == "Y" & base != 0, chg / base * 100, NA),
 chgcat1 = case_when(
 paramcd == "QT" & !is.na(chg) & chg <= 30 ~ "<= 30 msec",
 paramcd == "QT" & !is.na(chg) & chg > 30 & chg <= 60 ~ "> 30 - 60 msec",
 paramcd == "QT" & !is.na(chg) & chg > 60 ~ "> 60 msec",
 TRUE ~ ""
 ),
 chgcat1n = case_when(
 paramcd == "QT" & !is.na(chg) & chg <= 30 ~ 1,
 paramcd == "QT" & !is.na(chg) & chg > 30 & chg <= 60 ~ 2,
 paramcd == "QT" & !is.na(chg) & chg > 60 ~ 3,
 TRUE ~ NA
 ),
 tempavalc = ifelse(paramcd %in% c("INTP") & anl02fl=="Y", ifelse(is.na(avalc), "Missing", avalc), NA),
 tempbasec = ifelse(paramcd %in% c("INTP") & anl02fl=="Y", ifelse(is.na(basec), "Missing", basec), NA),
 tempavalcat1 = ifelse(paramcd %in% c("HR", "PR", "QRS", "QT") & anl02fl=="Y", ifelse(is.na(avalcat1), "Missing", avalcat1), NA),
 tempbasecat1 = ifelse(paramcd %in% c("HR", "PR", "QRS", "QT") & anl02fl=="Y", ifelse(is.na(basecat1), "Missing", basecat1), NA),
 shift1 = if_else(!is.na(tempavalc) & !is.na(tempbasec), paste(tempbasec, " to ", tempavalc), ""),
 shift2 = if_else(!is.na(tempavalcat1) & !is.na(tempbasecat1), paste(tempbasecat1, " to ", tempavalcat1), "")
 )
 
# Create anl01fl
adeg06 <- adeg05 %>%
 arrange(usubjid, paramcd, avisitn, avisit, awtdiff, adt) %>%
 group_by(usubjid, paramcd, avisitn, avisit, awtdiff, adt) %>%
 mutate(anl01fl = if_else(row_number() == 1 & !is.na(avisitn), "Y", "")) %>%
 ungroup()
 
# Merge with adsl to fetch other subject-level variables
adeg07 <- adeg06 %>%
 left_join(adsl, by = c("studyid" = "studyid", "usubjid" = "usubjid")) %>%
 arrange(usubjid,paramn,avisitn,adt) %>%
 arrange(usubjid,paramn,desc(is.na(avisitn)),avisitn,adt) %>%
 rename_all(toupper)
 
# Keep only required variables
varlist <- c(
 "STUDYID", "USUBJID", "SUBJID", "PARAM", "PARAMCD", "PARAMN", "ADT", "ADY",
 "AVISIT", "AVISITN", "AVAL", "AVALC", "ABLFL", "ANL01FL", "ANL02FL",
 "AVALCAT1", "AVALCA1N", "BASE", "BASEC", "BASECAT1", "BASECA1N",
 "CHG", "CHGCAT1", "CHGCAT1N", "PCHG", "SHIFT1", "SHIFT2",
 "AWTARGET", "AWTDIFF", "AWLO", "AWHI", "AWU", "EGSEQ", "VISITNUM",
 "VISIT", "SITEID", "AGE", "AGEU", "SEX", "RACE", "SAFFL", "RANDFL", "ENRLFL"
)
 
adeg <- adeg07 %>%
 select(all_of(varlist))
output <- adeg
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================