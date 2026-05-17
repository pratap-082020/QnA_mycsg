# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RE_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~usubjid,~rfstdtc,~rfxstdtc,
"MYCSG","MYCSG-1001","2023-01-21","2023-01-21",
"MYCSG","MYCSG-1002","2023-02-14","2023-02-14",
"","","","",
"","","","",
"","","","",
"","","","",
)

resp<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~redat_raw,~fev1,~fvc,~fev1pp,~fvcpp,
"MYCSG",1001,101,"Screening",1,"07-JAN-2023","2.73","3.91","81","101.3",
"MYCSG",1001,201,"Day 1",2,"21-JAN-2023","2.7","3.8","80.1","98.4",
"MYCSG",1001,202,"Month 1",3,"20-FEB-2023","3.37","3.36","100","100",
"MYCSG",1001,204,"Month 3",4,"21-APR-2023","3.37","3.36","100","100",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================