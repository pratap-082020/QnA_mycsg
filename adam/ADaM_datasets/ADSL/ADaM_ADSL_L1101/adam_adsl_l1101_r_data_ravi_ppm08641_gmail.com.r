# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_ADSL_L1101
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~studyid,~domain,~usubjid,~subjid,~rfstdtc,~rfendtc,~rfxstdtc,~rfxendtc,~rficdtc,~rfpendtc,~dthdtc,~dthfl,~siteid,~age,~ageu,~sex,~race,~ethnic,~armcd,~arm,~actarmcd,~actarm,~country,
"CSG001","DM","CSG001-1001","1001","2010-01-01","","","","2010-01-01","2010-01-01","","","10",35,"YEARS","M","WHITE","HISPANIC OR LATINO","SCRNFAIL","Screen Failure","SCRNFAIL","Screen Failure","USA",
"CSG001","DM","CSG001-1002","1002","2010-01-01","2010-01-05","","","2010-01-01","2010-01-05","","","10",40,"YEARS","F","MULTIPLE","NOT HISPANIC OR LATINO","NOTASSGN","Not Assigned","NOTASSGN","Not Assigned","USA",
"CSG001","DM","CSG001-1003","1003","2010-01-03","2010-01-05","","","2010-01-01","2010-01-05","2010-01-05","Y","10",40,"YEARS","M","OTHER","HISPANIC OR LATINO","PBO","Placebo","NOTTRT","Not Treated","USA",
"CSG001","DM","CSG001-1004","1004","2010-01-05","2010-02-28","2010-01-05T08:35","2010-01-25T08:45","2010-01-01","2010-02-28","","","10",38,"YEARS","M","WHITE","HISPANIC OR LATINO","ACTIVE","Active","ACTIVE","Active","USA",
"CSG001","DM","CSG001-1005","1005","2010-02-05","","2010-02-05T08:46","2010-02-12T08:30","2010-01-15","2020-02-20","","","10",64,"YEARS","M","AMERICAN INDIAN OR ALASKA NATIVE","NOT HISPANIC OR LATINO","ACTIVE","Active","PBO","Placebo","USA",
"CSG001","DM","CSG001-1006","1006","2010-03-02","2010-03-25","2010-03-02T08:30","2010-03-10T08:30","2010-02-18","2010-03-25","","","10",75,"YEARS","F","NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER","NOT HISPANIC OR LATINO","PBO","Placebo","PBO","Placebo","USA",
"CSG001","DM","CSG001-1007","1007","2010-04-15","2010-06-12","2010-04-15T08:23","2010-05-06T08:12","2010-04-04","2010-06-12","","","10",32,"YEARS","M","UNKNOWN","NOT HISPANIC OR LATINO","PBO","Placebo","PBO","Placebo","USA",
"CSG001","DM","CSG001-1008","1008","2010-06-27","2010-08-18","2010-06-27T08:45","2010-07-11T09:20","2010-06-20","2010-08-18","","","10",83,"YEARS","F","NOT REPORTED","NOT HISPANIC OR LATINO","ACTIVE","Active","ACTIVE","Active","USA",
)

suppdm<-tribble(
~studyid,~rdomain,~usubjid,~idvar,~idvarval,~qnam,~qlabel,~qval,
"CSG001","DM","CSG001-1002","","","RACE1","Race 1","ASIAN",
"CSG001","DM","CSG001-1002","","","RACE2","Race 2","AMERICAN INDIAN OR ALASKA NATIVE",
"CSG001","DM","CSG001-1003","","","RACESP","Race Other Specify","BRAZILIAN",
)

