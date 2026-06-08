# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TAE_L100
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
 
 
source("./TFL_TAE_L100_data.r")
 
 
#==============================================================================;
#Filter required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(saffl=="Y")
 
adae01<-adae  %>%
 filter(saffl=="Y",trtemfl=="Y")
 
 
#==============================================================================;
#Create treatment variable;
#==============================================================================;
 
adsl02<-adsl01 %>% mutate(treatment=trt01an) %>%
 bind_rows(adsl01 %>% mutate(treatment=99))
 
adae02<-adae01 %>% mutate(treatment=trtan) %>%
 bind_rows(adae01 %>% mutate(treatment=99))
 
#==============================================================================;
#Get treatment totals;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Create a dummy dataset containing all possible treatment levels;
#------------------------------------------------------------------------------;
 
dummy_trttotals <- tibble(treatment = c(0, 54, 81, 99))
 
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
#Create a function for obtaining subject and event counts;
#==============================================================================;
 
 
compute_counts <- function(data, filter_expr, ord) {
 data %>%
 filter({{ filter_expr }}) %>%
 group_by(treatment) %>%
 summarise(
 ord = ord,
 subjects = n_distinct(usubjid),
 events = n(),
 .groups = "drop"
 )
}
 
#==============================================================================;
#Obtaining actual counts-for the table;
#==============================================================================;
 
 
counts01 <- bind_rows(
 compute_counts(adae02, trtemfl == "Y", 1),
 compute_counts(adae02, toupper(aerel) %in% c("POSSIBLE", "PROBABLE"), 2),
 compute_counts(adae02, aesdth == "Y", 3),
 compute_counts(adae02, aeser == "Y", 4),
 compute_counts(adae02, toupper(aerel) %in% c("POSSIBLE", "PROBABLE") & aeser == "Y", 5),
 compute_counts(adae02, toupper(aeacn) == "DRUG WITHDRAWN", 6),
 compute_counts(adae02, toupper(aeacn) == "DRUG WITHDRAWN" & toupper(aerel) %in% c("POSSIBLE", "PROBABLE"), 7)
)
 
#==============================================================================;
#Create dummy data;
#==============================================================================;
 
dummy01 <- tribble(
 ~label, ~ord,
 "Adverse Events", 1,
 "Drug-Related [1] Adverse Events", 2,
 "Deaths", 3,
 "Serious Adverse Events [2]", 4,
 "Drug-Related [1] Serious Adverse Events [2]", 5,
 "Adverse Events Leading to Permanent Discontinuation of Study Drug", 6,
 "Drug-Related [1] Adverse Events Leading to Permanent Discontinuation of Study Drug", 7
)
 
dummy02<-cross_join(dummy01,dummy_trttotals)
 
#==============================================================================;
#Merge dummy counts with actual counts;
#Set subject count and event count to 0 for missing rows;
#==============================================================================;
 
counts02 <- counts01 %>%
 full_join(dummy02, by = c("ord","treatment")) %>%
 mutate(
 subjects = if_else(is.na(subjects), 0, subjects),
 events = if_else(is.na(events), 0, events)
 )
 
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
 percent=if_else(trttotal!=0,subjects/trttotal*100,0),
 percentc=str_c(" (",sprintf("%.1f",percent),"%)"),
 cp=if_else(subjects==0,"0",str_c(subjects, percentc, str_c(" ",events)))
 )
 
 
#==============================================================================;
#Transpose to obtain treatment as columns;
#==============================================================================;
 
counts05 <- counts04 %>%
 pivot_wider(
 id_cols = c(ord, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 )
 
output<-select(counts05,-trt99)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================