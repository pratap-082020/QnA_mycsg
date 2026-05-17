# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_QS_LEQ5D3L
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

eq5d3l<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~qsdat_raw,~eq5d3l_1,~eq5d3l_2,~eq5d3l_3,~eq5d3l_4,~eq5d3l_5,~eq5d3l_6,
"MYCSG",1001,101,"Screening",1,"07 JAN 2023","1-I have no problems in walking about","2-I have some problems washing or dressing myself","3-I am unable to perform my usual activities","3-I have extreme pain or discomfort","2-I am moderately anxious or depressed","62",
"MYCSG",1001,201,"Day 1",2,"21 JAN 2023","3-I am confined to bed","2-I have some problems washing or dressing myself","1-I have no problems with performing my usual activities","1-I have no pain or discomfort","3-I am extremely anxious or depressed","57",
"MYCSG",1001,205,"Month 4",3,"21 MAY 2023","2-I have some problems in walking about","1-I have no problems with self-care","3-I am unable to perform my usual activities","3-I have extreme pain or discomfort","2-I am moderately anxious or depressed","71",
"MYCSG",1002,101,"Screening",4,"31 JAN 2023","1-I have no problems in walking about","1-I have no problems with self-care","1-I have no problems with performing my usual activities","2-I have moderate pain or discomfort","2-I am moderately anxious or depressed","66",
"MYCSG",1002,201,"Day 1",5,"14 FEB 2023","3-I am confined to bed","3-I am unable to wash or dress myself","1-I have no problems with performing my usual activities","2-I have moderate pain or discomfort","2-I am moderately anxious or depressed","55",
"MYCSG",1002,205,"Month 4",6,"14 JUN 2023","3-I am confined to bed","2-I have some problems washing or dressing myself","3-I am unable to perform my usual activities","1-I have no pain or discomfort","2-I am moderately anxious or depressed","93",
)

dm<-tribble(
~studyid,~usubjid,~rfstdtc,~rfxstdtc,
"MYCSG","MYCSG-1001","2023-01-21","2023-01-21",
"MYCSG","MYCSG-1002","2023-02-14","2023-02-14",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================