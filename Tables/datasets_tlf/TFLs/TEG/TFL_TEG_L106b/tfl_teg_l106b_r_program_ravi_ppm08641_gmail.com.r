# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TEG_L106b
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
 
 
source("./TFL_TEG_L106b_data.r")
 
 
#==============================================================================;
# Read input datasets;
#==============================================================================;
 
adsl01 <- adsl %>% filter(saffl == "Y")
adeg01 <- adeg %>% filter(saffl == "Y")
 
#==============================================================================;
# Create a variable named 'treatment' to hold report level column groupings;
#==============================================================================;
 
adsl02<-adsl01 %>%
 mutate(treatment=trt01an)
 
adeg02<-adeg01 %>%
 mutate(treatment=trt01an)
 
 
#==============================================================================;
# Populate the AVLAC of baseline visit across all visits as BASEC;
#==============================================================================;
base01 <- adeg02 %>%
 filter(avisit == "Baseline") %>%
 mutate(basec = avalc) %>%
 select(usubjid, paramcd, treatment, basec)
 
adeg03 <- adeg02 %>%
 left_join(base01, by = c("usubjid", "paramcd", "treatment"))
 
#==============================================================================;
# Subset only postbaseline visits;
# Create numeric variables in ADEG corresponding to each level in AVALC and BASEC;
#==============================================================================;
adeg04 <- adeg03 %>%
 filter(avisitn > 6) %>%
 mutate(
 result = case_when(
 avalc == "NORMAL" ~ 1,
 avalc == "ABNORMAL - CLINICALLY SIGNIFICANT" ~ 3,
 avalc == "ABNORMAL - NOT CLINICALLY SIGNIFICANT" ~ 2,
 avalc == "" | is.na(avalc) ~ 4
 ),
 bresult = case_when(
 basec == "NORMAL" ~ 1,
 basec == "ABNORMAL - CLINICALLY SIGNIFICANT" ~ 3,
 basec == "ABNORMAL - NOT CLINICALLY SIGNIFICANT" ~ 2,
 basec == "" | is.na(basec) ~ 4
 )
 )
 
#==============================================================================;
# Get treatment totals into a dataset and into macro variables (for column headers);
#==============================================================================;
trttotal_pre <- adsl02 %>%
 group_by(treatment) %>%
 summarize(trttotal = n_distinct(usubjid))
 
#==============================================================================;
# Create dummy dataset for treatment totals;
#==============================================================================;
dummy_pre <- tibble(treatment = 1:2)
 
#==============================================================================;
# Merge actual counts with dummy counts;
#==============================================================================;
trttotals <- dummy_pre %>%
 left_join(trttotal_pre, by = "treatment") %>%
 mutate(trttotal = ifelse(is.na(trttotal), 0, trttotal))
 
 
#==============================================================================;
# Obtain actual counts;
#==============================================================================;
counts01 <- adeg04 %>%
 filter(!is.na(result) & !is.na(bresult)) %>%
 group_by(param, avisitn, avisit, treatment, result, bresult) %>%
 summarize(count = n())
 
#==============================================================================;
# Create dummy counts for all observed visits;
#==============================================================================;
dummy01 <- adeg04 %>%
 select(param, avisitn, avisit) %>%
 distinct()
 
dummy02 <- dummy01 %>%
 expand_grid(treatment = 1:2, result = 1:4, bresult = 1:4)
 
#==============================================================================;
# Merge dummy and actual counts;
#==============================================================================;
counts02 <- dummy02 %>%
 left_join(counts01, by = c("param", "avisitn", "avisit", "treatment", "result", "bresult")) %>%
 mutate(count = ifelse(is.na(count), 0, count))
 
#==============================================================================;
# Fetch denominators into the counts dataset;
#==============================================================================;
counts03 <- counts02 %>%
 left_join(trttotals, by="treatment")
 
#==============================================================================;
# Derive percentage and concatenate count and percentage;
#==============================================================================;
counts04 <- counts03 %>%
 mutate(
 cp = paste(format(count, digits=3), " (", sprintf("%.1f", count / trttotal * 100), "%)")
 )
 
#==============================================================================;
# Transpose the data such that treatments and baseline result become columns;
#==============================================================================;
counts05 <- counts04 %>%
 pivot_wider(
 id_cols = c(param, treatment, avisitn, avisit, result),
 names_from = c("bresult"),
 values_from = cp,
 names_prefix = "grp_"
 )
 
#==============================================================================;
# Create a label column as presentation requirement;
#==============================================================================;
counts06 <- counts05 %>%
 mutate(
 label = case_when(
 result == 1 ~ "Normal",
 result == 2 ~ "Abnormal - NCS",
 result == 3 ~ "Abnormal - CS",
 result == 4 ~ "Missing"
 ),
 treatmentc=case_when(
 treatment == 1 ~ "Placebo",
 treatment == 2 ~ "Active"
 )
 )
 
output <- counts06 %>%
 arrange(param, treatment, avisitn, result)
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================