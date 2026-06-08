# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TAE_L111
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
 
 
source("./TFL_TAE_L111_data.r")
 
 
# Read and process input datasets
 
adae01 <- adae %>% filter(saffl == "Y" & trtemfl == "Y")
adsl01 <- adsl %>% filter(saffl == "Y")
 
# Create variables and calculate duration
adae02 <- adae01 %>%
 mutate(treatment = trtan)
 
adsl02 <- adsl01 %>%
 mutate(
 treatment = trt01an,
 dur = trtedt-trtsdt + 1
 )
 
# Get treatment totals
trttotal_pre <- adsl02 %>%
 group_by(treatment) %>%
 summarise(trttotal = n_distinct(usubjid))
 
# Create dummy dataset for treatment totals
dummy_pre <- tibble(treatment = c(0, 54, 81))
 
# Create a dataset to hold the total subject years of exposure
subjyr <- adsl02 %>%
 group_by(treatment) %>%
 summarise(subjyr = sum(dur) / 365.25)
 
# Merge actual counts, subject years of exposure dataset with dummy counts
trttotals <- dummy_pre %>%
 left_join(trttotal_pre, by = "treatment") %>%
 left_join(subjyr, by = "treatment")
 
 
# Obtaining actual counts-for the table
# Top row counts
sub_count <- adae02 %>%
 group_by(treatment) %>%
 summarise(count = n()) %>%
 mutate(label="Overall")
 
# SOC level counts
soc_count <- adae02 %>%
 group_by(aebodsys, treatment) %>%
 summarise(count = n())
 
# Preferred term level counts
pt_count <- adae02 %>%
 group_by(aebodsys, aedecod, treatment) %>%
 summarise(count = n())
 
# Combine top row, SOC, and PT level counts into a single dataset
counts01 <- bind_rows(sub_count, soc_count, pt_count)
 
# Create zero counts if an event is not present in a treatment
# Get all the available SOC and PT values
dummy01 <- counts01 %>%
 distinct(aebodsys, aedecod,label)
 
# Create a row for each treatment
dummy02 <- dummy01 %>%
 expand_grid(
 treatment = c(0, 54, 81)
 )
 
# Merge dummy counts with actual counts
counts02 <- dummy02 %>%
 left_join(counts01, by = c("aebodsys", "aedecod", "label", "treatment")) %>%
 mutate(count = coalesce(count, 0))
 
# Calculate percentages
counts03 <- counts02 %>%
 left_join(trttotals, by = "treatment") %>%
 mutate(
 cp = ifelse(count != 0,
 paste0(count, " (", sprintf("%.1f", count / subjyr * 100), ")"),
 " 0")
 )
 
# Create the label column
counts04 <- counts03 %>%
 mutate(
 label = case_when(
 is.na(aebodsys) & is.na(aedecod) ~ paste0(label),
 !is.na(aebodsys) & is.na(aedecod) ~ aebodsys,
 !is.na(aebodsys) & !is.na(aedecod) ~ paste0("(*ESC*)R\"\\pnhang\\fi220\\li220\"", aedecod),
 )
 )
 
# Transpose to obtain treatment as columns
counts05 <- counts04 %>%
 pivot_wider(
 id_cols = c(aebodsys, aedecod, label),
 names_from = treatment,
 values_from = cp,
 names_prefix = "trt"
 )
 
# Create variables to sort the SOCs by descending frequency in high dose and also sort PTs by descending frequency in high dose within each SOC
# Extract counts from high dose column (trt81)
trans03 <- counts05 %>%
 mutate(cnt81 = coalesce(as.numeric(word(trt81, 1, sep = ' ')),0))
 
# Separate top row, SOC rows, and PT rows into separate datasets
section0 <- trans03 %>%
 filter(is.na(aebodsys) & is.na(aedecod))
 
section1 <- trans03 %>%
 filter(!is.na(aebodsys) & is.na(aedecod)) %>%
 arrange(desc(cnt81), aebodsys)
 
section2 <- trans03 %>%
 filter(!is.na(aebodsys) & !is.na(aedecod)) %>%
 arrange(aebodsys, desc(cnt81), aedecod)
 
# Create an order variable for top row
section0 <- section0 %>%
 mutate(section0ord = row_number())
 
# Create order variables for SOC rows and PT rows
section1 <- section1 %>%
 arrange(desc(cnt81),aebodsys) %>%
 mutate(section1ord = row_number(), section0ord = 999, section2ord=0)
 
section2 <- section2 %>%
 arrange(aebodsys,desc(cnt81),aedecod) %>%
 mutate(section2ord = row_number(), section0ord = 999)
 
# Bring the SOC sort order variable into PT rows dataset
section2_2 <- left_join(section2, section1 %>% select(aebodsys, section1ord), by = "aebodsys")
 
# Combine all datasets after creating sort order variables
final01 <- bind_rows(section0, section1, section2_2)
 
# Sort the final dataset using section sort order variables
final02 <- final01 %>%
 arrange(section0ord, section1ord, section2ord)
 
output<-final02 %>% select(aebodsys,aedecod,label,trt0,trt54,trt81)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================