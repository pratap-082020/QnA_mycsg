# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_DM_LCSG001
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
 
 
source("./SDTM_DM_LCSG001_data.r")
 
#==============================================================================
# Read primary input datasets
#==============================================================================
demog01 <- demog
ipadmin01 <- ipadmin
eos01 <- eos
enrl01 <- enrlment
 
#==============================================================================
# Create the id variables and other variables which are directly dependent
# on raw variables without involving major derivations
#==============================================================================
dm01 <- demog %>%
 rename(race0 = race) %>%
 mutate(
 domain = "DM",
 studyid = study,
 subjid = pt,
 siteid = substr(pt, 1, 2),
 usubjid = paste(study, pt, sep = "-"),
 country = country,
 ethnic = toupper(ethnic),
 non_missing_count = rowSums(across(c(race0, race2, race3, race4), ~ !is.na(.) & . != "")),
 
 race = ifelse(non_missing_count > 1, "MULTIPLE", toupper(coalesce(race0, race2, race3, race4))),
 racesp = racesp,
 race1 = ifelse(non_missing_count > 1,toupper(race0),""),
 race2 = ifelse(non_missing_count > 1,toupper(race2),""),
 race3 = ifelse(non_missing_count > 1,toupper(race3),""),
 race4 = ifelse(non_missing_count > 1,toupper(race4),""),
 
 age = ifelse(!is.na(age_raw), as.integer(age_raw), NA_integer_),
 ageu = toupper(age_rawu),
 sex = ifelse(sex == "Female", "F", ifelse(sex == "Male", "M", sex))
 )
 
#==============================================================================;
# Derive disposition related variables
#==============================================================================;
 
