* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_FT_L6MWT;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_FT\SDTM_FT_L6MWT\SDTM_FT_L6MWT;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read and process input datasets;
*==============================================================================;

data ft01;
    set smwt;
run;

data dm01;
    set dm;
run;

*==============================================================================;
*Create required variables in ft;
*==============================================================================;

data ft02;
    set ft01;

    *------------------------------------------------------------------------------;
    *create common variables;
    *------------------------------------------------------------------------------;
    length studyid $5 usubjid $15;
    studyid="MYCSG";
    domain="FT";
    usubjid=catx("-",studyid,subject);
    if ftdat_raw ne "" then ftdtc=put(input(ftdat_raw,date11.),yymmdd10.);

    ftcat="SIX MINUTE WALK";
    fteval="INVESTIGATOR";

    visitnum=folderseq;
    visit=foldername;

    *------------------------------------------------------------------------------;
    *Create rows for testcd using arrays;
    *------------------------------------------------------------------------------;

    array qvars[*] smwt_1 smwt_2 smwt_3 smwt_4 smwt_5 smwt_6;
    array testcd[6] $8 _temporary_ ("SIXMW101" "SIXMW102" "SIXMW103" "SIXMW104" "SIXMW105" "SIXMW106" );

    length fttestcd $8 ftorres ftstresc $200;

    do i=1 to dim(qvars);
        fttestcd=testcd[i];
        ftorres=qvars[i];
        ftstresc=qvars[i];

        ftstresn=input(ftstresc,??best.);
        ftorresu="m";
        ftstresu=ftorresu;

        output;
        call missing(fttestcd,ftorres,ftstresc,ftstresn);
    end;
run;

*==============================================================================;
*Create --LOBXFL;
*==============================================================================;

*------------------------------------------------------------------------------;
*Fetch RFXSTDTC into ft data;
*------------------------------------------------------------------------------;

proc sort data=ft02;
    by studyid usubjid;
run;

proc sort data=dm01;
    by studyid usubjid;
run;

data ft03;
    merge ft02(in=a) dm01(in=b keep=studyid usubjid rfstdtc rfxstdtc);
    by studyid usubjid;
    if a;
run;

*------------------------------------------------------------------------------;
*Filter qualifying records;
*------------------------------------------------------------------------------;

data base01;
    set ft03;
    where "" lt ftdtc le rfxstdtc and ftorres ne "";
run;

*------------------------------------------------------------------------------;
*Pick latest record;
*------------------------------------------------------------------------------;

proc sort data=base01;
    by studyid usubjid fttestcd ftdtc;
run;

data base02;
    set base01;
    by studyid usubjid fttestcd ftdtc;
    if last.fttestcd;
    keep studyid usubjid fttestcd ftdtc;
run;

*------------------------------------------------------------------------------;
*populate --lobxfl on the timepoint identified above;
*------------------------------------------------------------------------------;

proc sort data=ft03;
    by studyid usubjid fttestcd ftdtc;
run;

data ft04;
    merge ft03 base02(in=b);
    by studyid usubjid fttestcd ftdtc;
    if b then ftlobxfl="Y";
run;

*==============================================================================;
*Derive other dependent variables;
*==============================================================================;

data ft05;
    set ft04;

    length fttest $40;

    if fttestcd='SIXMW101' then fttest='SIXMW1-Distance at 1 Minute';
    else if fttestcd='SIXMW102' then fttest='SIXMW1-Distance at 2 Minutes';
    else if fttestcd='SIXMW103' then fttest='SIXMW1-Distance at 3 Minutes';
    else if fttestcd='SIXMW104' then fttest='SIXMW1-Distance at 4 Minutes';
    else if fttestcd='SIXMW105' then fttest='SIXMW1-Distance at 5 Minutes';
    else if fttestcd='SIXMW106' then fttest='SIXMW1-Distance at 6 Minutes';

    ftdt=input(ftdtc,??yymmdd10.);
    rfstdt=input(rfstdtc,??yymmdd10.);

    if nmiss(ftdt,rfstdt)=0 then ftdy=ftdt-rfstdt+(ftdt>=rfstdt);

    format ftdt rfstdt date9.;

    *------------------------------------------------------------------------------;
    *supplementarty domain variables;
    *------------------------------------------------------------------------------;

    ftasstdv=smwt_device;
run;

*==============================================================================;
*Create --SEQ variable;
*==============================================================================;

proc sort data=ft05;
    by studyid usubjid fttestcd ftdtc;
run;

data ft06;
    set ft05;
    by studyid usubjid fttestcd ftdtc;
    if first.usubjid then ftseq=1;
    else ftseq+1;
run;

*==============================================================================;
*keep only required variables ;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID FTSEQ FTTESTCD FTTEST FTCAT FTORRES FTORRESU
FTSTRESC FTSTRESN FTSTRESU FTLOBXFL FTEVAL VISITNUM VISIT FTDTC FTDY FTASSTDV

;

data ft;
    retain &varlist.;
    set ft06;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;