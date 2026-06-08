# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1004_L103b
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
 
 
source("./ADaM_C1004_L103b_data.r")
 
 
# Load the necessary library
library(dplyr)
library(tidyr)
 
#=========================================================
# Read input datasets
#=========================================================
 
lb01 <- lb
 
#=========================================================
# Create variables and parameters which are directly based on source records
#=========================================================
 
lb02 <- lb01 %>%
 mutate(
 paramcd = lbtestcd,
 param = paste0(str_trim(lbtest), " (", str_trim(lbstresu), ")"),
 adt = if_else(nchar(lbdtc) >= 10, as.Date(substr(lbdtc, 1, 10), "%Y-%m-%d"), NA),
 aval = lbstresn
 )
 
#=========================================================
# Create the new parameter- HDLLDL
#=========================================================
 
# Subset the input parameters: LDL and HDL
ratio01 <- lb02 %>%
 filter(paramcd %in% c("LDL", "HDL")) %>%
 arrange(usubjid, adt, visitnum, visit)
 
# Transpose the data such that LDL and HDL collected at a timepoint are available side by side
ratio02 <- ratio01 %>%
 pivot_wider(
 names_from = paramcd,
 values_from = aval,
 id_cols = c(usubjid, adt, visitnum, visit)
 )
 
# Derive AVAL for HDLLDL
ratio03 <- ratio02 %>%
 mutate(
 aval = if_else(!is.na(HDL) & !is.na(LDL), round(HDL / LDL, 2), NA_real_),
 paramcd = "HDLLDL",
 param = "HDL LDL Ratio (Ratio)",
 paramtyp = "DERIVED"
 )
 
#=========================================================
# Combine the derived parameter records with records of source parameters
#=========================================================
 
lb03 <- bind_rows(
 lb02,
 select(ratio03, usubjid, paramcd, param, adt, aval)
) %>%
 arrange(usubjid, paramcd, adt)
 
#=========================================================
# Keep only the required variables and order the variables in a logical sequence
#=========================================================
 
output <- lb03 %>%
 select(usubjid, paramcd, param, adt, aval)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================