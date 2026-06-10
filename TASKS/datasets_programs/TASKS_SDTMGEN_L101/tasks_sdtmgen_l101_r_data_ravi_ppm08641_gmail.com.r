# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~usubjid,~rfstdtc,
"MYCSG-1001","2010-01-15",
"MYCSG-1002","2010-02-01",
"MYCSG-1003","",
)

vs<-tribble(
~usubjid,~vstestcd,~vsorres,~vsstat,~vsdtc,
"MYCSG-1001","SYSBP","130","","2010-01-10",
"MYCSG-1001","SYSBP","125","","2010-01-11",
"MYCSG-1001","SYSBP","","NOT DONE","2010-01-14",
"MYCSG-1001","SYSBP","135","","2010-01-15",
"MYCSG-1001","SYSBP","130","","2010-01-16",
"MYCSG-1001","SYSBP","130","","2010-01-18",
"MYCSG-1002","SYSBP","130","","2010-01-30",
"MYCSG-1002","SYSBP","130","","2010-02-01",
"MYCSG-1003","SYSBP","130","","2010-03-02",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================