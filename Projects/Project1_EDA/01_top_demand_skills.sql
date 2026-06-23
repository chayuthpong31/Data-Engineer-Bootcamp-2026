/*
Question: What are the top 10 most in-demand skills for data engineer?
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote
    job market, providing insights into the most valuable skills for data
    engineers seeking remote work.
*/

SELECT
    sd.skills,
    COUNT(jpf.job_id) AS demand_count,
    (COUNT(jpf.job_id) / (SELECT COUNT(*) FROM job_postings_fact WHERE job_title_short = 'Data Engineer' AND job_work_from_home = TRUE)) * 100 AS demand_percentage
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer' AND jpf.job_work_from_home = TRUE
GROUP BY sd.skills
ORDER BY job_count DESC
LIMIT 10;


/*
Output:
┌────────────┬───────────┬────────────────────┐
│   skills   │ job_count │ demand_percentage  │
│  varchar   │   int64   │       double       │
├────────────┼───────────┼────────────────────┤
│ sql        │     29221 │  66.63398171162748 │
│ python     │     28776 │  65.61922787494584 │
│ aws        │     17823 │  40.64260141837502 │
│ azure      │     14143 │ 32.250929240872914 │
│ spark      │     12799 │ 29.186144619524317 │
│ airflow    │      9996 │ 22.794335621280187 │
│ snowflake  │      8639 │ 19.699906505826284 │
│ databricks │      8183 │ 18.660068866440152 │
│ java       │      7267 │ 16.571272204866258 │
│ gcp        │      6446 │ 14.699108384831142 │
└────────────┴───────────┴────────────────────┘

Key Insights:
1. SQL and Python are the most in-demand skills for data engineers seeking remote work, with demand percentages of approximately 66.63% and 65.62% respectively that remain the foundational skills for data engineers.
2. Cloud platforms like AWS, Azure, and GCP are highly sought-after skills, indicating the growing importance of cloud-based data engineering.
3. Specialized tools such as Spark and Airflow are also in high demand, highlighting the need for expertise in big data and workflow automation.
*/