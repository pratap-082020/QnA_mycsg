* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_CM_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_CM\SDTM_CM_LCSG001\SDTM_CM_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data conmeds01;
   set conmeds;
run;

data dm01;
   set dm;
run;

data se01;
   set se;
run;

/*=========================================================
Create variables which are directly dependent on raw variables
=========================================================*/

data cm01;
   set conmeds01;
   length studyid usubjid $50 cmdosu $200;
   studyid=study;
   usubjid=catx("-",study,pt);
   domain="CM";
   cmtrt=cmvt;
   cmdecod=cmpt;
   cmcat=upcase(cmcat);
   cmindc=cmindc;
   if input(cmdose_raw,??best.) ne . then cmdose=input(cmdose_raw,??best.);
   if cmdose=. then cmdostxt=cmdose_raw;
   if cmdosu_raw="Milligram" then cmdosu="mg";
   else cmdosu=cmdosu_raw;
   if cmdosfrq="Daily" then cmdosfrq="QD";
   else if cmdosfrq="As needed" then cmdosfrq="PRN";
   cmroute=route;

   stdayn=input(scan(cmstdt_raw,1,'/'),?? best.);
   if stdayn ne . then stday=put(stdayn,z2.);

   stmonthc=upcase(scan(cmstdt_raw,2,'/'));
   if stmonthc="JAN" then stmonth="01";
   else if stmonthc="FEB" then stmonth="02";
   else if stmonthc="MAR" then stmonth="03";
   else if stmonthc="APR" then stmonth="04";
   else if stmonthc="MAY" then stmonth="05";
   else if stmonthc="JUN" then stmonth="06";
   else if stmonthc="JUL" then stmonth="07";
   else if stmonthc="AUG" then stmonth="08";
   else if stmonthc="SEP" then stmonth="09";
   else if stmonthc="OCT" then stmonth="10";
   else if stmonthc="NOV" then stmonth="11";
   else if stmonthc="DEC" then stmonth="12";
   styear=scan(cmstdt_raw,3,'/');
   if styear="UNK" then styear="";

   cmstdtc=catx("-",styear,stmonth,stday);

   endayn=input(scan(cmendt_raw,1,'/'),?? best.);
   if endayn ne . then enday=put(endayn,z2.);

   enmonthc=upcase(scan(cmendt_raw,2,'/'));
   if enmonthc="JAN" then enmonth="01";
   else if enmonthc="FEB" then enmonth="02";
   else if enmonthc="MAR" then enmonth="03";
   else if enmonthc="APR" then enmonth="04";
   else if enmonthc="MAY" then enmonth="05";
   else if enmonthc="JUN" then enmonth="06";
   else if enmonthc="JUL" then enmonth="07";
   else if enmonthc="AUG" then enmonth="08";
   else if enmonthc="SEP" then enmonth="09";
   else if enmonthc="OCT" then enmonth="10";
   else if enmonthc="NOV" then enmonth="11";
   else if enmonthc="DEC" then enmonth="12";
   enyear=scan(cmendt_raw,3,'/');
   if enyear="UNK" then enyear="";

   cmendtc=catx("-",enyear,enmonth,enday);
run;

/*=========================================================
Derive study day variables
=========================================================*/

proc sort data=cm01 out=cm02;
   by usubjid;
run;

proc sort data=dm01;
   by usubjid;
run;

data cm03;
   merge cm02(in=a) dm01(in=b keep=usubjid rfstdtc rfxendtc);
   by usubjid;
   if a;
   if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,yymmdd10.);
   if length(cmstdtc) ge 10 then cmstdt=input(cmstdtc,yymmdd10.);
   if length(cmendtc) ge 10 then cmendt=input(cmendtc,yymmdd10.);
   if rfxendtc ne "" then rfxendt=input(substrn(rfxendtc,1,10),??yymmdd10.);

   if n(cmstdt,rfstdt)=2 then cmstdy=cmstdt-rfstdt+(cmstdt>=rfstdt);

   if cmendt ne . and rfstdt ne . then do;
      if cmendt ge rfstdt then cmendy=cmendt-rfstdt+1;
      else cmendy=cmendt-rfstdt;
   end;
   format cmstdt cmendt rfstdt rfxendt date9.;
