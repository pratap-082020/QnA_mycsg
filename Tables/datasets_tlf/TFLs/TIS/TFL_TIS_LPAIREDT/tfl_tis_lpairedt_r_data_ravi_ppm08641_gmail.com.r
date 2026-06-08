# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_LPAIREDT
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

 library(tidyverse)

#==============================================================================
# Input data
#==============================================================================

adeff <- tribble(
  ~usubjid,    ~param,               ~avisit,     ~aval, ~base, ~chg,
  "MYCSG-001", "Transfusion Count",  "Baseline",  12,    12,     0,
  "MYCSG-001", "Transfusion Count",  "Week 12",    4,    12,    -8,
  "MYCSG-002", "Transfusion Count",  "Baseline",  15,    15,     0,
  "MYCSG-002", "Transfusion Count",  "Week 12",    6,    15,    -9,
  "MYCSG-003", "Transfusion Count",  "Baseline",   9,     9,     0,
  "MYCSG-003", "Transfusion Count",  "Week 12",    8,     9,    -1,
  "MYCSG-004", "Transfusion Count",  "Baseline",  20,    20,     0,
  "MYCSG-004", "Transfusion Count",  "Week 12",   10,    20,   -10,
  "MYCSG-005", "Transfusion Count",  "Baseline",  14,    14,     0,
  "MYCSG-005", "Transfusion Count",  "Week 12",    5,    14,    -9
) %>%
  mutate(
    trt01an = 1,
    saffl = "Y"
  )


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================