# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_HO_L101
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
 
 
source("./SDTM_HO_L101_data.r")
 
# Create variables directly based on raw data
ho01 <- hosp %>%
 mutate(
 studyid = "MYCSG",
 domain = "HO",
 usubjid = paste(studyid, subject, sep = "-"),
 hospid = ifelse(!is.na(recordposition), sprintf("%03d", recordposition), NA),
 hostdtc = format(as.Date(hostdat, "%d/%b/%Y"),"%Y-%m-%d"),
 hoendtc = format(as.Date(hoendat, "%d/%b/%Y"), "%Y-%m-%d"),
 hoterm = hounit,
 hoenrtpt = ifelse(is.na(hoendat)|hoendat=="", "ONGOING", NA),
 hoentpt = ifelse(is.na(hoendat)|hoendat=="", "END OF STUDY", NA)
 )
 
# Calculate study days
ho02 <- ho01 %>%
 arrange(usubjid) %>%
 left_join(dm %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, "%Y-%m-%d"),
 hostdt = as.Date(hostdtc, "%Y-%m-%d"),
 hoendt = as.Date(hoendtc, "%Y-%m-%d"),
 hostdy = ifelse(!is.na(rfstdt) & !is.na(hostdt), hostdt - rfstdt + as.numeric(hostdt >= rfstdt), NA),
 hoendy = ifelse(!is.na(rfstdt) & !is.na(hoendt), hoendt - rfstdt + as.numeric(hoendt >= rfstdt), NA)
 )
 
# Create EPOCH variable
 
# EPOCH variable creation
se02 <- se %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1)))
 
epochstart <- se02 %>%
 select(usubjid, short, sestdtc) %>%
 pivot_wider(names_from = short, values_from = sestdtc, names_prefix = "s", values_fill = "")
 
epochend <- se02 %>%
 select(usubjid, short, seendtc) %>%
 pivot_wider(names_from = short, values_from = seendtc, names_prefix = "e", values_fill = "")
 
epochdates <- left_join(epochstart, epochend, by = "usubjid")
 
ho03 <- ho02 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(hostdtc) == 10 & (ss <= hostdtc) & ((hostdtc < st) | st == "") ~ "SCREENING",
 nchar(hostdtc) == 10 & (st <= hostdtc) & ((hostdtc < sf) | sf == "") ~ "TREATMENT",
 nchar(hostdtc) == 10 & (hostdtc > sf) ~ "FOLLOW-UP",
 nchar(hostdtc) == 7 & (ss7 < hostdtc) & ((hostdtc < st7) | st == "") ~ "SCREENING",
 nchar(hostdtc) == 7 & (st7 < hostdtc) & ((hostdtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(hostdtc) == 7 & (hostdtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create hoSEQ variable
ho04 <- ho03 %>%
 arrange(usubjid, hoterm, hostdtc, hoendtc, hospid) %>%
 group_by(usubjid) %>%
 mutate(hoseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Select and order the required variables
hovarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "HOSEQ", "HOSPID", "HOTERM", "EPOCH",
 "HOSTDTC", "HOENDTC", "HOSTDY", "HOENDY", "HOENRTPT", "HOENTPT", "HOREAS"
)
 
ho05 <- ho04 %>%
 select(all_of(hovarlist))
 
 
output <- ho05
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================