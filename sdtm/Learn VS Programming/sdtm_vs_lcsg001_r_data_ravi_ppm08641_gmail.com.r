# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_VS_LCSG001
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

physmeas<-tribble(
~study,~pt,~studypt,~folder,~pmdt_raw,~height_raw,~heightu,~weight_raw,~weightu,
"CSG001","1004","CSG001-1004","SCR","4/JAN/2010","177","Centimeters","87.3","Kilogram",
"CSG001","1005","CSG001-1005","SCR","5/FEB/2010","66.14","Centimeters","76.1","Kilogram",
"CSG001","1006","CSG001-1006","SCR","1/MAR/2010","160","Centimeters","60.9","Kilogram",
"CSG001","1007","CSG001-1007","SCR","13/APR/2010","178","Centimeters","85.4","Kilogram",
)

vitals<-tribble(
~study,~pt,~studypt,~folder,~vsdt_raw,~sysbp_raw,~diabp_raw,~pos,~hr_raw,~resp_raw,~temp_raw,~tempu,~temploc,
"CSG001","1004","CSG001-1004","SCR","02/JAN/2010","122","72","Supine","79","24","34.8","Celsius","Axilla",
"CSG001","1004","CSG001-1004","WEEK 2","12/JAN/2010","120","82","Supine","87","20","35.3","Celsius","Axilla",
"CSG001","1005","CSG001-1005","SCR","5/FEB/2010","120","85","Sitting","68","14","98.06","Fahrenheit","Axilla",
"CSG001","1005","CSG001-1005","WEEK 2","12/FEB/2010","125","87","Sitting","69","15","36.6","Celsius","Axilla",
"CSG001","1005","CSG001-1005","UNS_VIT","22/FEB/2010","130","90","Sitting","75","18","37.0","Celsius","Axilla",
"CSG001","1006","CSG001-1006","SCR","01/MAR/2010","133","87","Sitting","74","20","36.2","Celsius","Ear",
"CSG001","1006","CSG001-1006","WEEK 2","11/MAR/2010","115","68","Sitting","65","21","35.1","Celsius","Ear",
"CSG001","1007","CSG001-1007","SCR","15/APR/2010","120","80","Sitting","75","21","36.9","Celsius","Axilla",
"CSG001","1007","CSG001-1007","WEEK 2","29/APR/2010","140","80","Sitting","80","","37.4","Celsius","Axilla",
)

dm<-tribble(
~studyid,~domain,~usubjid,~subjid,~rfstdtc,
"CSG001","DM","CSG001-1001",1001,"2010-01-01",
"CSG001","DM","CSG001-1002",1002,"2010-01-01",
"CSG001","DM","CSG001-1003",1003,"2010-01-03",
"CSG001","DM","CSG001-1004",1004,"2010-01-05",
"CSG001","DM","CSG001-1005",1005,"2010-02-05",
"CSG001","DM","CSG001-1006",1006,"2010-03-02",
"CSG001","DM","CSG001-1007",1007,"2010-04-15",
"CSG001","DM","CSG001-1008",1008,"2010-06-27",
)

sv<-tribble(
~studyid,~domain,~usubjid,~visitnum,~visit,~svstdtc,~svendtc,~svstdy,~svendy,~svupdes,
"CSG001","SV","CSG001-1004",1,"SCREENING","2010-01-01","2010-01-05",-4,1,"",
"CSG001","SV","CSG001-1004",101,"WEEK 1","2010-01-03","2010-01-05",-2,1,"",
"CSG001","SV","CSG001-1004",102,"WEEK 2","2010-01-10","2010-01-12",6,8,"",
"CSG001","SV","CSG001-1004",103,"WEEK 3","2010-01-18","2010-01-18",14,14,"",
"CSG001","SV","CSG001-1004",104,"WEEK 4","2010-01-24","2010-01-25",20,21,"",
"CSG001","SV","CSG001-1005",1,"SCREENING","2010-02-01","2010-02-05",-4,1,"",
"CSG001","SV","CSG001-1005",101,"WEEK 1","2010-02-05","2010-02-06",1,2,"",
"CSG001","SV","CSG001-1005",102,"WEEK 2","2010-02-10","2010-02-12",6,8,"",
"CSG001","SV","CSG001-1005",103,"WEEK 3","2010-02-18","2010-02-19",14,15,"",
"CSG001","SV","CSG001-1005",103.01,"WEEK 3 UNSCHEDULED 01","2010-02-22","2010-02-22",18,18,"LB,VS,EG",
"CSG001","SV","CSG001-1005",103.02,"WEEK 3 UNSCHEDULED 02","2010-02-23","2010-02-23",19,19,"LB",
"CSG001","SV","CSG001-1005",104,"WEEK 4","2010-02-24","2010-02-24",20,20,"",
"CSG001","SV","CSG001-1006",1,"SCREENING","2010-03-01","2010-03-01",-1,-1,"",
"CSG001","SV","CSG001-1006",101,"WEEK 1","2010-03-02","2010-03-02",1,1,"",
"CSG001","SV","CSG001-1006",102,"WEEK 2","2010-03-10","2010-03-11",9,10,"",
"CSG001","SV","CSG001-1007",1,"SCREENING","2010-04-13","2010-04-15",-2,1,"",
"CSG001","SV","CSG001-1007",101,"WEEK 1","2010-04-15","2010-04-15",1,1,"",
"CSG001","SV","CSG001-1007",102,"WEEK 2","2010-04-22","2010-04-29",8,15,"",
"CSG001","SV","CSG001-1007",103,"WEEK 3","2010-04-29","2010-04-29",15,15,"",
"CSG001","SV","CSG001-1007",104,"WEEK 4","2010-05-06","2010-05-06",22,22,"",
"CSG001","SV","CSG001-1007",201,"FOLLOW-UP 1","2010-05-14","2010-05-14",30,30,"",
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
"CSG001","SE","CSG001-1005",2,"ACTIVE","Active",2,"TREATMENT","2010-02-05","2010-02-24",1,20,
"CSG001","SE","CSG001-1006",1,"SCR","Screening",1,"SCREENING","2010-02-18","2010-03-02",-12,1,
"CSG001","SE","CSG001-1006",2,"PBO","Placebo",2,"TREATMENT","2010-03-02","2010-03-25",1,24,
"CSG001","SE","CSG001-1007",1,"SCR","Screening",1,"SCREENING","2010-04-04","2010-04-15",-11,1,
"CSG001","SE","CSG001-1007",2,"PBO","Placebo",2,"TREATMENT","2010-04-15","2010-05-06",1,22,
"CSG001","SE","CSG001-1007",3,"FUP","Follow-up",2,"FOLLOW-UP","2010-05-06","2010-06-12",22,59,
"CSG001","SE","CSG001-1008",1,"SCR","Screening",1,"SCREENING","2010-06-20","2010-06-27",-7,1,
"CSG001","SE","CSG001-1008",2,"ACTIVE","Active",2,"TREATMENT","2010-06-27","2010-07-15",1,19,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================