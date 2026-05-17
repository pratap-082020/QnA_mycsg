* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_CV_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_CV\SDTM_CV_L101\SDTM_CV_L101;

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
data cv01;
   set echo;
   length usubjid $10;
   studyid="MYCSG";
   domain="CV";
   usubjid=catx('-',studyid,subject);
   if recordposition ne . then cvspid=put(recordposition,z3.);
   cvcat="ECHOCARDIOGRAM";
   cvmethod="ECHOCARDIOGRAM";
   if not missing(echodat) then cvdtc=put(input(echodat,date11.),yymmdd10.);

   length cvtestcd $8 cvtest $40;
   if upcase(echo_yn)="NO" then do;
      cvstat="NOT DONE";
      cvreasnd="Not Collected";
      cvtestcd="CVALL";
      cvtest="Cardiovascular Test Results";
      output;
   end;
   else if upcase(echo_yn)="YES" then do;
      cvtestcd="LVEF";
      cvtest="Left Ventricular Ejection Fraction";
      if missing(lvef) then do;
         cvstat="NOT DONE";
         cvreasnd="Not Collected";
      end;
      else do;
         cvorres=lvef;
         cvorresu="%";
         cvstresc=cvorres;
         cvstresn=input(cvstresc,??best.);
         cvstresu=cvorresu;
      end;

      output;
      call missing(cvtestcd,cvtest,cvstat,cvreasnd,cvorres,cvorresu,cvstresc,cvstresn,cvstresu);
      cvtestcd="RVEF_E";
      cvtest="Right Ventricular Ejection Fraction, Est";
      if missing(rvef) then do;
         cvstat="NOT DONE";
         cvreasnd="Not Collected";
      end;
      else do;
         cvorres=rvef;
         cvorresu="%";
         cvstresc=cvorres;
         cvstresn=input(cvstresc,??best.);
         cvstresu=cvorresu;
      end;

      output;
      call missing(cvtestcd,cvtest,cvstat,cvreasnd,cvorres,cvorresu,cvstresc,cvstresn,cvstresu);

   end;
run;

/*=========================================================
Get RFSTDTC from DM into CV01 dataset
=========================================================*/

/*----------------------------------------------------------
Calculate study day
----------------------------------------------------------*/
proc sort data=cv01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data cv02;
   merge cv01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(cvdtc) then cvdt=input(cvdtc,yymmdd10.);

   if nmiss(rfstdt,cvdt)=0 then cvdy=cvdt-rfstdt+(cvdt>=rfstdt);
   format rfstdt cvdt date9.;
run;

/*=========================================================
Create VISITNUM and VISIT
=========================================================*/

/*----------------------------------------------------------
Use SV to fetch the sequenced unscheduled visit number
----------------------------------------------------------*/
data cv03;
   set cv02;
   length visit $50;
   visitnum=folderseq;
   visit=upcase(FOLDERNAME);
run;

data sched01 unsched01;
   set cv03;
   if find(visit,"UNSCHEDULED",'i') then output unsched01;
   else output sched01;
run;

proc sql;
   create table unsched02 as
      select a.*,b.visitnum,b.visit length=50
      from unsched01(drop=visitnum visit) as a
      left join
      sv as b
      on a.usubjid=b.usubjid and svstdtc le cvdtc le svendtc;
quit;

data cv04;
   set sched01 unsched02;
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
Compare cvdtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=cv04 out=cv05;
   by usubjid;
run;

data cv06;
   merge cv05(in=a) epochdates;
   by usubjid;
   if a;
run;

data cv07;
   set cv06;
   ymd=cvdtc;
   length epoch $40;

    if ("" lt start_scr le ymd lt end_scr) or (start_trt="" and "" lt start_scr le ymd lt end_scr) then epoch="SCREENING";
   else if "" lt start_trt le ymd le end_trt then epoch="TREATMENT";
   else if "" lt start_fu lt ymd le end_fu then epoch="FOLLOW-UP";
run;

/*=========================================================
Create baseline flag
=========================================================*/

/*----------------------------------------------------------
Subset the records meeting the baseline definition
----------------------------------------------------------*/
proc sort data=cv07 out=base01;
   by usubjid cvtestcd cvdtc;
   where "" lt cvdtc le rfstdtc and (cvorres ne "");
run;

/*----------------------------------------------------------
Identify the closest record to reference start date
----------------------------------------------------------*/

data base02;
   set base01;
   by usubjid cvtestcd cvdtc;
   if last.cvtestcd;
run;

/*----------------------------------------------------------
Populate the baseline flag
----------------------------------------------------------*/

proc sort data=cv07;
   by usubjid cvtestcd cvdtc;
run;

data cv08;
   merge cv07(in=a) base02(in=b keep=usubjid cvtestcd cvdtc);
   by usubjid cvtestcd cvdtc;
   if b then cvblfl="Y";
run;

/*=========================================================
Create cvSEQ variable
=========================================================*/

proc sort data=cv08;
   by usubjid cvcat cvtestcd cvdtc;
run;

data cv09;
   set cv08;
   by usubjid cvcat cvtestcd cvdtc;
   if first.usubjid then cvseq=1;
   else cvseq+1;
run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let cvvarlist=STUDYID DOMAIN USUBJID CVSEQ CVSPID CVTESTCD CVTEST CVCAT
CVORRES CVORRESU CVSTRESC CVSTRESN CVSTRESU CVSTAT CVREASND CVMETHOD CVBLFL VISITNUM VISIT
EPOCH CVDTC CVDY;

data cv(label='Cardiovascular System Findings');
   retain &cvvarlist.;
   set cv09;
   keep &cvvarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;