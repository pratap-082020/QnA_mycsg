# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RS_LONCEX06
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
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
library(lubridate)
library(pharmaRTF)
 
 
source("./SDTM_RS_LONCEX06_data.r")
 
#==============================================================================;
#Read input datasets;
#==============================================================================;
 
dm01 <- dm
 
#==============================================================================;
#Create required variables in rs;;
#==============================================================================;
 
rs01 <- rs_rec %>%
 mutate(
 studyid="MYCSG",
 domain = "RS",
 usubjid = paste(studyid,subject,sep="-"),
 rsdtc = as.character(as.Date(rsdat, "%d %b %Y"), format="%Y-%m-%d"),
 visitnum = folderseq,
 visit = foldername
 )
 
#==============================================================================;
#create required rows for testcds;
#==============================================================================;
 
rs02 <- bind_rows(
 rs01 %>% mutate(rstestcd = "TRGRESP", rstest = "Target Response", rsorres = trgresp_rsorres),
 rs01 %>% mutate(rstestcd = "NTRGRESP", rstest = "Non-target Response", rsorres = ntrgresp_rsorres),
 rs01 %>% mutate(rstestcd = "OVRLRESP", rstest = "Overall Response", rsorres = ovrlresp_rsorres),
) %>% mutate(rsstresc = rsorres) %>%
 filter(!is.na(rsorres),rsorres != "")
 
#==============================================================================;
# Create rs03 dataset
#==============================================================================;
 
 
rs03 <- inner_join(rs02, dm %>% select(usubjid,rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, "%Y-%m-%d"),
 rsdt = as.Date(rsdtc, "%Y-%m-%d"),
 rsdy = ifelse(!is.na(rsdt) & !is.na(rfstdt), rsdt - rfstdt + (rsdt >= rfstdt), NA)
 )
 
#==============================================================================;
# Create SEQ variable;
#==============================================================================;
 
 
rs04 <- rs03 %>%
 arrange(studyid, usubjid, rstestcd, rsdtc) %>%
 group_by(studyid, usubjid) %>%
 mutate(rsseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
#==============================================================================;
#Keep only the required variables;
#==============================================================================;
 
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "RSSEQ", "RSTESTCD",
 "RSTEST", "RSORRES", "RSSTRESC", "RSEVAL", "VISITNUM",
 "VISIT", "RSDTC", "RSDY"
)
 
 
rs <- rs04 %>%
 select(all_of(varlist))
 
 
output <- rs
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================