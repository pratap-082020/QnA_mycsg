# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_IS_LADAB
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

isada<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~isdat_raw,~istiter,
"MYCSG",1001,101,"Screening",1,"07 JAN 2023","124",
"MYCSG",1001,201,"Day 1",2,"21 JAN 2023","10",
"MYCSG",1001,202,"Month 1",3,"20 FEB 2023","1164",
"MYCSG",1001,203,"Month 2",4,"22 MAR 2023","550",
"MYCSG",1001,204,"Month 3",5,"21 APR 2023","10",
"MYCSG",1001,205,"Month 4",6,"21 MAY 2023","3273",
"MYCSG",1001,301,"Follow-up 1",7,"20 JUL 2023","3126",
"MYCSG",1001,302,"Follow-up 2",8,"18 SEP 2023","2710",
"MYCSG",1002,101,"Screening",9,"31 JAN 2023","2596",
"MYCSG",1002,201,"Day 1",10,"14 FEB 2023","10",
"MYCSG",1002,202,"Month 1",11,"16 MAR 2023","3234",
"MYCSG",1002,203,"Month 2",12,"15 APR 2023","10",
"MYCSG",1002,204,"Month 3",13,"15 MAY 2023","2355",
"MYCSG",1002,205,"Month 4",14,"14 JUN 2023","3441",
"MYCSG",1002,301,"Follow-up 1",15,"13 AUG 2023","2967",
"MYCSG",1002,302,"Follow-up 2",16,"12 OCT 2023","2953",
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