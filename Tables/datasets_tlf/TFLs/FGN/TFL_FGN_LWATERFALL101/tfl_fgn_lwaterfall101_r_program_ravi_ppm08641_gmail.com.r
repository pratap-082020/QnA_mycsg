# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LWATERFALL101
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
 
 
source("./TFL_FGN_LWATERFALL101_data.r")
 
 
# Step 1: Prepare the dataset
graph01 <- adrs %>%
 arrange(desc(pchg), usubjid) %>%
 mutate(usubjid = factor(usubjid, levels = unique(usubjid)),
 pchg2 = if_else(pchg>0,pchg+3,pchg-3))
 
# Step 2: Create waterfall plot
finalplot <- ggplot(graph01, aes(x = usubjid, y = pchg, fill = trtp)) +
 geom_col() +
 geom_text(aes(y=pchg2, label=pchg), size=3)+
 scale_y_continuous(
 limits = c(-100, 100),
 breaks = seq(-100, 100, 20),
 expand = expansion(mult = c(0, 0.05))
 ) +
 scale_fill_manual(
 name = NULL,
 values = c("Placebo" = "lightblue", "Drug MYCSG" = "lightgreen")
 ) +
 labs(
 x = "Subject",
 y = "Best percent change",
 ) +
 theme_classic() +
 theme(
 
 axis.text.x = element_text(angle = -90, vjust = 0.5, hjust = 1),
 legend.position = "bottom",
 plot.caption = element_text(face = "italic", hjust = 0),
 panel.grid.minor.x = element_blank(),
 panel.grid.major.x = element_blank(),
 panel.grid.major.y = element_line(color="grey", linetype="dashed", linewidth = 0.25)
 )
 
finalplot
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================