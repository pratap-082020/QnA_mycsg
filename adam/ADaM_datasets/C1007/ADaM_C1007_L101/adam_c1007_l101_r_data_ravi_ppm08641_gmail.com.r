# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1007_L101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

windows<-tribble(
~avisit,~target,~lower,~higher,~avisitn,
"Week 1",7,2,11,1,
"Week 2",14,12,18,2,
"Week 3",21,19,25,3,
"Week 4",28,26,32,4,
"Week 5",35,33,39,5,
"Week 6",42,40,46,6,
"Week 7",49,47,53,7,
"Week 8",56,54,60,8,
"Week 9",63,61,67,9,
"Week 10",70,68,74,10,
)

vs<-tribble(
~usubjid,~paramn,~paramcd,~param,~adt,~ady,~aval,~visit,~visitnum,~trtsdt,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20124,-21,125,"SCREENING",1.1,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20145,1,158,"DAY 1",2,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20152,8,140,"WEEK 1",3,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20159,15,153,"WEEK 2",4,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20166,22,159,"WEEK 3",5,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20167,23,165,"UNSCHEDULED",902,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20173,29,138,"WEEK 4",6,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20180,36,142,"WEEK 5",7,20145,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20305,-28,110,"SCREENING",1.1,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20331,-2,120,"UNSCHEDULED",902,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20333,1,130,"DAY 1",2,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20340,8,130,"WEEK 1",3,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20347,15,140,"WEEK 2",4,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20354,22,120,"WEEK 3",5,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20361,29,130,"WEEK 4",6,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20368,36,90,"WEEK 5",7,20333,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================