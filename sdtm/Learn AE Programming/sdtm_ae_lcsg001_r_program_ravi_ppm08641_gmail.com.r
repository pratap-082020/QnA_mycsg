# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_AE_LCSG001
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
 
 
source("./SDTM_AE_LCSG001_data.r")
 
# Read input datasets
ae01 <- adverse
dm01 <- dm
se01 <- se
 
# Create variables which are directly based on the existing raw variables
ae02 <- ae01 %>%
 filter(aevt != "") %>%
 mutate(
 domain = "AE",
 studyid = study,
 usubjid = paste(study, pt, sep = '-'),
 aeterm = aevt,
 aellt = aellt,
 aedecod = aedecod,
 aecat = aecat,
 aebodsys = aebodsys,
 aesev = toupper(aesev),
 aeser = if_else(toupper(aeser) == "YES", "Y", if_else(toupper(aeser) == "NO", "N", aeser)),
 aeacn = if_else(toupper(aeacn) == "NO ACTION TAKEN", "DOSE NOT CHANGED", toupper(aeacn)),
 aeacnoth = aeacnoth,
 aerel = if_else(toupper(aerel) == "YES", "Y", if_else(toupper(aerel) == "NO", "N", aerel)),
 aeout = toupper(aeout),
 aescong = if_else(toupper(scong) == "YES", "Y", if_else(toupper(scong) == "NO", "N", NA_character_)),
 aesdisab = if_else(toupper(sdisab) == "YES", "Y", if_else(toupper(sdisab) == "NO", "N", NA_character_)),
 aesdth = if_else(toupper(sdeath) == "YES", "Y", if_else(toupper(sdeath) == "NO", "N", NA_character_)),
 aeshosp = if_else(toupper(shosp) == "YES", "Y", if_else(toupper(shosp) == "NO", "N", NA_character_)),
 aeslife = if_else(toupper(slife) == "YES", "Y", if_else(toupper(slife) == "NO", "N", NA_character_)),
 aesmie = if_else(toupper(smie) == "YES", "Y", if_else(toupper(smie) == "NO", "N", NA_character_)),
 stdayn = suppressWarnings(as.numeric(word(aestdt_raw, 1, sep='/'))),
 stday = if_else(!is.na(stdayn), sprintf("%02d", stdayn), "-"),
 stmonthc = toupper(word(aestdt_raw, 2, sep='/')),
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
 styear = word(aestdt_raw,3,sep='/'),
 styear = if_else(toupper(styear) == "UNK", "-", styear),
 aestdtc = str_c(styear, stmonth, stday, sep = "-"),
 
 aestdtc = ifelse(str_sub(aestdtc, -5) == "-----", str_sub(aestdtc, end = -6), aestdtc),
 aestdtc = ifelse(str_sub(aestdtc, -4) == "----", str_sub(aestdtc, end = -5), aestdtc),
 aestdtc = ifelse(str_sub(aestdtc, -2) == "--", str_sub(aestdtc, end = -3), aestdtc),
 
 
 endayn = as.numeric(word(aeendt_raw, 1, sep='/')),
 enday = if_else(!is.na(endayn), sprintf("%02d", endayn), "-"),
 enmonthc = toupper(word(aeendt_raw, 2, sep='/')),
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
 enyear = word(aeendt_raw,3,sep='/'),
 enyear = if_else(toupper(enyear) == "UNK", "-", enyear),
 aeendtc = str_c(enyear, enmonth, enday, sep = "-"),
 
 aeendtc = ifelse(str_sub(aeendtc, -5) == "-----", str_sub(aeendtc, end = -6), aeendtc),
 aeendtc = ifelse(str_sub(aeendtc, -4) == "----", str_sub(aeendtc, end = -5), aeendtc),
 aeendtc = ifelse(str_sub(aeendtc, -2) == "--", str_sub(aeendtc, end = -3), aeendtc)
 
 
 )
 