ds<-tribble(
~studyid,~domain,~usubjid,~dsseq,~dsrefid,~dsterm,~dsdecod,~dscat,~dsscat,~dsstdtc,~dsstdy,
"CSG001","DS","CSG001-1001",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-01-01",1,
"CSG001","DS","CSG001-1002",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-01-01",1,
"CSG001","DS","CSG001-1002",2,"","ENROLLED","ELIGIBILITY CRITERIA MET","PROTOCOL MILESTONE","","2010-01-04",4,
"CSG001","DS","CSG001-1002",3,"","Withdrawl of consent","WITHDRAWL OF CONSENT","DISPOSITION EVENT","END OF STUDY","2010-01-05",5,
"CSG001","DS","CSG001-1003",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-01-01",-2,
"CSG001","DS","CSG001-1003",2,"","ENROLLED","ELIGIBILITY CRITERIA MET","PROTOCOL MILESTONE","","2010-01-03",1,
"CSG001","DS","CSG001-1003",3,"514876","RANDOMIZED","RANDOMIZED","PROTOCOL MILESTONE","","2010-01-03",1,
"CSG001","DS","CSG001-1003",4,"","Death","DEATH","DISPOSITION EVENT","END OF STUDY","2010-01-05",3,
"CSG001","DS","CSG001-1004",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-01-01",-4,
"CSG001","DS","CSG001-1004",2,"","ENROLLED","ELIGIBILITY CRITERIA MET","PROTOCOL MILESTONE","","2010-01-04",-1,
"CSG001","DS","CSG001-1004",3,"101415","RANDOMIZED","RANDOMIZED","PROTOCOL MILESTONE","","2010-01-05",1,
"CSG001","DS","CSG001-1004",4,"","Completed","COMPLETED","DISPOSITION EVENT","END OF TREATMENT","2010-01-25",21,
"CSG001","DS","CSG001-1004",5,"","Completed","COMPLETED","DISPOSITION EVENT","END OF STUDY","2010-02-28",55,
"CSG001","DS","CSG001-1005",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-01-15",-21,
"CSG001","DS","CSG001-1005",2,"","ENROLLED","ELIGIBILITY CRITERIA MET","PROTOCOL MILESTONE","","2010-02-01",-4,
"CSG001","DS","CSG001-1005",3,"306185","RANDOMIZED","RANDOMIZED","PROTOCOL MILESTONE","","2010-02-05",1,
"CSG001","DS","CSG001-1006",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-02-18",-12,
"CSG001","DS","CSG001-1006",2,"","ENROLLED","ELIGIBILITY CRITERIA MET","PROTOCOL MILESTONE","","2010-03-01",-1,
"CSG001","DS","CSG001-1006",3,"987435","RANDOMIZED","RANDOMIZED","PROTOCOL MILESTONE","","2010-03-01",-1,
"CSG001","DS","CSG001-1006",4,"","Adverse Event","ADVERSE EVENT","DISPOSITION EVENT","END OF TREATMENT","2010-03-25",24,
"CSG001","DS","CSG001-1006",5,"","Adverse Event","ADVERSE EVENT","DISPOSITION EVENT","END OF STUDY","2010-03-25",24,
"CSG001","DS","CSG001-1007",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-04-04",-11,
"CSG001","DS","CSG001-1007",2,"","ENROLLED","ELIGIBILITY CRITERIA MET","PROTOCOL MILESTONE","","2010-04-14",-1,
"CSG001","DS","CSG001-1007",3,"098745","RANDOMIZED","RANDOMIZED","PROTOCOL MILESTONE","","2010-04-14",-1,
"CSG001","DS","CSG001-1007",4,"","Completed","COMPLETED","DISPOSITION EVENT","END OF TREATMENT","2010-05-06",22,
"CSG001","DS","CSG001-1007",5,"","Completed","COMPLETED","DISPOSITION EVENT","END OF STUDY","2010-06-12",59,
"CSG001","DS","CSG001-1008",1,"","INFORMED CONSENT OBTAINED","INFORMED CONSENT OBTAINED","PROTOCOL MILESTONE","","2010-06-20",-7,
"CSG001","DS","CSG001-1008",2,"","ENROLLED","ELIGIBILITY CRITERIA MET","PROTOCOL MILESTONE","","2010-06-26",-1,
"CSG001","DS","CSG001-1008",3,"123098","RANDOMIZED","RANDOMIZED","PROTOCOL MILESTONE","","2010-06-27",1,
"CSG001","DS","CSG001-1008",4,"","Subject Request","SUBJECT REQUEST","DISPOSITION EVENT","END OF TREATMENT","2010-07-15",19,
"CSG001","DS","CSG001-1008",5,"","Subject Request","SUBJECT REQUEST","DISPOSITION EVENT","END OF STUDY","2010-08-18",53,
)

