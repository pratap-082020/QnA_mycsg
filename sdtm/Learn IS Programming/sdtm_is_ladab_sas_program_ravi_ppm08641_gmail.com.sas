* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_IS_LADAB;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_IS\SDTM_IS_LADAB\SDTM_IS_LADAB;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read input datasets;
*==============================================================================;

data is01;
    set isada;
run;

data dm01;
    set dm;
run;

*==============================================================================;
*Create required variables;
*==============================================================================;

data is02;
    set is01;

    *------------------------------------------------------------------------------;
    *create common variables;
    *------------------------------------------------------------------------------;
    length studyid $5 usubjid $15;
    studyid="MYCSG";
    domain="IS";
    usubjid=catx("-",studyid,subject);
    if isdat_raw ne "" then isdtc=put(input(isdat_raw,date11.),yymmdd10.);

    visitnum=folderseq;
    visit=foldername;

    istestcd="ADA";
    istest="AntiDrug Antibody";

    isorres=istiter;
    isstresc=isorres;

    isstresn=input(isstresc,??best.);
    if isorres ne "" then isorresu="Titer";
    isstresu=isorresu;
    ismethod="ELECTROCHEMILUMINESCENCE IMMUNOASSAY";
    isspec="SERUM";
run;

*==============================================================================;
*Create --LOBXFL;
*==============================================================================;

*------------------------------------------------------------------------------;
*Fetch RFXSTDTC into is data;
*------------------------------------------------------------------------------;

proc sort data=is02;
    by studyid usubjid;
run;

proc sort data=dm01;
    by studyid usubjid;
run;

data is03;
    merge is02(in=a) dm01(in=b keep=studyid usubjid rfstdtc rfxstdtc);
    by studyid usubjid;
    if a;
run;

*------------------------------------------------------------------------------;
*Filter qualifying records;
*------------------------------------------------------------------------------;

data base01;
    set is03;
    where "" lt isdtc le rfxstdtc and isorres ne "";
run;

*------------------------------------------------------------------------------;
*Pick latest record;
*------------------------------------------------------------------------------;

proc sort data=base01;
    by studyid usubjid istestcd isdtc;
run;

data base02;
    set base01;
    by studyid usubjid istestcd isdtc;
    if last.istestcd;
    keep studyid usubjid istestcd isdtc;
run;

*------------------------------------------------------------------------------;
*populate --lobxfl on the timepoint identified above;
*------------------------------------------------------------------------------;

proc sort data=is03;
    by studyid usubjid istestcd isdtc;
run;

data is04;
    merge is03 base02(in=b);
    by studyid usubjid istestcd isdtc;
    if b then islobxfl="Y";
run;

*==============================================================================;
*Derive other dependent variables;
*==============================================================================;

data is05;
    set is04;
    isdt=input(isdtc,??yymmdd10.);
    rfstdt=input(rfstdtc,??yymmdd10.);

    if nmiss(isdt,rfstdt)=0 then isdy=isdt-rfstdt+(isdt>=rfstdt);

    format isdt rfstdt date9.;
run;

*==============================================================================;
*Create --SEQ variable;
*==============================================================================;

proc sort data=is05;
    by studyid usubjid istestcd isdtc;
run;

data is06;
    set is05;
    by studyid usubjid istestcd isdtc;
    if first.usubjid then isseq=1;
    else isseq+1;
run;

*==============================================================================;
*keep only required variables ;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID ISSEQ ISTESTCD ISTEST ISORRES ISORRESU
ISSTRESC ISSTRESN ISSTRESU ISSPEC ISMETHOD ISLOBXFL VISITNUM VISIT ISDTC ISDY
;

data is;
    retain &varlist.;
    set is06;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;