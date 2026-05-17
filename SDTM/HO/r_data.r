# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_HO_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~domain,~usubjid,~subjid,~rfstdtc,~rfendtc,~sex,
"MYCSG","DM","MYCSG-1001","1001","2010-01-15","2010-01-30","F",
"MYCSG","DM","MYCSG-2003","2003","2010-02-03","2010-02-10","F",
"MYCSG","DM","MYCSG-3010","3010","2010-01-15","2010-01-08","M",
)

se<-tribble(
~studyid,~domain,~usubjid,~seseq,~etcd,~element,~taetord,~epoch,~sestdtc,~seendtc,~seupdes,
"MYCSG","SE","MYCSG-1001",1,"SCRN","SCREENING",1,"SCREENING","2010-01-03","2010-01-15","",
"MYCSG","SE","MYCSG-1001",2,"ACT","ACTIVE",2,"TREATMENT","2010-01-15","2010-01-25","",
"MYCSG","SE","MYCSG-1001",3,"FU","FOLLOW-UP",3,"FOLLOW-UP","2010-01-25","2010-01-30","",
"MYCSG","SE","MYCSG-2003",1,"SCRN","SCREENING",1,"SCREENING","2010-01-27","2010-02-03","",
"MYCSG","SE","MYCSG-2003",2,"ACT","ACTIVE",2,"TREATMENT","2010-02-03","2010-02-10","",
)

hosp<-tribble(
~project,~subject,~folderseq,~foldername,~recordposition,~hostdat,~hoendat,~horeas,~hounit,
"MYCSG","1001",900,"Hospitalization",0,"20/JAN/2010","20/JAN/2010","Adverse Event","Emergency Room",
"MYCSG","1001",900,"Hospitalization",1,"20/JAN/2010","23/JAN/2010","Adverse Event","General Ward",
"MYCSG","2003",900,"Hospitalization",0,"10/FEB/2010","","Normal Clinical Practice","General Ward",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================