run;

/*=========================================================
Derive EPOCH variable
=========================================================*/

/*----------------------------------------------------------
Process SE dataset such start date and end date of each epoch comes onto a single record
----------------------------------------------------------*/

data se02;
   set se01;
   short=substrn(epoch,1,1);
run;

proc sort data=se02;
   by usubjid;
run;

proc transpose data=se02 out=epochstart(drop=_:) prefix=s;
   by usubjid;
   var sestdtc;
   id short;
run;

proc transpose data=se02 out=epochend(drop=_:) prefix=e;
   by usubjid;
   var seendtc;
   id short;
run;

data epochdates;
   merge epochstart epochend;
   by usubjid;
run;

/*----------------------------------------------------------
Compare cmSTDTC with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

data cm04;
   merge cm03(in=a) epochdates;
   by usubjid;
   if a;
run;

data cm05;
   set cm04;
   ymd=cmstdtc;
   ym=substrn(cmstdtc,1,7);
   y=substrn(cmstdtc,1,4);
   length epoch $40;

   if length(cmstdtc)=10 then do;
      if ("" lt ss le ymd lt es) or (st="" and "" lt ss le ymd le es) then epoch="SCREENING";
      else if "" lt st le ymd lt et then epoch="TREATMENT";
      else if "" lt sf le ymd le ef then epoch="FOLLOW-UP";
   end;
   else if length(cmstdtc)=7 then do;
      if "" lt substrn(ss,1,7) lt ym lt substrn(es,1,7) lt substrn(st,1,7) then epoch="SCREENING";
      else if "" lt substrn(st,1,7) lt ym lt substrn(et,1,7) lt substrn(sf,1,7) then epoch="TREATMENT";
      else if "" lt substrn(sf,1,7) le ym le substrn(ef,1,7) then epoch="FOLLOW-UP";
   end;
   else if length(cmstdtc)=4 then do;
      if "" lt substrn(ss,1,4) lt y lt substrn(es,1,4) lt substrn(st,1,4) then epoch="SCREENING";
      else if "" lt substrn(st,1,4) lt y lt substrn(et,1,4) lt substrn(sf,1,4) then epoch="TREATMENT";
      else if "" lt substrn(sf,1,4) le y le substrn(ef,1,4) then epoch="FOLLOW-UP";
   end;
run;

/*=========================================================
Create cmSEQ variable
=========================================================*/

proc sort data=cm05;
   by usubjid cmdecod cmstdtc;
run;

data cm06;
   set cm05;
   by usubjid cmdecod cmstdtc;
   if first.usubjid then cmseq=1;
   else cmseq+1;
run;

/*=========================================================
Assign attributes and keep only the required variables in the dataset
=========================================================*/

%let varlist=STUDYID DOMAIN USUBJID CMSEQ CMTRT CMDECOD CMCAT CMINDC CMDOSE CMDOSTXT
CMDOSU CMDOSFRQ CMROUTE EPOCH CMSTDTC CMENDTC CMSTDY CMENDY
;

data cm07;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   CMSEQ label='Sequence Number'
   CMTRT label='Reported Name of Drug, Med, or Therapy'
   CMDECOD label='Standardized Medication Name'
   CMCAT label='Category for Medication'
   CMINDC label='Indication'
   CMDOSE label='Dose per Administration'
   CMDOSTXT label='Dose Description'
   CMDOSU label='Dose Units'
   CMDOSFRQ label='Dosing Frequency per Interval'
   CMROUTE label='Route of Administration'
   EPOCH label='Epoch'
   CMSTDTC label='Start Date/Time of Medication'
   CMENDTC label='End Date/Time of Medication'
   CMSTDY label='Study Day of Start of Medication'
   CMENDY label='Study Day of End of Medication'
   ;
   set cm06;
   keep &varlist.;
run;

/*=========================================================
Save final copies of the datasets with dataset labels
=========================================================*/

options validvarname=v7;

proc sort data=cm07 out=osCSG001.cm(label="Concomitant Medications");
   by usubjid;
run;

/*=========================================================
Create xpt files
=========================================================*/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname cm xport "&xptpath.\cm.xpt";

proc copy in=osCSG001 out=cm;
   select cm;
run;

libname cm;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;