# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TE_LCSG801
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
 
 
# source("./SDTM_TE_LCSG801_data.r")
 
te <- tibble(
 STUDYID = rep("CSG801", 5),
 DOMAIN = rep("TE", 5),
 ETCD = c("SCRN", "CSG300", "CSG600", "PBO", "FU"),
 ELEMENT = c("Screening", "CSG801 300 mg Q2W", "CSG801 600 mg Q2W", "Placebo Q2W", "Follow-up"),
 TESTRL = c("Informed consent", "First dose of CSG801, where dose is 300 mg",
 "First dose of CSG801, where dose is 600 mg", "First dose of placebo", "One day after last dose of study drug"),
 TEENRL = c("Screening assessments are complete; up to 4 Weeks after start of the element",
 "12 Weeks after start of the element", "12 Weeks after start of the element",
 "12 Weeks after start of the element", "3 Weeks after start of the element"),
 TEDUR = c("P4W", "P12W", "P12W", "P12W", "P3W")
)
 
output <- te
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================