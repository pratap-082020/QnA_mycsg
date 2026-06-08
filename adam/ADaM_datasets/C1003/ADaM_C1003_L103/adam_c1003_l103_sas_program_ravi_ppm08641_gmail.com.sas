* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1003_L103;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1003\ADaM_C1003_L103\ADaM_C1003_L103;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input data
=========================================================*/

data ae01;
   set ae;
run;

/*=========================================================
Create ASTDT,TRTA and TRTEMFL variables
=========================================================*/

data ae02;
   set ae01;
   if length(aestdtc)=10 then astdt=input(aestdtc,yymmdd10.);

   format astdt date9.;

   if . lt ap01sdt le astdt le ap01edt then do;
      trta=trt01a;
      trtemfl="Y";
   end;
   else if . lt ap02sdt le astdt le ap02edt then do;
      trta=trt02a;
      trtemfl="Y";
   end;
   else if . lt ap03sdt le astdt le ap03edt then do;
      trta=trt03a;
      trtemfl="Y";
   end;
   if trtemfl="" then trtemfl="N";
run;

/*=========================================================
Keep only required variables and order the variables in a logical sequence
=========================================================*/
data output;
   retain usubjid aedecod astdt trta trtemfl aestdtc ap01sdt ap01edt ap02sdt ap02edt ap03sdt ap03edt;
   set ae02;
   keep usubjid aedecod astdt trta trtemfl aestdtc ap01sdt ap01edt ap02sdt ap02edt ap03sdt ap03edt;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;