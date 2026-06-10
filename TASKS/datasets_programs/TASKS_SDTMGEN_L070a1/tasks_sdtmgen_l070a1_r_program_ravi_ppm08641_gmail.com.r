# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L070a1
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

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
library(stringr)
 
 
source("./TASKS_SDTMGEN_L070a1_data.r")
 
#==============================================================================;
#Get the names of all datasets in the current session;
#==============================================================================;
 
object_list <- ls()
 
#------------------------------------------------------------------------------;
#Filter data frames;
#------------------------------------------------------------------------------;
 
data_frames <- object_list %>%
 keep(~is.data.frame(get(.)))
 
#------------------------------------------------------------------------------;
#Create a tibble with data frame names;
#------------------------------------------------------------------------------;
 
dataset_names <- tibble(dataset = data_frames)
 
#------------------------------------------------------------------------------;
#Function to get variable names for a dataset;
#------------------------------------------------------------------------------;
 
get_variable_names <- function(dataset_name) {
 dataset <- get(dataset_name)
 variable_names <- names(dataset)
 tibble(dataset_name = dataset_name, variable = variable_names)
}
 
#------------------------------------------------------------------------------;
#Apply the function to each dataset name;
#------------------------------------------------------------------------------;
 
variable_info <- dataset_names %>%
 rowwise() %>%
 mutate(variables = list(get_variable_names(dataset))) %>%
 unnest(variables)
 
datevars<-variable_info %>%
 filter(str_detect(variable, "dt_raw$"))
 
#==============================================================================;
#Function to convert raw date values to ISO format;
#==============================================================================;
 
create_iso_dtc <- function(input_data, input_dt_var, input_time_var="", output_var) {
 output_data <- input_data %>%
 mutate(
 stdayn = suppressWarnings(as.numeric(word({{ input_dt_var }}, 1))),
 stday = if_else(!is.na(stdayn), str_pad(stdayn, width = 2, pad = "0"), "-"),
 stmonthc = str_to_upper(word({{ input_dt_var }}, 2)),
 stmonth = case_when(
 stmonthc == "JAN" ~ "01",
 stmonthc == "FEB" ~ "02",
 stmonthc == "MAR" ~ "03",
 stmonthc == "APR" ~ "04",
 stmonthc == "MAY" ~ "05",
 stmonthc == "JUN" ~ "06",
 stmonthc == "JUL" ~ "07",
 stmonthc == "AUG" ~ "08",
 stmonthc == "SEP" ~ "09",
 stmonthc == "OCT" ~ "10",
 stmonthc == "NOV" ~ "11",
 stmonthc == "DEC" ~ "12",
 TRUE ~ "-"
 ),
 styear = word({{ input_dt_var }}, 3),
 styear1 = if_else((styear == "UNK") | (is.na(styear)), "-", styear),
 tempdate = str_c(styear1, stmonth, stday, sep = "-"),
 timecheck={{input_time_var}},
 tempdtc = ifelse(timecheck != "", str_c(tempdate, {{ input_time_var }}, sep = "T"), tempdate),
 tempdtc = ifelse(str_sub(tempdtc, -5) == "-----", str_sub(tempdtc, end = -6), tempdtc),
 tempdtc = ifelse(str_sub(tempdtc, -4) == "----", str_sub(tempdtc, end = -5), tempdtc),
 tempdtc = ifelse(str_sub(tempdtc, -2) == "--", str_sub(tempdtc, end = -3), tempdtc),
 {{ output_var }} := tempdtc
 )
 
 return(output_data)
}
 
#==============================================================================;
#Apply create_iso_dtc function to each row of datevars and append the resulting datasets;
#==============================================================================;
 
alldates01 <- datevars %>%
 mutate(output_data = map2(dataset_name, variable, ~ create_iso_dtc(get(.x), get(.y), "", dtc))) %>%
 unnest(output_data) %>%
 select(study,pt,dtc)
 
#==============================================================================;
#Sort the combined dataset by subject and date and pick the latest record;
#==============================================================================;
 
rfpendtc<-alldates01 %>%
 filter(dtc!="") %>%
 arrange(study,pt,dtc) %>%
 group_by(study,pt) %>%
 slice(n()) %>%
 rename(rfpendtc=dtc)
 
output<-rfpendtc
#==============================================================================;

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================