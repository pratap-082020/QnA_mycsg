# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_EG_LCSG001
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
 
 
source("./SDTM_EG_LCSG001_data.r")
 
# Read input datasets
ecg01 <- ecg
dm01 <- dm
se01 <- se
sv01 <- sv
 
# Reorganize the data collected to present the information as a result of a test code
 
eg01 <- bind_rows(
 mutate(ecg01, egtestcd = "HR", egtest="Heart Rate",egorres = hr_raw, egorresu=ifelse(!is.na(egorres),"beats/min","") ),
 mutate(ecg01, egtestcd = "PR", egtest="PR Interval",egorres = pr_raw, egorresu=ifelse(!is.na(egorres),"msec","") ),
 mutate(ecg01, egtestcd = "QT", egtest="QT Interval",egorres = qt_raw, egorresu=ifelse(!is.na(egorres),"msec","") ),
 mutate(ecg01, egtestcd = "QRS", egtest="QRS Interval",egorres = qrs_raw, egorresu=ifelse(!is.na(egorres),"msec","") ),
 mutate(ecg01, egtestcd = "QTC", egtest="QT Interval Corrected",egorres = qtc_raw, egorresu=ifelse(!is.na(egorres),"msec","") ),
 mutate(ecg01, egtestcd = "INTP", egtest="Interpretation",
 egorres = case_when(
 egintp %in% c("Abnormal Not Clinically Significant", "Abnormal Clinically Significant") ~ "ABNORMAL",
 egintp == "Normal" ~ "NORMAL",
 TRUE ~ ""
 ),
 egclsig = case_when(
 egintp == "Abnormal Clinically Significant" ~ "Y",
 egintp == "Abnormal Not Clinically Significant" ~ "N",
 TRUE ~ ""
 )
 )
 
 
 )
eg02 <- eg01 %>%
 mutate(
 studyid = study,
 domain = "EG",
 usubjid = paste(study, pt, sep = '-'),
 egdtc = format(as.Date(egdt_raw, format = "%d/%b/%Y"),"%Y-%m-%d"),
 egcat = "ECG",
 egstresc = egorres,
 egstresu = egorresu,
 egstresn = suppressWarnings(as.numeric(egorres)),
 egstat = if_else(is.na(egorres), "NOT DONE", ""),
 )
 
# Create study day variable
eg03 <- eg02 %>%
 left_join(dm01 %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"),
 egdt = as.Date(substr(egdtc, 1, 10), format = "%Y-%m-%d"),
 egdy = as.numeric(if_else(!is.na(rfstdt) & !is.na(egdt), egdt - rfstdt + (egdt >= rfstdt), NA))
 )
 
# Create VISITNUM and VISIT variables
eg04 <- eg03 %>%
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
uns01 <- filter(eg04, visit == "UNSCHEDULED")%>%
 select(-visitnum,-visit)
sched01 <- filter(eg04, visit != "UNSCHEDULED")
 
uns02 <- uns01 %>%
 left_join(sv01 %>% select(usubjid, svstdtc, svendtc, visitnum, visit),
 by = c("usubjid" = "usubjid", "egdtc"="svstdtc"))
 
 
eg05 <- bind_rows(uns02, sched01)
 
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
 
eg06 <- eg05 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(egdtc) == 10 & (ss <= egdtc) & ((egdtc < st) | st == "") ~ "SCREENING",
 nchar(egdtc) == 10 & (st <= egdtc) & ((egdtc < sf) | sf == "") ~ "TREATMENT",
 nchar(egdtc) == 10 & (egdtc > sf) ~ "FOLLOW-UP",
 nchar(egdtc) == 7 & (ss7 < egdtc) & ((egdtc < st7) | st == "") ~ "SCREENING",
 nchar(egdtc) == 7 & (st7 < egdtc) & ((egdtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(egdtc) == 7 & (egdtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create baseline flag
base01 <- eg06 %>%
 filter(!is.na(egorres) & "" <= egdtc & egdtc <= rfstdtc) %>%
 arrange(usubjid,egtestcd,egdtc)
 
base02 <- base01 %>%
 group_by(usubjid, egtestcd) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(egblfl="Y")
 
eg08 <- eg06 %>%
 left_join(base02 %>% select(usubjid, egtestcd, egdtc, egblfl), by = c("usubjid", "egtestcd", "egdtc"))
 
# Create egSEQ variable
eg09 <- eg08 %>%
 arrange(usubjid, egcat, egtestcd, egdtc) %>%
 group_by(usubjid) %>%
 mutate(egseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Select the required variables and order them
egvarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "EGSEQ", "EGTESTCD", "EGTEST", "EGCAT", "EGORRES",
 "EGORRESU", "EGSTRESC", "EGSTRESN", "EGSTRESU", "EGSTAT", "EGMETHOD", "EGBLFL", "VISITNUM",
 "VISIT", "EPOCH", "EGDTC", "EGDY", "EGCLSIG"
)
 
eg10 <- eg09 %>%
 select(all_of(egvarlist))
 
output <- eg10
 
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================