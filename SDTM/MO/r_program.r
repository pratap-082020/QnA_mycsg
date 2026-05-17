# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_MO_L101
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
 
 
source("./SDTM_MO_L101_data.r")
 
 
 
# Read input datasets
morpho01 <- morpho
dm01 <- dm
se01 <- se
sv01 <- sv
 
# Reorganize the data collected to present the information as a result of a test code
 
mo01 <- bind_rows(
 mutate(morpho01 %>% filter(str_to_upper(moyn)=="NO"), motestcd = "MOALL",moorres = "", moorresu="",mostresc=moorres, mostresu=moorresu, moreasnd=reasnd),
 mutate(morpho01 %>% filter(str_to_upper(moyn)=="YES"), motestcd = "LENGTH", moorres = molength, moorresu=ifelse(moorres!="", "mm",""),mostresc=moorres, mostresu=moorresu),
 mutate(morpho01 %>% filter(str_to_upper(moyn)=="YES"), motestcd = "WIDTH", moorres = mowidth, moorresu=ifelse(moorres!="", "mm","") ,mostresc=moorres, mostresu=moorresu),
 mutate(morpho01 %>% filter(str_to_upper(moyn)=="YES"), motestcd = "DEPTH", moorres = modepth, moorresu=ifelse(moorres!="", "mm","") ,mostresc=moorres, mostresu=moorresu),
 
)
 
 
mo02 <- mo01 %>%
 mutate(
 studyid = "MYCSG",
 domain = "MO",
 usubjid = paste(studyid, subject, sep = '-'),
 mospid = ifelse(!is.na(recordposition), sprintf("%03d", recordposition), NA),
 modtc = format(as.Date(modat, format = "%d/%b/%Y"),"%Y-%m-%d"),
 mostat = if_else(is.na(moorres) | moorres == "", "NOT DONE", ""),
 moreasnd = if_else(motestcd != "MOALL" & moorres=="", "Not Collected", moreasnd),
 mostresn = as.numeric(mostresc),
 motest = case_when(
 motestcd=="MOALL"~"Morphology Findings",
 motestcd=="LENGTH"~"Length",
 motestcd=="WIDTH"~"Width",
 motestcd=="DEPTH"~"Depth",
 TRUE ~ ""
 
 ),
 moloc = ifelse(mostat!="NOT DONE", "KIDNEY",""),
 molat = str_to_upper(laterality),
 momethod = ifelse(mostat!="NOT DONE", "CT SCAN","")
 
 )
 
# Create study day variable
mo03 <- mo02 %>%
 left_join(dm01 %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"),
 modt = as.Date(substr(modtc, 1, 10), format = "%Y-%m-%d"),
 mody = as.numeric(if_else(!is.na(rfstdt) & !is.na(modt), modt - rfstdt + (modt >= rfstdt), NA))
 )
 
# Create VISITNUM and VISIT variables
mo04 <- mo03 %>%
 mutate(
 visit = str_to_upper(foldername),
 visitnum = folderseq
 )
 
# Remapping unscheduled visits using SV dataset
 
uns01 <- filter(mo04, str_detect(visit,"UNSCHEDULED"))%>%
 select(-visitnum,-visit)
sched01 <- filter(mo04, !str_detect(visit,"UNSCHEDULED"))
 
uns02 <- uns01 %>%
 left_join(sv01 %>% select(usubjid, svstdtc, svendtc, visitnum, visit),
 by = c("usubjid" = "usubjid", "modtc"="svstdtc"))
 
 
mo05 <- bind_rows(uns02, sched01)
 
# EPOCH variable creation
se02 <- se01 %>%
 mutate(short = str_to_lower(substr(epoch, 1, 1)))
 
epochstart <- se02 %>%
 select(usubjid, short, sestdtc) %>%
 pivot_wider(names_from = short, values_from = sestdtc, names_prefix = "s", values_fill = "")
 
epochend <- se02 %>%
 select(usubjid, short, seendtc) %>%
 pivot_wider(names_from = short, values_from = seendtc, names_prefix = "e", values_fill = "")
 
epochdates <- left_join(epochstart, epochend, by = "usubjid")
 
mo06 <- mo05 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(modtc) == 10 & (ss <= modtc) & ((modtc < st) | st == "") ~ "SCREENING",
 nchar(modtc) == 10 & (st <= modtc) & ((modtc < sf) | sf == "") ~ "TREATMENT",
 nchar(modtc) == 10 & (modtc > sf) ~ "FOLLOW-UP",
 nchar(modtc) == 7 & (ss7 < modtc) & ((modtc < st7) | st == "") ~ "SCREENING",
 nchar(modtc) == 7 & (st7 < modtc) & ((modtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(modtc) == 7 & (modtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create baseline flag
base01 <- mo06 %>%
 filter(!is.na(moorres) & "" <= modtc & modtc <= rfstdtc) %>%
 arrange(usubjid,motestcd,modtc)
 
base02 <- base01 %>%
 group_by(usubjid, motestcd) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(moblfl="Y")
 
mo08 <- mo06 %>%
 left_join(base02 %>% select(usubjid, motestcd, modtc, moblfl), by = c("usubjid", "motestcd", "modtc"))
 
# Create moSEQ variable
mo09 <- mo08 %>%
 arrange(usubjid, motestcd, modtc) %>%
 group_by(usubjid) %>%
 mutate(moseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Define the variable list
movarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "MOSEQ", "MOSPID", "MOTESTCD", "MOTEST",
 "MOORRES", "MOORRESU", "MOSTRESC", "MOSTRESN", "MOSTRESU", "MOSTAT",
 "MOREASND", "MOLOC", "MOLAT", "MOMETHOD", "MOBLFL", "VISITNUM", "VISIT",
 "EPOCH", "MODTC", "MODY"
)
 
# Assuming you have a data frame named mo09, you can create the 'mo' data frame
mo <- mo09 %>%
 select(all_of(movarlist))
 
output <- mo
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================