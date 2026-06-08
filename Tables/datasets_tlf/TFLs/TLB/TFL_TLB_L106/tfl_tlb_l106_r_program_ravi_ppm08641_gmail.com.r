# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TLB_L106
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
 
 
source("./TFL_TLB_L106_data.r")
 
 
# Filter adlb01 dataset
adlb01 <- adlb %>%
 filter(anl02fl == "Y" & !is.na(atoxgrn) & !is.na(btoxgrn) & saffl == "Y")
 
# Create a variable named 'treatment' and duplicate rows
adlb01 <- adlb01 %>%
 mutate(
 treatment = trt01an
 ) %>%
 bind_rows(adlb01 %>% mutate(treatment = 3))
 
 
adsl01 <- adsl %>%
 mutate(
 treatment = trt01an
 ) %>%
 bind_rows(adsl %>% mutate(treatment = 3))
 
 
# Duplicate records for total atoxgrn and btoxgrn
adlb02 <- adlb01 %>%
 bind_rows(adlb01 %>% filter(!is.na(atoxgrn)) %>% mutate(atoxgrn = 6))
 
adlb03 <- adlb02 %>%
 bind_rows(adlb02 %>% filter(!is.na(btoxgrn)) %>% mutate(btoxgrn = 6))
 
# Get treatment totals
denoms <- adsl01 %>%
 group_by(treatment) %>%
 summarise(denom = n_distinct(usubjid))
 
# Get actual counts in atoxgrn vs btoxgrn
counts01 <- adlb03 %>%
 group_by(paramn, paramcd, param, treatment, atoxgrn, btoxgrn) %>%
 summarise(count = n_distinct(usubjid))
 
# Create a dummy to get all levels
dummy01 <- adlb03 %>%
 distinct(paramn, paramcd, param)
 
dummy02 <- dummy01 %>%
 expand_grid(
 treatment = 1:3,
 atoxgrn = 0:6,
 btoxgrn = 0:6
 )
 
# Merge dummy and actual counts to have all levels in the table
counts02 <- dummy02 %>%
 left_join(counts01, by = c("paramn", "paramcd", "param", "treatment", "atoxgrn", "btoxgrn")) %>%
 mutate(count = coalesce(count, 0))
 
# Fetch treatment totals into counts dataset
counts03_pre <- counts02 %>%
 left_join(denoms, by = "treatment")
 
# Fetch total to total row counts as a column to use as a denominator for calculating percentages
altdenoms <- counts02 %>%
 filter(atoxgrn == 6 & btoxgrn == 6) %>%
 select(paramn, paramcd, param, treatment, count) %>%
 rename(altdenom = count)
 
counts03 <- counts03_pre %>%
 left_join(altdenoms, by = c("paramn","paramcd", "param", "treatment"))
 
# Calculate percentages
counts04 <- counts03 %>%
 mutate(
 cp = ifelse(count != 0, paste0(count, " (", sprintf("%.1f", count / altdenom * 100), ")"), " 0")
 ) %>%
 mutate(
 label = case_when(
 treatment == 1 ~ paste0("ARM A (N=", denom, ")"),
 treatment == 2 ~ paste0("ARM B (N=", denom, ")"),
 treatment == 3 ~ paste0("Total (N=", denom, ")")
 )
 )
 
# Transpose the data so that post-baseline toxicity levels become columns
trans01 <- counts04 %>%
 pivot_wider(
 id_cols = c("paramn", "param", "treatment", "label", "btoxgrn"),
 names_prefix = "tox",
 names_from = c( "atoxgrn"),
 values_from = cp
 )
 
output <- trans01
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================