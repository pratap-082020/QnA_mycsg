* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1001_L106;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1001\ADaM_C1001_L106\ADaM_C1001_L106;

%include "&root2._data.sas";

options validvarname=upcase;

/*=========================================================
Derive EOSSTT, EOSDT and DCSREAS
=========================================================*/

/*----------------------------------------------------------
Subset and process the End of Study related record from Disposition data
----------------------------------------------------------*/

/*----------------------------------------------------------
Create EOSDT and DCSREAS variables.
DSSTDC on END OF STUDY record is EOSDT
Any value in DSDECOD variable other than 'COMPLETED' is DCSREAS.
EOSSTT will be partially derived in a later step using this data as we need to check for the absence of record (which can only be checked by
comparing the subjects in this subset with DM dataset).
----------------------------------------------------------*/
data eos01;
   set ds;
   where dscat="DISPOSITION EVENT" and dsscat="END OF STUDY";

   eosdt=input(dsstdtc,yymmdd10.);

   length dcsreas $200 eosstt $50;
   if dsdecod ne "COMPLETED" then do;
      dcsreas=dsdecod;
      eosstt="DISCONTINUED";
   end;
   else if dsdecod="COMPLETED" then do;
      eosstt="COMPLETED";
   end;

   format eosdt date9.;
   keep usubjid eosstt dcsreas eosdt;
run;

/*=========================================================
Derive EOTDT and DCTREAS
=========================================================*/

/*----------------------------------------------------------
Subset and process the End of Treatment related record from Disposition data
----------------------------------------------------------*/

/*----------------------------------------------------------
Create EOTDT and DCTREAS variables.
DSSTDC on END OF TREATMENT record is EOTDT
Any value in DSDECOD variable other than 'COMPLETED' is DCTREAS.
EOTSTT will be partially derived in a later step using this data as we need to check for the absence of record (which can only be checked by
comparing the subjects in this subset with DM dataset).
----------------------------------------------------------*/
data eot01;
   set ds;
   where dscat="DISPOSITION EVENT" and dsscat="END OF TREATMENT";

   eotdt=input(dsstdtc,yymmdd10.);

   length dctreas $200 eotstt $50;
   if dsdecod ne "COMPLETED" then do;
      dctreas=dsdecod;
      eotstt="DISCONTINUED";
   end;
   else if dsdecod="COMPLETED" then do;
      eotstt="COMPLETED";
   end;

   format eotdt date9.;
   keep usubjid eotstt eotdt dctreas;
run;

/*=========================================================
Bring the processed EOT and EOS related variables into DM dataset
=========================================================*/

/*----------------------------------------------------------
Sort the datasets using PROC SORT before merging at subject level
----------------------------------------------------------*/

/*----------------------------------------------------------
Make use of in= dataset operator identify if a dataset is contributing to a particular observation in the merged dataset
If a subject exists in DM but not in EOS - ONGOING in study
If a subject exists in DM but not in EOT - ONGOING in treatment
----------------------------------------------------------*/

proc sort data=dm;
   by usubjid;
run;

proc sort data=eos01;
   by usubjid;
run;

proc sort data=eot01;
   by usubjid;
run;

data adsl01;
   merge dm(in=indm) eos01(in=ineos) eot01(in=ineot);
   by usubjid;

   if indm;

   if indm and not ineos then eosstt="ONGOING";
   if indm and not ineot then eotstt="ONGOING";

run;

/*=========================================================
Arrange variables in a logical sequence for easy review
=========================================================*/

data adsl;
   retain usubjid eotstt eotdt dctreas eosstt eosdt dcsreas;
   set adsl01;

run;

data output;
    set adsl;
    keep usubjid eotstt eotdt dctreas eosstt eosdt dcsreas;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;