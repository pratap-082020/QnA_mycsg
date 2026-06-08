# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_LREPMS101
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
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
library(lubridate)
library(pharmaRTF)
rm(list = ls())
 
 
source("./TFL_TIS_LREPMS101_data.r")
 
library(dplyr)
library(nlme)
library(emmeans)
library(tidyr)
library(stringr)
 
#==============================================================================
# Filter for required subset
#==============================================================================
adlb01 <- adlb %>%
 filter(paramcd == "HBA1C", saffl == "Y", avisitn > 0) %>%
 mutate(treatment = factor(trtpn,levels = c(1, 2)))
 
#==============================================================================
# Descriptive statistics
#==============================================================================
stats01 <- adlb01 %>%
 group_by(paramn, paramcd, param, avisitn, avisit, treatment) %>%
 summarise(numobs = n(), .groups = "drop") %>%
 mutate(n = as.character(numobs),
 treatment=as.numeric(treatment))
 
#==============================================================================
# MMRM using nlme::lme
#==============================================================================
mmrm_model <- lme(
 fixed = chg ~ base + treatment * factor(avisitn),
 random = ~1 | usubjid,
 correlation = corSymm(form = ~avisitn | usubjid),
 weights = varIdent(form = ~1 | avisitn),
 data = adlb01,
 method = "REML",
 na.action = na.exclude
)
 
#==============================================================================
# LSMeans (emmeans) and Comparisons
#==============================================================================
lsmeans_tbl <- emmeans(mmrm_model, ~ treatment | avisitn)
 
lsmeans_df <- as_tibble(lsmeans_tbl) %>%
 mutate(
 lsm = if_else(!is.na(emmean), sprintf("%.2f", round(emmean, 2)), "NE"),
 se = if_else(!is.na(SE), sprintf("%.3f", round(SE, 3)), "NE"),
 lsm_se = paste0(lsm, "(", se, ")"),
 lcl = if_else(!is.na(lower.CL), sprintf("%.2f", round(lower.CL, 2)), "NE"),
 ucl = if_else(!is.na(upper.CL), sprintf("%.2f", round(upper.CL, 2)), "NE"),
 ci = paste0("(", lcl, ",", ucl, ")"),
 treatment = as.numeric(as.character(treatment))
 ) %>%
 select(avisitn, treatment, lsm_se, ci)
 
#==============================================================================
# Pairwise differences (Drug X vs Placebo)
#==============================================================================
contrast_df <- contrast(lsmeans_tbl, method = "revpairwise", adjust = "none") %>%
 summary(infer = TRUE) %>%
 as_tibble() %>%
 filter(contrast == "treatment2 - treatment1") %>%
 mutate(
 dlsm = if_else(!is.na(estimate), sprintf("%.2f", round(estimate, 2)), "NE"),
 dse = if_else(!is.na(SE), sprintf("%.3f", round(SE, 3)), "NE"),
 dlsm_se = paste0(dlsm, "(", dse, ")"),
 dlcl = if_else(!is.na(lower.CL), sprintf("%.2f", round(lower.CL, 2)), "NE"),
 ducl = if_else(!is.na(upper.CL), sprintf("%.2f", round(upper.CL, 2)), "NE"),
 dci = paste0("(", dlcl, ",", ducl, ")"),
 dpval = if_else(!is.na(p.value), sprintf("%.4f", round(p.value, 4)), "NE"),
 treatment = 2  # Drug X
 ) %>%
 select(avisitn, treatment, dlsm_se, dci, dpval)
 
#==============================================================================
# Merge descriptive + LSMeans + differences
#==============================================================================
stats03 <- stats01 %>%
 left_join(lsmeans_df, by = c("avisitn", "treatment")) %>%
 left_join(contrast_df, by = c("avisitn", "treatment"))
 
#==============================================================================
# Add treatment labels
#==============================================================================
stats04 <- stats03 %>%
 mutate(
 treatmentc = case_when(
 treatment == 1 ~ "Placebo",
 treatment == 2 ~ "Drug X"
 )
 )
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================