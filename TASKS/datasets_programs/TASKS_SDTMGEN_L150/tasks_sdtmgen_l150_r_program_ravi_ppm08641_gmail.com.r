# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L150
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
 
 
source("./TASKS_SDTMGEN_L150_data.r")
 
 
lb02 <- lblc %>%
 left_join(conversion, by = c("lbtestcd", "lborresu"))
 
 
lb03 <- lb02 %>%
 mutate(
 tempsign = case_when(
 str_sub(lborres, 1, 2) %in% c("<=", ">=") ~ str_sub(lborres, 1, 2),
 str_sub(lborres, 1, 1) %in% c("<", ">") ~ str_sub(lborres, 1, 1),
 TRUE ~ ""
 ),
 tempresn = case_when(
 str_sub(lborres, 1, 2) %in% c("<=", ">=") ~ suppressWarnings(as.numeric(str_sub(lborres, 3,-1))),
 str_sub(lborres, 1, 1) %in% c("<", ">") ~ suppressWarnings(as.numeric(str_sub(lborres, 2,-1))),
 TRUE ~ suppressWarnings(as.numeric(lborres))
 )
 )
 
 
lb04 <- lb03 %>%
 mutate(
 tempstresn = ifelse(!is.na(tempresn) & !is.na(conv_mult), tempresn * conv_mult, NA),
 lbstresn = ifelse(tempsign == "", tempstresn, NA),
 lbstresc = ifelse(tempsign == "", as.character(tempstresn), ifelse(!is.na(tempstresn), paste0(tempsign, as.character(tempstresn)), NA))
 )
 
 
output <- lb04 %>%
 select(usubjid, lbtestcd, lbdtc, lborres, lborresu, lbstresn, lbstresc, lbstresu)
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================