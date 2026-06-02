# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_PR_L101
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/prme/dev/clinical_sas_samples/mycsg/mycsg_config.R")
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
 
 
source("./SDTM_PR_L101_data.r")
 
#==============================================================================;
#Read input datasets;
#==============================================================================;
 
transfusn01 <- transfusn
dm01 <- dm
se01 <- se
 
#==============================================================================;
#Create variables which are directly based on raw variables;
#==============================================================================;
 
pr01<-transfusn01 %>%
 mutate(
 studyid = "MYCSG",
 domain = "PR",
 usubjid = paste(studyid,subject, sep = "-"),
 prspid = ifelse(!is.na(recordposition),sprintf("%03d", recordposition),""),
 prcat = "TRANSFUSIONS",
 prstdate = ifelse(!is.na(prstdat),format(as.Date(prstdat,"%d/%b/%Y"),"%Y-%m-%d"),""),
 prsttime = format(as.POSIXct(prsttim, format = "%H:%M", tz = ""),"%H:%M"),
 prstdtc = paste(prstdate,prsttime, sep = "T"),
 
 prendate = ifelse(!is.na(prendat),format(as.Date(prendat,"%d/%b/%Y"),"%Y-%m-%d"),""),
 prentime = format(as.POSIXct(prentim, format = "%H:%M", tz = ""),"%H:%M"),
 prendtc = paste(prendate,prentime, sep = "T"),
 
 prtrt = prtrt,
 prdose = as.numeric(prvol),
 
 prdosu = ifelse(!is.na(prdose),prvolu,""),
 prindc = prreas
 
 )
 
 
# Calculate study days
pr02 <- pr01 %>%
 arrange(usubjid) %>%
 left_join(dm %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, "%Y-%m-%d"),
 prstdt = as.Date(prstdtc, "%Y-%m-%d"),
 prendt = as.Date(prendtc, "%Y-%m-%d"),
 prstdy = ifelse(!is.na(rfstdt) & !is.na(prstdt), prstdt - rfstdt + as.numeric(prstdt >= rfstdt), NA),
 prendy = ifelse(!is.na(rfstdt) & !is.na(prendt), prendt - rfstdt + as.numeric(prendt >= rfstdt), NA)
 )
 
# Create EPOCH variable
 
# EPOCH variable creation
se02 <- se %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1)))
 
epochstart <- se02 %>%
 select(usubjid, short, sestdtc) %>%
 pivot_wider(names_from = short, values_from = sestdtc, names_prefix = "s", values_fill = "")
 
epochend <- se02 %>%
 select(usubjid, short, seendtc) %>%
 pivot_wider(names_from = short, values_from = seendtc, names_prefix = "e", values_fill = "")
 
epochdates <- left_join(epochstart, epochend, by = "usubjid")
 
pr03 <- pr02 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(prstdate) == 10 & (ss <= prstdate) & ((prstdate < st) | st == "") ~ "SCREENING",
 nchar(prstdate) == 10 & (st <= prstdate) & ((prstdate < sf) | sf == "") ~ "TREATMENT",
 nchar(prstdate) == 10 & (prstdate > sf) ~ "FOLLOW-UP",
 nchar(prstdate) == 7 & (ss7 < prstdate) & ((prstdate < st7) | st == "") ~ "SCREENING",
 nchar(prstdate) == 7 & (st7 < prstdate) & ((prstdate < sf7) | sf == "") ~ "TREATMENT",
 nchar(prstdate) == 7 & (prstdate > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create prSEQ variable
pr04 <- pr03 %>%
 arrange(usubjid, prcat, prtrt, prstdtc, prendtc) %>%
 group_by(usubjid) %>%
 mutate(prseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Define the list of variable names
prvarlist <- c("STUDYID", "DOMAIN", "USUBJID", "PRSEQ", "PRSPID", "PRTRT",
 "PRCAT", "PRINDC", "PRDOSE", "PRDOSU", "EPOCH", "PRSTDTC",
 "PRENDTC", "PRSTDY", "PRENDY")
 
# Create a new data frame or tibble with the specified variable names
pr05 <- pr04 %>%
 select(all_of(prvarlist))
 
output <- pr05
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================