* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1007_L102;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1007\ADaM_C1007_L102\ADaM_C1007_L102;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data vs01;
   set vs;
   format adt trtsdt date9.;
run;

/*=========================================================
Check the interval in which the ADY falls for each parameter and assign AVISIT/AVISITN/AWTARGET/AWLO/AWHI
=========================================================*/

data vs02;
   set vs01;
   length avisit $30;
   awu="Days";

   if paramn=1 then do;
      if 2 le ady le 11 then do;
         avisit="Week 1";
         avisitn=1;
         awlo=2;
         awhi=11;
         awtarget=7;
      end;
      else do;
         do i=2 to 10;
            lower=ceil(((i*7)+(i-1)*7)/2)+1;
            higher=((i*7)+(i+1)*7+1)/2;
            target=i*7;
            if lower le ady le higher then do;
               awlo=lower;
               awhi=higher;
               awtarget=target;
               avisitn=i;
               avisit="Week "||strip(put(i,best.));
            end;
         end;
      end;
   end;
   else if paramn=6 then do;
      if 2 le ady le 127 then do;
         awlo=2;
         awhi=127;
         awtarget=84;
         avisitn=12;
         avisit="Week 12";
      end;
      else do;
         do j=24,36;
            lower=ceil(((j*7)+(j-12)*7+1)/2)+1;
            higher=ceil(((j*7)+(j+12)*7+1)/2);
            target=j*7;
            if lower le ady le higher then do;
               awlo=lower;
               awhi=higher;
               awtarget=target;
               avisitn=j;
               avisit="Week "||strip(put(j,best.));
            end;
         end;

      end;
   end;
   drop i j;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid paramcd param paramn avisitn avisit adt ady aval awtarget awlo awhi  awu trtsdt visitnum visit;
   set vs02;
   keep usubjid paramcd param paramn avisitn avisit adt ady aval awtarget awlo awhi  awu trtsdt visitnum visit;
run;

data csg_formoutput;
   set output;
   call missing(awtarget,awlo,awhi,awu,avisitn,avisit);

run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;