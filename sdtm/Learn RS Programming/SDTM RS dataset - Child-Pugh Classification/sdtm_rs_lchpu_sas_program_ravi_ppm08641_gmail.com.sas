* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_RS_LCHPU;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_RS\SDTM_RS_LCHPU\SDTM_RS_LCHPU;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read and process input datasets;
*==============================================================================;

data rs01;
    set chpu;
run;

data dm01;
    set dm;
run;

*==============================================================================;
*Create required variables in rs;
*==============================================================================;

data rs02;
    set rs01;

    *------------------------------------------------------------------------------;
    *create common variables;
    *------------------------------------------------------------------------------;
    length studyid $5 usubjid $15;
    studyid="MYCSG";
    domain="RS";
    usubjid=catx("-",studyid,subject);
    if rsdat_raw ne "" then rsdtc=put(input(rsdat_raw,date11.),yymmdd10.);

    rscat="CHILD-PUGH CLASSIFICATION";

    visitnum=folderseq;
    visit=foldername;

    *------------------------------------------------------------------------------;
    *Create rows for testcd using arrays;
    *------------------------------------------------------------------------------;

    array qvars[*] chpu_1 chpu_2 chpu_3 chpu_4 chpu_5;
    array testcd[5] $8 _temporary_ ("CPS0101" "CPS0102" "CPS0103" "CPS0104" "CPS0105A" );
    array test[5] $40 _temporary_ (
                    "CPS01-Encephalopathy Grade"
                    "CPS01-Ascites"
                    "CPS01-Serum Bilirubin"
                    "CPS01-Serum Albumin"
                    "CPS01-PT, Sec Prolonged"
                    );

    length rstestcd $8 rstest $40 rsorres rsstresc $200;

    do i=1 to dim(qvars);
        rstestcd=testcd[i];
        rstest=test[i];
        rsorres=scan(qvars[i],-1,':');
        rsstresc=scan(qvars[i],1,':');

        rsstresn=input(rsstresc,??best.);
        rsorresu="";
        rsstresu=rsorresu;

        output;
        call missing(rstestcd,rsorres,rsstresc,rsstresn);
    end;
run;

*==============================================================================;
*Create --LOBXFL;
*==============================================================================;

*------------------------------------------------------------------------------;
*Fetch RFXSTDTC into rs data;
*------------------------------------------------------------------------------;

proc sort data=rs02;
    by studyid usubjid;
run;

proc sort data=dm01;
    by studyid usubjid;
run;

data rs03;
    merge rs02(in=a) dm01(in=b keep=studyid usubjid rfstdtc rfxstdtc);
    by studyid usubjid;
    if a;
run;

*------------------------------------------------------------------------------;
*Filter qualifying records;
*------------------------------------------------------------------------------;

data base01;
    set rs03;
    where "" lt rsdtc le rfxstdtc and rsorres ne "";
run;

*------------------------------------------------------------------------------;
*Pick latest record;
*------------------------------------------------------------------------------;

proc sort data=base01;
    by studyid usubjid rstestcd rsdtc;
run;

data base02;
    set base01;
    by studyid usubjid rstestcd rsdtc;
    if last.rstestcd;
    keep studyid usubjid rstestcd rsdtc;
run;

*------------------------------------------------------------------------------;
*populate --lobxfl on the timepoint identified above;
*------------------------------------------------------------------------------;

proc sort data=rs03;
    by studyid usubjid rstestcd rsdtc;
run;

data rs04;
    merge rs03 base02(in=b);
    by studyid usubjid rstestcd rsdtc;
    if b then rslobxfl="Y";
run;

*==============================================================================;
*Derive other dependent variables;
*==============================================================================;

data rs05;
    set rs04;

    rsdt=input(rsdtc,??yymmdd10.);
    rfstdt=input(rfstdtc,??yymmdd10.);

    if nmiss(rsdt,rfstdt)=0 then rsdy=rsdt-rfstdt+(rsdt>=rfstdt);

    format rsdt rfstdt date9.;
run;

*==============================================================================;
*Create --SEQ variable;
*==============================================================================;

proc sort data=rs05;
    by studyid usubjid rstestcd rsdtc;
run;

data rs06;
    set rs05;
    by studyid usubjid rstestcd rsdtc;
    if first.usubjid then rsseq=1;
    else rsseq+1;
run;

*==============================================================================;
*keep only required variables ;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID RSSEQ RSTESTCD RSTEST RSCAT RSORRES
RSORRESU RSSTRESC RSSTRESN RSSTRESU RSLOBXFL VISITNUM VISIT RSDTC RSDY

;

data rs;
    retain &varlist.;
    set rs06;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;