# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L151
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

library(tidyverse)

#==============================================================================
# Input data
#==============================================================================

vs <- tribble(
  ~studyid, ~usubjid,   ~paramcd, ~avisitn, ~aval, ~base, ~dcaevisn, ~dcsreas,              ~expl,
  "CSG-01", "CSG-1001", "SYSBP",         0,   140,   140,         1, NA,                    "actual result",
  "CSG-01", "CSG-1001", "SYSBP",         1,   142,   140,         1, NA,                    "actual result",
  "CSG-01", "CSG-1001", "SYSBP",         2,    NA,   140,         1, "ADVERSE EVENT",       "rule 1: treatment-related (carry base)",
  "CSG-01", "CSG-1001", "SYSBP",         3,    NA,   140,         1, "ADVERSE EVENT",       "rule 1: treatment-related (carry base)",
  "CSG-01", "CSG-2001", "SYSBP",         0,   150,   150,         2, NA,                    "actual result",
  "CSG-01", "CSG-2001", "SYSBP",         1,   148,   150,         2, NA,                    "actual result",
  "CSG-01", "CSG-2001", "SYSBP",         2,   152,   150,         2, "LACK OF EFFICACY",    "observed at dc visit",
  "CSG-01", "CSG-2001", "SYSBP",         3,    NA,   150,         2, "LACK OF EFFICACY",    "rule 1: treatment-related (carry base)",
  "CSG-01", "CSG-3001", "SYSBP",         0,   130,   130,         1, NA,                    "actual result",
  "CSG-01", "CSG-3001", "SYSBP",         1,   135,   130,         1, NA,                    "actual result",
  "CSG-01", "CSG-3001", "SYSBP",         2,    NA,   130,         1, "PROTOCOL VIOLATION",  "rule 2: other reason (carry locf)",
  "CSG-01", "CSG-3001", "SYSBP",         3,    NA,   130,         1, "PROTOCOL VIOLATION",  "rule 2: other reason (carry locf)",
  "CSG-01", "CSG-4001", "SYSBP",         0,   120,   120,        NA, NA,                  "actual result",
  "CSG-01", "CSG-4001", "SYSBP",         1,   122,   120,        NA, NA,                  "actual result",
  "CSG-01", "CSG-4001", "SYSBP",         2,    NA,   120,        NA, "SPORADIC MISSING",    "rule 3: sporadic gap (carry locf)",
  "CSG-01", "CSG-4001", "SYSBP",         3,   124,   120,        NA, NA,                  "actual result",
  "CSG-01", "CSG-5001", "SYSBP",         0,   130,   130,        NA, NA,                  "actual result",
  "CSG-01", "CSG-5001", "SYSBP",         1,   128,   130,        NA, NA,                  "actual result",
  "CSG-01", "CSG-5001", "SYSBP",         2,   126,   130,        NA, NA,                  "actual result",
  "CSG-01", "CSG-5001", "SYSBP",         3,   125,   130,        NA, NA,                  "actual result",
  "CSG-01", "CSG-6001", "SYSBP",         0,   140,   140,         4, NA,                    "actual result",
  "CSG-01", "CSG-6001", "SYSBP",         1,   142,   140,         4, NA,                    "actual result",
  "CSG-01", "CSG-6001", "SYSBP",         2,    NA,   140,         4, "ADVERSE EVENT",       "LOCF",
  "CSG-01", "CSG-6001", "SYSBP",         3,    NA,   140,         4, "ADVERSE EVENT",       "LOCF",
  "CSG-01", "CSG-6001", "SYSBP",         4,    NA,   140,         4, "ADVERSE EVENT",       "LOCF",
  "CSG-01", "CSG-6001", "SYSBP",         5,    NA,   140,         4, "ADVERSE EVENT",       "rule 1: treatment-related (carry base)"
) 


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================