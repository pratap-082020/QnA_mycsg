# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TU_LONCEX01
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

tutgsc<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tuloc,~tulat,~tumethod,~tudat,~tueval,~tuevalid,~ldiam_trorres,~ldiam_trorresu,
"MYCSG",1001,1,"SCREEN",1,1,"R-T01","OCCIPITAL LOBE","RIGHT","MRI","04/JAN/2023","INDEPENDENT ASSESSOR","RADIOLOGIST","10","mm",
"MYCSG",1001,1,"SCREEN",2,2,"R-T02","TEMPORAL LOBE","LEFT","MRI","04/JAN/2023","INDEPENDENT ASSESSOR","RADIOLOGIST","5","mm",
"MYCSG",1001,1,"SCREEN",3,3,"R-T03","OCCIPITAL LOBE","LEFT","MRI","04/JAN/2023","INDEPENDENT ASSESSOR","RADIOLOGIST","10","mm",
"MYCSG",1001,1,"SCREEN",4,4,"T01","OCCIPITAL LOBE","LEFT","MRI","04/JAN/2023","INVESTIGATOR","","10","mm",
"MYCSG",1001,1,"SCREEN",5,5,"T02","OCCIPITAL LOBE","RIGHT","MRI","04/JAN/2023","INVESTIGATOR","","10","mm",
"MYCSG",1001,1,"SCREEN",6,6,"T03","TEMPORAL LOBE","LEFT","MRI","04/JAN/2023","INVESTIGATOR","","5","mm",
)

tuntsc<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tuloc,~tulat,~tumethod,~tudat,~tueval,~tuevalid,
"MYCSG",1001,1,"SCREEN",1,1,"NT01","FRONTAL LOBE","RIGHT","MRI","04/JAN/2023","INVESTIGATOR","",
"MYCSG",1001,1,"SCREEN",2,2,"NT02","CEREBELLUM","LEFT","MRI","04/JAN/2023","INVESTIGATOR","",
"MYCSG",1001,1,"SCREEN",3,3,"R-NT01","PARIETAL LOBE","LEFT","MRI","04/JAN/2023","INDEPENDENT ASSESSOR","RADIOLOGIST",
"MYCSG",1001,1,"SCREEN",4,4,"R-NT02","FRONTAL LOBE","RIGHT","MRI","04/JAN/2023","INDEPENDENT ASSESSOR","RADIOLOGIST",
"MYCSG",1001,1,"SCREEN",5,5,"R-NT03","OCCIPITAL LOBE","RIGHT","MRI","04/JAN/2023","INDEPENDENT ASSESSOR","RADIOLOGIST",
)

tunw<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tuloc,~tulat,~tumethod,~tudat,~tueval,~tuevalid,~tumstate_trorres,
"MYCSG",1001,5,"Cycle 4 Week 4",2,1,"NEW01","FRONTAL LOBE","RIGHT","MRI","26/APR/2023","INVESTIGATOR","","PRESENT",
"MYCSG",1001,5,"Cycle 4 Week 4",3,2,"R-NEW01","FRONTAL LOBE","RIGHT","MRI","26/APR/2023","INDEPENDENT ASSESSOR","RADIOLOGIST","PRESENT",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================