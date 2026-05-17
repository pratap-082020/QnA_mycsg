* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_CE_LGE01;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_CE\SDTM_CE_LGE01\SDTM_CE_LGE01;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read and process input datasets;
*==============================================================================;

data events01;
    set ceevents;
run;

*==============================================================================;
*Create records for each instance of diarrhea and vomiting;
*==============================================================================;

data events02;
    set events01;

    length ceterm $200 ceevintx $50;

    *------------------------------------------------------------------------------;
    *common variables;
    *------------------------------------------------------------------------------;
    studyid="MYCSG";
    usubjid=subject;
    domain="CE";
    cepresp="Y";
    cecat="Gastroenteritis";
    cegrpid=put(input(cedat_raw,??date11.),yymmdd10.);
    cedtc=put(input(gedat_raw,??date11.),yymmdd10.);
    cespid=cats(geday);

    array occvars[*] diaoccur_1 diaoccur_2 diaoccur_3 vomoccur_1 vomoccur_2 vomoccur_3;

    do i=1 to 6;

        if i in (1,2,3) then ceterm="Diarrhea";
        else ceterm="Vomiting";

        cedecod=ceterm;

        if occvars[i]="Yes" then ceoccur="Y";
        else if occvars[i]="No" then ceoccur="N";

        if i in (1,4) then ceevintx="Episodes from 00:00 to 08:00";
        else if i in (2,5) then ceevintx="Episodes from 08:01 to 16:00";
        else if i in (3,6) then ceevintx="Episodes from 16:01 to 24:00";

        output;
        call missing(ceterm,ceoccur,ceevintx);*ensure values are not carried forward;
    end;
run;

*==============================================================================;
*Derive CESEQ;
*==============================================================================;
proc sort data=events02;
    by studyid usubjid cegrpid ceterm cedtc ceevintx;
run;

data events03;
    set events02;
    by studyid usubjid cegrpid ceterm cedtc ceevintx;
    if first.usubjid then ceseq=1;
    else ceseq+1;
run;

*==============================================================================;
*Keep only required variables;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID CESEQ CEGRPID CESPID CETERM CEDECOD CECAT
CEPRESP CEOCCUR CEDTC CEEVINTX;

data ce;
    retain &varlist.;
    set events03;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;