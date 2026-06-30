SELECT
    job_id,
    COUNT(*) OVER ()
FROM job_postings_fact;

-- Aggregate
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (PARTITION BY job_title_short) AS avg_hourly_by_title
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 10;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (ORDER BY salary_hour_avg DESC) AS rank_hourly_salary 
FROM job_postings_fact
ORDER BY 
salary_hour_avg DESC
LIMIT 10;

SELECT
    job_posted_date,
    job_title_short,
    salary_year_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    )
FROM job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;

SELECT 
    sd.skills,
    COUNT(jpf.job_id) AS job_count   
FROM job_postings_fact jpf
LEFT JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE LOWER(jpf.job_title_short) LIKE '%data%' AND LOWER(jpf.job_location) LIKE '%thai%'
GROUP BY sd.skills
ORDER BY job_count DESC
LIMIT 20;

-- ROW_NUMBER() -- Providing a new job_id
SELECT 
    *, 
    ROW_NUMBER() OVER (
        ORDER BY job_posted_date
    )
FROM job_postings_fact
ORDER BY job_posted_date
LIMIT 20;

-- LAG() - Time Based Comparison of Company Yearly Salary
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary,
    salary_year_avg - LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 30;

-- LEAD() - 
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS next_posting_salary,
    salary_year_avg - LEAD(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 30;