# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1009_L103
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
 
 
source("./ADaM_C1009_L103_data.r")
 
 
#=========================================================
# Read input datasets
#=========================================================
vs01 <- advs %>%
 mutate(adt=as.Date(adt,origin="1960-01-01"))
 
#=========================================================
# Creation of average record for multiple collections at a timepoint
#=========================================================
 
average <- vs01 %>%
 group_by(usubjid, paramcd, param, paramn, avisitn, avisit, adt, ady, awlo, awtarget, awhi) %>%
 summarise(
 aval = mean(aval, na.rm = TRUE),
 count = n()
 ) %>%
 ungroup()
 
#=========================================================
# Separate the average result record where there exists more than one record at a time
#=========================================================
 
new_records <- filter(average, count > 1)
 
#=========================================================
# Combine the newly created records with parent records and assign dtype value
#=========================================================
 
vs02 <- bind_rows(
 mutate(vs01, dtype = NA_character_),
 mutate(new_records, dtype = "AVERAGE")
)
 
vs02 <- vs02 %>%
 mutate(
 awtdiff = ifelse(!is.na(ady) & !is.na(awtarget), abs(ady - awtarget), NA_real_)
 )
 
#=========================================================
# Create analysis flag - ANL01FL
#=========================================================
 
# Sort the data such that the closest, latest and average result come on top within each analysis visit
vs02_1 <- vs02 %>%
 arrange(usubjid, paramcd, avisitn, avisit, awtdiff, desc(ady), desc(dtype))
 
# Assign the ANL01FL
vs03 <- vs02_1 %>%
 group_by(usubjid, paramcd, avisitn, avisit) %>%
 mutate(
 anl01fl = ifelse(row_number() == 1 & !is.na(avisitn), "Y", "")
 ) %>%
 ungroup()
 
# Arrange the data
vs03 <- vs03 %>%
 arrange(usubjid, paramn, avisitn, avisit, ady, dtype)
 
vs03_1 <- vs03 %>%
 arrange(usubjid, paramn, !is.na(avisitn), avisitn, avisit, ady, !is.na(dtype), dtype)
 
 
#=========================================================
# Keep only the required records and order the variables in a logical sequence
#=========================================================
 
output <- vs03_1 %>%
 select(
 usubjid, paramcd, param, paramn, avisitn, avisit, adt, ady, anl01fl, aval,
 dtype, awlo, awtarget, awhi, awtdiff, visitnum, visit
 )
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================