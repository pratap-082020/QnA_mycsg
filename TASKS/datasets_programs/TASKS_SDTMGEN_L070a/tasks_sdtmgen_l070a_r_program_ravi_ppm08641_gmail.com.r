# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L070a
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.R")
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
 
 
source("./TASKS_SDTMGEN_L070a_data.r")
 
#==============================================================================;
#Combine all the dataset which contain a date variable - once per variable;
#Rename the date variables to a common variable named date
#==============================================================================;
 
 
alldates01 <- bind_rows(
 adverse %>% select(study, pt, aestdt_raw) %>% rename(date = aestdt_raw),
 adverse %>% select(study, pt, aeendt_raw) %>% rename(date = aeendt_raw),
 conmeds %>% select(study, pt, cmstdt_raw) %>% rename(date = cmstdt_raw),
 conmeds %>% select(study, pt, cmendt_raw) %>% rename(date = cmendt_raw),
 ecg %>% select(study, pt, egdt_raw) %>% rename(date = egdt_raw),
 enrlment %>% select(study, pt, icdt_raw) %>% rename(date = icdt_raw),
 enrlment %>% select(study, pt, enrldt_raw) %>% rename(date = enrldt_raw),
 enrlment %>% select(study, pt, randdt_raw) %>% rename(date = randdt_raw),
 eos %>% select(study, pt, eostdt_raw) %>% rename(date = eostdt_raw),
 eoip %>% select(study, pt, eostdt_raw) %>% rename(date = eostdt_raw),
 ipadmin %>% select(study, pt, ipstdt_raw) %>% rename(date = ipstdt_raw),
 vitals %>% select(study, pt, vsdt_raw) %>% rename(date = vsdt_raw)
)
 
#==============================================================================;
#Convert date to ISO format using the custom function;
#==============================================================================;
 
 
alldates02<-alldates01 %>%
 mutate(
 date=str_replace_all(date,"/"," "),
 stdayn = suppressWarnings(as.numeric(word(date, 1))),
 stday = if_else(!is.na(stdayn), str_pad(stdayn, width = 2, pad = "0"), "-"),
 stmonthc = str_to_upper(word(date, 2)),
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
 styear = word(date,3),
 styear1 = if_else((styear == "UNK") | (is.na(styear)), "-", styear),
 dtc = str_c(styear1, stmonth, stday, sep = "-"),
 
 dtc = if_else(str_sub(dtc, -5) == "-----","",dtc),
 dtc = if_else(str_sub(dtc, -4) == "----",str_sub(dtc,end=-5),dtc),
 dtc = if_else(str_sub(dtc, -2) == "--",str_sub(dtc,end=-3),dtc)
 )
 
#==============================================================================;
#Sort the dataset based on subject and date and pick the last record;
#==============================================================================;
 
rfpendtc<-alldates02 %>%
 filter(!is.na(dtc),dtc!="")
 arrange(study,pt,dtc) %>%
 group_by(study,pt) %>%
 slice(n()) %>%
 rename(rfpendtc=dtc) %>%
 select(study,pt,rfpendtc)
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================