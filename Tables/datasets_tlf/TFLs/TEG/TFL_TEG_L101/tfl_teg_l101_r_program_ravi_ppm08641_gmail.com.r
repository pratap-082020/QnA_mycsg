# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TEG_L101
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
 
 
source("./TFL_TEG_L101_data.r")
 
 
# Read input datasets
adeg01 <- adeg %>% filter(avisitn > 1)
adsl01 <- adsl %>% filter(saffl == "Y")
 
#==============================================================================
# Create a variable named 'treatment' to hold report level column groupings
# Also create duplicate rows for presenting total column
#==============================================================================
adeg02 <- bind_rows(
 mutate(adeg01,treatment=trt01an),
 mutate(adeg01, treatment=3)
 )
 
adsl02 <- bind_rows(
 mutate(adsl01,treatment=trt01an),
 mutate(adsl01, treatment=3)
)
#==============================================================================
# Create a numeric variable in ADEG corresponding to each level in AVALC
#==============================================================================
adeg03 <- adeg02 %>%
 mutate(result = case_when(
 avalc == "NORMAL" ~ 2,
 avalc == "ABNORMAL - CLINICALLY SIGNIFICANT" ~ 4,
 avalc == "ABNORMAL - NOT CLINICALLY SIGNIFICANT" ~ 3,
 TRUE ~ NA_integer_
 )) %>%
 filter(!is.na(result))
 
# Get treatment totals into a dataset and into macro variables (for column headers)
# Get treatment totals based on actual data
trttotal_pre <- adsl02 %>%
 group_by(treatment) %>%
 summarize(trttotal = n_distinct(usubjid))
 
#==============================================================================
# Create dummy dataset for treatment totals
#==============================================================================
dummy_pre <- tibble(treatment = 1:3)
 
#==============================================================================
# Merge actual counts with dummy counts
#==============================================================================
trttotals <- dummy_pre %>%
 left_join(trttotal_pre, by = "treatment") %>%
 mutate(trttotal = ifelse(is.na(trttotal), 0, trttotal))
 
 
#==============================================================================
# Obtaining actual counts-for the table
#==============================================================================
# Get counts for 'number of subjects with a non-missing value'
sub_count <- adeg03 %>%
 filter(!is.na(result)) %>%
 group_by(avisitn, avisit, treatment) %>%
 summarize(count = n_distinct(usubjid)) %>%
 mutate(result=1)
 
# Get counts for each level of avalc - abnormality level counts
abn_count <- adeg03 %>%
 group_by(avisitn, avisit, result, treatment) %>%
 summarize(count = n_distinct(usubjid))
 
#==============================================================================
# Combine all datasets with counts into a single dataset
#==============================================================================
counts01 <- bind_rows(sub_count, abn_count)
 
#==============================================================================
# Create zero counts for levels which are not present in actual data
#==============================================================================
# Get all available visits
dummy01 <- counts01 %>%
 distinct(avisitn, avisit)
 
#==============================================================================
# Create a row for each treatment and row to be presented in the table
#==============================================================================
dummy02 <- dummy01 %>%
 cross_join(expand_grid(treatment = 1:3, result = 1:4))
 
#==============================================================================
# Merge dummy counts with actual counts
#==============================================================================
counts02 <- dummy02 %>%
 left_join(counts01, by = c("avisitn", "avisit", "treatment", "result")) %>%
 mutate(count = ifelse(is.na(count), 0, count))
 
#==============================================================================
# Process the data to calculate percentages
#==============================================================================
# Denominator: number of subjects with non-missing data
# Populate 'n' row counts at a visit on all rows of the visit
 
# Sort the sub_count dataset
denom01 <- sub_count %>%
 select(treatment, avisitn, avisit, denom=count)
 
# Merge the counts02 and denom01 datasets
counts03 <- counts02 %>%
 left_join(denom01, by = c("treatment", "avisitn", "avisit")) %>%
 mutate(denom = ifelse(is.na(denom), 0, denom))
 
#==============================================================================
# Calculate percentages
#==============================================================================
 
counts04 <- counts03 %>%
 mutate(
 cp = ifelse(result != 1,
 ifelse(count != 0,
 paste0(formatC(count, width = 3)," (", sprintf("%5.1f",count / denom * 100), "%)"),
 formatC(count, width = 3)),
 formatC(count, width = 3))
 )
 
# Create the label column
counts05 <- counts04 %>%
 mutate(c2 = case_when(
 result == 1 ~ "n",
 result == 2 ~ "Normal",
 result == 3 ~ "Abnormal - NCS",
 result == 4 ~ "Abnormal - CS",
 TRUE ~ ""
 ))
 
#==============================================================================
# Transpose to obtain treatment as columns
#==============================================================================
trans01 <- counts05 %>%
 pivot_wider(id_cols = c(avisitn,avisit,result,c2),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt")
 
 
trans02 <- trans01 %>%
 rename(c1=avisit) %>%
 select(avisitn,c1,result,c2,trt1,trt2,trt3)
 
output<-trans02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================