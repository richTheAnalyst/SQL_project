-- Data Cleaning 
SELECT * 
FROM layoffs1;
 
 -- checking for duplicates
 
CREATE TABLE layoffs1
LIKE layoffs;

INSERT INTO layoffs1
SELECT * FROM layoffs;
 
 SELECT *, ROW_NUMBER() OVER( PARTITION BY company, location, industry, total_laid_off,percentage_laid_off
 , `date`, stage, country, funds_raised_millions) AS row_num
 FROM layoffs1;
 
 WITH duplicate_cte AS
 (
 SELECT *, ROW_NUMBER() OVER( PARTITION BY company, location, industry, total_laid_off,percentage_laid_off
 , `date`, stage, country, funds_raised_millions) AS row_num
 FROM layoffs1
 )
 SELECT * FROM
 duplicate_cte
 WHERE row_num > 1;
 

 CREATE TABLE `layoffs2` (
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

SELECT * FROM
layoffs2;

INSERT INTO layoffs2
 SELECT *, ROW_NUMBER() OVER( PARTITION BY company, location, industry, total_laid_off,percentage_laid_off
 , `date`, stage, country, funds_raised_millions) AS row_num
 FROM layoffs1;
 
SELECT *
 FROM layoffs2
 WHERE row_num > 1;
 
 -- Standarzing Data
 SELECT * FROM 
 layoffs2;
 
SELECT *
 FROM layoffs2
 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
 
 SELECT DISTINCT(company)
FROM layoffs2
ORDER BY 1;

UPDATE layoffs2
SET company = 'AppGate'
WHERE company = 'Appgate';
 
 SELECT t1.industry,t2.industry
 FROM layoffs2 t1
 JOIN layoffs2 t2
 ON t1.company = t2.company
 WHERE (t1.industry IS  NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
 
 UPDATE layoffs2 t1
  JOIN layoffs2 t2
 ON t1.company = t2.company
 SET t1.industry = t2.industry
  WHERE (t1.industry IS  NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
 
 UPDATE layoffs2
 SET industry = 'Crypto'
 WHERE industry = 'Crypto Currency' ;
 
 SELECT DISTINCT(country), TRIM(TRAILING '.' FROM country )
 FROM layoffs2
 ORDER BY 1;
 
 UPDATE layoffs2
 SET country =  TRIM(TRAILING '.' FROM country )
 WHERE country = 'United States.';
 
 SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
 FROM layoffs2;
 
UPDATE layoffs2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT * 
FROM layoffs2;

UPDATE layoffs2
SET percentage_laid_off = (50*0.12)/50
WHERE company = 'Ethos Life'
AND location = 'SF Bay Area'
AND industry = 'Finance'
AND percentage_laid_off IS NULL;

SELECT percentage_laid_off, ROUND(percentage_laid_off,2) 
FROM layoffs2;

UPDATE layoffs2
SET percentage_laid_off = 0
WHERE percentage_laid_off = 0.000375000
;
ALTER TABLE  layoffs2
DROP COLUMN row_num



 
 
 