* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_RS_LONCEX06;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_RS\SDTM_RS_LONCEX06\SDTM_RS_LONCEX06;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read and process input datasets;
*==============================================================================;

data rs01;
    set rs_rec;
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
    usubjid=cats("MYCSG-",subject);
    if rsdat ne "" then rsdtc=put(input(rsdat,date11.),yymmdd10.);

    visitnum=folderseq;
    visit=foldername;
    rseval=rseval;
    *------------------------------------------------------------------------------;
    *Create rows for testcd using arrays;
    *------------------------------------------------------------------------------;

    array qvars[*] trgresp_rsorres ntrgresp_rsorres ovrlresp_rsorres;
    array testcd[3] $8 _temporary_ ("TRGRESP" "NTRGRESP" "OVRLRESP" );
    array test[3] $40 _temporary_ (
                    "Target Response"
                    "Non-target Response"
                    "Overall Response"
                    );

    length rstestcd $8 rstest $40 rsorres rsstresc $200;

    do i=1 to dim(qvars);

        rstestcd=testcd[i];
        rstest=test[i];
        rsorres=qvars[i];
        rsstresc=rsorres;

        if rsorres ne "" then output;
        call missing(rstestcd,rsorres,rsstresc);
    end;
run;

*==============================================================================;
*Derive other dependent variables;
*==============================================================================;

proc sort data=dm;
    by usubjid;
run;

proc sort data=rs02;
    by usubjid;
run;

data rs03;
    merge rs02(in=a) dm(in=b);
    by usubjid;
    if a and b;

    if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,yymmdd10.);
    if length(rsdtc) ge 10 then rsdt=input(rsdtc,yymmdd10.);

    if nmiss(rsdt,rfstdt)=0 then rsdy=rsdt-rfstdt+(rsdt ge rfstdt);

    format rfstdt rsdt date9.;
run;
*==============================================================================;
*Create --SEQ variable;
*==============================================================================;

proc sort data=rs03;
    by studyid usubjid rstestcd rsdtc;
run;

data rs04;
    set rs03;
    by studyid usubjid rstestcd rsdtc;
    if first.usubjid then rsseq=1;
    else rsseq+1;
run;

*==============================================================================;
*keep only required variables ;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID RSSEQ RSTESTCD RSTEST RSORRES RSSTRESC
RSEVAL VISITNUM VISIT RSDTC RSDY

;

data rs;
    retain &varlist.;
    set rs04;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;