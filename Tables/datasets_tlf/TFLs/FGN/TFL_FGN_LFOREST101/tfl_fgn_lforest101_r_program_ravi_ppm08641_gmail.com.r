# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LFOREST101
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
 
 
source("./TFL_FGN_LFOREST101_data.r")
 
 
finalplot <- ggplot(data=forest_data,
 aes(
 x=hr,
 y=yval
 ))+
 geom_point(color="blue")+
 geom_errorbarh(aes(xmin=lcl, xmax=ucl), color="darkblue", height=0)+
 scale_x_continuous(
 breaks=seq(0.4,1.4,0.2),
 limits=c(0,2.4),
 name="Hazard ratio",
 expand = c(0,0)
 )+
 geom_text(
 aes(x=0, label=subgroup), size= 3, hjust="left"
 )+
 scale_y_reverse(
 labels=NULL,
 expand = expansion(mult=c(0,0.1))
 )+
 geom_text(
 aes(x=1.6, label=trt1), size= 3, hjust="left"
 )+
 geom_text(
 aes(x=2.1, label=trt2), size= 3, hjust="left"
 )+theme_minimal()+
 theme(
 plot.background = element_rect(fill="white", color="white"),
 panel.background = element_rect(fill="white", color="white"),
 axis.title.y = element_blank(),
 panel.grid = element_blank(),
 axis.line.x = element_line(color="black"),
 axis.ticks.x = element_line(color="black"),
 )+
 geom_segment(
 aes(
 x=1,
 xend=1,
 y=0,
 yend=9
 ),
 linetype="dashed",
 color="grey"
 )+
 annotate(
 geom="text",
 x=0,
 y=-1,
 label="Subgroup",
 size = 3,
 hjust="left",
 fontface="bold"
 )+
 annotate(
 geom="text",
 x=1.6,
 y=-1,
 label="Drug MYCSG \n n/m (%)",
 size = 3,
 hjust="left",
 fontface="bold"
 )+
 annotate(
 geom="text",
 x=2.1,
 y=-1,
 label="Placebo \n n/m (%)",
 size = 3,
 hjust="left",
 fontface="bold"
 )+
 annotate(
 geom="segment", x=0, xend= 2.4, y=-0.5, yend=-0.5
 )
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================