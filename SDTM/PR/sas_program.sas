* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_PR_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_PR\SDTM_PR_L101\SDTM_PR_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Create variables which are directly based on raw data
=========================================================*/

data pr01;
   set transfusn;
   length usubjid $10 prstdtc prendtc $19;
   studyid="MYCSG";
   domain="PR";
   usubjid=catx('-',studyid,subject);
   if recordposition ne . then prspid=put(recordposition,z3.);
   prcat="TRANSFUSIONS";

   if not missing(prstdat) then prstdtc=put(input(prstdat,date11.),yymmdd10.);
   if not missing(prsttim) then prstdtc=catx("T",prstdtc,prsttim);

   if not missing(prendat) then prendtc=put(input(prendat,date11.),yymmdd10.);
   if not missing(prentim) then prendtc=catx("T",prendtc,prentim);

   prtrt=prtrt;
   prdose=input(prvol,??best.);
   prdosu=prvolu;
   prindc=prreas;

run;

/*=========================================================
Calculate study day
=========================================================*/

/*----------------------------------------------------------
Get RFSTDTC from DM
----------------------------------------------------------*/
proc sort data=pr01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data pr02;
   merge pr01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(prstdtc) then prstdt=input(prstdtc,?? yymmdd10.);
   if not missing(prendtc) then prendt=input(prendtc,?? yymmdd10.);

   if nmiss(rfstdt,prstdt)=0 then prstdy=prstdt-rfstdt+(prstdt>=rfstdt);
   if nmiss(rfstdt,prendt)=0 then prendy=prendt-rfstdt+(prendt>=rfstdt);

   format rfstdt prstdt prendt date9.;
run;

/*=========================================================
Create EPOCH variable
=========================================================*/
/*----------------------------------------------------------
Process SE dataset such start date and end date of each epoch comes onto a single record
----------------------------------------------------------*/
data se02;
   set se;

   length short $3;
   if epoch="SCREENING" then short="SCR";
   else if epoch="TREATMENT" then short="TRT";
   else if epoch="FOLLOW-UP" then short="FU";
run;

proc sort data=se02;
   by usubjid;
run;

proc transpose data=se02 out=epochstart(drop=_:) prefix=start_;
   by usubjid;
   var sestdtc;
   id short;
run;

proc transpose data=se02 out=epochend(drop=_:) prefix=end_;
   by usubjid;
   var seendtc;
   id short;
run;

data epochdates;
   merge epochstart epochend;
   by usubjid;
run;

/*----------------------------------------------------------
Compare prstdtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=pr02 out=pr03;
   by usubjid;
run;

data pr04;
   merge pr03(in=a) epochdates;
   by usubjid;
   if a;
run;

data pr05;
   set pr04;
   ymd=substrn(prstdtc,1,10);
   length epoch $40;

   if ("" lt start_scr le ymd lt end_scr) or (start_trt="" and "" lt start_scr le ymd le end_scr) then epoch="SCREENING";
   else if "" lt start_trt le ymd le end_trt then epoch="TREATMENT";
   else if "" lt start_fu lt ymd le end_fu then epoch="FOLLOW-UP";
run;
/*=========================================================
Create --SEQ variable
=========================================================*/

proc sort data=pr05;
   by usubjid prcat prtrt prstdtc prendtc;
run;

data pr06;
   set pr05;
   by usubjid prcat prtrt prstdtc prendtc;
   if first.usubjid then prseq=1;
   else prseq+1;
run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let prvarlist=STUDYID DOMAIN USUBJID PRSEQ PRSPID PRTRT PRCAT PRINDC PRDOSE PRDOSU EPOCH
PRSTDTC PRENDTC PRSTDY PRENDY
;

data pr(label='Procedures');
   retain &prvarlist.;
   set pr06;
   keep &prvarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;