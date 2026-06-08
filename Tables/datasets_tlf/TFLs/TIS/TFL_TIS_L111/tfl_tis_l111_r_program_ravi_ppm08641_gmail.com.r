# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_L111
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
 
rm(list = ls())
 
source("./TFL_TIS_L111_data.r")
 
 
 
#==============================================================================;
#Process input data for presentation requirement;
#==============================================================================;
 
adsl01 <- adsl %>%
 rename_with(tolower) %>%
 filter(saffl=="Y")
 
adsl02 <- bind_rows(
 adsl01 %>% mutate(treatment=trt01an)
)
 
adsl03 <- bind_rows(
 adsl02 %>% mutate(group=1, statistic=str_to_upper(case_when(sex=="M"~"Male", sex=="F" ~ "Female", sex=="" ~ "Missing"))),
 adsl02 %>% mutate(group=2, statistic=if_else(race=="","Missing", race)),
)
 
#==============================================================================;
#Get treatment totals;
#==============================================================================;
 
trttotals_pre <- adsl02 %>%
 count(treatment)
 
dummy_trttotals <- tibble(treatment=1:2)
 
trttotals <- dummy_trttotals %>%
 left_join(trttotals_pre, by="treatment") %>%
 mutate(
 trttotal= if_else(is.na(n),0, n)
 ) %>%
 select(-n)
 
#==============================================================================;
#Get the counts;
#==============================================================================;
 
counts01 <- adsl03 %>%
 count(group,treatment,statistic)
 
 
dummy01 <- tribble(
 ~group, ~grouplabel, ~intord, ~statistic,
 1, "Sex", 1, "Male",
 1, "Sex", 2, "Female",
 1, "Sex", 99, "Missing",
 2, "Race", 3, "Asian",
 2, "Race", 2, "Black or African American",
 2, "Race", 1, "White",
 2, "Race", 4, "Other",
 2, "Race", 99, "Missing",
) %>%
 mutate(ustat=str_to_upper(statistic))
 
dummy02 <- dummy01 %>%
 cross_join(dummy_trttotals)
 
counts02 <- dummy02 %>%
 left_join(counts01, by=c("group"="group", "treatment"="treatment", "ustat"="statistic")) %>%
 mutate(
 count = if_else(is.na(n),0, n)
 ) %>%
 select(-n)
 
 
#==============================================================================;
#Calculate percentages;
#==============================================================================;
 
counts03 <- counts02 %>%
 left_join(trttotals,by="treatment")
 
counts04 <- counts03 %>%
 mutate(
 percent = if_else(trttotal!=0,count/trttotal*100,0),
 percentf = if_else(percent==100, "%3.0f", "%4.1f"),
 percentc = str_c(" (", sprintf(percentf,percent),"%)"),
 cp = if_else(count==0, "  0", str_c(count, percentc))
 )
 
counts05 <- counts04 %>%
 pivot_wider(
 id_cols = c(group,grouplabel,intord,statistic),
 values_from = cp,
 names_from = treatment,
 names_prefix = "trt_"
 )
 
 
#==============================================================================
#Perform Chi-square test by group
#==============================================================================
 
events01 <- counts03 %>%
 filter(intord != 99)
 
# Pivot data into contingency table per group
pval <- events01 %>%
 select(group, statistic, treatment, count) %>%
 group_by(group) %>%
 nest() %>%
 mutate(
 chisq_p = map_dbl(data, function(df) {
 # Create contingency table
 tab <- xtabs(count ~ statistic + treatment, data = df)
 
 # Remove rows/cols with all-zero counts
 tab <- tab[rowSums(tab) > 0, colSums(tab) > 0, drop = FALSE]
 
 # Only run test if we have at least 2 rows and 2 columns
 if (all(dim(tab) >= c(2, 2))) {
 suppressWarnings(chisq.test(tab, correct = FALSE)$p.value)
 } else {
 NA_real_
 }
 }),
 pval = case_when(
 !is.na(chisq_p) & chisq_p < 0.0001 ~ "<.0001",
 !is.na(chisq_p) ~ sprintf("%0.4f", chisq_p),
 TRUE ~ "-"
 ),
 intord=1,
 ) %>%
 select(group,intord, pval)
 
#==============================================================================;
#Bring pvalue onto descriptive statistics data;
#==============================================================================;
 
counts06 <- counts05 %>%
 left_join(pval, by=c("group", "intord")) %>%
 rename(c1=grouplabel, c2=statistic, c3=trt_1, c4=trt_2) %>%
 arrange(group,intord) %>%
 filter(intord!=99)
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================