# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_SV_LCSG001
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
 
 
source("./SDTM_SV_LCSG001_data.r")
 
 
# Read input datasets and keep relevant columns
ipadmin01 <- ipadmin %>%
 filter(!is.na(folder)) %>%
 select(study, pt, folder, ipstdt_raw) %>%
 rename(date = ipstdt_raw) %>%
 mutate(inputdataset="IPADMIN")
 
lab_chem01 <- lab_chem %>%
 filter(!is.na(folder)) %>%
 select(study, pt, folder, lbdt_raw) %>%
 rename(date = lbdt_raw)%>%
 mutate(inputdataset="LAB_CHEM")
 
lab_hema01 <- lab_hema %>%
 filter(!is.na(folder)) %>%
 select(study, pt, folder, lbdt_raw) %>%
 rename(date = lbdt_raw)%>%
 mutate(inputdataset="LAB_HEMA")
 
eq5d3l01 <- eq5d3l %>%
 filter(!is.na(folder)) %>%
 select(study, pt, folder, dt_raw) %>%
 rename(date = dt_raw) %>%
 mutate(inputdataset="EQ5D3L")
 
physmeas01 <- physmeas %>%
 filter(!is.na(folder)) %>%
 select(study, pt, folder, pmdt_raw) %>%
 rename(date = pmdt_raw) %>%
 mutate(inputdataset="PHYSMEAS")
 
vitals01 <- vitals %>%
 filter(!is.na(folder)) %>%
 select(study, pt, folder, vsdt_raw) %>%
 rename(date = vsdt_raw) %>%
 mutate(inputdataset="VITALS")
 
ecg01 <- ecg %>%
 filter(!is.na(folder)) %>%
 select(study, pt, folder, egdt_raw) %>%
 rename(date = egdt_raw) %>%
 mutate(inputdataset="ECG")
 
# Combine all date datasets into one
dates01 <- bind_rows(ipadmin01, lab_chem01, lab_hema01, eq5d3l01, physmeas01, vitals01, ecg01) %>%
 mutate(
 sdtmdomain = case_when(
 inputdataset %in% c("LAB_HEMA", "LAB_CHEM") ~ "LB",
 inputdataset == "EQ5D3L" ~ "QS",
 inputdataset %in% c("PHYSMEAS", "VITALS") ~ "VS",
 inputdataset == "ECG" ~ "EG",
 inputdataset == "IPADMIN" ~ "EC,EX"
 ),
 
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
 isodtc = str_c(year, month, day, sep = "-"),
 
 isodtc = ifelse(str_sub(isodtc, -5) == "-----", str_sub(isodtc, end = -6), isodtc),
 isodtc = ifelse(str_sub(isodtc, -4) == "----", str_sub(isodtc, end = -5), isodtc),
 isodtc = ifelse(str_sub(isodtc, -2) == "--", str_sub(isodtc, end = -3), isodtc)
 
 ) %>%
 select(-dayn, -monthc, -year)
 
# Create VISITNUM and VISIT variables
dates02 <- dates01 %>%
 mutate(
 visit = case_when(
 folder == "SCR" ~ "SCREENING",
 str_detect(folder, "WEEK") ~ toupper(folder),
 str_detect(folder, "^FU\\d+") ~ paste("FOLLOW-UP", str_remove(folder, "FU")),
 str_detect(folder, "^UNS_") ~ "UNSCHEDULED"
 ),
 visitnum = case_when(
 folder == "SCR" ~ 1,
 str_detect(folder, "WEEK") ~ 100 + as.numeric(str_remove_all(folder, "\\D")),
 str_detect(folder, "^FU\\d+") ~ 200 + as.numeric(str_remove(folder, "FU")),
 str_detect(folder, "^UNS_") ~ 999
 ),
 sdtmdomain2=ifelse(visitnum==999,sdtmdomain,"")
 )
 
