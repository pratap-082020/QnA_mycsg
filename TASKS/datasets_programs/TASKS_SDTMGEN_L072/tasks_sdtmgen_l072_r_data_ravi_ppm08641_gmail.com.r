# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L072
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

demog<-tribble(
~study,~pt,~sex,~ethnic,~race,
"CSG001","1001","Male","Hispanic or Latino","White",
"CSG001","1002","Female","Not Hispanic or Latino","Asian",
"CSG001","1003","Male","Hispanic or Latino","Other",
"CSG001","1004","Male","Hispanic or Latino","White",
"CSG001","1005","Male","Not Hispanic or Latino","American Indian or Alaska Native",
"CSG001","1006","Female","Not Hispanic or Latino","Native Hawaiian or Other Pacific Islander",
"CSG001","1007","Male","Not Hispanic or Latino","Unknown",
"CSG001","1008","Female","Not Hispanic or Latino","Not Reported",
)

ipadmin<-tribble(
~study,~pt,~folder,~ipstdt_raw,~ipqty_raw,~ipboxid,
"CSG001","1004","WEEK 1","05/JAN/2010","2","13434371",
"CSG001","1004","WEEK 2","12/JAN/2010","2","52970539",
"CSG001","1004","WEEK 3","18/JAN/2010","1","52120567",
"CSG001","1004","WEEK 4","25/JAN/2010","2","59305202",
"CSG001","1005","WEEK 1","05/FEB/2010","2","13787377",
"CSG001","1005","WEEK 2","12/FEB/2010","2","65580239",
"CSG001","1005","WEEK 3","19/FEB/2010","0","45377264",
"CSG001","1006","WEEK 1","2/MAR/2010","1.9","39024101",
"CSG001","1006","WEEK 2","10/MAR/2010","2","65845489",
"CSG001","1007","WEEK 1","15/APR/2010","2","66223983",
"CSG001","1007","WEEK 2","22/APR/2010","2","71763169",
"CSG001","1007","WEEK 3","29/APR/2010","2","60038358",
"CSG001","1007","WEEK 4","6/MAY/2010","2","68706162",
"CSG001","1008","WEEK 1","27/JUN/2010","2","68891589",
"CSG001","1008","WEEK 2","4/JUL/2010","2","2311359",
"CSG001","1008","WEEK 3","11/JUL/2010","2","3199027",
)

box<-tribble(
~kitid,~content,
"13434371","ACTIVE",
"52970539","ACTIVE",
"52120567","ACTIVE",
"59305202","ACTIVE",
"13787377","PBO",
"65580239","ACTIVE",
"45377264","ACTIVE",
"39024101","PBO",
"65845489","PBO",
"66223983","PBO",
"71763169","PBO",
"60038358","PBO",
"68706162","PBO",
"68891589","ACTIVE",
"2311359","ACTIVE",
"3199027","ACTIVE",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================