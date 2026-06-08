# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADAE_L1101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

ae<-tribble(
~studyid,~usubjid,~aeseq,~aeterm,~aedecod,~aebodsys,~aestdtc,~aeendtc,~aeser,~aesev,~aerel,
"MYCSG","MYCSG-001",1,"HEADACHE","Headache","Nervous system disorders","2006-01","2006-01-22","N","MILD","NOT RELATED",
"MYCSG","MYCSG-001",2,"CHRONIC BACK PAIN","Back pain","Musculoskeletal and connective tissue disorders","2005","2006","N","MODERATE","NOT RELATED",
"MYCSG","MYCSG-001",3,"NOSE BLEEDING RIGHT NOSTRIL","Epistaxis","Respiratory, thoracic and mediastinal disorders","2006-01-22","2006-01-22","N","MILD","NOT RELATED",
"MYCSG","MYCSG-001",4,"PROBLEMS OF HYPOTENSION","Hypotension","Vascular disorders","","","N","MILD","POSSIBLY RELATED",
"MYCSG","MYCSG-001",5,"HEADACHE","Headache","Nervous system disorders","2006-01-24","2006-01","N","MODERATE","PROBABLY RELATED",
"MYCSG","MYCSG-001",6,"HEADACHE","Headache","Nervous system disorders","2006-02","2006-02-05","N","SEVERE","PROBABLY RELATED",
"MYCSG","MYCSG-001",7,"LOOSE STOOL","Diarrhoea","Gastrointestinal disorders","2006-03-05","2006-03-06","N","","DEFINITELY RELATED",
"MYCSG","MYCSG-001",8,"ABDOMINAL DISCOMFORT","Abdominal discomfort","Gastrointestinal disorders","2006-03-05","2006","N","MODERATE","DEFINITELY RELATED",
"MYCSG","MYCSG-001",9,"DIARRHEA","Diarrhoea","Gastrointestinal disorders","2006-03-17","2006-03-18","N","MODERATE","DEFINITELY RELATED",
"MYCSG","MYCSG-001",10,"ABDOMINAL FULLNESS DUE TO GAS","Abdominal distension","Gastrointestinal disorders","2006-03-17","2006-03-19","N","MILD","DEFINITELY RELATED",
"MYCSG","MYCSG-001",11,"NAUSEA (INTERMITTENT)","Nausea","Gastrointestinal disorders","2006-04-20","2006-04-22","N","MILD","PROBABLY RELATED",
"MYCSG","MYCSG-001",12,"WEAKNESS","Asthenia","General disorders and administration site conditions","2006-05-17","2006-05-20","N","MILD","POSSIBLY RELATED",
"MYCSG","MYCSG-001",13,"HEADACHE","Headache","Nervous system disorders","2006-05-20","2006-05-22","N","MILD","UNLIKELY RELATED",
"MYCSG","MYCSG-001",14,"HEADACHE","Headache","Nervous system disorders","2006-05-23","2006-06-27","N","MILD","UNLIKELY RELATED",
"MYCSG","MYCSG-001",15,"HYPOTENSIVE","Hypotension","Vascular disorders","2006-05-21","2006-05-25","Y","SEVERE","UNLIKELY RELATED",
"MYCSG","MYCSG-001",16,"HEADACHE","Headache","Nervous system disorders","2006-06-01","2006-06-01","N","MILD","UNLIKELY RELATED",
"MYCSG","MYCSG-002",1,"HEADACHE","Headache","Nervous system disorders","2006-04-19","2006-04-19","N","MILD","UNLIKELY RELATED",
)

adsl<-tribble(
~studyid,~usubjid,~saffl,~trt01a,~trt01an,~trtsdt,~trtedt,~age,~agegr1,~sex,~race,
"MYCSG","MYCSG-001","Y","Drug A",1,16824,16936,54,"<65","M","ASIAN",
"MYCSG","MYCSG-002","Y","Drug B",2,16906,16936,54,"<65","F","WHITE",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================