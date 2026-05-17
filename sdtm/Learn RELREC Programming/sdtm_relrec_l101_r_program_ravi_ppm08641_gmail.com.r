# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RELREC_L101
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
 
 
source("./SDTM_RELREC_L101_data.r")
 
#==============================================================================
# Create dsae_ae dataset
#==============================================================================
dsae_ae <- adverse
 
#==============================================================================
# Create dsae_eos dataset
#==============================================================================
dsae_eos <- eos %>%
 filter(dsaeno != "") %>%
 select(study, subject, dsaeno, dsspid) %>%
 mutate(aespid = dsaeno)
 
#==============================================================================
# Merge dsae_ae and dsae_eos datasets
#==============================================================================
dsae01 <- inner_join(dsae_ae, dsae_eos, by = c("study", "subject", "aespid"))
 
#==============================================================================
# Create final_dsae dataset
#==============================================================================
final_dsae <- bind_rows(
 dsae01 %>% mutate(rdomain="DS", idvar="DSSPID", idvarval=dsspid),
 dsae01 %>% mutate(rdomain="AE", idvar="AESPID", idvarval=aespid),
) %>%
 mutate(relid=paste0("DSAE",dsspid)) %>%
 select(study,subject,rdomain,idvar,idvarval,relid)
 
 
#==============================================================================
# Create cmae_ae dataset
#==============================================================================
cmae_ae <- adverse
 
#==============================================================================
# Create cmae_cm dataset
#==============================================================================
cmae_cm <- conmeds %>%
 filter(cmaeno != "") %>%
 select(study, subject, cmaeno, cmspid) %>%
 mutate(aespid = cmaeno)
 
#==============================================================================
# Merge cmae_ae and cmae_cm datasets
#==============================================================================
cmae01 <- inner_join(cmae_ae, cmae_cm, by = c("study", "subject", "aespid"))
 
#==============================================================================
# Create final_cmae dataset
#==============================================================================
final_cmae <- bind_rows(
 cmae01 %>% mutate(rdomain="CM", idvar="CMSPID", idvarval=cmspid),
 cmae01 %>% mutate(rdomain="AE", idvar="AESPID", idvarval=aespid),
) %>%
 mutate(relid=paste0("CMAE",cmspid)) %>%
 select(study,subject,rdomain,idvar,idvarval,relid)
 
#==============================================================================
# Combine final_dsae and final_cmae datasets
#==============================================================================
final <- bind_rows(final_dsae, final_cmae) %>%
 mutate(
 studyid = "MYCSG",
 usubjid = paste(study, subject, sep = "-")
 ) %>%
 select(studyid, rdomain, usubjid, idvar, idvarval, relid)
 
#==============================================================================
# Sort the final dataset
#==============================================================================
final2 <- final %>%
 arrange(studyid, usubjid, rdomain, idvar, idvarval) %>%
 rename_all(toupper)
 
#==============================================================================
# Select and keep required variables
#==============================================================================
keepvars <- c("STUDYID", "RDOMAIN", "USUBJID", "IDVAR", "IDVARVAL", "RELID")
 
relrec <- final2 %>%
 select(all_of(keepvars))
 
output <- relrec
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================