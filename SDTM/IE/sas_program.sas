* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_IE_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_IE\SDTM_IE_L101\SDTM_IE_L101;

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
data ie01;
   set eligcrit;
   length usubjid $10 ieorres $200;
   studyid="MYCSG";
   domain="IE";
   usubjid=catx('-',studyid,subject);
   if recordposition ne . then iespid=put(recordposition,z3.);

   if not missing(iedat) then iedtc=put(input(iedat,date11.),yymmdd10.);

   length ietestcd $8 ietest $40;
    if upcase(icrit01)="NO" then do;
      ietestcd="INCL01";
      ietest="Inclusion criteria 1";
      ieorres="N";
      iestresc=ieorres;
      output;
    end;
    call missing(ietestcd,ietest,ieorres,iestresc);
    if upcase(icrit02)="NO" then do;
      ietestcd="INCL02";
      ietest="Inclusion criteria 2";
      ieorres="N";
      iestresc=ieorres;
      output;
    end;
    call missing(ietestcd,ietest,ieorres,iestresc);
    if upcase(ecrit01)="YES" then do;
      ietestcd="EXCL01";
      ietest="Exclusion criteria 1";
      ieorres="Y";
      iestresc=ieorres;
      output;
    end;

run;

/*=========================================================
Calculate study day
=========================================================*/

/*----------------------------------------------------------
Get RFSTDTC from DM into rp01 dataset
----------------------------------------------------------*/
proc sort data=ie01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data ie02;
   merge ie01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(iedtc) then iedt=input(iedtc,yymmdd10.);

   if nmiss(rfstdt,iedt)=0 then iedy=iedt-rfstdt+(iedt>=rfstdt);
   format rfstdt iedt date9.;
run;

/*=========================================================
Create VISITNUM and VISIT
=========================================================*/

data ie03;
   set ie02;
   length visit $50;
   visitnum=folderseq;
   visit=upcase(FOLDERNAME);
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
Compare iedtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=ie03 out=ie04;
   by usubjid;
run;

data ie05;
   merge ie04(in=a) epochdates;
   by usubjid;
   if a;
run;

data ie06;
   set ie05;
   ymd=iedtc;
   length epoch $40;

   if ("" lt start_scr le ymd lt end_scr) or (start_trt="" and "" lt start_scr le ymd le end_scr) then epoch="SCREENING";
   else if "" lt start_trt le ymd le end_trt then epoch="TREATMENT";
   else if "" lt start_fu lt ymd le end_fu then epoch="FOLLOW-UP";

   if substrn(ietestcd,1,4)="INCL" then iecat="INCLUSION";
   else if substrn(ietestcd,1,4)="EXCL" then iecat="EXCLUSION";
run;

/*=========================================================
Create --SEQ variable
=========================================================*/

proc sort data=ie06;
   by usubjid iecat ietestcd iedtc iespid;
run;

data ie07;
   set ie06;
   by usubjid iecat ietestcd iedtc iespid;
   if first.usubjid then ieseq=1;
   else ieseq+1;

run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let ievarlist=STUDYID DOMAIN USUBJID IESEQ IESPID IETESTCD IETEST IECAT IEORRES IESTRESC VISITNUM VISIT EPOCH IEDTC IEDY
;

data ie(label='   Inclusion/Exclusion Criteria Not Met');
   retain &ievarlist.;
   set ie07;
   keep &ievarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;