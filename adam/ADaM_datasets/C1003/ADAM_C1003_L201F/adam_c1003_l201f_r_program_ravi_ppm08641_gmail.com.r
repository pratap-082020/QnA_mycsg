# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADAM_C1003_L201F
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================


#==============================================================================
# program for the task
#==============================================================================

adcm04 <- adcm03 %>%
  mutate(
    
    #------------------------------------------------------------------------------
    # prefl
    #------------------------------------------------------------------------------
    prefl = case_when(
      !is.na(astdtm) & !is.na(trtsdtm) & astdtm < trtsdtm ~ "Y",
      !is.na(astdt)  & !is.na(trtsdt)  & astdt  < trtsdt  ~ "Y",
      !is.na(trtsdt) &  is.na(astdt)                    ~ "Y",
      TRUE ~ ""
    ),
    
    #------------------------------------------------------------------------------
    # ontrtfl
    #------------------------------------------------------------------------------
    ontrtfl = case_when(
      !is.na(astdtm) & !is.na(trtsdtm) & !is.na(trtedtm) &
        astdtm < trtsdtm & is.na(aendt) ~ "Y",
      
      !is.na(astdtm) & !is.na(trtsdtm) & !is.na(trtedtm) &
        astdtm < trtsdtm & !is.na(aendtm) & aendtm >= trtsdtm ~ "Y",
      
      !is.na(astdtm) & !is.na(trtsdtm) & !is.na(trtedtm) &
        astdtm < trtsdtm & !is.na(aendtm) & aendtm < trtsdtm ~ "",
      
      !is.na(astdtm) & !is.na(trtsdtm) & !is.na(trtedtm) &
        astdtm >= trtsdtm & astdtm <= trtedtm ~ "Y",
      
      !is.na(astdtm) & !is.na(trtsdtm) & !is.na(trtedtm) &
        astdtm >= trtsdtm & astdtm > trtedtm ~ "",
      
      !is.na(astdt) & !is.na(trtsdt) & !is.na(trtedt) &
        astdt < trtsdt & is.na(aendt) ~ "Y",
      
      !is.na(astdt) & !is.na(trtsdt) & !is.na(trtedt) &
        astdt < trtsdt & !is.na(aendt) & aendt >= trtsdt ~ "Y",
      
      !is.na(astdt) & !is.na(trtsdt) & !is.na(trtedt) &
        astdt >= trtsdt & astdt <= trtedt ~ "Y",
      
      !is.na(trtsdt) & is.na(astdt) & is.na(aendt) ~ "Y",
      
      !is.na(trtsdt) & is.na(astdt) & !is.na(aendt) & aendt >= trtsdt ~ "Y",
      
      TRUE ~ ""
    ),
    
    #------------------------------------------------------------------------------
    # quick check flags vs expected
    #------------------------------------------------------------------------------
    prefl_ok  = coalesce(prefl, "")    == coalesce(exp_prefl, ""),
    ontrt_ok = coalesce(ontrtfl, "") == coalesce(exp_ontrtfl, "")
  )


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================