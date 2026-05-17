# ============================================================
# Downloaded from myCSG lesson content
# Lesson: SDTM_DS_LCSG001
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

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

eos<-tribble(
~study,~pt,~eoscat,~eotype,~eostdt_raw,~eoterm,
"CSG001","1002","End of Study","","5/JAN/2010","Withdrawl of consent",
"CSG001","1003","End of Study","","5/JAN/2010","Death",
"CSG001","1004","End of Study","","28/FEB/2010","Completed",
"CSG001","1006","End of Study","","25/MAR/2010","Adverse Event",
"CSG001","1007","End of Study","","12/JUN/2010","Completed",
"CSG001","1008","End of Study","","18/AUG/2010","Subject Request",
)

eoip<-tribble(
~study,~pt,~eoscat,~eotype,~eostdt_raw,~eoterm,
"CSG001","1004","End of Treatment","","25/JAN/2010","Completed",
"CSG001","1006","End of Treatment","","25/MAR/2010","Adverse Event",
"CSG001","1007","End of Treatment","","6/MAY/2010","Completed",
"CSG001","1008","End of Treatment","","15/JUL/2010","Subject Request",
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



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================