# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L201
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

ec<-tribble(
~studyid,~usubjid,~ecseq,~ectrt,~ecdose,~ecstdtc,~ecendtc,
"MYCSG","MYCSG-1001",1,"MYCSG",12,"2010-06-15","2010-06-15",
"MYCSG","MYCSG-1001",2,"MYCSG",12,"2010-06-18","2010-06-18",
)

suppec<-tribble(
~studyid,~usubjid,~rdomain,~idvar,~idvarval,~qnam,~qlabel,~qval,~qorig,~qeval,
"MYCSG","MYCSG-1001","EC","ECSEQ","1","ECDOSINT","Dose interrupted","Y","CRF","",
"MYCSG","MYCSG-1001","EC","ECSEQ","1","ECINTRS","Reason for dose interruption","Local irritation","CRF","",
"MYCSG","MYCSG-1001","EC","ECSEQ","1","ECDOSRES","Dose resumed","Y","CRF","",
"MYCSG","MYCSG-1001","EC","ECSEQ","2","ECDOSINT","Dose interrupted","N","CRF","",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================