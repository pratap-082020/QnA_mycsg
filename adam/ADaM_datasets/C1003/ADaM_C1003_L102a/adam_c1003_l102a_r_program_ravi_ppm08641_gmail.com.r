# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1003_L102a
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
 
 
source("./ADaM_C1003_L102a_data.r")
 
#==============================================================================;
#Convert SAS date values to R date values;
#==============================================================================;
adae01<-ae %>%
 mutate(
 across(c(trtsdt,trtedt),~suppressWarnings(as_date(as.integer(.), origin = "1960-01-01")))
 )
 
adae02<-adae01  %>%
 mutate(astdt=suppressWarnings(as.Date(aestdtc)),
 aendt=suppressWarnings(as.Date(aeendtc)))
 
basesev<-adae02  %>%
 filter(!is.na(astdt),!is.na(trtsdt), astdt < trtsdt) %>%
 arrange(usubjid,aedecod,aesev) %>%
 group_by(usubjid,aedecod) %>%
 slice(n()) %>%
 select(usubjid,aedecod,aesev) %>%
 rename(basesev=aesev)
 
#==============================================================================;
#populate worst baseline severity of a decod on all rows of that decod;
#==============================================================================;
 
adae03<-adae02 %>%
 left_join(basesev,by=c("usubjid","aedecod"))
 
#==============================================================================;
#create trtemfl;
#==============================================================================;
 
adae04<-adae03 %>%
 mutate(
 trtemfl = if_else(
 !is.na(trtsdt) & astdt >= trtsdt & astdt <= trtedt + 15,
 if_else(
 is.na(basesev) | aesev > basesev,
 "Y",
 "N"
 ),
 "N"
 )
 ) %>%
 arrange(usubjid,astdt,aedecod)
 
output<-select(adae04,usubjid,aedecod,astdt,aendt,trtemfl,trtsdt,aestdtc,trtedt,
 aeendtc,aesev,basesev) %>%
 arrange(usubjid,is.na(astdt),astdt)
 
#==============================================================================;
; 

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================