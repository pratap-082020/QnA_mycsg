# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TAE_L104
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
 
 
source("./TFL_TAE_L104_data.r")
 
 
#==============================================================================;
#Filter required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(saffl=="Y")
 
adae01<-adae  %>%
 filter(saffl=="Y",trtemfl=="Y")
 
#==============================================================================;
#Create numeric version of relationship variable;
#==============================================================================;
 
adae02 <- adae01 %>%
 mutate(areln = case_when(
 toupper(aerel) == "NONE" ~ 1,
 toupper(aerel) == "REMOTE" ~ 2,
 toupper(aerel) == "POSSIBLE" ~ 3,
 toupper(aerel) == "PROBABLE" ~ 4,
 TRUE ~ 99
 ))
 
#==============================================================================;
#Create flags to identify the first occurrence of highest intensity
#at subject, soc, soc at pt levels;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Subject level;
#------------------------------------------------------------------------------;
 
temp01<-adae02 %>%
 filter(trtemfl=="Y") %>%
 arrange(usubjid,areln,aeseq) %>%
 group_by(usubjid) %>%
 mutate(
 aoccifl=if_else(row_number()==n(),"Y","")
 )
 
#------------------------------------------------------------------------------;
#SOC level;
#------------------------------------------------------------------------------;
 
temp02<-temp01 %>%
 filter(trtemfl=="Y") %>%
 arrange(usubjid,aebodsys,areln,aeseq) %>%
 group_by(usubjid,aebodsys) %>%
 mutate(
 aoccsifl=if_else(row_number()==n(),"Y","")
 )
 
#------------------------------------------------------------------------------;
#PT level;
#------------------------------------------------------------------------------;
 
temp03<-temp02 %>%
 filter(trtemfl=="Y") %>%
 arrange(usubjid,aebodsys,aedecod,areln,aeseq) %>%
 group_by(usubjid,aebodsys,aedecod,) %>%
 mutate(
 aoccpifl=if_else(row_number()==n(),"Y","")
 )
 
adae02<-temp03
 
#==============================================================================;
#Create treatment variable;
#==============================================================================;
 
adsl02<-adsl01 %>% mutate(treatment=trt01an) %>%
 bind_rows(adsl01 %>% mutate(treatment=99))
 
adae03<-adae02 %>% mutate(treatment=trtan) %>%
 bind_rows(adae02 %>% mutate(treatment=99))
 
#==============================================================================;
#Replicate the rows for total relationship;
#==============================================================================;
 
adae04<-adae03 %>%
 bind_rows(adae03 %>% mutate(areln=100))
 
 
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
#Obtaining actual counts-for the table;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#TOP row;
#------------------------------------------------------------------------------;
 
sub_count <- adae04 %>%
 filter(aoccifl=="Y") %>%
 group_by(treatment,areln) %>%
 summarise(label = "Overall", count = n_distinct(usubjid)) %>%
 ungroup()
 
#------------------------------------------------------------------------------;
#SOC rows;
#------------------------------------------------------------------------------;
 
soc_count <- adae04 %>%
 filter(aoccsifl=="Y") %>%
 group_by(aebodsys, treatment,areln) %>%
 summarise(count = n_distinct(usubjid)) %>%
 ungroup()
 
#------------------------------------------------------------------------------;
#PT rows;
#------------------------------------------------------------------------------;
 
pt_count <- adae04 %>%
 filter(aoccpifl=="Y") %>%
 group_by(aebodsys, aedecod, treatment,areln) %>%
 summarise(count = n_distinct(usubjid)) %>%
 ungroup()
 
 
 
#------------------------------------------------------------------------------;
#Combine toprow, SOC, and PT level counts into single dataset;
#Replace NAs with blanks
#------------------------------------------------------------------------------;
 
counts01 <- bind_rows(sub_count, soc_count, pt_count) %>%
 mutate(across(c(label, aebodsys, aedecod), ~ if_else(is.na(.), "", .)))
 
 
#==============================================================================;
#Create zero counts if an event is not present in a treatment;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Get all the available SOC and PT values;
#Create a row for each treatment;
#------------------------------------------------------------------------------;
 
dummy01<-counts01 %>%
 distinct(label,aebodsys,aedecod) %>%
 cross_join(dummy_trttotals)
 
dummy02<-dummy01 %>%
 cross_join(tibble(areln=c(1,2,3,4,99,100)))
 
#==============================================================================;
#Merge dummy counts with actual counts;
#Set subject count and event count to 0 for missing rows;
#==============================================================================;
 
counts02<-dummy02 %>%
 left_join(counts01,by=c("label","aebodsys", "aedecod", "treatment","areln")) %>%
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
 percentc=str_c(" (",sprintf("%.1f",percent),"%)"),
 cp=if_else(count==0,"0",str_c(count, percentc))
 )
 
#==============================================================================;
#Create label column;
#==============================================================================;
 
counts05<-counts04 %>%
 mutate(
 label=case_when(
 aebodsys=="" & aedecod=="" ~ label,
 aebodsys!="" & aedecod=="" ~ aebodsys,
 aebodsys!="" & aedecod!="" ~ str_c("   ",aedecod),
 TRUE~""
 )
 )
 
#==============================================================================;
#Transpose to obtain treatment as columns;
#==============================================================================;
 
trans01 <- counts05 %>%
 pivot_wider(
 id_cols = c(aebodsys, aedecod, label,areln),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 ) %>%
 arrange(aebodsys,aedecod,label,areln)
 
trans02 <- trans01 %>%
 mutate(relationship = case_when(
 areln == 1 ~ "None",
 areln == 2 ~ "Remote",
 areln == 3 ~ "Possible",
 areln == 4 ~ "Probable",
 areln == 99 ~ "Missing",
 areln == 100 ~ "Total"
 )) %>%
 select(aebodsys, aedecod, areln, label,relationship, trt0, trt54, trt81, label)
 
output <- trans02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================