# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1007_L101
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
 
 
source("./ADaM_C1007_L101_data.r")
 
vs02 <- vs %>%
 mutate(
 avisit = case_when(
 ady %in% 2:11 ~ "Week 1",
 ady %in% 12:18 ~ "Week 2",
 ady %in% 19:25 ~ "Week 3",
 ady %in% 26:32 ~ "Week 4",
 ady %in% 33:39 ~ "Week 5",
 TRUE ~ NA_character_
 ),
 avisitn = case_when(
 ady %in% 2:11 ~ 1,
 ady %in% 12:18 ~ 2,
 ady %in% 19:25 ~ 3,
 ady %in% 26:32 ~ 4,
 ady %in% 33:39 ~ 5,
 TRUE ~ NA_real_
 ),
 awlo = case_when(
 ady %in% 2:11 ~ 2,
 ady %in% 12:18 ~ 12,
 ady %in% 19:25 ~ 19,
 ady %in% 26:32 ~ 26,
 ady %in% 33:39 ~ 33,
 TRUE ~ NA_real_
 ),
 awhi = case_when(
 ady %in% 2:11 ~ 11,
 ady %in% 12:18 ~ 18,
 ady %in% 19:25 ~ 25,
 ady %in% 26:32 ~ 32,
 ady %in% 33:39 ~ 39,
 TRUE ~ NA_real_
 ),
 awtarget = case_when(
 ady %in% 2:11 ~ 7,
 ady %in% 12:18 ~ 14,
 ady %in% 19:25 ~ 21,
 ady %in% 26:32 ~ 28,
 ady %in% 33:39 ~ 35,
 TRUE ~ NA_real_
 ),
 awu="Days"
 )
 
output<-vs02 %>%
 select(usubjid,paramcd,param,paramn,avisitn,avisit,adt,ady,aval,awtarget,awlo
 ,awhi,awu,trtsdt,visitnum,visit)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================