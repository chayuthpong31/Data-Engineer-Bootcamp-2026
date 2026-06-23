/*
Find the top 10 companies for posting jobs
They must have > 3000 postings
Limit this to only US jobs
*/

EXPLAIN ANALYZE
SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS num_postings
FROM job_postings_fact jpf
LEFT JOIN 
    company_dim cd ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY num_postings DESC
LIMIT 10;
