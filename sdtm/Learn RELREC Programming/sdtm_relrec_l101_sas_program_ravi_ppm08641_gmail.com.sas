* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_RELREC_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_RELREC\SDTM_RELREC_L101\SDTM_RELREC_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Creating relationship for DS and AE
=========================================================*/
/*----------------------------------------------------------
Create common named variables between adverse and eos datasets for merging these datasets together
DSAENO has the information related to AESPID on adverse events
----------------------------------------------------------*/

data dsae_ae;
    length aespid $10;
    set adverse;
run;

data dsae_eos;
    set eos;
    where dsaeno ne "";
    length aespid $10;
    aespid=dsaeno;
run;

/*----------------------------------------------------------
Merge processed ADVERSE and EOS datasets to check if a matching record exists between these two datasets
----------------------------------------------------------*/

proc sort data=dsae_ae;
    by study subject aespid;
run;

proc sort data=dsae_eos;
    by study subject aespid;
run;

data dsae01;
   merge dsae_ae(in=a)
         dsae_eos(in=b);
   by study subject aespid;

   if a and b;
run;

/*----------------------------------------------------------
Create a record for each related domain
Populate
----------------------------------------------------------*/
data final_dsae;
    set dsae01;
    length rdomain $2 idvar $8 idvarval $200 reltag $10 relid $200;
    reltag="DSAE";
    relid=cats(reltag,dsspid);
    rdomain="DS";
    idvar="DSSPID";
    idvarval=dsspid;
    output;

    rdomain="AE";
    idvar="AESPID";
    idvarval=aespid;
    output;
    keep study subject rdomain idvar idvarval relid;
run;

/*=========================================================
Creating relationship for CM and AE
=========================================================*/
/*----------------------------------------------------------
Create common named variables between adverse and conmeds datasets for merging these datasets together
CMAENO has the information related to AESPID on adverse events
----------------------------------------------------------*/

data cmae_ae;
    length aespid $10;
    set adverse;
run;

data cmae_cm;
    set conmeds;
    where cmaeno ne "";
    length aespid $10;
    aespid=cmaeno;
run;

/*----------------------------------------------------------
Merge processed ADVERSE and CONMEDS datasets to check if a matching record exists between these two datasets
----------------------------------------------------------*/

proc sort data=cmae_ae;
    by study subject aespid;
run;

proc sort data=cmae_cm;
    by study subject aespid;
run;

data cmae01;
   merge cmae_ae(in=a)
         cmae_cm(in=b);
   by study subject aespid;

   if a and b;
run;

/*----------------------------------------------------------
Create a record for each related domain
----------------------------------------------------------*/
data final_cmae;
    set cmae01;
    length rdomain $2 idvar $8 idvarval $200 reltag $10 relid $200;
    reltag="CMAE";
    relid=cats(reltag,cmspid);
    rdomain="CM";
    idvar="CMSPID";
    idvarval=cmspid;
    output;

    rdomain="AE";
    idvar="AESPID";
    idvarval=aespid;
    output;
    keep study subject rdomain idvar idvarval relid;
run;

/*=========================================================
Append all datasets and create common variables
=========================================================*/
data final;
    set final_dsae final_cmae;
    length studyid usubjid $20;
    studyid="MYCSG";
    usubjid=catx("-",study,subject);
run;

/*=========================================================
Sort the dataset and keep only required variables
=========================================================*/

proc sort data=final;
    by studyid usubjid rdomain idvar idvarval;
run;

%let keepvars=STUDYID RDOMAIN USUBJID IDVAR IDVARVAL RELID;

data relrec;
    retain &keepvars.;
    set final;
    keep &keepvars.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;