* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_EG_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_EG\SDTM_EG_LCSG001\SDTM_EG_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data ecg01;
   set ecg;
run;

data dm01;
   set dm;
run;

data se01;
   set se;
run;

data sv01;
   set sv;
run;

/*=========================================================
Reorganize the data collected to present the information as result of a test code
=========================================================*/

data eg01;
   set ecg01(in=a);
   length
      studyid usubjid $20
      egtestcd $8
      egtest egcat $40
      egorres egorresu egstresc egstresu $200
   ;
   studyid=study;
   domain="EG";
   usubjid=catx("-",study,pt);

   if egdt_raw ne "" then egdtc=put(input(egdt_raw,??date11.),yymmdd10.);
   egcat="ECG";

   egtestcd="HR";
   egtest="Heart Rate";
   egorres=hr_raw;
   if egorres ne "" then egorresu="beats/min";
   egstresc=egorres;
   if egstresc ne "" then egstresu="beats/min";
   if not missing(egstresc) then egstresn=input(egstresc,??best.);
   output;
   call missing(egtestcd,egtest,egorres,egorresu,egstresc,egstresu,egstresn);

   egtestcd="PR";
   egtest="PR Interval";
   egorres=pr_raw;
   if egorres ne "" then egorresu="msec";
   egstresc=egorres;
   if egstresc ne "" then egstresu="msec";
   if not missing(egstresc) then egstresn=input(egstresc,??best.);
   output;
   call missing(egtestcd,egtest,egorres,egorresu,egstresc,egstresu,egstresn);

   egtestcd="QT";
   egtest="QT Interval";
   egorres=qt_raw;
   if egorres ne "" then egorresu="msec";
   egstresc=egorres;
   if egstresc ne "" then egstresu="msec";
   if not missing(egstresc) then egstresn=input(egstresc,??best.);
   output;
   call missing(egtestcd,egtest,egorres,egorresu,egstresc,egstresu,egstresn);

   egtestcd="QRS";
   egtest="QRS Interval";
   egorres=qrs_raw;
   if egorres ne "" then egorresu="msec";
   egstresc=egorres;
   if egstresc ne "" then egstresu="msec";
   if not missing(egstresc) then egstresn=input(egstresc,??best.);
   output;
   call missing(egtestcd,egtest,egorres,egorresu,egstresc,egstresu,egstresn);

   egtestcd="QTC";
   egtest="QT Interval Corrected";
   egorres=qtc_raw;
   if egorres ne "" then egorresu="msec";
   egstresc=egorres;
   if egstresc ne "" then egstresu="msec";
   if not missing(egstresc) then egstresn=input(egstresc,??best.);
   output;
   call missing(egtestcd,egtest,egorres,egorresu,egstresc,egstresu,egstresn);

   egtestcd="INTP";
   egtest="Interpretation";
   if egintp in ("Abnormal Not Clinically Significant" "Abnormal Clinically Significant") then do;
      egorres="ABNORMAL";
      if egintp="Abnormal Clinically Significant" then egclsig="Y";
      else if egintp="Abnormal Not Clinically Significant" then egclsig="N";
   end;
   else if egintp="Normal" then do;
      egorres="NORMAL";
   end;
   egstresc=egorres;
   output;
run;

/*=========================================================
Create NOT DONE variable
=========================================================*/

data eg02;
   set eg01;
   if egorres = "" then do;
      egstat="NOT DONE";
   end;
run;

/*=========================================================
Create study day variable
=========================================================*/

proc sort data=eg02;
   by usubjid;
run;

