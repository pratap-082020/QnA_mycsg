* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_DD_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_DD\SDTM_DD_L101\SDTM_DD_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Create variables which are directly based on raw data
=========================================================*/
/*----------------------------------------------------------
Create a separate record for each test collected using output statements
----------------------------------------------------------*/
data dd01;
   set dd_death;
   length usubjid $10 ddorres $200;
   studyid="MYCSG";
   domain="DD";
   usubjid=catx('-',studyid,subject);

   if not missing(dddat) then dddtc=put(input(dddat,date11.),yymmdd10.);

   length ddtestcd $8 ddtest $40;

   ddtestcd="ATUOPIND";
   ddtest="Autopsy Indicator";
   ddorres=autopsy;
   ddstresc=ddorres;
   output;

   call missing(ddtestcd,ddtest,ddorres,ddstresc);
   ddtestcd="PRCDTH";
   ddtest="Primary Cause of Death";
   ddorres=prmcaus;
   ddstresc=ddorres;
   prcdthsp=prmcaussp;
   output;

   call missing(ddtestcd,ddtest,ddorres,ddstresc,prcdthsp);
   if seccaus ne "" then do;
      ddtestcd="SECDTH";
      ddtest="Secondary Cause of Death";
      ddorres=seccaus;
      ddstresc=ddorres;
      output;
   end;

run;

/*=========================================================
Calculate study day
=========================================================*/

/*----------------------------------------------------------
Get RFSTDTC from DM into dd01 dataset
----------------------------------------------------------*/
proc sort data=dd01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data dd02;
   merge dd01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(dddtc) then dddt=input(dddtc,yymmdd10.);

   if nmiss(rfstdt,dddt)=0 then dddy=dddt-rfstdt+(dddt>=rfstdt);
   format rfstdt dddt date9.;
run;

/*=========================================================
Create DDSEQ variable
=========================================================*/

proc sort data=dd02;
   by usubjid ddtestcd dddtc;
run;

data dd03;
   set dd02;
   by usubjid ddtestcd dddtc;
   if first.usubjid then ddseq=1;
   else ddseq+1;
run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let ddvarlist=STUDYID DOMAIN USUBJID DDSEQ DDTESTCD DDTEST DDORRES DDSTRESC DDDTC DDDY PRCDTHSP
;

data dd(label='Death details');
   retain &ddvarlist.;
   set dd03;
   keep &ddvarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;