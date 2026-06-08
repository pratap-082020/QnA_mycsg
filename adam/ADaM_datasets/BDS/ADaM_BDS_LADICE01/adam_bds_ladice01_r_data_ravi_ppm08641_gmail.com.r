# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_BDS_LADICE01
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

ds<-tribble(
~studyid,~usubjid,~dsterm,~dsdecod,~dscat,~dsscat,~dsstdtc,
"MYCSG-ADICE01","MYCSG-ADICE01-1001","ADVERSE EVENT","ADVERSE EVENT","DISPOSITION EVENT","STUDY TREATMENT","2018-12-21",
"MYCSG-ADICE01","MYCSG-ADICE01-1002","LACK OF EFFICACY","LACK OF EFFICACY","DISPOSITION EVENT","STUDY TREATMENT","2018-12-25",
)

sv<-tribble(
~studyid,~usubjid,~visitnum,~visit,~svstdtc,~svendtc,
"MYCSG-ADICE01","MYCSG-ADICE01-1001",12,"Week 12","2018-09-04","2018-09-04",
"MYCSG-ADICE01","MYCSG-ADICE01-1001",24,"Week 24","2018-11-21","2018-11-21",
"MYCSG-ADICE01","MYCSG-ADICE01-1001",36,"Week 36","2019-02-13","2019-02-13",
"MYCSG-ADICE01","MYCSG-ADICE01-1002",12,"Week 12","2018-09-17","2018-09-17",
"MYCSG-ADICE01","MYCSG-ADICE01-1002",24,"Week 24","2018-12-10","2018-12-10",
"MYCSG-ADICE01","MYCSG-ADICE01-1003",12,"Week 12","2018-09-21","2018-09-21",
"MYCSG-ADICE01","MYCSG-ADICE01-1003",24,"Week 24","2018-12-11","2018-12-11",
"MYCSG-ADICE01","MYCSG-ADICE01-1003",36,"Week 36","2019-03-05","2019-03-05",
"MYCSG-ADICE01","MYCSG-ADICE01-1004",12,"Week 12","2018-12-19","2018-12-19",
)

adsl<-tribble(
~studyid,~usubjid,~trtsdt,~trtedt,~eosdt,
"MYCSG-ADICE01","MYCSG-ADICE01-1001",21342,21539,21595,
"MYCSG-ADICE01","MYCSG-ADICE01-1002",21362,21543,21543,
"MYCSG-ADICE01","MYCSG-ADICE01-1003",21363,21613,21613,
"MYCSG-ADICE01","MYCSG-ADICE01-1004",21449,21537,21537,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================