proc import datafile='Y:\My Drive\Estate\git\mi\df\pistna.xlsx' out=pist
replace
dbms=xlsx;
run;
/* see type of imported variables */
proc contents data=pist;
run;
/* see number of missing */
proc means data=pist n nmiss;
var _all_;
run;
/* proc logistic with available cases 
also referred to as 'Available Case Analysis'
*/
proc logistic data=pist;
class v5 v6;
model v1= v2--v6;
run;
/* macro to stop graphics */
%macro odsOFF;
ods graphics off; ods results off; ods exclude all;
options nonotes;
%mend;
%macro odsON;
ods graphics on; ods results; ods exclude none;
options notes;
%mend;
/* */
%macro efficiency(dist,k,imp,burn);
%do i=1 %to &k;
%let prior=%scan(&dist,&i);

%odsOff;
proc mi data=pist nimpute=&imp out=ris_discrim_&prior seed=545;
var v2--v6;
class v5 v6;
fcs nbiter=&burn reg(v2/details)
	 discrim(v5/details classeffects=include prior=&prior);
run;

proc logistic data=ris_discrim_&prior plots=roc;
class v5(ref='0') v6(ref='0') /  param=ref;
model v1(ref='0')=v2--v6 / link=glogit covb ;
by _imputation_;
ods output ParameterEstimates=lgsparms_&prior;
run;

proc mianalyze parms(link=glogit classvar=ClassVal0)=lgsparms_&prior;
class v5 v6;
modeleffects intercept v2 v3 v4 v5 v6 ;
ods output VarianceInfo=vi_&prior;
run;

proc means data=vi_&prior mean;
var releff;
ods output summary=s_&prior;
run;
%odsOn;

data s_&prior;
set s_&prior;
Prior="&prior";
run;
%end;

data sumup;
length Prior $35;
set s_jeffreys
	s_equal
	s_proportional
	s_ridge;
run;

proc print data=sumup;
run;
%mend;
/* use macro to test which prior works best */
%efficiency(dist=equal jeffreys proportional ridge,k=4,imp=2,burn=1)
