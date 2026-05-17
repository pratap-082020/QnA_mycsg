# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_EG_LCSG001
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

ecg<-tribble(
~study,~pt,~folder,~egdt_raw,~egscat,~egmethod,~egloc,~pr_raw,~qrs_raw,~qt_raw,~qtc_raw,~hr_raw,~egintp,~egintpsp,
"CSG001","1004","SCR","4/JAN/2010","SOC","12 Lead","Heart","80","88","409","385","59","Normal","",
"CSG001","1005","SCR","5/FEB/2010","SOC","12 Lead","Heart","180","80","360","392","76","Normal","",
"CSG001","1005","UNS_ECG","22/FEB/2010","SOC","12 Lead","Heart","190","90","376","408","81","Normal","",
"CSG001","1006","SCR","1/MAR/2010","SOC","12 Lead","Heart","142","76","389","411","71","Normal","",
"CSG001","1007","SCR","13/APR/2010","SOC","12 Lead","Heart","152","108","396","441","74","Abnormal Not Clinically Significant","AV BLOCK Grade 1",
)

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

sv<-tribble(
~studyid,~domain,~usubjid,~visitnum,~visit,~svstdtc,~svendtc,~svstdy,~svendy,~svupdes,
"CSG001","SV","CSG001-1004",1,"SCREENING","2010-01-02","2010-01-04",-3,-1,"",
"CSG001","SV","CSG001-1004",101,"WEEK 1","2010-01-05","2010-01-05",1,1,"",
"CSG001","SV","CSG001-1004",102,"WEEK 2","2010-01-12","2010-01-12",8,8,"",
"CSG001","SV","CSG001-1004",103,"WEEK 3","2010-01-18","2010-01-18",14,14,"",
"CSG001","SV","CSG001-1004",104,"WEEK 4","2010-01-25","2010-01-25",21,21,"",
"CSG001","SV","CSG001-1005",1,"SCREENING","2010-02-02","2010-02-05",-3,1,"",
"CSG001","SV","CSG001-1005",101,"WEEK 1","2010-02-05","2010-02-05",1,1,"",
"CSG001","SV","CSG001-1005",102,"WEEK 2","2010-02-12","2010-02-12",8,8,"",
"CSG001","SV","CSG001-1005",103,"WEEK 3","2010-02-19","2010-02-19",15,15,"",
"CSG001","SV","CSG001-1005",103.01,"WEEK 3 UNSCHEDULED 01","2010-02-22","2010-02-22",18,18,"VS,EG",
"CSG001","SV","CSG001-1006",1,"SCREENING","2010-02-27","2010-03-01",-3,-1,"",
"CSG001","SV","CSG001-1006",101,"WEEK 1","2010-03-02","2010-03-02",1,1,"",
"CSG001","SV","CSG001-1006",102,"WEEK 2","2010-03-10","2010-03-11",9,10,"",
"CSG001","SV","CSG001-1007",1,"SCREENING","2010-04-12","2010-04-15",-3,1,"",
"CSG001","SV","CSG001-1007",101,"WEEK 1","2010-04-15","2010-04-15",1,1,"",
"CSG001","SV","CSG001-1007",102,"WEEK 2","2010-04-22","2010-04-29",8,15,"",
"CSG001","SV","CSG001-1007",103,"WEEK 3","2010-04-29","2010-04-29",15,15,"",
"CSG001","SV","CSG001-1007",104,"WEEK 4","2010-05-06","2010-05-06",22,22,"",
"CSG001","SV","CSG001-1008",1,"SCREENING","2010-06-24","2010-06-24",-3,-3,"",
"CSG001","SV","CSG001-1008",101,"WEEK 1","2010-06-27","2010-06-27",1,1,"",
"CSG001","SV","CSG001-1008",102,"WEEK 2","2010-07-04","2010-07-04",8,8,"",
"CSG001","SV","CSG001-1008",103,"WEEK 3","2010-07-11","2010-07-11",15,15,"",
)

se<-tribble(
~studyid,~domain,~usubjid,~seseq,~etcd,~element,~taetord,~epoch,~sestdtc,~seendtc,~sestdy,~seendy,
"CSG001","SE","CSG001-1001",1,"SCR","Screening",1,"SCREENING","2010-01-01","2010-01-01",1,1,
"CSG001","SE","CSG001-1002",1,"SCR","Screening",1,"SCREENING","2010-01-01","2010-01-05",1,5,
"CSG001","SE","CSG001-1003",1,"SCR","Screening",1,"SCREENING","2010-01-01","2010-01-05",-2,3,
"CSG001","SE","CSG001-1004",1,"SCR","Screening",1,"SCREENING","2010-01-01","2010-01-05",-4,1,
"CSG001","SE","CSG001-1004",2,"ACTIVE","Active",2,"TREATMENT","2010-01-05","2010-01-25",1,21,
"CSG001","SE","CSG001-1005",1,"SCR","Screening",1,"SCREENING","2010-01-15","2010-02-05",-21,1,
"CSG001","SE","CSG001-1005",2,"ACTIVE","Active",2,"TREATMENT","2010-02-05","2010-02-22",1,18,
"CSG001","SE","CSG001-1006",1,"SCR","Screening",1,"SCREENING","2010-02-18","2010-03-02",-12,1,
"CSG001","SE","CSG001-1006",2,"PBO","Placebo",2,"TREATMENT","2010-03-02","2010-03-25",1,24,
"CSG001","SE","CSG001-1007",1,"SCR","Screening",1,"SCREENING","2010-04-04","2010-04-15",-11,1,
"CSG001","SE","CSG001-1007",2,"PBO","Placebo",2,"TREATMENT","2010-04-15","2010-05-06",1,22,
"CSG001","SE","CSG001-1008",1,"SCR","Screening",1,"SCREENING","2010-06-20","2010-06-27",-7,1,
"CSG001","SE","CSG001-1008",2,"ACTIVE","Active",2,"TREATMENT","2010-06-27","2010-07-15",1,19,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================