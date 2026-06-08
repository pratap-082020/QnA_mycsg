# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TEG_L105
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
 
 
source("./TFL_TEG_L105_data.r")
 
 
 
#==============================================================================;
# Read input datasets;
#==============================================================================;
adsl01 <- adsl %>% filter(saffl == "Y")
adeg01 <- adeg %>% filter(saffl == "Y")
 
#==============================================================================;
# Create a variable named "treatment" to hold report level column groupings;
#==============================================================================;
 
adsl02<-adsl01 %>%
 mutate(treatment=trt01an) %>%
 bind_rows(adsl01 %>% mutate(treatment=3))
 
adeg02<-adeg01 %>%
 mutate(treatment=trt01an) %>%
 bind_rows(adeg01 %>% mutate(treatment=3))
 
#==============================================================================;
# Get treatment totals into a dataset and into macro variables (for column headers);
#==============================================================================;
trttotal_pre <- adsl02 %>%
 group_by(treatment) %>%
 summarize(trttotal = n_distinct(usubjid))
 
#==============================================================================;
# Create a dummy dataset for treatment totals;
#==============================================================================;
dummy_pre <- tibble(treatment = 1:3)
 
#==============================================================================;
# Merge actual counts with dummy counts;
#==============================================================================;
trttotals <- dummy_pre %>%
 left_join(trttotal_pre, by = "treatment") %>%
 mutate(trttotal = ifelse(is.na(trttotal), 0, trttotal))
 
 
#==============================================================================;
# Restructure the data such that criteria variables become rows;
#==============================================================================;
adeg03 <- bind_rows(
 adeg02 %>% filter(crit1!="") %>% mutate(severity=2, severityc=crit1),
 adeg02 %>% filter(crit2!="") %>% mutate(severity=3, severityc=crit2),
 adeg02 %>% filter(crit3!="") %>% mutate(severity=4, severityc=crit3),
 adeg02 %>% filter(crit4!="") %>% mutate(severity=5, severityc=crit4),
 
)
 
#==============================================================================;
# Obtain counts for the table;
#==============================================================================;
#==============================================================================;
# Get counts for 'n' - number of subjects with non-missing data;
#==============================================================================;
ncount <- adeg02 %>%
 filter(!is.na(aval)) %>%
 group_by(paramn, paramcd, param, avisitn, avisit, treatment) %>%
 summarize(severity = 1, count = n_distinct(usubjid))
 
#==============================================================================;
# Get counts for different levels;
#==============================================================================;
levelscount <- adeg03 %>%
 group_by(paramn, paramcd, param, avisitn, avisit, severity, treatment) %>%
 summarize(count = n_distinct(usubjid))
 
#==============================================================================;
# Combine 'n' and 'levels' counts into a single dataset;
#==============================================================================;
counts01 <- bind_rows(ncount, levelscount)
 
#==============================================================================;
# Create a dummy for all visits with at least one missing result;
#==============================================================================;
#==============================================================================;
# Get distinct values for parameter and visit;
#==============================================================================;
dummy01 <- adeg02 %>%
 filter(!is.na(aval)) %>%
 distinct(paramn, paramcd, param, avisitn, avisit)
 
#==============================================================================;
# Create a record for each treatment and severity level using do loops;
#==============================================================================;
dummy02 <- dummy01 %>%
 cross_join(expand_grid(treatment = 1:3, severity = 1:5))
 
#==============================================================================;
# Merge dummy and actual counts;
#==============================================================================;
counts02 <- dummy02 %>%
 left_join(counts01, by = c("paramn", "paramcd", "param", "avisitn", "avisit", "treatment", "severity")) %>%
 mutate(count = ifelse(is.na(count), 0, count))
 
#==============================================================================;
# Populate 'n' count across all rows within a visit to use in percentage calculation;
#==============================================================================;
counts03 <- counts02 %>%
 left_join(counts02 %>%
 filter(severity == 1) %>%
 select(paramn,paramcd,param,avisitn,avisit,treatment,denom=count),
 by = c("paramn", "paramcd", "param", "avisitn", "avisit", "treatment")) %>%
 mutate(denom = ifelse(is.na(denom), 0, denom))
 
#==============================================================================;
# Calculate percentages and create label;
#==============================================================================;
counts04 <- counts03 %>%
 mutate(
 cp = ifelse(severity != 1 & count!=0,
 paste0(format(count, digits = 3), " (", sprintf("%.1f%%", count / denom * 100), ")"),
 format(count, digits = 3)),
 label = case_when(
 severity == 1 ~ "n",
 severity == 2 ~ "<0",
 severity == 3 ~ ">=0",
 severity == 4 ~ ">30",
 severity == 5 ~ ">60"
 )
 )
 
#==============================================================================;
# Transpose the data such that treatments become columns;
#==============================================================================;
trans01 <- counts04 %>%
 pivot_wider(id_cols=c(paramn,paramcd,param,avisitn,avisit, severity, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt")
 
 
output <- trans01 %>%
 arrange(paramn,avisitn,severity)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================