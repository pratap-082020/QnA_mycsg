# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1006_L102b
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
 
 
source("./ADaM_C1006_L102b_data.r")
 
 
 
 
# Read input dataset and create analysis variables
vs01 <- vs %>%
 mutate(
 paramcd = if_else(vstestcd == "SYSBP" & vspos == "SITTING", "STSBP",
 if_else(vstestcd == "DIABP" & vspos == "SITTING", "STDBP", NA_character_)),
 paramn = if_else(vstestcd == "SYSBP" & vspos == "SITTING", 1,
 if_else(vstestcd == "DIABP" & vspos == "SITTING", 2, NA_real_)),
 param = paste0(str_to_title(vspos), " ", vstest, " (", vsstresu, ")"),
 adt = if_else(nchar(vsdtc) >= 10, ymd(substr(vsdtc, 1, 10)), NA_Date_),
 aval = vsstresn,
 avisit = if_else(visit == "SCREEN", "Screening", str_to_title(visit)),
 avisitn = if_else(visit == "SCREEN", -1, visitnum),
 aval2=case_when(
 paramn==1 ~ aval*-1,
 paramn==2 ~ aval,
 TRUE~NA
 )
 )
 
# Fetch the reference start date
dm01 <- dm %>%
 mutate(trtsdt = if_else(nchar(rfstdtc) >= 10, ymd(substr(rfstdtc, 1, 10)), NA_Date_)) %>%
 select(usubjid, trtsdt)
 
# Merge the datasets
vs02 <- vs01 %>%
 left_join(dm01, by = "usubjid")
 
# Derive the baseline flag
base01 <- vs02 %>%
 filter(adt <= trtsdt & !is.na(aval)) %>%
 arrange(usubjid,paramn, aval2, adt, visitnum)
 
base02 <- base01 %>%
 group_by(usubjid, paramn) %>%
 slice(n()) %>%
 mutate(ablfl = "Y") %>%
 select(usubjid, paramn, adt, visitnum, ablfl, base=aval)
 
# Merge the baseline flag back onto the parent dataset
vs03 <- vs02 %>%
 left_join(base02 %>% select(-base), by = c("usubjid", "paramn", "adt", "visitnum")) %>%
 mutate(
 avisitn = if_else(ablfl == "Y", 0, avisitn, avisitn),
 avisit = if_else(ablfl == "Y", "Baseline", avisit, avisit)
 )
 
# Deriving base, chg, and pchg variables
vs04 <- vs03 %>%
 left_join(base02 %>% select(usubjid,paramn,base), by = c("usubjid", "paramn"))
 
vs05 <- vs04 %>%
 mutate(
 basetype = case_when(
 paramn==1 ~"MINIMUM",
 paramn==2 ~ "MAXIMUM",
 TRUE ~ NA),
 chg = if_else(adt > trtsdt & !is.na(aval) & !is.na(base), aval - base, NA_real_),
 pchg = if_else(adt > trtsdt & !is.na(aval) & !is.na(base), (aval - base) / base * 100, NA_real_)
 )
 
# Keep only the required variables and order them in a logical sequence
output <- vs05 %>%
 select(usubjid, basetype, paramn, paramcd, param, adt, avisitn, avisit,
 aval, base, chg, pchg, trtsdt, ablfl) %>%
 arrange(usubjid,paramn,avisitn,adt)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================