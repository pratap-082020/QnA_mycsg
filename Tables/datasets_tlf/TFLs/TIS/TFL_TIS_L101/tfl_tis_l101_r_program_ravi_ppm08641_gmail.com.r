# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_L101
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
 
 
source("./TFL_TIS_L101_data.r")
 
#==============================================================================;
#Filter required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(saffl=="Y")
 
adae01<-adae %>%
 filter(saffl=="Y",trtemfl=="Y")
 
 
#==============================================================================;
#Create treatment variable;
#==============================================================================;
 
adsl02<-adsl01 %>% mutate(treatment=trt01an)
adae02<-adae01 %>% mutate(treatment=trtan)
 
#==============================================================================;
#Get treatment totals;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Create a dummy dataset containing all possible treatment levels;
#------------------------------------------------------------------------------;
 
dummy_trttotals <- tibble(treatment = c(1,2))
 
#------------------------------------------------------------------------------;
#Get actual treatment totals;
#------------------------------------------------------------------------------;
 
trttotals_pre<-adsl02 %>%
 count(treatment)
 
 
#------------------------------------------------------------------------------;
#Merge with dummy treatment totals;
#------------------------------------------------------------------------------;
 
trttotals<-dummy_trttotals %>%
 left_join(trttotals_pre,by=c("treatment")) %>%
 mutate(trttotal=if_else(is.na(n),0,n)) %>%
 select(-n)
 
 
#==============================================================================;
#Obtaining actual counts-for the table;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#TOP row;
#------------------------------------------------------------------------------;
 
sub_count <- adae02 %>%
 group_by(treatment) %>%
 summarise(label = "Overall", count = n_distinct(usubjid), events=n()) %>%
 ungroup()
 
 
#------------------------------------------------------------------------------;
#PT rows;
#------------------------------------------------------------------------------;
 
pt_count <- adae02 %>%
 group_by(aedecod, treatment) %>%
 summarise(count = n_distinct(usubjid),events = n()) %>%
 ungroup()
 
 
 
#------------------------------------------------------------------------------;
#Combine toprow, and PT level counts into single dataset;
#Replace NAs with blanks
#------------------------------------------------------------------------------;
 
counts01 <- bind_rows(sub_count, pt_count) %>%
 mutate(across(c(label, aedecod), ~ if_else(is.na(.), "", .)))
 
 
#==============================================================================;
#Create zero counts if an event is not present in a treatment;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Get all the available SOC and PT values;
#Create a row for each treatment;
#------------------------------------------------------------------------------;
 
dummy01<-counts01 %>%distinct(label,aedecod)
 
dummy02<-cross_join(dummy01,dummy_trttotals)
 
#==============================================================================;
#Merge dummy counts with actual counts;
#Set subject count and event count to 0 for missing rows;
#==============================================================================;
 
counts02<-dummy02 %>%
 left_join(counts01,by=c("label","aedecod", "treatment")) %>%
 mutate(across(c(count,events),~if_else(is.na(.),0,.)))
 
 
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
 percentc=str_c(" (",sprintf("%.1f",percent),"%)"),
 cp=if_else(count==0,"0",str_c(count, percentc))
 )
 
#==============================================================================;
#Create label column;
#==============================================================================;
 
counts05<-counts04 %>%
 mutate(
 label=case_when(
 aedecod=="" ~ label,
 aedecod!="" ~ str_c(aedecod),
 TRUE~""
 )
 )
 
#==============================================================================;
#Transpose to obtain treatment as columns;
#==============================================================================;
 
trans01 <- counts05 %>%
 pivot_wider(
 id_cols = c(aedecod, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 )
 
 
#==============================================================================;
#Calculate p-value;
#==============================================================================;
 
events01 <- counts05
 
#------------------------------------------------------------------------------;
#get the count of subjects with non-events;
#------------------------------------------------------------------------------;
 
events02 <- bind_rows(
 mutate(events01, event=1),
 mutate(events01, event=2, count=trttotal-count)
) %>%
 select(aedecod,label,treatment,event,count)
 
#------------------------------------------------------------------------------;
#Run Fisher exact test and store p-values;
#------------------------------------------------------------------------------;
 
 
events03<-events02 %>%
 pivot_wider(
 id_cols = c(aedecod, label, treatment),
 values_from = count,
 names_from=event,
 names_prefix="event_"
 ) %>%
 select(-treatment)
 
# Function to perform Fisher's exact test for a group
perform_fisher_test <- function(group) {
 if (nrow(group) == 2) {
 fisher_result <- fisher.test(group)
 } else {
 fisher_result <- NA
 }
 return(fisher_result)
}
 
# Group the data by label and aedecod, and apply Fisher's exact test to each group
p_val01 <- events03 %>%
 group_by(label, aedecod) %>%
 nest() %>%
 mutate(
 fisher_test_result = map(data, perform_fisher_test)
 ) %>%
 ungroup()
 
 
p_val02 <- p_val01 %>%
 mutate(p_value = map_dbl(fisher_test_result, "p.value"),
 pval = case_when(
 p_value <0.0001 ~ "<.0001",
 TRUE ~ sprintf("%0.4f",(round(p_value,4)))
 )) %>%
 select(label,aedecod,pval)
 
 
#==============================================================================;
#Merge the p-value back on to counts datasets;
#==============================================================================;
 
trans02 <- trans01 %>%
 left_join(p_val02, by=c("label", "aedecod")) %>%
 mutate(p_val=ifelse(is.na(pval),"-",pval))
 
output<-trans02 %>% select(aedecod,label,trt1,trt2,pval)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================