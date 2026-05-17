# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_QS_LEQ5D3L
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
 
 
source("./SDTM_QS_LEQ5D3L_data.r")
 
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
qs01 <- eq5d3l
dm01 <- dm
 
#==============================================================================;
#Create required variables in QS;
#==============================================================================;
qs02 <- bind_rows(
 mutate(qs01, qstestcd = "EQ5D0101", qsorres = word(eq5d3l_1, 2, sep = "-"), qsstresc = word(eq5d3l_1, 1, sep = "-")),
 mutate(qs01, qstestcd = "EQ5D0102", qsorres = substr(eq5d3l_2, 3,nchar(eq5d3l_2)), qsstresc = word(eq5d3l_2, 1, sep = "-")),
 mutate(qs01, qstestcd = "EQ5D0103", qsorres = word(eq5d3l_3, 2, sep = "-"), qsstresc = word(eq5d3l_3, 1, sep = "-")),
 mutate(qs01, qstestcd = "EQ5D0104", qsorres = word(eq5d3l_4, 2, sep = "-"), qsstresc = word(eq5d3l_4, 1, sep = "-")),
 mutate(qs01, qstestcd = "EQ5D0105", qsorres = word(eq5d3l_5, 2, sep = "-"), qsstresc = word(eq5d3l_5, 1, sep = "-")),
 mutate(qs01, qstestcd = "EQ5D0106", qsorres = eq5d3l_6, qsstresc = eq5d3l_6)
) %>%
 mutate(
 studyid = "MYCSG",
 domain = "QS",
 usubjid = paste(studyid, subject, sep = "-"),
 qsdtc = ifelse(qsdat_raw != "", format(as.Date(qsdat_raw, format = "%d %b %Y"), "%Y-%m-%d"), ""),
 qscat = "EQ-5D-3L",
 qsevintx = "TODAY",
 qseval = "STUDY SUBJECT",
 visitnum = folderseq,
 visit = foldername,
 qsstresn = suppressWarnings(as.numeric(qsstresc)),
 qsorresu = "",
 qsstresu = ""
 )
 
 
#==============================================================================;
#Create --LOBXFL;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Fetch RFXSTDTC into QS data;
#------------------------------------------------------------------------------;
 
qs03 <- qs02 %>%
 arrange(studyid, usubjid) %>%
 left_join(dm01 %>% select(studyid, usubjid, rfstdtc, rfxstdtc), by = c("studyid", "usubjid"))
 
 
#------------------------------------------------------------------------------;
#Filter qualifying records;
#------------------------------------------------------------------------------;
base01 <- qs03 %>%
 filter(qsdtc != "", qsdtc <= rfxstdtc, qsorres != "")
 
#------------------------------------------------------------------------------;
#Pick latest record;
#------------------------------------------------------------------------------;
base02 <- base01 %>%
 arrange(studyid, usubjid, qstestcd, qsdtc) %>%
 group_by(studyid, usubjid, qstestcd) %>%
 filter(row_number() == n()) %>%
 ungroup() %>%
 select(studyid, usubjid, qstestcd, qsdtc)
 
#------------------------------------------------------------------------------;
#populate --lobxfl on the timepoint identified above;
#------------------------------------------------------------------------------;
 
qs04 <- qs03 %>%
 left_join(base02 %>% mutate(qslobxfl = "Y"),
 by = c("studyid", "usubjid", "qstestcd", "qsdtc")) %>%
 mutate(qslobxfl = if_else(!is.na(qslobxfl), qslobxfl, ""))
 
 
 
#==============================================================================;
#Derive other dependent variables;
#==============================================================================;
qs05 <- qs04 %>%
 mutate(
 qstest = case_when(
 qstestcd == "EQ5D0101" ~ "EQ5D01-Mobility",
 qstestcd == "EQ5D0102" ~ "EQ5D01-Self-Care",
 qstestcd == "EQ5D0103" ~ "EQ5D01-Usual Activities",
 qstestcd == "EQ5D0104" ~ "EQ5D01-Pain/Discomfort",
 qstestcd == "EQ5D0105" ~ "EQ5D01-Anxiety/Depression",
 qstestcd == "EQ5D0106" ~ "EQ5D01-EQ VAS Score",
 TRUE ~ ""
 ),
 qsdt = as.Date(qsdtc, format = "%Y-%m-%d"),
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 qsdy = if_else(!is.na(qsdt) & !is.na(rfstdt), qsdt - rfstdt + (qsdt >= rfstdt), NA),
 qsdy=as.numeric(qsdy),
 qsdt = format(qsdt, "%Y-%m-%d"),
 rfstdt = format(rfstdt, "%Y-%m-%d")
 )
 
 
#==============================================================================;
#Create --SEQ variable;
#==============================================================================;
qs06 <- qs05 %>%
 arrange(studyid, usubjid, qstestcd, qsdtc) %>%
 group_by(studyid, usubjid) %>%
 mutate(qsseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
 
#==============================================================================;
#keep only required variables ;
#==============================================================================;
varlist <- c("STUDYID", "DOMAIN", "USUBJID", "QSSEQ", "QSTESTCD", "QSTEST", "QSCAT", "QSORRES", "QSORRESU",
 "QSSTRESC", "QSSTRESN", "QSSTRESU", "QSLOBXFL", "QSEVAL", "VISITNUM", "VISIT", "QSDTC", "QSDY", "QSEVINTX")
 
qs <- qs06 %>%
 select(all_of(varlist))
 
output <- qs
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================