data eg03;
   merge eg02(in=a) dm01(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a;
   rfstdt=input(substrn(rfstdtc,1,10),??yymmdd10.);
   egdt=input(substrn(egdtc,1,10),??yymmdd10.);

   if egdt ne . and rfstdt ne . then egdy=egdt-rfstdt+(egdt>=rfstdt);
run;

/*=========================================================
Create VISITNUM and VISIT variables
=========================================================*/

/*----------------------------------------------------------
Mapping the visits based on folder value
----------------------------------------------------------*/
data eg04;
   set eg03;
   length visit $40;
   if folder="SCR" then do;
      visit="SCREENING";
      visitnum=1;
   end;
   else if index(upcase(folder),"WEEK") then do;
      visit=upcase(folder);
      visitnum=100+input(compress(folder,,'kd'),best.);
   end;
   else if substrn(upcase(folder),1,2)="FU" then do;
      visit=tranwrd(upcase(folder),"FU","FOLLOW-UP ");
      visitnum=200+input(compress(folder,,'kd'),best.);
   end;
   else if substrn(folder,1,4)="UNS_" then do;
      visit="UNSCHEDULED";
      visitnum=999;
   end;
run;

/*----------------------------------------------------------
Remapping unscheduled visits using SV dataset
----------------------------------------------------------*/

data uns01(drop=visitnum visit)
     sched01;
   set eg04;
   if visitnum=999 then output uns01;
   else output sched01;
run;

proc sql;
   create table uns02 as
      select a.*,b.visitnum,b.visit
      from uns01 as a
      left join
      sv01 as b
      on a.usubjid=b.usubjid and svstdtc le egdtc le svendtc;
quit;

data eg05;
   set uns02 sched01;
run;

/*=========================================================
EPOCH variable creation
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
Compare egdtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=eg05;
   by usubjid;
run;

data eg06;
   merge eg05(in=a) epochdates;
   by usubjid;
   if a;
run;

data eg07;
   set eg06;
   ymd=egdtc;
   ym=substrn(egdtc,1,7);
   y=substrn(egdtc,1,4);
   length epoch $40;

   if length(egdtc)=10 then do;
      if ("" lt ss le ymd lt es) or (st="" and "" lt ss le ymd le es) then epoch="SCREENING";
      else if ("" lt st le ymd lt et)  then epoch="TREATMENT";
      else if "" lt sf le ymd le ef then epoch="FOLLOW-UP";
   end;
   else if length(egdtc)=7 then do;
      if "" lt substrn(ss,1,7) lt ym lt substrn(es,1,7) lt substrn(st,1,7) then epoch="SCREENING";
      else if "" lt substrn(st,1,7) lt ym lt substrn(et,1,7) lt substrn(sf,1,7) then epoch="TREATMENT";
      else if "" lt substrn(sf,1,7) le ym le substrn(ef,1,7) then epoch="FOLLOW-UP";
   end;
run;

/*=========================================================
Create baseline flag
=========================================================*/

/*----------------------------------------------------------
Subset the records meeting the baseline definition
----------------------------------------------------------*/

proc sort data=eg07 out=base01;
   by usubjid egtestcd egdtc;
   where "" lt egdtc le rfstdtc and (egorres ne "");
run;

/*----------------------------------------------------------
Identify the closest record to reference start date
----------------------------------------------------------*/

data base02;
   set base01;
   by usubjid egtestcd egdtc;
   if last.egtestcd;
run;

/*----------------------------------------------------------
Populate the baseline flag
----------------------------------------------------------*/

proc sort data=eg07;
   by usubjid egtestcd egdtc;
run;

data eg08;
   merge eg07(in=a) base02(in=b keep=usubjid egtestcd egdtc);
   by usubjid egtestcd egdtc;
   if b then egblfl="Y";
run;

/*=========================================================
Create egSEQ variable
=========================================================*/

proc sort data=eg08;
   by usubjid egcat egtestcd egdtc;
run;

data eg09;
   set eg08;
   by usubjid egcat egtestcd egdtc;
   if first.usubjid then egseq=1;
   else egseq+1;
run;

/*=========================================================
Assign attributes and keep only required variables
=========================================================*/

%let varlist=STUDYID DOMAIN USUBJID EGSEQ EGTESTCD EGTEST EGCAT EGORRES
EGORRESU EGSTRESC EGSTRESN EGSTRESU EGSTAT EGMETHOD EGBLFL VISITNUM VISIT EPOCH EGDTC EGDY EGCLSIG
;

data eg10;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   EGSEQ label='Sequence Number'
   EGTESTCD label='ECG Test or Examination Short Name'
   EGTEST label='ECG Test or Examination Name'
   EGCAT label='Category for ECG'
   EGORRES label='Result or Finding in Original Units'
   EGORRESU label='Original Units'
   EGSTRESC label='Character Result/Finding in Std Format'
   EGSTRESN label='Numeric Result/Finding in Standard Units'
   EGSTRESU label='Standard Units'
   EGSTAT label='Completion Status'
   EGMETHOD label='Method of Test or Examination'
   EGBLFL label='Baseline Flag'
   VISITNUM label='Visit Number'
   VISIT label='Visit Name'
   EPOCH label='Epoch'
   EGDTC label='Date/Time of ECG'
   EGDY label='Study Day of ECG'
   EGCLSIG label='Clinically Significant'

;
   set eg09;
   keep &varlist.;
run;

/*=========================================================
Create supplementary domain
=========================================================*/

/*----------------------------------------------------------
Transpose the non-parent domain variables
----------------------------------------------------------*/

%let suppvars=EGCLSIG;
proc sort data=eg10 out=suppeg01;
   by studyid domain usubjid egseq;
run;

proc transpose data=suppeg01 out=suppeg02(rename=(col1=qval) where=(qval ne "")) name=qnam label=qlabel;
   by studyid domain usubjid egseq;
   var &suppvars.;
run;

data suppeg03;
   attrib STUDYID label='Study Identifier'
      RDOMAIN label='Related Domain Abbreviation'
      USUBJID label='Unique Subject Identifier'
      IDVAR label='Identifying Variable'
      IDVARVAL label='Identifying Variable Value'
      QNAM label='Qualifier Variable Name'
      QLABEL label='Qualifier Variable Label'
      QVAL label='Data Value'
;
   retain studyid rdomain usubjid idvar idvarval qnam qlabel qval;
   set suppeg02;
   idvar="EGSEQ";
   idvarval=cats(egseq);
   rdomain=domain;
   drop domain egseq;
run;

/*=========================================================
Save final copies of the datasets with dataset labels
=========================================================*/

options validvarname=v7;

proc sort data=eg10 out=osCSG001.eg(label="ECG Test Results" drop=&suppvars.);
   by usubjid egseq;
run;

proc sort data=suppeg03 out=osCSG001.suppeg(label="Supplemental Qualifiers for EG");
   by usubjid idvar idvarval;
run;

/*=========================================================
Create xpt files
=========================================================*/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname eg xport "&xptpath.\eg.xpt";
libname suppeg xport "&xptpath.\suppeg.xpt";

proc copy in=osCSG001 out=eg;
   select eg;
run;

proc copy in=osCSG001 out=suppeg;
   select suppeg;
run;

libname eg;
libname suppeg;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;