# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_VS_LCSG001
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
 
 
source("./SDTM_VS_LCSG001_data.r")
 
 
# Read input datasets
vitals01 <- vitals %>% mutate(vscat="VITAL SIGNS")
physmeas01 <- physmeas %>% rename(vsdt_raw=pmdt_raw) %>% mutate(vscat="PHYSICAL MEASUREMENTS")
dm01 <- dm
se01 <- se
sv01 <- sv
 
# Reorganize the data collected to present the information as a result of a test code
 
vs01 <- bind_rows(
 mutate(vitals01, vstestcd = "SYSBP",vsorres = sysbp_raw, vsorresu=ifelse(!is.na(vsorres),"mmHg",""),vsstresn=as.numeric(vsorres), vsstresc=vsorres, vsstresu=vsorresu, vspos=str_to_upper((pos)) ),
 mutate(vitals01, vstestcd = "DIABP", vsorres = diabp_raw, vsorresu=ifelse(!is.na(vsorres),"mmHg",""),vsstresn=as.numeric(vsorres), vsstresc=vsorres, vsstresu=vsorresu, vspos=str_to_upper((pos)) ),
 mutate(vitals01, vstestcd = "HR", vsorres = hr_raw, vsorresu=ifelse(!is.na(vsorres),"beats/min",""),vsstresn=as.numeric(vsorres), vsstresc=vsorres, vsstresu=vsorresu ),
 mutate(vitals01, vstestcd = "RESP", vsorres = resp_raw, vsorresu=ifelse(!is.na(vsorres)&vsorres!="","breaths/min",""),vsstresn=as.numeric(vsorres), vsstresc=vsorres, vsstresu=vsorresu ),
 mutate(vitals01, vstestcd = "TEMP", vsorres = temp_raw,
 vsorresu=substr(tempu,1,1),
 vsorresu=ifelse(!is.na(vsorres),vsorresu,""),
 vsstresn=case_when(
 vsorresu=="C"~as.numeric(vsorres),
 vsorresu=="F"~round((as.numeric(vsorres)-32)*5/9,2)
 ),
 vsstresu=ifelse(!is.na(vsstresn),"C",""),
 vsstresc=as.character(vsstresn),
 vsloc = str_to_upper(temploc)
 ),
 
 
 mutate(physmeas01, vstestcd = "HEIGHT", vsorres = height_raw,
 vsorresu=case_when(
 heightu=="Centimeters"~"cm",
 heightu=="Inches"~"in",
 TRUE ~ ""
 ),
 vsorresu=ifelse(!is.na(vsorres),vsorresu,""),
 vsstresn=case_when(
 vsorresu=="cm"~as.numeric(vsorres),
 vsorresu=="in"~round(as.numeric(vsorres)*2.54,2)
 ),
 vsstresu=ifelse(!is.na(vsstresn),"cm",""),
 vsstresc=as.character(vsstresn)
 ),
 
 mutate(physmeas01, vstestcd = "WEIGHT", vsorres = weight_raw,
 vsorresu=case_when(
 weightu=="Kilogram"~"kg",
 weightu=="Pound"~"lb",
 TRUE ~ ""
 ),
 vsorresu=ifelse(!is.na(vsorres),vsorresu,""),
 vsstresn=case_when(
 vsorresu=="kg"~as.numeric(vsorres),
 vsorresu=="lb"~round(as.numeric(vsorres)*2.2,2)
 ),
 vsstresu=ifelse(!is.na(vsstresn),"kg",""),
 vsstresc=as.character(vsstresn)
 )
 
 )
 
 
