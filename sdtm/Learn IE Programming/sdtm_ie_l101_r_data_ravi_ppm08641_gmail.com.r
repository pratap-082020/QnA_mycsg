# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_IE_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~domain,~usubjid,~subjid,~rfstdtc,~rfendtc,~sex,
"MYCSG","DM","MYCSG-1001","1001","2010-01-15","2010-01-30","F",
"MYCSG","DM","MYCSG-2003","2003","2010-02-03","2010-02-10","F",
"MYCSG","DM","MYCSG-3010","3010","2010-03-06","2010-03-08","M",
"MYCSG","DM","MYCSG-4001","4001","","2010-06-10","M",
)

se<-tribble(
~studyid,~domain,~usubjid,~seseq,~etcd,~element,~taetord,~epoch,~sestdtc,~seendtc,~seupdes,
"MYCSG","SE","MYCSG-1001",1,"SCRN","SCREENING",1,"SCREENING","2010-01-03","2010-01-15","",
"MYCSG","SE","MYCSG-1001",2,"ACT","ACTIVE",2,"TREATMENT","2010-01-15","2010-01-25","",
"MYCSG","SE","MYCSG-1001",3,"FU","FOLLOW-UP",3,"FOLLOW-UP","2010-01-25","2010-01-30","",
"MYCSG","SE","MYCSG-2003",1,"SCRN","SCREENING",1,"SCREENING","2010-01-27","2010-02-03","",
"MYCSG","SE","MYCSG-2003",2,"ACT","ACTIVE",2,"TREATMENT","2010-02-03","2010-02-10","",
"MYCSG","SE","MYCSG-3010",1,"SCRN","SCREENING",1,"SCREENING","2010-03-06","2010-03-08","",
"MYCSG","SE","MYCSG-4001",1,"SCRN","SCREENING",1,"SCREENING","2010-06-08","2010-06-11","",
)

eligcrit<-tribble(
~project,~subject,~folderseq,~foldername,~recordposition,~iedat,~icrit01,~icrit02,~ecrit01,
"MYCSG","4001",1,"Screening",0,"10/JUN/2010","Yes","No","Yes",
"MYCSG","2003",1,"Screening",0,"01/FEB/2010","No","Yes","No",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================