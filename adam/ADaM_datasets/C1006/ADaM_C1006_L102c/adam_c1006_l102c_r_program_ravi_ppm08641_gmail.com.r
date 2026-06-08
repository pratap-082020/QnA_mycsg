# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1006_L102c
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
 
 
source("./ADaM_C1006_L102c_data.r")
 
 
# Creating analysis variables directly based on SDTM variables
vs01 <- vs %>%
 mutate(
 paramcd = case_when(
 vstestcd == "SYSBP" & vspos == "SITTING" ~ "STSBP",
 vstestcd == "DIABP" & vspos == "SITTING" ~ "STDBP",
 vstestcd == "WEIGHT" ~ vstestcd,
 TRUE ~ NA_character_
 ),
 paramn = case_when(
 vstestcd == "SYSBP" & vspos == "SITTING" ~ 1,
 vstestcd == "DIABP" & vspos == "SITTING" ~ 2,
 vstestcd == "WEIGHT" ~ 3,
 TRUE ~ NA_integer_
 ),
 param = str_c(str_to_title(vspos), " ", vstest, " (", vsstresu, ")"),
 adt = if_else(nchar(vsdtc) >= 10, as.Date(substr(vsdtc, 1, 10), format = "%Y-%m-%d"), NA_Date_),
 aval = vsstresn,
 avisit = case_when(
 visit == "SCREEN" ~ "Screening",
 TRUE ~ str_to_title(visit)
 ),
 avisitn = visitnum
 )
 
# Fetch the reference start date from SDTM.DM as treatment start date
dm01 <- dm %>%
 mutate(
 trtsdt = if_else(nchar(rfstdtc) >= 10, as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"), NA_Date_)
 ) %>%
 select(usubjid, trtsdt)
 
vs02 <- vs01 %>%
 left_join(dm01, by = "usubjid")
 
# Derive the baseline flag
base01 <- vs02 %>%
 filter(!is.na(aval), adt <= trtsdt) %>%
 mutate(
 aval2 = case_when(
 paramn == 1 ~ aval * -1,
 paramn == 2 ~ aval,
 paramn == 3 ~ 1,
 TRUE ~ NA_real_
 )
 ) %>%
 arrange(usubjid, paramn, aval2, adt, visitnum)
 
base02 <- base01 %>%
 group_by(usubjid, paramn) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(ablfl = "Y",base=aval) %>%
 select(usubjid,paramn,adt,visitnum,ablfl,base)
 
vs03 <- vs02 %>%
 left_join(base02 %>% select(-base), by = c("usubjid", "paramn", "adt", "visitnum")) %>%
 mutate(avisit = if_else(ablfl == "Y", "Baseline", avisit, avisit),
 avisitn = if_else(ablfl == "Y", 0, avisitn, avisitn))
 
# Deriving base, chg, and pchg variables
vs04 <- vs03 %>%
 left_join(base02 %>% select(usubjid,paramn,base), by = c("usubjid", "paramn"))
 
vs05 <- vs04 %>%
 mutate(
 basetype = case_when(
 paramn == 2 ~ "MAXIMUM",
 paramn == 1 ~ "MINIMUM",
 paramn == 3 ~ "ORIGINAL",
 TRUE ~ NA_character_
 ),
 chg = if_else(adt > trtsdt, aval - base, NA_real_),
 pchg = if_else(adt > trtsdt, (aval - base) / base * 100, NA_real_)
 ) %>%
 arrange(usubjid,paramn,avisitn,adt)
 
# Keep only the required variables and order them in a logical sequence
output <- vs05 %>%
 select(usubjid, basetype, paramn, paramcd, param, avisitn,avisit,adt, aval, base, chg, pchg, trtsdt, ablfl)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================