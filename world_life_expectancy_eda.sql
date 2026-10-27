select *  from world_life_expectancy;
# duplicate countryro find 
select country, year, concat(country, year),count(concat(country, year))
 from world_life_expectancy
group by country, year, concat(country, year)
having count(concat(country, year)) >1;

select *  
from(select row_id, concat(country, year), 
row_number() over( partition by concat(country, year) order by concat(country, year)) as row_num
 from world_life_expectancy)
 as row_table
 where row_num>1
 ;
 # delete duplicate values
DELETE FROM world_life_expectancy
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT row_id,
               ROW_NUMBER() OVER (
                   PARTITION BY CONCAT(country, year)
                   ORDER BY CONCAT(country, year)
               ) AS row_num
        FROM world_life_expectancy
    ) AS row_table
    WHERE row_num > 1
);

select *  from world_life_expectancy
where Status = '';

select distinct(Status) from world_life_expectancy
where Status<>'';
select distinct(Status) from world_life_expectancy
where country='United States of America';
select distinct(country) from world_life_expectancy
where Status='developing';
select distinct(country) from world_life_expectancy
where country='United States of America';
#this did not work!!!
#update world_life_expectancy 
#set Status='developing'
#where country in (select distinct(country) from world_life_expectancy
#				where Status='developing')
;
update world_life_expectancy t1 join world_life_expectancy t2
on t1.country=t2.country
set t1.Status='developing'
where t1.Status='' and t2.status <> ''
and t2.status ='developing';

# we had 8 rows with no status; only 7 got updated beacuse the 8 th had status as developed

update world_life_expectancy t1 join world_life_expectancy t2
on t1.country=t2.country
set t1.Status='developed'
where t1.Status='' and t2.status <> ''
and t2.status ='developed';
# YAAYYY NO BLANKS

select *  from world_life_expectancy
where `Life expectancy` = '';

#POPULATE WITH THE AVERAGE AS THE LIFE EXPECTANCY IS EXPOTEINALLY INCRESING.

select COUNTRY, year, `Life expectancy` from world_life_expectancy;
#where `Life expectancy` = ''; 

SELECT t1.country, t1.year, t1.`Life expectancy`,
       t2.country, t2.year, t2.`Life expectancy`,
       t3.country, t3.year, t3.`Life expectancy`,
       ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1) AS avg_life_expectancy
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
    ON t1.country = t3.country
    AND t1.year = t3.year + 1
WHERE t1.`Life expectancy` = '';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
    ON t1.country = t3.country
    AND t1.year = t3.year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = '';


# SECOND PART
#EXPLORE DATA -- WHAT WE HAVE?
-- LOWEST EXPENTANCY HIGHER EXPETANCY
select Country,MIN(`Life expectancy`), MAX(`Life expectancy`) ,
ROUND(MAX(`Life expectancy`)-MIN(`Life expectancy`),1) AS LIFE_INCREASE_OVER_15_YEARS
from world_life_expectancy
GROUP BY COUNTRY
HAVING MIN(`Life expectancy`) <> 0 OR MAX(`Life expectancy`) <>0
ORDER BY LIFE_INCREASE_OVER_15_YEARS DESC
;

SELECT YEAR, ROUND(AVG(`Life expectancy`),2) FROM world_life_expectancy
GROUP BY YEAR
HAVING MIN(`Life expectancy`) <> 0 OR MAX(`Life expectancy`) <>0
ORDER BY YEAR
;

SELECT COUNTRY, ROUND(AVG(`Life expectancy`),2) as life_exp, round(avg(GDP),2) as gdp
FROM world_life_expectancy
group by country
having life_exp > 0 and gdp>0
order by gdp desc;
-- high gdp , high life_expectancy

select 
sum(case when gdp >= 1500 then 1 else 0 end) high_gdp_count,
avg(case when gdp >= 1500 then `Life expectancy` else null end) high_gdp_Life_expectancy,
sum(case when gdp <= 1500 then 1 else 0 end) low_gdp_count,
avg(case when gdp <= 1500 then `Life expectancy` else null end) low_gdp_Life_expectancy
from world_life_expectancy
;

select  status, ROUND(AVG(`Life expectancy`),1)
from world_life_expectancy
group by Status ;

select  status,count(distinct(country)),ROUND(AVG(`Life expectancy`),1)
from world_life_expectancy
group by Status ;
-- developed (32) countries have life_expectancy @ 79.2
-- developing (161) countries have life_expectancy @ 66.8

select bmi, country,ROUND(AVG(`Life expectancy`),1) as life_exp from world_life_expectancy
group by bmi,country
having life_exp> 0 and bmi>0
order by bmi asc
;




select * from(SELECT country,
       year,
       `life expectancy`,
       `adult mortality`,
       SUM(`adult mortality`) OVER(PARTITION BY country ORDER BY year) AS rolling_total
FROM world_life_expectancy) as a
where country like 'united%' ;



