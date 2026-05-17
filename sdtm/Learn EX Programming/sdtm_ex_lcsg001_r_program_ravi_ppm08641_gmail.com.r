# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_EX_LCSG001
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
 
 
source("./SDTM_EX_LCSG001_data.r")
 
 
# Read input datasets
ipadmin01 <- ipadmin
dm01 <- dm
sv01 <- sv
se01 <- se
box01 <- box
lot01 <- lot
 
# Create variables based on source variables
ex01 <- ipadmin01 %>%
 mutate(
 studyid = study,
 domain = "EX",
 usubjid = paste(study, pt, sep = "-"),
 ipcon = as.numeric(ipconc),
 ipqty = as.numeric(ipqty_raw),
 exdose = ifelse(!is.na(ipcon) & !is.na(ipqty), ipcon * ipqty, NA),
 exdosu = ifelse(!is.na(exdose), "ug", ""),
 exdosfrm = "INJECTION",
 exdosfrq = "EVERY WEEK",
 exroute = "INTRAVENOUS",
 exadj = toupper(ipadj),
 epoch = "TREATMENT",
 ipstdtc = as.Date(ipstdt_raw, format = "%d/%b/%Y"),
 ipsttm = format(as.POSIXct(ipsttm_raw, format = "%H:%M", tz = "GMT"),"%H:%M"),
 exstdtc = paste(ipstdtc, ipsttm,sep="T"),
 exendtc = exstdtc
 )
 
# Create EXTRT variable
ex02 <- ex01 %>%
 left_join(box01, by = c("ipboxid" = "kitid")) %>%
 mutate(extrt = case_when(
 content == "PBO" ~ "PLACEBO",
 content == "ACTIVE" ~ "ACTIVE",
 TRUE ~ ""
 )) %>%
 select(-content)
 
# Create EXLOT variable
ex03 <- ex02 %>%
 left_join(lot01 %>% select(kitid,exlot=lotnum), by = c("ipboxid" = "kitid"))
 
 
# Create study day variables by fetching reference start date information from demographics
ex04 <- ex03 %>%
 arrange(usubjid) %>%
 left_join(dm01 %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 exstdt = as.Date(exstdtc),
 exendt = as.Date(exendtc),
 exstdy = ifelse(!is.na(exstdt) & !is.na(rfstdt), exstdt - rfstdt + (exstdt >= rfstdt), NA),
 exendy = ifelse(!is.na(exendt) & !is.na(rfstdt), exendt - rfstdt + (exendt >= rfstdt), NA),
 exdose = ifelse(extrt == "PLACEBO", 0, exdose)
 ) %>%
 select(-rfstdtc)
 
# Create EXSEQ variable
ex05 <- ex04 %>%
 arrange(usubjid, extrt, exstdtc) %>%
 group_by(usubjid) %>%
 mutate(exseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Define the list of variables to keep
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "EXSEQ", "EXTRT",
 "EXDOSE", "EXDOSU", "EXDOSFRM", "EXDOSFRQ", "EXROUTE",
 "EXLOT", "EXADJ", "EPOCH", "EXSTDTC", "EXENDTC", "EXSTDY", "EXENDY"
)
 
# Create ex06 by selecting the variables from ex05
ex06 <- ex05 %>%
 select(all_of(varlist))
 
output <- ex06
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================