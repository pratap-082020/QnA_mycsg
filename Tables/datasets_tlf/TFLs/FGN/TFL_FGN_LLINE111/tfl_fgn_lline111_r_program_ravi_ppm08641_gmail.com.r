# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LLINE111
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

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
rm(list = ls())
 
 
source("./TFL_FGN_LLINE111_data.r")
 
 
finalplot <- ggplot(data = adpc,
 aes(
 x=time,
 y=aval,
 color=usubjid
 ))+
 geom_line(show.legend = FALSE)+
 geom_point(show.legend = FALSE)+
 theme_classic()+
 labs(
 x = "Time (hr)",
 y = "Plasma concentration (ng/mL)"
 ) +
 scale_x_continuous(
 breaks = seq(0, 24, by = 4),
 limits = c(0, 24),
 expand = c(0.01, 0)
 ) +
 scale_y_continuous(
 breaks = seq(0, 30, by = 5),
 limits = c(0, 30),
 expand = c(0.01, 0)
 )
 
finalplot
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================