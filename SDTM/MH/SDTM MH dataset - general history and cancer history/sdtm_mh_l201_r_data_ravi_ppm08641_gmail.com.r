# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_MH_L201
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~usubjid,~rfstdtc,
"MYCSG","MYCSG-1001","2015-08-24",
"MYCSG","MYCSG-1002","2015-07-12",
"MYCSG","MYCSG-1003","2015-08-02",
)

rmh<-tribble(
~subject,~foldername,~folderseq,~recordposition,~mhcat,~mhdat_raw,~mhspid,~mhterm,~mhstdat_raw,~mhongo,~mhendat_raw,
1001,"Screening",1,1,"General Medical History","19 AUG 2015",1,"HEADACHE","UN UNK 2015","Yes","",
1001,"Screening",1,2,"General Medical History","19 AUG 2015",2,"DVT HEPATIC VEIN","UN FEB 2015","Yes","",
1001,"Screening",1,3,"General Medical History","19 AUG 2015",3,"DIABETES MELLITUS (TYPE 2)","UN UNK 2015","Yes","",
1001,"Screening",1,4,"General Medical History","19 AUG 2015",4,"RIGHT-SIDED ABDOMINAL PAIN","UN UNK 2015","Yes","",
1001,"Screening",1,5,"General Medical History","19 AUG 2015",5,"INTERMITTENT URINARY RETENTION","UN UNK 2015","No","24 AUG 2015",
1001,"Screening",1,6,"General Medical History","19 AUG 2015",6,"GASTROESOPHAGEAL REFLUX DISEASE","UN UNK 2015","Yes","",
1001,"Screening",1,7,"General Medical History","19 AUG 2015",7,"SENSORY NEUROPATHY","UN UNK 2015","Yes","",
1001,"Screening",1,8,"General Medical History","19 AUG 2015",8,"CONSTIPATION (OPIOID-INDUCED)","UN UNK 2015","Yes","",
1001,"Screening",1,9,"General Medical History","19 AUG 2015",9,"FATIGUE","UN UNK 2015","Yes","",
1001,"Screening",1,10,"General Medical History","19 AUG 2015",10,"NAUSEA","UN UNK 2015","Yes","",
1001,"Screening",1,11,"General Medical History","19 AUG 2015",11,"ANOREXIA","UN UNK 2015","Yes","",
1001,"Screening",1,12,"General Medical History","19 AUG 2015",12,"DIARRHEA","UN UNK 2015","Yes","",
1001,"Screening",1,13,"General Medical History","19 AUG 2015",13,"LOW ANTERIOR RESECTION OF RECTUM","UN APR 2015","No","UN APR 2015",
1001,"Screening",1,14,"General Medical History","19 AUG 2015",14,"ABDOMINAL PERINEAL RESECTION","UN DEC 2015","No","UN DEC 2015",
1001,"Screening",1,15,"General Medical History","19 AUG 2015",15,"ILEOSTOMY","UN DEC 2015","No","UN DEC 2015",
1001,"Screening",1,16,"General Medical History","19 AUG 2015",16,"VOMITING","UN UNK 2015","Yes","",
1001,"Screening",1,17,"General Medical History","19 AUG 2015",17,"DVT PORTAL VEIN","UN FEB 2015","Yes","",
1002,"Screening",1,1,"General Medical History","02 JUL 2015",1,"HYPERTENSION","UN UNK 2015","Yes","",
1002,"Screening",1,2,"General Medical History","02 JUL 2015",2,"ASTHMA","UN UNK 2015","Yes","",
1002,"Screening",1,3,"General Medical History","02 JUL 2015",3,"ALCOHOLIC CIRRHOSIS","UN UNK 2015","Yes","",
1002,"Screening",1,4,"General Medical History","02 JUL 2015",4,"GASTRIC VARICES","UN OCT 2015","Yes","",
1002,"Screening",1,5,"General Medical History","02 JUL 2015",5,"ESOPHAGEAL VARICES LIGATION","17 OCT 2015","No","17 OCT 2015",
1002,"Screening",1,6,"General Medical History","02 JUL 2015",6,"NON-CARDIAC CHEST PAIN","06 JAN 2015","No","27 JAN 2015",
1002,"Screening",1,7,"General Medical History","02 JUL 2015",7,"LEFT NECK PAIN","UN SEP 2015","Yes","",
1002,"Screening",1,8,"General Medical History","02 JUL 2015",8,"BACK PAIN","UN UNK 2015","Yes","",
1002,"Screening",1,9,"General Medical History","02 JUL 2015",9,"LEFT SHOULDER NUMBNESS","UN OCT 2015","Yes","",
1002,"Screening",1,10,"General Medical History","02 JUL 2015",10,"SENSORY NEUROPATHY (BOTH UPPER & LOWER EXTREMITIES)","UN SEP 2015","Yes","",
1002,"Screening",1,11,"General Medical History","02 JUL 2015",11,"ODYNOPHAGIA","UN SEP 2015","No","06 JAN 2015",
1002,"Screening",1,12,"General Medical History","02 JUL 2015",12,"SEASONAL ALLERGIES","UN UNK 2015","Yes","",
1002,"Screening",1,13,"General Medical History","02 JUL 2015",13,"DYSPHAGIA","UN SEP 2015","No","06 JAN 2015",
1002,"Screening",1,14,"General Medical History","02 JUL 2015",14,"CHRONIC KIDNEY DISEASE","UN UNK 2015","Yes","",
1002,"Screening",1,15,"General Medical History","02 JUL 2015",15,"HYPOTHYROIDISM","UN UNK 2015","Yes","",
1002,"Screening",1,16,"General Medical History","02 JUL 2015",16,"WEIGHT LOSS","UN UNK 2015","No","UN UNK 2015",
1002,"Screening",1,17,"General Medical History","02 JUL 2015",17,"BILATERAL EDEMA (LOWER LIMBS)","29 MAY 2015","Yes","",
1002,"Screening",1,18,"General Medical History","02 JUL 2015",18,"HYPOMAGNESEMIA","02 JUL 2015","Yes","",
1003,"Screening",1,1,"General Medical History","28 JUL 2015",1,"HYPERTENSION","UN UNK 2015","Yes","",
1003,"Screening",1,2,"General Medical History","28 JUL 2015",2,"HYPERCHOLESTEROLEMIA","08 MAY 2015","Yes","",
1003,"Screening",1,3,"General Medical History","28 JUL 2015",3,"BENIGN PROSTATIC HYPERPLASIA","UN UNK 2015","Yes","",
1003,"Screening",1,4,"General Medical History","28 JUL 2015",4,"LEFT NEPHRECTOMY","UN UNK 2015","No","UN UNK 2015",
1003,"Screening",1,5,"General Medical History","28 JUL 2015",5,"APPENDECTOMY","UN UNK 2015","No","UN UNK 2015",
1003,"Screening",1,6,"General Medical History","28 JUL 2015",6,"HYPERTHYROIDISM","08 NOV 2015","Yes","",
1003,"Screening",1,7,"General Medical History","28 JUL 2015",7,"CATARACTS (BOTH EYES)","UN UNK 2015","Yes","",
1003,"Screening",1,8,"General Medical History","28 JUL 2015",8,"RASH (MACULO-PAPULAR) -UPPER CHEST, NECK, NOSE & CHIN","UN MAY 2015","Yes","",
1003,"Screening",1,9,"General Medical History","28 JUL 2015",9,"PRURITUS","UN MAY 2015","Yes","",
1003,"Screening",1,10,"General Medical History","28 JUL 2015",10,"COUGH","12 APR 2015","Yes","",
1003,"Screening",1,11,"General Medical History","28 JUL 2015",11,"GASTROESOPHAGEAL REFLUX DISEASE","UN APR 2015","Yes","",
1003,"Screening",1,12,"General Medical History","28 JUL 2015",12,"NAUSEA","UN JUL 2015","Yes","",
1003,"Screening",1,13,"General Medical History","28 JUL 2015",13,"DYSPNEA","UN JUL 2015","Yes","",
1003,"Screening",1,14,"General Medical History","28 JUL 2015",14,"FATIGUE","UN JUL 2015","Yes","",
1003,"Screening",1,15,"General Medical History","28 JUL 2015",15,"MYALGIA","UN JUL 2015","No","04 AUG 2015",
)

rmhyn<-tribble(
~subject,~foldername,~folderseq,~recordposition,~mhyn,
1001,"Screening",1,0,"Yes",
1002,"Screening",1,0,"Yes",
1003,"Screening",1,0,"Yes",
)

rcxhist<-tribble(
~subject,~foldername,~folderseq,~recordposition,~cxtumtyp,~dxdtc,~cxinstag,~cxspec,~cxrecdat_raw,~cxrcstag,~cxstago,~cxmet1,~cxmet2,~cxmet3,~cxmet4,~cxmet5,~cxmeto,~cxmetos,~cxmet6,~cxtumos,
1001,"Screening",1,0,"Other","02FEB2010:00:00:00.000","Stage IIIB","","28 MAR 2015","Stage IV","",0,0,0,0,1,0,"",0,"RECTAL CANCER",
1002,"Screening",1,0,"Head and neck","20SEP2014:00:00:00.000","Stage IVC","","","","",0,0,1,0,0,0,"",1,"",
1003,"Screening",1,0,"Non-small cell lung cancer (NSCLC)","10JUL2013:00:00:00.000","","","","Stage IV","",0,0,0,1,0,0,"",0,"",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================