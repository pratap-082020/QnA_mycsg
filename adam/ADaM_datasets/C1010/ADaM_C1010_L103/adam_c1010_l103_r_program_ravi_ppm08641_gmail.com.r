# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L103
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
 
 
source("./ADaM_C1010_L103_data.r")
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
vs01<-vs %>%
 mutate(adt=as.Date(adt,origin="1960-01-01"),
 trtsdt=as.Date(trtsdt,origin="1960-01-01"))
 
#==============================================================================;
#Create full template of visits;
#==============================================================================;
 
template01 <- vs01 %>% distinct(usubjid, paramn) %>%
 select(usubjid, paramn)
 
param_visit <- tibble(
 paramn = rep(c(1, 6), times = c(5, 4)),
 avisitn = c(1:5, c(12, 24, 36, 48))
)
 
 
template02 <- template01 %>%
 full_join(param_visit,by=c("paramn")) %>%
 mutate(
 avisit = paste0("Week ", as.character(avisitn))
 )
 
#==============================================================================;
#Create a variable to hold a unique sequence for each record;
#==============================================================================;
 
vs02<-vs01 %>% mutate(seq=row_number(),inb=1)
 
#==============================================================================;
#Merge template and actual data;
#==============================================================================;
 
 
#------------------------------------------------------------------------------;
#Retain the sequence onto the records coming from template dataset;
#------------------------------------------------------------------------------;
 
 
template03 <- full_join(template02, vs02, by = c("usubjid", "paramn", "avisitn", "avisit")) %>%
 select(usubjid, seq, avisitn, avisit, paramn, adt,inb) %>%
 arrange(usubjid, paramn, avisitn, is.na(adt), adt) %>%
 group_by(usubjid,paramn) %>%
 fill(seq, .direction = "down") %>%
 ungroup() %>%
 select(usubjid,paramn,avisitn,avisit,seq,inb)
 
 
#==============================================================================;
#Merge the template created with data present based on sequence created;
#==============================================================================;
 
vs03 <- left_join(template03, vs02 %>% select(-avisitn, -avisit, -inb),
 by = c("usubjid", "paramn", "seq"))  %>%
 mutate(dtype = if_else(is.na(inb) & !is.na(aval), "LOCF", ""))
 
output <- vs03 %>%
 select(usubjid, paramcd, param, paramn, avisitn, avisit, adt, ady, aval, dtype, trtsdt)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================