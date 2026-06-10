# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L104
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

visit_mapping<-tribble(
  ~collected_visitnum,~collected_visit,~visitnum,~visit,~visitdy,
  6,"Screening",101,"SCREENING",-28,
  7,"Day 1",201,"DAY 1",1,
  8,"Day 3",202,"DAY 3",3,
  9,"Day 7",203,"DAY 7",7,
  10,"Day 14",204,"DAY 14",14,
  11,"Day 21",205,"DAY 21",21,
  12,"Day 28 EOT",206,"DAY 28 EOT",28,
  13,"EOT + 2 Weeks",301,"EOT + 2 WEEKS",42,
  14,"EOT + 8 Weeks",302,"EOT + 8 WEEKS",84,
  23,"Unscheduled Visit",9999,"Unscheduled Visit",NA,
)

echo<-tribble(
  ~study,~pt,~folderseq,~foldername,~echodat_raw,~lvef,~rvef,
  "MYCSG","1001",6,"Screening","15 DEC 2009",67,60,
  "MYCSG","1001",7,"Day 1","1 JAN 2009",67,60,
  "MYCSG","1001",8,"Day 3","3 JAN 2009",67,60,
  "MYCSG","1001",9,"Day 7","7 JAN 2009",67,60,
  "MYCSG","1001",10,"Day 14","14 JAN 2009",67,60,
  "MYCSG","1001",23,"Unscheduled Visit","17 JAN 2009",67,60,
  "MYCSG","1001",11,"Day 21","21 JAN 2009",67,60,
  "MYCSG","1001",12,"Day 28 EOT","28 JAN 2009",67,60,
  "MYCSG","1001",13,"EOT + 2 Weeks","14 FEB 2009",67,60,
  "MYCSG","1001",14,"EOT + 8 Weeks","5 MAR 2009",67,60,
)


# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================