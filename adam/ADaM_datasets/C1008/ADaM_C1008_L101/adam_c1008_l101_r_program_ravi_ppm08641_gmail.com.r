# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1008_L101
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
 
 
source("./ADaM_C1008_L101_data.r")
 
 
library(tidyverse)
library(lubridate)
 
# Read input datasets (assuming 'adsl' and 'ae' are already available in R)
adsl01 <- adsl %>%
 mutate(across(c(ap01sdt,ap01edt,ap02sdt,ap02edt,ap03sdt,ap03edt),~as.Date(.,origin="1960-01-01")))
 
ae01 <- ae
 
# Merge ADSL and AE datasets
ae02 <- left_join(ae01, adsl01, by = "usubjid")
 
# Create ASTDT, APERIOD, TRTP, and TRTA variables
ae03 <- ae02 %>%
 mutate(
 astdt = if_else(nchar(aestdtc) == 10, ymd(aestdtc), NA_Date_),
 astdt = as.Date(astdt, origin="1970-01-01"),
 aperiod = case_when(
 !is.na(ap01sdt) & astdt >= ap01sdt & astdt <= ap01edt ~ 1,
 !is.na(ap02sdt) & astdt >= ap02sdt & astdt <= ap02edt ~ 2,
 !is.na(ap03sdt) & astdt >= ap03sdt & astdt <= ap03edt ~ 3,
 TRUE ~ NA_integer_
 ),
 
 trtp = case_when(
 !is.na(ap01sdt) & astdt >= ap01sdt & astdt <= ap01edt ~ trt01p,
 !is.na(ap02sdt) & astdt >= ap02sdt & astdt <= ap02edt ~ trt02p,
 !is.na(ap03sdt) & astdt >= ap03sdt & astdt <= ap03edt ~ trt03p,
 TRUE ~ NA_character_
 ),
 
 trta = case_when(
 !is.na(ap01sdt) & astdt >= ap01sdt & astdt <= ap01edt ~ trt01a,
 !is.na(ap02sdt) & astdt >= ap02sdt & astdt <= ap02edt ~ trt02a,
 !is.na(ap03sdt) & astdt >= ap03sdt & astdt <= ap03edt ~ trt03a,
 TRUE ~ NA_character_
 )
 )
 
output <- ae03
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================