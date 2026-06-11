# ============================================================
# Downloaded from myCSG lesson content
# Lesson: MACROS_SDTM_L261
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
 
 
source("./MACROS_SDTM_L261_data.r")
 
#==============================================================================
# Function to create study day (Handles ISO 8601 DateTime format, Returns Numeric)
#==============================================================================
 
csg_sdtm_create_studyday <- function(dtcvar, rfstdtc) {
 
 # Extract date part from ISO 8601 datetime
 dtcvar_date <- str_split_fixed(dtcvar, "T", 2)[, 1]
 rfstdtc_date <- str_split_fixed(rfstdtc, "T", 2)[, 1]
 
 # Convert to Date
 dtcvar_n <- suppressWarnings(as.Date(dtcvar_date, format = "%Y-%m-%d"))
 rfstdtn  <- suppressWarnings(as.Date(rfstdtc_date, format = "%Y-%m-%d"))
 
 # Compute study day: NA where either date is missing
 study_day <- ifelse(
 is.na(dtcvar_n) | is.na(rfstdtn),
 NA,
 as.integer(dtcvar_n - rfstdtn + (dtcvar_n >= rfstdtn))
 )
 
 return(study_day)
}
 
 
#==============================================================================;
#Apply function;
#==============================================================================;
 
ae01 <- ae %>%
 mutate(
 aestdy = csg_sdtm_create_studyday(aestdtc, rfstdtc),
 aeendy = csg_sdtm_create_studyday(aeendtc, rfstdtc)
 )
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================