-- Data Cleaning Project 
use project2;
Create Table Layoffs_staging LIKE layoffs;
Insert layoffs_staging Select * From layoffs;
-- 1. Remove Duplicates
With duplicate_cte as(
Select * ,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging
) Select * From duplicate_cte
Where row_num > 1;

-- to delete duplicates create a staging 2 table
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert Into layoffs_staging2 Select * ,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging;
Select * From layoffs_staging2 Where row_num > 1;
Delete From layoffs_staging2 Where row_num > 1;

-- 2. Standardizing Data
Select Distinct(Company), Trim(company) from layoffs_staging2;
Update layoffs_staging2 SET company = trim(company);

select distinct industry from layoffs_staging2 order by 1;
select * from layoffs_staging2 where industry like 'crypto%';
update layoffs_staging2 set industry = 'Crypto' where industry like 'crypto%';

select distinct location from layoffs_staging2 order by 1;

select distinct country from layoffs_staging2 order by 1;
select distinct country, trim(trailing '.' from country) from layoffs_staging2;
update layoffs_staging2 set country = trim(trailing '.' from country) where country like 'United States%'; 

select `date`, str_to_date(`date`, '%m/%d/%Y') AS result from layoffs_staging2 where `date` like '_/__/____';
select `date`, str_to_date(`date`, '%m-%d-%Y') AS result from layoffs_staging2 where `date` Like '__-__-____';

-- update layoffs_staging2 set `date` = str_to_date(`date`, '%m/%d/%Y') where `date` like '_/__/____';
-- update layoffs_staging2 set `date` = str_to_date(`date`, '%m-%d-%Y') where `date` like '__-__-____';
-- update layoffs_staging2 set `date` = str_to_date(`date`, '%m/%d/%Y') where `date` like '_/__/____';
alter table layoffs_staging2
modify column`date` DATE;

select distinct `date` from layoffs_staging2 order by 1;
select * from layoffs_staging2 where `date` is null;

update layoffs_staging2 set industry = null where industry = '';

select * from layoffs_staging2 where total_laid_off is null
and percentage_laid_off is null;

select distinct * from layoffs_staging2 where industry is null or industry = '';

select * from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.industry = t2.industry
    and  t1.location = t2.location
where t1.industry is null
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2 
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry IS NULL
and t2.industry is not null;

select * from layoffs_staging2 where company = 'Airbnb';
select * from layoffs_staging2 where company like 'Bally%';

select * from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

delete from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;










 
