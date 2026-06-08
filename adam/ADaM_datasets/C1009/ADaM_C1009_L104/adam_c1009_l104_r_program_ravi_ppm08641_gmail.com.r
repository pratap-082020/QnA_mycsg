# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1009_L104
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
 
 
source("./ADaM_C1009_L104_data.r")
 
#==============================================================================
# Read input datasets
#==============================================================================
 
eg01 <- adeg %>%
 mutate(trtsdt=as.Date(trtsdt,origin="1960-01-01"),
 adt=as.Date(adt,origin="1960-01-01"))
 
#==============================================================================
# Populate baseline date on all records of a subject/parameter
#==============================================================================
 
#------------------------------------------------------------------------------
# Subset baseline records
#------------------------------------------------------------------------------
 
base01 <- eg01 %>%
 filter(ablfl == "Y") %>%
 mutate(basedt = as.Date(adt, format="%Y-%m-%d")) %>%
 select(studyid, usubjid, paramcd, basedt)
 
#------------------------------------------------------------------------------
# Populate baseline date on all records
#------------------------------------------------------------------------------
 
eg02 <- eg01 %>%
 left_join(base01, by = c("studyid", "usubjid", "paramcd"))
 
#==============================================================================
# Populate ANL02FL
#==============================================================================
 
eg03 <- eg02 %>%
 mutate(
 anl02fl = ifelse(adt > trtsdt & !is.na(trtsdt) & adt > basedt & !is.na(basedt), "Y", "")
 )
 
#==============================================================================
# Keep only required variables
#==============================================================================
 
output <- eg03 %>%
 select(studyid, usubjid, paramcd, adt, avalc, ablfl, trtsdt, anl02fl)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================