* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_LB_LCSG001;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_LB\SDTM_LB_LCSG001\SDTM_LB_LCSG001;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Pool the raw datasets and create direct variables;
*==============================================================================;

data lb01;
   length specimen coll_unit $100;
   set
   lab_chem(in=inchem)
   lab_hema(in=inhema)
   lab_urin(in=inurin)
   ;
   studyid=study;
   domain="LB";

   usubjid=catx("-",study,pt);

   lbtestcd=test;
   lborres=coll_rslt;
   lbornrlo=lower;
   lbornrhi=upper;
   lborresu=coll_unit;

   length lbcat $100;
   if inchem then lbcat="CHEMISTRY";
   else if inhema then lbcat="HEMATOLOGY";
   else if inurin then lbcat="URINALYSIS";

   lbspec=upcase(specimen);
run;

*==============================================================================;
*Pull standard unit and conversion factor from metadata;
*==============================================================================;

proc sql;
   create table lb02 as
      select a.*,b.lbstresu,b.conversion,b.lbtest,b.decimals
      from lb01 as a
      left join
      lab_meta as b
      on a.lbcat=b.lbcat and a.lbtestcd=b.lbtestcd and a.lborresu=b.lborresu
      ;
quit;

*==============================================================================;
*create values of standard units;
*==============================================================================;

*separate the symbols and numeric components;
*convert the numeric component to standard units;
*concatenate the symbols back to standard converted values;

data lb03(drop=j tempsign: tempresn: stresn: stdlow: stdhigh:)
     lb03_temp;
    set lb02;

    array tempsigns[*] $30 tempsign1 tempsign2 tempsign3;
    array tempresns[*] tempresn1 tempresn2 tempresn3;
    array stresns[*]  stresn1 stresn2 stresn3;
    array origvars[*] lborres lbornrlo lbornrhi;
    array nstdvars[*] lbstresn stdlow stdhigh;
    array cstdvars[*] $200 lbstresc stdlowc stdhighc;

    do j=1 to dim(tempsigns);
       if substrn(origvars[j],1,2) in ("<=" ">=") then do;
           tempresns[j]=input(substrn(origvars[j],3),??best.);
           tempsigns[j]=substrn(origvars[j],1,2);
       end;
       else if substrn(origvars[j],1,1) in ("<" ">") then do;
           tempresns[j]=input(substrn(origvars[j],2),??best.);
           tempsigns[j]=substrn(origvars[j],1,1);
       end;
       else tempresns[j]=input(origvars[j],??best.);

       if decimals ne . then roundto=10**(-1*decimals);

       if nmiss(tempresns[j],conversion)=0 then do;
           stresns[j]=tempresns[j]*conversion;
           stresns[j]=round(stresns[j],roundto);
       end;
       if tempsigns[j]="" then do;
           nstdvars[j]=stresns[j];
           cstdvars[j]=strip(put(stresns[j],best.));
       end;
       else if tempsigns[j] ne "" then do;
           if stresns[j] ne . then cstdvars[j]=cats(tempsigns[j],put(stresns[j],best.));
       end;
    end;

    lbstnrlo=stdlow;
    lbstnrhi=stdhigh;

   *------------------------------------------------------------------------------;
   *LBNRIND;
   *------------------------------------------------------------------------------;

    length lbnrind $10;
    if lbstnrlo ne . and lbstnrhi ne . and lbstresn ne . then do;
      if lbstresn lt lbstnrlo then lbnrind="LOW";
      else if lbstnrlo le lbstresn le lbstnrhi then lbnrind="NORMAL";
      else if lbstresn gt lbstnrhi then lbnrind="HIGH";
    end;
    else if lbstnrlo ne . and lbstnrhi = . and lbstresn ne . then do;
      if lbstresn lt lbstnrlo then lbnrind="LOW";
      else if lbstresn ge lbstnrlo then lbnrind="NORMAL";
    end;
run;

*==============================================================================;
*Create additional variables;
*==============================================================================;

data lb04;
   set lb03;

   if lbdt_raw ne "" then lbdtc=put(input(lbdt_raw,??date11.),yymmdd10.);

   *------------------------------------------------------------------------------;
   *VISITNUM, VISIT;
   *------------------------------------------------------------------------------;

   length visit $40;
   if folder="SCR" then do;
      visit="SCREENING";
      visitnum=1;
   end;
   else if index(upcase(folder),"WEEK") then do;
      visit=upcase(folder);
      visitnum=100+input(compress(folder,,'kd'),best.);
   end;
   else if substrn(upcase(folder),1,2)="FU" then do;
      visit=tranwrd(upcase(folder),"FU","FOLLOW-UP ");
      visitnum=200+input(compress(folder,,'kd'),best.);
   end;
   else if substrn(folder,1,4)="UNS_" then do;
      visit="UNSCHEDULED";
      visitnum=999;
   end;

run;

*==============================================================================;
*Create study day variable;
*==============================================================================;

proc sort data=lb04;
   by usubjid;
run;

data lb05;
   merge lb04(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a;
   rfstdt=input(substrn(rfstdtc,1,10),??yymmdd10.);
   lbdt=input(substrn(lbdtc,1,10),??yymmdd10.);

   if lbdt ne . and rfstdt ne . then lbdy=lbdt-rfstdt+(lbdt>=rfstdt);
run;

*==============================================================================;
*Create baseline flag;
*==============================================================================;

*------------------------------------------------------------------------------;
*Subset the records meeting the baseline definition;
*------------------------------------------------------------------------------;

proc sort data=lb05 out=base01;
   by usubjid lbcat lbtestcd lbdtc;
   where "" lt lbdtc le rfstdtc and (lborres ne "");
run;

*------------------------------------------------------------------------------;
*Identify the closest record to reference start date;
*------------------------------------------------------------------------------;

data base02;
   set base01;
   by usubjid lbcat lbtestcd lbdtc;
   if last.lbtestcd;
run;

*------------------------------------------------------------------------------;
*Populate the baseline flag;
*------------------------------------------------------------------------------;

proc sort data=lb05;
   by usubjid lbcat lbtestcd lbdtc;
run;

data lb06;
   merge lb05(in=a) base02(in=b keep=usubjid lbcat lbtestcd lbdtc);
   by usubjid lbcat lbtestcd lbdtc;
   if b then lbblfl="Y";
run;

*==============================================================================;
*Create lbSEQ variable;
*==============================================================================;

proc sort data=lb06;
   by usubjid lbcat lbtestcd lbdtc;
run;

data lb07;
   set lb06;
   by usubjid lbcat lbtestcd lbdtc;
   if first.usubjid then lbseq=1;
   else lbseq+1;
run;

*==============================================================================;
*Keep only required variables;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID LBSEQ LBTESTCD LBTEST LBCAT  LBORRES LBORRESU LBORNRLO LBORNRHI LBSTRESC LBSTRESN
LBSTRESU LBSTNRLO LBSTNRHI LBBLFL LBNRIND LBSPEC VISITNUM VISIT LBDTC LBDY
;

data lb08;
   retain &varlist.;
   set lb07;
   keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;