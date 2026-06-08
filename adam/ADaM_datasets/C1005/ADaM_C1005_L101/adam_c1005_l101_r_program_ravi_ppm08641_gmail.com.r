# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1005_L101
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
 
 
source("./ADaM_C1005_L101_data.r")
 
 

#=========================================================
# Read input dataset and create analysis variables which are directly based on SDTM variables
#=========================================================

vs01 <- vs %>%
  mutate(
    paramcd = case_when(
      vstestcd == "SYSBP" & vspos == "SITTING" ~ "STSBP",
      vstestcd == "DIABP" & vspos == "SITTING" ~ "STDBP",
      TRUE ~ NA
    ),
    paramn = case_when(
      vstestcd == "SYSBP" & vspos == "SITTING" ~ 1,
      vstestcd == "DIABP" & vspos == "SITTING" ~ 2,
      TRUE ~ NA
    ),
    param = str_c(str_to_title(str_trim(vspos)), " ", str_trim(vstest), " (", str_trim(vsstresu), ")"),
    adt = if_else(nchar(vsdtc) >= 10, as.Date(substr(vsdtc, 1, 10), format="%Y-%m-%d"), NA),
    aval = vsstresn,
    avisit = ifelse(visit == "SCREEN", "Screening", str_to_title(visit)),
    avisitn = visitnum
  )

#=========================================================
# Derive minimum value record
#=========================================================

# Fetch the reference start date from SDTM.DM as treatment start date
dm01 <- dm %>%
  mutate(
    trtsdt = if_else(nchar(rfstdtc) >= 10, as.Date(substr(rfstdtc, 1, 10), format="%Y-%m-%d"), NA),
  ) %>%
  select(usubjid, trtsdt)

vs02 <- vs01 %>%
  left_join(dm01, by = "usubjid")

# Identify the record with minimum result across postbaseline rows and append it back to full data
min01 <- vs02 %>%
  filter(adt > trtsdt & !is.na(aval)) %>%
  arrange(usubjid, paramn, aval, adt)

min02 <- min01 %>%
  group_by(usubjid, paramn) %>%
  slice(1) %>%
  mutate(
    avisitn = 98,
    avisit = "Minimum value postbaseline",
    dtype = "MINIMUM"
  ) %>%
  ungroup()

vs03 <- bind_rows(vs02, min02) %>%
  arrange(usubjid, paramn, avisitn, adt)

#=========================================================
# Keep only the required variables and order the variables in a logical sequence
#=========================================================
output <- vs03 %>%
  select(usubjid, paramn, paramcd, param, avisitn, avisit, adt, aval, dtype, trtsdt)

 
 
#==============================================================================;
; ; 

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================