# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1016_L101
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
 
 
source("./ADaM_C1016_L101_data.r")
 
 
#==============================================================================;
#Read input datasets;
#==============================================================================;
 
ae01 <- ae %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"))
 
#==============================================================================;
#Create ASTDT;
#==============================================================================;
 
 
ae02 <- ae01 %>%
 mutate(astdt = as.Date(aestdtc))
 
#==============================================================================;
#Create AOCCFL;
#==============================================================================;
 
ae03 <- ae02 %>%
 arrange(usubjid, desc(trtemfl), astdt) %>%
 group_by(usubjid) %>%
 mutate(aoccfl = if_else(row_number()==1 & trtemfl == "Y", "Y", "")) %>%
 ungroup()
 
#==============================================================================;
#Create AOCCSFL;
#==============================================================================;
 
ae04 <- ae03 %>%
 arrange(usubjid, aebodsys, desc(trtemfl), astdt) %>%
 group_by(usubjid, aebodsys) %>%
 mutate(aoccsfl = if_else(row_number()==1 & trtemfl == "Y", "Y", "")) %>%
 ungroup()
 
#==============================================================================;
#Create AOCCPFL;
#==============================================================================;
 
ae05 <- ae04 %>%
 arrange(usubjid, aebodsys, aedecod, desc(trtemfl), astdt) %>%
 group_by(usubjid, aebodsys, aedecod) %>%
 mutate(aoccpfl = if_else(row_number()==1& trtemfl == "Y", "Y", "")) %>%
 ungroup() %>%
 arrange(usubjid,aedecod,astdt)
 
#==============================================================================;
#Keep only required variables;
#==============================================================================;
 
output <- ae05 %>%
 select(usubjid, aedecod, aebodsys, astdt, trtemfl, aoccfl, aoccsfl, aoccpfl,
 trtsdt)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================