# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1001_L106
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~usubjid,
"CSG-1001",
"CSG-1002",
"CSG-1003",
"CSG-1004",
"CSG-1005",
)

ds<-tribble(
~usubjid,~dsdecod,~dscat,~dsscat,~dsstdtc,
"CSG-1001","COMPLETED","DISPOSITION EVENT","END OF TREATMENT","2010-01-15",
"CSG-1001","COMPLETED","DISPOSITION EVENT","END OF STUDY","2010-02-15",
"CSG-1002","COMPLETED","DISPOSITION EVENT","END OF TREATMENT","2010-01-15",
"CSG-1002","LOST TO FOLLOW-UP","DISPOSITION EVENT","END OF STUDY","2010-02-15",
"CSG-1003","ADVERSE EVENT","DISPOSITION EVENT","END OF TREATMENT","2010-01-15",
"CSG-1003","ADVERSE EVENT","DISPOSITION EVENT","END OF STUDY","2010-01-15",
"CSG-1004","COMPLETED","DISPOSITION EVENT","END OF TREATMENT","2010-01-15",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================