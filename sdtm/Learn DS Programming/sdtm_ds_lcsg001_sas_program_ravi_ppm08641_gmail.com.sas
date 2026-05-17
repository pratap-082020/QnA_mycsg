* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_DS_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_DS\SDTM_DS_LCSG001\SDTM_DS_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data dm01;
   set dm;
run;

data enrl01;
   set enrlment;
run;

data eos01;
   set eos;
run;

data eoip01;
   set eoip;
run;

/*=========================================================
Create records that come from Enrollment Dataset
=========================================================*/

data protmil01;
   set enrl01;
   length studyid usubjid dsstdtc protvers cnstvers $20 dscat $30 dsdecod dsterm $200;
   studyid=study;
   usubjid=catx("-",study,pt);

   if not missing(icdt_raw) then do;
      dsstdtc=put(input(icdt_raw,?? date11.),yymmdd10.);
      dsterm="INFORMED CONSENT OBTAINED";
      dsdecod=dsterm;
      dscat="PROTOCOL MILESTONE";
      protvers=prtvers;
      cnstvers=icvers;
      output;
   end;
   call missing(dsstdtc,dsterm,dsdecod,dscat,cnstvers,protvers);

   if not missing(enrldt_raw) then do;
      dsstdtc=put(input(enrldt_raw,?? date11.),yymmdd10.);
      dsterm="ENROLLED";
      dsdecod="ELIGIBILITY CRITERIA MET";
      dscat="PROTOCOL MILESTONE";
      output;
   end;
   call missing(dsstdtc,dsterm,dsdecod,dscat,cnstvers,protvers);

   if not missing(randdt_raw) then do;
      dsstdtc=put(input(randdt_raw,?? date11.),yymmdd10.);
      dsterm="RANDOMIZED";
      dsdecod="RANDOMIZED";
      dscat="PROTOCOL MILESTONE";
      dsrefid=randno;
      output;
   end;
   keep studyid usubjid dsstdtc dscat dsdecod dsterm cnstvers protvers dsrefid;
run;

/*=========================================================
Create the records coming form EOIP raw dataset
=========================================================*/

data dispevnt01;
   set eoip01;
   length studyid usubjid dsstdtc $20 dscat dsscat $30 dsdecod dsterm $200;
   studyid=study;
   usubjid=catx("-",study,pt);

   if not missing(eostdt_raw) then do;
      dsstdtc=put(input(eostdt_raw,?? date11.),yymmdd10.);
      dsterm=eoterm;
      dsdecod=upcase(dsterm);
      dscat="DISPOSITION EVENT";
      dsscat="END OF INVESTIGATIONAL PRODUCT";
      output;
   end;
   keep studyid usubjid dsstdtc dscat dsscat dsdecod dsterm;
run;

/*=========================================================
Create the records coming form EOS raw dataset
=========================================================*/

data dispevnt02;
   set eos01;
   length studyid usubjid dsstdtc $20 dscat dsscat $30 dsdecod dsterm $200;
   studyid=study;
   usubjid=catx("-",study,pt);

   if not missing(eostdt_raw) then do;
      dsstdtc=put(input(eostdt_raw,?? date11.),yymmdd10.);
      dsterm=eoterm;
      dsdecod=upcase(dsterm);
      dscat="DISPOSITION EVENT";
      dsscat="END OF STUDY";
      output;
   end;
   keep studyid usubjid dsstdtc dscat dsscat dsdecod dsterm;
run;

/*=========================================================
Combine the records of protocol milestones and disposition events
=========================================================*/

data ds01;
   set protmil01 dispevnt01 dispevnt02;
   domain="DS";
run;

/*=========================================================
Create study day variable
=========================================================*/

proc sort data=ds01;
   by usubjid;
run;

proc sort data=dm01;
   by usubjid;
run;

data ds02;
   merge ds01(in=a) dm01(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a;
   if not missing(rfstdtc) then rfstdt=input(substrn(rfstdtc,1,10),??yymmdd10.);
   if not missing(dsstdtc) then dsstdt=input(substrn(dsstdtc,1,10),??yymmdd10.);

   if nmiss(rfstdt,dsstdt)=0 then dsstdy=dsstdt-rfstdt+(dsstdt ge rfstdt);

   format rfstdt dsstdt date9.;
run;

/*=========================================================
Create sequence variable
=========================================================*/

proc sort data=ds02 out=ds03;
   by usubjid dsstdtc;
run;

data ds03;
   set ds03;
   by usubjid dsstdtc;
   if first.usubjid then dsseq=1;
   else dsseq+1;
run;

/*=========================================================
Assign attributes to the variables and keep only required variables
=========================================================*/

%let keepvars=STUDYID   DOMAIN  USUBJID DSSEQ   DSREFID DSTERM  DSDECOD 
DSCAT   DSSCAT  DSSTDTC DSSTDY  PROTVERS    CNSTVERS
;

%let suppvars=PROTVERS  CNSTVERS;

data ds04;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   DSSEQ label='Sequence Number'
   DSREFID label='Reference ID'
   DSTERM label='Reported Term for the Disposition Event'
   DSDECOD label='Standardized Disposition Term'
   DSCAT label='Category for Disposition Event'
   DSSCAT label='Subcategory for Disposition Event'
   DSSTDTC label='Start Date/Time of Disposition Event'
   DSSTDY label='Study Day of Start of Disposition Event'
   PROTVERS label='Enrolled Protocol Version'
   CNSTVERS label='Enrolled Consent Version'
;
   set ds03;
   keep &keepvars;
run;

/*=========================================================
Create supplemetary domain
=========================================================*/

proc sort data=ds04 out=suppds01;
   by studyid domain usubjid dsseq;
run;

proc transpose data=suppds01 out=suppds02(rename=(col1=qval) where=(qval ne "")) name=qnam label=qlabel;
   by studyid domain usubjid dsseq;
   var &suppvars.;
run;

data suppds03;
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
   set suppds02;
   idvar="DSSEQ";
   idvarval=cats(dsseq);
   rdomain=domain;
   drop domain dsseq;
run;

/*=========================================================
Save final copies of the datasets with dataset labels
=========================================================*/

options validvarname=v7;

proc sort data=DS04 out=osCSG001.ds(label="Disposition" drop=&suppvars.);
   by usubjid;
run;

proc sort data=suppDS03 out=osCSG001.suppds(label="Supplemental Qualifiers for Disposition");
   by usubjid idvar idvarval;
run;

/*=========================================================
Create xpt files
=========================================================*/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname ds xport "&xptpath.\ds.xpt";

proc copy in=osCSG001 out=ds;
   select ds;
run;

libname suppds xport "&xptpath.\suppDS.xpt";

proc copy in=osCSG001 out=suppds;
   select suppds;
run;

libname ds;
libname suppds;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;