rficdtc <- enrl01 %>%
 mutate(
 rficdtc = ifelse(!is.na(icdt_raw), format(as.Date(icdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"), NA),
 enrldtc = ifelse(!is.na(enrldt_raw), format(as.Date(enrldt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"), NA),
 randdtc = ifelse(!is.na(randdt_raw), format(as.Date(randdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"), NA)
 ) %>%
 select(study, pt, rficdtc, enrldtc, randdtc)
 
rfendtc <- eos01 %>%
 filter(eoscat == "End of Study") %>%
 mutate(rfendtc = ifelse(!is.na(eostdt_raw), format(as.Date(eostdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"), NA)) %>%
 select(study, pt, rfendtc)
 
dthdtc <- eos01 %>%
 filter(eoscat == "End of Study" & eoterm == "Death") %>%
 mutate(dthdtc = ifelse(!is.na(eostdt_raw), format(as.Date(eostdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"), NA), dthfl = "Y") %>%
 select(study, pt, dthdtc, dthfl)
 
#==============================================================================;
# Get Exposure Related Variables
#==============================================================================;
 
exp01 <- ipadmin01 %>%
 filter(as.integer(ipqty_raw) > 0) %>%
 mutate(
 ipstdtc = as.Date(ipstdt_raw, format = "%d/%b/%Y"),
 ipsttm = format(as.POSIXct(ipsttm_raw, format = "%H:%M", tz = ""),"%H:%M"),
 tempdtc = paste(ipstdtc, ipsttm, sep = "T")
 ) %>%
 select(study, pt, tempdtc, ipboxid)
 
#Earliest treatment date
rfxstdtc <- exp01 %>%
 arrange(study,pt,tempdtc) %>%
 group_by(study, pt) %>%
 slice(1) %>%
 mutate(rfxstdtc = tempdtc)
 
#Late treatment date
rfxendtc <- exp01 %>%
 arrange(study,pt,tempdtc) %>%
 group_by(study, pt) %>%
 slice(n()) %>%
 mutate(rfxendtc = tempdtc)
 
#==============================================================================;
# Derive Planned and Actual Arm related variables
#==============================================================================;
 
 
randno <- enrl01 %>%
 filter(!is.na(randno) & randno!="") %>%
 select(study, pt, randno)
 
rand01 <- rand %>%
 mutate(
 armcd = tx_cd,
 arm = ifelse(armcd == "ACTIVE", "Active", ifelse(armcd == "PBO", "Placebo", NA_character_))
 ) %>%
 select(armcd, arm, randno=rand_id)
 
armcd <- randno %>%
 left_join(rand01, by = "randno")
 
#==============================================================================;
#Derive actual related variable;
#==============================================================================;
 
actarmcd01 <- rfxstdtc
 
# Create 'box01' data frame
box01 <- box %>%
 mutate(
 ipboxid = kitid,
 actarmcd = case_when(
 content == "ACTIVE" ~ "ACTIVE",
 content == "PBO" ~ "PBO",
 TRUE ~ NA_character_
 ),
 actarm = case_when(
 content == "ACTIVE" ~ "Active",
 content == "PBO" ~ "Placebo",
 TRUE ~ NA_character_
 )
 )
 
# Merge 'actarmcd01' and 'box01' data frames by 'ipboxid'
actarmcd <- left_join(actarmcd01, box01, by = "ipboxid") %>%
 filter(!is.na(actarmcd)) %>%
 select(study, pt, actarmcd, actarm)
 
#==============================================================================;
#RFPENDTC;
#==============================================================================;
 
# Combine the raw date variables into 'alldates01' data frame
alldates01 <- bind_rows(
 adverse %>% select(study, pt, date = aestdt_raw),
 adverse %>% select(study, pt, date = aeendt_raw),
 adverse %>% select(study, pt, date = hadmtdt_raw),
 adverse %>% select(study, pt, date = hdsdt_raw),
 conmeds %>% select(study, pt, date = cmstdt_raw),
 conmeds %>% select(study, pt, date = cmendt_raw),
 ecg %>% select(study, pt, date = egdt_raw),
 enrlment %>% select(study, pt, date = icdt_raw),
 enrlment %>% select(study, pt, date = enrldt_raw),
 enrlment %>% select(study, pt, date = randdt_raw),
 eos %>% select(study, pt, date = eostdt_raw),
 eoip %>% select(study, pt, date = eostdt_raw),
 eq5d3l %>% select(study, pt, date = dt_raw),
 hosp %>% select(study, pt, date = stdt_raw),
 hosp %>% select(study, pt, date = endt_raw),
 ipadmin %>% select(study, pt, date = ipstdt_raw),
 lab_chem %>% select(study, pt, date = lbdt_raw),
 lab_hema %>% select(study, pt, date = lbdt_raw),
 physmeas %>% select(study, pt, date = pmdt_raw),
 surg %>% select(study, pt, date = surgdt_raw),
 vitals %>% select(study, pt, date = vsdt_raw)
)
 
 
# Process the date variables to create date in ISO format in 'alldates02' data frame
alldates02 <- alldates01 %>%
 mutate(
 
 dayn = as.numeric(word(date, 1, sep='/')),
 day = if_else(!is.na(dayn), sprintf("%02d", dayn), "-"),
 monthc = toupper(word(date, 2, sep='/')),
 month = case_when(
 monthc == "JAN" ~ "01",
 monthc == "FEB" ~ "02",
 monthc == "MAR" ~ "03",
 monthc == "APR" ~ "04",
 monthc == "MAY" ~ "05",
 monthc == "JUN" ~ "06",
 monthc == "JUL" ~ "07",
 monthc == "AUG" ~ "08",
 monthc == "SEP" ~ "09",
 monthc == "OCT" ~ "10",
 monthc == "NOV" ~ "11",
 monthc == "DEC" ~ "12",
 TRUE ~ "-"
 ),
 year = word(date,3,sep='/'),
 year = if_else(toupper(year) == "UNK", "-", year),
 datec = str_c(year, month, day, sep = "-"),
 
 datec = ifelse(str_sub(datec, -5) == "-----", str_sub(datec, end = -6), datec),
 datec = ifelse(str_sub(datec, -4) == "----", str_sub(datec, end = -5), datec),
 datec = ifelse(str_sub(datec, -2) == "--", str_sub(datec, end = -3), datec)
 
 )
 
# Pick the latest non-missing date for each subject
rfpendtc <- alldates02 %>%
 filter(!is.na(datec) & datec != "") %>%
 arrange(study, pt, datec) %>%
 group_by(study, pt) %>%
 slice(n()) %>%
 ungroup() %>%
 select(study, pt, rfpendtc = datec)
 
#==============================================================================;
# Merge all datasets together
#==============================================================================;
 
dm02 <- dm01 %>%
 left_join(rficdtc, by = c("study", "pt")) %>%
 left_join(dthdtc, by = c("study", "pt")) %>%
 left_join(rfendtc, by = c("study", "pt")) %>%
 left_join(rfxstdtc, by = c("study", "pt")) %>%
 left_join(rfxendtc, by = c("study", "pt")) %>%
 left_join(armcd, by = c("study", "pt")) %>%
 left_join(actarmcd, by = c("study", "pt")) %>%
 left_join(rfpendtc, by = c("study", "pt"))
 
#==============================================================================;
# Derive additional variables which are dependent on other derived variables
#==============================================================================;
 
dm03 <- dm02 %>%
 mutate(
 rfstdtc = substr(rfxstdtc, 1, 10),
 rfstdtc = ifelse(is.na(rfstdtc) & !is.na(randdtc), randdtc, rfstdtc),
 rfstdtc = ifelse(is.na(rfstdtc) & !is.na(rficdtc), rficdtc, rfstdtc),
 
 armcd = case_when(
 is.na(enrldtc) ~ "SCRNFAIL",
 is.na(randdtc) ~ "NOTASSGN",
 TRUE ~ armcd
 ),
 
 arm = case_when(
 armcd =="SCRNFAIL" ~ "Screen Failure",
 armcd == "NOTASSGN" ~ "Not Assigned",
 TRUE ~ arm),
 
 actarmcd = case_when(
 is.na(enrldtc) ~ "SCRNFAIL",
 is.na(randdtc) ~ "NOTASSGN",
 is.na(rfxstdtc) ~ "NOTTRT",
 TRUE ~ actarmcd
 ),
 
 actarm = case_when(
 actarmcd =="SCRNFAIL" ~ "Screen Failure",
 actarmcd == "NOTASSGN" ~ "Not Assigned",
 actarmcd == "NOTTRT" ~ "Not Treated",
 TRUE ~ actarm),
 
 ) %>%
 rename_all(toupper)
 
# Write attributes and keep only required variables and in the required order
varlist <- c(
 'STUDYID', 'DOMAIN', 'USUBJID', 'SUBJID', 'RFSTDTC', 'RFENDTC', 'RFXSTDTC', 'RFXENDTC',
 'RFICDTC', 'RFPENDTC', 'DTHDTC', 'DTHFL', 'SITEID', 'AGE', 'AGEU', 'SEX', 'RACE', 'ETHNIC',
 'ARMCD', 'ARM', 'ACTARMCD', 'ACTARM', 'COUNTRY', 'RACE1', 'RACE2', 'RACE3', 'RACE4', 'RACESP'
)
 
dm <- dm03 %>%
 select(all_of(varlist))
 
output <- dm
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================