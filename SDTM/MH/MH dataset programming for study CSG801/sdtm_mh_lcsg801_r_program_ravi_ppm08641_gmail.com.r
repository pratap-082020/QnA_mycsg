# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_MH_LCSG801
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
 
 
source("./SDTM_MH_LCSG801_data.r")
 
 
library(dplyr)
 
# Load the input datasets (replace with your actual data sources)
mh_1 <- mh801_1
mh_2 <- mh801_2
mh_3 <- mh801_3
dm01 <- dm
 
# Combine information from three raw datasets
mh01 <- bind_rows(
 mh_1 %>% mutate(source = "MH801_1"),
 mh_2 %>% mutate(source = "MH801_2"),
 mh_3 %>% mutate(source = "MH801_3")
) %>%
 mutate(
 studyid = study,
 usubjid = paste(studyid, pt, sep = "-"),
 domain = "MH",
 repeatnum = ifelse(is.na(repeatnum), 1, repeatnum),
 mhrefid = paste(source, sprintf("%03d", repeatnum), sep = "-"),
 mhdtc = ifelse(mhdat != "", paste(substr(mhdat, 1, 4), substr(mhdat, 5, 6), substr(mhdat, 7, 8), sep = "-"),""),
 mhstdtc = ifelse(mhstdat != "", paste(substr(mhstdat, 1, 4), substr(mhstdat, 5, 6), substr(mhstdat, 7, 8), sep = "-"),""),
 mhendtc = ifelse(mhendat != "", paste(substr(mhendat, 1, 4), substr(mhendat, 5, 6), substr(mhendat, 7, 8), sep = "-"),""),
 mhterm = ifelse(source == "MH801_1", str_to_upper(mhterm),mhterm),
 mhcat = ifelse(source == "MH801_1"|source == "MH801_2", "DIABETES", "GENERAL"),
 mhscat = ifelse(source == "MH801_2", "COMPLICATIONS",""),
 mhpresp = ifelse(source == "MH801_1" | source=="MH801_2", "Y", NA),
 mhoccur = ifelse(source == "MH801_1","Y",mhoccur),
 
 mhenrtpt = case_when(
 source == "MH801_1"~ "ONGOING",
 source == "MH801_2" & mhoccur=='Y'~ "ONGOING",
 source == "MH801_3" & mhongo=='Yes'~ "ONGOING",
 TRUE ~ ""
 ),
 mhentpt = case_when(
 source == "MH801_1" ~ mhdtc,
 source == "MH801_2" & mhoccur=="Y" ~ mhdtc,
 source == "MH801_3" & mhongo=='Yes'~ mhdtc,
 TRUE ~ ""
 ),
 
 mhstdtc = ifelse(str_sub(mhstdtc, -5) == "-----", str_sub(mhstdtc, end = -6), mhstdtc),
 mhstdtc = ifelse(str_sub(mhstdtc, -4) == "----", str_sub(mhstdtc, end = -5), mhstdtc),
 mhstdtc = ifelse(str_sub(mhstdtc, -2) == "--", str_sub(mhstdtc, end = -3), mhstdtc),
 mhstdtc = ifelse(str_sub(mhstdtc, -1) == "-", str_sub(mhstdtc, end = -2), mhstdtc),
 
 mhendtc = ifelse(str_sub(mhendtc, -5) == "-----", str_sub(mhendtc, end = -6), mhendtc),
 mhendtc = ifelse(str_sub(mhendtc, -4) == "----", str_sub(mhendtc, end = -5), mhendtc),
 mhendtc = ifelse(str_sub(mhendtc, -2) == "--", str_sub(mhendtc, end = -3), mhendtc),
 mhendtc = ifelse(str_sub(mhendtc, -1) == "-", str_sub(mhendtc, end = -2), mhendtc)
 )
 
# Create Study day variable
mh02 <- dm01 %>%
 inner_join(mh01, by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 mhdt = as.Date(mhdtc, format = "%Y-%m-%d"),
 mhstdt = as.Date(mhstdtc, format = "%Y-%m-%d"),
 mhendt = as.Date(mhendtc, format = "%Y-%m-%d"),
 mhdy = as.numeric(if_else(!is.na(rfstdt) & !is.na(mhdt), mhdt - rfstdt + (mhdt >= rfstdt), NA)),
 mhstdy = as.numeric(if_else(!is.na(rfstdt) & !is.na(mhstdt), mhstdt - rfstdt + (mhstdt >= rfstdt), NA)),
 mhstdy = as.numeric(if_else(!is.na(rfstdt) & !is.na(mhendt), mhendt - rfstdt + (mhendt >= rfstdt), NA))
 )
 
# Create sequence variable
mh03 <- mh02 %>%
 arrange(usubjid, mhterm, mhstdtc) %>%
 group_by(usubjid) %>%
 mutate(MHSEQ = row_number()) %>%
 rename_all(toupper)
 
# Assign variable attributes and keep only required variables
mhvarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "MHSEQ", "MHREFID", "MHTERM", "MHCAT", "MHSCAT",
 "MHPRESP", "MHOCCUR", "MHDTC",
 "MHSTDTC", "MHENDTC", "MHDY", "MHENRTPT", "MHENTPT"
)
 
mh04 <- mh03 %>%
 select(all_of(mhvarlist))
 
output <- mh04
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================