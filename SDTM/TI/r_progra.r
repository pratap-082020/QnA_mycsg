# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TI_LCSG801
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
 
 
# source("./SDTM_TI_LCSG801_data.r")
 
library(dplyr)
library(tidyr)
 
# Create data for inclusion criteria
inclusion_df <- tibble(
 STUDYID = "CSG801",
 DOMAIN = "TI",
 IETESTCD = c("INCL01", "INCL02", "INCL03"),
 IETEST = c("Male and female patients 18-70 (inclusive) years of age",
 "Active ulcerative colitis confirmed by colonoscopy",
 "The patient is able and willing to comply with the requirements of this trial protocol"),
 IECAT = "INCLUSION",
 TIVERS = "Version 1"
)
 
# Create data for exclusion criteria
exclusion_df <- tibble(
 STUDYID = "CSG801",
 DOMAIN = "TI",
 IETESTCD = c("EXCL01", "EXCL02", "EXCL03"),
 IETEST = c("Pregnant or breastfeeding women",
 "Contraindication to colonoscopy",
 "Allergies to any component of CSG801"),
 IECAT = "EXCLUSION",
 TIVERS = "Version 1"
)
 
# Combine data for inclusion and exclusion criteria
ti <- bind_rows(inclusion_df, exclusion_df)
 
output <- ti
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================