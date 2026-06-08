# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1004_L103c
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
 
 
source("./ADaM_C1004_L103c_data.r")
 
#=========================================================
# Read input datasets
#=========================================================
 
qs01 <- qs
 
#=========================================================
# Process the data to create analysis variables, and create score variable for use in creation of derived parameter
#=========================================================
 
qs02 <- qs01 %>%
 mutate(
 paramcd = qstestcd,
 param = case_when(
 toupper(str_trim(qstest)) == "MOBILITY" ~ "Mobility",
 toupper(str_trim(qstest)) == "SELF-CARE" ~ "Self-care",
 toupper(str_trim(qstest)) == "USUAL ACTIVITIES" ~ "Usual activities",
 toupper(str_trim(qstest)) == "PAIN / DISCOMFORT" ~ "Pain/discomfort",
 toupper(str_trim(qstest)) == "ANXIETY / DEPRESSION" ~ "Anxiety/depression",
 toupper(str_trim(qstest)) == "YOUR HEALTH TODAY" ~ "Your health today",
 TRUE ~ NA_character_
 ),
 aval = qsstresn,
 paramn = as.integer(substr(qstestcd, nchar(qstestcd) - 1, nchar(qstestcd))),
 avalcat1 = case_when(
 paramn %in% c(1, 2, 3) & aval == 1 ~ "No problem",
 paramn %in% c(1, 2, 3) & aval == 2 ~ "Slight problem",
 paramn %in% c(1, 2, 3) & aval == 3 ~ "Moderate problem",
 paramn %in% c(1, 2, 3) & aval == 4 ~ "Severe problem",
 paramn %in% c(1, 2, 3) & aval == 5 ~ "Unable",
 paramn %in% c(4, 5) & aval == 1 ~ "None",
 paramn %in% c(4, 5) & aval == 2 ~ "Slight",
 paramn %in% c(4, 5) & aval == 3 ~ "Moderate",
 paramn %in% c(4, 5) & aval == 4 ~ "Severe",
 paramn %in% c(4, 5) & aval == 5 ~ "Extreme",
 TRUE ~ NA_character_
 ),
 avalca1n = case_when(
 avalcat1 %in% c("No problem", "None") ~ 1,
 avalcat1 %in% c("Slight problem", "Slight") ~ 2,
 avalcat1 %in% c("Moderate problem", "Moderate") ~ 3,
 avalcat1 %in% c("Severe problem", "Severe") ~ 4,
 avalcat1 %in% c("Unable", "Extreme") ~ 5,
 TRUE ~ NA_real_
 ),
 avalc = ifelse(paramn != 6, word(qsstresc, 2, sep = "-"), qsstresc),
 score = case_when(
 paramn == 1 ~ (aval == 1) * 0 + (aval == 2) * 0.051 + (aval == 3) * 0.063 + (aval == 4) * 0.212 + (aval == 5) * 0.275,
 paramn == 2 ~ (aval == 1) * 0 + (aval == 2) * 0.057 + (aval == 3) * 0.076 + (aval == 4) * 0.181 + (aval == 5) * 0.217,
 paramn == 3 ~ (aval == 1) * 0 + (aval == 2) * 0.051 + (aval == 3) * 0.067 + (aval == 4) * 0.174 + (aval == 5) * 0.190,
 paramn == 4 ~ (aval == 1) * 0 + (aval == 2) * 0.060 + (aval == 3) * 0.075 + (aval == 4) * 0.276 + (aval == 5) * 0.341,
 paramn == 5 ~ (aval == 1) * 0 + (aval == 2) * 0.079 + (aval == 3) * 0.104 + (aval == 4) * 0.296 + (aval == 5) * 0.301,
 TRUE ~ NA_real_
 ),
 adt = if_else(nchar(qsdtc) >= 10, as.Date(substr(qsdtc, 1, 10), "%Y-%m-%d"), NA)
 )
 
#=========================================================
# Creation of derived parameter, CHI
#=========================================================
 
# Transpose the SCORE variable
derived01 <- qs02 %>%
 arrange(usubjid, adt, visitnum, visit) %>%
 filter(paramn %in% 1:5)
 
derived02 <- derived01 %>%
 pivot_wider(
 names_from = paramcd,
 values_from = score,
 id_cols = c(usubjid, adt, visitnum, visit)
 )
 
# Create the aval and other variables
derived03 <- derived02 %>%
 mutate(
 non_missing_count = rowSums(!is.na(select(., EQ5D5L01, EQ5D5L02, EQ5D5L03, EQ5D5L04, EQ5D5L05))),
 aval = if_else(non_missing_count==5, round(1 - 0.9675 * rowSums(across(starts_with("EQ5D5L"))), digits=3), NA),
 paramcd = "CHI",
 paramn = 7,
 param = 'Composite health index',
 paramtyp = "DERIVED",
 avalc = if_else(!is.na(aval), as.character(aval), NA_character_)
 )
 
#=========================================================
# Combine derived parameter with source records
#=========================================================
 
qs03 <- bind_rows(
 qs02,
 derived03
) %>%
 arrange(usubjid, adt, paramn)
 
#=========================================================
# Keep the required variables and arrange the variables in a logical sequence
#=========================================================
 
output <- qs03 %>%
 select(usubjid, paramn, param, paramcd, paramtyp, adt, aval, avalc, visitnum, visit, score)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================