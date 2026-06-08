# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_LTTEST102
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
 
 
source("./TFL_TIS_LTTEST102_data.r")
 
 
 
#==============================================================================;
#Filter input data;
#==============================================================================;
 
trig01 <- adlb %>%
 filter(avisit=="Week 12") %>%
 mutate(group=1, dp=0, treatment=trtpn, result=chg)
 
 
#==============================================================================;
#Get the descriptive statistics and process them;
#==============================================================================;
 
stats01 <- trig01 %>%
 group_by(group,dp,treatment) %>%
 summarize(
 count = n(),
 result_n = sum(!is.na(result)),
 result_nmiss = sum(is.na(result)),
 result_mean = mean(result, na.rm = TRUE),
 result_stddev = sd(result, na.rm = TRUE),
 result_median = median(result, na.rm = TRUE),
 result_min = min(result, na.rm=TRUE),
 result_max = max(result, na.rm=TRUE),
 result_q1 = quantile(result, 0.25, type=2, na.rm = TRUE),
 result_q3 = quantile(result, 0.75, type=2, na.rm = TRUE)
 ) %>%
 ungroup() %>%
 complete(nesting(group,dp),treatment=1,
 fill=list(count=0,result_n=0,result_nmiss=0))
 
 
#------------------------------------------------------------------------------;
#Concatenate the statistics;
#------------------------------------------------------------------------------;
 
 
stats02 <- stats01 %>%
 mutate(
 
 hint=str_length(trunc(max(result_max, na.rm = TRUE))),
 lint=str_length(trunc(min(result_min, na.rm = TRUE))),
 hint2  = max(hint, lint, 3),
 
 
 #give a minimum width of 3 even if all integer components across all
 #analysis variables could be less than 3. This is decided based on
 #maximum number of subjects expected in the study
 
 intfmt = str_c("%",hint2,".0f"),
 
 asisfmt =
 if_else(dp==0,str_c("%",hint2, ".",dp,"f"),
 str_c("%",hint2+dp+1, ".",dp,"f")),
 
 plusonefmt = str_c("%",hint2+dp+2, ".",dp+1,"f"),
 plustwofmt = str_c("%",hint2+dp+3, ".",dp+2,"f"),
 
 n = sprintf(intfmt, result_n),
 nmiss = str_c( " (", str_trim(sprintf(intfmt, result_nmiss)), ")"),
 nnmiss = str_c(n,nmiss),
 
 mean = if_else(is.na(result_mean), "", sprintf(plusonefmt, result_mean)),
 sd = if_else(is.na(result_stddev),"", sprintf(plustwofmt,result_stddev)),
 sd2 = if_else(!is.na(result_mean) & is.na(result_stddev), "-", sd),
 sd3 = if_else(sd2!="", str_c(" (",sd2,")"), ""),
 
 meansd = str_c(mean,sd3),
 
 median = if_else(is.na(result_median), "", sprintf(plusonefmt, result_median)),
 q1 = if_else(is.na(result_q1), "", sprintf(plusonefmt, result_q1)),
 q3 = if_else(is.na(result_q3), "", sprintf(plusonefmt, result_q3)),
 q1q3 = if_else(is.na(result_q1), "", str_c(q1, ", ", q3)),
 
 min = if_else(is.na(result_min),"",sprintf(asisfmt, result_min)),
 max = if_else(is.na(result_max),"",sprintf(asisfmt, result_max)),
 minmax = if_else(is.na(result_min), "", str_c(min, ", ", max)),
 
 )
 
#------------------------------------------------------------------------------;
#transpose the data such that statistics are rows;
#------------------------------------------------------------------------------;
 
 
stats03 <- stats02 %>%
 pivot_longer(
 cols = c(nnmiss,meansd,median,q1q3,minmax)
 ) %>%
 select(group,treatment,name,value)
 
#------------------------------------------------------------------------------;
#supporting display variables;
#------------------------------------------------------------------------------;
 
stats04 <- stats03 %>%
 mutate(
 grouplabel=case_when(
 group==1 ~ "Triglycerides"
 ),
 name = str_to_upper(name),
 statistic = case_when(
 name=="NNMISS" ~ "n (missing)",
 name=="MEANSD" ~ "Mean (SD)",
 name=="MEDIAN" ~ "Median",
 name=="Q1Q3" ~ "Q1, Q3",
 name=="MINMAX" ~ "Min, Max",
 ),
 intord = case_when(
 name=="NNMISS" ~ 1,
 name=="MEANSD" ~ 2,
 name=="MEDIAN" ~ 3,
 name=="Q1Q3" ~ 4,
 name=="MINMAX" ~ 5,
 )
 )
 
#------------------------------------------------------------------------------;
#transpose the data to display treatments as columns;
#------------------------------------------------------------------------------;
 
stats05 <- stats04 %>%
 pivot_wider(
 id_cols = c(group,grouplabel,intord,statistic),
 values_from = value,
 names_from = treatment,
 names_prefix = "trt"
 )
 
stats05
 
 
#==============================================================================;
#Pvalue using t-test;
#==============================================================================;
 
 
ttest_res <- t.test(formula=chg~treatment, data=trig01, var.equal=TRUE)
 
# Convert result into a tidy tibble
ttest <- tibble(
 method = ttest_res$method,
 estimate = ttest_res$estimate,
 null_value = ttest_res$null.value,
 statistic = ttest_res$statistic,
 p_value = ttest_res$p.value,
 conf_low = ttest_res$conf.int[1],
 conf_high = ttest_res$conf.int[2],
 df = ttest_res$parameter
)
 
pval01 <- ttest %>%
 mutate(group=1,
 intord=6,
 statistic="p-value",
 grouplabel="Triglycerides",
 trt1=if_else(p_value < 0.0001, "<0.0001", sprintf("%0.4f", p_value))) %>%
 select(group, grouplabel,intord, trt1, statistic, trt1) %>%
 distinct()
 
 
#==============================================================================;
#Append descriptive stats with inferential statistics;
#==============================================================================;
 
stats06 <- bind_rows(stats05, pval01)
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================