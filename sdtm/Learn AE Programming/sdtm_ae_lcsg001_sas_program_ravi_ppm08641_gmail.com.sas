* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_AE_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_AE\SDTM_AE_LCSG001\SDTM_AE_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data ae01;
   set adverse;
run;

data dm01;
   set dm;
run;

data se01;
   set se;
run;

/*=========================================================
Create variables which are directly based on the existing raw variables
=========================================================*/

data ae02;
   length domain $2
          studyid usubjid $20
          aeacn $30;
   set ae01;
   where aevt ne "";

   studyid=study;
   usubjid=catx('-',study,pt);
   domain="AE";
   aeterm=aevt;
   aellt=aellt;
   aedecod=aedecod;
   aecat=aecat;
   aebodsys=aebodsys;
   aesev=upcase(aesev);

   if upcase(aeser)="YES" then aeser="Y";
   else if upcase(aeser)="NO" then aeser="N";

   if upcase(aeacn)="NO ACTION TAKEN" then aeacn="DOSE NOT CHANGED";
   else aeacn=upcase(AEACN);

   aeacnoth=aeacnoth;

   if upcase(aerel)="YES" then aerel="Y";
   else if upcase(aerel)="NO" then aerel="N";

   aeout=upcase(aeout);

   if upcase(scong)="YES" then aescong="Y";
   else if upcase(scong)="NO" then aescong="N";

   if upcase(sdisab)="YES" then aesdisab="Y";
   else if upcase(sdisab)="NO" then aesdisab="N";

   if upcase(sdeath)="YES" then aesdth="Y";
   else if upcase(sdeath)="NO" then aescong="N";

   if upcase(shosp)="YES" then aeshosp="Y";
   else if upcase(shosp)="NO" then aeshosp="N";

   if upcase(slife)="YES" then aeslife="Y";
   else if upcase(slife)="NO" then aeslife="N";

   if upcase(smie)="YES" then aesmie="Y";
   else if upcase(smie)="NO" then aesmie="N";

   stdayn=input(scan(aestdt_raw,1,'/'),?? best.);
   if stdayn ne . then stday=put(stdayn,z2.);

   stmonthc=upcase(scan(aestdt_raw,2,'/'));
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
   styear=scan(aestdt_raw,3,'/');
   if styear="UNK" then styear="";

   aestdtc=catx("-",styear,stmonth,stday);

   endayn=input(scan(aeendt_raw,1,'/'),?? best.);
   if endayn ne . then enday=put(endayn,z2.);

   enmonthc=upcase(scan(aeendt_raw,2,'/'));
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
   enyear=scan(aeendt_raw,3,'/');
   if enyear="UNK" then enyear="";

   aeendtc=catx("-",enyear,enmonth,enday);
run;

/*=========================================================
Derive study day variables and AETRTEM
=========================================================*/

proc sort data=ae02;
   by usubjid;
run;

proc sort data=dm01;
   by usubjid;
run;

data ae03;
   merge ae02(in=a) dm01(in=b keep=usubjid rfstdtc rfxendtc);
   by usubjid;
   if a;
   if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,yymmdd10.);
   if length(aestdtc) ge 10 then aestdt=input(aestdtc,yymmdd10.);
   if length(aeendtc) ge 10 then aeendt=input(aeendtc,yymmdd10.);
   if rfxendtc ne "" then rfxendt=input(substrn(rfxendtc,1,10),??yymmdd10.);

   if rfxendt ne . then rfxen15dtc=put(rfxendt+15,yymmdd10.);

   if n(aestdt,rfstdt)=2 then aestdy=aestdt-rfstdt+(aestdt>=rfstdt);

   if aeendt ne . and rfstdt ne . then do;
      if aeendt ge rfstdt then aeendy=aeendt-rfstdt+1;
      else aeendy=aeendt-rfstdt;
   end;

   if prefdose="Y" then aetrtem="N";
   else if "" lt substrn(rfstdtc,1,10) le aestdtc le rfxen15dtc then aetrtem="Y";
   else if aestdtc ne "" then aetrtem="N";

   format aestdt aeendt rfstdt rfxendt date9.;
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
Compare AESTDTC with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

data ae04;
   merge ae03(in=a) epochdates;
   by usubjid;
   if a;
run;

