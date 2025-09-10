-- Explorartory Data Analysis

select * from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off) from layoffs_staging2;
select * from layoffs_staging2 where percentage_laid_off = 1 order by funds_raised_millions desc;
select company, SUM(total_laid_off) from layoffs_staging2 group by company order by 2 desc;
select min(`date`), max(`date`) from layoffs_staging2;
select industry, SUM(total_laid_off) from layoffs_staging2 group by industry order by 2 desc;
select country, SUM(total_laid_off) from layoffs_staging2 group by country order by 2 desc;
select Year(`date`), sum(total_laid_off) from layoffs_staging2 group by year(`date`) order by 1 desc;
select stage, sum(total_laid_off) from layoffs_staging2 group by stage order by 2 asc;
select substring(`date`, 1,7) as month, sum(total_laid_off) from layoffs_staging2 where substring(`date`, 1,7) is not null
group by month order by 1 asc;

with rolling_total as
(
select substring(`date`, 1,7) as month, sum(total_laid_off) as total_off from layoffs_staging2 where substring(`date`, 1,7) is not null
group by month order by 1 asc
)
select month , total_off
,sum(total_off) over(order by month)
from rolling_total;

select company, YEAR(`date`), sum(total_laid_off) from layoffs_staging2 group by company, YEAR(`date`) order by 3 desc;

with Company_Year(company, years, total_laid_off) AS
(
select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging2 group by company, YEAR(`date`)
),
Company_Year_Rank as
(
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Company_Year
where years is not null
)
select * from Company_Year_Rank
where ranking <= 5 order by 1 asc;











 