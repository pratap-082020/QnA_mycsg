# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1001_L102
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
 
 
source("./ADaM_C1001_L102_data.r")
 
 
 
 
rficdt<-ds %>%
 filter(dscat=="PROTOCOL MILESTONE", dsscat=="INFORMED CONSENT OBTAINED",dsdecod=="SUBJECT INFORMED CONSENT") %>%
 mutate(rficdt=as.Date(dsstdtc)) %>%
 select(usubjid,rficdt)
 
randdt<-ds %>%
 filter(dscat=="PROTOCOL MILESTONE",dsdecod=="RANDOMIZED") %>%
 mutate(randdt=as.Date(dsstdtc),randfl="Y") %>%
 select(usubjid,randdt,randfl)
 
ex01<-bind_rows(
 ex %>% rename(dtc=exstdtc),
 ex %>% rename(dtc=exendtc)
)
 
trtsdt<-ex01 %>%
 filter(excat=="TREATMENT PERIOD",exdose>0,dtc!="") %>%
 arrange(usubjid,dtc) %>%
 group_by(usubjid) %>%
 slice(1) %>%
 mutate(trtsdt=as.Date(dtc),saffl="Y") %>%
 select(usubjid,trtsdt,saffl)
 
trtedt<-ex01 %>%
 filter(excat=="TREATMENT PERIOD",exdose>0,dtc!="") %>%
 arrange(usubjid,dtc) %>%
 group_by(usubjid) %>%
 slice(n()) %>%
 mutate(trtedt=as.Date(dtc)) %>%
 select(usubjid,trtedt)
 
scrffl<-ds %>%
 filter(dsdecod=="DID NOT MEET ENTRANCE CRITERIA") %>%
 mutate(scrffl="Y") %>%
 select(usubjid,scrffl)
 
#Process for FASFL
lb01<-lb %>%
 left_join(trtsdt,by=c("usubjid")) %>%
 mutate(dtc=str_sub(lbdtc,1,10),lbdt=suppressWarnings(as.Date(dtc)))
 
postlb<-lb01 %>%
 filter(!is.na(lbdt),!is.na(trtsdt),lbdt>trtsdt,!is.na(lbstresn)) %>%
 select(usubjid) %>%
 distinct(usubjid) %>%
 mutate(inhba1c=1)
 
 
#process for PPROTFL
dv01<-dv %>%
 distinct(usubjid) %>%
 mutate(indv=1)
 
dm01<-dm %>% mutate(indm=1)
#Bring all dates into dm dataset
datasets <- list(dm01,rficdt,randdt,trtsdt,trtedt,scrffl,postlb,dv01)
 
# Join the datasets using left_join
adsl01 <- reduce(datasets, left_join, by = "usubjid") %>%
 mutate(
 fasfl=ifelse(saffl=="Y" & inhba1c==1 & indm==1,"Y","N"),
 pprotfl=ifelse(fasfl=="Y" & is.na(indv) & indm==1, "Y", "N"),
 across(c(randfl,scrffl,saffl,fasfl,pprotfl),~ifelse(indm==1 & (is.na(.)|.==""),"N",.)))
 
#Drop temporary variables
adsl02<-adsl01 %>%
 select(usubjid,rficdt,randdt,trtsdt,trtedt,scrffl,randfl,saffl,fasfl,pprotfl)
 
output<-adsl02
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================