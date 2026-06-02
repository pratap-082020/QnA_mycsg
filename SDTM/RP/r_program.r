# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RP_L101
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
 
 
source("./SDTM_RP_L101_data.r")
 
 
# Read input datasets
repmen01 <- repmen
dm01 <- dm
se01 <- se
sv01 <- sv
 
# Reorganize the data collected to present the information as a result of a test code
 
rp01 <- bind_rows(
 mutate(repmen01 %>% filter(str_to_upper(repmen_yn)=="NO"), rptestcd = "RPALL",rporres = "", rporresu="",rpstresc=rporres, rpstresu=rporresu),
 mutate(repmen01 %>% filter(str_to_upper(repmen_yn)=="YES"), rptestcd = "CHILDPOT", rporres = childpot, rporresu="",rpstresc=rporres, rpstresu=rporresu),
 mutate(repmen01 %>% filter(str_to_upper(repmen_yn)=="YES"), rptestcd = "MENOSTAT", rporres = menostat, rporresu="",rpstresc=rporres, rpstresu=rporresu),
 
)
 
 
rp02 <- rp01 %>%
 mutate(
 studyid = "MYCSG",
 domain = "RP",
 usubjid = paste(studyid, subject, sep = '-'),
 rpspid = ifelse(!is.na(recordposition), sprintf("%03d", recordposition), NA),
 rpdtc = format(as.Date(repmendat, format = "%d/%b/%Y"),"%Y-%m-%d"),
 rpstat = if_else(is.na(rporres) | rporres == "", "NOT DONE", ""),
 rpreasnd = if_else(rpstat=="NOT DONE", "Not Collected", ""),
 rptest = case_when(
 rptestcd=="RPALL"~"Reproductive System Findings",
 rptestcd=="CHILDPOT"~"Childbearing Potential",
 rptestcd=="MENOSTAT"~"Menopause Status",
 TRUE ~ ""
 
 )
 )
 
# Create study day variable
rp03 <- rp02 %>%
 left_join(dm01 %>% select(usubjid, rfstdtc), by = "usubjid") %>%
 mutate(
 rfstdt = as.Date(substr(rfstdtc, 1, 10), format = "%Y-%m-%d"),
 rpdt = as.Date(substr(rpdtc, 1, 10), format = "%Y-%m-%d"),
 rpdy = as.numeric(if_else(!is.na(rfstdt) & !is.na(rpdt), rpdt - rfstdt + (rpdt >= rfstdt), NA))
 )
 
# Create VISITNUM and VISIT variables
rp04 <- rp03 %>%
 mutate(
 visit = str_to_upper(foldername),
 visitnum = folderseq
 )
 
# Remapping unscheduled visits using SV dataset
 
uns01 <- filter(rp04, str_detect(visit,"UNSCHEDULED"))%>%
 select(-visitnum,-visit)
sched01 <- filter(rp04, !str_detect(visit,"UNSCHEDULED"))
 
uns02 <- uns01 %>%
 left_join(sv01 %>% select(usubjid, svstdtc, svendtc, visitnum, visit),
 by = c("usubjid" = "usubjid", "rpdtc"="svstdtc"))
 
 
rp05 <- bind_rows(uns02, sched01)
 
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
 
rp06 <- rp05 %>%
 left_join(epochdates, by = "usubjid") %>%
 mutate(
 ss7 = substr(ss, 1, 7),
 st7 = substr(st, 1, 7),
 sf7 = substr(sf, 1, 7),
 epoch = case_when(
 nchar(rpdtc) == 10 & (ss <= rpdtc) & ((rpdtc < st) | st == "") ~ "SCREENING",
 nchar(rpdtc) == 10 & (st <= rpdtc) & ((rpdtc < sf) | sf == "") ~ "TREATMENT",
 nchar(rpdtc) == 10 & (rpdtc > sf) ~ "FOLLOW-UP",
 nchar(rpdtc) == 7 & (ss7 < rpdtc) & ((rpdtc < st7) | st == "") ~ "SCREENING",
 nchar(rpdtc) == 7 & (st7 < rpdtc) & ((rpdtc < sf7) | sf == "") ~ "TREATMENT",
 nchar(rpdtc) == 7 & (rpdtc > sf7) & sf7 != "" ~ "FOLLOW-UP"
 )
 )
 
# Create baseline flag
base01 <- rp06 %>%
 filter(!is.na(rporres) & "" <= rpdtc & rpdtc <= rfstdtc) %>%
 arrange(usubjid,rptestcd,rpdtc)
 
base02 <- base01 %>%
 group_by(usubjid, rptestcd) %>%
 slice(n()) %>%
 ungroup() %>%
 mutate(rpblfl="Y")
 
rp08 <- rp06 %>%
 left_join(base02 %>% select(usubjid, rptestcd, rpdtc, rpblfl), by = c("usubjid", "rptestcd", "rpdtc"))
 
# Create rpSEQ variable
rp09 <- rp08 %>%
 arrange(usubjid, rptestcd, rpdtc) %>%
 group_by(usubjid) %>%
 mutate(rpseq = row_number()) %>%
 ungroup() %>%
 rename_all(toupper)
 
# Define a character vector with variable names
rpvarlist <- c(
 "STUDYID", "DOMAIN", "USUBJID", "RPSEQ", "RPSPID", "RPTESTCD", "RPTEST",
 "RPORRES", "RPORRESU", "RPSTRESC", "RPSTRESU", "RPSTAT", "RPREASND",
 "RPBLFL", "VISITNUM", "VISIT", "EPOCH", "RPDTC", "RPDY"
)
 
# Assuming you have a data frame named rp09, you can create the 'rp' data frame
rp <- rp09 %>%
 select(all_of(rpvarlist))
 
output <- rp
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================