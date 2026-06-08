# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_L151
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
 
source("./TFL_TIS_L151_data.r")
 
# Load required libraries
library(tidyverse)
library(broom)
library(emmeans)
#==============================================================================
# Read and prepare input datasets
#==============================================================================
 
adsl02 <- adsl %>%
 filter(fasfl == "Y") %>%
 mutate(treatment = factor(trt01pn, levels = c(1, 2, 3)))  # placebo, low, high
 
adlb02 <- adlb %>%
 filter(fasfl == "Y", avisitn == 12) %>%
 mutate(treatment = factor(trt01pn, levels = c(1, 2, 3)))
 
#==============================================================================
# Calculate subject count by treatment
#==============================================================================
 
n_df <- adlb02 %>%
 count(treatment, name = "n") %>%
 mutate(
 group = case_when(
 treatment=="1" ~ 3,
 treatment=="2" ~ 2,
 treatment=="3" ~ 1
 ),
 order = 1,
 n = as.character(n)
 )
 
#==============================================================================
# Fit ANCOVA model
#==============================================================================
 
model <- lm(chg ~ treatment + blhba1c, data = adlb02)
 
#==============================================================================
# Least Squares Means
#==============================================================================
 
lsmeans_tbl <- emmeans(model, ~ treatment)
 
lsmeans_df <- as_tibble(lsmeans_tbl) %>%
 mutate(
 group = case_when(
 treatment=="1" ~ 3,
 treatment=="2" ~ 2,
 treatment=="3" ~ 1
 ),
 order = 1,
 lsm_se = sprintf("%.2f(%.3f)", emmean, SE),
 ci     = sprintf("(%.2f,%.2f)", lower.CL, upper.CL)
 ) %>%
 select(group, order, lsm_se, ci)
 
#==============================================================================
# Pairwise Comparisons
#==============================================================================
 
contrasts <- contrast(lsmeans_tbl, method = list(
 "low vs placebo"  = c(0, 1, -1),  # low - placebo
 "high vs placebo" = c(1, 0, -1),  # high - placebo
 "high vs low"     = c(1, -1, 0)   # high - low
))
 
contrast_df <- as_tibble(summary(contrasts, infer = TRUE)) %>%
 mutate(
 group = case_when(
 contrast == "low vs placebo" ~ 2,
 contrast == "high vs placebo" ~ 3,
 contrast == "high vs low" ~ 3
 ),
 order = case_when(
 contrast == "high vs low" ~ 2,
 TRUE ~ 1
 ),
 dlsm_se = sprintf("%.2f(%.3f)", estimate, SE),
 dci     = sprintf("(%.2f,%.2f)", lower.CL, upper.CL),
 p_value = if_else(p.value < 0.0001, "<.0001", sprintf("%.3f", p.value))
 ) %>%
 select(group, order, dlsm_se, dci, p_value) %>%
 arrange(group, order)
 
#==============================================================================
# Add treatment totals from ADSL
#==============================================================================
 
denoms <- adsl02 %>% count(treatment, name = "denom") %>%
 mutate(
 group = case_when(
 treatment=="1" ~ 3,
 treatment=="2" ~ 2,
 treatment=="3" ~ 1
 )
 )
 
#==============================================================================
# Merge all parts
#==============================================================================
 
all01 <- full_join(n_df, lsmeans_df, by = c("group", "order")) %>%
 full_join(contrast_df, by = c("group", "order")) %>%
 left_join(select(denoms, group, denom), by = "group")
 
#==============================================================================
# Add treatment labels and comparisons
#==============================================================================
 
final_df <- all01 %>%
 mutate(
 trtgroup = case_when(
 group == 1 ~ paste0("Placebo (N=", denom, ")"),
 group == 2 ~ paste0("Low Dose (N=", denom, ")"),
 group == 3 ~ paste0("High Dose (N=", denom, ")")
 ),
 comparison = case_when(
 group == 2 & order == 1 ~ "Low Dose vs Placebo",
 group == 3 & order == 1 ~ "High Dose vs Placebo",
 group == 3 & order == 2 ~ "High Dose vs Low Dose"
 )
 ) %>%
 select(group, order, trtgroup, comparison, n, lsm_se, ci, dlsm_se, dci, p_value) %>%
 arrange(group, order)
 
view(final_df)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================