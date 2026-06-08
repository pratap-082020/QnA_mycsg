# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LLINE111a
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
 
source("./TFL_FGN_LLINE111a_data.r")
 
 
stats01 <- adpc %>%
 group_by(time) %>%
 summarize(
 mean = mean(conc, na.rm=TRUE),
 sd = sd(conc, na.rm = TRUE),
 lcl = mean - sd,
 ucl = mean + sd
 ) %>%
 ungroup()
 
 
finalplot <- ggplot(stats01, aes(x = time)) +
 
 # (A) Ribbon: map fill = "Mean ± SD" so it produces a legend key
 geom_ribbon(aes(ymin = lcl,
 ymax = ucl,
 fill = "Mean ± SD"),
 alpha = 0.5) +
 
 # (B) Line + points: map colour = "Mean Concentration (ng/mL)"
 geom_line(aes(y = mean, colour = "Mean Concentration (ng/mL)"),
 linewidth = 0.75) +
 geom_point(aes(y = mean, colour = "Mean Concentration (ng/mL)"),
 size = 2) +
 
 # (C) Scales to force the manual colors & labels
 scale_fill_manual(
 name   = NULL,                # no separate title for fill legend
 values = c("Mean ± SD" = "lightblue")
 ) +
 scale_colour_manual(
 name   = NULL,                # no separate title for colour legend
 values = c("Mean Concentration (ng/mL)" = "blue")
 ) +
 
 # (D) Axes, theme, and limits
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
 breaks = seq(0, 25, by = 5),
 limits = c(0, 25),
 expand = c(0.01, 0)
 ) +
 theme_classic() +
 theme(
 legend.position = "top",
 legend.key.height = unit(0.7, "cm"),
 legend.key.width  = unit(1.5, "cm")
 )
 
 
finalplot
 
#==============================================================================;


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================