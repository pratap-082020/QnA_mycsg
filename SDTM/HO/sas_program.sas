* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_HO_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_HO\SDTM_HO_L101\SDTM_HO_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Create variables which are directly based on raw data
=========================================================*/
data ho01;
   set hosp;
   length usubjid $10 hoterm $200;
   studyid="MYCSG";
   domain="HO";
   usubjid=catx('-',studyid,subject);
   if recordposition ne . then hospid=put(recordposition,z3.);

   if not missing(hostdat) then hostdtc=put(input(hostdat,date11.),yymmdd10.);
   if not missing(hoendat) then hoendtc=put(input(hoendat,date11.),yymmdd10.);

   hoterm=hounit;

   if hoendat="" then do;
    hoenrtpt="ONGOING";
    hoentpt="END OF STUDY";
   end;
   *qnams mapping;
   horeas=horeas;
run;

/*=========================================================
Calculate study days
=========================================================*/

/*----------------------------------------------------------
Get RFSTDTC from DM into HO01 dataset
----------------------------------------------------------*/
proc sort data=ho01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data ho02;
   merge ho01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(hostdtc) then hostdt=input(hostdtc,yymmdd10.);
   if not missing(hoendtc) then hoendt=input(hoendtc,yymmdd10.);

   if nmiss(rfstdt,hostdt)=0 then hostdy=hostdt-rfstdt+(hostdt>=rfstdt);
   if nmiss(rfstdt,hoendt)=0 then hoendy=hoendt-rfstdt+(hoendt>=rfstdt);
   format rfstdt hostdt hoendt date9.;
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
Compare hostdtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=ho02 out=ho03;
   by usubjid;
run;

data ho04;
   merge ho03(in=a) epochdates;
   by usubjid;
   if a;
run;

data ho05;
   set ho04;
   ymd=hostdtc;
   length epoch $40;

   if ("" lt start_scr le ymd lt end_scr) or (start_trt="" and "" lt start_scr le ymd lt end_scr) then epoch="SCREENING";
   else if "" lt start_trt le ymd le end_trt then epoch="TREATMENT";
   else if "" lt start_fu lt ymd le end_fu then epoch="FOLLOW-UP";
run;

/*=========================================================
Create rpSEQ variable
=========================================================*/

proc sort data=ho05;
   by usubjid hoterm hostdtc hoendtc hospid;
run;

data ho06;
   set ho05;
   by usubjid hoterm hostdtc hoendtc hospid;
   if first.usubjid then hoseq=1;
   else hoseq+1;
run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let hovarlist=STUDYID DOMAIN USUBJID HOSEQ HOSPID HOTERM EPOCH HOSTDTC HOENDTC
HOSTDY HOENDY HOENRTPT HOENTPT HOREAS
;

data HO(label='Healthcare Encounters');
   retain &hovarlist.;
   set ho06;
   keep &hovarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;