* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_VS_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_VS\SDTM_VS_LCSG001\SDTM_VS_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Reading input datasets
=========================================================*/

data dm01;
   set dm;
run;

data se01;
   set se;
run;

data sv01;
   set sv;
run;

data physmeas01;
   set physmeas;
run;

data vitals01;
   set vitals;
run;

/*=========================================================
Reorganize the data collected to present the information as result of a test code
=========================================================*/

data vs01;
   length folder $50;
   set vitals01(in=a) physmeas01(in=b) ;
   length
      studyid usubjid $20
      vstestcd $8
      vstest vspos vsloc vscat $40
      vsorres vsorresu vsstresc vsstresu $200
   ;
   studyid=study;
   domain="VS";
   usubjid=catx("-",study,pt);

   if a then do;
      if vsdt_raw ne "" then vsdtc=put(input(vsdt_raw,??date11.),yymmdd10.);
      vscat="VITAL SIGNS";

      vstestcd="SYSBP";
      vstest="Systolic Blood Pressure";
      vsorres=sysbp_raw;
      if vsorres ne "" then vsorresu="mmHg";
      vspos=upcase(pos);
      vsstresc=vsorres;
      if vsstresc ne "" then vsstresu="mmHg";
      if not missing(vsstresc) then vsstresn=input(vsstresc,??best.);
      output;
      call missing(vstestcd,vstest,vsorres,vsorresu,vspos,vsstresc,vsstresu,vsstresn,vsloc);

      vstestcd="DIABP";
      vstest="Diastolic Blood Pressure";
      vsorres=diabp_raw;
      if vsorres ne "" then vsorresu="mmHg";
      vspos=upcase(pos);
      vsstresc=vsorres;
      if vsstresc ne "" then vsstresu="mmHg";
      if not missing(vsstresc) then vsstresn=input(vsstresc,??best.);
      output;
      call missing(vstestcd,vstest,vsorres,vsorresu,vspos,vsstresc,vsstresu,vsstresn,vsloc);

      vstestcd="HR";
      vstest="Heart Rate";
      vsorres=hr_raw;
      if vsorres ne "" then vsorresu="beats/min";
      vsstresc=vsorres;
      if vsstresc ne "" then vsstresu="beats/min";
      if not missing(vsstresc) then vsstresn=input(vsstresc,??best.);
      output;
      call missing(vstestcd,vstest,vsorres,vsorresu,vspos,vsstresc,vsstresu,vsstresn,vsloc);

      vstestcd="RESP";
      vstest="Respiratory Rate";
      vsorres=resp_raw;
      if vsorres ne "" then vsorresu="breaths/min";
      vsstresc=vsorres;
      if vsstresc ne "" then vsstresu="breaths/min";
      if not missing(vsstresc) then vsstresn=input(vsstresc,??best.);
      output;
      call missing(vstestcd,vstest,vsorres,vsorresu,vspos,vsstresc,vsstresu,vsstresn,vsloc);

      vstestcd="TEMP";
      vstest="Temperature";
      vsorres=temp_raw;
      vsloc=upcase(temploc);
      if vsorres ne "" then do;
         if tempu="Fahrenheit" then vsorresu="F";
         else if tempu="Celsius" then vsorresu="C";
      end;
      if vsorres ne "" then vsorresn=input(vsorres,?? best.);
      if vsorresu="F" then vsstresn=round((vsorresn-32)*5/9,0.01);
      else vsstresn=vsorresn;

      if vsstresn ne . then vsstresc=strip(put(vsstresn,best.));
      if vsstresc ne "" then vsstresu="C";
      output;
      call missing(vstestcd,vstest,vsorres,vsorresu,vspos,vsstresc,vsstresu,vsstresn,vsloc);
   end;
   if b then do;
      if pmdt_raw ne "" then vsdtc=put(input(pmdt_raw,??date11.),yymmdd10.);
      vscat="PHYSICAL MEASUREMENTS";

      vstestcd="HEIGHT";
      vstest="Height";
      vsorres=height_raw;
      if vsorres ne "" then do;
         if heightu="Centimeters" then vsorresu="cm";
         else if heightu="Inches" then vsorresu="in";
      end;
      if vsorres ne "" then vsorresn=input(vsorres,?? best.);
      if vsorresu="Inches" then vsstresn=round(vsorresn*2.54,0.01);
      else vsstresn=vsorresn;

      if vsstresn ne . then vsstresc=strip(put(vsstresn,best.));
      if vsstresc ne "" then vsstresu="cm";
      output;
      call missing(vstestcd,vstest,vsorres,vsorresu,vspos,vsstresc,vsstresu,vsstresn,vsloc);

      vstestcd="WEIGHT";
      vstest="Weight";
      vsorres=weight_raw;
      if vsorres ne "" then do;
         if weightu="Kilogram" then vsorresu="kg";
         else if weightu="Pound" then vsorresu="lb";
      end;
      if vsorres ne "" then vsorresn=input(vsorres,?? best.);
      if vsorresu="lb" then vsstresn=round(vsorresn*2.2,0.01);
      else vsstresn=vsorresn;

      if vsstresn ne . then vsstresc=strip(put(vsstresn,best.));
      if vsstresc ne "" then vsstresu="kg";
      output;
      call missing(vstestcd,vstest,vsorres,vsorresu,vspos,vsstresc,vsstresu,vsstresn,vsloc);
   end;
