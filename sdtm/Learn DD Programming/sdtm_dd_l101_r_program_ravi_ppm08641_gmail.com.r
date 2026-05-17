# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_DD_L101
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
 
 
source("./SDTM_DD_L101_data.r")
 
 
# Create a separate record for each test collected
 
dd01 <- bind_rows(
 mutate(dd_death, ddtestcd = "ATUOPIND", ddtest="Autopsy Indicator",ddorres = autopsy),
 mutate(dd_death, ddtestcd = "PRCDTH",ddtest="Primary Cause of Death", ddorres = prmcaus,prcdthsp=prmcaussp ),
 mutate(dd_death %>% filter(seccaus!="" & !is.na(seccaus)), ddtestcd = "SECDTH",ddtest="Secondary Cause of Death", ddorres =seccaus),
)
 
dd02 <- dd01 %>%
 mutate(
 usubjid = paste("MYCSG", subject, sep = '-'),
 studyid = "MYCSG",
 domain = "DD",
 dddtc = ifelse(!is.na(dddat), format(as.Date(dddat, format = "%d/%b/%Y"),"%Y-%m-%d"), NA),
 ddstresc=ddorres
 )
 
# Calculate study day
dd03 <- dd02 %>%
 left_join(dm %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = ifelse(!is.na(rfstdtc), as.Date(rfstdtc, format = "%Y-%m-%d"), NA),
 dddt = ifelse(!is.na(dddtc), as.Date(dddtc, format = "%Y-%m-%d"), NA),
 dddy = ifelse(!is.na(rfstdt) & !is.na(dddt), dddt - rfstdt + (dddt >= rfstdt), NA_real_)
 )
 
# Create DDSEQ variable
dd04 <- dd03 %>%
 arrange(usubjid, ddtestcd, dddtc) %>%
 group_by(usubjid) %>%
 mutate(ddseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Select the required variables and order them
ddvarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "DDSEQ", "DDTESTCD", "DDTEST", "DDORRES", "DDSTRESC",
 "DDDTC", "DDDY", "PRCDTHSP"
)
 
dd <- dd04 %>%
 select(all_of(ddvarlist))
 
output <- dd
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================