* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_MH_L201;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_MH\SDTM_MH_L201\SDTM_MH_L201;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Create macro for ISO date creation
=========================================================*/
%macro createisodate(rawdatevar=,outdtcvar=);

%*-----------------------------------------------------------------------------;
%*extract individual components;
%*-----------------------------------------------------------------------------;

rday=input(scan(&rawdatevar.,1,' '),??best.);
rmonth=scan(&rawdatevar.,2,' ');
ryear=scan(&rawdatevar.,3,' ');

%*-----------------------------------------------------------------------------;
%*conver day and month values to two digit charcter values;
%*-----------------------------------------------------------------------------;

if rday ne . then rdayc=put(rday,z2.);
if rmonth not in ("UNK" "") then rmonthc=put(month(input(cats("01",rmonth,"1960"),date9.)),z2.);

%*-----------------------------------------------------------------------------;
%*concate components to create date in iso format;
%*-----------------------------------------------------------------------------;

&outdtcvar.=catx("-",ryear,rmonthc,rdayc);

%*-----------------------------------------------------------------------------;
%*set intermediate variables to null to prevent carrying forward between observations and
macro calls;
%*-----------------------------------------------------------------------------;

call missing(rday,rmonth,ryear,rdayc,rmonthc);

%mend createisodate;

/*=========================================================
Create basic macro for study day variables
=========================================================*/

%macro create_studyday(dtcvar=,dyvar=);

rfstdtn=input(rfstdtc,?? yymmdd10.);
&dtcvar.n=input(&dtcvar.,?? yymmdd10.);

format rfstdtn &dtcvar.n date9.;
if nmiss(rfstdtn,&dtcvar.n)=0 then &dyvar.=&dtcvar.n-rfstdtn+(&dtcvar.n>=rfstdtn);

%mend create_studyday;

/*=========================================================
Create macro for --SEQ variable creation
=========================================================*/
%macro createseq(indsn=,outdsn=,sortvars=,seqvar=);

proc sort data=&indsn. out=&outdsn.;
   by &sortvars.;
run;

data &outdsn.;
   set &outdsn.;
   by &sortvars.;
   if first.usubjid then &seqvar.=1;
   else &seqvar.+1;
run;

%mend createseq;

/*=========================================================
Create variables which are either assigned or directly based on raw variables
=========================================================*/
/*----------------------------------------------------------
Append all the raw datasets and create variables conditionally
As two separate recrods need to be  created from a single record in RCXHIST dataset, it is appended twice
in=opeartor is used to create temporary variables to identify the records coming from a specific dataset
----------------------------------------------------------*/
data mh01;
   set
   rmh(in=inrmh rename=(mhspid=rmhspid))
   rcxhist(in=indiag)
   rcxhist(in=recdiag where=(not missing(CXRECDAT_RAW)));

   *common variables across datasets;

   studyid="MYCSG";
   domain="MH";

   usubjid=catx("-",studyid,subject);

   *dataset specific variables;
   if inrmh then do;
      mhspid=catx("-","RMH",put(rmhspid,z3.));

      mhterm=strip(mhterm);
      mhcat=upcase(mhcat);

      *create ISO dates;

      %createisodate(rawdatevar=mhdat_raw,outdtcvar=mhdtc);
      %createisodate(rawdatevar=mhstdat_raw,outdtcvar=mhstdtc);
      %createisodate(rawdatevar=mhendat_raw,outdtcvar=mhendtc);
      output;
   end;
   if indiag or recdiag then do;
      mhspid=catx("-","RCXHIST",put(recordposition,z3.));

      mhterm=cxtumtyp;
      mhcat="CANCER HISTORY";

      length mhevdtyp $50;
      if indiag then do;
         mhevdtyp="INITIAL DIAGNOSIS";
         if input(substrn(dxdtc,1,9),date9.) ne . then mhstdtc=put(input(substrn(dxdtc,1,9),date9.),yymmdd10.);
         output;
      end;
      else if recdiag then do;
         mhevdtyp="MOST RECENT DIAGNOSIS";
         %createisodate(rawdatevar=CXRECDAT_RAW,outdtcvar=mhstdtc);
         output;
      end;
   end;

run;

/*=========================================================
Derive study day variables
=========================================================*/
/*----------------------------------------------------------
Get RFSTDTC into main dataset
----------------------------------------------------------*/
proc sort data=mh01;
   by studyid usubjid;
run;

proc sort data=dm;
   by studyid usubjid;
run;

data mh02;
   merge mh01(in=a)
         dm(in=b keep=studyid usubjid rfstdtc);
   by studyid usubjid;

   if a and b;
run;

data mh03;
   set mh02;

   *create study day variables;
   %create_studyday(dtcvar=mhdtc,dyvar=mhdy);
   %create_studyday(dtcvar=mhstdtc,dyvar=mhstdy);
   %create_studyday(dtcvar=mhendtc,dyvar=mhendy);
run;

/*=========================================================
Create variables which are dependent on other derived variables
=========================================================*/
data mh04;
   set mh03;

   if upcase(mhongo)="YES" then do;
      mhenrtpt="ONGOING";
      mhentpt=mhdtc;
   end;
run;

/*=========================================================
Create MHSEQ variable
=========================================================*/

%createseq(indsn=mh04,outdsn=mh05,sortvars=studyid usubjid mhterm mhstdtc,seqvar=mhseq);

/*=========================================================
Keep only the required variables
=========================================================*/

%let keepvars=STUDYID DOMAIN USUBJID MHSEQ MHSPID MHTERM MHEVDTYP MHCAT MHDTC MHSTDTC MHENDTC
MHDY MHSTDY MHENDY MHENRTPT MHENTPT
;

data mh;
   retain &keepvars.;
   keep &keepvars.;
   set mh05;

run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;