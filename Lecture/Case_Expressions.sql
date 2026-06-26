-- Bucket Salaries
-- < 25 = 'Low'
-- 25-50 = 'Medium'
-- > 50 = 'High'

SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg < 25 THEN 'Low'
        WHEN salary_hour_avg < 50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;


-- Handling Missing Data (Nulls)
-- Filter NULL Salary values
SELECT 
    job_title_short,
    CASE
        WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg
        WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
        ELSE NULL
    END AS salary_category
FROM job_postings_fact
LIMIT 10;

-- Categorizing Categorical Values
-- Classify the `job_title` column values as:
    -- 'Data Analyst'
    -- 'Data Engineer'
    -- 'Data Scientist'

SELECT
    job_title,
    CASE
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
    END AS job_title_category,
    job_title_short
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

-- Final Example: Conditional Calculations
-- Compute a standardized_salary using yearly salary and adjusted hourly salary (e.g. 2080 hours/year)
-- Categorize salaries into tiers of :
    -- < 75K 'Low'
    -- 75K - 150K 'Medium'
    -- >= 150K 'High'
WITH yearly_salary AS(
    SELECT
        job_title_short,
        CASE 
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2080
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
        END AS avg_yearly_salary
    FROM job_postings_fact jpf
)
SELECT
    *,
    CASE
        WHEN avg_yearly_salary IS NULL THEN 'Missing'
        WHEN avg_yearly_salary < 75000 THEN 'Low'
        WHEN avg_yearly_salary < 150000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM yearly_salary
LIMIT 10;