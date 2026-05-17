# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TR_LONCEX06
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
#rmac1-std1
#rmac1-std2
#rmac1-std3
 
#IN progress - need to change the structure of code
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
 
 
library(glue)
library(tidyverse)
library(haven)
library(assertthat)
library(huxtable)
library(data.table)
library(lubridate)
library(pharmaRTF)
 
 
source("./SDTM_TR_LONCEX06_data.r")
 
#==============================================================================;
# Combine the input datasets and create required rows for testcds
#==============================================================================;
 
#Combining TUTG and TUTGSC as they share same structure
 
tutg <- bind_rows(tutgsc, tutg)
 
tr01 <- bind_rows(
 tuntsc %>% mutate(indsname="TUNTSC", trgrpid = "NON-TARGET", trtestcd ="TUMSTATE" , trtest ="Tumor State" , trorres ="PRESENT", trstresc=trorres),
 tunt %>% mutate(indsname="TUNT", trgrpid = "NON-TARGET", trtestcd ="TUMSTATE" , trtest ="Tumor State" ,
 trorres =tumstate_trorres, trstresc=trorres,
 trstat=if_else(trineval=="NOT DONE", "NOT DONE","")),
 tutg %>% mutate(indsname="TUTG", trgrpid = "TARGET", trtestcd ="DIAMETER" , trtest ="Diameter" ,
 trorres = case_when(
 trtoosm =="Y" ~ "TOO SMALL TO MEASURE",
 !is.na(ldiam_trorres) ~ ldiam_trorres,
 TRUE ~ ""
 ),
 trorresu = if_else(!is.na(ldiam_trorres),ldiam_trorresu,"" ),
 trstresc=trorres,
 trstat=if_else(!is.na(trineval)|trineval=="","", "NOT DONE")
 ),
 
 tunw %>% mutate(indsname="TUNW",trgrpid = "NEW", trtestcd ="TUMSTATE" , trtest ="Tumor State" , trorres =tumstate_trorres, trstresc=trorres, trstat=if_else(!is.na(trineval),"", "NOT DONE"))
)
 
#==============================================================================;
#Create common variables;
#==============================================================================;
 
tr02 <- tr01 %>%
 mutate(
 studyid = "MYCSG",
 usubjid = paste("MYCSG", subject, sep = "-"),
 domain = "TR",
 visitnum = folderseq,
 visit = foldername,
 trlnkid = tulnkid,
 trspid = tuspid,
 trlnkgrp = foldername,
 trmethod = tumethod,
 treval = tueval,
 trrefid = paste(indsname, sprintf("%04d", recordposition), sep = "-"),
 trdtc = as.character(as.Date(tudat, format = "%d %b %Y"), format="%Y-%m-%d"),
 trstresc = if_else(trstresc=="TOO SMALL TO MEASURE","5",trstresc),
 trstresu = trorresu
 )
 
 
#==============================================================================;
# Calculate study day
#==============================================================================;
 
 
tr03 <- inner_join(tr02, select(dm, usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, "%Y-%m-%d"),
 trdt = as.Date(trdtc, "%Y-%m-%d"),
 trdy = ifelse(!is.na(trdt) & !is.na(rfstdt), trdt - rfstdt + (trdt >= rfstdt), NA)
 )
 
#==============================================================================;
# Create TRSEQ variable
#==============================================================================;
 
tr04 <- tr03 %>%
 arrange(usubjid, trgrpid, trtestcd, trdtc, trlnkid) %>%
 group_by(usubjid) %>%
 mutate(trseq = row_number()) %>%
 ungroup() %>%
 mutate(trstresn = as.numeric(trstresc)) %>%
 rename_all(toupper)
 
#==============================================================================;
# Keep only required variables and use retain statement to order the variables in the required order
#==============================================================================;
 
 
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "TRSEQ", "TRGRPID", "TRSPID", "TRLNKID",
 "TRLNKGRP", "TRTESTCD", "TRTEST", "TRORRES", "TRORRESU", "TRSTRESC", "TRSTRESN", "TRSTRESU",
 "TRSTAT", "TRREASND", "TRMETHOD", "TREVAL", "VISITNUM", "VISIT", "TRDTC",
 "TRDY"
)
 
tr <- tr04 %>%
 select(all_of(varlist))
 
output <- tr
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================