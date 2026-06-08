# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TVS_L101
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
 
 
source("./TFL_TVS_L101_data.r")
 
#==============================================================================;
#subset required records;
#==============================================================================;
 
adsl01<-adsl %>%
 filter(saffl=="Y")
 
advs01<-advs %>%
 filter(saffl=="Y")
 
 
#==============================================================================;
#replicate rows for total column;
#==============================================================================;
 
adsl02<-adsl01 %>%
 mutate(treatment=trt01an) %>%
 bind_rows(adsl01 %>% mutate(treatment=3))
 
advs02<-advs01 %>%
 mutate(treatment=trt01an) %>%
 bind_rows(advs01 %>% mutate(treatment=3))
 
 
#==============================================================================;
#Get treatment totals;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#Create a dummy dataset containing all possible treatment levels;
#------------------------------------------------------------------------------;
 
dummy_trttotals <- tibble(treatment = c(1,2,3))
 
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
#Fetch all the analysis variables into a single variable using output statement;
#Create the group variables to indicate the rows for each analysis variable
#==============================================================================;
 
advs03 <- advs02 %>%
 mutate(
 dp = case_when(
 paramcd %in% c("SYSBPM", "DIABPM", "WEIGHT") ~ 1,
 paramcd %in% c("PULSE") ~ 0,
 TRUE ~ NA_real_
 )
 )
 
advs04<-advs03 %>% mutate(group=1,result=aval) %>%
 bind_rows(advs03 %>% filter(!is.na(chg)) %>% mutate(group=2,result=chg))
 
#==============================================================================;
#Calculate summary statistics;
#==============================================================================;
 
stats01 <- advs04 %>%
 group_by(paramn,paramcd,param,dp,avisitn,avisit,group,treatment) %>%
 summarize(
 result_n = sum(!is.na(result)),
 result_mean = mean(result, na.rm = TRUE),
 result_stddev = sd(result, na.rm = TRUE),
 result_min = min(result, na.rm = TRUE),
 result_median = median(result, na.rm = TRUE),
 result_max = max(result, na.rm = TRUE)
 ) %>% ungroup()
 
 
#==============================================================================;
#Process the statistics as per presentation requirements;
#==============================================================================;
 
stats02 <- stats01 %>%
 mutate(
 
 #create variables to store the format values based on dp variable
 asisf=paste0("%.",dp,"f"),
 plusonef=paste0("%.",dp+1,"f"),
 plustwof=paste0("%.",dp+2,"f"),
 
 n=sprintf("%.0f", result_n),
 mean = ifelse(!is.na(result_mean), sprintf(plusonef, result_mean), NA_character_),
 std = ifelse(!is.na(result_stddev), paste0(sprintf(plustwof, result_stddev)), " - "),
 median = ifelse(!is.na(result_median), sprintf(plusonef, result_median), NA_character_),
 min = ifelse(!is.na(result_min), sprintf(asisf, result_min), NA_character_),
 max = ifelse(!is.na(result_max), sprintf(asisf, result_max), NA_character_),
 )
 
stats03 <- stats02 %>%
 select(paramn,paramcd,param,group,dp,avisitn,avisit,group,treatment, n, mean, std, median, min, max)
 
#==============================================================================;
#Separate AVAL and CHG statistics;
#==============================================================================;
 
#------------------------------------------------------------------------------;
#AVAL;
#------------------------------------------------------------------------------;
 
aval_stats<-stats03 %>%
 filter(group==1) %>%
 rename(aval_n=n,aval_mean=mean,aval_sd=std,aval_median=median,aval_min=min,aval_max=max) %>%
 select(-group,-dp)
 
#------------------------------------------------------------------------------;
#CHG;
#------------------------------------------------------------------------------;
 
chg_stats<-stats03 %>%
 filter(group==2) %>%
 rename(chg_n=n,chg_mean=mean,chg_sd=std,chg_median=median,chg_min=min,chg_max=max) %>%
 select(-group,-dp)
 
 
#==============================================================================;
#Join aval and change statistics to appear side by side ;
#==============================================================================;
 
stats04<-aval_stats %>%
 left_join(chg_stats,by=c("paramn","paramcd","param", "avisitn",
 "avisit", "treatment"))
 
#------------------------------------------------------------------------------;
#Replace NAs with null value;
#------------------------------------------------------------------------------;
 
stats05<-stats04 %>%
 mutate(across(starts_with("c"),~if_else(is.na(.),"",.)))
 
#==============================================================================;
#Bring treatment totals into stats dataset and create treatment label;
#==============================================================================;
 
stats06<-stats05 %>%
 left_join(trttotals,by="treatment") %>%
 mutate(
 treatmentc=case_when(
 treatment==1~"Placebo",
 treatment==2~"Active",
 treatment==3~"Total",
 TRUE~""
 ),
 treatmentc=str_c(treatmentc, " (N=",sprintf("%.0f",trttotal),")")
 ) %>%
 arrange(paramn,treatment,avisitn)
 
#==============================================================================;
#Arrange variables in required order;
#==============================================================================;
 
stats07<-stats06 %>%
 select(paramn,param,treatment,treatmentc,avisitn,avisit,starts_with("aval"),starts_with("chg"))
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================