* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_QS_LEQ5D3L;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_QS\SDTM_QS_LEQ5D3L\SDTM_QS_LEQ5D3L;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read and process input datasets;
*==============================================================================;

data qs01;
    set eq5d3l;
run;

data dm01;
    set dm;
run;

*==============================================================================;
*Create required variables in QS;
*==============================================================================;

data qs02;
    set qs01;

    *------------------------------------------------------------------------------;
    *create common variables;
    *------------------------------------------------------------------------------;
    length studyid $5 usubjid $15;
    studyid="MYCSG";
    domain="QS";
    usubjid=catx("-",studyid,subject);
    if qsdat_raw ne "" then qsdtc=put(input(qsdat_raw,date11.),yymmdd10.);

    qscat="EQ-5D-3L";
    qsevintx="TODAY";
    qseval="STUDY SUBJECT";

    visitnum=folderseq;
    visit=foldername;

    *------------------------------------------------------------------------------;
    *Create rows for testcd using arrays;
    *------------------------------------------------------------------------------;

    array qvars[*] eq5d3l_1 eq5d3l_2 eq5d3l_3 eq5d3l_4 eq5d3l_5 eq5d3l_6;
    array testcd[6] $8 _temporary_ ("EQ5D0101" "EQ5D0102" "EQ5D0103" "EQ5D0104" "EQ5D0105" "EQ5D0106" );

    length qstestcd $8 qsorres qsstresc $200;

    do i=1 to dim(qvars);
        qstestcd=testcd[i];

        if i=2 then do;
            qsorres=substrn(qvars[i],3);
            qsstresc=substrn(qvars[i],1,1);
        end;
        else do;
            qsorres=scan(qvars[i],-1,'-');
            qsstresc=scan(qvars[i],1,'-');
        end;

        qsstresn=input(qsstresc,??best.);
        qsorresu="";
        qsstresu=qsorresu;

        output;
        call missing(qstestcd,qsorres,qsstresc,qsstresn);
    end;
run;

*==============================================================================;
*Create --LOBXFL;
*==============================================================================;

*------------------------------------------------------------------------------;
*Fetch RFXSTDTC into QS data;
*------------------------------------------------------------------------------;

proc sort data=qs02;
    by studyid usubjid;
run;

proc sort data=dm01;
    by studyid usubjid;
run;

data qs03;
    merge qs02(in=a) dm01(in=b keep=studyid usubjid rfstdtc rfxstdtc);
    by studyid usubjid;
    if a;
run;

*------------------------------------------------------------------------------;
*Filter qualifying records;
*------------------------------------------------------------------------------;

data base01;
    set qs03;
    where "" lt qsdtc le rfxstdtc and qsorres ne "";
run;

*------------------------------------------------------------------------------;
*Pick latest record;
*------------------------------------------------------------------------------;

proc sort data=base01;
    by studyid usubjid qstestcd qsdtc;
run;

data base02;
    set base01;
    by studyid usubjid qstestcd qsdtc;
    if last.qstestcd;
    keep studyid usubjid qstestcd qsdtc;
run;

*------------------------------------------------------------------------------;
*populate --lobxfl on the timepoint identified above;
*------------------------------------------------------------------------------;

proc sort data=qs03;
    by studyid usubjid qstestcd qsdtc;
run;

data qs04;
    merge qs03 base02(in=b);
    by studyid usubjid qstestcd qsdtc;
    if b then qslobxfl="Y";
run;

*==============================================================================;
*Derive other dependent variables;
*==============================================================================;

data qs05;
    set qs04;

    length qstest $40;
    if qstestcd='EQ5D0101' then qstest='EQ5D01-Mobility';
    else if qstestcd='EQ5D0102' then qstest='EQ5D01-Self-Care';
    else if qstestcd='EQ5D0103' then qstest='EQ5D01-Usual Activities';
    else if qstestcd='EQ5D0104' then qstest='EQ5D01-Pain/Discomfort';
    else if qstestcd='EQ5D0105' then qstest='EQ5D01-Anxiety/Depression';
    else if qstestcd='EQ5D0106' then qstest='EQ5D01-EQ VAS Score';

    qsdt=input(qsdtc,??yymmdd10.);
    rfstdt=input(rfstdtc,??yymmdd10.);

    if nmiss(qsdt,rfstdt)=0 then qsdy=qsdt-rfstdt+(qsdt>=rfstdt);

    format qsdt rfstdt date9.;
run;

*==============================================================================;
*Create --SEQ variable;
*==============================================================================;

proc sort data=qs05;
    by studyid usubjid qstestcd qsdtc;
run;

data qs06;
    set qs05;
    by studyid usubjid qstestcd qsdtc;
    if first.usubjid then qsseq=1;
    else qsseq+1;
run;

*==============================================================================;
*keep only required variables ;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID QSSEQ QSTESTCD QSTEST QSCAT QSORRES QSORRESU
QSSTRESC QSSTRESN QSSTRESU QSLOBXFL QSEVAL VISITNUM VISIT QSDTC QSDY QSEVINTX
;

data qs;
    retain &varlist.;
    set qs06;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;