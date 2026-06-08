# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LSPIDER101
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
 
rm(list=ls())
 
source("./TFL_FGN_LSPIDER101_data.r")
 
labels <- adfev %>%
 arrange(usubjid,avisitn) %>%
 group_by(usubjid) %>%
 slice_tail() %>%
 ungroup()
 
 
color_map <- c("Placebo"="Red", "Drug MYCSG"="Blue")
shape_map <- c("Placebo"=21, "Drug MYCSG"=22)
linetype_map <- c("Placebo"="dotted", "Drug MYCSG"="solid")
 
finalplot <- ggplot(data=adfev,
 aes(x=avisitn, y=pchg, group=usubjid,
 color=trtp, linetype=trtp, shape=trtp))+
 geom_line()+
 geom_point()+
 scale_x_continuous(
 breaks=c(0,4,8,12),
 labels=c("Week 0", "Week 4", "Week 8", "Week 12"),
 expand = expansion(mult=c(0,0.1))
 )+
 scale_y_continuous(
 breaks=seq(-80,80,10),
 limits=c(-80,80)
 )+
 labs(
 x="Analysis visit",
 y="Percent change in FEV1"
 )+
 scale_color_manual(
 values=color_map,
 name="Treatment"
 )+
 scale_shape_manual(
 values=shape_map,
 name="Treatment"
 )+
 scale_linetype_manual(
 values=linetype_map,
 name="Treatment"
 )+
 theme_minimal()+
 theme(
 plot.background = element_rect(fill="white", color="white"),
 panel.background = element_rect(fill="white", color="white"),
 axis.line = element_line(color="black"),
 axis.ticks = element_line(color="black"),
 panel.grid= element_blank(),
 panel.grid.major.y=element_line(linetype="dotted", color="grey"),
 legend.position = "bottom"
 )+
 geom_text(
 data=labels,
 aes(x=avisitn, y=pchg, label=usubjid),
 nudge_x = 0.5,
 show.legend = FALSE
 )
 
 
finalplot
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================