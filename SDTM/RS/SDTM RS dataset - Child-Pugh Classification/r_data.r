# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RS_LCHPU
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

chpu<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~rsdat_raw,~chpu_1,~chpu_2,~chpu_3,~chpu_4,~chpu_5,
"MYCSG",1001,101,"Screening",1,"07 JAN 2023","1:None","2:Slight","3:>3","3:<2.8","2:4 to 6",
"MYCSG",1002,101,"Screening",2,"31 JAN 2023","3:3 or 4","2:Slight","1:<2","1:>3.5","3:>6",
"MYCSG",1003,101,"Screening",3,"01 MAR 2023","2:1 or 2","1:Absent","3:>3","3:<2.8","2:4 to 6",
"MYCSG",1004,101,"Screening",4,"08 APR 2023","1:None","1:Absent","1:<2","2:2.8 to 3.5","2:4 to 6",
"MYCSG",1005,101,"Screening",5,"04 MAY 2023","3:3 or 4","3:Moderate","1:<2","2:2.8 to 3.5","2:4 to 6",
"MYCSG",1006,101,"Screening",6,"19 MAY 2023","3:3 or 4","2:Slight","3:>3","1:>3.5","2:4 to 6",
)

dm<-tribble(
~studyid,~usubjid,~rfstdtc,~rfxstdtc,
"MYCSG","MYCSG-1001","2023-01-21","2023-01-21",
"MYCSG","MYCSG-1002","2023-02-14","2023-02-14",
"MYCSG","MYCSG-1003","2023-03-15","2023-03-15",
"MYCSG","MYCSG-1004","2023-04-22","2023-04-22",
"MYCSG","MYCSG-1005","2023-05-18","2023-05-18",
"MYCSG","MYCSG-1006","2023-06-02","2023-06-02",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================