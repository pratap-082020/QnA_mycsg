# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LLINE101
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
 
source("./TFL_FGN_LLINE101_data.r")
 
 
# 1. Compute mean and 95% CI for each treatment × visit
stats01 <- adlb %>%
 group_by(trtp, avisitn) %>%
 summarise(
 meanaval = mean(aval, na.rm = TRUE),
 n        = sum(!is.na(aval)),
 sdaval   = sd(aval, na.rm = TRUE),
 lclm     = meanaval - qt(0.975, df = n - 1) * sdaval / sqrt(n),
 uclm     = meanaval + qt(0.975, df = n - 1) * sdaval / sqrt(n),
 .groups  = "drop"
 )
 
# 2. Offset x‐positions so CI bars don’t overlap
stats02 <- stats01 %>%
 mutate(
 xpos = case_when(
 trtp == "Placebo" ~ avisitn - 0.05,
 TRUE              ~ avisitn + 0.05
 ),
 treatment = recode(trtp,
 "Placebo" = "Placebo",
 "MYCSG"   = "Drug MYCSG"
 )
 )
 
# 3. Define aesthetics for colour, linetype, shape
color_map    <- c("Placebo" = "red",       "Drug MYCSG" = "green")
linetype_map <- c("Placebo" = "dashed",    "Drug MYCSG" = "solid")
shape_map    <- c("Placebo" = 18,          "Drug MYCSG" = 16)  # 18=diamond, 16=circle
 
# 4. Plot
finalplot <- ggplot(stats02, aes(x = xpos, y = meanaval,
 colour   = treatment,
 linetype = treatment,
 shape    = treatment)) +
 geom_line(size = 1) +
 geom_errorbar(aes(ymin = lclm, ymax = uclm),
 width = 0.1) +
 geom_point(size = 3) +
 scale_x_continuous(
 name   = "Analysis Visit",
 breaks = 1:5,
 labels = c("Baseline", "Month 1", "Month 2", "Month 3", "Month 4"),
 expand = c(0, 0)
 ) +
 scale_y_continuous(
 name   = "Hemoglobin value (mg/dL)",
 breaks = seq(12, 16, 0.5),
 limits = c(12, 16),
 expand = c(0, 0)
 ) +
 scale_colour_manual(name   = "Treatment", values = color_map) +
 scale_linetype_manual(name   = "Treatment", values = linetype_map) +
 scale_shape_manual(name   = "Treatment", values = shape_map) +
 labs(
 title    = "Line Plot - Hemoglobin Over Time (Mean ± 95% CI) by Treatment Group",
 subtitle = "Safety Analysis Set",
 caption  = "© www.mycsg.in"
 ) +
 theme(
 plot.background = element_rect(fill="white"),
 panel.background = element_rect(fill="white"),
 panel.grid.major    = element_blank(),
 panel.grid.minor    = element_blank(),
 axis.line           = element_line(colour = "black"),
 axis.ticks.length   = unit(2, "pt"),
 legend.position     = c(0.05, 0.95),
 legend.justification= c(0, 1),
 legend.background   = element_rect(fill = "white", colour = "black"),
 plot.margin         = margin(10, 10, 10, 10)
 )
 
finalplot
 
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================