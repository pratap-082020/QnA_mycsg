# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1006_L101b
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
 
 
source("./ADaM_C1006_L101b_data.r")
 
#==============================================================================;
#Handle the date, times created in sas;
#==============================================================================;
 
advs01 <- advs %>%
 mutate(adt=as.Date(adt, origin="1960-01-01"),
 trtsdt=as.Date(trtsdt, origin="1960-01-01"),
 adtm     = as.POSIXct(adtm, origin = "1960-01-01", tz = "UTC"),
 trtsdtm  = as.POSIXct(trtsdtm, origin = "1960-01-01", tz = "UTC"),
 atm = hms::hms(seconds = atm))
 
#==============================================================================
# Subset eligible records
#==============================================================================
 
base01 <- advs01 %>%
 filter(
 !is.na(aval) &
 (
 (is.na(atm) & !is.na(adt) & adt <= trtsdt) |
 (!is.na(atm) & !is.na(adtm) & adtm < trtsdtm)
 )
 )
 
#==============================================================================
# Select the latest record per subject and parameter
#==============================================================================
 
base02 <- base01 %>%
 arrange(usubjid, paramcd, adt, adtm) %>%
 group_by(usubjid, paramcd) %>%
 slice_tail( ) %>%
 ungroup() %>%
 select(usubjid, paramcd, adt, adtm) %>%
 mutate(inbase=1)
 
#==============================================================================
# Flag ablfl = "Y" on matching records in parent dataset
#==============================================================================
 
advs02 <- advs01 %>%
 left_join(base02, by = c("usubjid", "paramcd", "adt", "adtm")) %>%
 mutate(ablfl = if_else(!is.na(inbase), "Y", NA))
 
output <- advs02 %>%
 select(-inbase) %>%
 arrange(usubjid,paramcd,adt,adtm) %>%
 mutate(atm=as.numeric(atm))
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================