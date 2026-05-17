* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_RE_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_RE\SDTM_RE_L101\SDTM_RE_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read and process input datasets;
*==============================================================================;

data re01;
    set resp;
run;

data dm01;
    set dm;
run;

*==============================================================================;
*Create required variables in re;
*==============================================================================;

data re02;
    set re01;

    *------------------------------------------------------------------------------;
    *create common variables;
    *------------------------------------------------------------------------------;
    length studyid $5 usubjid $15;
    studyid="MYCSG";
    domain="RE";
    usubjid=catx("-",studyid,subject);
    if redat_raw ne "" then redtc=put(input(redat_raw,date11.),yymmdd10.);

    visitnum=folderseq;
    visit=foldername;

    *------------------------------------------------------------------------------;
    *Create rows for testcd using arrays;
    *------------------------------------------------------------------------------;

    array qvars[*] fev1 fvc fev1pp fvcpp;
    array testcd[4] $8 _temporary_ ("FEV1" "FVC" "FEV1PP" "FVCPP" );
    array testu[4] $8 _temporary_ ("L" "L" "%" "%" );

    length retestcd $8 reorres restresc reorresu $200;

    do i=1 to dim(qvars);
        retestcd=testcd[i];

        reorres=qvars[i];
        restresc=reorres;

        restresn=input(restresc,??best.);
        if reorres ne "" then reorresu=testu[i];
        restresu=reorresu;

        output;
        call missing(retestcd,reorres,restresc,restresn,reorresu,restresu);
    end;
run;

*==============================================================================;
*Create --LOBXFL;
*==============================================================================;

*------------------------------------------------------------------------------;
*Fetch RFXSTDTC into re data;
*------------------------------------------------------------------------------;

proc sort data=re02;
    by studyid usubjid;
run;

proc sort data=dm01;
    by studyid usubjid;
run;

data re03;
    merge re02(in=a) dm01(in=b keep=studyid usubjid rfstdtc rfxstdtc);
    by studyid usubjid;
    if a;
run;

*------------------------------------------------------------------------------;
*Filter qualifying records;
*------------------------------------------------------------------------------;

data base01;
    set re03;
    where "" lt redtc le rfxstdtc and reorres ne "";
run;

*------------------------------------------------------------------------------;
*Pick latest record;
*------------------------------------------------------------------------------;

proc sort data=base01;
    by studyid usubjid retestcd redtc;
run;

data base02;
    set base01;
    by studyid usubjid retestcd redtc;
    if last.retestcd;
    keep studyid usubjid retestcd redtc;
run;

*------------------------------------------------------------------------------;
*populate --lobxfl on the timepoint identified above;
*------------------------------------------------------------------------------;

proc sort data=re03;
    by studyid usubjid retestcd redtc;
run;

data re04;
    merge re03 base02(in=b);
    by studyid usubjid retestcd redtc;
    if b then relobxfl="Y";
run;

*==============================================================================;
*Derive other dependent variables;
*==============================================================================;

data re05;
    set re04;

    length retest $40;
    if retestcd='FEV1' then retest='Forced Expiratory Volume in 1 Second';
    else if retestcd='FVC' then retest='Forced Vital Capacity';
    else if retestcd='FEV1PP' then retest='Percent Predicted FEV1';
    else if retestcd='FVCPP' then retest='Percent Predicted Forced Vital Capacity';

    redt=input(redtc,??yymmdd10.);
    rfstdt=input(rfstdtc,??yymmdd10.);

    if nmiss(redt,rfstdt)=0 then redy=redt-rfstdt+(redt>=rfstdt);

    format redt rfstdt date9.;
run;

*==============================================================================;
*Create --SEQ variable;
*==============================================================================;

proc sort data=re05;
    by studyid usubjid retestcd redtc;
run;

data re06;
    set re05;
    by studyid usubjid retestcd redtc;
    if first.usubjid then reseq=1;
    else reseq+1;
run;

*==============================================================================;
*keep only required variables ;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID RESEQ RETESTCD RETEST REORRES REORRESU RESTRESC
RESTRESN RESTRESU RELOBXFL VISITNUM VISIT REDTC REDY
;

data re;
    retain &varlist.;
    set re06;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;