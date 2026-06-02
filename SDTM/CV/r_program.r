# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_CV_L101
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
 
 
source("./SDTM_CV_L101_data.r")
 
 
# Create separate records for each test collected
cv01 <- bind_rows(
 mutate(echo %>% filter(echo_yn=="Yes"), cvtestcd = "LVEF", cvtest="Left Ventricular Ejection Fraction",cvorres = lvef, ),
 mutate(echo %>% filter(echo_yn=="Yes"), cvtestcd = "RVEF_E",cvtest="Right Ventricular Ejection Fraction, Est", cvorres = rvef, ),
 mutate(echo %>% filter(echo_yn=="No"), cvtestcd = "CVALL",cvtest="Cardiovascular Test Results", cvorres = "",cvstat="NOT DONE",cvreasnd="Not Collected"),
)
 
#==============================================================================;
#Create other common variables;
#==============================================================================;
 
cv02<-cv01 %>%
 mutate(
 usubjid = paste("MYCSG", subject, sep = '-'),
 studyid = "MYCSG",
 domain = "CV",
 cvspid = if_else(!is.na(recordposition), str_pad(recordposition, width = 3, pad = "0"), NA_character_),
 cvcat = "ECHOCARDIOGRAM",
 cvmethod = "ECHOCARDIOGRAM",
 cvdtc = ifelse(!is.na(echodat), as.Date(echodat, format = "%Y-%m-%d"), NA),
 cvstresc=cvorres,
 cvorresu=if_else(cvtestcd %in% c("LVEF","RVEF_E") & cvorres !="","%",""),
 cvstat=if_else(cvtestcd %in% c("LVEF","RVEF_E") & cvorres =="","NOT DONE",cvstat),
 cvreasnd=if_else(cvtestcd %in% c("LVEF","RVEF_E") & cvorres =="","Not Collected",cvreasnd,cvreasnd),
 cvstresu=cvorresu,
 cvstresn=as.numeric(cvstresc),
 cvdtc=format(as.Date(echodat,format="%d/%b/%Y"),format="%Y-%m-%d")
 )
 
 
# Get RFSTDTC from DM into CV01 dataset
cv03 <- cv02 %>%
 left_join(dm %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = ifelse(!is.na(rfstdtc), as.Date(rfstdtc, format = "%Y-%m-%d"), NA),
 cvdt = ifelse(!is.na(cvdtc), as.Date(cvdtc, format = "%Y-%m-%d"), NA),
 cvdy = ifelse(!is.na(rfstdt) & !is.na(cvdt), cvdt - rfstdt + (cvdt >= rfstdt), NA_real_)
 )
 
# Create VISITNUM and VISIT
cv04 <- cv03 %>%
 mutate(
 visitnum = folderseq,
 visit = toupper(foldername)
 )
 
# Separate scheduled and unscheduled records
sched01 <- cv04 %>%
 filter(!grepl("UNSCHEDULED", visit, ignore.case = TRUE))
 
unsched01 <- cv04 %>%
 filter(grepl("UNSCHEDULED", visit, ignore.case = TRUE))
 
# Join with SV to fetch the sequenced unscheduled visit number
unsched02 <- left_join(unsched01 %>% select(-visitnum, -visit),
 select(sv,usubjid,svstdtc,visitnum, visit),
 by = c("usubjid", "cvdtc" = "svstdtc"))
 
# Combine the datasets
cv05 <- bind_rows(sched01, unsched02)
 
# Process SE dataset to combine start date and end date of each epoch onto a single record
 
# Derive EPOCH variable
se01 <- se %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1))) %>%
 arrange(usubjid, short)
 
# Process SE dataset to combine start date and end date of each epoch onto a single record
epochstart <- se01 %>%
 pivot_wider(names_from = short, values_from = sestdtc, id_cols = c(usubjid), names_prefix = "s", values_fill = "")
 
epochend <- se01 %>%
 pivot_wider(names_from = short, values_from = seendtc, id_cols = c(usubjid), names_prefix = "e", values_fill = "")
 
epochdates <- left_join(epochstart, epochend, by = "usubjid")
 
# Compare cvdtc with each epoch's start and end dates and assign the epoch value
cv07 <- cv05 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(cvdtc) == 10 & (ss <= cvdtc) & ((cvdtc < st) | st == "") ~ "SCREENING",
 nchar(cvdtc) == 10 & (st <= cvdtc) & ((cvdtc < sf) | sf == "") ~ "TREATMENT",
 nchar(cvdtc) == 10 & (cvdtc > sf) ~ "FOLLOW-UP",
 nchar(cvdtc) == 7 & (ss7 < cvdtc) & ((cvdtc < st7) | st == "") ~ "SCREENING",
 nchar(cvdtc) == 7 & (st7 < cvdtc) & ((cvdtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(cvdtc) == 7 & (cvdtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create baseline flag
base01 <- cv07 %>%
 filter(cvdtc > "" & cvdtc <= rfstdtc & !is.na(cvorres))
 
base02 <- base01 %>%
 group_by(usubjid, cvtestcd) %>%
 filter(row_number() == n()) %>%
 mutate(cvblfl="Y")
 
cv08 <- cv07 %>%
 left_join(base02 %>% select(usubjid, cvtestcd, cvdtc, cvblfl), by = c("usubjid", "cvtestcd", "cvdtc"))
 
# Create cvSEQ variable
cv09 <- cv08 %>%
 arrange(usubjid, cvcat, cvtestcd, cvdtc) %>%
 group_by(usubjid) %>%
 mutate(cvseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Select the required variables and order them
cvvarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "CVSEQ", "CVSPID", "CVTESTCD", "CVTEST", "CVCAT",
 "CVORRES", "CVORRESU", "CVSTRESC", "CVSTRESN", "CVSTRESU", "CVSTAT", "CVREASND", "CVMETHOD",
 "CVBLFL", "VISITNUM", "VISIT", "EPOCH", "CVDTC", "CVDY"
)
 
cv <- cv09 %>%
 select(all_of(cvvarlist))
 
 
output <- cv
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================