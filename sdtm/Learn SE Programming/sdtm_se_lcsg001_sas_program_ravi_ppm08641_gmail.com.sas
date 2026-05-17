* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_SE_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/**********************************************************
Include the data file
**********************************************************/
%let root2=&root.SDTM\SDTM_SE\SDTM_SE_LCSG001\SDTM_SE_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/**********************************************************
Programming for the Task
**********************************************************/

/**********************************************************
Read input datasets
**********************************************************/

data dm01;
   set dm;
run;

data eos01;
   set eos;
run;

data eoip01;
   set eoip;
run;

data sv01;
   set sv;
run;

/**********************************************************
Create a dataset with one record per subject to hold all key date variables
**********************************************************/

/*----------------------------------------------------------
Keep the required date variables sdtm.dm dataset
----------------------------------------------------------*/
data dm02;
   set dm01;
   keep studyid usubjid rfstdtc rfendtc rfxstdtc rfxendtc rfpendtc rficdtc armcd arm actarmcd actarm rfstdt;
   rfxstdtc=substrn(rfxstdtc,1,10);
   rfxendtc=substrn(rfxendtc,1,10);
   if rfstdtc ne "" then rfstdt=input(rfstdtc,??yymmdd10.);
run;

/*----------------------------------------------------------
Fetch eoip date
----------------------------------------------------------*/

data eoipdtc;
   set eoip01;
   length usubjid $20;
   where upcase(eoscat)="END OF TREATMENT" and eostdt_raw ne "";
   eoipdtc=put(input(eostdt_raw,date11.),yymmdd10.);
   usubjid=catx("-",study,pt);
   keep usubjid eoipdtc;
run;

/*----------------------------------------------------------
Fetch eos date
----------------------------------------------------------*/

data eosdtc;
   set eos01;
   length usubjid $20;
   where upcase(eoscat)="END OF STUDY" and eostdt_raw ne "";
   eosdtc=put(input(eostdt_raw,date11.),yymmdd10.);
   usubjid=catx("-",study,pt);
   keep usubjid eosdtc;
run;

/**********************************************************
Fetch the earliest follow-up visit start date from sdtm SV
**********************************************************/

proc sort data=sv01 out=fup01;
   by usubjid svstdtc;
   where visit ? "FOLLOW";
run;

proc sort data=fup01 out=fupdtc(keep=usubjid svstdtc rename=(svstdtc=fupdtc)) nodupkey;
   by usubjid;
run;

/**********************************************************
Get the latest available date in SV for each subject
**********************************************************/

proc sort data=sv01 out=svlatest01;
   by usubjid descending svendtc;
run;

proc sort data=svlatest01 out=svlatest02(keep=usubjid svendtc rename=(svendtc=svlatestdtc)) nodupkey;
   by usubjid;
run;

/*----------------------------------------------------------
Merge all datasets such that required date variables are present on a single record
----------------------------------------------------------*/

proc sort data=dm02;
   by usubjid;
run;

proc sort data=eosdtc;
   by usubjid;
run;

proc sort data=eoipdtc;
   by usubjid;
run;

data keydates01;
   merge dm02(in=a) eoipdtc eosdtc fupdtc svlatest02;
   by usubjid;
   if a;
run;

/**********************************************************
Create records for elements using key date variables
**********************************************************/

/*----------------------------------------------------------
Screening Element
----------------------------------------------------------*/

data scr01;
   set keydates01;
   where rficdtc ne "";
   length sestdtc seendtc $10 etcd $10 element epoch $40;
   etcd="SCR";
   element="Screening";
   epoch="SCREENING";
   sestdtc=substrn(rficdtc,1,10);
   taetord=1;
   if rfxstdtc ne "" then seendtc=substrn(rfxstdtc,1,10);
   else seendtc=substrn(rfpendtc,1,10);
   keep studyid usubjid etcd element epoch sestdtc seendtc taetord;
run;

/*----------------------------------------------------------
Element corresponding to treatment
----------------------------------------------------------*/

data trt01;
   set keydates01;
   where rfxstdtc ne "";

   length sestdtc seendtc $10 etcd $10 element epoch $40;
   etcd=armcd;
   element=arm;
   epoch="TREATMENT";
   sestdtc=substrn(rfxstdtc,1,10);
   taetord=2;
   if eoipdtc ne "" then seendtc=substrn(eoipdtc,1,10);
   else seendtc=substrn(svlatestdtc,1,10);
   keep studyid usubjid etcd element epoch sestdtc seendtc taetord;
run;

/*----------------------------------------------------------
Follow-up element
----------------------------------------------------------*/

data fup01;
   set keydates01;
   where fupdtc ne "";

   length sestdtc seendtc $10 etcd $10 element epoch $40;
   etcd="FUP";
   element="Follow-up";
   epoch="FOLLOW-UP";
   sestdtc=substrn(eoipdtc,1,10);
   taetord=2;
   if eosdtc ne "" then seendtc=substrn(eosdtc,1,10);
   else seendtc=substrn(svlatestdtc,1,10);
   keep studyid usubjid etcd element epoch sestdtc seendtc taetord;
run;

/**********************************************************
Combine the datasets containing individual elements
**********************************************************/

data se01;
   set scr01 trt01 fup01;
   by usubjid;
   domain="SE";
   if not missing(sestdtc) then sestdt=input(sestdtc,??yymmdd10.);
   if not missing(seendtc) then seendt=input(seendtc,??yymmdd10.);
   format sestdt seendt date9.;
run;

/**********************************************************
Derive SESEQ variable
**********************************************************/

proc sort data=se01;
   by usubjid taetord;
run;

data se02;
   set se01;
   by usubjid taetord;
   if first.usubjid then seseq=1;
   else seseq+1;
run;

/**********************************************************
Create study day variables
**********************************************************/

data se03;
   merge se02(in=a) dm02(in=b keep=usubjid rfstdt);
   by usubjid;
   if a;
   if n(rfstdt,sestdt)=2 then sestdy=sestdt-rfstdt+(sestdt>=rfstdt);
   if n(rfstdt,seendt)=2 then seendy=seendt-rfstdt+(seendt>=rfstdt);
run;

/**********************************************************
Assign variable attributes and keep the required variables
**********************************************************/

%let varlist=STUDYID DOMAIN USUBJID SESEQ ETCD ELEMENT TAETORD EPOCH SESTDTC SEENDTC SESTDY SEENDY;
data se04;
   attrib
   STUDYID label='Study Identifier'
   DOMAIN label='Domain Abbreviation'
   USUBJID label='Unique Subject Identifier'
   SESEQ label='Sequence Number'
   ETCD label='Element Code'
   ELEMENT label='Description of Element'
   TAETORD label='Planned Order of Element within Arm'
   EPOCH label='Epoch'
   SESTDTC label='Start Date/Time of Element'
   SEENDTC label='End Date/Time of Element'
   SESTDY label='Study Day of Start of Element'
   SEENDY label='Study Day of End of Element'
   ;
   set se03;
   keep &varlist.;
run;

/**********************************************************
Save final copies of the datasets with dataset labels
**********************************************************/

options validvarname=v7;
proc sort data=se04 out=osCSG001.se(label="Subject Elements");
   by usubjid seseq;
run;

/**********************************************************
Create xpt files
**********************************************************/

%let xptpath=%sysfunc(pathname(osCSG001))\xpt\;

libname se xport "&xptpath.\se.xpt";

proc copy in=osCSG001 out=se;
   select se;
run;

libname se;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;