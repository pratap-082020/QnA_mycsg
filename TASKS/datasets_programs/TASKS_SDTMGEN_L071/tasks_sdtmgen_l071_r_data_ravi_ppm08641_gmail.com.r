# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L071
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

enrlment<-tribble(
~study,~pt,~folder,~icdt_raw,~icvers,~prtvers,~enrldt_raw,~randdt_raw,~randno,
"CSG001","1001","SCR","1/JAN/2010","1","1","","","",
"CSG001","1002","SCR","1/JAN/2010","1","1","4/JAN/2010","","",
"CSG001","1003","SCR","1/JAN/2010","1","1","3/JAN/2010","3/JAN/2010","514876",
"CSG001","1004","SCR","1/JAN/2010","1","1","4/JAN/2010","5/JAN/2010","101415",
"CSG001","1005","SCR","15/JAN/2010","1","1","1/FEB/2010","5/FEB/2010","306185",
"CSG001","1006","SCR","18/FEB/2010","1","1","1/MAR/2010","1/MAR/2010","987435",
"CSG001","1007","SCR","4/APR/2010","2","2","14/APR/2010","14/APR/2010","098745",
"CSG001","1008","SCR","20/JUN/2010","2","3","26/JUN/2010","27/JUN/2010","123098",
)

rand<-tribble(
~rand_id,~tx_cd,~cohort,~strata,
"514876","PBO","1","Dummy strata1",
"101415","ACTIVE","1","Dummy strata1",
"306185","ACTIVE","1","Dummy strata1",
"987435","PBO","2","Dummy strata2",
"098745","PBO","2","Dummy strata2",
"123098","ACTIVE","2","Dummy strata2",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================