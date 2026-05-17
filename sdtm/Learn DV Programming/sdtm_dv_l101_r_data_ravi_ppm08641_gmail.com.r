# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_DV_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~usubjid,~rfstdtc,
"MYCSG","MYCSG-1001","2023-01-04",
"MYCSG","MYCSG-1002","2023-02-14",
"MYCSG","MYCSG-1003","2023-03-15",
"MYCSG","MYCSG-1004","2023-04-22",
"MYCSG","MYCSG-1005","2023-05-18",
"MYCSG","MYCSG-1006","2023-06-02",
)

protdev<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~term,~dvstdat_raw,~dvendat_raw,~major,~coded,
"MYCSG","1001",990,"Protocol Deviations",1,"TOOK ASPIRIN","10-JAN-2023","11-JAN-2023","Yes","PROHIBITED MEDS",
"MYCSG","1002",990,"Protocol Deviations",2,"Drug Metformin administered","20-FEB-2023","20-FEB-2023","No","EXCLUDED CONCOMITANT MEDICATIOn",
"MYCSG","1003",990,"Protocol Deviations",3,"CT SCAN not perfomed within visit window for visit 3","02-APR-2023","","No","STUDY PROCEDURES",
"MYCSG","1004",990,"Protocol Deviations",4,"The patient did not attend the Site for an ""early termination-End of study"" visit. Therefore, none of the protocol procedures for early termination were performed (physical examination, vital signs, laboratory assessments, and immunogenicity). This situation is considered a protocol deviation and the information needs to be submitted to LEC by site.","01-SEP-2023","","No","STUDY PROCEDURES",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================