# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L150
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

lblc<-tribble(
~usubjid,~lbdtc,~lbtestcd,~lborresu,~lborres,
"MYCSG-1001","2010-01-05","BILI","umol/L","25.66",
"MYCSG-1001","2010-02-05","BILI","mg/dL","1.3",
"MYCSG-1001","2010-03-05","BILI","mg/L","10",
"MYCSG-1001","2010-04-05","BILI","mg/dL","<1",
"MYCSG-1001","2010-01-05","CA","mmol/L","2.25",
"MYCSG-1001","2010-02-05","CA","mg/dL","10.5",
"MYCSG-1001","2010-03-05","CA","mg/L","95",
"MYCSG-1001","2010-04-05","CA","mg/dL",">=15",
)

conversion<-tribble(
~lbtestcd,~lborresu,~lbstresu,~conv_mult,~decimals,
"BILI","umol/L","umol/L",1,3,
"BILI","mg/dL","umol/L",17.1037,3,
"BILI","mg/L","umol/L",1.7104,3,
"CA","mmol/L","mmol/L",1,2,
"CA","mg/dL","mmol/L",0.2495,2,
"CA","mg/L","mmol/L",0.025,2,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================