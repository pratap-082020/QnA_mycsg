# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_PP_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

pcon<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~grpid,~dosing_time,~pctpt,~pcdat_raw,~pctim,~spec,~analyte,~unit,~result,
"MYCSG",1001,201,"Day 1 - Predose",1,"Day 1","2023-02-01T08:00","PREDOSE","01-FEB-2023","07:45","PLASMA","Drug A","ng/mL","<0.1",
"MYCSG",1001,201,"Day 1 - 1H30M",2,"Day 1","2023-02-01T08:00","1H30MIN","01-FEB-2023","09:30","PLASMA","Drug A","ng/mL","4.74",
"MYCSG",1001,201,"Day 1 - 6H",3,"Day 1","2023-02-01T08:00","6H","01-FEB-2023","14:00","PLASMA","Drug A","ng/mL","1.09",
"MYCSG",1001,202,"Day 2",4,"Day 1","2023-02-01T08:00","24H","02-FEB-2023","08:00","PLASMA","Drug A","ng/mL","<0.1",
"MYCSG",1001,205,"Day 11 - Predose",5,"Day 11","2023-02-11T08:00","PREDOSE","11-FEB-2023","07:45","PLASMA","Drug A","ng/mL","<0.1",
"MYCSG",1001,205,"Day 11 - 1H30M",6,"Day 11","2023-02-11T08:00","1H30MIN","11-FEB-2023","09:30","PLASMA","Drug A","ng/mL","4.2",
"MYCSG",1001,205,"Day 11 - 6H",7,"Day 11","2023-02-11T08:00","6H","11-FEB-2023","14:00","PLASMA","Drug A","ng/mL","1.18",
"MYCSG",1001,206,"Day 12",8,"Day 11","2023-02-11T08:00","24H","12-FEB-2023","08:00","PLASMA","Drug A","ng/mL","<0.1",
)

pparam<-tribble(
~studyid,~subject,~folderseq,~foldername,~recordposition,~grpid,~spec,~param,~result,
"MYCSG",1001,201,"Day 1",1,"Day 1_DRUGA","PLASMA","TMAX (H)","1.87",
"MYCSG",1001,201,"Day 1",2,"Day 1_DRUGA","PLASMA","CMAX (ug/L)","44.5",
"MYCSG",1001,201,"Day 1",3,"Day 1_DRUGA","PLASMA","AUCALL (h*mg/L)","294.7",
"MYCSG",1001,201,"Day 1",4,"Day 1_DRUGA","PLASMA","LAMZHL (H)","0.75",
"MYCSG",1001,201,"Day 1",5,"Day 1_DRUGA","PLASMA","VZO (L)","10.9",
"MYCSG",1001,205,"Day 11",6,"Day 11_DRUGA","PLASMA","TMAX (H)","1.91",
"MYCSG",1001,205,"Day 11",7,"Day 11_DRUGA","PLASMA","CMAX (ug/L)","46.0",
"MYCSG",1001,205,"Day 11",8,"Day 11_DRUGA","PLASMA","AUCALL (h*mg/L)","289.0",
"MYCSG",1001,205,"Day 11",9,"Day 11_DRUGA","PLASMA","LAMZHL (H)","0.77",
"MYCSG",1001,205,"Day 11",10,"Day 11_DRUGA","PLASMA","VZO (L)","10.7",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================