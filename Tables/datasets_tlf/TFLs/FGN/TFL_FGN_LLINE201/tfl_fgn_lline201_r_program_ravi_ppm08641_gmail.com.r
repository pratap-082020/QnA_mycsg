# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_FGN_LLINE201
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#source("D:/SAS/Home/dev/clinical_sas_samples/mycsg/mycsg_config.r")
#rmac1-std1
#rmac1-std2
#rmac1-std3


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

rm(list = ls())

library(glue)
library(tidyverse)
library(haven)
library(assertthat)
library(huxtable)
library(data.table)
library(lubridate)
library(pharmaRTF)
library(r2rtf)

source("./TFL_FGN_LLINE201_data.r")

#------------------------------------------------------------------------------
# 0. Output locations
#------------------------------------------------------------------------------

reportloc  <- getwd()
reportname <- word(reportloc, -1, sep = fixed("/"))
reportfile <- file.path(reportloc, paste0(reportname, "_r.rtf"))

fig_dir <- file.path(reportloc, "figures")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

#------------------------------------------------------------------------------
# 1. Helper: stats + plot for a single paramcd (SAS BY-group equivalent)
#------------------------------------------------------------------------------

stats01 <- adlb %>%
  group_by(paramcd,param,trtp, avisitn) %>%
  summarise(
    meanaval = mean(aval, na.rm = TRUE),
    n        = sum(!is.na(aval)),
    sdaval   = sd(aval, na.rm = TRUE),
    lclm     = meanaval - qt(0.975, df = n - 1) * sdaval / sqrt(n),
    uclm     = meanaval + qt(0.975, df = n - 1) * sdaval / sqrt(n),
    .groups  = "drop"
  ) %>%
  mutate(
    xpos = case_when(
      trtp == "Placebo" ~ avisitn - 0.05,
      TRUE              ~ avisitn + 0.05
    ),
    treatment = recode(trtp,
                       "Placebo" = "Placebo",
                       "Active"   = "Drug MYCSG"
    )
  ) %>% 
  ungroup() %>% 
  mutate(
    lclm=if_else(near(sdaval,0), NA, lclm), #Set to null to not draw error bars,
    uclm=if_else(near(sdaval,0), NA, uclm)
  )



make_line_plot <- function(stats02, y_label, y_limits, y_breaks) {
  
  color_map    <- c("Placebo" = "red",    "Drug MYCSG" = "green")
  linetype_map <- c("Placebo" = "dashed", "Drug MYCSG" = "solid")
  shape_map    <- c("Placebo" = 18,       "Drug MYCSG" = 16)
  
  ggplot(
    stats02,
    aes(
      x        = xpos,
      y        = meanaval,
      colour   = treatment,
      linetype = treatment,
      shape    = treatment
    )
  ) +
    geom_line(size = 0.5) +
    geom_errorbar(aes(ymin = lclm, ymax = uclm), width = 0.1) +
    geom_point(size = 2) +
    scale_x_continuous(
      name   = "Analysis Visit",
      breaks = 1:5,
      labels = c("Baseline", "Month 1", "Month 2", "Month 3", "Month 4"),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      name   = y_label,
      breaks = y_breaks,
      expand = c(0, 0)
    ) +
    coord_cartesian(ylim = y_limits) +
    scale_colour_manual(name = "Treatment", values = color_map) +
    scale_linetype_manual(name = "Treatment", values = linetype_map) +
    scale_shape_manual(name = "Treatment", values = shape_map) +
    theme(
      plot.background      = element_rect(fill = "white"),
      panel.background     = element_rect(fill = "white"),
      panel.grid.major     = element_blank(),
      panel.grid.minor     = element_blank(),
      axis.line            = element_line(colour = "black"),
      axis.ticks.length    = unit(2, "pt"),
      legend.position      = c(0.05, 0.95),
      legend.justification = c(0, 1),
      legend.background    = element_rect(fill = "white", colour = "black"),
      plot.margin          = margin(10, 10, 10, 10)
    )
}

#------------------------------------------------------------------------------
# 2. Parameter control table (like your SAS param_ctrl)
#    Filter to params present + build figure names dynamically
#------------------------------------------------------------------------------
param_ctrl <- tribble(
  ~paramcd, ~param_label,         ~y_label,                    ~ymin, ~ymax, ~ystep,
  "HGB",    "Hemoglobin",         "Hemoglobin (g/dL)",           12,    16,    0.5,
  "WBC",    "White Blood Cells",  "White Blood Cells (10^9/L)",   4,     8,    0.5,
  "PLT",    "Platelets",          "Platelets (10^9/L)",         200,   300,   20
) %>%
  semi_join(adlb %>% distinct(paramcd), by = "paramcd") %>%
  mutate(
    fig_file = file.path(fig_dir, glue("{reportname}_{paramcd}.png")),
    y_limits = map2(ymin, ymax, ~ c(.x, .y)),
    y_breaks = pmap(list(ymin, ymax, ystep), ~ seq(..1, ..2, by = ..3))
  )

#------------------------------------------------------------------------------
# 3. Create one PNG per paramcd
#------------------------------------------------------------------------------
for (i in seq_len(nrow(param_ctrl))) {
  
  pcd <- param_ctrl$paramcd[i]
  
  stats02 <- stats01 %>%
    filter(paramcd == pcd) 
  
  p <- make_line_plot(
    stats02  = stats02,
    y_label  = param_ctrl$y_label[i],
    y_limits = param_ctrl$y_limits[[i]],
    y_breaks = param_ctrl$y_breaks[[i]]
  ) 
  
  ggsave(
    filename = param_ctrl$fig_file[i],
    plot     = p,
    width    = 8,
    height   = 5,
    dpi      = 300
  )
}

#------------------------------------------------------------------------------
# 4. Build one combined RTF with one call (vector of figures)
#    Note: title/subtitle repeats on each page (like a standard TFL header)
#------------------------------------------------------------------------------
param_ctrl$fig_file %>%
  rtf_read_figure() %>%
  rtf_page(orientation = "landscape", margin = c(rep(0.5, 6))) %>%
  rtf_title(
    title    = "Line Plot - Hematology Results Over Time (Mean ± 95% CI) by Treatment Group",
    subtitle = "Safety Analysis Set"
  ) %>%
  rtf_footnote(glue("{reportname}")) %>%
  rtf_figure(fig_width = 8, fig_height = 5) %>%
  rtf_encode(doc_type = "figure", page_footnote = "last") %>%
  write_rtf(file = reportfile)

cat(glue("RTF created: {reportfile}\n"))


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================