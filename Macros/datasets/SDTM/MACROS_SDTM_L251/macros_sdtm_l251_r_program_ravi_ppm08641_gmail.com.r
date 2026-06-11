# ============================================================
# Downloaded from myCSG lesson content
# Lesson: MACROS_SDTM_L251
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
 
 
source("./MACROS_SDTM_L251_data.r")
 
#==============================================================================
# Function to create ISO8601 datetime strings (No Regular Expressions)
#==============================================================================
csg_sdtm_create_isodtc <- function(indatevar, intimevar = NA) {
 # Handle NA as character vector
 intimevar <- if (all(is.na(intimevar))) rep("", length(indatevar)) else intimevar
 
 # Step 1: split dates
 date_parts <- str_split(indatevar, "[ /]+")
 
 # Extract day, month, year from each row
 stdayn   <- map_chr(date_parts, ~ suppressWarnings(as.integer(.x[1])))
 stmonthc <- map_chr(date_parts, ~ toupper(.x[2]) %||% "-")
 styear   <- map_chr(date_parts, ~ .x[3] )
 
 stday <- ifelse(is.na(stdayn),"-",str_pad(stdayn,width=2,pad="0"))
 
 # Month lookup
 month_map <- c("JAN"="01", "FEB"="02", "MAR"="03", "APR"="04",
 "MAY"="05", "JUN"="06", "JUL"="07", "AUG"="08",
 "SEP"="09", "OCT"="10", "NOV"="11", "DEC"="12")
 stmonth <- ifelse(stmonthc %in% names(month_map), month_map[stmonthc], "-")
 styear  <- ifelse(is.na(styear) | styear == "UNK", "-", styear)
 
 # Construct date
 stdate <- str_c(styear, stmonth, stday, sep = "-")
 
 # Add time (if any)
 outdtcvar <- ifelse(stdate != "" & intimevar != "",
 str_c(stdate, "T", intimevar),
 ifelse(stdate != "", stdate, ""))
 
 # Cleanup trailing dashes
 outdtcvar <- ifelse(outdtcvar == "-----", "", outdtcvar)
 outdtcvar <- ifelse(str_ends(outdtcvar, "----"), str_sub(outdtcvar, 1, -5), outdtcvar)
 outdtcvar <- ifelse(str_ends(outdtcvar, "--"), str_sub(outdtcvar, 1, -3), outdtcvar)
 outdtcvar <- replace_na(outdtcvar, "")
 
 return(outdtcvar)
}
 
 
enrl01 <- enrlment %>%
 mutate(
 enrldtc  = csg_sdtm_create_isodtc(enrldt_raw, NA),
 randdtc  = csg_sdtm_create_isodtc(randdt_raw, NA),
 rficdtc  = csg_sdtm_create_isodtc(icdt_raw, NA)
 )
 
 
ae01 <- ae %>%
 mutate(
 aestdtc = csg_sdtm_create_isodtc(aestdat_raw,aesttm),
 aeendtc = csg_sdtm_create_isodtc(aeendat_raw,aeentm)
 )
 
output <- ae01
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================