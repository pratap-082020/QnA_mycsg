# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1007_L102
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

vs<-tribble(
~USUBJID,~PARAMN,~PARAMCD,~PARAM,~ADT,~ADY,~AVAL,~VISIT,~VISITNUM,~TRTSDT,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20124,-21,125,"SCREENING",1.1,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20145,1,158,"DAY 1",2,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20152,8,140,"WEEK 1",3,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20159,15,153,"WEEK 2",4,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20166,22,159,"WEEK 3",5,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20173,29,138,"WEEK 4",6,20145,
"CSG-1001",1,"SYSBP","Systolic Blood Pressure (mmHg)",20180,36,142,"WEEK 5",7,20145,
"CSG-1001",6,"WEIGHT","Weight (kg)",20124,-21,75.7,"SCREENING",1.1,20145,
"CSG-1001",6,"WEIGHT","Weight (kg)",20129,-16,75,"SCREENING",1.1,20145,
"CSG-1001",6,"WEIGHT","Weight (kg)",20138,-7,75,"SCREENING",1.1,20145,
"CSG-1001",6,"WEIGHT","Weight (kg)",20145,1,75.2,"DAY 1",2,20145,
"CSG-1001",6,"WEIGHT","Weight (kg)",20313,169,74.6,"WEEK 24",18,20145,
"CSG-1001",6,"WEIGHT","Weight (kg)",20318,174,74.9,"UNSCHEDULED",902,20145,
"CSG-1001",6,"WEIGHT","Weight (kg)",20397,253,74.3,"WEEK 36",24,20145,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20305,-28,110,"SCREENING",1.1,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20331,-2,120,"UNSCHEDULED",902,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20333,1,130,"DAY 1",2,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20340,8,130,"WEEK 1",3,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20347,15,140,"WEEK 2",4,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20354,22,120,"WEEK 3",5,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20361,29,130,"WEEK 4",6,20333,
"CSG-1002",1,"SYSBP","Systolic Blood Pressure (mmHg)",20368,36,90,"WEEK 5",7,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20305,-28,81,"SCREENING",1.1,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20312,-21,80.8,"SCREENING",1.1,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20319,-14,81,"SCREENING",1.1,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20331,-2,81,"UNSCHEDULED",902,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20333,1,81,"DAY 1",2,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20380,48,81,"UNSCHEDULED",902,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20384,52,80.8,"UNSCHEDULED",902,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20417,85,80.8,"WEEK 12",12,20333,
"CSG-1002",6,"WEIGHT","Weight (kg)",20501,169,79.8,"WEEK 24",18,20333,
)

windows<-tribble(
~paramcd,~avisit,~target,~lower,~higher,~avisitn,
"WEIGHT","Week 1",84,2,127,1,
"WEIGHT","Week 24",168,128,211,24,
"WEIGHT","Week 36",252,212,295,36,
"SYSBP","Week 1",7,2,11,1,
"SYSBP","Week 2",14,12,18,2,
"SYSBP","Week 3",21,19,25,3,
"SYSBP","Week 4",28,26,32,4,
"SYSBP","Week 5",35,33,39,5,
"SYSBP","Week 6",42,40,46,6,
"SYSBP","Week 7",49,47,53,7,
"SYSBP","Week 8",56,54,60,8,
"SYSBP","Week 9",63,61,67,9,
"SYSBP","Week 10",70,68,74,10,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================