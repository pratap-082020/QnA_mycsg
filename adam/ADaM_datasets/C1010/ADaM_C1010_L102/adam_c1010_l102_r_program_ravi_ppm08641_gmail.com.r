# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L102
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
 
 
source("./ADaM_C1010_L102_data.r")
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
vs01<-vs %>%
 mutate(adt=as.Date(adt,origin="1960-01-01"),
 trtsdt=as.Date(trtsdt,origin="1960-01-01"))
 
#==============================================================================;
#Create full template of visits;
#==============================================================================;
 
template01 <- distinct(vs01, usubjid, paramn) %>%
 select(usubjid, paramn)
 
template02 <- template01 %>%
 cross_join(tibble(avisitn=1:5)) %>%
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
 
 
template02 <- template02 %>%
 arrange(usubjid, paramn, avisitn)
 
template03 <- left_join(template02, vs02, by = c("usubjid", "paramn", "avisitn", "avisit")) %>%
 mutate(dtype = if_else(is.na(inb), "LOCF", "")) %>%
 select(usubjid, seq, dtype, avisitn, avisit, paramn, adt)
 
template03 <- template03 %>%
 arrange(usubjid, paramn, avisitn, adt)
 
template04 <- template03 %>%
 rename(old_seq=seq) %>%
 group_by(usubjid, paramn) %>%
 mutate(check=row_number(),seq = if_else(row_number()==1, NA, old_seq)) %>%
 fill(seq, .direction = "down") %>%
 ungroup() %>%
 mutate(seq=if_else(is.na(seq),old_seq,seq)) %>%
 select(usubjid,dtype,avisitn,avisit,seq)
 
#==============================================================================;
#Merge the template created with data present based on sequence created;
#==============================================================================;
 
vs03 <- left_join(template04, vs02 %>% select(-avisitn, -avisit), by = c("usubjid", "seq"))
 
output <- vs03 %>%
 select(usubjid, paramcd, param, paramn, avisitn, avisit, adt, ady, aval, dtype, trtsdt)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================