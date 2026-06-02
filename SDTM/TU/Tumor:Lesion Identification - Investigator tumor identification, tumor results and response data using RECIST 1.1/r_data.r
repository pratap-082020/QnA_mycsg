# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TU_LONCEX06
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
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tuloc,~tulat,~tumethod,~tudat,~tueval,~ldiam_trorres,~ldiam_trorresu,
"MYCSG",1001,101,"SCREEN",1,"","T01","SUPRACLAVICULAR LYMPH NODE","RIGHT","MRI","21 Dec 2022","INVESTIGATOR","17","mm",
"MYCSG",1001,101,"SCREEN",2,"","T02","CELIAC LYMPH NODE","","MRI","21 Dec 2022","INVESTIGATOR","16","mm",
"MYCSG",1001,101,"SCREEN",3,"","T03","THYROID GLAND","LEFT","MRI","21 Dec 2022","INVESTIGATOR","15","mm",
"MYCSG",1001,101,"SCREEN",4,"","T04","SKIN OF THE TRUNK","","MRI","21 Dec 2022","INVESTIGATOR","14","mm",
"MYCSG",1002,101,"SCREEN",5,"","T01","LUNG","LEFT","CT SCAN","31 Jan 2023","INVESTIGATOR","26","mm",
"MYCSG",1002,101,"SCREEN",6,"","T02","LUNG","RIGHT","CT SCAN","31 Jan 2023","INVESTIGATOR","35","mm",
)

tuntsc<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tuloc,~tulat,~tumethod,~tudat,~tueval,
"MYCSG",1001,101,"SCREEN",1,"","NT01","MEDIASTINAL LYMPH NODE","RIGHT","MRI","21 Dec 2022","INVESTIGATOR",
"MYCSG",1001,101,"SCREEN",2,"","NT02","CEREBELLUM","RIGHT","CT SCAN","21 Dec 2022","INVESTIGATOR",
)

tunw<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tupleyn,~tuloc,~tulat,~tumstate_trorres,~trineval,~trreasnd,~tumethod,~tudat,~tueval,
"MYCSG",1001,206,"WEEK 36",1,"","NEW01","No","LUNG, LEFT LOWER LOBE","","EQUIVOCAL","","","CT SCAN","30 Aug 2023","INVESTIGATOR",
"MYCSG",1001,207,"WEEK 44",2,"","NEW01","Yes","","","UNEQUIVOCAL","","","CT SCAN","25 Oct 2023","INVESTIGATOR",
"MYCSG",1001,207,"WEEK 44",3,"","NEW02","No","CEREBELLUM","LEFT","UNEQUIVOCAL","","","MRI","25 Oct 2023","INVESTIGATOR",
"MYCSG",1001,207,"WEEK 44",4,"","NEW03","No","FEMORAL LYMPH NODE","LEFT","UNEQUIVOCAL","","","MRI","25 Oct 2023","INVESTIGATOR",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================