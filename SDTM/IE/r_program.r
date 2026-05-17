# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_IE_L101
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
 
 
source("./SDTM_IE_L101_data.r")
 
 
# Read input datasets
eligcrit01 <- eligcrit
dm01 <- dm
se01 <- se
 
# Reorganize the data collected to present the information as a result of a test code
 
ie01 <- bind_rows(
 mutate(eligcrit01 %>% filter(str_to_upper(icrit01)=="NO"), iecat="INCLUSION", ietestcd = "INCL01",ieorres = "N",iestresc=ieorres),
 mutate(eligcrit01 %>% filter(str_to_upper(icrit02)=="NO"), iecat="INCLUSION", ietestcd = "INCL02", ieorres = "N", iestresc=ieorres),
 mutate(eligcrit01 %>% filter(str_to_upper(ecrit01)=="YES"), iecat="EXCLUSION", ietestcd = "EXCL01", ieorres = "Y", iestresc=ieorres),
 
)
 
 
ie02 <- ie01 %>%
 mutate(
 studyid = "MYCSG",
 domain = "IE",
 usubjid = paste(studyid, subject, sep = '-'),
 iespid = ifelse(!is.na(recordposition), sprintf("%03d", recordposition), NA),
 iedtc = format(as.Date(iedat, format = "%d/%b/%Y"),"%Y-%m-%d"),
 ietest = case_when(
 ietestcd=="INCL01"~"Inclusion criteria 1",
 ietestcd=="INCL02"~"Inclusion criteria 2",
 ietestcd=="EXCL01"~"Exclusion criteria 1",
 TRUE ~ ""
 
 )
 )
 
# Create study day variable
ie03 <- ie02 %>%
 left_join(dm01 %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"),
 iedt = as.Date(substr(iedtc, 1, 10), format = "%Y-%m-%d"),
 iedy = as.numeric(if_else(!is.na(rfstdt) & !is.na(iedt), iedt - rfstdt + (iedt >= rfstdt), NA))
 )
 
# Create VISITNUM and VISIT variables
ie04 <- ie03 %>%
 mutate(
 visit = str_to_upper(foldername),
 visitnum = folderseq
 )
 
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
 
ie05 <- ie04 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(iedtc) == 10 & (ss <= iedtc) & ((iedtc < st) | st == "") ~ "SCREENING",
 nchar(iedtc) == 10 & (st <= iedtc) & ((iedtc < sf) | sf == "") ~ "TREATMENT",
 nchar(iedtc) == 10 & (iedtc > sf) ~ "FOLLOW-UP",
 nchar(iedtc) == 7 & (ss7 < iedtc) & ((iedtc < st7) | st == "") ~ "SCREENING",
 nchar(iedtc) == 7 & (st7 < iedtc) & ((iedtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(iedtc) == 7 & (iedtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create ieSEQ variable
ie06 <- ie05 %>%
 arrange(usubjid, ietestcd, iedtc) %>%
 group_by(usubjid) %>%
 mutate(ieseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Define a character vector with variable names
# Define the variable list
ievarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "IESEQ", "IESPID", "IETESTCD",
 "IETEST", "IECAT", "IEORRES", "IESTRESC", "VISITNUM", "VISIT",
 "EPOCH", "IEDTC", "IEDY"
)
 
# Create the 'ie' data frame
ie <- ie06 %>%
 select(all_of(ievarlist))
 
output <- ie
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================