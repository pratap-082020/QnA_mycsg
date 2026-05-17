* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_RP_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_RP\SDTM_RP_L101\SDTM_RP_L101;

%include "&root2._data.sas";

options validvarname=upcase;

/*=========================================================
Create variables which are directly based on raw data
=========================================================*/
/*----------------------------------------------------------
Create a separate record for each test collected using output statements
----------------------------------------------------------*/
data rp01;
   set repmen;
   length usubjid $10 rporres $200;
   studyid="MYCSG";
   domain="RP";
   usubjid=catx('-',studyid,subject);
   if recordposition ne . then rpspid=put(recordposition,z3.);

   if not missing(repmendat) then rpdtc=put(input(repmendat,date11.),yymmdd10.);

   length rptestcd $8 rptest $40;
   if upcase(repmen_yn)="NO" then do;
      rpstat="NOT DONE";
      rpreasnd="Not Collected";
      rptestcd="RPALL";
      rptest="Reproductive System Findings";
      output;
   end;
   else if upcase(repmen_yn)="YES" then do;
      rptestcd="CHILDPOT";
      rptest="   Childbearing Potential";
      if missing(childpot) then do;
         rpstat="NOT DONE";
         rpreasnd="Not Collected";
      end;
      else do;
         rporres=childpot;
         rporresu="";
         rpstresc=rporres;
         rpstresu=rporresu;
      end;

      output;
      call missing(rptestcd,rptest,rpstat,rpreasnd,rporres,rporresu,rpstresc,rpstresu);
      rptestcd="MENOSTAT";
      rptest="Menopause Status";
      if missing(menostat) then do;
         rpstat="NOT DONE";
         rpreasnd="Not Collected";
      end;
      else do;
         rporres=menostat;
         rporresu="";
         rpstresc=rporres;
         rpstresu=rporresu;
      end;

      output;
      call missing(rptestcd,rptest,rpstat,rpreasnd,rporres,rporresu,rpstresc,rpstresn,rpstresu);

   end;
run;

/*=========================================================
Get RFSTDTC from DM into rp01 dataset
=========================================================*/

/*----------------------------------------------------------
Calculate study day
----------------------------------------------------------*/
proc sort data=rp01;
   by usubjid;
run;

proc sort data=dm;
   by usubjid;
run;

data rp02;
   merge rp01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a and b;
   if not missing(rfstdtc) then rfstdt=input(rfstdtc,yymmdd10.);
   if not missing(rpdtc) then rpdt=input(rpdtc,yymmdd10.);

   if nmiss(rfstdt,rpdt)=0 then rpdy=rpdt-rfstdt+(rpdt>=rfstdt);
   format rfstdt rpdt date9.;
run;

/*=========================================================
Create VISITNUM and VISIT
=========================================================*/

data rp03;
   set rp02;
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
Compare rpdtc with each epoch's start and end dates and assign epoch value
----------------------------------------------------------*/

proc sort data=rp03 out=rp05;
   by usubjid;
run;

data rp06;
   merge rp05(in=a) epochdates;
   by usubjid;
   if a;
run;

data rp07;
   set rp06;
   ymd=rpdtc;
   length epoch $40;

   if ("" lt ss le ymd lt st) or (st="" and "" lt ss le ymd le es) then epoch="SCREENING";
   else if "" lt st le ymd le et then epoch="TREATMENT";
   else if "" lt et lt ymd le ef then epoch="FOLLOW-UP";
run;

/*=========================================================
Create baseline flag
=========================================================*/

/*----------------------------------------------------------
Subset the records meeting the baseline definition
----------------------------------------------------------*/
proc sort data=rp07 out=base01;
   by usubjid rptestcd rpdtc;
   where "" lt rpdtc le rfstdtc and (rporres ne "");
run;

/*----------------------------------------------------------
Identify the closest record to reference start date
----------------------------------------------------------*/

data base02;
   set base01;
   by usubjid rptestcd rpdtc;
   if last.rptestcd;
run;

/*----------------------------------------------------------
Populate the baseline flag
----------------------------------------------------------*/

proc sort data=rp07;
   by usubjid rptestcd rpdtc;
run;

data rp08;
   merge rp07(in=a) base02(in=b keep=usubjid rptestcd rpdtc);
   by usubjid rptestcd rpdtc;
   if b then rpblfl="Y";
run;

/*=========================================================
Create rpSEQ variable
=========================================================*/

proc sort data=rp08;
   by usubjid rptestcd rpdtc;
run;

data rp09;
   set rp08;
   by usubjid rptestcd rpdtc;
   if first.usubjid then rpseq=1;
   else rpseq+1;
run;

/*=========================================================
Keep only required variables, and order the variables in the required order
=========================================================*/

%let rpvarlist=STUDYID DOMAIN USUBJID RPSEQ RPSPID RPTESTCD RPTEST
RPORRES RPORRESU RPSTRESC RPSTRESU RPSTAT RPREASND RPBLFL VISITNUM VISIT
EPOCH RPDTC RPDY;

data rp(label='Reproductive System Findings');
   retain &rpvarlist.;
   set rp09;
   keep &rpvarlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;