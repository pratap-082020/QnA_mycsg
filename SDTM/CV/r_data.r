# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_CV_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~domain,~usubjid,~subjid,~rfstdtc,
"MYCSG","DM","MYCSG-1001",1001,"2010-01-15",
)

sv<-tribble(
~studyid,~domain,~usubjid,~visitnum,~visit,~svstdtc,~svendtc,
"MYCSG","SV","MYCSG-1001",101,"SCREENING","2010-01-03","2010-01-08",
"MYCSG","SV","MYCSG-1001",201,"DAY 1","2010-01-15","2010-01-15",
"MYCSG","SV","MYCSG-1001",202,"DAY 3","2010-01-17","2010-01-18",
"MYCSG","SV","MYCSG-1001",203,"DAY 7","2010-01-20","2010-01-22",
"MYCSG","SV","MYCSG-1001",203.01,"DAY 7 Unscheduled 1","2010-01-23","2010-01-23",
"MYCSG","SV","MYCSG-1001",301,"FOLLOW-UP 1","2010-01-26","2010-01-26",
"MYCSG","SV","MYCSG-1001",302,"FOLLOW-UP 2","2010-01-30","2010-01-30",
)

se<-tribble(
~studyid,~domain,~usubjid,~seseq,~etcd,~element,~taetord,~epoch,~sestdtc,~seendtc,~seupdes,
"MYCSG","SE","MYCSG-1001",1,"SCRN","SCREENING",1,"SCREENING","2010-01-03","2010-01-15","",
"MYCSG","SE","MYCSG-1001",2,"ACT","ACTIVE",2,"TREATMENT","2010-01-15","2010-01-25","",
"MYCSG","SE","MYCSG-1001",3,"FU","FOLLOW-UP",3,"FOLLOW-UP","2010-01-25","2010-01-30","",
)

echo<-tribble(
~project,~subject,~folderseq,~foldername,~recordposition,~echo_yn,~echodat,~lvef,~rvef,
"MYCSG","1001",101,"Screening",0,"No","","","",
"MYCSG","1001",201,"Day 1",0,"Yes","15/JAN/2010","67","60",
"MYCSG","1001",203,"Day 3",0,"Yes","17/JAN/2010","65","",
"MYCSG","1001",999,"Unscheduled",0,"Yes","23/JAN/2010","68","59",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================