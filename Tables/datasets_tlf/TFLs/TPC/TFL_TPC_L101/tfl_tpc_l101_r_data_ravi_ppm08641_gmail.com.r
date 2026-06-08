# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TPC_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

adsl<-tribble(
~usubjid,~trt01a,~pkfl,~trt01an,
"MYCSG-10001","MYCSG 20 mg","Y",1,
"MYCSG-10002","MYCSG 20 mg","Y",1,
"MYCSG-10003","MYCSG 20 mg","Y",1,
"MYCSG-10004","MYCSG 20 mg","Y",1,
"MYCSG-10005","MYCSG 20 mg","Y",1,
"MYCSG-20001","MYCSG 40 mg","Y",2,
"MYCSG-20002","MYCSG 40 mg","Y",2,
"MYCSG-20003","MYCSG 40 mg","Y",2,
"MYCSG-20004","MYCSG 40 mg","Y",2,
"MYCSG-20005","MYCSG 40 mg","Y",2,
)

adpc<-tribble(
~usubjid,~trt01a,~avisit,~atpt,~aval,~pkfl,~trt01an,~avisitn,~atptn,~paramcd,
"MYCSG-10001","MYCSG 20 mg","Day 1","Predose",0,"Y",1,1,0,"MYCSG",
"MYCSG-10001","MYCSG 20 mg","Day 1","1 hour",48.62,"Y",1,1,1,"MYCSG",
"MYCSG-10001","MYCSG 20 mg","Day 1","2 hours",56.48,"Y",1,1,2,"MYCSG",
"MYCSG-10001","MYCSG 20 mg","Month 1","Predose",65.23,"Y",1,2,0,"MYCSG",
"MYCSG-10001","MYCSG 20 mg","Month 1","1 hour",47.66,"Y",1,2,1,"MYCSG",
"MYCSG-10001","MYCSG 20 mg","Month 1","2 hours",47.66,"Y",1,2,2,"MYCSG",
"MYCSG-10002","MYCSG 20 mg","Day 1","Predose",0,"Y",1,1,0,"MYCSG",
"MYCSG-10002","MYCSG 20 mg","Day 1","1 hour",57.67,"Y",1,1,1,"MYCSG",
"MYCSG-10002","MYCSG 20 mg","Day 1","2 hours",45.31,"Y",1,1,2,"MYCSG",
"MYCSG-10002","MYCSG 20 mg","Month 1","Predose",55.43,"Y",1,2,0,"MYCSG",
"MYCSG-10002","MYCSG 20 mg","Month 1","1 hour",45.37,"Y",1,2,1,"MYCSG",
"MYCSG-10002","MYCSG 20 mg","Month 1","2 hours",45.34,"Y",1,2,2,"MYCSG",
"MYCSG-10003","MYCSG 20 mg","Day 1","Predose",0,"Y",1,1,0,"MYCSG",
"MYCSG-10003","MYCSG 20 mg","Day 1","1 hour",30.87,"Y",1,1,1,"MYCSG",
"MYCSG-10003","MYCSG 20 mg","Day 1","2 hours",32.75,"Y",1,1,2,"MYCSG",
"MYCSG-10003","MYCSG 20 mg","Month 1","Predose",44.38,"Y",1,2,0,"MYCSG",
"MYCSG-10003","MYCSG 20 mg","Month 1","1 hour",39.87,"Y",1,2,1,"MYCSG",
"MYCSG-10003","MYCSG 20 mg","Month 1","2 hours",53.14,"Y",1,2,2,"MYCSG",
"MYCSG-10004","MYCSG 20 mg","Day 1","Predose",0,"Y",1,1,0,"MYCSG",
"MYCSG-10004","MYCSG 20 mg","Day 1","1 hour",35.88,"Y",1,1,1,"MYCSG",
"MYCSG-10004","MYCSG 20 mg","Day 1","2 hours",64.66,"Y",1,1,2,"MYCSG",
"MYCSG-10004","MYCSG 20 mg","Month 1","Predose",47.74,"Y",1,2,0,"MYCSG",
"MYCSG-10004","MYCSG 20 mg","Month 1","1 hour",50.68,"Y",1,2,1,"MYCSG",
"MYCSG-10004","MYCSG 20 mg","Month 1","2 hours",35.75,"Y",1,2,2,"MYCSG",
"MYCSG-10005","MYCSG 20 mg","Day 1","Predose",0,"Y",1,1,0,"MYCSG",
"MYCSG-10005","MYCSG 20 mg","Day 1","1 hour",51.11,"Y",1,1,1,"MYCSG",
"MYCSG-10005","MYCSG 20 mg","Day 1","2 hours",38.49,"Y",1,1,2,"MYCSG",
"MYCSG-10005","MYCSG 20 mg","Month 1","Predose",53.76,"Y",1,2,0,"MYCSG",
"MYCSG-10005","MYCSG 20 mg","Month 1","1 hour",43.99,"Y",1,2,1,"MYCSG",
"MYCSG-10005","MYCSG 20 mg","Month 1","2 hours",47.08,"Y",1,2,2,"MYCSG",
"MYCSG-20001","MYCSG 40 mg","Day 1","Predose",0,"Y",2,1,0,"MYCSG",
"MYCSG-20001","MYCSG 40 mg","Day 1","1 hour",127.78,"Y",2,1,1,"MYCSG",
"MYCSG-20001","MYCSG 40 mg","Day 1","2 hours",99.8,"Y",2,1,2,"MYCSG",
"MYCSG-20001","MYCSG 40 mg","Month 1","Predose",84.13,"Y",2,2,0,"MYCSG",
"MYCSG-20001","MYCSG 40 mg","Month 1","1 hour",112.34,"Y",2,2,1,"MYCSG",
"MYCSG-20001","MYCSG 40 mg","Month 1","2 hours",81.69,"Y",2,2,2,"MYCSG",
"MYCSG-20002","MYCSG 40 mg","Day 1","Predose",0,"Y",2,1,0,"MYCSG",
"MYCSG-20002","MYCSG 40 mg","Day 1","1 hour",70.6,"Y",2,1,1,"MYCSG",
"MYCSG-20002","MYCSG 40 mg","Day 1","2 hours",80.08,"Y",2,1,2,"MYCSG",
"MYCSG-20002","MYCSG 40 mg","Month 1","Predose",102.95,"Y",2,2,0,"MYCSG",
"MYCSG-20002","MYCSG 40 mg","Month 1","1 hour",111.08,"Y",2,2,1,"MYCSG",
"MYCSG-20002","MYCSG 40 mg","Month 1","2 hours",102.57,"Y",2,2,2,"MYCSG",
"MYCSG-20003","MYCSG 40 mg","Day 1","Predose",0,"Y",2,1,0,"MYCSG",
"MYCSG-20003","MYCSG 40 mg","Day 1","1 hour",95.48,"Y",2,1,1,"MYCSG",
"MYCSG-20003","MYCSG 40 mg","Day 1","2 hours",77.82,"Y",2,1,2,"MYCSG",
"MYCSG-20003","MYCSG 40 mg","Month 1","Predose",89.2,"Y",2,2,0,"MYCSG",
"MYCSG-20003","MYCSG 40 mg","Month 1","1 hour",93.09,"Y",2,2,1,"MYCSG",
"MYCSG-20003","MYCSG 40 mg","Month 1","2 hours",115.86,"Y",2,2,2,"MYCSG",
"MYCSG-20004","MYCSG 40 mg","Day 1","Predose",0,"Y",2,1,0,"MYCSG",
"MYCSG-20004","MYCSG 40 mg","Day 1","1 hour",73.55,"Y",2,1,1,"MYCSG",
"MYCSG-20004","MYCSG 40 mg","Day 1","2 hours",104.86,"Y",2,1,2,"MYCSG",
"MYCSG-20004","MYCSG 40 mg","Month 1","Predose",94.22,"Y",2,2,0,"MYCSG",
"MYCSG-20004","MYCSG 40 mg","Month 1","1 hour",89.85,"Y",2,2,1,"MYCSG",
"MYCSG-20004","MYCSG 40 mg","Month 1","2 hours",109.18,"Y",2,2,2,"MYCSG",
"MYCSG-20005","MYCSG 40 mg","Day 1","Predose",0,"Y",2,1,0,"MYCSG",
"MYCSG-20005","MYCSG 40 mg","Day 1","1 hour",113.97,"Y",2,1,1,"MYCSG",
"MYCSG-20005","MYCSG 40 mg","Day 1","2 hours",87.41,"Y",2,1,2,"MYCSG",
"MYCSG-20005","MYCSG 40 mg","Month 1","Predose",95.36,"Y",2,2,0,"MYCSG",
"MYCSG-20005","MYCSG 40 mg","Month 1","1 hour",104.97,"Y",2,2,1,"MYCSG",
"MYCSG-20005","MYCSG 40 mg","Month 1","2 hours",114.63,"Y",2,2,2,"MYCSG",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================