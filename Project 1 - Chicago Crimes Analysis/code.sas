Step 1: Accessing Data
/* Using proc import to import xlsx file initially, Do not run, takes 10 mins to load */
options validvarname=v7;
proc import datafile="/home/u60639771/Chicago_Crime/Chicago_Crimes_2001-2022.xlsx" dbms=xlsx
out=mydata.crime_out;

/* Create library called mydata which has the crime data set */
libname mydata "/home/u60639771/Projects";

Step 2: Data Exploration
/* Using proc contents to understand the data set */
proc contents data=mydata.crime_out;
run;

/* Diff data values in a single column */
proc freq data=mydata.crime_out;
tables Primary_Type;
run;


/* Proc Freq & Cross Tabulation */
/* Use crosslist for aggregates */
proc freq data=mydata.crime_out;
tables Primary_Type*Arrest / norow nocol nocum;
run;

Step 3: Data Cleaning
/* Using Keep function to keep only a limited number of variables for further analysis */
data crime1;
set mydata.crime_out;
keep ID Date Primary_Type Location_Description Community_Area Arrest;
run;

Step 4: Data Manipulation
/* Subsetting data to MOTOR VEHICLE THEFT and creating new variables*/
data crime2;
set work.crime1;
keep ID NewDate Year Month Day Primary_Type Location_Description Community_Area Arrest;
where Primary_Type="MOTOR VEHICLE THEFT";
/* Date = '01JAN2001'd; */
NewDate=datepart(Date);
format NewDate date9.;
Year = year(NewDate);
Month = month(NewDate);
Day = day(NewDate);
run;

/* Creating format for Arrest */
proc format;
value arr
       0='No'
       1='Yes';
run;

/* Using arr format */
data crime3;
set crime2;
format arrest arr.;
run;

Step 5: Data Analysis & Interpretation
/* proc freq */
proc freq data=crime3 order=freq;
tables Year;
run;

/* No Motor Vehicle Theft in 2003 2004? */
data crimenew;
set mydata.crime_out;
where year(Date) in(2003,2004) and Primary_Type="MOTOR VEHICLE THEFT";
run;

/* Macros */
%macro tabs (data, vari);
proc freq data=&data order=freq;
tables &vari;
run;
%mend;

%tabs (work.crime3, Community_Area);
%tabs (work.crime3, Location_Description);
%tabs (work.crime3, Arrest);
%tabs (work.crime3, Month);

