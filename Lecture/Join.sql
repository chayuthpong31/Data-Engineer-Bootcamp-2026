SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
LIMIT 10;

SELECT 
    COUNT(*)
FROM 
    job_postings_fact;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_location
FROM job_postings_fact jpf
JOIN company_dim cd ON jpf.company_id = cd.company_id;

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    sd.skills
FROM job_postings_fact jpf
LEFT JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
LIMIT 10;

DESCRIBE skills_dim;