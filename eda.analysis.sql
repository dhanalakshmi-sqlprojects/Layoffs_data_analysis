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
  
  