vs02 <- vs01 %>%
 mutate(
 studyid = study,
 domain = "VS",
 usubjid = paste(study, pt, sep = '-'),
 vsdtc = format(as.Date(vsdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"),
 vsstat = if_else(is.na(vsorres) | vsorres == "", "NOT DONE", ""),
 vstest = case_when(
 vstestcd=="SYSBP"~"Systolic Blood Pressure",
 vstestcd=="DIABP"~"Diastolic Blood Pressure",
 vstestcd=="HR"~"Heart Rate",
 vstestcd=="RESP"~"Respiratory Rate",
 vstestcd=="TEMP"~"Temperature",
 vstestcd=="HEIGHT"~"Height",
 vstestcd=="WEIGHT"~"Weight",
 TRUE ~ ""
 
 )
 )
 
# Create study day variable
vs03 <- vs02 %>%
 left_join(dm01 %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"),
 vsdt = as.Date(substr(vsdtc, 1, 10), format = "%Y-%m-%d"),
 vsdy = as.numeric(if_else(!is.na(rfstdt) & !is.na(vsdt), vsdt - rfstdt + (vsdt >= rfstdt), NA))
 )
 
# Create VISITNUM and VISIT variables
vs04 <- vs03 %>%
 mutate(
 visit = case_when(
 folder == "SCR" ~ "SCREENING",
 grepl("WEEK", folder, ignore.case = TRUE) ~ toupper(folder),
 grepl("^FU\\d+", folder, ignore.case = TRUE) ~ paste("FOLLOW-UP", gsub("^FU", "", folder)),
 grepl("^UNS_", folder) ~ "UNSCHEDULED"
 ),
 visitnum = case_when(
 folder == "SCR" ~ 1,
 grepl("WEEK", folder, ignore.case = TRUE) ~ 100 + as.numeric(gsub("\\D", "", folder)),
 grepl("^FU\\d+", folder, ignore.case = TRUE) ~ 200 + as.numeric(gsub("^FU", "", folder)),
 grepl("^UNS_", folder) ~ 999
 )
 )
 
# Remapping unscheduled visits using SV dataset
uns01 <- filter(vs04, visit == "UNSCHEDULED")%>%
 select(-visitnum,-visit)
sched01 <- filter(vs04, visit != "UNSCHEDULED")
 
uns02 <- uns01 %>%
 left_join(sv01 %>% select(usubjid, svstdtc, svendtc, visitnum, visit),
 by = c("usubjid" = "usubjid", "vsdtc"="svstdtc"))
 
 
vs05 <- bind_rows(uns02, sched01)
 
# EPOCH variable creation
se02 <- se01 %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1)))
 
epochstart <- se02 %>%
 select(usubjid, short, sestdtc) %>%
 pivot_wider(names_from = short, values_from = sestdtc, names_prefix = "s", values_fill = "")
 
epochend <- se02 %>%
 select(usubjid, short, seendtc) %>%
 pivot_wider(names_from = short, values_from = seendtc, names_prefix = "e", values_fill = "")
 
epochdates <- left_join(epochstart, epochend, by = "usubjid")
 
vs06 <- vs05 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(vsdtc) == 10 & (ss <= vsdtc) & ((vsdtc < st) | st == "") ~ "SCREENING",
 nchar(vsdtc) == 10 & (st <= vsdtc) & ((vsdtc < sf) | sf == "") ~ "TREATMENT",
 nchar(vsdtc) == 10 & (vsdtc > sf) ~ "FOLLOW-UP",
 nchar(vsdtc) == 7 & (ss7 < vsdtc) & ((vsdtc < st7) | st == "") ~ "SCREENING",
 nchar(vsdtc) == 7 & (st7 < vsdtc) & ((vsdtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(vsdtc) == 7 & (vsdtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create baseline flag
base01 <- vs06 %>%
 filter(!is.na(vsorres) & "" <= vsdtc & vsdtc <= rfstdtc) %>%
 arrange(usubjid,vstestcd,vsdtc)
 
base02 <- base01 %>%
 group_by(usubjid, vstestcd) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(vsblfl="Y")
 
vs08 <- vs06 %>%
 left_join(base02 %>% select(usubjid, vstestcd, vsdtc, vsblfl), by = c("usubjid", "vstestcd", "vsdtc"))
 
# Create vsSEQ variable
vs09 <- vs08 %>%
 arrange(usubjid, vscat, vstestcd, vsdtc) %>%
 group_by(usubjid) %>%
 mutate(vsseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Select the required variables and order them
vsvarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "VSSEQ", "VSTESTCD", "VSTEST", "VSCAT", "VSORRES",
 "VSORRESU", "VSSTRESC", "VSSTRESN", "VSSTRESU", "VSSTAT", "VSBLFL", "VISITNUM",
 "VISIT", "EPOCH", "VSDTC", "VSDY", "VSLOC", "VSPOS"
)
 
vs10 <- vs09 %>%
 select(all_of(vsvarlist))
 
output <- vs10
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================