# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TA_LCSG801
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
 
 
# source("./SDTM_TA_LCSG801_data.r")
 
library(dplyr)
library(tidyr)
 
# Create data for Arm 1 - 300 mg
arm1_df <- tibble(
 armcd = "CSG300",
 arm = "CSG801 300 mg Q2W",
 taetord = c(1, 2, 3),
 etcd = c("SCRN", "CSG300", "FU"),
 element = c("Screening", "CSG801 300 mg Q2W", "Follow-up"),
 tabranch = c("Randomized to CSG801 300 mg Q2W", "", ""),
 tatrans = "",
 epoch = c("SCREENING", "TREATMENT", "FOLLOW-UP")
)
 
# Create data for Arm 2 - 600 mg
arm2_df <- tibble(
 armcd = "CSG600",
 arm = "CSG801 600 mg Q2W",
 taetord = c(1, 2, 3),
 etcd = c("SCRN", "CSG600", "FU"),
 element = c("Screening", "CSG801 600 mg Q2W", "Follow-up"),
 tabranch = c("Randomized to CSG801 600 mg Q2W", "", ""),
 tatrans = "",
 epoch = c("SCREENING", "TREATMENT", "FOLLOW-UP")
)
 
# Create data for Arm 3 - Placebo
arm3_df <- tibble(
 armcd = "PBO",
 arm = "Placebo Q2W",
 taetord = c(1, 2, 3),
 etcd = c("SCRN", "PBO", "FU"),
 element = c("Screening", "Placebo Q2W", "Follow-up"),
 tabranch = c("Randomized to Placebo Q2W", "", ""),
 tatrans = "",
 epoch = c("SCREENING", "TREATMENT", "FOLLOW-UP")
)
 
# Combine data for all arms
ta <- bind_rows(arm1_df, arm2_df, arm3_df)
 
output <- ta
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================