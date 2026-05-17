# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_LB_LCSG001
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
 
 
source("./SDTM_LB_LCSG001_data.r")
 
 
#==============================================================================;
# Pool the raw datasets and create direct variables
#==============================================================================;
 
 
 
lb01 <- bind_rows(
 mutate(lab_chem, lbcat = "CHEMISTRY"),
 mutate(lab_hema, lbcat = "HEMATOLOGY"),
 mutate(lab_urin, lbcat = "URINALYSIS")
) %>%
 mutate(
 studyid = study,
 usubjid = paste(study, pt, sep = "-"),
 domain = "LB",
 lbtestcd = test,
 lbspec = toupper(specimen),
 lborres = coll_rslt,
 lborresu = coll_unit,
 lbornrlo = lower,
 lbornrhi = upper
 )
#==============================================================================;
#Pull standard unit and conversion factor from metadata
#==============================================================================;
 
 
lb02 <- left_join(lb01, lab_meta, by = c("lbcat", "lbtestcd", "lborresu"))
 
#------------------------------------------------------------------------------;
# Create values of standard units
#------------------------------------------------------------------------------;
 
 
 
lb03 <- lb02 %>%
 mutate(
 tempsign = case_when(
 str_sub(lborres, 1, 2) %in% c("<=", ">=") ~ str_sub(lborres, 1, 2),
 str_sub(lborres, 1, 1) %in% c("<", ">") ~ str_sub(lborres, 1, 1),
 TRUE ~ ""
 ),
 tempresn = case_when(
 str_sub(lborres, 1, 2) %in% c("<=", ">=") ~ suppressWarnings(as.numeric(str_sub(lborres, 3,-1))),
 str_sub(lborres, 1, 1) %in% c("<", ">") ~ suppressWarnings(as.numeric(str_sub(lborres, 2,-1))),
 TRUE ~ suppressWarnings(as.numeric(lborres))
 ),
 tempstresn = ifelse(!is.na(tempresn) & !is.na(conversion), tempresn * conversion, NA),
 tempstresn = round(tempstresn,decimals),
 lbstresn = ifelse(tempsign == "", tempstresn, NA),
 lbstresc = ifelse(tempsign == "", as.character(tempstresn), ifelse(!is.na(tempstresn), paste0(tempsign, as.character(tempstresn)), NA)),
 tempstnrlo = suppressWarnings(as.numeric(lbornrlo)),
 tempstnrhi = suppressWarnings(as.numeric(lbornrhi)),
 lbstnrlo = ifelse(!is.na(tempstnrlo) & !is.na(conversion), tempstnrlo * conversion, NA),
 lbstnrhi = ifelse(!is.na(tempstnrhi) & !is.na(conversion), tempstnrhi * conversion, NA),
 lbstnrlo = round(lbstnrlo,decimals),
 lbstnrhi = round(lbstnrhi,decimals),
 
 lbnrind = case_when(
 !is.na(lbstnrlo) & !is.na(lbstnrhi) & !is.na(lbstresn) & lbstresn < lbstnrlo ~ "LOW",
 !is.na(lbstnrlo) & !is.na(lbstnrhi) & !is.na(lbstresn) & lbstresn >= lbstnrlo & lbstresn <= lbstnrhi ~ "NORMAL",
 !is.na(lbstnrlo) & !is.na(lbstnrhi) & !is.na(lbstresn) & lbstresn > lbstnrhi ~ "HIGH",
 !is.na(lbstnrlo) & is.na(lbstnrhi) & !is.na(lbstresn) & lbstresn < lbstnrlo ~ "LOW",
 !is.na(lbstnrlo) & is.na(lbstnrhi) & !is.na(lbstresn) & lbstresn >= lbstnrlo ~ "NORMAL"
 )
 )
 
#==============================================================================;
#Create additional variables;
#==============================================================================;
 
lb04 <- lb03 %>%
 mutate(
 lbdtc = as.character(as.Date(lbdt_raw, format = "%d/%b/%Y")),
 visit = case_when(
 folder == "SCR" ~ "SCREENING",
 str_detect(folder, "WEEK") ~ toupper(folder),
 str_detect(folder, "^FU") ~ paste0("FOLLOW-UP ", as.numeric(str_extract(folder, "[0-9]+"))),
 folder == "UNS_" ~ "UNSCHEDULED"
 ),
 visitnum = case_when(
 folder == "SCR" ~ 1,
 str_detect(folder, "WEEK") ~ 100 + as.numeric(str_extract(folder, "[0-9]+")),
 str_detect(folder, "^FU") ~ 200 + as.numeric(str_extract(folder, "[0-9]+")),
 folder == "UNS_" ~ 999
 )
 )
 
#==============================================================================;
# Create study day variable
#==============================================================================;
 
lb05 <- lb04 %>%
 arrange(usubjid) %>%
 left_join(dm %>% select(usubjid, rfstdtc) %>% distinct(), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"),
 lbdt = as.Date(substr(lbdtc, 1, 10), format = "%Y-%m-%d"),
 lbdy = ifelse(!is.na(lbdt) & !is.na(rfstdt), lbdt - rfstdt + (lbdt >= rfstdt), NA)
 )
 
#==============================================================================;
# Create baseline flag
#==============================================================================;
 
 
base01 <- lb05 %>%
 filter(lbdtc != "" & lbdtc <= rfstdtc & lborres != "") %>%
 arrange(usubjid, lbcat, lbtestcd, lbdtc) %>%
 distinct(usubjid, lbcat, lbtestcd, lbdtc)
 
base02 <- base01 %>%
 group_by(usubjid, lbcat, lbtestcd) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(lbblfl = "Y")
 
lb06 <- lb05 %>%
 left_join(base02 %>% select(usubjid, lbcat, lbtestcd, lbdtc, lbblfl), by = c("usubjid", "lbcat", "lbtestcd", "lbdtc"))
 
#==============================================================================;
# Create lbSEQ variable
#==============================================================================;
 
 
lb07 <- lb06 %>%
 arrange(usubjid, lbcat, lbtestcd, lbdtc) %>%
 group_by(usubjid) %>%
 mutate(lbseq = row_number()) %>%
 rename_all(toupper)
 
#==============================================================================;
# Keep only required variables
#==============================================================================;
 
varlist <- c("STUDYID", "DOMAIN", "USUBJID", "LBSEQ", "LBTESTCD",
 "LBTEST", "LBCAT", "LBORRES", "LBORRESU", "LBORNRLO",
 "LBORNRHI", "LBSTRESC", "LBSTRESN", "LBSTRESU", "LBSTNRLO",
 "LBSTNRHI", "LBBLFL", "LBNRIND", "LBSPEC", "VISITNUM", "VISIT",
 "LBDTC", "LBDY")
lb08 <- lb07 %>%
 select(all_of(varlist))
 
output<-lb08
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================