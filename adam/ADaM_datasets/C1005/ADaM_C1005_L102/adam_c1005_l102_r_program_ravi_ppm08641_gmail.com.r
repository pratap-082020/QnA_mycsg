# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1005_L102
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
 
 
source("./ADaM_C1005_L102_data.r")
 
 
#=========================================================
# Read input dataset and create analysis variables which are directly based on SDTM variables
#=========================================================
vs01 <- vs %>%
 mutate(
 paramcd = case_when(
 vstestcd == "SYSBP" & vspos == "SITTING" ~ "STSBP",
 vstestcd == "DIABP" & vspos == "SITTING" ~ "STDBP",
 TRUE ~ NA_character_
 ),
 paramn = case_when(
 vstestcd == "SYSBP" & vspos == "SITTING" ~ 1,
 vstestcd == "DIABP" & vspos == "SITTING" ~ 2,
 TRUE ~ NA_integer_
 ),
 param = paste0(str_to_title(vspos), " ", vstest, " (", vsstresu, ")"),
 adt = as.Date(substr(vsdtc, 1, 10), format = "%Y-%m-%d"),
 aval = vsstresn,
 avisitn = visitnum,
 avisit = if_else(visit == "SCREEN", "Screening", str_to_title(visit))
 )
 
#=========================================================
# Derive average value record
#=========================================================
dm01 <- dm %>%
 mutate(
 trtsdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d")
 ) %>%
 select(usubjid, trtsdt)
 
vs02 <- vs01 %>%
 left_join(dm01, by = "usubjid")
 
avg01 <- vs02 %>%
 filter(!is.na(adt) & !is.na(trtsdt) & adt > trtsdt & !is.na(aval))
 
avg02 <- avg01 %>%
 group_by(usubjid, paramn, paramcd, param, trtsdt) %>%
 summarise(mean = mean(aval, na.rm = TRUE)) %>%
 ungroup()
 
avg03 <- avg02 %>%
 mutate(
 aval = round(mean, 2),
 avisitn = 100,
 avisit = "Average of all postbaseline values",
 dtype = "AVERAGE"
 )
 
vs03 <- bind_rows(vs02, avg03) %>%
 arrange(usubjid,paramn,avisitn,adt)
 
output <- vs03 %>%
 select(usubjid, paramn, paramcd, param, avisitn, avisit, adt, aval, dtype, trtsdt)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================