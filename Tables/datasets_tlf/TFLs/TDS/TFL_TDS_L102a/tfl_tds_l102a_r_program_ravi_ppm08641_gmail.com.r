# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TDS_L102a
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
 
 
source("./TFL_TDS_L102a_data.r")
 
 
 
 
#==============================================================================;
#Filter required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(saffl=="Y")
 
 
#==============================================================================;
#Create treatment variable;
#==============================================================================;
 
adsl02<-adsl01 %>% mutate(treatment=trt01an) %>%
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
 
#------------------------------------------------------------------------------;
#section 1 counts;
#------------------------------------------------------------------------------;
 
sec1_counts01 <- adsl02 %>%
 count(treatment, eotstt, name="count") %>%
 rename(label=eotstt)
 
#------------------------------------------------------------------------------;
#section 2 counts;
#------------------------------------------------------------------------------;
 
sec2_counts01 <- adsl02 %>%
 count(treatment, dctreas, name="count") %>%
 rename(label=dctreas)
 
#------------------------------------------------------------------------------;
#Combine section 1 and section 2 counts;
#------------------------------------------------------------------------------;
 
 
 
counts01 <- bind_rows(
 sec1_counts01 %>% mutate(section=1),
 sec2_counts01 %>% mutate(section=2),
)
 
#------------------------------------------------------------------------------;
#Create dummy dataset to have all rows;
#------------------------------------------------------------------------------;
 
dummy01 <- tribble(
 ~section, ~order, ~label,
 1, 0, "Treatment disposition",
 1, 1, "Ongoing",
 1, 2, "Completed",
 1, 3, "Discontinued",
 2, 0, "Primary reason for discontinuing treatment",
 2, 1, "Adverse Event",
 2, 2, "Protocol Deviation",
 2, 3, "Lost to Follow-up",
 2, 4, "Withdrawal by Subject",
 2, 5, "Investigator Discretion",
 2, 6, "Intolerable Toxicity",
 2, 7, "Progressive Disease per RECIST",
 2, 8, "Clinical Progression Without Radiological PD by RE",
 2, 9, "Other"
)
 
 
dummy02<-cross_join(dummy01,dummy_trttotals)
 
#==============================================================================;
#Merge dummy counts with actual counts;
#Set subject count and event count to 0 for missing rows;
#==============================================================================;
 
counts02<-dummy02 %>%
 left_join(counts01,by=c("section","label", "treatment")) %>%
 mutate(count=if_else(is.na(count)&order!=0,0,count))
 
 
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
 percent=if_else(trttotal!=0,round(count/trttotal*100,1),0),
 percentc=str_c(" (",sprintf("%.1f",percent),"%)"),
 cp=if_else(order!=0,
 if_else(count==0,"0",str_c(count, percentc))
 ,""),
 label=if_else(order==0,label,str_c("   ",label))
 )
 
#==============================================================================;
#Transpose to obtain treatment as columns;
#==============================================================================;
 
counts05 <- counts04 %>%
 pivot_wider(
 id_cols = c(section, order, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 )
 
output <- counts05 %>% select(section,order,label,trt1,trt2,trt3)
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================