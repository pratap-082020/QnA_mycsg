* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_DA_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_DA\SDTM_DA_L101\SDTM_DA_L101;

%include "&root2._data.sas";

options validvarname=upcase;

/*=========================================================
Create variables which are directly based on raw data
=========================================================*/
/*----------------------------------------------------------
Create a separate record for each test collected using output statements
----------------------------------------------------------*/
data da01;
   set drugacc;
   length usubjid $10;
   studyid="MYCSG";
   domain="DA";
   usubjid=catx('-',studyid,subject);
   if recordposition ne . then daspid=put(recordposition,z3.);
   darefid=refid;

   length datestcd $8 datest $40;
   datestcd="DISPAMT";
   datest="Dispensed Amount";

   if not missing(dispamt_dadat) then dadtc=put(input(dispamt_dadat,date11.),yymmdd10.);
   if missing(dispamt) then do;
      dastat="NOT DONE";
   end;
   else do;
      daorres=dispamt;
      daorresu=dispamtu;
      dastresc=daorres;
      dastresn=input(dastresc,??best.);
      dastresu=daorresu;
   end;

   output;
   call missing(dadtc,datestcd,datest,dastat,dareasnd,daorres,daorresu,dastresc,dastresn,dastresu);

   datestcd="RETAMT";
   datest="Returned Amount";
   if not missing(retamt_dadat) then dadtc=put(input(retamt_dadat,date11.),yymmdd10.);

   if missing(retamt) then do;
      dastat="NOT DONE";
   end;
   else do;
      daorres=retamt;
      daorresu=retamtu;
      dastresc=daorres;
      dastresn=input(dastresc,??best.);
      dastresu=daorresu;
   end;

   output;
   call missing(dadtc,datestcd,datest,dastat,dareasnd,daorres,daorresu,dastresc,dastresn,dastresu);

run;

/*=========================================================
Get RFSTDTC from DM into CV01 dataset
=========================================================*/

/*----------------------------------------------------------
Calculate study day
----------------------------------------------------------*/
proc sort data=da01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data da02;
   merge da01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(dadtc) then dadt=input(dadtc,yymmdd10.);

   if nmiss(rfstdt,dadt)=0 then dady=dadt-rfstdt+(dadt>=rfstdt);
   format rfstdt dadt date9.;
run;

/*=========================================================
Create EPOCH variable
=========================================================*/
/*----------------------------------------------------------
Process SE dataset such start date and end date of each epoch comes onto a single record
----------------------------------------------------------*/
data se02;
   set se;
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
Compare dadtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=da02 out=da03;
   by usubjid;
run;

data da04;
   merge da03(in=a) epochdates;
   by usubjid;
   if a;
run;

data da05;
   set da04;
   ymd=dadtc;
   length epoch $40;

   if ("" lt ss le ymd lt es) or (st="" and "" lt ss le ymd le es) then epoch="SCREENING";
   else if "" lt st le ymd le et then epoch="TREATMENT";
   else if "" lt sf lt ymd le ef then epoch="FOLLOW-UP";
run;

/*=========================================================
Create daSEQ variable
=========================================================*/

proc sort data=da05;
   by usubjid darefid datestcd dadtc;
run;

data da06;
   set da05;
   by usubjid darefid datestcd dadtc;
   if first.usubjid then daseq=1;
   else daseq+1;
run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let davarlist=STUDYID DOMAIN USUBJID DASEQ DAREFID DASPID DATESTCD DATEST
DAORRES DAORRESU DASTRESC DASTRESN DASTRESU DASTAT EPOCH DADTC DADY;

data da(label='Drug Accountability');
   retain &davarlist.;
   set da06;
   keep &davarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;