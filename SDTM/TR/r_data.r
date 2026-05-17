# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_TR_LONCEX06
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

tutg<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tuchange,~tumethod,~tudat,~tueval,~ldiam_trorres,~ldiam_trorresu,~trtoosm,~trineval,~trreasnd,
"MYCSG",1001,202,"WEEK 6",1,"","T01","","MRI","11 Feb 2023","INVESTIGATOR","12","mm","","","",
"MYCSG",1001,202,"WEEK 6",2,"","T02","","MRI","11 Feb 2023","INVESTIGATOR","12","mm","","","",
"MYCSG",1001,202,"WEEK 6",3,"","T03","","MRI","11 Feb 2023","INVESTIGATOR","14","mm","","","",
"MYCSG",1001,202,"WEEK 6",4,"","T04","","MRI","11 Feb 2023","INVESTIGATOR","14","mm","","","",
"MYCSG",1001,203,"WEEK 12",5,"","T01","","MRI","25 Mar 2023","INVESTIGATOR","12","mm","","","",
"MYCSG",1001,203,"WEEK 12",6,"","T02","","MRI","25 Mar 2023","INVESTIGATOR","12","mm","","","",
"MYCSG",1001,203,"WEEK 12",7,"","T03","","MRI","25 Mar 2023","INVESTIGATOR","15","mm","","","",
"MYCSG",1001,203,"WEEK 12",8,"","T04","","MRI","25 Mar 2023","INVESTIGATOR","8","mm","","","",
"MYCSG",1001,204,"WEEK 20",9,"","T01","","MRI","17 May 2023","INVESTIGATOR","9","mm","","","",
"MYCSG",1001,204,"WEEK 20",10,"","T02","","MRI","17 May 2023","INVESTIGATOR","12","mm","","","",
"MYCSG",1001,204,"WEEK 20",11,"","T03","","MRI","17 May 2023","INVESTIGATOR","11","mm","","","",
"MYCSG",1001,204,"WEEK 20",12,"","T04","","MRI","17 May 2023","INVESTIGATOR","","","Y","","",
"MYCSG",1001,205,"WEEK 28",13,"","T01","","MRI","12 Jul 2023","INVESTIGATOR","9","mm","","","",
"MYCSG",1001,205,"WEEK 28",14,"","T02","","MRI","12 Jul 2023","INVESTIGATOR","8","mm","","","",
"MYCSG",1001,205,"WEEK 28",15,"","T03","","MRI","12 Jul 2023","INVESTIGATOR","6","mm","","","",
"MYCSG",1001,205,"WEEK 28",16,"","T04","","MRI","12 Jul 2023","INVESTIGATOR","0","mm","","","",
"MYCSG",1001,206,"WEEK 36",17,"","T01","","MRI","30 Aug 2023","INVESTIGATOR","8","mm","","","",
"MYCSG",1001,206,"WEEK 36",18,"","T02","","MRI","30 Aug 2023","INVESTIGATOR","9","mm","","","",
"MYCSG",1001,206,"WEEK 36",19,"","T03","","MRI","30 Aug 2023","INVESTIGATOR","0","mm","","","",
"MYCSG",1001,206,"WEEK 36",20,"","T04","","MRI","30 Aug 2023","INVESTIGATOR","0","mm","","","",
"MYCSG",1001,207,"WEEK 44",21,"","T01","","MRI","25 Oct 2023","INVESTIGATOR","12","mm","","","",
"MYCSG",1001,207,"WEEK 44",22,"","T02","","MRI","25 Oct 2023","INVESTIGATOR","9","mm","","","",
"MYCSG",1001,207,"WEEK 44",23,"","T03","","MRI","25 Oct 2023","INVESTIGATOR","0","mm","","","",
"MYCSG",1001,207,"WEEK 44",24,"","T04","","MRI","25 Oct 2023","INVESTIGATOR","0","mm","","","",
"MYCSG",1002,202,"WEEK 6",26,"","T01","","CT SCAN","24 Mar 2023","INVESTIGATOR","31","mm","","","",
"MYCSG",1002,202,"WEEK 6",27,"","T02","","CT SCAN","24 Mar 2023","INVESTIGATOR","38","mm","","","",
"MYCSG",1002,203,"WEEK 12",28,"","T01","","CT SCAN","05 May 2023","INVESTIGATOR","10","mm","","","",
"MYCSG",1002,203,"WEEK 12",29,"","T02","","CT SCAN","05 May 2023","INVESTIGATOR","15","mm","","","",
"MYCSG",1002,204,"WEEK 20",30,"","T01","","CT SCAN","27 Jun 2023","INVESTIGATOR","0","mm","","","",
"MYCSG",1002,204,"WEEK 20",31,"","T02","","CT SCAN","27 Jun 2023","INVESTIGATOR","0","mm","","","",
)

tunt<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~tuspid,~tulnkid,~tuchange,~tumethod,~tudat,~tueval,~tumstate_trorres,~trineval,~trreasnd,
"MYCSG",1001,202,"WEEK 6",1,"","NT01","","CT SCAN","11 Feb 2023","INVESTIGATOR","PRESENT","","",
"MYCSG",1001,202,"WEEK 6",2,"","NT02","","MRI","11 Feb 2023","INVESTIGATOR","","NOT DONE","SCAN NOT PERFORMED",
"MYCSG",1001,203,"WEEK 12",3,"","NT01","","CT SCAN","25 Mar 2023","INVESTIGATOR","ABSENT","","",
"MYCSG",1001,203,"WEEK 12",4,"","NT02","","MRI","25 Mar 2023","INVESTIGATOR","","NOT DONE","SCAN NOT PERFORMED",
"MYCSG",1001,204,"WEEK 20",5,"","NT01","","CT SCAN","17 May 2023","INVESTIGATOR","ABSENT","","",
"MYCSG",1001,204,"WEEK 20",6,"","NT02","","MRI","17 May 2023","INVESTIGATOR","PRESENT","","",
"MYCSG",1001,205,"WEEK 28",7,"","NT01","","CT SCAN","12 Jul 2023","INVESTIGATOR","ABSENT","","",
"MYCSG",1001,205,"WEEK 28",8,"","NT02","","MRI","12 Jul 2023","INVESTIGATOR","","NOT DONE","SCAN NOT PERFORMED",
"MYCSG",1001,206,"WEEK 36",9,"","NT01","","CT SCAN","30 Aug 2023","INVESTIGATOR","ABSENT","","",
"MYCSG",1001,206,"WEEK 36",10,"","NT02","","MRI","30 Aug 2023","INVESTIGATOR","ABSENT","","",
"MYCSG",1001,207,"WEEK 44",11,"","NT01","","CT SCAN","25 Oct 2023","INVESTIGATOR","ABSENT","","",
"MYCSG",1001,207,"WEEK 44",12,"","NT02","","MRI","25 Oct 2023","INVESTIGATOR","PRESENT","","",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================