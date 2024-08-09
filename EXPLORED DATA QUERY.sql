SELECT * 
FROM layoffs2;
-- Exploratory Data Analysis

-- checking to be sure if there are no duplicates
WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company,location , industry, total_laid_off, percentage_laid_off,
 `date`, country, funds_raised_millions) AS row_num
FROM layoffs2
)
SELECT * FROM
duplicate_cte
WHERE row_num > 1;

SELECT *, ROW_NUMBER() OVER(
PARTITION BY company,location , industry, total_laid_off, percentage_laid_off,
 `date`, country, funds_raised_millions) AS row_num
FROM layoffs2
WHERE row_num > 1;

CREATE TABLE `layoffs3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT * 
FROM layoffs3 ;
INSERT INTO 
layoffs3
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company,location , industry, total_laid_off, percentage_laid_off,
 `date`, country, funds_raised_millions) AS row_num
FROM layoffs2;
SELECT * FROM layoffs3
WHERE row_num > 1;

DELETE FROM Layoffs3
WHERE row_num >1;

ALTER TABLE layoffs3
DROP COLUMN row_num;







-- NOW THE EXPLORATION STARTS WITH TABLE layoffs3

SELECT * 
FROM layoffs3;

SELECT MAX(total_laid_off), MIN(total_laid_off) 
,MAX(percentage_laid_off),MIN(percentage_laid_off)
FROM layoffs3;

SELECT * 
FROM layoffs3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs3
GROUP BY company
ORDER BY 2 DESC;

SELECT  MIN(`date`), MAX(`date`)
FROM layoffs3 ;

SELECT industry, SUM(total_laid_off)
FROM layoffs3
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs3
GROUP BY country
ORDER BY 2 DESC;

SELECT DISTINCT(country), industry ,YEAR(`date`), SUM(total_laid_off)
FROM layoffs3
GROUP BY YEAR(`date`), industry, country
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`, 1,7) AS MONTH , SUM(total_laid_off)
FROM  layoffs3
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH rollingTotal_cte AS
(
SELECT  SUBSTRING(`date`, 1,7) AS MONTH , SUM(total_laid_off) AS totalLaidOff
FROM  layoffs3
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,
totalLaidOff, SUM(totalLaidOff) OVER(ORDER BY `MONTH`) AS rolling_total
FROM RollingTotal_cte;

SELECT company,YEAR(`date`) AS years , SUM(total_laid_off)
FROM layoffs3
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year ( company, years, total_laid_off)  AS
(
SELECT company,YEAR(`date`) , SUM(total_laid_off)
FROM layoffs3
GROUP BY company, YEAR(`date`)
),  Company_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC)
AS LaidOffs_rank
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_rank
WHERE LaidOffs_rank <=5;


SELECT *
FROM layoffs3;


WITH Company_Year ( company, industry, funds_raised_millions)  AS
(
SELECT company,industry , SUM(funds_raised_millions)
FROM layoffs3
GROUP BY company, industry 
),  Company_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY industry  ORDER BY funds_raised_millions DESC)
AS LaidOffs_rank
FROM Company_Year

)
SELECT * 
FROM Company_rank
WHERE LaidOffs_rank <=5;



WITH Company_Year ( company, years, funds_raised_millions)  AS
(
SELECT company,YEAR(`date`) , SUM(funds_raised_millions)
FROM layoffs3
GROUP BY company, YEAR(`date`)
),  Company_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY funds_raised_millions DESC)
AS LaidOffs_rank
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_rank
WHERE LaidOffs_rank <=5;
