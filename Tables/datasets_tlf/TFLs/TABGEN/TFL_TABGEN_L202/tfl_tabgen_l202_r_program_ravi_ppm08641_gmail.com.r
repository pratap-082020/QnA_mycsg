# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TABGEN_L202
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
 
 
source("./TFL_TABGEN_L202_data.r")
 
 
 
#==============================================================================;
#subset required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(fasfl=="Y")
 
#==============================================================================;
#replicate rows for total column;
#==============================================================================;
 
adsl02<-adsl01 %>%
 mutate(treatment=trt01pn) %>%
 bind_rows(adsl01 %>% mutate(treatment=4))
 
#==============================================================================;
#Fetch all the analysis variables into a single variable using output statement;
#Create the group variables to indicate the rows for each analysis variable
#==============================================================================;
 
adsl03<-adsl02 %>% mutate(vargroup=1,result=age,dp=0) %>%
 bind_rows(adsl02 %>% mutate(vargroup=2,result=heightbl,dp=1))
 
#==============================================================================;
#Calculate summary statistics;
#==============================================================================;
 
stats01 <- adsl03 %>%
 group_by(vargroup, dp,treatment) %>%
 summarize(
 nrecs = n(),
 result_nmiss = sum(is.na(result)),
 result_n = nrecs - result_nmiss,
 result_mean = mean(result, na.rm = TRUE),
 result_stddev = sd(result, na.rm = TRUE),
 result_min = min(result, na.rm = TRUE),
 result_q1 = quantile(result, 0.25, type = 2, na.rm = TRUE),
 result_median = median(result, na.rm = TRUE),
 result_q3 = quantile(result, 0.75, type = 2, na.rm = TRUE),
 result_max = max(result, na.rm = TRUE)
 ) %>% ungroup() %>%
 complete(nesting(vargroup, dp), treatment = 1:4,
 fill = list(result_n = 0, result_nmiss = 0, result_mean = NA, result_stddev = NA,
 result_min = NA, result_q1 = NA, result_median = NA,
 result_q3 = NA, result_max = NA))
 
 
#==============================================================================;
#Process the statistics as per presentation requirements;
#==============================================================================;
 
stats02 <- stats01 %>%
 mutate(
 
 #create variables to store the format values based on dp variable
 asisf=paste0("%.",dp,"f"),
 plusonef=paste0("%.",dp+1,"f"),
 plustwof=paste0("%.",dp+2,"f"),
 
 mean = ifelse(!is.na(result_mean), sprintf(plusonef, result_mean), NA_character_),
 std = ifelse(!is.na(result_stddev), paste0(" (", sprintf(plustwof, result_stddev), ")"), " ( - )"),
 median = ifelse(!is.na(result_median), sprintf(plusonef, result_median), NA_character_),
 q1 = ifelse(!is.na(result_q1), sprintf(plusonef, result_q1), NA_character_),
 q3 = ifelse(!is.na(result_q3), sprintf(plusonef, result_q3), NA_character_),
 min = ifelse(!is.na(result_min), sprintf(asisf, result_min), NA_character_),
 max = ifelse(!is.na(result_max), sprintf(asisf, result_max), NA_character_),
 nnmiss = paste0(formatC(result_n, format = "d", width = 3), " (", formatC(result_nmiss, format = "d", width = 3), ")"),
 meanstd = ifelse(result_n != 0, paste0(trimws(mean), trimws(std)), NA_character_),
 q1q3 = ifelse(result_n != 0, paste0(trimws(q1), ",", trimws(q3)), NA_character_),
 minmax = ifelse(result_n != 0, paste0(trimws(min), ",", trimws(max)), NA_character_)
 )
 
stats03 <- stats02 %>%
 select(vargroup, treatment, nnmiss, meanstd, q1q3, median, minmax)
 
#==============================================================================;
#Restructure the statistics such that they appear as 'rows' ;
#==============================================================================;
 
stats04 <- stats03 %>%
 pivot_longer(cols = c(nnmiss, meanstd, median, q1q3, minmax),
 names_to = "name",
 values_to = "col1")
#==============================================================================;
#Create some supporting variables as per sorting and presentation requirements;
#==============================================================================;
 
stats05 <- stats04 %>%
 mutate(
 
 grouplabel=case_when(
 vargroup==1 ~ "Age (years)",
 vargroup==2 ~ "Height (cm)",
 TRUE ~ ""
 ),
 name = toupper(name),
 intord = case_when(
 name == "NNMISS" ~ 1,
 name == "MEANSTD" ~ 2,
 name == "MEDIAN" ~ 3,
 name == "Q1Q3" ~ 4,
 name == "MINMAX" ~ 5
 ),
 statistic = case_when(
 name == "NNMISS" ~ "n (missing)",
 name == "MEANSTD" ~ "Mean (SD)",
 name == "MEDIAN" ~ "Median",
 name == "Q1Q3" ~ "Q1, Q3",
 name == "MINMAX" ~ "Min, Max"
 )
 ) %>%
 select(-name)
 
#==============================================================================;
#Restructure the data such that treatments appear as 'columns';
#==============================================================================;
 
stats06 <- stats05 %>%
 pivot_wider(
 id_cols=c(vargroup,grouplabel,intord,statistic),
 names_from = treatment,
 values_from = col1,
 names_prefix = "trt"
 ) %>%
 mutate(across(c(trt1,trt2,trt3,trt4),~if_else(is.na(.),"",.)))
 
 
output<-stats06 %>% rename(group=vargroup)
 


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================