vs<-tribble(
~studyid,~domain,~usubjid,~vsseq,~vstestcd,~vstest,~vscat,~vspos,~vsorres,~vsorresu,~vsstresc,~vsstresn,~vsstresu,~vsstat,~vsloc,~vsblfl,~visitnum,~visit,~epoch,~vsdtc,~vsdy,
"CSG001","VS","CSG001-1004",1,"HEIGHT","Height","PHYSICAL MEASUREMENTS","","177","cm","177",177,"cm","","","Y",1,"SCREENING","SCREENING","2010-01-04",-1,
"CSG001","VS","CSG001-1004",2,"WEIGHT","Weight","PHYSICAL MEASUREMENTS","","87.3","kg","87.3",87.3,"kg","","","Y",1,"SCREENING","SCREENING","2010-01-04",-1,
"CSG001","VS","CSG001-1004",3,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SUPINE","72","mmHg","72",72,"mmHg","","","Y",1,"SCREENING","SCREENING","2010-01-02",-3,
"CSG001","VS","CSG001-1004",4,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SUPINE","82","mmHg","82",82,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-01-12",8,
"CSG001","VS","CSG001-1004",5,"HR","Heart Rate","VITAL SIGNS","","72","beats/min","72",72,"beats/min","","","Y",1,"SCREENING","SCREENING","2010-01-02",-3,
"CSG001","VS","CSG001-1004",6,"HR","Heart Rate","VITAL SIGNS","","82","beats/min","82",82,"beats/min","","","",102,"WEEK 2","TREATMENT","2010-01-12",8,
"CSG001","VS","CSG001-1004",7,"RESP","Respiratory Rate","VITAL SIGNS","","24","breaths/min","24",24,"breaths/min","","","Y",1,"SCREENING","SCREENING","2010-01-02",-3,
"CSG001","VS","CSG001-1004",8,"RESP","Respiratory Rate","VITAL SIGNS","","20","breaths/min","20",20,"breaths/min","","","",102,"WEEK 2","TREATMENT","2010-01-12",8,
"CSG001","VS","CSG001-1004",9,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SUPINE","122","mmHg","122",122,"mmHg","","","Y",1,"SCREENING","SCREENING","2010-01-02",-3,
"CSG001","VS","CSG001-1004",10,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SUPINE","120","mmHg","120",120,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-01-12",8,
"CSG001","VS","CSG001-1004",11,"TEMP","Temperature","VITAL SIGNS","","34.8","C","34.8",34.8,"C","","AXILLA","Y",1,"SCREENING","SCREENING","2010-01-02",-3,
"CSG001","VS","CSG001-1004",12,"TEMP","Temperature","VITAL SIGNS","","35.3","C","35.3",35.3,"C","","AXILLA","",102,"WEEK 2","TREATMENT","2010-01-12",8,
"CSG001","VS","CSG001-1005",1,"HEIGHT","Height","PHYSICAL MEASUREMENTS","","66.14","cm","66.14",66.14,"cm","","","Y",1,"SCREENING","TREATMENT","2010-02-05",1,
"CSG001","VS","CSG001-1005",2,"WEIGHT","Weight","PHYSICAL MEASUREMENTS","","76.1","kg","76.1",76.1,"kg","","","Y",1,"SCREENING","TREATMENT","2010-02-05",1,
"CSG001","VS","CSG001-1005",3,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SITTING","85","mmHg","85",85,"mmHg","","","Y",1,"SCREENING","TREATMENT","2010-02-05",1,
"CSG001","VS","CSG001-1005",4,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SITTING","87","mmHg","87",87,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-02-12",8,
"CSG001","VS","CSG001-1005",5,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SITTING","90","mmHg","90",90,"mmHg","","","",103.01,"WEEK 3 UNSCHEDULED 01","TREATMENT","2010-02-22",18,
"CSG001","VS","CSG001-1005",6,"HR","Heart Rate","VITAL SIGNS","","85","beats/min","85",85,"beats/min","","","Y",1,"SCREENING","TREATMENT","2010-02-05",1,
"CSG001","VS","CSG001-1005",7,"HR","Heart Rate","VITAL SIGNS","","87","beats/min","87",87,"beats/min","","","",102,"WEEK 2","TREATMENT","2010-02-12",8,
"CSG001","VS","CSG001-1005",8,"HR","Heart Rate","VITAL SIGNS","","90","beats/min","90",90,"beats/min","","","",103.01,"WEEK 3 UNSCHEDULED 01","TREATMENT","2010-02-22",18,
"CSG001","VS","CSG001-1005",9,"RESP","Respiratory Rate","VITAL SIGNS","","14","breaths/min","14",14,"breaths/min","","","Y",1,"SCREENING","TREATMENT","2010-02-05",1,
"CSG001","VS","CSG001-1005",10,"RESP","Respiratory Rate","VITAL SIGNS","","15","breaths/min","15",15,"breaths/min","","","",102,"WEEK 2","TREATMENT","2010-02-12",8,
"CSG001","VS","CSG001-1005",11,"RESP","Respiratory Rate","VITAL SIGNS","","18","breaths/min","18",18,"breaths/min","","","",103.01,"WEEK 3 UNSCHEDULED 01","TREATMENT","2010-02-22",18,
"CSG001","VS","CSG001-1005",12,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SITTING","120","mmHg","120",120,"mmHg","","","Y",1,"SCREENING","TREATMENT","2010-02-05",1,
"CSG001","VS","CSG001-1005",13,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SITTING","125","mmHg","125",125,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-02-12",8,
"CSG001","VS","CSG001-1005",14,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SITTING","130","mmHg","130",130,"mmHg","","","",103.01,"WEEK 3 UNSCHEDULED 01","TREATMENT","2010-02-22",18,
"CSG001","VS","CSG001-1005",15,"TEMP","Temperature","VITAL SIGNS","","98.06","F","36.7",36.7,"C","","AXILLA","Y",1,"SCREENING","TREATMENT","2010-02-05",1,
"CSG001","VS","CSG001-1005",16,"TEMP","Temperature","VITAL SIGNS","","36.6","C","36.6",36.6,"C","","AXILLA","",102,"WEEK 2","TREATMENT","2010-02-12",8,
"CSG001","VS","CSG001-1005",17,"TEMP","Temperature","VITAL SIGNS","","37.0","C","37",37,"C","","AXILLA","",103.01,"WEEK 3 UNSCHEDULED 01","TREATMENT","2010-02-22",18,
"CSG001","VS","CSG001-1006",1,"HEIGHT","Height","PHYSICAL MEASUREMENTS","","160","cm","160",160,"cm","","","Y",1,"SCREENING","SCREENING","2010-03-01",-1,
"CSG001","VS","CSG001-1006",2,"WEIGHT","Weight","PHYSICAL MEASUREMENTS","","60.9","kg","60.9",60.9,"kg","","","Y",1,"SCREENING","SCREENING","2010-03-01",-1,
"CSG001","VS","CSG001-1006",3,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SITTING","87","mmHg","87",87,"mmHg","","","Y",1,"SCREENING","SCREENING","2010-03-01",-1,
"CSG001","VS","CSG001-1006",4,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SITTING","68","mmHg","68",68,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-03-11",10,
"CSG001","VS","CSG001-1006",5,"HR","Heart Rate","VITAL SIGNS","","87","beats/min","87",87,"beats/min","","","Y",1,"SCREENING","SCREENING","2010-03-01",-1,
"CSG001","VS","CSG001-1006",6,"HR","Heart Rate","VITAL SIGNS","","68","beats/min","68",68,"beats/min","","","",102,"WEEK 2","TREATMENT","2010-03-11",10,
"CSG001","VS","CSG001-1006",7,"RESP","Respiratory Rate","VITAL SIGNS","","20","breaths/min","20",20,"breaths/min","","","Y",1,"SCREENING","SCREENING","2010-03-01",-1,
"CSG001","VS","CSG001-1006",8,"RESP","Respiratory Rate","VITAL SIGNS","","21","breaths/min","21",21,"breaths/min","","","",102,"WEEK 2","TREATMENT","2010-03-11",10,
"CSG001","VS","CSG001-1006",9,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SITTING","133","mmHg","133",133,"mmHg","","","Y",1,"SCREENING","SCREENING","2010-03-01",-1,
"CSG001","VS","CSG001-1006",10,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SITTING","115","mmHg","115",115,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-03-11",10,
"CSG001","VS","CSG001-1006",11,"TEMP","Temperature","VITAL SIGNS","","36.2","C","36.2",36.2,"C","","EAR","Y",1,"SCREENING","SCREENING","2010-03-01",-1,
"CSG001","VS","CSG001-1006",12,"TEMP","Temperature","VITAL SIGNS","","35.1","C","35.1",35.1,"C","","EAR","",102,"WEEK 2","TREATMENT","2010-03-11",10,
"CSG001","VS","CSG001-1007",1,"HEIGHT","Height","PHYSICAL MEASUREMENTS","","178","cm","178",178,"cm","","","Y",1,"SCREENING","SCREENING","2010-04-13",-2,
"CSG001","VS","CSG001-1007",2,"WEIGHT","Weight","PHYSICAL MEASUREMENTS","","85.4","kg","85.4",85.4,"kg","","","Y",1,"SCREENING","SCREENING","2010-04-13",-2,
"CSG001","VS","CSG001-1007",3,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SITTING","80","mmHg","80",80,"mmHg","","","Y",1,"SCREENING","TREATMENT","2010-04-15",1,
"CSG001","VS","CSG001-1007",4,"DIABP","Diastolic Blood Pressure","VITAL SIGNS","SITTING","80","mmHg","80",80,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-04-29",15,
"CSG001","VS","CSG001-1007",5,"HR","Heart Rate","VITAL SIGNS","","80","beats/min","80",80,"beats/min","","","Y",1,"SCREENING","TREATMENT","2010-04-15",1,
"CSG001","VS","CSG001-1007",6,"HR","Heart Rate","VITAL SIGNS","","80","beats/min","80",80,"beats/min","","","",102,"WEEK 2","TREATMENT","2010-04-29",15,
"CSG001","VS","CSG001-1007",7,"RESP","Respiratory Rate","VITAL SIGNS","","21","breaths/min","21",21,"breaths/min","","","Y",1,"SCREENING","TREATMENT","2010-04-15",1,
"CSG001","VS","CSG001-1007",8,"RESP","Respiratory Rate","VITAL SIGNS","","","","",NA,"","NOT DONE","","",102,"WEEK 2","TREATMENT","2010-04-29",15,
"CSG001","VS","CSG001-1007",9,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SITTING","120","mmHg","120",120,"mmHg","","","Y",1,"SCREENING","TREATMENT","2010-04-15",1,
"CSG001","VS","CSG001-1007",10,"SYSBP","Systolic Blood Pressure","VITAL SIGNS","SITTING","140","mmHg","140",140,"mmHg","","","",102,"WEEK 2","TREATMENT","2010-04-29",15,
"CSG001","VS","CSG001-1007",11,"TEMP","Temperature","VITAL SIGNS","","36.9","C","36.9",36.9,"C","","AXILLA","Y",1,"SCREENING","TREATMENT","2010-04-15",1,
"CSG001","VS","CSG001-1007",12,"TEMP","Temperature","VITAL SIGNS","","37.4","C","37.4",37.4,"C","","AXILLA","",102,"WEEK 2","TREATMENT","2010-04-29",15,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================