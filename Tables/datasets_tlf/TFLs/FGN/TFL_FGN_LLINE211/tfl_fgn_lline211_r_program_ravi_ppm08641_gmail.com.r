# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LLINE211
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
library(patchwork)

rm(list = ls())


source("./TFL_FGN_LLINE211_data.r")


#------------------------------------------------------------------------------
# 1) Offset AVISITN so confidence intervals do not overlap (within TRTP)
#------------------------------------------------------------------------------
stats02 <- stats01 %>%
  mutate(
    avisitn_plot = case_when(
      trtp == "Placebo" ~ avisitn - 0.05,
      TRUE              ~ avisitn + 0.05
    )
  ) %>%
  arrange(param, agegr1n, avisitn, trtp)

#------------------------------------------------------------------------------
# 2) Plot (DATAPANEL-style): 2x2 panels by AGEGR1, shared axes (fixed)
#------------------------------------------------------------------------------
visit_labs <- c("Baseline", "Month 1", "Month 2", "Month 3", "Month 4")

make_datapanel_plot <- function(df_param, y_accuracy = 0.1) {
  
  df_param <- df_param %>%
    mutate(
      agegr1 = factor(agegr1, levels = df_param %>% distinct(agegr1, agegr1n) %>% arrange(agegr1n) %>% pull(agegr1)),
      trtp   = factor(trtp, levels = c("Placebo", "Active"))
    )
  
  ggplot(
    df_param,
    aes(
      x        = avisitn_plot,
      y        = meanaval,
      group    = trtp,
      linetype = trtp,
      shape    = trtp,
      colour   = trtp
    )
  ) +
    geom_line(linewidth = 0.5) +
    geom_errorbar(aes(ymin = lclm, ymax = uclm), width = 0.08) +
    geom_point(size = 2) +
    facet_wrap(vars(agegr1), ncol = 2, scales = "fixed") +
    scale_x_continuous(
      name   = "Analysis Visit",
      breaks = 1:5,
      labels = visit_labs,
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      name   = "",
      labels = scales::number_format(accuracy = y_accuracy),
      expand = c(0, 0)
    ) +
    theme(
      plot.background      = element_rect(fill = "white"),
      panel.background     = element_rect(fill = "white"),
      panel.grid.major     = element_blank(),
      panel.grid.minor     = element_blank(),
      axis.line            = element_line(colour = "black"),
      axis.ticks.length    = unit(2, "pt"),
      legend.position      = "bottom",
      legend.background    = element_rect(fill = "white", colour = "black"),
      strip.background     = element_rect(fill = "grey85", colour = NA),
      plot.margin          = margin(10, 10, 10, 10)
    ) + theme(axis.text.x = element_text(angle = 60, hjust = 1))
}

#------------------------------------------------------------------------------
# 3) Create one PNG per PARAM (SAS BY PARAM equivalent) and then one RTF
#------------------------------------------------------------------------------
reportloc  <- getwd()
reportname <- stringr::word(reportloc, -1, sep = fixed("/"))
fig_dir    <- file.path(reportloc, "figures")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# ordered params (alphabetical, like PROC SORT BY param)
param_index <- stats02 %>%
  distinct(param) %>%
  arrange(param)

png_files <- c()

for (p in param_index$param) {
  
  df_param <- stats02 %>% filter(param == p)
  
  pplot <- make_datapanel_plot(df_param, y_accuracy = 0.1)
  
  out_png <- file.path(fig_dir, glue("{reportname}_{str_replace_all(p, '[^A-Za-z0-9]+', '_')}.png"))
  png_files <- c(png_files, out_png)
  
  ggsave(filename = out_png, plot = pplot, width = 8, height = 5, dpi = 300)
}

#------------------------------------------------------------------------------
# 4) Write a single RTF with all parameter pages (vector of figures)
#------------------------------------------------------------------------------
reportfile <- file.path(reportloc, paste0(reportname, "_r.rtf"))

png_files %>%
  rtf_read_figure() %>%
  rtf_page(orientation = "landscape", margin = c(rep(0.5, 6))) %>%
  rtf_title(
    title    = "Line Plot - Hematology results comparison over different age groups",
    subtitle = "Safety Analysis Set"
  ) %>%
  rtf_figure(fig_width = 8, fig_height = 5) %>%
  rtf_encode(doc_type = "figure", page_footnote = "last") %>%
  write_rtf(file = reportfile)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================