run;

/*=========================================================
Create NOT DONE variable
=========================================================*/

data vs02;
   set vs01;
   if vsorres = "" then do;
      vsstat="NOT DONE";
   end;
run;

/*=========================================================
Create study day variable
=========================================================*/

proc sort data=vs02;
   by usubjid;
run;

data vs03;
   merge vs02(in=a) dm01(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a;
   rfstdt=input(substrn(rfstdtc,1,10),??yymmdd10.);
   vsdt=input(substrn(vsdtc,1,10),??yymmdd10.);

   if vsdt ne . and rfstdt ne . then vsdy=vsdt-rfstdt+(vsdt>=rfstdt);
run;

/*=========================================================
Create VISITNUM and VISIT variables
=========================================================*/

/*----------------------------------------------------------
Mapping the visits based on folder value
----------------------------------------------------------*/
data vs04;
   set vs03;
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
   set vs04;
   if visitnum=999 then output uns01;
   else output sched01;
run;

proc sql;
   create table uns02 as
      select a.*,b.visitnum,b.visit
      from uns01 as a
      left join
      sv01 as b
      on a.usubjid=b.usubjid and svstdtc le vsdtc le svendtc;
quit;

data vs05;
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
Compare vsdtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=vs05;
   by usubjid;
run;

data vs06;
   merge vs05(in=a) epochdates;
   by usubjid;
   if a;
run;

data vs07;
   set vs06;
   ymd=vsdtc;
   ym=substrn(vsdtc,1,7);
   y=substrn(vsdtc,1,4);
   length epoch $40;

   if length(vsdtc)=10 then do;
      if ("" lt ss le ymd lt es) or (st="" and "" lt ss le ymd le es) then epoch="SCREENING";
      else if "" lt st le ymd lt et then epoch="TREATMENT";
      else if "" lt sf le ymd le ef then epoch="FOLLOW-UP";
   end;
   else if length(vsdtc)=7 then do;
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

proc sort data=vs07 out=base01;
   by usubjid vstestcd vsdtc;
   where "" lt vsdtc le rfstdtc and (vsorres ne "");
run;

/*----------------------------------------------------------
Identify the closest record to reference start date
----------------------------------------------------------*/

data base02;
   set base01;
   by usubjid vstestcd vsdtc;
   if last.vstestcd;
run;

/*----------------------------------------------------------
Populate the baseline flag
----------------------------------------------------------*/

proc sort data=vs07;
   by usubjid vstestcd vsdtc;
run;

data vs08;
   merge vs07(in=a) base02(in=b keep=usubjid vstestcd vsdtc);
   by usubjid vstestcd vsdtc;
   if b then vsblfl="Y";
run;

/*=========================================================
Create VSSEQ variable
=========================================================*/

proc sort data=vs08;
   by usubjid vscat vstestcd vsdtc;
run;

data vs09;
   set vs08;
   by usubjid vscat vstestcd vsdtc;
   if first.usubjid then vsseq=1;
   else vsseq+1;
run;

/*=========================================================
Assign attributes and keep only required variables
=========================================================*/

%let varlist=STUDYID DOMAIN USUBJID VSSEQ VSTESTCD VSTEST VSCAT VSPOS VSORRES VSORRESU VSSTRESC VSSTRESN
VSSTRESU VSSTAT VSLOC VSBLFL VISITNUM VISIT EPOCH VSDTC VSDY
;

data vs10;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   VSSEQ label='Sequence Number'
   VSTESTCD label='Vital Signs Test Short Name'
   VSTEST label='Vital Signs Test Name'
   VSCAT label='Category for Vital Signs'
   VSPOS label='Vital Signs Position of Subject'
   VSORRES label='Result or Finding in Original Units'
   VSORRESU label='Original Units'
   VSSTRESC label='Character Result/Finding in Std Format'
   VSSTRESN label='Numeric Result/Finding in Standard Units'
   VSSTRESU label='Standard Units'
   VSSTAT label='Completion Status'
   VSLOC label='Location of Vital Signs Measurement'
   VSBLFL label='Baseline Flag'
   VISITNUM label='Visit Number'
   VISIT label='Visit Name'
   EPOCH label="Epoch"
   VSDTC label='Date/Time of Measurements'
   VSDY label='Study Day of Vital Signs'

;
   set vs09;
   keep &varlist.;
run;

/*=========================================================
Save final copies of the datasets with dataset labels
=========================================================*/

options validvarname=v7;

proc sort data=vs10 out=osCSG001.vs(label="Vital Signs");
   by usubjid;
run;

/*=========================================================
Create xpt files
=========================================================*/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname vs xport "&xptpath.\vs.xpt";

proc copy in=osCSG001 out=vs;
   select vs;
run;

libname vs;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;