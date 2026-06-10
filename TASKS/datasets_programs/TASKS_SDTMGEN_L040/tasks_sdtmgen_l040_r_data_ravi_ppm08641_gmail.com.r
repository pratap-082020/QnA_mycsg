# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L040
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

demog<-tribble(
~subject,~sex,~race,~ethnicity,~country,
"MYCSG1001",1,"AIAN","NOT HISPANIC OR LATINO","UNITED STATES OF AMERICA",
"MYCSG1002",2,"AS","NOT HISPANIC OR LATINO","INDIA",
"MYCSG1003",1,"BAA","NOT HISPANIC OR LATINO","JAPAN",
"MYCSG1004",1,"NHOP","NOT HISPANIC OR LATINO","UNITED STATES OF AMERICA",
"MYCSG1005",2,"WHITE","NOT REPORTED","UNITED STATES OF AMERICA",
"MYCSG1006",2,"NR","NOT HISPANIC OR LATINO","UNITED STATES OF AMERICA",
"MYCSG1007",1,"UNK","NOT HISPANIC OR LATINO","MEXICO",
"MYCSG1008",2,"WHITE","UNKNOWN","UNITED STATES OF AMERICA",
"MYCSG1009",1,"WHITE","HISPANIC OR LATINO","UNITED STATES OF AMERICA",
)

metadata<-tribble(
~variable,~collected_value,~standard_value,
"RACE","AIAN","AMERICAN INDIAN OR ALASKA NATIVE",
"RACE","AS","ASIAN",
"RACE","BAA","BLACK OR AFRICAN AMERICAN",
"RACE","NHOP","NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER",
"RACE","WHITE","WHITE",
"RACE","NR","NOT REPORTED",
"RACE","UNK","UNKNOWN",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================