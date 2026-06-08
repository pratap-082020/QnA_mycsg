# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_L131
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
 
rm(list = ls())
 
 
source("./TFL_TIS_L131_data.r")
 
adrs <- adrs %>%
 rename_with(tolower)
 
library(janitor)
library(broom)
 
#==========================================================
# Step 1: Process input dataset
#==========================================================
adrs02 <- adrs %>%
 mutate(treatment = trt01pn)
 
#==========================================================
# Step 2: Fetch denominators
#==========================================================
denoms <- adrs02 %>%
 count(treatment, name = "denom")
 
 
#==========================================================
# Step 3: Fetch response level count and percent
#==========================================================
counts01 <- adrs02 %>%
 count(treatment, aval) %>%
 left_join(denoms, by = "treatment") %>%
 mutate(percent = 100 * n / denom)
 
counts02 <- counts01 %>%
 filter(aval == 1) %>%
 mutate(
 cp = sprintf("%d (%.1f)", n, percent),
 intord = 1,
 group = 1,
 label = "n (%)"
 ) %>%
 select(group, intord, label, treatment, cp)
 
#==========================================================
# Step 4: Fetch confidence intervals using binomial test
#==========================================================
ci01 <- adrs02 %>%
 mutate(responder = if_else(aval == 1, 1, 0)) %>%
 group_by(treatment) %>%
 summarise(
 n_resp = sum(responder),
 n_total = n(),
 .groups = "drop"
 ) %>%
 mutate(
 ci = map2(n_resp, n_total, ~ binom.test(.x, .y)$conf.int),
 lower = map_dbl(ci, 1),
 upper = map_dbl(ci, 2)
 ) %>%
 mutate(
 cp = paste0(sprintf("%.2f", lower), ",", sprintf("%.2f", upper)),
 group = 1,
 intord = 2,
 label = "95% CI [1]"
 ) %>%
 select(group, intord, label, treatment, cp)
 
#==========================================================
# Step 5: Combine and pivot to final format
#==========================================================
all01 <- bind_rows(counts02, ci01) %>%
 mutate(treatment = as.character(treatment))
 
trans01 <- all01 %>%
 pivot_wider(
 id_cols = c(group, intord, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 ) %>%
 arrange(group, intord, label)
 
#==========================================================
# Step 6: Add group label and finalize output
#==========================================================
label01 <- tibble(
 group = 1,
 intord = 0,
 label = "Responders"
)
 
final <- bind_rows(label01, trans01) %>%
 arrange(group, intord)
 
# View final table
final
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================