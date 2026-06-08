# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LSCATTER101
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
 
 
source("./TFL_FGN_LSCATTER101_data.r")
 
adlb2<-adlb %>%
 mutate(
 trt01an = factor(trt01an, levels=c("1","2"))
 )
 
color_map <- c("1"="Blue", "2"="Red")
shape_map <- c("1"=21, "2"=18)
 
finalplot <- ggplot(data=adlb2,
 aes(
 x=base,
 y=aval,
 color=trt01an,
 fill=trt01an,
 shape=trt01an
 ))+
 geom_point(size=3)+
 scale_x_continuous(
 breaks=seq(from=30,to=50,by=2),
 limits=c(30,50)
 )+
 scale_y_continuous(
 breaks=seq(from=30,to=50,by=2),
 limits=c(30,50)
 )+
 labs(
 x="Baseline Hemoglobin Value",
 y="Postbaseline Maximum Hemoglobin Value"
 )+
 geom_abline(
 intercept=0,
 slope=1,
 color="black",
 linetype="dashed"
 )+theme_minimal()+
 theme(
 plot.background = element_rect(color = "white", fill="white"),
 panel.background = element_rect(color = "white", fill="white"),
 panel.grid = element_blank(),
 axis.line = element_line(color="black"),
 axis.ticks = element_line(color="black"),
 axis.title = element_text(size=8),
 legend.position = "bottom",
 legend.background = element_rect(color="black"),
 # legend.title = element_blank()
 )+
 scale_shape_manual(
 name="Treatment",
 values=shape_map,
 labels=c("1"="Drug MYCSG", "2"="Placebo")
 )+
 scale_color_manual(
 name="Treatment",
 values=color_map,
 labels=c("1"="Drug MYCSG", "2"="Placebo")
 )+
 scale_fill_manual(
 name="Treatment",
 values=color_map,
 labels=c("1"="Drug MYCSG", "2"="Placebo")
 )
 
 
finalplot
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================