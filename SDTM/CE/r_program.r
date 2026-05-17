# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_CE_LGE01
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
 
 
source("./SDTM_CE_LGE01_data.r")
 
#==============================================================================
# Read and process input datasets
# Replace Yes with Y and No with N using across processing
#==============================================================================
events01 <- ceevents %>%
 mutate(across(c(diaoccur_1,diaoccur_2,diaoccur_3,vomoccur_1,vomoccur_2,vomoccur_3),
 ~ case_when(.=="Yes"~"Y",
 .=="No"~"N",
 TRUE~NA)))
 
#==============================================================================
# Create records for each instance of diarrhea and vomiting
#==============================================================================
 
events02<-bind_rows(
 mutate(events01,ceterm="Diarrhea",ceevintx="Episodes from 00:00 to 08:00",ceoccur=diaoccur_1),
 mutate(events01,ceterm="Diarrhea",ceevintx="Episodes from 08:01 to 16:00",ceoccur=diaoccur_2),
 mutate(events01,ceterm="Diarrhea",ceevintx="Episodes from 16:01 to 24:00",ceoccur=diaoccur_3),
 
 mutate(events01,ceterm="Vomiting",ceevintx="Episodes from 00:00 to 08:00",ceoccur=vomoccur_1),
 mutate(events01,ceterm="Vomiting",ceevintx="Episodes from 08:01 to 16:00",ceoccur=vomoccur_2),
 mutate(events01,ceterm="Vomiting",ceevintx="Episodes from 16:01 to 24:00",ceoccur=vomoccur_3),
 
 )
 
#==============================================================================;
#Create common variable;
#==============================================================================;
 
events03 <- events02 %>%
 mutate(
 cedecod = ceterm,
 studyid = "MYCSG",
 usubjid = subject,
 domain = "CE",
 cepresp = "Y",
 cecat = "Gastroenteritis",
 cegrpid = format(as.Date(cedat_raw, format = "%d %b %Y"),"%Y-%m-%d"),
 cedtc = format(as.Date(gedat_raw, format = "%d %b %Y"),"%Y-%m-%d"),
 cespid = as.character(geday)
 )
 
#==============================================================================
# Derive CESEQ
#==============================================================================
events04 <- events03 %>%
 arrange(studyid, usubjid, cegrpid, ceterm, cedtc, ceevintx) %>%
 group_by(studyid, usubjid) %>%
 mutate(CESEQ = row_number()) %>%
 rename_all(toupper)
 
#==============================================================================
# Keep only required variables
#==============================================================================
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "CESEQ", "CEGRPID", "CESPID",
 "CETERM", "CEDECOD", "CECAT", "CEPRESP", "CEOCCUR", "CEDTC", "CEEVINTX"
)
 
ce <- events04 %>%
 select(all_of(varlist))
 
output <- ce
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================