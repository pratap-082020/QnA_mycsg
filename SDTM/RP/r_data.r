# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RP_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~domain,~usubjid,~subjid,~rfstdtc,~sex,
"MYCSG","DM","MYCSG-1001","1001","2010-01-15","F",
"MYCSG","DM","MYCSG-2003","2003","2010-02-03","F",
"MYCSG","DM","MYCSG-3010","3010","2010-01-15","M",
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
"MYCSG","SV","MYCSG-2003",101,"SCREENING","2010-01-27","2010-02-02",
"MYCSG","SV","MYCSG-2003",201,"DAY 1","2010-02-03","2010-02-03",
"MYCSG","SV","MYCSG-3010",101,"SCREENING","2010-01-03","2010-01-08",
)

se<-tribble(
~studyid,~domain,~usubjid,~seseq,~etcd,~element,~taetord,~epoch,~sestdtc,~seendtc,~seupdes,
"MYCSG","SE","MYCSG-1001",1,"SCRN","SCREENING",1,"SCREENING","2010-01-03","2010-01-15","",
"MYCSG","SE","MYCSG-1001",2,"ACT","ACTIVE",2,"TREATMENT","2010-01-15","2010-01-25","",
"MYCSG","SE","MYCSG-1001",3,"FU","FOLLOW-UP",3,"FOLLOW-UP","2010-01-25","2010-01-30","",
"MYCSG","SE","MYCSG-2003",1,"SCRN","SCREENING",1,"SCREENING","2010-01-27","2010-02-03","",
"MYCSG","SE","MYCSG-2003",2,"ACT","ACTIVE",2,"TREATMENT","2010-02-03","2010-02-10","",
)

repmen<-tribble(
~project,~subject,~folderseq,~foldername,~recordposition,~repmen_yn,~repmendat,~childpot,~menostat,
"MYCSG","1001",101,"Screening",0,"No","","","",
"MYCSG","1001",101,"Day 1",1,"Yes","15/JAN/2010","Yes","Pre-Menopause",
"MYCSG","2003",101,"Screening",0,"Yes","29/JAN/2010","No","Menopause",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================