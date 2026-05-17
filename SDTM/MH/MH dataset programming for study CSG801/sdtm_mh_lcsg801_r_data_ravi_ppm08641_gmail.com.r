# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_MH_LCSG801
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

mh801_1<-tribble(
~study,~pt,~repeatnum,~mhterm,~mhdat,~mhstdat,
"CSG801","101-001",1,"Type 2 Diabetes","20150103","20130314",
"CSG801","101-002",1,"Type 1 Diabetes","20150208","201001",
"CSG801","201-001",1,"Type 2 Diabetes","20141214","20050602",
)

mh801_2<-tribble(
~study,~pt,~repeatnum,~mhterm,~mhdat,~mhstdat,~mhoccur,
"CSG801","101-001",1,"DIABETIC RETINOPATHY","20150103","","N",
"CSG801","101-001",1,"NEUROPATHY","20150103","","N",
"CSG801","101-001",1,"NEPHROPATHY","20150103","","N",
"CSG801","101-001",1,"PERIPHERAL VASCULAR DISEASE","20150103","","N",
"CSG801","101-001",1,"DIABETIC KETOACIDOSIS","20150103","","N",
"CSG801","101-002",1,"DIABETIC RETINOPATHY","20150208","20140924","Y",
"CSG801","101-002",1,"NEUROPATHY","20150208","","N",
"CSG801","101-002",1,"NEPHROPATHY","20150208","","N",
"CSG801","101-002",1,"PERIPHERAL VASCULAR DISEASE","20150208","","N",
"CSG801","101-002",1,"DIABETIC KETOACIDOSIS","20150208","","N",
"CSG801","201-001",1,"DIABETIC RETINOPATHY","20141214","","N",
"CSG801","201-001",1,"NEUROPATHY","20141214","","N",
"CSG801","201-001",1,"NEPHROPATHY","20141214","201001","Y",
"CSG801","201-001",1,"PERIPHERAL VASCULAR DISEASE","20141214","201001","Y",
"CSG801","201-001",1,"DIABETIC KETOACIDOSIS","20141214","","N",
)

mh801_3<-tribble(
~study,~pt,~repeatnum,~mhterm,~mhdat,~mhstdat,~mhendat,~mhongo,
"CSG801","101-001",1,"High Blood Pressure","20150103","20121221","","Yes",
"CSG801","101-002",1,"Appendectomy","20150208","20140501","20140501","",
)

dm<-tribble(
~usubjid,~rfstdtc,
"CSG801-101-001","2015-01-15",
"CSG801-101-002","2015-02-12",
"CSG801-201-001","2014-12-21",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================