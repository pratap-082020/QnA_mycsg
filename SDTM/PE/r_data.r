# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_PE_L101
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

physexam<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~pedat_raw,~bodsys,~result,~abnsp,~clsig,
"MYCSG",1001,201,"DAY 1",1,"04-JAN-2023","Cardiovascular","Normal","","",
"MYCSG",1001,201,"DAY 1",2,"04-JAN-2023","Ear/Nose/Throat","Normal","","",
"MYCSG",1001,201,"DAY 1",3,"04-JAN-2023","Gastrointestinal","Normal","","",
"MYCSG",1001,201,"DAY 1",4,"04-JAN-2023","Respiratory","Normal","","",
"MYCSG",1001,201,"DAY 1",5,"04-JAN-2023","Central Nervous System","Normal","","",
"MYCSG",1001,201,"DAY 1",6,"04-JAN-2023","Musculoskelatal","Abnormal","Mild lower back pain","No",
"MYCSG",1001,202,"WEEK 6",7,"11-FEB-2023","Cardiovascular","Normal","","",
"MYCSG",1001,202,"WEEK 6",8,"11-FEB-2023","Ear/Nose/Throat","Normal","","",
"MYCSG",1001,202,"WEEK 6",9,"11-FEB-2023","Gastrointestinal","Abnormal","Diarrhea","Yes",
"MYCSG",1001,202,"WEEK 6",10,"11-FEB-2023","Respiratory","Normal","","",
"MYCSG",1001,202,"WEEK 6",11,"11-FEB-2023","Central Nervous System","Normal","","",
"MYCSG",1001,202,"WEEK 6",12,"11-FEB-2023","Musculoskelatal","Normal","","",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================