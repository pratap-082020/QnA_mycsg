# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_FA_LGE01
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
 
 
source("./SDTM_FA_LGE01_data.r")
 
 
 
#==============================================================================;
#Read and process input datasets;
#==============================================================================;
 
events01 <- ceevents %>%
 select(-foldername)
 
details01 <- cedetails %>%
 select(-foldername)
 
 
#==============================================================================;
#Create rows to hold tests for events01;
#==============================================================================;
events02 <- bind_rows(
 mutate(events01, fatestcd = "OCCUR", faobj = "Diarrhea", faorres = diaoccur_1, faevintx = "Episodes from 00:01 to 08:00"),
 mutate(events01, fatestcd = "OCCUR", faobj = "Diarrhea", faorres = diaoccur_2, faevintx = "Episodes from 08:01 to 16:00"),
 mutate(events01, fatestcd = "OCCUR", faobj = "Diarrhea", faorres = diaoccur_3, faevintx = "Episodes from 16:01 to 24:00"),
 mutate(events01 %>% filter(dianum_1!=""), fatestcd = "EPSDNUM", faobj = "Diarrhea", faorres = dianum_1, faevintx = "Episodes from 00:01 to 08:00"),
 mutate(events01 %>% filter(dianum_2!=""), fatestcd = "EPSDNUM", faobj = "Diarrhea", faorres = dianum_2, faevintx = "Episodes from 08:01 to 16:00"),
 mutate(events01 %>% filter(dianum_3!=""), fatestcd = "EPSDNUM", faobj = "Diarrhea", faorres = dianum_3, faevintx = "Episodes from 16:01 to 24:00"),
 mutate(events01, fatestcd = "OCCUR", faobj = "Vomiting", faorres = vomoccur_1, faevintx = "Episodes from 00:01 to 08:00"),
 mutate(events01, fatestcd = "OCCUR", faobj = "Vomiting", faorres = vomoccur_2, faevintx = "Episodes from 08:01 to 16:00"),
 mutate(events01, fatestcd = "OCCUR", faobj = "Vomiting", faorres = vomoccur_3, faevintx = "Episodes from 16:01 to 24:00"),
 mutate(events01 %>% filter(vomnum_1!=""), fatestcd = "EPSDNUM", faobj = "Vomiting", faorres = vomnum_1, faevintx = "Episodes from 00:01 to 08:00"),
 mutate(events01 %>% filter(vomnum_2!=""), fatestcd = "EPSDNUM", faobj = "Vomiting", faorres = vomnum_2, faevintx = "Episodes from 08:01 to 16:00"),
 mutate(events01 %>% filter(vomnum_3!=""), fatestcd = "EPSDNUM", faobj = "Vomiting", faorres = vomnum_3, faevintx = "Episodes from 16:01 to 24:00")
)%>%
 mutate(facat = "Gastroenteritis",
 fagrpid = format(as.Date(cedat_raw, format="%d %b %Y"),"%Y-%m-%d"),
 fadtc = format(as.Date(gedat_raw, format="%d %b %Y"),"%Y-%m-%d")
 )
 
 
#==============================================================================;
#Create rows to hold tests from details01;
#==============================================================================;
details02 <- bind_rows(
 mutate(details01, fatestcd = "OCCUR", facat = "Gastroenteritis Details", faobj = "Healthcare provided visit", faorres = hcare),
 mutate(details01 %>% filter(hcare == "Yes"), fatestcd = "HOVISTYP", facat = "Gastroenteritis Details", faobj = "Healthcare provided visit", faorres = hcare_type),
 mutate(details01, fatestcd = "OCCUR", facat = "Gastroenteritis Details", faobj = "Oral Rehydration", faorres = orehyd),
 mutate(details01, fatestcd = "OCCUR", facat = "Gastroenteritis Details", faobj = "Intravenous hydration", faorres = ivrehyd),
 mutate(details01, fatestcd = "OCCUR", facat = "Gastroenteritis Details", faobj = "Resulted in hospitalization", faorres = hosp)
) %>%
 mutate(facat = "Gastroenteritis Details",fagrpid = format(as.Date(cedat_raw, format="%d %b %Y"),"%Y-%m-%d"))
 
#==============================================================================;
#Combine the tests from events and details and create variables which are common
#to both the datasets;
#==============================================================================;
 
all01<-bind_rows(events02,details02) %>%
 mutate(studyid = "MYCSG",
 domain = "FA",
 usubjid = subject,
 fatest = case_when(
 fatestcd == "EPSDNUM" ~ "Number of Episodes",
 fatestcd == "OCCUR" ~ "Occurrence",
 fatestcd == "HOVISTYP" ~ "Healthcare visit type",
 TRUE ~ ""
 ),
 fastresc = case_when(
 faorres == "Yes" ~ "Y",
 faorres == "No" ~ "N",
 TRUE ~ faorres
 ),
 fastresn = suppressWarnings(as.numeric(fastresc)),
 faorresu = "",
 fastresu = faorresu,
 faeval = "INVESTIGATOR"
 )
 
 
#==============================================================================;
#Derive FASEQ;
#==============================================================================;
 
all02 <- all01 %>%
 arrange(studyid, usubjid, faobj, fatestcd, fadtc, faevintx) %>%
 group_by(studyid, usubjid) %>%
 mutate(faseq = row_number()) %>%
 ungroup() %>% rename_all(toupper)
 
#==============================================================================;
#keep only required variables;
#==============================================================================;
varlist <- c("STUDYID", "DOMAIN", "USUBJID", "FASEQ", "FAGRPID", "FATESTCD",
 "FATEST", "FAOBJ", "FACAT", "FAORRES", "FAORRESU", "FASTRESC",
 "FASTRESN", "FASTRESU", "FAEVAL", "FADTC", "FAEVINTX")
 
fa <- all02 %>% select(all_of(varlist))
 
output <- fa
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================