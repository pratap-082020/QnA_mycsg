# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LBAR101
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
library(patchwork)
rm(list = ls())
 
source("./TFL_FGN_LBAR101_data.r")
 
stats01<-tribble(
 ~avisitn,~treatment,~percent,~nsubj,~avisit,~treatmentc,
 1,1,30,70,"Month 1","Low Dose",
 1,2,65,70,"Month 1","High Dose",
 1,3,0,35,"Month 1","Placebo",
 2,1,45,69,"Month 2","Low Dose",
 2,2,80,70,"Month 2","High Dose",
 2,3,1,35,"Month 2","Placebo",
 3,1,56,69,"Month 3","Low Dose",
 3,2,89,68,"Month 3","High Dose",
 3,3,1,34,"Month 3","Placebo",
)
 
barchart <- ggplot(data=stats01,
 aes(x=factor(avisitn),
 y=percent,
 fill=factor(treatmentc,levels=c("Low Dose", "High Dose", "Placebo")))
)+
 geom_bar(stat="identity", position = "dodge")+
 scale_x_discrete(
 name="Analysis Visit",
 labels=c("Month 1", "Month 2", "Month 3")
 )+
 scale_y_continuous(
 name = "Seroconversion (%)",
 breaks=seq(from=0, to=100, by=10),
 limits=c(0,100),
 expand=c(0,0)
 )+theme_minimal()+
 theme(
 plot.background = element_rect(fill="white", color = "white"),
 panel.background = element_rect(fill="white", color="white"),
 panel.grid = element_blank(),
 panel.grid.major.y = element_line(linetype = "dashed", color="grey"),
 axis.line = element_line(color="black"),
 legend.position = "bottom",
 legend.title = element_blank(),
 legend.background = element_rect(fill="white", color="black"),
 axis.ticks = element_line(color="black")
 )+
 scale_fill_manual(
 values=c("Low Dose"="Green", "High Dose"="Blue", "Placebo"="Red")
 )
 
 
numbers <- ggplot(data=stats01,
 aes(
 x=factor(avisitn),
 y=factor(treatment, levels=c("3","2","1"))
 ))+
 geom_text(
 aes(
 label=nsubj
 )
 )+
 scale_y_discrete(
 breaks=c(1,2,3),
 labels = c("Low Dose", "High Dose", "Placebo")
 )+
 scale_x_discrete(
 labels=NULL
 )+
 theme_minimal()+
 theme(
 plot.background = element_rect(color="white", fill="white"),
 panel.background = element_rect(color="white", fill="white"),
 panel.grid = element_blank(),
 axis.title = element_blank()
 )
 
 
finalplot <- barchart / numbers + plot_layout(heights = c(7,3))
 
finalplot
 
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================