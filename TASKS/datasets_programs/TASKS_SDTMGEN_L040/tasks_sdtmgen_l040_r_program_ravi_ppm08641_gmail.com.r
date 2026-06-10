# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L040
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

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
 
 
source("./TASKS_SDTMGEN_L040_data.r")
 
 
 
#==============================================================================
# Create required formats as named vectors
#==============================================================================
 
sex_fmt <- c("1" = "M", "2" = "F")
 
#==============================================================================
# Create SEX, ETHNIC, COUNTRY
#==============================================================================
 
dm01 <- demog %>%
 rename(
 old_sex = sex,
 old_race = race,
 old_country = country
 ) %>%
 mutate(
 sex = sex_fmt[as.character(old_sex)],
 ethnic = toupper(ethnicity),
 country = case_when(
 old_country == "UNITED STATES OF AMERICA" ~ "USA",
 old_country == "INDIA" ~ "IND",
 old_country == "MEXICO" ~ "MEX",
 old_country == "JAPAN" ~ "JPN",
 TRUE ~ NA_character_
 )
 )
 
#==============================================================================
# Create race variable from metadata
#==============================================================================
 
race_meta <- metadata %>%
 filter(variable == "RACE") %>%
 mutate(
 old_race = collected_value,
 race = standard_value
 ) %>% select(old_race,race)
 
#==============================================================================
# Merge race_meta with main data based on old_race
#==============================================================================
 
dm02 <- dm01 %>%
 left_join(race_meta, by = "old_race")
 
#==============================================================================
# Sort by subject
#==============================================================================
 
dm03 <- dm02 %>%
 arrange(subject)
 
#==============================================================================
# Final DM dataset — drop intermediate and raw columns
#==============================================================================
 
dm <- dm03 %>%
 select(-starts_with("old_"), -ethnicity)
 
 
output <- dm
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================