-- Subquery
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
)
LIMIT 10;

-- CTEs
WITH valid_salaries AS(
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)

SELECT *
FROM valid_salaries
LIMIT 10;

-- 🧩 Scenario 1 - Subquery in `SELECT`
-- Show each job's salary next to the overall market median:
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;

-- 🧩 Scenario 2 -- Subquery in FROM
-- Stage only jobs that are remote before aggregating to determine the remote median salary per job
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short;

-- 🧩 Scenario 3 -- Subquery in HAVING
-- Keep only job titles whose median salary is above the overall median
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
) ;

-- CTE Example
-- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
-- Use a CTE to calculate the median salary by title and work arrangement, then compare those medians.
WITH remote_jobs AS(
    SELECT
        job_title_short,
        MEDIAN(salary_year_avg) AS remote_median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States' AND job_work_from_home = TRUE
    GROUP BY job_title_short
),
onsite_jobs AS (
    SELECT
        job_title_short,
        MEDIAN(salary_year_avg) AS onsite_median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States' AND job_work_from_home = FALSE
    GROUP BY job_title_short
)
SELECT
    rj.job_title_short,
    rj.remote_median_salary::INT AS remote_median_salary,
    oj.onsite_median_salary::INT AS remote_median_salary,
    (remote_median_salary - onsite_median_salary)::INT AS remote_premium
FROM remote_jobs rj 
INNER JOIN  onsite_jobs oj ON rj.job_title_short = oj.job_title_short;

WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)
SELECT
    r.job_title_short,
    r.median_salary,
    o.median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median r
INNER JOIN title_median o ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;

SELECT *
FROM range(3) AS src(key)
WHERE NOT EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);

-- Final Example
-- Identify job postings that have no associated skills before loading them into a data mart
SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT *
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;

SELECT *
FROM job_postings_fact tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM skills_job_dim src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;