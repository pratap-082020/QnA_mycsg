# ============================================================
# Downloaded from myCSG lesson content
# Lesson: MACROS_SDTM_L271
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

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
 
rm(list = ls())
 
source("./MACROS_SDTM_L271_data.r")
 
 
csg_sdtm_create_seq <- function(data, sortvars, seqvar = "seqvar", groupvar = "usubjid") {
 
 data %>%
 arrange(!!!parse_exprs(sortvars)) %>%
 group_by(!!sym(groupvar)) %>%
 mutate(!!sym(seqvar) := row_number()) %>%
 ungroup()
}
 
 
ae01 <- csg_sdtm_create_seq(
 ae,
 sortvars = c("usubjid", "!is.na(aestdtc)", "aestdtc", "aeterm", "aeendtc"),
 seqvar = "aeseq"
)
 
output <- ae01
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================