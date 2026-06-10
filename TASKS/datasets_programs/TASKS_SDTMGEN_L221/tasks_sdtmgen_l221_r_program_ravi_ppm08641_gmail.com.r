# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L221
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

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

source("./TASKS_SDTMGEN_L221_data.r")

write_xpt(ec,"r_ec.xpt",version=5)
write_xpt(suppec,"r_suppec.xpt",version=5)

;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================