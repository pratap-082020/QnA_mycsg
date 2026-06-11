# ============================================================
# Downloaded from myCSG lesson content
# Lesson: MACROS_SDTM_L281
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
 
 
source("./MACROS_SDTM_L281_data.r")
 
 
#==============================================================================
# Function to create baseline flag (Simplified Sorting)
#==============================================================================
 
csg_sdtm_create_baseline_flag <- function(df, flagvar, filter_condition, groupbyvars, sortvars) {
 
 # Step 1: Assign a row number (to maintain original sequence)
 df <- df %>%
 mutate(tempseq = row_number())
 
 # Step 2: Filter based on the given condition (equivalent to SAS where)
 base01 <- df %>%
 filter(!!rlang::parse_expr(filter_condition))
 
 # Step 3: Sort data based on `sortvars`
 base02 <- base01 %>%
 arrange(!!!syms(sortvars)) %>%
 group_by(!!!syms(groupbyvars)) %>%
 slice_tail() %>%
 ungroup() %>%
 select(!!!syms(groupbyvars), !!!syms(sortvars), tempseq) %>%
 mutate(!!flagvar := "Y")
 
 # Step 4: Merge baseline flag back to original dataset
 df_out <- df %>%
 left_join(base02, by = c( sortvars, "tempseq")) %>%
 mutate(!!flagvar := ifelse(is.na(!!sym(flagvar)), "", !!sym(flagvar))) %>%
 select(-tempseq) %>%
 arrange(!!!syms(sortvars))
 
 return(df_out)
}
 
#==============================================================================
# Example Usage (Matching Your Base Code)
#==============================================================================
 
 
# Apply the function
lb01 <- csg_sdtm_create_baseline_flag(
 df = lb,
 flagvar = "lbblfl",
 filter_condition = "!is.na(lbdtc) & lbdtc != '' & lbdtc <= rfstdtc & lborres != '' & !is.na(lborres)",
 groupbyvars = c("usubjid", "lbcat", "lbtestcd"),
 sortvars = c("usubjid", "lbcat", "lbtestcd", "lbdtc")
)
 
output <- lb01
 
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================