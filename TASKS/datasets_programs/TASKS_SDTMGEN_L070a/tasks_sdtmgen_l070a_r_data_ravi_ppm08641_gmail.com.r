# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TASKS_SDTMGEN_L070a
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

ipadmin<-tribble(
~study,~pt,~folder,~ipconc,~ipstdt_raw,~ipsttm_raw,~ipqty_raw,~ipqtyu,~ipadj,~ipboxid,
"CSG001","1004","WEEK 1","500","05/JAN/2010","8:35","2","mL","","13434371",
"CSG001","1004","WEEK 2","500","12/JAN/2010","8:35","2","mL","","52970539",
"CSG001","1004","WEEK 3","500","18/JAN/2010","9:30","1","mL","Adverse Event","52120567",
"CSG001","1004","WEEK 4","500","25/JAN/2010","8:45","2","mL","","59305202",
"CSG001","1005","WEEK 1","500","05/FEB/2010","8:46","2","mL","","13787377",
"CSG001","1005","WEEK 2","500","12/FEB/2010","8:30","2","mL","","65580239",
"CSG001","1005","WEEK 3","500","19/FEB/2010","8:15","0","mL","Adverse Event","45377264",
"CSG001","1006","WEEK 1","500","2/MAR/2010","8:30","1.9","mL","","39024101",
"CSG001","1006","WEEK 2","500","10/MAR/2010","8:30","2","mL","","65845489",
"CSG001","1007","WEEK 1","500","15/APR/2010","8:23","2","mL","","66223983",
"CSG001","1007","WEEK 2","500","22/APR/2010","9:00","2","mL","","71763169",
"CSG001","1007","WEEK 3","500","29/APR/2010","9:03","2","mL","","60038358",
"CSG001","1007","WEEK 4","500","6/MAY/2010","8:12","2","mL","","68706162",
"CSG001","1008","WEEK 1","500","27/JUN/2010","8:45","2","mL","","68891589",
"CSG001","1008","WEEK 2","500","4/JUL/2010","8:17","2","mL","","2311359",
"CSG001","1008","WEEK 3","500","11/JUL/2010","9:20","2","mL","","3199027",
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

ecg<-tribble(
~study,~pt,~folder,~egdt_raw,
"CSG001","1004","SCR","4/JAN/2010",
"CSG001","1005","SCR","5/FEB/2010",
"CSG001","1005","UNS_ECG","22/FEB/2010",
"CSG001","1006","SCR","1/MAR/2010",
"CSG001","1007","SCR","13/APR/2010",
)

vitals<-tribble(
~study,~pt,~folder,~vsdt_raw,
"CSG001","1004","SCR","02/JAN/2010",
"CSG001","1004","WEEK 2","12/JAN/2010",
"CSG001","1005","SCR","5/FEB/2010",
"CSG001","1005","WEEK 2","12/FEB/2010",
"CSG001","1005","UNS_VIT","22/FEB/2010",
"CSG001","1006","SCR","01/MAR/2010",
"CSG001","1006","WEEK 2","11/MAR/2010",
"CSG001","1007","SCR","15/APR/2010",
"CSG001","1007","WEEK 2","29/APR/2010",
)

eligcrit<-tribble(
~study,~pt,~folder,~elignum,~eligsp,
"CSG001","1001","SCR","INCL103","",
"CSG001","1001","SCR","EXCL103","",
"CSG001","1004","SCR","EXCL105","",
)

conmeds<-tribble(
~study,~pt,~cmvt,~cmstdt_raw,~cmendt_raw,
"CSG001","1004","OMEPRAZOLE","UN/UNK/2007","",
"CSG001","1006","PARACETAMOL","6/MAR/2010","25/MAR/2010",
"CSG001","1007","LOPERAMIDE","10/MAY/2010","12/MAY/2010",
)

adverse<-tribble(
~study,~pt,~aevt,~aestdt_raw,~aeendt_raw,
"CSG001","1001","nausea","01/JAN/2010","01/JAN/2010",
"CSG001","1003","CARDIAC ARREST","05/JAN/2010","05/JAN/2010",
"CSG001","1004","nausea","01/JAN/2010","01/JAN/2010",
"CSG001","1004","PAIN ABDOMINAL","03/JAN/2010","07/JAN/2010",
"CSG001","1004","PAIN ABDOMINAL","08/JAN/2010","09/JAN/2010",
"CSG001","1004","Neuropathy","10/JAN/2010","",
"CSG001","1005","GALLSTONES","18/FEB/2010","21/FEB/2010",
"CSG001","1006","MID LOWER BACK PAIN","UN/MAR/2010","25/MAR/2010",
"CSG001","1007","DIARRHEA","9/MAY/2010","12/MAY/2010",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================