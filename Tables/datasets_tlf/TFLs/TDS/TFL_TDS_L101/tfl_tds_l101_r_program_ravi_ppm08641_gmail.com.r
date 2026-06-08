# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TDS_L101
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
 
 
source("./TFL_TDS_L101_data.r")
 
 
 
#==============================================================================;
#Filter required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(randfl=="Y")
 
 
#==============================================================================;
#Create treatment variable;
#==============================================================================;
 
adsl02<-adsl01 %>% mutate(treatment=trt01pn) %>%
 bind_rows(adsl01 %>% mutate(treatment=4))
 
 
#==============================================================================;
#Get treatment totals;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Create a dummy dataset containing all possible treatment levels;
#------------------------------------------------------------------------------;
 
dummy_trttotals <- tibble(treatment = c(1,2,3,4))
 
#------------------------------------------------------------------------------;
#Get actual treatment totals;
#------------------------------------------------------------------------------;
 
trttotals_pre<-adsl02 %>%
 count(treatment)
 
 
#------------------------------------------------------------------------------;
#Merge with dummy treatment totals;
#------------------------------------------------------------------------------;
 
trttotals<-dummy_trttotals  %>%
 left_join(trttotals_pre,by=c("treatment")) %>%
 mutate(trttotal=if_else(is.na(n),0,n)) %>%
 select(-n)
 
 
#==============================================================================;
#Obtaining actual counts-for the table;
#==============================================================================;
 
counts01 <- bind_rows(
 adsl02 %>% filter(randfl == "Y") %>% count(treatment, name = "count") %>% mutate(order = 1),
 adsl02 %>% filter(fasfl == "Y") %>% count(treatment, name = "count") %>% mutate(order = 2),
 adsl02 %>% filter(saffl == "Y") %>% count(treatment, name = "count") %>% mutate(order = 3),
 adsl02 %>% filter(pprotfl == "Y") %>% count(treatment, name = "count") %>% mutate(order = 4)
)
 
#------------------------------------------------------------------------------;
#Create dummy dataset to have all rows;
#------------------------------------------------------------------------------;
 
dummy01 <- tribble(
 ~order, ~label,
 1, "Randomized Analysis Set",
 2, "Full Analysis Set",
 3, "Safety Analysis Set",
 4, "Per-protocol Analysis Set"
)
 
 
dummy02<-cross_join(dummy01,dummy_trttotals)
 
#==============================================================================;
#Merge dummy counts with actual counts;
#Set subject count and event count to 0 for missing rows;
#==============================================================================;
 
counts02<-dummy02 %>%
 left_join(counts01,by=c("order","treatment")) %>%
 mutate(count=if_else(is.na(count),0,count))
 
 
#==============================================================================;
#Calculate percentages;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Fetch denominators;
#------------------------------------------------------------------------------;
 
counts03<-counts02 %>%
 left_join(trttotals,by="treatment")
 
#------------------------------------------------------------------------------;
#Create a single variable to hold count and percentage;
#------------------------------------------------------------------------------;
 
 
counts04<-counts03 %>%
 mutate(
 percent=if_else(trttotal!=0,count/trttotal*100,0),
 percentc=str_c(" (",sprintf("%.1f",percent),")"),
 cp=if_else(count==0,"0",str_c(count, percentc))
 )
 
#==============================================================================;
#Transpose to obtain treatment as columns;
#==============================================================================;
 
counts05 <- counts04 %>%
 pivot_wider(
 id_cols = c(order, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 )
 
output<-select(counts05,order,label,trt1,trt2,trt3,trt4)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================