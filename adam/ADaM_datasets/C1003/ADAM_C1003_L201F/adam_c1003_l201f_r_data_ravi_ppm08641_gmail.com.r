# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADAM_C1003_L201F
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

library(tidyverse)

adcm03 <- tribble(
  ~studyid, ~usubjid, ~trtsdt, ~trtedt, ~trtsdtm, ~trtedtm, ~astdt, ~aendt, ~astdtm, ~aendtm, ~exp_prefl, ~exp_ontrtfl, ~scenario,
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2019-12-30", "2019-12-31", NA, NA, "Y", "",  "Started before and ended before",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2019-12-30", NA, "2019-12-30T08:00:00", NA, "Y", "Y", "Started before and no end date",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2019-12-30", "2020-01-02", "2019-12-30T08:00:00", "2020-01-02T10:00:00", "Y", "Y", "Started before and ended after",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2019-12-30", "2019-12-31", "2019-12-30T08:00:00", "2019-12-31T10:00:00", "Y", "",  "Started before and ended before",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2020-01-05", NA, "2020-01-05T10:00:00", NA, "",  "Y", "Started and ended in between",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2020-01-20", NA, "2020-01-20T10:00:00", NA, "",  "",  "Started after treatment end date",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2019-12-30", NA, NA, NA, "Y", "Y", "Time missing: Started before and no end date",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2019-12-30", "2020-01-05", NA, NA, "Y", "Y", "Time missing: Started before and ended after",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", "2020-01-05", NA, NA, NA, "",  "Y", "Time missing: Started and ended in between",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", NA, NA, NA, NA, "Y", "Y", "Both start and end dates missing",
  "S1001", "01-001", "2020-01-01", "2020-01-15", "2020-01-01T10:00:00", "2020-01-15T17:00:00", NA, "2020-01-05", NA, NA, "Y", "Y", "Start date unknown but ended in treatment period"
) %>%
  mutate(
    across(c(trtsdt, trtedt, astdt, aendt), ~parse_date(.x, format="%Y-%m-%d")),
    across(c(trtsdtm, trtedtm, astdtm, aendtm), ~parse_datetime(.x, format="%Y-%m-%dT%H:%M:%S"))
  )

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================