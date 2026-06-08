# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TRS_L103
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
 
 
source("./TFL_TRS_L103_data.r")
 
#==============================================================================;
#Define the response format;
#==============================================================================;
 
 
resp_format <- tribble(
 ~resp_code, ~resp_text,
 1, "CR",
 2, "PR",
 3, "SD",
 4, "PD",
 5, "NE"
)
 
 
#==============================================================================;
# Process ADRS dataset to transpose parameters as variables
#==============================================================================;
 
 
adrs01 <- adrs %>%
 mutate(paramcd=str_to_lower(paramcd)) %>%
 pivot_wider(
 id_cols = c(usubjid, trt01pn),
 names_from = paramcd,
 values_from = avalc
 )
 
#==============================================================================;
# Process adrs and adsl datasets
#==============================================================================;
 
adrs02 <- bind_rows(
 adrs01 %>% mutate(treatment=trt01pn),
 adrs01 %>% mutate(treatment=3)
)
 
adsl02 <- bind_rows(
 adsl %>% mutate(treatment=trt01pn),
 adsl %>% mutate(treatment=3)
)
 
#==============================================================================;
# Create a dummy dataset to have all levels
#==============================================================================;
 
 
dummy01 <- expand_grid(
 treatment = 1:3,
 ircn = 1:5,
 invn = 1:5
) %>%
 mutate(
 irc = resp_format$resp_text[ircn],
 inv = resp_format$resp_text[invn]
 )
 
#==============================================================================;
# Fetch treatment totals
#==============================================================================;
 
denoms <- adsl02 %>%
 group_by(treatment) %>%
 summarize(denom = n_distinct(usubjid))
 
 
#==============================================================================;
#Process for counts;
#==============================================================================;
 
# Create concnum01 and concdenom01 tables
concnum01 <- adrs02 %>%
 filter(irc == inv & inv != "" & irc != "") %>%
 group_by(treatment) %>%
 summarise(num = n_distinct(usubjid))
 
concdenom01 <- adrs02 %>%
 filter(inv != "" & irc != "") %>%
 group_by(treatment) %>%
 summarise(denom = n_distinct(usubjid))
 
# Create conc01 by joining concnum01 and concdenom01
conc01 <- full_join(concnum01, concdenom01, by = "treatment")
 
# Create concdummy01
concdummy01 <- tibble(treatment = 1:3)
 
# Get IRC vs INV counts and merge with dummy dataset containing all levels
counts01 <- adrs02 %>%
 group_by(treatment, irc, inv) %>%
 summarise(count = n()) %>%
 ungroup() %>%
 mutate(count = ifelse(is.na(count), 0, count))
 
counts02 <- full_join(dummy01, counts01, by = c("treatment", "irc", "inv")) %>%
 mutate(count = ifelse(is.na(count), 0, count))
 
 
# Calculate percentages using the number of subjects with irc and inv data
counts03 <- counts02 %>%
 left_join(concdenom01, by = "treatment") %>%
 mutate(
 cp = ifelse(count != 0,
 paste(count, " (", sprintf("%.1f",count/denom*100), ")", sep = ""), "0")
 ) %>%
 select(treatment, ircn, irc, inv, cp)
 
# Transpose the data such that investigator result levels become columns
trans01 <- counts03 %>%
 pivot_wider(
 id_cols = c(treatment, ircn, irc),
 values_from = cp,
 names_from = inv,
 ) %>%
 rename_all(tolower)
 
# Create a row for overall concordance and combine with irc/inv level counts
conc02 <- conc01 %>%
 mutate(
 num = ifelse(is.na(num), 0, num),
 denom = ifelse(is.na(denom), 0, denom),
 sd = paste(num, "(", sprintf("%.1f",num/denom*100), ")", sep = "")
 ) %>%
 select(treatment, sd) %>%
 mutate(ircn=99)
 
trans02 <- trans01 %>% mutate(group=1) %>%
 bind_rows(conc02 %>% mutate(group=2)) %>%
 mutate(
 irc = ifelse(group == 2, "Overall Concordance Rate", irc)
 )
 
output <- trans02 %>%
 arrange(treatment,group,ircn)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================