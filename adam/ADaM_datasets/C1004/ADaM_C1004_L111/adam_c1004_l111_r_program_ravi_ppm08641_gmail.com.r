# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1004_L111
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
 
 
source("./ADaM_C1004_L111_data.r")
 
 
#==============================================================================
# Sort the input data (optional in R if not relying on sort order)
#==============================================================================
 
vs_sorted <- advs %>%
 arrange(usubjid, avisitn, atpt) %>%
 mutate(
 atpts = str_to_lower(str_sub(atpt,1,1))
 )
 
#==============================================================================
# Pivot wider to get Baseline and End of Test as columns
#==============================================================================
 
vs_trans <- vs_sorted %>%
 pivot_wider(
 id_cols = c(usubjid,avisitn,avisit,adt,ady,trtsdt),
 names_from = atpts,
 values_from = aval,
 names_prefix = "spo2_"
 )
 
#==============================================================================
# Create new parameter for SpO₂ Decay
#==============================================================================
 
vs_decay <- vs_trans %>%
 filter(!is.na(spo2_b), !is.na(spo2_e)) %>%
 mutate(
 paramcd = "SPO2DECY",
 param = "SpO2 Decay (%)",
 paramn = 2,
 aval = spo2_b - spo2_e
 )
 
#=============================================================================;
#Append to original vs dataset and keep only required variables;
#=============================================================================;
 
vs_final <- bind_rows(
 advs,
 vs_decay
) %>%
 select(usubjid, avisitn, avisit, adt, ady, atpt, trtsdt,
 paramcd, param, paramn, aval)
 
output <- vs_final
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================