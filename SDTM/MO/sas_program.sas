* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_MO_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_MO\SDTM_MO_L101\SDTM_MO_L101;

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
data mo01;
   set morpho;
   length usubjid $10 moorres $200;
   studyid="MYCSG";
   domain="MO";
   usubjid=catx('-',studyid,subject);
   if recordposition ne . then mospid=put(recordposition,z3.);

   if not missing(modat) then modtc=put(input(modat,date11.),yymmdd10.);
   molat=upcase(laterality);
   length motestcd $8 motest $40;
   if upcase(moyn)="NO" then do;
      mostat="NOT DONE";
      moreasnd=reasnd;
      motestcd="MOALL";
      motest="Morphology Findings";
      output;
   end;
   else if upcase(moyn)="YES" then do;
      motestcd="LENGTH";
      motest="Length";
      if missing(molength) then do;
         mostat="NOT DONE";
         moreasnd="Not Collected";
      end;
      else do;
         moorres=molength;
         moorresu="mm";
         mostresc=moorres;
         mostresu=moorresu;
         mostresn=input(mostresc,??best.);
      end;

      output;
      call missing(motestcd,motest,mostat,moreasnd,moorres,moorresu,mostresc,mostresu,mostresn);
      motestcd="WIDTH";
      motest="Width";
      if missing(mowidth) then do;
         mostat="NOT DONE";
         moreasnd="Not Collected";
      end;
      else do;
         moorres=mowidth;
         moorresu="mm";
         mostresc=moorres;
         mostresu=moorresu;
         mostresn=input(mostresc,??best.);
      end;

      output;

      call missing(motestcd,motest,mostat,moreasnd,moorres,moorresu,mostresc,mostresu,mostresn);
      motestcd="DEPTH";
      motest="Depth";
      if missing(modepth) then do;
         mostat="NOT DONE";
         moreasnd="Not Collected";
      end;
      else do;
         moorres=modepth;
         moorresu="mm";
         mostresc=moorres;
         mostresu=moorresu;
         mostresn=input(mostresc,??best.);
      end;
      output;
   end;
run;

/*=========================================================
Calculate study day
=========================================================*/

/*----------------------------------------------------------
Get RFSTDTC from DM into mo01 dataset
----------------------------------------------------------*/
proc sort data=mo01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data mo02;
   merge mo01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(modtc) then modt=input(modtc,yymmdd10.);

   if nmiss(rfstdt,modt)=0 then mody=modt-rfstdt+(modt>=rfstdt);
   format rfstdt modt date9.;
run;

/*=========================================================
Create VISITNUM and VISIT
=========================================================*/

/*----------------------------------------------------------
Use SV to fetch the sequenced unscheduled visit number
----------------------------------------------------------*/
data mo03;
   set mo02;
   length visit $50;
   visitnum=folderseq;
   visit=upcase(FOLDERNAME);
run;

data sched01 unsched01;
   set mo03;
   if find(visit,"UNSCHEDULED",'i') then output unsched01;
   else output sched01;
run;

proc sql;
   create table unsched02 as
      select a.*,b.visitnum,b.visit length=50
      from unsched01(drop=visitnum visit) as a
      left join
      sv as b
      on a.usubjid=b.usubjid and svstdtc le modtc le svendtc;
quit;

data mo04;
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
Compare modtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=mo04 out=mo05;
   by usubjid;
run;

data mo06;
   merge mo05(in=a) epochdates;
   by usubjid;
   if a;
run;

data mo07;
   set mo06;
   ymd=modtc;
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
proc sort data=mo07 out=base01;
   by usubjid motestcd molat modtc;
   where "" lt modtc le rfstdtc and (moorres ne "");
run;

/*----------------------------------------------------------
Identify the closest record to reference start date
----------------------------------------------------------*/

data base02;
   set base01;
   by usubjid motestcd molat modtc;
   if last.molat;
run;

/*----------------------------------------------------------
Populate the baseline flag
----------------------------------------------------------*/

proc sort data=mo07;
   by usubjid motestcd molat modtc;
run;

data mo08;
   merge mo07(in=a) base02(in=b keep=usubjid motestcd molat modtc);
   by usubjid motestcd molat modtc;
   if b then moblfl="Y";
run;

/*=========================================================
Create moSEQ variable
=========================================================*/

proc sort data=mo08;
   by usubjid motestcd modtc;
run;

data mo09;
   set mo08;
   by usubjid motestcd modtc molat;
   if first.usubjid then moseq=1;
   else moseq+1;

   if mostat="" then do;
      moloc="KIDNEY";
      momethod="CT SCAN";
   end;
run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let movarlist=STUDYID DOMAIN USUBJID MOSEQ MOSPID MOTESTCD MOTEST MOORRES MOORRESU MOSTRESC
MOSTRESN MOSTRESU MOSTAT MOREASND MOLOC MOLAT MOMETHOD MOBLFL VISITNUM VISIT EPOCH MODTC MODY
;

data mo(label='Morphology');
   retain &movarlist.;
   set mo09;
   keep &movarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;