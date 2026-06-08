# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TAE_L103
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
 
 
source("./TFL_TAE_L103_data.r")
 
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
#SOC rows;
#------------------------------------------------------------------------------;
 
soc_count <- adae02 %>%
 group_by(aebodsys, treatment) %>%
 summarise(count = n_distinct(usubjid),events = n()) %>%
 ungroup()
 
#------------------------------------------------------------------------------;
#PT rows;
#------------------------------------------------------------------------------;
 
pt_count <- adae02 %>%
 group_by(aebodsys, aedecod, treatment) %>%
 summarise(count = n_distinct(usubjid),events = n()) %>%
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
 
dummy02<-counts01 %>%
 complete(nesting(label,aebodsys,aedecod),treatment=c(0,54,81,99)) %>%
 select(-count,-events)
 
#==============================================================================;
#Merge dummy counts with actual counts;
#Set subject count and event count to 0 for missing rows;
#==============================================================================;
 
counts02<-dummy02 %>%
 left_join(counts01,by=c("label","aebodsys", "aedecod", "treatment")) %>%
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
 id_cols = c(aebodsys, aedecod, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 ) %>%
 arrange(aebodsys,aedecod,label)
 
#==============================================================================;
#Create variables to sort the SOCs by descending frequency in high dose and also
#sort PTs by descending frequency in high dose within each SOC;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Extract counts from high dose column (trt81);
#------------------------------------------------------------------------------;
 
trans02 <- trans01 %>%
 mutate(cnt81 = as.integer(word(trt81,1,sep=fixed("("))))
 
#------------------------------------------------------------------------------;
#Separate top row, soc rows and pt rows into separate datasets;
#------------------------------------------------------------------------------;
 
section0 <- trans02 %>%
 filter(label == "Overall" & aebodsys == "" & aedecod == "")
 
section1 <- trans02 %>%
 filter(aebodsys != "" & aedecod == "")
 
section2 <- trans02 %>%
 filter(aedecod != "")
 
#------------------------------------------------------------------------------;
#Create order variable for top-row;
#------------------------------------------------------------------------------;
 
section0_1<-section0 %>%
 mutate(section0ord=1)
 
#------------------------------------------------------------------------------;
#Create order variable for SOC rows by sorting based on required variables;
#------------------------------------------------------------------------------;
 
section1_1<-section1 %>%
 arrange(desc(cnt81),aebodsys) %>%
 mutate(section1ord=row_number(),section0ord=999)
#------------------------------------------------------------------------------;
#Create order variable for PT rows by sorting based on required variables within each SOC;
#------------------------------------------------------------------------------;
 
section2_1<-section2 %>%
 arrange(aebodsys,desc(cnt81),aedecod) %>%
 mutate(section2ord=row_number(),section0ord=999)
 
#------------------------------------------------------------------------------;
#Bring the SOC sort order variable into PT rows dataset;
#------------------------------------------------------------------------------;
 
section2_2<-section2_1 %>%
 left_join(select(section1_1,aebodsys,section1ord),by=c("aebodsys"))
 
#==============================================================================;
#Combine all sections and sort the records based on section and row orders;
#==============================================================================;
 
final01<-bind_rows(section0,section1_1,section2_2) %>%
 mutate(
 across(c(section0ord,section1ord,section2ord),~if_else(is.na(.),0,.))
 ) %>%
 arrange(section0ord,section1ord,section2ord)
 
final02 <-final01 %>%
 select(aebodsys,aedecod,label,trt0,trt54,trt81,trt99)
 
 
output<-select(final02,-trt99)
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================