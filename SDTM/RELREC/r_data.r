# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_RELREC_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

adverse<-tribble(
~study,~subject,~aespid,~aeterm,
"MYCSG","1001","1","Pneumonia",
"MYCSG","1001","2","Headache",
"MYCSG","1002","1","Sepsis",
"MYCSG","1002","2","Hemoglobin decreased",
)

eos<-tribble(
~study,~subject,~dsspid,~dsterm,~dsaeno,
"MYCSG","1001","3001","Completed","",
"MYCSG","1002","3001","Adverse Event","1",
)

conmeds<-tribble(
~study,~subject,~cmspid,~cmtrt,~cmaeno,
"MYCSG","1001","1","Azithromycin","1",
"MYCSG","1001","2","Benadryl","1",
"MYCSG","1002","1","Omeprazole","",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================