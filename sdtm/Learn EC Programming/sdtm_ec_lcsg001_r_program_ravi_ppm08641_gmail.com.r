# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_EC_LCSG001
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
 
 
source("./SDTM_EC_LCSG001_data.r")
 
# Read input datasets
ipadmin01 <- ipadmin
dm01 <- dm
box01 <- box
lot01 <- lot
 
# Create variables which are directly based on source variables
ec01 <- ipadmin01 %>%
 mutate(
 studyid = study,
 domain = "EC",
 usubjid = paste(study,pt, sep = '-'),
 ecdose = as.numeric(ipqty_raw),
 ecdosu = ipqtyu,
 ecdosfrm = "INJECTION",
 ecdosfrq = "EVERY WEEK",
 ecroute = "INTRAVENOUS",
 ecpstrg = as.numeric(ipconc),
 ecpstrgu = ifelse(!is.na(ecpstrg), "ug/ml", NA_character_),
 ecadj = toupper(ipadj),
 epoch = "TREATMENT",
 ipstdtc = as.Date(ipstdt_raw, format = "%d/%b/%Y"),
 ipsttm = format(as.POSIXct(ipsttm_raw, format = "%H:%M", tz = ""),"%H:%M"),
 ecstdtc = paste(ipstdtc, ipsttm, sep = "T"),
 ecendtc = ecstdtc
 )
 
# Create ECTRT variable by fetching the information from box dataset
ec02 <- ec01 %>%
 left_join(box01 %>% select(kitid, content), by = c("ipboxid" = "kitid")) %>%
 mutate(
 ectrt = case_when(
 content == "PBO" ~ "PLACEBO",
 content == "ACTIVE" ~ "ACTIVE",
 TRUE ~ ""
 )
 )
 
# Create ECLOT variable by fetching the information from lot dataset
ec03 <- ec02 %>%
 left_join(lot01 %>% select(kitid, eclot=lotnum), by = c("ipboxid" = "kitid")) %>%
 select(-content)
 
# Create study day variables by fetching reference start date information from demographics
ec04 <- ec03 %>%
 left_join(dm01 %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 ecstdt = as.Date(ecstdtc, format = "%Y-%m-%d"),
 ecendt = as.Date(ecendtc, format = "%Y-%m-%d"),
 ecstdy = ifelse(!is.na(rfstdt) & !is.na(ecstdt), ecstdt - rfstdt + (ecstdt >= rfstdt), NA_real_),
 ecendy = ifelse(!is.na(rfstdt) & !is.na(ecendt), ecendt - rfstdt + (ecendt >= rfstdt), NA_real_)
 )
 
# Create ECSEQ variable
ec05 <- ec04 %>%
 arrange(usubjid, ectrt, ecstdtc) %>%
 group_by(usubjid) %>%
 mutate(ecseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Select the required variables and order them
ecvarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "ECSEQ", "ECTRT", "ECDOSE", "ECDOSU", "ECDOSFRM", "ECDOSFRQ", "ECROUTE",
 "ECLOT", "ECPSTRG", "ECPSTRGU", "ECADJ", "EPOCH", "ECSTDTC", "ECENDTC", "ECSTDY", "ECENDY"
)
 
ec06 <- ec05 %>%
 select(all_of(ecvarlist))
 
output <- ec06
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================