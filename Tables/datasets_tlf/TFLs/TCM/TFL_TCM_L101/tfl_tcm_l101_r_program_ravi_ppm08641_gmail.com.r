# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TCM_L101
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
 
 
source("./TFL_TCM_L101_data.r")
 
 
 
# Filter datasets
adcm01 <- adcm %>%
 filter(saffl == "Y")
 
adsl01 <- adsl %>%
 filter(saffl == "Y")
 
# Create a variable named 'treatment' and duplicate rows
adcm02 <- adcm01 %>%
 mutate(treatment = trt01an) %>%
 bind_rows(adcm01 %>% mutate(treatment = 3))
 
adsl02 <- adsl01 %>%
 mutate(treatment = trt01an) %>%
 bind_rows(adsl01 %>% mutate(treatment = 3))
 
# Get treatment totals into a dataset and macro variables
trttotal_pre <- adsl02 %>%
 group_by(treatment) %>%
 summarise(trttotal = n_distinct(usubjid))
 
# Create a dummy dataset for treatment totals
dummy_pre <- data.frame(treatment = 1:3)
 
# Merge actual counts with dummy counts
trttotals <- dummy_pre %>%
 left_join(trttotal_pre, by = "treatment") %>%
 mutate(trttotal = coalesce(trttotal, 0))
 
 
# Create subject level count - top row
sub_count <- adcm02 %>%
 group_by(treatment) %>%
 summarise(
 label = "Overall",
 count = n_distinct(usubjid)
 )
 
# Create ATC2 level counts
atc2_count <- adcm02 %>%
 group_by(cm2atcl, treatment) %>%
 summarise(count = n_distinct(usubjid))
 
# Create ATC4 level counts
atc4_count <- adcm02 %>%
 group_by(cm2atcl, cm4atcl, treatment) %>%
 summarise(count = n_distinct(usubjid))
 
# Create CMDECOD level counts
pt_count <- adcm02 %>%
 group_by(cm2atcl, cm4atcl, cmdecod, treatment) %>%
 summarise(count = n_distinct(usubjid))
 
# Combine top row, ATC2, ATC4, and CMDECOC counts into a single dataset
counts01 <- bind_rows(sub_count, atc2_count, atc4_count, pt_count)
 
# Create zero counts if an event is not present in a treatment
 
# Get all available SOC and PT values
dummy01 <- counts01 %>%
 select(cm2atcl, cm4atcl, cmdecod, label) %>%
 distinct()
 
# Create a row for each treatment
dummy02 <- dummy01 %>%
 expand_grid(treatment = 1:3)
 
# Merge dummy counts with actual counts
counts02 <- dummy02 %>%
 left_join(counts01, by = c("cm2atcl", "cm4atcl", "cmdecod", "label", "treatment")) %>%
 mutate(count = coalesce(count, 0))
 
# Calculate percentages
counts03 <- counts02 %>%
 left_join(trttotals, by = "treatment")
 
counts04 <- counts03 %>%
 mutate(
 cp = ifelse(count != 0,
 paste0(count, " (", sprintf("%.1f", count / trttotal * 100), "%)"),
 as.character(count))
 )
 
# Create the label column
counts05 <- counts04 %>%
 mutate(
 label = ifelse(
 is.na(cm2atcl) & is.na(cm4atcl) & is.na(cmdecod),
 label,
 ifelse(!is.na(cm2atcl) & is.na(cm4atcl) & is.na(cmdecod), cm2atcl,
 ifelse(!is.na(cm2atcl) & !is.na(cm4atcl) & is.na(cmdecod),
 paste0('(*ESC*)R"\\pnhang\\fi220\\li220 "', cm4atcl),
 paste0('(*ESC*)R"\\pnhang\\fi420\\li420 "', cmdecod)
 )
 )
 )
 )
 
# Transpose to obtain treatment as columns
trans01 <- counts05 %>%
 pivot_wider(
 id_cols = c("cm2atcl", "cm4atcl", "cmdecod", "label"),
 names_prefix = "trt",
 names_from = treatment,
 values_from = cp
 )
 
trans02 <- trans01 %>%
 select(cm2atcl, cm4atcl, cmdecod, trt1, trt2, trt3)
 
output <- trans02 %>%
 arrange(!is.na(cm2atcl),cm2atcl, !is.na(cm4atcl),cm4atcl,!is.na(cmdecod),cmdecod)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================