# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L110a
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

se<-tribble(
~studyid,~domain,~usubjid,~seseq,~etcd,~element,~taetord,~epoch,~sestdtc,~seendtc,~seupdes,
"MYCSG","SE","MYCSG-1001",1,"SCRN","SCREENING",1,"SCREENING","2010-01-01","2010-03-01","",
"MYCSG","SE","MYCSG-1001",2,"ACT","ACTIVE",2,"TREATMENT","2010-03-01","2011-11-30","",
"MYCSG","SE","MYCSG-1001",3,"FU","FOLLOW-UP",3,"FOLLOW-UP","2011-11-30","2013-02-28","",
)

cm<-tribble(
~studyid,~usubjid,~cmstdtc,
"MYCSG","MYCSG-1001","2010-01-01",
"MYCSG","MYCSG-1001","2010-03-01",
"MYCSG","MYCSG-1001","2011-11-30",
"MYCSG","MYCSG-1001","2013-02-28",
"MYCSG","MYCSG-1001","2010-02",
"MYCSG","MYCSG-1001","2011-02",
"MYCSG","MYCSG-1001","2012",
"MYCSG","MYCSG-1001","2011",
"MYCSG","MYCSG-1001","2010",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================