# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L160
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
library(stringi)
 
source("./TASKS_SDTMGEN_L160_data.r")
 
comments01 <- comments %>%
 mutate(
 nchar = str_length(comment),
 rest = comment,
 f200 = str_sub(rest,1,200),
 rf200 = stri_reverse(f200),
 srf200 = str_locate(rf200," ")[,1],
 lastspace = 200-srf200+1,
 coval = str_sub(rest,1, lastspace),
 rest= str_sub(rest,lastspace+1),
 
 f200 = str_sub(rest,1,200),
 rf200 = stri_reverse(f200),
 srf200 = str_locate(rf200," ")[,1],
 lastspace = 200-srf200+1,
 coval1 = str_sub(rest,1, lastspace),
 rest= str_sub(rest,lastspace+1),
 
 f200 = str_sub(rest,1,200),
 rf200 = stri_reverse(f200),
 srf200 = str_locate(rf200," ")[,1],
 lastspace = 200-srf200+1,
 coval2 = str_sub(rest,1, lastspace),
 rest= str_sub(rest,lastspace+1),
 
 f200 = str_sub(rest,1,200),
 rf200 = str_trim(stri_reverse(f200)),
 srf200 = str_locate(str_trim(rf200)," ")[,1],
 lastspace = 200-srf200+1,
 coval3 = str_sub(rest,1, lastspace),
 rest= str_sub(rest,lastspace+1),
 
 f200 = str_sub(rest,1,200),
 rf200 = stri_reverse(f200),
 srf200 = str_locate(rf200," ")[,1],
 lastspace = 200-srf200+1,
 coval4 = str_sub(rest,1, lastspace),
 rest= str_sub(rest,lastspace+1),
 
 )
 
output <- comments01 %>%
 select(studyid,usubjid,comment,starts_with("coval"))
 
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================