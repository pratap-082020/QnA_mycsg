* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_DV_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_DV\SDTM_DV_L101\SDTM_DV_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Create variables which are directly based on raw variables;
*==============================================================================;

data dv01;
    set protdev;

    studyid="MYCSG";
    domain="DV";

    length usubjid $10;

    usubjid="MYCSG-"||strip(subject);
    dvdecod=coded;
    if not missing(dvstdat_raw) then dvstdtc=put(input(dvstdat_raw,date11.),yymmdd10.);
    if not missing(dvendat_raw) then dvendtc=put(input(dvendat_raw,date11.),yymmdd10.);

    dvmajor=major;
run;

*==============================================================================;
*Create split variables dynamically;
*==============================================================================;

data dv02;
   set dv01 end=last;

   array cvars[200] $200 dvterm dvterm1-dvterm199 ;

   length tempcomment $32767 ;
   tempcomment=term;

   retain maxvars 1;

   do i=1 to 200;

      cutpos=find(tempcomment,' ',-200); *determine the position of space from the end of string;
      cvars[i]=substrn(tempcomment,1,cutpos);*extract till that space;
      tempcomment=substrn(tempcomment,cutpos+1);*keep only the subsequent string in parent variable;

      if missing(tempcomment) then leave; * if no further text exists, leave the loop for next obs instead of running 200 times;

   end;

   maxvars=max(maxvars,i);

*------------------------------------------------------------------------------;
*find the list of unused variables to be dropped;
*------------------------------------------------------------------------------;

   if last then do;
    if maxvars gt 1 then droplist="dvterm"||cats(maxvars)||"-dvterm199";
    else droplist="dvterm1-dvterm199";
    call symputx("dropvarlist",droplist);
   end;
run;

*------------------------------------------------------------------------------;
*Drop unused variables;
*------------------------------------------------------------------------------;

data dv03;
    set dv02;
    drop &dropvarlist.;

    length commentx $32767;
    commentx=catx("",of dvterm:);

    match=(term=commentx); *concatenate and check if it matches with original;
run;

*==============================================================================;
*Create study day variables;
*==============================================================================;

proc sort data=dm;
   by usubjid;
run;

proc sort data=dv03;
   by usubjid;
run;

data dv04;
   merge dv03(in=a)
         dm(in=b keep=usubjid rfstdtc);
   by usubjid;

   if a;

   *------------------------------------------------------------------------------;
   *Create numeric version of dates;
   *------------------------------------------------------------------------------;

   if not missing(rfstdtc) then rfstdt=input(rfstdtc,??yymmdd10.);
   if not missing(dvstdtc) then dvstdt=input(dvstdtc,??yymmdd10.);
   if not missing(dvendtc) then dvendt=input(dvendtc,??yymmdd10.);

   format rfstdt dvstdt dvendt date9.;

   *------------------------------------------------------------------------------;
   *create study days;
   *------------------------------------------------------------------------------;

   if nmiss(rfstdt,dvstdt)=0 then dvstdy=dvstdt-rfstdt+(dvstdt>=rfstdt);
   if nmiss(rfstdt,dvendt)=0 then dvendy=dvendt-rfstdt+(dvendt>=rfstdt);
run;

*==============================================================================;
*Create sequence variable;
*==============================================================================;

proc sort data=dv04;
   by usubjid dvterm dvstdtc;
run;

data dv05;
   set dv04;
   by usubjid dvterm dvstdtc;
   if first.usubjid then dvseq=1;
   else dvseq+1;
run;

*==============================================================================;
*Keep only required variables;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID DVSEQ DVTERM DVDECOD DVSTDTC DVENDTC DVSTDY
DVENDY DVTERM1 DVMAJOR;

data dv;
    retain &varlist.;
    set dv05;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;