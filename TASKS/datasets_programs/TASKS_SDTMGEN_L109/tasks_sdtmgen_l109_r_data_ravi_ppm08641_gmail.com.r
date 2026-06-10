# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L109
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

cv02<-tribble(
~folderseq,~foldername,~usubjid,~studyid,~cvdtc,~cvtestcd,~cvorres,~cvdy,
101,"Screening","MYCSG-1001","MYCSG","","CVALL","",NA,
201,"Day 1","MYCSG-1001","MYCSG","2010-01-15","LVEF","67",1,
201,"Day 1","MYCSG-1001","MYCSG","2010-01-15","RVEF_E","60",1,
202,"Day 3","MYCSG-1001","MYCSG","2010-01-17","LVEF","65",3,
202,"Day 3","MYCSG-1001","MYCSG","2010-01-17","RVEF_E","",3,
999,"Unscheduled","MYCSG-1001","MYCSG","2010-01-23","LVEF","68",9,
999,"Unscheduled","MYCSG-1001","MYCSG","2010-01-23","RVEF_E","59",9,
999,"Unscheduled","MYCSG-1001","MYCSG","2010-01-24","LVEF","68",9,
999,"Unscheduled","MYCSG-1001","MYCSG","2010-01-24","RVEF_E","59",9,
)

sv<-tribble(
~studyid,~domain,~usubjid,~visitnum,~visit,~svstdtc,~svendtc,
"MYCSG","SV","MYCSG-1001",101,"SCREENING","2010-01-03","2010-01-08",
"MYCSG","SV","MYCSG-1001",201,"DAY 1","2010-01-15","2010-01-15",
"MYCSG","SV","MYCSG-1001",202,"DAY 3","2010-01-17","2010-01-18",
"MYCSG","SV","MYCSG-1001",203,"DAY 7","2010-01-20","2010-01-22",
"MYCSG","SV","MYCSG-1001",203.01,"DAY 7 Unscheduled 1","2010-01-23","2010-01-23",
"MYCSG","SV","MYCSG-1001",203.02,"DAY 7 Unscheduled 2","2010-01-24","2010-01-24",
"MYCSG","SV","MYCSG-1001",301,"FOLLOW-UP 1","2010-01-26","2010-01-26",
"MYCSG","SV","MYCSG-1001",302,"FOLLOW-UP 2","2010-01-30","2010-01-30",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================