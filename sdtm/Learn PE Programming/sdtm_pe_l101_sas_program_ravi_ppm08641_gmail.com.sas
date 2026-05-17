* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_PE_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_PE\SDTM_PE_L101\SDTM_PE_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read and process input datasets;
*==============================================================================;

data pe01;
    set physexam;
run;

data dm01;
    set dm;
run;

*==============================================================================;
*Create required variables in pe;
*==============================================================================;

data pe02;
    set pe01;

    *------------------------------------------------------------------------------;
    *create common variables;
    *------------------------------------------------------------------------------;
    length studyid $5 usubjid $15;
    studyid="MYCSG";
    domain="PE";
    usubjid=catx("-",studyid,subject);
    if pedat_raw ne "" then pedtc=put(input(pedat_raw,date11.),yymmdd10.);

    visitnum=folderseq;
    visit=foldername;

    petest=bodsys;

    length petestcd $8;

    if petest="Ear/Nose/Throat" then petestcd="ENT";
    else if petest="Central Nervous System" then petestcd="CNS";
    else petestcd=substrn(upcase(petest),1,8);

    peorres=result;
    pestresc=upcase(peorres);

    peabnsp=abnsp;
    peclsig=substrn(clsig,1,1);

run;

*==============================================================================;
*create --LOBXFL;
*==============================================================================;

*------------------------------------------------------------------------------;
*Fetch RFXSTDTC into pe data;
*------------------------------------------------------------------------------;

proc sort data=pe02;
    by studyid usubjid;
run;

proc sort data=dm01;
    by studyid usubjid;
run;

data pe03;
    merge pe02(in=a) dm01(in=b keep=studyid usubjid rfstdtc rfxstdtc);
    by studyid usubjid;
    if a;
run;

*------------------------------------------------------------------------------;
*Filter qualifying records;
*------------------------------------------------------------------------------;

data base01;
    set pe03;
    where "" lt pedtc le rfxstdtc and peorres ne "";
run;

*------------------------------------------------------------------------------;
*Pick latest record;
*------------------------------------------------------------------------------;

proc sort data=base01;
    by studyid usubjid petestcd pedtc;
run;

data base02;
    set base01;
    by studyid usubjid petestcd pedtc;
    if last.petestcd;
    keep studyid usubjid petestcd pedtc;
run;

*------------------------------------------------------------------------------;
*populate --lobxfl on the timepoint identified above;
*------------------------------------------------------------------------------;

proc sort data=pe03;
    by studyid usubjid petestcd pedtc;
run;

data pe04;
    merge pe03 base02(in=b);
    by studyid usubjid petestcd pedtc;
    if b then pelobxfl="Y";
run;

*==============================================================================;
*Derive other dependent variables;
*==============================================================================;

data pe05;
    set pe04;

    pedt=input(pedtc,??yymmdd10.);
    rfstdt=input(rfstdtc,??yymmdd10.);

    if nmiss(pedt,rfstdt)=0 then pedy=pedt-rfstdt+(pedt>=rfstdt);

    format pedt rfstdt date9.;
run;

*==============================================================================;
*create --SEQ variable;
*==============================================================================;

proc sort data=pe05;
    by studyid usubjid petestcd pedtc;
run;

data pe06;
    set pe05;
    by studyid usubjid petestcd pedtc;
    if first.usubjid then peseq=1;
    else peseq+1;
run;

*==============================================================================;
*keep only required variables ;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID PESEQ PETESTCD PETEST PEORRES PESTRESC
PELOBXFL VISITNUM VISIT PEDTC PEDY PEABNSP PECLSIG
;

data pe;
    retain &varlist.;
    set pe06;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;