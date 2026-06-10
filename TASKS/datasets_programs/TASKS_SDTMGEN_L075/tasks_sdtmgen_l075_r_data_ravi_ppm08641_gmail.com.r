# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L075
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

eos<-tribble(
~study,~pt,~eoscat,~eotype,~eostdt_raw,~eoterm,
"CSG001","1002","End of Study","","5/JAN/2010","Withdrawl of consent",
"CSG001","1003","End of Study","","5/JAN/2010","Death",
"CSG001","1004","End of Study","","28/FEB/2010","Completed",
"CSG001","1006","End of Study","","25/MAR/2010","Adverse Event",
"CSG001","1007","End of Study","","12/JUN/2010","Completed",
"CSG001","1008","End of Study","","18/AUG/2010","Subject Request",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================