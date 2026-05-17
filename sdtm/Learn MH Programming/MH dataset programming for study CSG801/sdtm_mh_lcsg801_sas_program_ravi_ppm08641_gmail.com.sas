* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_MH_LCSG801;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_MH\SDTM_MH_LCSG801\SDTM_MH_LCSG801;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data mh_1;
   set mh801_1;
run;

data mh_2;
   set mh801_2;
run;

data mh_3;
   set mh801_3;
run;

data dm01;
   set dm;
run;

/*=========================================================
Combine information from 3 raw datasets and create variables which are directly dependent on raw variables
=========================================================*/

data mh01;
   length mhterm $200;
   set mh_1(in=a) mh_2(in=b) mh_3(in=c);

   length source $10 studyid usubjid $14 mhcat $50;;

   if a then source="MH801_1";
   if b then source="MH801_2";
   if c then source="MH801_3";
   studyid=study;
   usubjid=catx("-",studyid,pt);
   domain="MH";

   if repeat=. then repeat=1;

   mhrefid=catx("-",source,put(repeat,z3.));
   if mhdat ne "" then mhdtc=catx("-",substrn(mhdat,1,4),substrn(mhdat,5,2),substrn(mhdat,7));
   if mhstdat ne "" then mhstdtc=catx("-",substrn(mhstdat,1,4),substrn(mhstdat,5,2),substrn(mhstdat,7));
   if mhendat ne "" then mhendtc=catx("-",substrn(mhendat,1,4),substrn(mhendat,5,2),substrn(mhendat,7));

   if a then do;
      mhterm=upcase(mhterm);
      mhcat="DIABETES";
      mhpresp="Y";
      mhoccur="Y";
      mhenrtpt="ONGOING";
      mhentpt=mhdtc;
   end;
   if b then do;
      mhscat="COMPLICATIONS";
      mhcat="DIABETES";
      mhpresp="Y";
      if mhoccur="Y" then do;
         mhenrtpt="ONGOING";
         mhentpt=mhdtc;
      end;
   end;
   if c then do;
      mhcat="GENERAL";
      if mhongo="Yes" then do;
         mhenrtpt="ONGOING";
         mhentpt=mhdtc;
      end;
   end;
run;

/*=========================================================
Create Study day variable
=========================================================*/
proc sort data=dm01;
   by usubjid;
run;

proc sort data=mh01;
   by usubjid;
run;

data mh02;
   merge mh01(in=a) dm01(in=b);
   by usubjid;
   if a;
run;

data mh03;
   set mh02;
   if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,yymmdd10.);
   if length(mhdtc) ge 10 then mhdt=input(mhdtc,yymmdd10.);
   if nmiss(mhdt,rfstdt)=0 then mhdy=mhdt-rfstdt+(mhdt>=rfstdt);

   format rfstdt mhdt date9.;
run;

/*=========================================================
Create sequence variable
=========================================================*/

proc sort data=mh03;
   by usubjid mhterm mhstdtc;
run;

data mh04;
   set mh03;
   by usubjid mhterm mhstdtc;
   if first.usubjid then mhseq=1;
   else mhseq+1;
run;

/*=========================================================
Assign attributes and keep only required variables
=========================================================*/

%let varlist=STUDYID DOMAIN USUBJID MHSEQ MHREFID MHTERM MHCAT MHSCAT MHPRESP MHOCCUR MHDTC MHSTDTC
MHENDTC MHDY MHENRTPT MHENTPT
;
data mh05;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   MHSEQ label='Sequence Number'
   MHREFID label='Reference ID'
   MHTERM label='Reported Term for the Medical History'
   MHCAT label='Category for Medical History'
   MHSCAT label='Subcategory for Medical History'
   MHPRESP label='Medical History Event Pre-Specified'
   MHOCCUR label='Medical History Occurrence'
   MHDTC label='Date/Time of History Collection'
   MHSTDTC label='Start Date/Time of Medical History Event'
   MHENDTC label='End Date/Time of Medical History Event'
   MHDY label='Study Day of History Collection'
   MHENRTPT label='End Relative to Reference Time Point'
   MHENTPT label='End Reference Time Point'
;
   set mh04;
   keep &varlist.;

run;

/*=========================================================
Save the final copy of the dataset with dataset label
=========================================================*/

data oscsg801.mh(label="Medical History");
   set mh05;
run;

/*=========================================================
Create xpt file
=========================================================*/

%let xptpath=%sysfunc(pathname(oscsg801))\xpt;

libname mh xport "&xptpath.\mh.xpt";

proc copy in=oscsg801 out=mh;
   select mh;
run;

libname mh;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;