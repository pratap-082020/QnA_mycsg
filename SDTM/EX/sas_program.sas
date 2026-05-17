* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_EX_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_EX\SDTM_EX_LCSG001\SDTM_EX_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data ipadmin01;
   set ipadmin;
run;

data dm01;
   set dm;
run;

data sv01;
   set sv;
run;

data se01;
   set se;
run;

data box01;
   set box;
run;

data lot01;
   set lot;
run;

/*=========================================================
Create variables which are directly based on source variables
=========================================================*/

data ex01;
   set ipadmin01;
   length studyid usubjid $20;
   studyid=study;
   domain="EX";
   usubjid=catx("-",studyid,pt);
   ipcon=input(ipconc,??best.);
   ipqty=input(ipqty_raw,??best.);
   if ipcon ne . and ipqty ne . then exdose=ipcon*ipqty;
   if exdose ne . then exdosu="ug";
   exdosfrm="INJECTION";
   exdosfrq="EVERY WEEK";
   exroute="INTRAVENOUS";
   exadj=upcase(ipadj);
   epoch="TREATMENT";

   if ipstdt_raw ne "" then ipstdtc=put(input(ipstdt_raw,date11.),yymmdd10.);
   if ipsttm_raw ne "" then ipsttm=put(input(ipsttm_raw,time5.),tod6.);
   exstdtc=catx('T',ipstdtc,ipsttm);
   exendtc=exstdtc;

run;

/*=========================================================
Create EXTRT variable by fetching the information from box dataset
=========================================================*/
proc sql;
   create table ex02 as
      select a.*,case
      when b.content="PBO" then "PLACEBO"
      when b.content="ACTIVE" then "ACTIVE"
      else ""
      end as EXTRT
      from ex01 as a
      left join
      box01 as b
      on a.ipboxid=b.kitid;
quit;

/*=========================================================
Create EXLOT variable by fetching the information from lot dataset
=========================================================*/

proc sql;
   create table ex03 as
      select a.*,b.lotnum as exlot
      from ex02 as a
      left join
      lot01 as b
      on a.ipboxid=b.kitid;
quit;

/*=========================================================
Create study day variables by fetching reference start date information from demographics
=========================================================*/

proc sort data=ex03;
   by usubjid;
run;

proc sort data=dm01;
   by usubjid;
run;

data ex04;
   merge ex03(in=a) dm01(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a;
   if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,??yymmdd10.);
   if length(exstdtc) ge 10 then exstdt=input(exstdtc,??yymmdd10.);
   if length(exendtc) ge 10 then exendt=input(exendtc,??yymmdd10.);

   if nmiss(exstdt,rfstdt)=0 then exstdy=exstdt-rfstdt+(exstdt>=rfstdt);
   if nmiss(exendt,rfstdt)=0 then exendy=exendt-rfstdt+(exendt>=rfstdt);

   if extrt="PLACEBO" then exdose=0;
   format rfstdt exstdt exendt date9.;
run;

/*=========================================================
Create EXSEQ variable
=========================================================*/
proc sort data=ex04;
   by usubjid extrt exstdtc;
run;

data ex05;
   set ex04;
   by usubjid extrt exstdtc;
   if first.usubjid then exseq=1;
   else exseq+1;
run;

/*=========================================================
Create attributes and keep only required variables
=========================================================*/

%let varlist=STUDYID DOMAIN USUBJID EXSEQ EXTRT EXDOSE EXDOSU EXDOSFRM EXDOSFRQ EXROUTE EXLOT
EXADJ EPOCH EXSTDTC EXENDTC EXSTDY EXENDY;

data ex06;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   EXSEQ label='Sequence Number'
   EXTRT label='Name of Treatment'
   EXDOSE label='Dose'
   EXDOSU label='Dose Units'
   EXDOSFRM label='Dose Form'
   EXDOSFRQ label='Dosing Frequency per Interval'
   EXROUTE label='Route of Administration'
   EXLOT label='Lot Number'
   EXADJ label='Reason for Dose Adjustment'
   EPOCH label='Epoch'
   EXSTDTC label='Start Date/Time of Treatment'
   EXENDTC label='End Date/Time of Treatment'
   EXSTDY label='Study Day of Start of Treatment'
   EXENDY label='Study Day of End of Treatment'
   ;
   set ex05;
   keep &varlist.;
run;

/*=========================================================
Save final copy of the dataset along with dataset label
=========================================================*/
options validvarname=v7;

proc sort data=ex06 out=oscsg001.ex(label="Exposure");
   by usubjid extrt exstdtc;
run;

/*=========================================================
Create xpt files
=========================================================*/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname ex xport "&xptpath.\ex.xpt";

proc copy in=osCSG001 out=ex;
   select ex;
run;

libname ex;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;