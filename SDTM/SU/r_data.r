# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_SU_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~usubjid,~rfstdtc,~rfxstdtc,
"MYCSG","MYCSG-1001","2023-01-04","2023-01-04",
"MYCSG","MYCSG-1002","2023-02-14","2023-02-14",
"MYCSG","MYCSG-1003","2023-03-15","2023-03-15",
"MYCSG","MYCSG-1004","2023-04-22","2023-04-22",
"MYCSG","MYCSG-1005","2023-05-18","2023-05-18",
"MYCSG","MYCSG-1006","2023-06-02","2023-06-02",
)

sualc<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~suncf,~sustdat,~suendat,~sudstxt_beer,~sudosfrq_beer,~sudstxt_wine,~sudosfrq_wine,~sudstxt_spirits,~sudosfrq_spirits,
"MYCSG","1001",990,"Substance Use",1,"Never","","","","","","","","",
"MYCSG","1002",990,"Substance Use",2,"Current","UN-UN-1984","","2","QM-Every month","1","QD-Daily","1","QM-Every month",
"MYCSG","1003",990,"Substance Use",3,"Former","UN-UN-1975","18-JUN-2010","","","","","1","QD-Daily",
"MYCSG","1004",990,"Substance Use",4,"Current","UN-UN-2020","","7","QW-Every week","","","","",
"MYCSG","1005",990,"Substance Use",5,"Never","","","","","","","","",
"MYCSG","1006",990,"Substance Use",6,"Never","","","","","","","","",
)

sucaf<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~suncf,~sustdat,~suendat,~sudstxt_coffee,~sudosfrq_coffee,~sudstxt_soda,~sudosfrq_soda,~sudstxt_tea,~sudosfrq_tea,
"MYCSG","1001",990,"Substance Use",1,"Current","UN-UN-1980","","2","QD-Daily","","","","",
"MYCSG","1002",990,"Substance Use",2,"Current","UN-UN-1980","","2","QD-Daily","","","","",
"MYCSG","1003",990,"Substance Use",3,"Never","","","","","","","","",
"MYCSG","1004",990,"Substance Use",4,"Former","01-JAN-2020","31-DEC-2020","","","","","1","QD-Daily",
"MYCSG","1005",990,"Substance Use",5,"Never","","","","","","","","",
"MYCSG","1006",990,"Substance Use",6,"Never","","","","","","","","",
)

sutob<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~suncf,~sustdat,~suendat,~sudstxt_cigarettes,~sudosfrq_cigarettes,~sudstxt_cigars,~sudosfrq_cigars,~sudstxt_pipefuls,~sudosfrq_pipefuls,
"MYCSG","1001",990,"Substance Use",1,"Never","","","","","","","","",
"MYCSG","1002",990,"Substance Use",2,"Never","","","","","","","","",
"MYCSG","1003",990,"Substance Use",3,"Never","","","","","","","","",
"MYCSG","1004",990,"Substance Use",4,"Never","","","","","","","","",
"MYCSG","1005",990,"Substance Use",5,"Fomer","UN-UN-2010","UN-UN-2010","","","1","QD-Daily","1","QW-Every week",
"MYCSG","1006",990,"Substance Use",6,"Current","UN-UN-2010","","3","QD-Daily","","","","",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================