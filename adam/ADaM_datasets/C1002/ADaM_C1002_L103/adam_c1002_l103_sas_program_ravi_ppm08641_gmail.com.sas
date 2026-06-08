* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1002_L103;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1002\ADaM_C1002_L103\ADaM_C1002_L103;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data ae01;
   set ae;
run;

/*=========================================================
Create ASTDT and ASTDTF variables
=========================================================*/

data ae02;
   set ae01;
   aest_year=scan(aestdtc,1,'-');
   aest_month=scan(aestdtc,2,'-');
   aest_day=scan(aestdtc,3,'-');

   if not missing(trtsdt) then do;
      trtst_year=put(year(trtsdt),4.);
      trtst_month=put(month(trtsdt),z2.);
      trtst_day=put(day(trtsdt),z2.);

      trtsdtc=put(trtsdt,yymmdd10.);
   end;

   if length(aestdtc)=10 then astdt=input(aestdtc,yymmdd10.);
   else if length(aestdtc)=7 then do;
      astdtf="D";
      if aestdtc=substrn(trtsdtc,1,7) then
         astdt=input(cats(aestdtc,"-",trtst_day),yymmdd10.);
      else if aestdtc gt substrn(trtsdtc,1,7) then astdt=input(cats(aestdtc,"-01"),yymmdd10.);
      else if aestdtc le substrn(trtsdtc,1,7) then
         astdt=intnx('month',input(cats(aestdtc,"-01"),yymmdd10.),0,'e');
   end;
   else if length(aestdtc)=4 then do;
      astdtf="M";
      if aest_year gt trtst_year then astdt=input(cats(aestdtc,"-01-01"),yymmdd10.);
      else if aest_year=trtst_year then astdt=trtsdt;
      else if aest_year lt trtst_year then astdt=input(cats(aestdtc,"-12-31"),yymmdd10.);
   end;
   format astdt date9.;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid aestdtc astdt trtsdt astdtf;
   set ae02;
   keep usubjid aestdtc astdt astdtf trtsdt;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;