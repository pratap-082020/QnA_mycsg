# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TDM_L100
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
 
 
source("./TFL_TDM_L100_data.r")
 
 
 
 
#==============================================================================;
#subset required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(saffl=="Y")
 
#==============================================================================;
#replicate rows for total column;
#==============================================================================;
 
adsl02<-adsl01 %>%
 mutate(treatment=trt01an) %>%
 bind_rows(adsl01 %>% mutate(treatment=4))
 
 
#******************************************************************************;
#Numeric variables summary;
#******************************************************************************;
 
#==============================================================================;
#Fetch all the analysis variables into a single variable using output statement;
#Create the group variables to indicate the rows for each analysis variable
#==============================================================================;
 
numeric01<-adsl02 %>% mutate(vargroup=3,result=age,dp=0) %>%
 bind_rows(adsl02 %>% mutate(vargroup=4,result=weightbl,dp=1)) %>%
 bind_rows(adsl02 %>% mutate(vargroup=5,result=heightbl,dp=0)) %>%
 bind_rows(adsl02 %>% mutate(vargroup=6,result=bmibl,dp=2))
 
#==============================================================================;
#Calculate summary statistics;
#==============================================================================;
 
stats01 <- numeric01 %>%
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
 group=vargroup,
 grouplabel=case_when(
 vargroup==3 ~ "Age (years)",
 vargroup==4 ~ "Weight (kg)",
 vargroup==5 ~ "Height (cm)",
 vargroup==6 ~ "BMI (kg/m**2)",
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
 id_cols=c(group,grouplabel,intord,statistic),
 names_from = treatment,
 values_from = col1,
 names_prefix = "trt"
 ) %>%
 mutate(across(c(trt1,trt2,trt3,trt4),~if_else(is.na(.),"",.)))
 
 
 
#******************************************************************************;
#Character variables summary;
#******************************************************************************;
 
 
 
#==============================================================================;
#Get the treatment totals into a dataset;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#create a dummy dataset containing all levels;
#------------------------------------------------------------------------------;
 
dummy_trttotals<-tibble(treatment=1:4)
 
#------------------------------------------------------------------------------;
#Get treatment totals based on actual data;
#------------------------------------------------------------------------------;
 
trttotals01<-adsl02 %>%
 count(treatment)
 
#------------------------------------------------------------------------------;
#Merge the dummy dataset containing all treatment rows with actual treatment totals dataset;
#------------------------------------------------------------------------------;
 
trttotals<-trttotals01 %>%
 right_join(dummy_trttotals,by=c("treatment")) %>%
 mutate(trttotal=if_else(is.na(n),0,n)) %>%
 select(-n)
 
 
#==============================================================================;
#Create some utility variables for smooth processing in the down-stream code;
#==============================================================================;
 
categorical01<-adsl02 %>%
 mutate(group=1,statistic=case_when(
 sex=="F"~"Female",
 sex=="M"~"Male",
 is.na(sex)~"",
 TRUE~""
 )) %>%
 bind_rows(
 adsl02 %>%
 mutate(group=2,statistic=if_else(is.na(arace)|arace=="","Missing",arace))
 )
 
 
#==============================================================================;
#Obtain counts for the categorical variable ;
#==============================================================================;
 
counts01<-categorical01 %>%
 count(group,statistic,treatment) %>%
 rename(count=n)
 
#==============================================================================;
#Create a dummy dataset containing a row for each level and treatment;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Create a row for each level of the categorical variable;
#------------------------------------------------------------------------------;
dummy01<-tribble(
 ~group,~grouplabel,~intord,~statistic,
 1,"Sex, n(%)",1,"Male",
 1,"Sex, n(%)",2,"Female",
 1,"Sex, n(%)",99,"Missing",
 2,"Race, n(%)",1,"White",
 2,"Race, n(%)",2,"Black or African American",
 2,"Race, n(%)",3,"Asian",
 2,"Race, n(%)",4,"Other",
 2,"Race, n(%)",99,"Missing",
)
 
#------------------------------------------------------------------------------;
#Create a row for each treament for record present in dummy01;
#------------------------------------------------------------------------------;
 
dummy02<-cross_join(dummy01,dummy_trttotals)
 
 
 
#==============================================================================;
#Merge the dummy counts with actual counts;
#==============================================================================;
 
 
counts02<-dummy02 %>%
 left_join(counts01,by=c("group","statistic","treatment")) %>%
 mutate(count=if_else(is.na(count),0,count))
 
#==============================================================================;
#Calculate percentages;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Fetch treatment totals into the dataset containing counts;
#------------------------------------------------------------------------------;
 
counts03<-counts02 %>%
 left_join(trttotals,by=c("treatment"))
 
#------------------------------------------------------------------------------;
#Create percentage variable and concatenate count and percentage into a single
#variable;
#------------------------------------------------------------------------------;
 
counts04<-counts03 %>%
 mutate(percent = if_else(trttotal != 0, count / trttotal * 100, 0),
 percentf=if_else(percent==100,"%.0f","%.1f"),
 percentc=paste0(" (",sprintf(percentf,percent),")"),
 cp=if_else(count!=0,paste0(count," ",percentc),"0"))
 
 
#==============================================================================;
#Restructure the dataset such that treatments appear as columns;
#==============================================================================;
 
counts05 <- counts04 %>%
 pivot_wider(
 id_cols = c(group, grouplabel, intord, statistic),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 )
 
#==============================================================================;
#Create final dataset - keeping only required variables;
#==============================================================================;
 
counts06<-counts05 %>%
 select(group,grouplabel,intord,statistic,trt1,trt2,trt3,trt4)
 
#==============================================================================;
#Combine numeric and categorical variable summaries;
#==============================================================================;
 
final<-bind_rows(stats06,counts06) %>%
 arrange(group,intord)
 
output <- final
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================