# Derive study day variables and AETRTEM
ae03 <- ae02 %>%
 left_join(select(dm01,usubjid, rfstdtc, rfxendtc),by=c("usubjid")) %>%
 mutate(
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 aestdt = as.Date(aestdtc, format = "%Y-%m-%d"),
 aeendt = as.Date(aeendtc, format = "%Y-%m-%d"),
 rfxendt = as.Date(substr(rfxendtc, 1, 10), format = "%Y-%m-%d"),
 rfxen15dtc = as.Date(rfxendt + 15, origin = "1970-01-01", tz = "UTC"),
 aestdy=ifelse(!is.na(aestdt) & !is.na(rfstdt),
 ifelse((aestdt>=rfstdt),aestdt-rfstdt+1,aestdt-rfstdt), NA),
 aeendy=ifelse(!is.na(aeendt) & !is.na(rfstdt),
 ifelse((aeendt>=rfstdt),aeendt-rfstdt+1,aeendt-rfstdt), NA),
 aetrtem = case_when(
 prefdose == "Y" ~ "N",
 "" < substr(rfstdtc, 1, 10) & substr(rfstdtc, 1, 10) <= aestdtc & aestdtc <= rfxen15dtc ~ "Y",
 aestdtc != "" ~ "N",
 TRUE ~ "N"
 )
 )
 
# Derive EPOCH variable
se02 <- se01 %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1))) %>%
 arrange(usubjid, short)
 
# Process SE dataset such that start date and end date of each epoch come onto a single record
epochstart <- se02 %>%
 pivot_wider(names_from = short, values_from = sestdtc, id_cols = c(usubjid), names_prefix = "s", values_fill="")
 
epochend <- se02 %>%
 pivot_wider(names_from = short, values_from = seendtc, id_cols = c(usubjid), names_prefix = "e", values_fill="")
 
epochdates <- left_join(epochstart, epochend, by = "usubjid")
 
# Compare AESTDTC with each epoch's start and end dates and assign epoch value
ae04 <- ae03 %>%
 left_join(epochdates,by="usubjid") %>%
 mutate(
 ss7=substr(ss,1,7),
 st7=substr(st,1,7),
 sf7=substr(sf,1,7),
 
 epoch=case_when(
 
 nchar(aestdtc)==10 & (ss <= aestdtc) & ((aestdtc < st)|st=="") ~ "SCREENING",
 nchar(aestdtc)==10 & (st <= aestdtc) & ((aestdtc < sf)|sf=="") ~ "TREATMENT",
 nchar(aestdtc)==10 & (aestdtc > sf) ~ "FOLLOW-UP",
 
 nchar(aestdtc)==7 & (ss7 < aestdtc) & ((aestdtc < st7)|st=="") ~ "SCREENING",
 nchar(aestdtc)==7 & (st7 < aestdtc) & ((aestdtc < sf7)|sf=="") ~ "TREATMENT",
 nchar(aestdtc)==7 & (aestdtc > sf7) & sf7!=""~ "FOLLOW-UP",
 )
 
 )
 
# Create AESEQ variable
ae05 <- ae04 %>%
 arrange(usubjid, aedecod, aestdtc) %>%
 group_by(usubjid) %>%
 mutate(aeseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# You can access ae06 as the final dataframe
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "AESEQ", "AETERM", "AELLT", "AEDECOD", "AECAT",
 "AEBODSYS", "AESEV", "AESER", "AEACN", "AEACNOTH", "AEREL", "AEOUT", "AESCONG",
 "AESDISAB", "AESDTH", "AESHOSP", "AESLIFE", "AESMIE", "EPOCH", "AESTDTC", "AEENDTC",
 "AESTDY", "AEENDY", "PREFDOSE", "AETRTEM"
)
 
# Create ae07 data frame with specified attributes and column labels
ae06 <- ae05 %>%
 select(all_of(varlist))
 
output <- ae06
 
#==============================================================================;
; 

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================