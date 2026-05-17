# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RS_LONCEX06
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

rs_rec<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~rsdat,~trgresp_rsorres,~ntrgresp_rsorres,~ovrlresp_rsorres,~rseval,
"MYCSG",1001,202,"WEEK 6",1,"11 Feb 2023","SD","Non-CR/Non-PD","SD","INVESTIGATOR",
"MYCSG",1001,203,"WEEK 12",2,"25 Mar 2023","SD","Non-CR/Non-PD","SD","INVESTIGATOR",
"MYCSG",1001,204,"WEEK 20",3,"17 May 2023","PR","Non-CR/Non-PD","PR","INVESTIGATOR",
"MYCSG",1001,205,"WEEK 28",4,"12 Jul 2023","PR","Non-CR/Non-PD","PR","INVESTIGATOR",
"MYCSG",1001,206,"WEEK 36",5,"30 Aug 2023","CR","CR","CR","INVESTIGATOR",
"MYCSG",1001,207,"WEEK 44",6,"25 Oct 2023","PD","CR","PD","INVESTIGATOR",
"MYCSG",1002,202,"WEEK 6",7,"24 Mar 2023","SD","","SD","INVESTIGATOR",
"MYCSG",1002,203,"WEEK 12",8,"05 May 2023","PR","","PR","INVESTIGATOR",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================