# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L110
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

se<-tribble(
~studyid,~domain,~usubjid,~seseq,~etcd,~element,~taetord,~epoch,~sestdtc,~seendtc,~seupdes,
"MYCSG","SE","MYCSG-1001",1,"SCRN","SCREENING",1,"SCREENING","2010-01-03","2010-01-15","",
"MYCSG","SE","MYCSG-1001",2,"ACT","ACTIVE",2,"TREATMENT","2010-01-15","2010-01-25","",
"MYCSG","SE","MYCSG-1001",3,"FU","FOLLOW-UP",3,"FOLLOW-UP","2010-01-25","2010-01-30","",
)

cv<-tribble(
~studyid,~usubjid,~cvtestcd,~cvtest,~cvorres,~visitnum,~visit,~cvdtc,~cvdy,
"MYCSG","MYCSG-1001","LVEF","Left Ventricular Ejection Fraction","68",101.01,"SCREENING Unscheduled 1","2010-01-13",-2,
"MYCSG","MYCSG-1001","LVEF","Left Ventricular Ejection Fraction","67",201,"DAY 1","2010-01-15",1,
"MYCSG","MYCSG-1001","LVEF","Left Ventricular Ejection Fraction","65",203,"DAY 3","2010-01-17",3,
"MYCSG","MYCSG-1001","LVEF","Left Ventricular Ejection Fraction","68",203.01,"DAY 7 Unscheduled 1","2010-01-23",9,
"MYCSG","MYCSG-1001","LVEF","Left Ventricular Ejection Fraction","68",301,"Follow-up","2010-01-26",12,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================