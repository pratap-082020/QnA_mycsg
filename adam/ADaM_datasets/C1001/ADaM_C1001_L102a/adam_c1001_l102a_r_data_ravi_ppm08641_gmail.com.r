# ============================================================
# Downloaded from myCSG lesson content
# Lesson: ADaM_C1001_L102a
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

dm<-tribble(
~usubjid,
"CSG-1001",
"CSG-1002",
"CSG-1003",
"CSG-1004",
"CSG-1005",
)

ex<-tribble(
~usubjid,~excat,~exdose,~exstdtc,~exendtc,
"CSG-1002","RUN-IN PERIOD",50,"2011-11-21","2011-12-06",
"CSG-1002","TREATMENT PERIOD",50,"2011-12-07","2012-03-01",
"CSG-1004","RUN-IN PERIOD",50,"2011-10-10","2011-10-23",
"CSG-1004","TREATMENT PERIOD",50,"2011-10-24","2012-01-16",
"CSG-1005","RUN-IN PERIOD",50,"2011-09-20","2011-10-03",
"CSG-1005","TREATMENT PERIOD",50,"2011-10-04","2011-10-04",
)

da<-tribble(
~usubjid,~datestcd,~dastresn,~visitnum,
"CSG-1002","DISPAMT",50,2,
"CSG-1002","RETAMT",50,3,
"CSG-1004","DISPAMT",50,2,
"CSG-1004","RETAMT",9,3,
"CSG-1005","DISPAMT",50,2,
"CSG-1005","RETAMT",7,3,
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================