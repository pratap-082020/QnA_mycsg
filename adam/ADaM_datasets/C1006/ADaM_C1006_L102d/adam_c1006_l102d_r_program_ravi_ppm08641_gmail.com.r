# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1006_L102d
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
 
 
source("./ADaM_C1006_L102d_data.r")
 
 
# Read input dataset and create analysis variables which are directly based on SDTM variables
vs01 <- vs %>%
 mutate(
 paramcd = case_when(
 vstestcd == "SYSBP" & vspos == "SITTING" ~ "STSBP",
 vstestcd == "DIABP" & vspos == "SITTING" ~ "STDBP",
 TRUE ~ as.character(vstestcd)
 ),
 paramn = case_when(
 vstestcd == "SYSBP" & vspos == "SITTING" ~ 1,
 vstestcd == "DIABP" & vspos == "SITTING" ~ 2,
 TRUE ~ 3
 ),
 param = paste0(str_to_title(vspos), " ", vstest, " (", vsstresu, ")"),
 adt = as.Date(vsdtc,format="%Y-%m-%d"),
 aval = vsstresn,
 avisitn = visitnum,
 avisit = case_when(
 visit == "SCREEN 1" ~ "Screening 1",
 visit == "SCREEN 2" ~ "Screening 2",
 !is.na(visit) ~  str_to_title(visit),
 TRUE ~ NA)
 )
 
# Fetch the reference start date from SDTM.DM as treatment start date
dm01 <- dm %>%
 mutate(
 trtsdt = as.Date(rfstdtc, "%Y-%m-%d")
 ) %>%
 select(usubjid, trtsdt)
 
vs02 <- vs01 %>%
 left_join(dm01, by = "usubjid")
 
 
# Create a new record to hold the average result of screening collections and append it to source records
base01 <- vs02 %>%
 filter(adt <= trtsdt, !is.na(aval))
 
base_mean <- base01 %>%
 group_by(usubjid, paramn, paramcd, param, trtsdt) %>%
 summarise(mean = mean(aval, na.rm = TRUE)) %>%
 ungroup()
 
base02 <- base_mean %>%
 mutate(
 aval = round(mean, 2),
 ablfl = "Y",
 base = aval
 ) %>%
 select(-mean)
 
vs03 <- bind_rows(vs02, select(base02,-base)) %>%
 mutate(
 dtype = if_else(ablfl == "Y", "AVERAGE", NA_character_),
 avisitn = if_else(ablfl == "Y", 0, avisitn, avisitn),
 avisit = if_else(ablfl == "Y", "Baseline", avisit, avisit)
 ) %>%
 arrange(usubjid, paramn, avisitn)
 
# Deriving base, chg, and pchg variables
vs04 <- vs03 %>%
 left_join(select(base02, usubjid, paramn, base), by = c("usubjid", "paramn"))
 
vs05 <- vs04 %>%
 mutate(
 basetype = "AVERAGE",
 chg = if_else(adt > trtsdt & !is.na(aval) & !is.na(base), aval - base, NA_real_),
 pchg = if_else(adt > trtsdt & !is.na(aval) & !is.na(base), chg / base * 100, NA_real_)
 ) %>%
 arrange(usubjid,paramn,avisitn,adt)
 
# Keep only the required variables and order the variables in a logical sequence
output <- vs05 %>%
 select(usubjid, paramn, paramcd, param, avisitn, avisit, adt, aval, base, chg, pchg, trtsdt, ablfl, basetype, dtype)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================