# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1010_L151
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

#==============================================================================
# Programming for the task (explicit last_aval first, then imputation)
#==============================================================================

vs01 <- vs %>%
  arrange(usubjid, paramcd, avisitn) %>%
  mutate(orig_aval = aval)

vs02 <- vs01 %>%
  group_by(usubjid, paramcd) %>%
  rename(last_aval = aval) %>%
  fill(last_aval, .direction = "down") %>%
  mutate(
    aval = case_when(
      is.na(orig_aval) &
        dcsreas == "ADVERSE EVENT" &
        avisitn > dcaevisn &
        !is.na(dcaevisn) ~ base,
      
      is.na(orig_aval) ~ last_aval,
      
      TRUE ~ orig_aval
    ),
    dtype = case_when(
      is.na(orig_aval) &
        dcsreas == "ADVERSE EVENT" &
        avisitn > dcaevisn &
        !is.na(dcaevisn) ~ "MBOCF",
      
      is.na(orig_aval) ~ "LOCF",
      
      TRUE ~ " "
    )
  ) %>%
  ungroup()

output <- vs02 %>%
  select(-orig_aval, -last_aval)


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================