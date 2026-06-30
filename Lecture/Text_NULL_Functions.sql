-- Length & Count
SELECT LENGTH('SQL');
SELECT CHAR_LENGTH('SQL');

SELECT LOWER('SQL');
SELECT UPPER('sql');

-- Substring/Extraction
SELECT LEFT('SQL', 2);
SELECT RIGHT('SQL', 2);
SELECT SUBSTRING('SQL', 2, 1);

-- Concatenation
SELECT CONCAT('SQL','-','Functions');
SELECT 'SQL'||'-'||'Functions';

-- Trimming
SELECT TRIM(' SQL ');
SELECT LTRIM(' SQL ');
SELECT RTRIM(' SQL ');

-- Replacement
SELECT REPLACE('SQL', 'Q', '_');
SELECT REGEXP_REPLACE('data.nerd@gmail.com', '^.*(@)', '\1');


-- Final Example
WITH title_lower AS(
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;

SELECT NULLIF(10, 10);

SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;

-- ***Coalesce*** : Returns first non-NULL value usually use in SCD
SELECT COALESCE(NULL, NULL, 2);

SELECT
    COALESCE(salary_hour_avg * 2080, salary_year_avg)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 10;

-- Final Example -- Simplify with Coalesce
SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_hour_avg * 2080, salary_year_avg) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_hour_avg * 2080, salary_year_avg) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_hour_avg * 2080, salary_year_avg) < 75000 THEN 'Low'
        WHEN COALESCE(salary_hour_avg * 2080, salary_year_avg) < 150000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;