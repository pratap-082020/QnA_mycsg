* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_EC_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_EC\SDTM_EC_LCSG001\SDTM_EC_LCSG001;

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

data ec01;
   set ipadmin01;
   length studyid usubjid $20;
   studyid=study;
   domain="EC";
   usubjid=catx("-",studyid,pt);
   ecdose=input(ipqty_raw,??best.);
   if ecdose ne . then ecdosu=ipqtyu;
   ecdosfrm="INJECTION";
   ecdosfrq="EVERY WEEK";
   ecroute="INTRAVENOUS";
   ecpstrg=input(ipconc,??best.);
   if ecpstrg ne . then ecpstrgu="ug/ml";
   ecadj=upcase(ipadj);
   epoch="TREATMENT";

   if ipstdt_raw ne "" then ipstdtc=put(input(ipstdt_raw,date11.),yymmdd10.);
   if ipsttm_raw ne "" then ipsttm=put(input(ipsttm_raw,time5.),tod6.);
   ecstdtc=catx('T',ipstdtc,ipsttm);
   ecendtc=ecstdtc;

run;

/*=========================================================
Create ECTRT variable by fetching the information from box dataset
=========================================================*/
proc sql;
   create table ec02 as
      select a.*,case
      when b.content="PBO" then "PLACEBO"
      when b.content="ACTIVE" then "ACTIVE"
      else ""
      end as ECTRT
      from ec01 as a
      left join
      box01 as b
      on a.ipboxid=b.kitid;
quit;

/*=========================================================
Create ECLOT variable by fetching the information from lot dataset
=========================================================*/

proc sql;
   create table ec03 as
      select a.*,b.lotnum as eclot
      from ec02 as a
      left join
      lot01 as b
      on a.ipboxid=b.kitid;
quit;

/*=========================================================
Create study day variables by fetching reference start date information from demographics
=========================================================*/

proc sort data=ec03;
   by usubjid;
run;

proc sort data=dm01;
   by usubjid;
run;

data ec04;
   merge ec03(in=a) dm01(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a;
   if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,??yymmdd10.);
   if length(ecstdtc) ge 10 then ecstdt=input(ecstdtc,??yymmdd10.);
   if length(ecendtc) ge 10 then ecendt=input(ecendtc,??yymmdd10.);

   if nmiss(ecstdt,rfstdt)=0 then ecstdy=ecstdt-rfstdt+(ecstdt>=rfstdt);
   if nmiss(ecendt,rfstdt)=0 then ecendy=ecendt-rfstdt+(ecendt>=rfstdt);

   format rfstdt ecstdt ecendt date9.;
run;

/*=========================================================
Create ECSEQ variable
=========================================================*/
proc sort data=ec04;
   by usubjid ectrt ecstdtc;
run;

data ec05;
   set ec04;
   by usubjid ectrt ecstdtc;
   if first.usubjid then ecseq=1;
   else ecseq+1;
run;

/*=========================================================
Create attributes and keep only required variables
=========================================================*/

%let varlist=STUDYID DOMAIN USUBJID ECSEQ ECTRT ECDOSE ECDOSU ECDOSFRM ECDOSFRQ ECROUTE ECLOT
ECPSTRG ECPSTRGU ECADJ EPOCH ECSTDTC ECENDTC ECSTDY ECENDY;

data ec06;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   ECSEQ label='Sequence Number'
   ECTRT label='Name of Treatment'
   ECDOSE label='Dose'
   ECDOSU label='Dose Units'
   ECDOSFRM label='Dose Form'
   ECDOSFRQ label='Dosing Frequency per Interval'
   ECROUTE label='Route of Administration'
   ECLOT label='Lot Number'
   ECPSTRG label='Pharmaceutical Strength'
   ECPSTRGU label='Pharmaceutical Strength Units'
   ECADJ label='Reason for Dose Adjustment'
   EPOCH label='Epoch'
   ECSTDTC label='Start Date/Time of Treatment'
   ECENDTC label='End Date/Time of Treatment'
   ECSTDY label='Study Day of Start of Treatment'
   ECENDY label='Study Day of End of Treatment'
   ;
   set ec05;
   keep &varlist.;
run;

/*=========================================================
Save final copy of the dataset along with dataset label
=========================================================*/
options validvarname=v7;

proc sort data=ec06 out=oscsg001.ec(label="Exposure as Collected");
   by usubjid ectrt ecstdtc;
run;

/*=========================================================
Create xpt files
=========================================================*/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname ec xport "&xptpath.\ec.xpt";

proc copy in=osCSG001 out=ec;
   select ec;
run;

libname ec;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;