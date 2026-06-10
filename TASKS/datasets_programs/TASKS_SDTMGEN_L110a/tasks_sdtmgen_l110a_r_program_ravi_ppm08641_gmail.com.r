# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L110a
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
 
rm(list = ls())
 
source("./TASKS_SDTMGEN_L110a_data.r")
 
#==============================================================================;
#Rename epoch in SE dataset;
#==============================================================================;
 
se01 <- se %>%
 rename(se_epoch=epoch)
 
 
#==============================================================================
# Step 1: Create firstdate and lastdate from partial dates
#==============================================================================
 
cm05 <- cm %>%
 mutate(
 tempseq = row_number(),
 ymd = cmstdtc,
 firstdate = case_when(
 str_length(ymd) == 10 ~ ymd,
 str_length(ymd) == 7  ~ str_c(ymd, "-01"),
 str_length(ymd) == 4  ~ str_c(ymd, "-01-01"),
 TRUE ~ NA_character_
 ),
 lastdate = case_when(
 str_length(ymd) == 10 ~ ymd,
 str_length(ymd) == 7  ~ format(ceiling_date(ymd(str_c(ymd, "-01")), "month") - days(1), "%Y-%m-%d"),
 str_length(ymd) == 4  ~ str_c(ymd, "-12-31"),
 TRUE ~ NA_character_
 )
 )
 
#==============================================================================
# Step 2: Join with SE and apply logic for date boundaries and epoch preference
#==============================================================================
 
 
cm06 <- cm05 %>%
 left_join(se01, by = c("studyid", "usubjid"),relationship = "many-to-many") %>%
 mutate(
 epoch = if_else(
 !is.na(sestdtc) &
 sestdtc <= firstdate &
 lastdate <= seendtc,
 se_epoch, " "
 ),
 epochseq = case_when(
 epoch == "TREATMENT"~ 2,
 epoch != " " ~ 1,
 epoch =="" ~ NA)
 ) %>%
 arrange(tempseq, epochseq, desc(epoch))
 
 
#==============================================================================
# Step 3: Keep only the preferred epoch (TREATMENT > others)
#==============================================================================
 
cm07 <- cm06 %>%
 arrange(tempseq, epochseq, desc(epoch)) %>%
 group_by(tempseq) %>%
 slice_head() %>%
 ungroup() %>%
 arrange(tempseq)
 
#==============================================================================
# Step 4: Final dataset with required variables
#==============================================================================
 
output <- cm07 %>%
 select(studyid, usubjid, cmstdtc, epoch)
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================