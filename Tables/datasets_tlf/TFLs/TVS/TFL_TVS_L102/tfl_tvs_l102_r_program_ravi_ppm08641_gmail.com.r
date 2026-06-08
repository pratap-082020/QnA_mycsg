# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TVS_L102
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
 
 
source("./TFL_TVS_L102_data.r")
 
 
# Filter datasets
advs01 <- advs %>%
 filter(saffl == "Y")
 
adsl01 <- adsl %>%
 filter(saffl == "Y")
 
# Create a variable named 'treatment' and duplicate rows
advs02 <- advs01 %>%
 mutate(
 treatment = trt01an
 ) %>%
 bind_rows(advs01 %>% mutate(treatment = 3))
 
adsl02 <- adsl01 %>%
 mutate(
 treatment = trt01an
 ) %>%
 bind_rows(adsl01 %>% mutate(treatment = 3))
 
# Get treatment totals into a dataset and macro variables (for column headers)
# Get treatment totals based on actual data
trttotal_pre <- adsl02 %>%
 group_by(treatment) %>%
 summarise(trttotal = n_distinct(usubjid))
 
# Create a dummy dataset for treatment totals
dummy_pre <- data.frame(treatment = 1:3)
 
# Merge actual counts with dummy counts
trttotals <- dummy_pre %>%
 left_join(trttotal_pre, by = "treatment") %>%
 mutate(trttotal = coalesce(trttotal, 0))
 
# Restructure the dataset to stack all criteria in a common variable
# Create a common variable to hold the criteria
# Create a corresponding numeric variable to sort the criteria within each parameter
advs03 <- bind_rows(
 advs02 %>% filter(crit1!="") %>% mutate(criteria=crit1,criteriaflag=crit1fl,criterian=1),
 advs02 %>% filter(crit2!="") %>% mutate(criteria=crit2,criteriaflag=crit2fl,criterian=2),
 advs02 %>% filter(crit3!="") %>% mutate(criteria=crit3,criteriaflag=crit3fl,criterian=3),
)
 
# Get 'n' counts
ncounts <- advs03 %>%
 filter(criteriaflag == "Y") %>%
 group_by(paramn, paramcd, param, treatment, criterian, criteria) %>%
 summarise(ncount = n_distinct(usubjid))
 
# Get 'm' counts
mcounts <- advs03 %>%
 filter(criteriaflag %in% c("Y", "N")) %>%
 group_by(paramn, paramcd, param, treatment, criterian, criteria) %>%
 summarise(mcount = n_distinct(usubjid))
 
# Create a dummy to hold each criterion (within a parameter) for all treatments
# Get unique criteria values within each parameter
dummy01 <- advs03 %>%
 select(paramn, paramcd, param, criterian, criteria) %>%
 distinct()
 
# Create a row for each treatment using do loops
dummy02 <- dummy01 %>%
 expand_grid(treatment = 1:3)
 
# Merge dummy and actual counts
counts01 <- dummy02 %>%
 left_join(mcounts, by = c("paramn", "paramcd", "param", "criterian", "criteria", "treatment")) %>%
 left_join(ncounts, by = c("paramn", "paramcd", "param", "criterian", "criteria", "treatment")) %>%
 mutate(
 ncount = coalesce(ncount, 0),
 mcount = coalesce(mcount, 0)
 )
 
# Calculate percentages
counts02 <- counts01 %>%
 mutate(
 cp = ifelse(mcount != 0,
 paste0(ncount, "/", mcount, " (", sprintf("%.1f", ncount / mcount * 100), "%)"),
 paste0(0, "/", 0))
 )
 
# Transpose the data so that treatments become columns
trans01 <- counts02 %>%
 pivot_wider(
 id_cols = c("paramn", "paramcd", "param", "criterian", "criteria"),
 names_prefix = "trt",
 names_from = treatment,
 values_from = cp
 )
 
output <- trans01 %>%
 arrange(paramn,criterian)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================