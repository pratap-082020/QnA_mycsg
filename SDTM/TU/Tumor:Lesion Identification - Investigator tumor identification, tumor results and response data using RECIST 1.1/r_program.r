# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TU_LONCEX06
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
 
 
source("./SDTM_TU_LONCEX06_data.r")
 
library(dplyr)
 
#==============================================================================;
# Append the required input datasets and create a variable to identify the source of the dataset
#==============================================================================;
 
 
tu01 <- bind_rows(
 tuntsc %>% mutate(indsname="TUNTSC"),
 tutgsc %>% mutate(indsname="TUTGSC"),
 tunw %>% mutate(indsname="TUNW")
 )
 
#==============================================================================;
# Create variables based on raw variables
#==============================================================================;
 
 
tu02 <- tu01 %>%
 mutate(
 studyid = "MYCSG",
 usubjid = paste("MYCSG", subject, sep = "-"),
 domain = "TU",
 turefid = if_else(!is.na(recordposition), paste(indsname, sprintf("%04d", recordposition), sep = "-"), NA_character_),
 tutestcd = "TUMIDENT",
 tutest = "Tumor Identification",
 tulnkid = tulnkid,
 tuloc = tuloc,
 tulat = tulat,
 tumethod = tumethod,
 tueval = tueval,
 visitnum = folderseq,
 visit = foldername,
 tudtc = as.character(as.Date(tudat, format = "%d %b %Y"), format="%Y-%m-%d"),
 tuorres = case_when(
 indsname == "TUNTSC" ~ "NON-TARGET",
 indsname == "TUTGSC" ~ "TARGET",
 indsname == "TUNW" ~ "NEW",
 TRUE ~ NA_character_
 ),
 tustresc = tuorres
 )
 
#==============================================================================;
# Calculate study day
#==============================================================================;
 
 
tu03 <- inner_join(tu02, dm %>% select(usubjid,rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(rfstdtc, format = "%Y-%m-%d"),
 tudt = as.Date(tudtc, format = "%Y-%m-%d"),
 tudy = ifelse(!is.na(tudt) & !is.na(rfstdt), tudt - rfstdt + (tudt >= rfstdt), NA)
 )
 
 
#==============================================================================;
# Create TUSEQ variable
#==============================================================================;
 
tu04 <- tu03 %>%
 arrange(usubjid, tutestcd, tumethod, tudtc, tulnkid) %>%
 group_by(usubjid) %>%
 mutate(tuseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
#==============================================================================;
# Keep only required variables and use retain statement to order the variables in the required order
#==============================================================================;
 
 
varlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "TUSEQ", "TUREFID", "TUSPID",
 "TULNKID", "TUTESTCD", "TUTEST", "TUORRES", "TUSTRESC", "TULOC",
 "TULAT", "TUMETHOD", "TUEVAL", "VISITNUM", "VISIT", "TUDTC", "TUDY"
)
 
tu <- tu04 %>%
 select(all_of(varlist))
 
 
output<-tu
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================