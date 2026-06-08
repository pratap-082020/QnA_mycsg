# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TABGEN_L302
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
 
 
source("./TFL_TABGEN_L302_data.r")
 
 
 
#==============================================================================;
#Filter required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(fasfl=="Y")
 
#==============================================================================;
#Replicate records for total column counts;
#==============================================================================;
 
adsl02<-adsl01 %>% mutate(treatment=trt01pn) %>%
 bind_rows(adsl01 %>% mutate(treatment=4))
 
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
 
adsl03<-adsl02 %>%
 mutate(group=1,statistic=if_else(is.na(asex)|asex=="","Missing",asex)) %>%
 bind_rows(
 adsl02 %>%
 mutate(group=2,statistic=if_else(is.na(arace)|arace=="","Missing",arace))
 )
 
 
#==============================================================================;
#Obtain counts for the categorical variable ;
#==============================================================================;
 
counts01<-adsl03 %>%
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
 2,"Race, n(%)",1,"Asian",
 2,"Race, n(%)",2,"Black or African American",
 2,"Race, n(%)",3,"White",
 2,"Race, n(%)",4,"Not reported",
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
 
final<-counts05 %>%
 select(group,grouplabel,intord,statistic,trt1,trt2,trt3,trt4)
 
output<-final
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================