# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_LLOGREG01
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
 
 
source("./TFL_TIS_LLOGREG01_data.r")
library(dplyr)
library(tidyr)
library(broom)
library(stringr)
 
#==============================================================================
# Count total subjects (denominator)
#==============================================================================
subjs01 <- adrs %>%
 count(trtpn, trtp, name = "nsubj")
 
#==============================================================================
# Count responders and calculate percent
#==============================================================================
resp01 <- adrs %>%
 filter(avalc == "Y") %>%
 count(trtpn, trtp, name = "count") %>%
 left_join(subjs01, by = c("trtpn", "trtp")) %>%
 mutate(percent = count / nsubj * 100) %>%
 select(-nsubj)
 
#==============================================================================
# Logistic regression for odds ratio and Wald CI
#==============================================================================
adrs$avalc <- factor(adrs$avalc, levels = c("N", "Y"))
adrs$trtp <- factor(adrs$trtp, levels = c("Placebo", "Low Dose", "High Dose"))
 
model <- glm(avalc ~ trtp, data = adrs, family = binomial())
 
# Extract Wald OR and CI manually
coefs <- summary(model)$coefficients
 
odds01 <- tibble(
 term = rownames(coefs),
 estimate = coefs[, "Estimate"],
 std_error = coefs[, "Std. Error"]
) %>%
 filter(term != "(Intercept)") %>%
 mutate(
 trtpn = case_when(
 term == "trtpLow Dose" ~ 2,
 term == "trtpHigh Dose" ~ 3
 ),
 oddsratioest = exp(estimate),
 lowercl = exp(estimate - 1.96 * std_error),
 uppercl = exp(estimate + 1.96 * std_error)
 ) %>%
 select(trtpn, oddsratioest, lowercl, uppercl)
 
# Extract p-values
est01 <- tidy(model) %>%
 filter(str_detect(term, "trtp")) %>%
 mutate(
 trtpn = case_when(
 term == "trtpLow Dose" ~ 2,
 term == "trtpHigh Dose" ~ 3
 )
 ) %>%
 select(trtpn, probchisq = p.value)
 
#==============================================================================
# Combine all
#==============================================================================
all01 <- subjs01 %>%
 left_join(resp01, by = c("trtpn", "trtp")) %>%
 left_join(odds01, by = "trtpn") %>%
 left_join(est01, by = "trtpn")
 
#==============================================================================
# Final formatting
#==============================================================================
all02 <- all01 %>%
 mutate(
 n = as.character(nsubj),
 resp = if_else(!is.na(count), str_c(count, "(", sprintf("%.1f",percent), ")"), NA_character_),
 or = case_when(
 trtpn == 1 ~ "Reference",
 TRUE ~ sprintf("%.2f", oddsratioest)
 ),
 lcl = if_else(!is.na(lowercl), sprintf("%.2f", lowercl), "-"),
 ucl = if_else(!is.na(uppercl), sprintf("%.2f", uppercl), "-"),
 ci = if_else(trtpn == 1, "-", paste0(lcl, " - ", ucl)),
 pval = if_else(trtpn == 1 | is.na(probchisq), "-", sprintf("%.3f", probchisq))
 ) %>%
 select(trtpn, trtp, n, resp, or, ci, pval)
 
# View result
all02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================