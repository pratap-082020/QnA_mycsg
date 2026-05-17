* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_FA_LGE01;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_FA\SDTM_FA_LGE01\SDTM_FA_LGE01;

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
    drop foldername;
run;

data details01;
    set cedetails;
    drop foldername;
run;

*==============================================================================;
*Create rows to hold tests for events01;
*==============================================================================;

data events02;
    set events01;
    length fatestcd $8 facat faobj faorres $200 faevintx $50;

    *------------------------------------------------------------------------------;
    *common variables which are applicable for all rows;
    *------------------------------------------------------------------------------;
    facat="Gastroenteritis";
    fagrpid=put(input(cedat_raw,??date11.),yymmdd10.);
    fadtc=put(input(gedat_raw,??date11.),yymmdd10.);

*==============================================================================;
*Diarrhea;
*==============================================================================;

    *------------------------------------------------------------------------------;
    *Create records corresponding to diarrhea occurrence;
    *------------------------------------------------------------------------------;

    faobj="Diarrhea";
    fatestcd="OCCUR";

    faorres=diaoccur_1;
    faevintx="Episodes from 00:01 to 08:00";
    output;
    call missing(faorres,faevintx);

    faorres=diaoccur_2;
    faevintx="Episodes from 08:01 to 16:00";
    output;
    call missing(faorres,faevintx);

    faorres=diaoccur_3;
    faevintx="Episodes from 16:01 to 24:00";
    output;
    call missing(faorres,faevintx,fatestcd);

    *------------------------------------------------------------------------------;
    *create records for diarrhea episodes;
    *------------------------------------------------------------------------------;

    fatestcd="EPSDNUM";

    if not missing(dianum_1) then do;
        faorres=dianum_1;
        faevintx="Episodes from 00:01 to 08:00";
        output;
        call missing(faorres,faevintx);
    end;
    if not missing(dianum_2) then do;
        faorres=dianum_2;
        faevintx="Episodes from 08:01 to 16:00";
        output;
        call missing(faorres,faevintx);
    end;
    if not missing(dianum_3) then do;
        faorres=dianum_3;
        faevintx="Episodes from 16:01 to 24:00";
        output;
        call missing(faorres,faevintx);
    end;
    call missing(faobj,fatestcd);

*==============================================================================;
*Vomiting;
*==============================================================================;

    *------------------------------------------------------------------------------;
    *Create records corresponding to Vomiting occurrence;
    *------------------------------------------------------------------------------;

    faobj="Vomiting";
    fatestcd="OCCUR";

    faorres=vomoccur_1;
    faevintx="Episodes from 00:01 to 08:00";
    output;
    call missing(faorres,faevintx);

    faorres=vomoccur_2;
    faevintx="Episodes from 08:01 to 16:00";
    output;
    call missing(faorres,faevintx);

    faorres=vomoccur_3;
    faevintx="Episodes from 16:01 to 24:00";
    output;
    call missing(faorres,faevintx,fatestcd);

    *------------------------------------------------------------------------------;
    *create records for Vomiting episodes;
    *------------------------------------------------------------------------------;

    fatestcd="EPSDNUM";

    if not missing(vomnum_1) then do;
        faorres=vomnum_1;
        faevintx="Episodes from 00:01 to 08:00";
        output;
        call missing(faorres,faevintx);
    end;
    if not missing(vomnum_2) then do;
        faorres=vomnum_2;
        faevintx="Episodes from 08:01 to 16:00";
        output;
        call missing(faorres,faevintx);
    end;
    if not missing(vomnum_3) then do;
        faorres=vomnum_3;
        faevintx="Episodes from 16:01 to 24:00";
        output;
        call missing(faorres,faevintx);
    end;
    call missing(faobj,fatestcd);

run;

*==============================================================================;
*Create rows to hold tests from details01;
*==============================================================================;

data details02;
    set details01;
    length fatestcd $8 facat faobj faorres $200;

    *------------------------------------------------------------------------------;
    *common variables which are applicable for all rows;
    *------------------------------------------------------------------------------;
    facat="Gastroenteritis Details";
    fagrpid=put(input(cedat_raw,??date11.),yymmdd10.);

    *------------------------------------------------------------------------------;
    *Create tests;
    *------------------------------------------------------------------------------;

    faobj="Healthcare provided visit";
    fatestcd="OCCUR";
    faorres=hcare;
    output;
    call missing(fatestcd,faorres);

    if hcare="Yes" then do;
      fatestcd="HOVISTYP";
      faorres=hcare_type;
      output;
      call missing(fatestcd,faorres,faobj);
    end;

    faobj="Oral Rehydration";
    fatestcd="OCCUR";
    faorres=orehyd;
    output;
    call missing(faobj,fatestcd,faorres);

    faobj="Intravenous hydration";
    fatestcd="OCCUR";
    faorres=ivrehyd;
    output;
    call missing(faobj,fatestcd,faorres);

    faobj="Resulted in hospitalization";
    fatestcd="OCCUR";
    faorres=hosp;
    output;
    call missing(faobj,fatestcd,faorres);

run;

*==============================================================================;
*Combine the tests from events and details and create variables which are common
to both the datasets;
*==============================================================================;

data all01;
    set events02(in=a) details02(in=b);

    length fatest $40 fastresc $200;
    studyid="MYCSG";
    domain="FA";
    usubjid=subject;

    if fatestcd="EPSDNUM" then fatest="Number of Episodes";
    else if fatestcd="OCCUR" then fatest="Occurrence";
    else if fatestcd="HOVISTYP" then fatest="Healthcare visit type";

    if faorres="Yes" then fastresc="Y";
    else if faorres="No" then fastresc="N";
    else fastresc=faorres;

    fastresn=input(fastresc,??best.);
    faorresu="";
    fastresu=faorresu;
    faeval="INVESTIGATOR";
run;

*==============================================================================;
*Derive FASEQ;
*==============================================================================;

proc sort data=all01;
    by studyid usubjid faobj fatestcd fadtc faevintx;
run;

data all02;
    set all01;
    by studyid usubjid faobj fatestcd fadtc faevintx;

    if first.usubjid then faseq=1;
    else faseq+1;
run;

*==============================================================================;
*keep only required variables;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID FASEQ FAGRPID FATESTCD FATEST FAOBJ FACAT
FAORRES FAORRESU FASTRESC FASTRESN FASTRESU FAEVAL FADTC FAEVINTX;

data fa;
    retain &varlist.;
    set all02;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;