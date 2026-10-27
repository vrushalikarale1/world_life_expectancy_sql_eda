# World Life Expectancy Data Cleaning & Exploratory Data Analysis (EDA)


Overview: This project focuses on cleaning and analyzing a global life expectancy dataset using MySQL. 
The script is divided into two primary phases: 
Data Cleaning & Imputation: Identifying and removing duplicate records, imputing missing status values (Developing vs. Developed), and filling missing life expectancy values using average interpolation.
Exploratory Data Analysis (EDA): 
Analyzing trends in life expectancy over time, assessing the impact of economic metrics (GDP) and health indicators (BMI, Adult Mortality), and comparing life expectancy across developed and developing nations.  




1. Data Cleaning Phase
   Duplicate Identification & Removal:
Used ROW_NUMBER() OVER (PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) to locate duplicate country-year entries.   Executed a DELETE statement targeting duplicate row_id values.
   Status Imputation:Filled blank Status entries by joining the table to itself (t1 JOIN t2 ON t1.country = t2.country) to inherit existing status values (Developing or Developed) for missing years.
   Missing Life Expectancy Imputation:Imputed missing Life expectancy values by joining adjacent consecutive years (Year - 1 and Year + 1) for the same country and calculating the average of the neighboring years:


2. Exploratory Data Analysis (EDA) phase
   Life Expectancy Trends: Evaluated minimum, maximum, and total increase in life expectancy per country over a 15-year window.   Calculated the yearly global average life expectancy to analyze overall global progression.
   Economic Correlation (GDP vs. Life Expectancy): Computed average GDP alongside average life expectancy per country.   Segmented records into high-GDP ($\ge 1500$) and low-GDP ($\le 1500$) buckets using conditional aggregation (CASE WHEN) to evaluate the difference in life expectancy averages.
   Development & Health Metrics: Aggregated country counts and average life expectancy grouped by development status (Developed vs. Developing).   Analyzed body mass index (BMI) correlations with life expectancy.   Utilized window functions (SUM() OVER (PARTITION BY country ORDER BY year)) to calculate rolling totals for adult mortality.    
