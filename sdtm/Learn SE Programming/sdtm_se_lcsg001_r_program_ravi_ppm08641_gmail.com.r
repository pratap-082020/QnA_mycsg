# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_SE_LCSG001
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
 
 
source("./SDTM_SE_LCSG001_data.r")
 
# Read input datasets (replace with your actual data source)
dm01 <- dm
eos01 <- eos
eoip01 <- eoip
sv01 <- sv
 
# Create a dataset with one record per subject to hold all key date variables
# Keep the required date variables from sdtm.dm dataset
dm02 <- dm01 %>%
 mutate(
 rfxstdtc = substr(rfxstdtc, 1, 10),
 rfxendtc = substr(rfxendtc, 1, 10),
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d")
 ) %>%
 select(studyid, usubjid, rfstdtc, rfendtc, rfxstdtc, rfxendtc, rfpendtc, rficdtc, armcd, arm, actarmcd, actarm, rfstdt)
 
# Fetch eoip date
eoipdtc <- eoip01 %>%
 filter(str_to_upper(eoscat) == "END OF TREATMENT" & eostdt_raw != "") %>%
 mutate(
 eoipdtc = format(as.Date(eostdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"),
 usubjid = paste(study, pt, sep = "-")
 ) %>%
 select(usubjid, eoipdtc)
 
# Fetch eos date
eosdtc <- eos01 %>%
 filter(str_to_upper(eoscat) == "END OF STUDY" & eostdt_raw != "") %>%
 mutate(
 eosdtc = format(as.Date(eostdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"),
 usubjid = paste(study, pt, sep = "-")
 ) %>%
 select(usubjid, eosdtc)
 
# Fetch the earliest follow-up visit start date from sdtm SV
fup01 <- sv01 %>%
 filter(str_detect(visit, "FOLLOW")) %>%
 arrange(usubjid, svstdtc) %>%
 group_by(usubjid) %>%
 slice(1) %>%
 select(usubjid, fupdtc=svstdtc)
 
# Get the latest available date in SV for each subject
svlatest01 <- sv01 %>%
 arrange(usubjid, desc(svendtc)) %>%
 group_by(usubjid) %>%
 slice(1) %>%
 select(usubjid, svlatestdtc=svendtc)
 
# Merge all datasets such that required date variables are present on a single record
keydates01 <- dm02 %>%
 left_join(eoipdtc, by = "usubjid") %>%
 left_join(eosdtc, by = "usubjid") %>%
 left_join(fup01, by = "usubjid") %>%
 left_join(svlatest01, by = "usubjid") %>%
 mutate(
 across(
 c(rfxstdtc,rfstdtc,rfxendtc,rfendtc,rficdtc),
 ~ifelse(.=="",NA,.)
 )
 )
 
# Create records for elements using key date variables
# Screening Element
scr01 <- keydates01 %>%
 filter(!is.na(rficdtc)) %>%
 mutate(
 etcd = "SCR",
 element = "Screening",
 epoch = "SCREENING",
 sestdtc = substr(rficdtc, 1, 10),
 taetord = 1,
 seendtc = ifelse(!is.na(rfxstdtc), substr(rfxstdtc, 1, 10), substr(rfpendtc, 1, 10))
 ) %>%
 select(studyid, usubjid, etcd, element, taetord, epoch, sestdtc, seendtc)
 
# Element corresponding to treatment
trt01 <- keydates01 %>%
 filter(!is.na(rfxstdtc)) %>%
 mutate(
 etcd = armcd,
 element = arm,
 epoch = "TREATMENT",
 sestdtc = substr(rfxstdtc, 1, 10),
 taetord = 2,
 seendtc = ifelse(!is.na(eoipdtc), substr(eoipdtc, 1, 10), substr(svlatestdtc, 1, 10))
 ) %>%
 select(studyid, usubjid, etcd, element, taetord, epoch, sestdtc, seendtc)
 
# Follow-up element
fup01 <- keydates01 %>%
 filter(!is.na(fupdtc)) %>%
 mutate(
 etcd = "FUP",
 element = "Follow-up",
 epoch = "FOLLOW-UP",
 sestdtc = substr(eoipdtc, 1, 10),
 taetord = 2,
 seendtc = ifelse(!is.na(eosdtc), substr(eosdtc, 1, 10), substr(svlatestdtc, 1, 10))
 ) %>%
 select(studyid, usubjid, etcd, element, taetord, epoch, sestdtc, seendtc)
 
# Combine the datasets containing individual elements
se01 <- bind_rows(scr01, trt01) %>%
 mutate(
 domain = "SE",
 sestdt = as.Date(sestdtc, format = "%Y-%m-%d"),
 seendt = as.Date(seendtc, format = "%Y-%m-%d")
 ) %>%
 select(
 studyid, domain, usubjid, etcd, element, taetord, epoch,
 sestdtc, seendtc, sestdt, seendt
 )
 
# Derive SESEQ variable
se02 <- se01 %>%
 arrange(usubjid, taetord) %>%
 group_by(usubjid) %>%
 mutate(seseq = row_number())
 
# Create study day variables
se03 <- se02 %>%
 left_join(dm02 %>% select(usubjid, rfstdt), by = "usubjid") %>%
 mutate(
 sestdy = ifelse(!is.na(rfstdt) & !is.na(sestdt), as.numeric(sestdt - rfstdt + (sestdt >= rfstdt)), NA),
 seendy = ifelse(!is.na(rfstdt) & !is.na(seendt), as.numeric(seendt - rfstdt + (seendt >= rfstdt)), NA)
 ) %>%
 rename_all(toupper)
 
# Assign variable attributes and keep the required variables
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "SESEQ", "ETCD", "ELEMENT", "TAETORD",
 "EPOCH", "SESTDTC", "SEENDTC", "SESTDY", "SEENDY"
)
 
se04 <- se03 %>%
 select(all_of(varlist))
 
output<-se04
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================