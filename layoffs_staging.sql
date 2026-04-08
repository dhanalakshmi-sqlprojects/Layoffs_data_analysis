SELECT * FROM data_analysis.raw_files;


-- Remove the duplicates
-- Standardize data formats
-- Handling the missing /NULL values
-- Remove unwanted columns

-- creating the table  for cleaning

create table data_analysis.layoffs_staging2
SELECT * FROM data_analysis.raw_files;

--  retrive the data

select * from data_analysis.layoffs_staging2;

-- standadize the data

update data_analysis.layoffs_staging2
set company=trim(company),
	industry=trim(industry),
    country=trim(country),
    location=trim(location),
    total_laid_off=trim(total_laid_off),
    percentage_laid_off=trim(percentage_laid_off),
    stage=trim(stage),
    `date`=trim(`date`);
    
    update  data_analysis.layoffs_staging
    set company=lower(company),
        industry=lower(industry);
    
    
-- adding the column row_number

alter table  data_analysis.layoffs_staging2
add  column id int auto_increment primary key;

-- remove the duplicates 

delete t1
from  data_analysis.layoffs_staging2 t1
join data_analysis.layoffs_staging2 t2
on t1.company=t2.company
and t1.industry=t2.industry
and t1.location=t2.location
AND t1.total_laid_off = t2.total_laid_off
AND t1.`date`= t2.`date`
and t1.id > t2.id;


-- RE CHECKING THE DUPLICATES

select 
    company, location, industry, total_laid_off, date,
    COUNT(*) AS duplicate_count
from data_analysis.layoffs_staging2
group by
    company, location, industry, total_laid_off, date
having COUNT(*) > 1;

-- Hadling the NULLS VALUES / MISSING VALUES

-- checking the nulll values
select *
from data_analysis.layoffs_staging2
where total_laid_off is null
or total_laid_off='' ;

-- delete the null  where total_laid_off values

delete 
from data_analysis.layoffs_staging2
where total_laid_off is null;

UPDATE data_analysis.layoffs_staging2
SET total_laid_off= NULL
WHERE TRIM(LOWER(total_laid_off)) in ('','null') ;


-- checking the null values where percentage_laid_off 

select *
from data_analysis.layoffs_staging2
where percentage_laid_off is null;

-- delete the null values from percentage_laid_off

delete 
from data_analysis.layoffs_staging2
where percentage_laid_off is null;
 
-- removing the prcentage symbol in the table

update data_analysis.layoffs_staging2
set percentage_laid_off=replace(percentage_laid_off ,'%','');

UPDATE data_analysis.layoffs_staging2
SET percentage_laid_off = TRIM(percentage_laid_off);

 
UPDATE data_analysis.layoffs_staging2
SET percentage_laid_off= NULL
WHERE TRIM(LOWER(percentage_laid_off)) in ('','null') ;

-- converting the data types

ALTER TABLE data_analysis.layoffs_staging2
modify column  total_laid_off  INT;

ALTER TABLE data_analysis.layoffs_staging2
MODIFY COLUMN percentage_laid_off float;

-- converting the date formates 

update data_analysis.layoffs_staging2
set `date`='01/13/2023'
where `date`='13/01/2023';

select `date`,str_to_date(`date`,'%m/%d/%Y')
from data_analysis.layoffs_staging2;

update data_analysis.layoffs_staging2
set `date`=str_to_date(`date`,'%m/%d/%Y');

-- changing the date  datatype

alter table data_analysis.layoffs_staging2
modify column `date` DATE;

UPDATE data_analysis.layoffs_staging2
SET stage= 'series A'
WHERE stage='seed';

-- remove the unnecessary  column  like id

alter  table  data_analysis.layoffs_staging2
drop column id;


-- Exploratory Data Analysis (EDA )

 select count(*) 
 from data_analysis.layoffs_staging2;
 
 -- Checking the null values
 
  select *
  from data_analysis.layoffs_staging2
  where total_laid_off is NULL
  OR percentage_laid_off IS NULL
  OR `date` IS NULL; 
  
  -- Maxmum layoffs
  select max(total_laid_off)
  from data_analysis.layoffs_staging2;
  
  -- companies wise highest layoffs
  
  select company,sum(total_laid_off) AS TOTAL_LAYOFFS
  FROM data_analysis.layoffs_staging2
  group by company
  order by TOTAL_LAYOFFS desc;
  
  -- Layoffs by industry
  
  SELECT industry, SUM(total_laid_off) AS TOTAL_LAYOFFS
FROM data_analysis.layoffs_staging2
GROUP BY industry
ORDER BY TOTAL_LAYOFFS DESC;
  
  -- Layoffs by country
  
  select country,sum(total_laid_off) AS TOTAL_LAYOFFS
  FROM data_analysis.layoffs_staging2
  group by country
  order by TOTAL_LAYOFFS desc;
  
  -- year wise layoffs trend
  
   select year(date) as year_trend,sum(total_laid_off) as total
   from data_analysis.layoffs_staging2
    group by year_trend
    order by  year_trend;
    
    -- month wise trend
    
    select date_format(date,'%Y-%m') as month_trend,sum(total_laid_off) as total
    from data_analysis.layoffs_staging2
    group by  month_trend
    order by month_trend;
    
    -- top companies  per year
    
    select company,year(date) as year_trend,sum(total_laid_off) as total
    from data_analysis.layoffs_staging2
    group by company,year_trend
    order by year_trend,total desc;
        
SELECT *
FROM data_analysis.layoffs_staging2
WHERE percentage_laid_off = 1;
  
  
















    
    
     
    
   