#==============================================================================;
#Create one row per each date - concatenating sdtm domains into a single value;
#==============================================================================;
 
dates03 <- dates02 %>%
 distinct(study,pt,visitnum,visit,isodtc,sdtmdomain2)
 
dates04 <- dates03 %>%
 arrange(study,pt,visitnum,visit,isodtc,sdtmdomain2)
 
dates05 <- dates04 %>%
 group_by(study,pt,visitnum,visit,isodtc) %>%
 summarize(svupdes=paste(sdtmdomain2, collapse = ", ")) %>%
 ungroup()
 
#==============================================================================;
#Get the earliest and latest end dates in each visit and create SVUPDES variable
#==============================================================================;
 
 
svstdtc <- dates05 %>%
 arrange(study, pt, visitnum, visit, isodtc) %>%
 group_by(study, pt, visitnum, visit) %>%
 slice(1) %>%
 mutate(svstdtc=isodtc) %>%
 select(-isodtc,-svupdes)
 
svendtc <- dates05 %>%
 arrange(study, pt, visitnum, visit, isodtc) %>%
 group_by(study, pt, visitnum, visit) %>%
 slice(n()) %>%
 mutate(svendtc=isodtc) %>%
 select(-isodtc)
 
 
#==============================================================================;
# Combine start and end dates into a single dataset;
#==============================================================================;
 
sv01 <- left_join(svstdtc, svendtc, by = c("study", "pt", "visitnum", "visit"))
 
#==============================================================================;
#Remap unscheduled visit;
#==============================================================================;
 
sv02 <- sv01 %>%
 arrange(study,pt,visitnum,visit,svstdtc) %>%
 mutate(temp_visitnum=ifelse(visitnum!=999,visitnum,NA ),
 temp_visit=ifelse(visitnum!=999,visit,NA ))
 
sv03 <- sv02 %>%
 group_by(study,pt) %>%
 fill(temp_visitnum,.direction = "down") %>%
 fill(temp_visit,.direction = "down") %>%
 ungroup()
 
sv04 <- sv03 %>%
 arrange(study,pt,temp_visitnum,temp_visit,visitnum,visit,svstdtc) %>%
 group_by(study,pt,temp_visitnum,temp_visit) %>%
 mutate(seq1 = row_number(), seq2 = seq1-1, seq3 = seq2*0.01,
 orig_visitnum = visitnum,
 orig_visit = visit,
 visitnum = ifelse(seq2>0,temp_visitnum+seq3,visitnum),
 visit = ifelse(seq2>0,paste(temp_visit," ", "UNSCHEDULED", " ", sprintf("%02d",seq2)),visit)) %>%
 ungroup()
 
sv05 <- sv04 %>%
 mutate(
 studyid = study,
 domain = "SV",
 usubjid = paste(studyid,pt, sep = '-'),
 svstdt = as.Date(svstdtc,"%Y-%m-%d"),
 svendt = as.Date(svendtc,"%Y-%m-%d"),
 )
 
sv06 <- sv05 %>%
 left_join(dm %>% select(usubjid,rfstdtc), by='usubjid') %>%
 mutate(rfstdt=as.Date(rfstdtc,"%Y-%m-%d"),
 svstdy = ifelse(!is.na(rfstdt) & !is.na(svstdt), svstdt - rfstdt + as.numeric(svstdt >= rfstdt), NA),
 svendy = ifelse(!is.na(rfstdt) & !is.na(svendt), svendt - rfstdt + as.numeric(svendt >= rfstdt), NA)) %>%
 rename_all(toupper)
 
# Define the list of variables to keep
varlist <- c("STUDYID", "DOMAIN", "USUBJID", "VISITNUM", "VISIT", "SVSTDTC",
 "SVENDTC", "SVSTDY", "SVENDY", "SVUPDES")
 
# Create the sv dataset with selected columns
sv <- sv06 %>%
 select(all_of(varlist))
 
output <- sv
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================