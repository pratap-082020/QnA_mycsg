# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TIS_LPAIREDT
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================


#==============================================================================
# Program for the task
#==============================================================================

#==============================================================================
# Read and process input data
#==============================================================================

adeff01 <- adeff %>%
  filter(saffl == "Y", avisit == "Week 12")

#------------------------------------------------------------------------------
# Create a variable named treatment to extend the code for other
# treatments/studies when needed
#------------------------------------------------------------------------------

adeff02 <- adeff01 %>%
  mutate(treatment = trt01an)

#==============================================================================
# Fetch all the analysis variables into a single variable using output logic
#==============================================================================

#------------------------------------------------------------------------------
# Create the group variables to indicate the rows for each analysis variable
#------------------------------------------------------------------------------

adeff03 <- bind_rows(
  adeff02 %>%
    mutate(group = 1, result = base),
  adeff02 %>%
    mutate(group = 2, result = aval),
  adeff02 %>%
    mutate(group = 3, result = chg)
) %>%
  arrange(group, treatment)

#==============================================================================
# Obtain the descriptive statistics for the analysis variable
#==============================================================================

stats01 <- adeff03 %>%
  group_by(group, treatment) %>%
  summarise(
    result_n = sum(!is.na(result)),
    result_nmiss = sum(is.na(result)),
    result_mean = mean(result, na.rm = TRUE),
    result_stddev = sd(result, na.rm = TRUE),
    result_min = min(result, na.rm = TRUE),
    result_q1 = quantile(result, 0.25, na.rm = TRUE, names = FALSE, type = 2),
    result_median = median(result, na.rm = TRUE),
    result_q3 = quantile(result, 0.75, na.rm = TRUE, names = FALSE, type = 2),
    result_max = max(result, na.rm = TRUE),
    .groups = "drop"
  )

#==============================================================================
# Process the statistics as per presentation requirements
#==============================================================================

stats02 <- stats01 %>%
  mutate(
    mean = if_else(!is.na(result_mean), sprintf("%5.1f", result_mean), NA),
    std = if_else(!is.na(result_stddev), str_c(" (", sprintf("%6.2f", result_stddev), ")"), " ( - )"),
    median = if_else(!is.na(result_median), sprintf("%5.1f", result_median), NA),
    q1 = if_else(!is.na(result_q1), sprintf("%5.1f", result_q1), NA),
    q3 = if_else(!is.na(result_q3), sprintf("%5.1f", result_q3), NA),
    min = if_else(!is.na(result_min), sprintf("%3.0f", result_min), NA),
    max = if_else(!is.na(result_max), sprintf("%3.0f", result_max), NA),
    nnmiss = str_c(sprintf("%3.0f", result_n), " (", sprintf("%3.0f", result_nmiss), ")"),
    meanstd = if_else(result_n != 0, str_c(str_trim(mean), str_trim(std)), NA),
    q1q3 = if_else(result_n != 0, str_c(str_trim(q1), ",", str_trim(q3)), NA),
    minmax = if_else(result_n != 0, str_c(str_trim(min), ",", str_trim(max)), NA)
  )

#------------------------------------------------------------------------------
# Keep only the required variables - treatment and concatenated statistics
#------------------------------------------------------------------------------

stats03 <- stats02 %>%
  select(group, treatment, nnmiss, meanstd, q1q3, median, minmax)

#==============================================================================
# Restructure the statistics such that they appear as rows
#==============================================================================

stats04 <- stats03 %>%
  pivot_longer(
    cols = c(nnmiss, meanstd, median, q1q3, minmax),
    names_to = "name",
    values_to = "col1"
  )

#==============================================================================
# Create some supporting variables as per sorting and presentation requirements
#==============================================================================

stats05 <- stats04 %>%
  mutate(
    name = str_to_upper(name),
    intord = case_when(
      name == "NNMISS" ~ 1,
      name == "MEANSTD" ~ 2,
      name == "MEDIAN" ~ 3,
      name == "Q1Q3" ~ 4,
      name == "MINMAX" ~ 5
    ),
    statistic = case_when(
      name == "NNMISS" ~ "n (missing)",
      name == "MEANSTD" ~ "Mean (SD)",
      name == "MEDIAN" ~ "Median",
      name == "Q1Q3" ~ "Q1, Q3",
      name == "MINMAX" ~ "Min, Max"
    )
  )

#==============================================================================
# Restructure the data such that groups appear as columns
#==============================================================================

stats06 <- stats05 %>%
  mutate(group = str_c("grp", group)) %>%
  select(treatment, intord, statistic, group, col1) %>%
  pivot_wider(
    names_from = group,
    values_from = col1
  )

#==============================================================================
# Create final dataset for descriptive statistics
#==============================================================================

desc01 <- stats06 %>%
  mutate(section = 1) %>%
  select(section, treatment, intord, statistic, grp1, grp2, grp3)

#==============================================================================
# Section for inferential statistics
#==============================================================================

ttest_obj <- with(adeff02, t.test(aval, base, paired = TRUE, conf.level = 0.95))

inf01 <- tribble(
  ~section, ~intord, ~statistic,            ~grp3,
  2,         2,      "p-value [2]",         sprintf("%6.4f", ttest_obj$p.value),
  2,         1,      "95% of Mean Change[1]",  str_c(
    "[",
    sprintf("%7.2f", ttest_obj$conf.int[1]) %>% str_trim(),
    ", ",
    sprintf("%7.2f", ttest_obj$conf.int[2]) %>% str_trim(),
    "]"
  )
)

#==============================================================================
# Combine the descriptive and inferential statistics datasets
#==============================================================================

final <- bind_rows(
  desc01,
  inf01
) %>%
  arrange(section, intord)

final


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================