# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TPC_L101
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
 
 
source("./TFL_TPC_L101_data.r")
 
# Load required libraries
library(tidyverse)
 
#==============================================================================
# Process input data
#==============================================================================
adsl01 <- adsl %>%
 filter(pkfl == "Y") %>%
 mutate(treatment = trt01an)
 
adpc01 <- adpc %>%
 filter(pkfl == "Y") %>%
 mutate(treatment = trt01an,
 logaval = if_else(aval > 0, log(aval), NA_real_))
 
#==============================================================================
# Obtain descriptive statistics
#==============================================================================
stats01 <- adpc01 %>%
 arrange(paramcd, avisitn, avisit, atptn, atpt) %>%
 group_by(paramcd, avisitn, avisit, atptn, atpt, treatment) %>%
 summarise(
 an = n(),
 amean = mean(aval, na.rm = TRUE),
 astd = sd(aval, na.rm = TRUE),
 amin = min(aval, na.rm = TRUE),
 amedian = median(aval, na.rm = TRUE),
 amax = max(aval, na.rm = TRUE),
 ln = n(),
 lmean = mean(logaval, na.rm = TRUE),
 lstd = sd(logaval, na.rm = TRUE),
 lmin = min(logaval, na.rm = TRUE),
 lmedian = median(logaval, na.rm = TRUE),
 lmax = max(logaval, na.rm = TRUE)
 ) %>%
 ungroup()
 
#==============================================================================
# Process the statistics as per presentation requirements
#==============================================================================
stats02 <- stats01 %>%
 mutate(
 n = if_else(!is.na(an), as.character(an), ""),
 mean = if_else(!is.na(amean), sprintf("%.2f", amean), ""),
 std = if_else(!is.na(astd), sprintf("%.3f", astd), ""),
 median = if_else(!is.na(amedian), sprintf("%.2f", amedian), ""),
 min = if_else(!is.na(amin), sprintf("%.1f", amin), ""),
 max = if_else(!is.na(amax), sprintf("%.1f", amax), ""),
 gmean = if_else(!is.na(lmean), sprintf("%.2f", exp(lmean)), ""),
 gstd = if_else(!is.na(lstd), sprintf("%.3f", exp(lstd)), ""),
 minmax = if_else(!is.na(amin) & !is.na(amax), str_c(min, ", ", max), ""),
 variance = if_else(!is.na(lstd), lstd^2, NA_real_),
 varexp = exp(variance),
 var_1 = varexp - 1,
 varsqrt = sqrt(var_1),
 gcv = if_else(!is.na(lstd), sprintf("%.1f", varsqrt * 100), "")
 )
 
#==============================================================================
# Keep only the required variables
#==============================================================================
stats03 <- stats02 %>%
 select(paramcd, avisitn, avisit, atptn, atpt, treatment, n, mean, std, gmean, gstd, gcv, median, minmax)
 
#==============================================================================
# Restructure the statistics such that they appear as 'rows' - using pivot_longer
#==============================================================================
stats04 <- stats03 %>%
 pivot_longer(cols = c(n, mean, std, gmean, gstd, gcv, median, minmax),
 names_to = "statistic",
 values_to = "value") %>%
 mutate(statistic = str_to_upper(statistic))
 
#==============================================================================
# Create some supporting variables as per sorting and presentation requirements
#==============================================================================
stats05 <- stats04 %>%
 mutate(
 intord = case_when(
 statistic == "N"      ~ 1,
 statistic == "MEAN"   ~ 2,
 statistic == "STD"    ~ 3,
 statistic == "GMEAN"  ~ 4,
 statistic == "GSTD"   ~ 5,
 statistic == "GCV"    ~ 6,
 statistic == "MEDIAN" ~ 7,
 statistic == "MINMAX" ~ 8,
 TRUE                  ~ NA_integer_
 )
 ) %>%
 arrange(paramcd, avisitn, avisit, atptn, atpt, intord)
 
#==============================================================================
# Restructure the data such that treatments appear as 'columns' - using pivot_wider
#==============================================================================
stats06 <- stats05 %>%
 pivot_wider(names_from = treatment, values_from = value, names_prefix = "trt")
 
#==============================================================================
# Create final dataset - keeping only required variables
#==============================================================================
final <- stats06 %>%
 select(paramcd, avisitn, avisit, atptn, atpt, intord, statistic, starts_with("trt"))
 
output <- final
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================