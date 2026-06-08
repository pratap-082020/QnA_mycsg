# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_L121
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
library(broom)
 
rm(list = ls())
 
source("./TFL_TIS_L121_data.r")
 
adsl <- adsl %>%
 rename_with(tolower)
 
grouplabels <-c('1'="Age", '2'="Weight")
 
#==============================================================================;
#Filter input data;
#==============================================================================;
 
adsl01 <- adsl %>%
 filter(ittfl=="Y")
 
#==============================================================================;
#Account the subjects for total column;
#==============================================================================;
 
adsl02 <- bind_rows(
 adsl01 %>% mutate(treatment=trt01pn)
)
 
#==============================================================================;
#Bring different analysis variables into a common variable;
#==============================================================================;
 
adsl03 <- bind_rows(
 adsl02 %>% mutate(group=3, result=age, dp=0),
 adsl02 %>% mutate(group=4, result=weightbl, dp=1),
)
 
#==============================================================================;
#Get the descriptive statistics and process them;
#==============================================================================;
 
stats01 <- adsl03 %>%
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
 complete(nesting(group,dp),treatment=1:3,
 fill=list(count=0,result_n=0,result_nmiss=0))
 
 
#------------------------------------------------------------------------------;
#Concatenate the statistics;
#------------------------------------------------------------------------------;
 
stats02 <- stats01 %>%
 mutate(
 
 #simplified approach
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
 cols = c(n, mean, sd, min, median, max)
 ) %>%
 select(group,treatment,name,value)
 
#------------------------------------------------------------------------------;
#supporting display variables;
#------------------------------------------------------------------------------;
 
stats04 <- stats03 %>%
 mutate(
 grouplabel=case_when(
 group==3 ~ "Age (Years)",
 group==4 ~ "Weight (Kg)"
 ),
 name = str_to_upper(name),
 statistic = case_when(
 name=="N" ~ "n",
 name=="MEAN" ~ "Mean",
 name=="SD" ~ "SD",
 name=="MEDIAN" ~ "Median",
 name=="MIN" ~ "Min",
 name=="MAX" ~ "Max"
 ),
 intord = case_when(
 name=="N" ~ 1,
 name=="MEAN" ~ 2,
 name=="SD" ~ 3,
 name=="MEDIAN" ~ 5,
 name=="MIN" ~ 4,
 name=="MAX" ~ 6
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
 names_prefix = "trt_"
 )
 
#==============================================================================;
#Inferential statistics;
#==============================================================================;
 
 
 
events01 <- adsl03 %>%
 mutate(intord=1)
 
#==============================================================================
# Step 2: Run group-wise GLM and extract p-values (like PROC GLM + ODS OUTPUT)
#==============================================================================
 
p_val01 <- events01 %>%
 group_by(group, intord) %>%
 nest() %>%
 mutate(
 model = map(data, ~ lm(result ~ factor(treatment), data = .x)),
 anova_tbl = map(model, ~ anova(.x) %>% tidy())
 ) %>%
 unnest(anova_tbl) %>%
 filter(term == "factor(treatment)") %>%
 select(group, intord, probf = p.value)
 
#==============================================================================
# Step 3: Format p-value like SAS (p_val02)
#==============================================================================
 
p_val02 <- p_val01 %>%
 mutate(
 pval = case_when(
 !is.na(probf) & probf < 0.0001 ~ "<.0001",
 !is.na(probf) ~ sprintf("%.4f", probf),
 TRUE ~ "-"
 )
 ) %>%
 select(group, intord, pval)
 
#==============================================================================
# Step 4: Merge p-values with all01 dataset (final)
#==============================================================================
 
final <- stats05 %>%
 left_join(p_val02, by = c("group", "intord")) %>%
 mutate(
 pval = if_else(is.na(pval) & intord == 1, "-", pval)
 ) %>%
 rename(c1=grouplabel, c2=statistic, c3=trt_1, c4=trt_2, c5=trt_3)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================