# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_CM_LCSG001
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
 
 
source("./SDTM_CM_LCSG001_data.r")
 
 
# Read input datasets
conmeds01 <- conmeds
dm01 <- dm
se01 <- se
 
# Create variables which are directly dependent on raw variables
cm01 <- conmeds01 %>%
 mutate(
 studyid = study,
 usubjid = paste(study, pt, sep = '-'),
 domain = "CM",
 cmtrt = cmvt,
 cmdecod = cmpt,
 cmcat = toupper(cmcat),
 cmindc = cmindc,
 cmdose = ifelse(!is.na(cmdose_raw), as.numeric(cmdose_raw), NA),
 cmdostxt = ifelse(is.na(cmdose), cmdose_raw, ""),
 cmdosu = ifelse(cmdosu_raw == "Milligram", "mg", cmdosu_raw),
 cmdosfrq = ifelse(cmdosfrq == "Daily", "QD",
 ifelse(cmdosfrq == "As needed", "PRN",
 cmdosfrq)),
 cmroute = route,
 stdayn = suppressWarnings(as.numeric(word(cmstdt_raw, 1, sep='/'))),
 stday = if_else(!is.na(stdayn), sprintf("%02d", stdayn), "-"),
 stmonthc = toupper(word(cmstdt_raw, 2, sep='/')),
 stmonth = case_when(
 stmonthc == "JAN" ~ "01",
 stmonthc == "FEB" ~ "02",
 stmonthc == "MAR" ~ "03",
 stmonthc == "APR" ~ "04",
 stmonthc == "MAY" ~ "05",
 stmonthc == "JUN" ~ "06",
 stmonthc == "JUL" ~ "07",
 stmonthc == "AUG" ~ "08",
 stmonthc == "SEP" ~ "09",
 stmonthc == "OCT" ~ "10",
 stmonthc == "NOV" ~ "11",
 stmonthc == "DEC" ~ "12",
 TRUE ~ "-"
 ),
 styear = word(cmstdt_raw,3,sep='/'),
 styear = if_else(toupper(styear) == "UNK", "-", styear),
 cmstdtc = str_c(styear, stmonth, stday, sep = "-"),
 
 cmstdtc = ifelse(str_sub(cmstdtc, -5) == "-----", str_sub(cmstdtc, end = -6), cmstdtc),
 cmstdtc = ifelse(str_sub(cmstdtc, -4) == "----", str_sub(cmstdtc, end = -5), cmstdtc),
 cmstdtc = ifelse(str_sub(cmstdtc, -2) == "--", str_sub(cmstdtc, end = -3), cmstdtc),
 
 
 endayn = as.numeric(word(cmendt_raw, 1, sep='/')),
 enday = if_else(!is.na(endayn), sprintf("%02d", endayn), "-"),
 enmonthc = toupper(word(cmendt_raw, 2, sep='/')),
 enmonth = case_when(
 enmonthc == "JAN" ~ "01",
 enmonthc == "FEB" ~ "02",
 enmonthc == "MAR" ~ "03",
 enmonthc == "APR" ~ "04",
 enmonthc == "MAY" ~ "05",
 enmonthc == "JUN" ~ "06",
 enmonthc == "JUL" ~ "07",
 enmonthc == "AUG" ~ "08",
 enmonthc == "SEP" ~ "09",
 enmonthc == "OCT" ~ "10",
 enmonthc == "NOV" ~ "11",
 enmonthc == "DEC" ~ "12",
 TRUE ~ "-"
 ),
 enyear = word(cmendt_raw,3,sep='/'),
 enyear = if_else(toupper(enyear) == "UNK", "-", enyear),
 cmendtc = str_c(enyear, enmonth, enday, sep = "-"),
 
 cmendtc = ifelse(str_sub(cmendtc, -5) == "-----", str_sub(cmendtc, end = -6), cmendtc),
 cmendtc = ifelse(str_sub(cmendtc, -4) == "----", str_sub(cmendtc, end = -5), cmendtc),
 cmendtc = ifelse(str_sub(cmendtc, -2) == "--", str_sub(cmendtc, end = -3), cmendtc)
 
 )
 
# Derive study day variables
cm02 <- cm01 %>%
 left_join(dm01 %>% select(usubjid, rfstdtc, rfxendtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 cmstdt = as.Date(cmstdtc, format = "%Y-%m-%d"),
 cmendt = as.Date(cmendtc, format = "%Y-%m-%d"),
 rfxendt = as.Date(substr(rfxendtc, 1, 10), format = "%Y-%m-%d"),
 rfxen15dtc = as.Date(rfxendt + 15, origin = "1970-01-01", tz = "UTC"),
 cmstdy = ifelse(!is.na(cmstdt) & !is.na(rfstdt), ifelse((cmstdt >= rfstdt), cmstdt - rfstdt + 1, cmstdt - rfstdt), NA),
 cmendy = ifelse(!is.na(cmendt) & !is.na(rfstdt), ifelse((cmendt >= rfstdt), cmendt - rfstdt + 1, cmendt - rfstdt), NA)
 )
 
# Derive EPOCH variable
se02 <- se01 %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1))) %>%
 arrange(usubjid, short)
 
# Process SE dataset to combine start date and end date of each epoch onto a single record
epochstart <- se02 %>%
 pivot_wider(names_from = short, values_from = sestdtc, id_cols = c(usubjid), names_prefix = "s", values_fill = "")
 
epochend <- se02 %>%
 pivot_wider(names_from = short, values_from = seendtc, id_cols = c(usubjid), names_prefix = "e", values_fill = "")
 
epochdates <- left_join(epochstart, epochend, by = "usubjid")
 
# Compare cmSTDTC with each epoch's start and end dates and assign the epoch value
cm04 <- cm02 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(cmstdtc) == 10 & (ss <= cmstdtc) & ((cmstdtc < st) | st == "") ~ "SCREENING",
 nchar(cmstdtc) == 10 & (st <= cmstdtc) & ((cmstdtc < sf) | sf == "") ~ "TREATMENT",
 nchar(cmstdtc) == 10 & (cmstdtc > sf) ~ "FOLLOW-UP",
 nchar(cmstdtc) == 7 & (ss7 < cmstdtc) & ((cmstdtc < st7) | st == "") ~ "SCREENING",
 nchar(cmstdtc) == 7 & (st7 < cmstdtc) & ((cmstdtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(cmstdtc) == 7 & (cmstdtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create CMSEQ variable
cm05 <- cm04 %>%
 arrange(usubjid, cmdecod, cmstdtc) %>%
 group_by(usubjid) %>%
 mutate(cmseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Select the required variables and assign attributes
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "CMSEQ", "CMTRT", "CMDECOD", "CMCAT", "CMINDC", "CMDOSE",
 "CMDOSTXT", "CMDOSU", "CMDOSFRQ", "CMROUTE", "EPOCH", "CMSTDTC", "CMENDTC", "CMSTDY", "CMENDY"
)
 
# Create the final dataset
cm06 <- cm05 %>%
 select(all_of(varlist))
 
output<-cm06
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================