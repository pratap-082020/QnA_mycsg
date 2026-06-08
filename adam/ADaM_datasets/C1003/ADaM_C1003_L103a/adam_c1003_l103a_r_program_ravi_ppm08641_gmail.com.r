# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1003_L103a
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
 
 
source("./ADaM_C1003_L103a_data.r")
 
 
#=========================================================
# Read input data
#=========================================================
 
ae01 <- ae %>%
 mutate(across(c(ap01sdt,ap01edt,ap02sdt,ap02edt,ap03sdt,ap03edt),~as.Date(.,origin="1960-01-01")))
 
 
#=========================================================
# Create ASTDT, TRTEM1FL, TRTEM2FL and TRTEM3FL variables
#=========================================================
 
ae02 <- ae01 %>%
 mutate(
 astdt = ifelse(nchar(aestdtc) == 10, as.Date(aestdtc, format = "%Y-%m-%d"), NA),
 astdt = as.Date(astdt,origin="1970-01-01"),
 trtem1fl = ifelse(!is.na(ap01sdt) & astdt >= ap01sdt & astdt <= ap01edt, "Y", "N"),
 trtem2fl = ifelse(!is.na(ap02sdt) & astdt >= ap02sdt & astdt <= ap02edt, "Y", "N"),
 trtem3fl = ifelse(!is.na(ap03sdt) & astdt >= ap03sdt & astdt <= ap03edt, "Y", "N")
 )
 
#=========================================================
# Keep only required variables and order the variables in a logical sequence
#=========================================================
 
output <- ae02 %>%
 select(usubjid, aedecod, astdt, trtem1fl, trtem2fl, trtem3fl, aestdtc, ap01sdt, ap01edt, ap02sdt, ap02edt, ap03sdt, ap03edt)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================