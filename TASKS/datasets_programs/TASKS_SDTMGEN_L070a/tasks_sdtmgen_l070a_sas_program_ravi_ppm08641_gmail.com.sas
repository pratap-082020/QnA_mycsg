* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L070a;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L070a\TASKS_SDTMGEN_L070a;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Pool all raw date variable values into a single variable
=========================================================*/

data alldates01;
   length date $20;
   set adverse(rename=(aestdt_raw=date) keep=study pt aestdt_raw)
       adverse(rename=(aeendt_raw=date)  keep=study pt aeendt_raw)
       conmeds(rename=(cmstdt_raw=date) keep=study pt cmstdt_raw)
       conmeds(rename=(cmendt_raw=date) keep=study pt cmendt_raw)
       ecg(rename=(egdt_raw=date) keep=study pt egdt_raw)
       enrlment(rename=(icdt_raw=date) keep=study pt icdt_raw)
       enrlment(rename=(enrldt_raw=date) keep=study pt enrldt_raw)
       enrlment(rename=(randdt_raw=date) keep=study pt randdt_raw)
       eos(rename=(eostdt_raw=date) keep=study pt eostdt_raw)
       eoip(rename=(eostdt_raw=date) keep=study pt eostdt_raw)
       ipadmin(rename=(ipstdt_raw=date) keep=study pt ipstdt_raw)
       vitals(rename=(vsdt_raw=date) keep=study pt vsdt_raw)

   indsname=_x;

   indsname=_x;
run;

/*=========================================================
Convert the date values into ISO 8601 format
=========================================================*/

data alldates02;
   set alldates01;
   length day month year datec $10;
   day=scan(date,1,'/');
   month=upcase(scan(date,2,'/'));
   year=scan(date,3,'/');
   if month="JAN" then month="01";
   else if month="FEB" then month="02";
   else if month="MAR" then month="03";
   else if month="APR" then month="04";
   else if month="MAY" then month="05";
   else if month="JUN" then month="06";
   else if month="JUL" then month="07";
   else if month="AUG" then month="08";
   else if month="SEP" then month="09";
   else if month="OCT" then month="10";
   else if month="NOV" then month="11";
   else if month="DEC" then month="12";
   else month="-";

   dayn=input(day,??best.);
   yearn=input(year,??best.);

   if dayn ne . then dayc=put(dayn,z2.);
   else dayc="-";
   if yearn ne . then yearc=put(year,4.);
   else yearc="-";

   datec=strip(yearc)||"-"||strip(month)||"-"||strip(dayc);
   if compress(datec,"-")="" then datec="";

run;

/*----------------------------------------------------------
Pick the latest non-missing date for each subject
----------------------------------------------------------*/

proc sort data=alldates02 out=alldates03;
   by study pt datec;
   where datec ne "";
run;

data rfpendtc;
   set alldates03;
   by study pt datec;
   if last.pt;
   rfpendtc=datec;
   keep study pt rfpendtc;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;