data ae05;
   set ae04;
   ymd=aestdtc;
   ym=substrn(aestdtc,1,7);
   y=substrn(aestdtc,1,4);
   length epoch $40;

   if length(aestdtc)=10 then do;
      if ("" lt ss le ymd lt es) or (st="" and "" lt ss le ymd le es) then epoch="SCREENING";
      else if "" lt st le ymd lt et then epoch="TREATMENT";
      else if "" lt sf le ymd le ef then epoch="FOLLOW-UP";
   end;
   else if length(aestdtc)=7 then do;
      if "" lt substrn(ss,1,7) lt ym lt substrn(es,1,7) lt substrn(st,1,7) then epoch="SCREENING";
      else if "" lt substrn(st,1,7) lt ym lt substrn(et,1,7) lt substrn(sf,1,7) then epoch="TREATMENT";
      else if "" lt substrn(sf,1,7) le ym le substrn(ef,1,7) then epoch="FOLLOW-UP";
   end;
run;

/*=========================================================
Create AESEQ variable
=========================================================*/

proc sort data=ae05;
   by usubjid aedecod aestdtc;
run;

data ae06;
   set ae05;
   by usubjid aedecod aestdtc;
   if first.usubjid then aeseq=1;
   else aeseq+1;
run;

/*=========================================================
Assign attributes and keep only required variables
=========================================================*/

%let varlist=STUDYID DOMAIN USUBJID AESEQ AETERM AELLT AEDECOD AECAT AEBODSYS AESEV AESER
AEACN AEACNOTH AEREL AEOUT AESCONG AESDISAB AESDTH AESHOSP AESLIFE AESMIE EPOCH AESTDTC
AEENDTC AESTDY AEENDY PREFDOSE AETRTEM
;

data ae07;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   AESEQ label='Sequence Number'
   AETERM label='Reported Term for the Adverse Event'
   AELLT label='Lowest Level Term'
   AEDECOD label='Dictionary-Derived Term'
   AECAT label='Category for Adverse Event'
   AEBODSYS label='Body System or Organ Class'
   AESEV label='Severity/Intensity'
   AESER label='Serious Event'
   AEACN label='Action Taken with Study Treatment'
   AEACNOTH label='Other Action Taken'
   AEREL label='Causality'
   AEOUT label='Outcome of Adverse Event'
   AESCONG label='Congenital Anomaly or Birth Defect'
   AESDISAB label='Persist or Signif Disability/Incapacity'
   AESDTH label='Results in Death'
   AESHOSP label='Requires or Prolongs Hospitalization'
   AESLIFE label='Is Life Threatening'
   AESMIE label='Other Medically Important Serious Event'
   EPOCH label='Epoch'
   AESTDTC label='Start Date/Time of Adverse Event'
   AEENDTC label='End Date/Time of Adverse Event'
   AESTDY label='Study Day of Start of Adverse Event'
   AEENDY label='Study Day of End of Adverse Event'
   PREFDOSE label='Prior to First Dose?'
   AETRTEM label='Treatment Emergent Flag'
;
   set ae06;
   keep &varlist.;
run;

/*=========================================================
Create supplementary domain
=========================================================*/

/*----------------------------------------------------------
Transpose the non-parent domain variables
----------------------------------------------------------*/

%let suppvars=PREFDOSE AETRTEM;
proc sort data=ae07 out=suppae01;
   by studyid domain usubjid aeseq;
run;

proc transpose data=suppae01 out=suppae02(rename=(col1=qval) where=(qval ne "")) name=qnam label=qlabel;
   by studyid domain usubjid aeseq;
   var &suppvars.;
run;

data suppae03;
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
   set suppae02;
   idvar="AESEQ";
   idvarval=cats(aeseq);
   rdomain=domain;
   drop domain aeseq;
run;

/*=========================================================
Save final copies of the datasets with dataset labels
=========================================================*/

options validvarname=v7;

proc sort data=ae07 out=osCSG001.ae(label="Adverse Events" drop=&suppvars.);
   by usubjid;
run;

proc sort data=suppae03 out=osCSG001.suppae(label="Supplemental Qualifiers for AE");
   by usubjid idvar idvarval;
run;

/*=========================================================
Create xpt files
=========================================================*/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname ae xport "&xptpath.\ae.xpt";

proc copy in=osCSG001 out=ae;
   select ae;
run;

libname suppae xport "&xptpath.\suppae.xpt";

proc copy in=osCSG001 out=suppae;
   select suppae;
run;

libname ae;
libname suppae;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;