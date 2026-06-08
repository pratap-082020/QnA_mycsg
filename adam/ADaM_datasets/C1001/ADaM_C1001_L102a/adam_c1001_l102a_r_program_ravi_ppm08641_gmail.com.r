# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1001_L102a
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
 
 
source("./ADaM_C1001_L102a_data.r")
 
library(dplyr)
 
# Sort the data by usubjid and exstdtc, and filter rows where EXCAT is "TREATMENT PERIOD" and EXSTDTC is not missing
trtsdt01 <- ex %>%
 arrange(usubjid, exstdtc) %>%
 filter(excat == "TREATMENT PERIOD" & !is.na(exstdtc))
 
# Keep only the first occurrence of each usubjid and convert exstdtc to trtsdt
trtsdt <- trtsdt01 %>%
 group_by(usubjid) %>%
 slice(1) %>%
 mutate(trtsdt = as.Date(substr(exstdtc, 1, 10), format = "%Y-%m-%d")) %>%
 select(usubjid, trtsdt)
 
 
# Sort the data by usubjid and exendtc, and filter rows where excat is "treatment period" and exendtc is not missing
trtedt01 <- ex %>%
 arrange(usubjid, exendtc) %>%
 filter(excat == "TREATMENT PERIOD" & !is.na(exendtc))
 
# Keep only the last occurrence of each usubjid and convert exendtc to trtedt
trtedt <- trtedt01 %>%
 group_by(usubjid) %>%
 slice(n()) %>%
 mutate(trtedt = as.Date(substr(exendtc, 1, 10), format = "%Y-%m-%d")) %>%
 select(usubjid, trtedt)
 
# Get the number of doses dispensed
disp01 <- da %>%
 filter(visitnum == 2 & datestcd == "DISPAMT") %>%
 rename(dispamt = dastresn) %>%
 select(usubjid, dispamt)
 
# Get the number of doses returned
ret01 <- da %>%
 filter(visitnum == 3 & datestcd == "RETAMT") %>%
 rename(retamt = dastresn) %>%
 select(usubjid, retamt)
 
# Merge disp01 and ret01 to calculate the number of doses taken
taken <- left_join(disp01, ret01, by = "usubjid") %>%
 mutate(taken = dispamt - retamt) %>%
 filter(taken > 0) %>%
 select(usubjid,taken)
 
# Merge dm, trtsdt, trtedt, and taken to create the final dataset adsl
adsl <- dm %>%
 left_join(trtsdt, by = "usubjid") %>%
 left_join(trtedt, by = "usubjid") %>%
 left_join(taken, by = "usubjid") %>%
 mutate(saffl = if_else(!is.na(trtsdt), "Y", "N"),
 saf2fl = if_else(!is.na(trtsdt) & !is.na(taken) & taken >0 , "Y", "N"))
 
output<-adsl %>%
 select(usubjid,trtsdt,trtedt,saffl,saf2fl)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================