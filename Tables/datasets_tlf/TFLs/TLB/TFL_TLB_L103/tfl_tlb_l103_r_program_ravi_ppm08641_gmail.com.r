# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TLB_L103
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
 
 
source("./TFL_TLB_L103_data.r")
 
 
#==============================================================================
# Read input datasets
#==============================================================================
 
# Read datasets and filter rows
adlb01 <- adlb %>%
 filter(saffl == "Y")
 
adsl01 <- adsl %>%
 filter(saffl == "Y")
 
#==============================================================================
# Create a variable named 'treatment' to hold report level column groupings
# Also create duplicate rows for presenting total column
#==============================================================================
 
adlb02 <- bind_rows(
 mutate(adlb01,treatment = trt01an),
 mutate(adlb01,treatment = 3)
 )
 
adsl02 <- bind_rows(
 mutate(adsl01,treatment = trt01an),
 mutate(adsl01,treatment = 3)
)
#==============================================================================
# Create numeric variables corresponding to anrind and bnrind
#==============================================================================
 
adlb03 <- adlb02 %>%
 mutate(anrindn = case_when(
 anrind == "LOW" ~ 1,
 anrind == "NORMAL" ~ 2,
 anrind == "HIGH" ~ 3,
 anrind == "" ~ 99,
 TRUE ~ NA
 ),
 bnrindn = case_when(
 bnrind == "LOW" ~ 1,
 bnrind == "NORMAL" ~ 2,
 bnrind == "HIGH" ~ 3,
 bnrind == "" ~ 99,
 TRUE ~ NA
 ))
#==============================================================================
# Get treatment totals into a dataset and into macro variables (for column headers)
#==============================================================================
 
trttotal_pre <- adsl02 %>%
 group_by(treatment) %>%
 summarise(trttotal = n_distinct(usubjid))
 
# Create a dummy dataset for treatment totals
dummy_pre <- tibble(treatment = 1:3)
 
# Merge actual counts with dummy counts
trttotals <- dummy_pre %>%
 left_join(trttotal_pre, by = "treatment") %>%
 mutate(trttotal = ifelse(is.na(trttotal), 0, trttotal))
 
#==============================================================================;
#Create a record for each safety for each analysis visit;
#==============================================================================;
 
dummy01 <- adlb02 %>%
 distinct(paramn, paramcd, param, avisitn, avisit) %>%
 filter(!is.na(paramn))
 
dummy02 <- adsl02 %>%
 cross_join(dummy01)
 
# Merge actual and dummy data
adlb04 <- adlb03 %>%
 full_join(dummy02, by = c("usubjid", "treatment", "paramn", "paramcd", "param", "avisitn", "avisit", "saffl", "trt01an")) %>%
 mutate(anrindn = ifelse(is.na(anrindn) & !is.na(param), 99, anrindn),
 bnrindn = ifelse(is.na(bnrindn) & !is.na(param), 99, bnrindn)) %>%
 select(-anrind, -bnrind)
 
# Duplicating data to create a total row and total column
adlb04_1 <- bind_rows(
 mutate(adlb04),
 adlb04 %>% filter(anrindn !=99) %>% mutate(anrindn=98)
)
 
adlb05 <- bind_rows(
 mutate(adlb04_1),
 adlb04_1 %>% filter(bnrindn !=99) %>% mutate(bnrindn=98)
)
 
#==============================================================================;
#Obtain counts;
#==============================================================================;
 
counts01 <- adlb05 %>%
 group_by(paramn, paramcd, param, avisitn, avisit, anrindn, bnrindn, treatment) %>%
 summarise(count = n_distinct(usubjid)) %>%
 ungroup()
 
# Create dummy for all levels of bnrindn and anrindn
dummyx01 <- adlb05 %>%
 distinct(paramn, paramcd, param, avisitn, avisit)
 
dummyx02 <- expand_grid(anrindn = c(1, 2, 3, 98, 99), bnrindn = c(1, 2, 3, 98, 99), treatment = 1:3) %>%
 cross_join(dummyx01) %>%
 arrange(paramn, paramcd, param, avisitn, avisit, anrindn, bnrindn, treatment)
 
# Merge dummy and actual counts
counts02 <- counts01 %>%
 full_join(dummyx02, by = c("paramn", "paramcd", "param", "avisitn", "avisit", "anrindn", "bnrindn", "treatment")) %>%
 mutate(count = ifelse(is.na(count), 0, count))
 
# Get denominator to calculate percentages
denoms01 <- counts02 %>%
 filter(anrindn == 98) %>%
 rename(denom = count) %>%
 select(-anrindn)
 
counts03 <- counts02 %>%
 left_join(denoms01,by=c("paramn", "paramcd", "param", "avisitn", "avisit", "bnrindn", "treatment"))
 
# Bring treatment total into counts dataset to concatenate to the treatment label
counts03 <- counts03 %>%
 left_join(trttotals, by = "treatment")
 
# Calculate percentages and create a label column
counts04 <- counts03 %>%
 mutate(cp = ifelse(anrindn %in% c(1, 2, 3) & bnrindn %in% c(1,2,3),
 ifelse(count!=0 & anrindn %in% c(1, 2, 3) & bnrindn %in% c(1,2,3),
 paste0(count, " (", sprintf("%.1f", count / denom * 100), ")"),
 as.character(count)
 ),
 as.character(count)
 ),
 label = case_when(anrindn == 1 ~ "Low",
 anrindn == 2 ~ "Normal",
 anrindn == 3 ~ "High",
 anrindn == 98 ~ "Total",
 anrindn == 99 ~ "No Data"),
 treatmentc = case_when(treatment == 1 ~ paste0("Placebo (N=", trttotal, ")"),
 treatment == 2 ~ paste0("Active (N=", trttotal, ")"),
 treatment == 3 ~ paste0("Total (N=", trttotal, ")"))) %>%
 arrange(paramn,avisitn,treatment,anrindn,bnrindn)
 
# Transpose data such that the baseline indicator becomes columns
trans01 <-counts04 %>%
 pivot_wider(
 id_cols = c(paramn, paramcd, param, avisitn, avisit, anrindn, label, treatment, treatmentc),
 names_from = bnrindn,
 values_from = cp,
 names_prefix = "c") %>%
 arrange(paramn,avisitn,treatment,anrindn)
 
 
output<-trans01 %>%
 select(paramn,paramcd, param, avisitn,avisit,treatment,treatmentc,anrindn,label,c1,c2,c3,c98,c99)
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================