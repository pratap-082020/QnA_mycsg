# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_L141
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
 
 
source("./TFL_TIS_L141_data.r")
 
library(dplyr)
library(tidyr)
library(broom)
 
#==============================================================================
# Step 1: Filter ADSL and ADRS for FASFL = "Y" and create treatment variable
#==============================================================================
adsl02 <- adsl %>%
 filter(fasfl == "Y") %>%
 mutate(treatment = trt01pn)
 
 
adrs02 <- adrs %>%
 filter(fasfl == "Y") %>%
 mutate(treatment = trt01pn)
 
#==============================================================================
# Step 2: Create dataset of responders and non-responders
#==============================================================================
adrs03 <- adsl02 %>%
 select(usubjid, treatment, age) %>%
 left_join(adrs02 %>% select(usubjid, avalc), by = "usubjid") %>%
 mutate(avalc = if_else(is.na(avalc), "N", avalc))
 
#==============================================================================
# Step 3: Denominator counts
#==============================================================================
denoms <- adsl02 %>%
 count(treatment, name = "denom")
 
#==============================================================================
# Step 4: Responder counts
#==============================================================================
counts01 <- adrs03 %>%
 count(treatment, avalc, name = "count")
 
counts02 <- counts01 %>%
 left_join(denoms, by = "treatment") %>%
 mutate(
 cp = if_else(count > 0, sprintf("%d (%.1f)", count, count / denom * 100), "0"),
 group = 1,
 intord = case_when(avalc == "Y" ~ 1, avalc == "N" ~ 2),
 label = case_when(avalc == "Y" ~ "Responders", avalc == "N" ~ "Non-responders")
 ) %>%
 select(group, intord, label, treatment, cp)
 
#==============================================================================
# Step 5: Logistic regression - OR, CI, p-value
#==============================================================================
adrs03 <- adrs03 %>%
 mutate(
 avalc = factor(avalc, levels = c("N", "Y"))
 )
 
model <- glm(avalc ~ age, data = adrs03, family = binomial())
 
# Odds Ratio and CI
odds01 <- tidy(model, exponentiate = TRUE, conf.int = TRUE) %>%
 filter(term != "(Intercept)") %>%
 mutate(treatment = parse_number(term)) %>%
 transmute(
 treatment=1,
 or = if_else(!is.na(estimate), sprintf("%.2f", estimate), "NE"),
 lower = if_else(!is.na(conf.low), sprintf("%.2f", conf.low), "NE"),
 upper = if_else(!is.na(conf.high), sprintf("%.2f", conf.high), "NE"),
 cp = paste0(or, "(", lower, ",", upper, ")"),
 group = 2,
 intord = 1,
 label = "Odds Ratio (95% CI)"
 )
 
# P-value (global test equivalent: model summary test)
pval_age <- tidy(model) %>%
 filter(term == "age") %>%
 pull(p.value)
 
 
p_val01 <- tibble(
 group = 2,
 intord = 2,
 label = "p-value",
 treatment = 1,
 pval = pval_age,
 cp = if_else(pval < 0.0001, "<.0001", sprintf("%.4f", pval))
)
 
# If you want per-treatment p-value (like SAS by-treatment logistic), loop or re-fit
 
#==============================================================================
# Step 6: Combine results
#==============================================================================
infstats01 <- bind_rows(odds01, p_val01)
 
 
#==============================================================================
# Step 7: Stack and transpose for table output
#==============================================================================
counts04 <- bind_rows(counts02, infstats01) %>%
 arrange(group, intord, label, treatment)
 
trans01 <- counts04 %>%
 pivot_wider(names_from = treatment, values_from = cp, names_prefix = "trt")
 
# Final table
final <- trans01 %>%
 select(group,intord,label,trt1)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================