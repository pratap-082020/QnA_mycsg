# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADRS_L1101
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
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
library(lubridate)
library(pharmaRTF)
 
 
source("./ADaM_ADRS_L1101_data.r")
 
 
#==============================================================================;
# Bring TRTSDT from ADSL into RS
#==============================================================================;
 
adsl01 <- adsl %>%
 select(usubjid, trtsdt) %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"))
 
adrs01 <- rs %>%
 left_join(adsl01, by = "usubjid")
 
#==============================================================================;
# Create variables directly based on source variables for source parameters
#==============================================================================;
 
adrs02 <- adrs01 %>%
 mutate(
 paramcd = rstestcd,
 param = case_when(
 paramcd == 'TRGRESP' ~ 'Target Response',
 paramcd == 'NTRGRESP' ~ 'Non-target Response',
 paramcd == 'NEWLPROG' ~ 'New Lesion Progression',
 paramcd == 'OVRLRESP' ~ 'Overall Response'
 ),
 paramn = case_when(
 paramcd == 'TRGRESP' ~ 1,
 paramcd == 'NTRGRESP' ~ 2,
 paramcd == 'NEWLPROG' ~ 3,
 paramcd == 'OVRLRESP' ~ 4
 ),
 adt = as.Date(rsdtc, format = "%Y-%m-%d"),
 ady = ifelse(!is.na(adt) & !is.na(trtsdt), ifelse(adt >= trtsdt, adt - trtsdt + 1, adt - trtsdt), NA),
 avalc = rsstresc,
 avisitn = visitnum,
 avisit = visit,
 tempresn = case_when(
 paramcd == "OVRLRESP" & !is.na(avalc) ~ match(avalc, c("CR", "PR", "SD", "PD", "NE")),
 TRUE ~ NA
 )
 ) %>%
 select(studyid, usubjid, paramcd, param, paramn, adt, ady, avisitn, avisit, avalc, tempresn)
 
#==============================================================================;
# Create the derived parameter BESTRESP
#==============================================================================;
 
bestresp01 <- adrs02 %>%
 filter(paramcd == "OVRLRESP" & !is.na(tempresn)) %>%
 arrange(usubjid, tempresn, adt)
 
bestresp02 <- bestresp01 %>%
 group_by(usubjid) %>%
 filter(row_number() == 1) %>%
 mutate(
 paramcd = "BESTRESP",
 param = "Best Overall Response",
 paramn = 5
 )
 
#==============================================================================;
# Combine source and derived parameter records
#==============================================================================;
 
adrs03 <- bind_rows(adrs02, bestresp02) %>%
 select(-tempresn)%>%
 arrange(usubjid, paramn, adt) %>%
 rename_all(toupper)
 
#==============================================================================;
# Keep only required variables
#==============================================================================;
 
varlist <- c("STUDYID", "USUBJID", "PARAM", "PARAMCD", "PARAMN", "ADT", "ADY", "AVISIT", "AVISITN", "AVALC")
 
adrs <- adrs03 %>%
 select(all_of(varlist))
 
output<-adrs
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================