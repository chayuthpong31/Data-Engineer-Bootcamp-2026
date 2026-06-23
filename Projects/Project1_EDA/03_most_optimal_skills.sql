/*
Question: What are the most optimal skills for data engineers-balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why? This approach highlights skills that balance market demand and financial reward.
        It weights core skills appropriately, rather than letting rare, outlier skills distort the results.
*/
WITH skill_salaries AS(
SELECT
    jpf.job_id,
    sd.skills,
    CASE 
        WHEN jpf.salary_year_avg IS NOT NULL THEN jpf.salary_year_avg
        WHEN jpf.salary_hour_avg IS NOT NULL THEN jpf.salary_hour_avg * 2080
        ELSE NULL
    END AS yearly_avg_salary
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer' AND jpf.job_work_from_home = True 
)

SELECT
    RANK() OVER (ORDER BY MEDIAN(yearly_avg_salary) * LN(COUNT(job_id)) DESC) AS skill_rank,
    skills,
    ROUND(MEDIAN(yearly_avg_salary), 1) AS median_salary,
    ROUND(LN(COUNT(job_id)), 1) AS demand_count,
    ROUND((MEDIAN(yearly_avg_salary) * LN(COUNT(job_id)) / 1_000_000),2) AS optimal_score
FROM skill_salaries
GROUP BY skills
ORDER BY optimal_score DESC
LIMIT 25;

/*
Output:
┌────────────┬────────────┬───────────────┬──────────────┬───────────────┐
│ skill_rank │   skills   │ median_salary │ demand_count │ optimal_score │
│   int64    │  varchar   │    double     │    double    │    double     │
├────────────┼────────────┼───────────────┼──────────────┼───────────────┤
│          1 │ sql        │      130000.0 │         10.3 │          1.34 │
│          2 │ python     │      130000.0 │         10.3 │          1.33 │
│          3 │ spark      │      140000.0 │          9.5 │          1.32 │
│          4 │ airflow    │      140000.0 │          9.2 │          1.29 │
│          5 │ aws        │      130250.0 │          9.8 │          1.27 │
│          6 │ terraform  │      156000.0 │          8.1 │          1.26 │
│          7 │ kafka      │      140000.0 │          8.8 │          1.23 │
│          8 │ snowflake  │      135000.0 │          9.1 │          1.22 │
│          9 │ java       │      135000.0 │          8.9 │           1.2 │
│         10 │ azure      │      125000.0 │          9.6 │          1.19 │
│         11 │ scala      │      135000.0 │          8.7 │          1.18 │
│         12 │ databricks │      130000.0 │          9.0 │          1.17 │
│         13 │ kubernetes │      139500.0 │          8.3 │          1.16 │
│         14 │ pyspark    │      136042.0 │          8.5 │          1.16 │
│         15 │ git        │      135200.0 │          8.4 │          1.14 │
│         16 │ gcp        │      130000.0 │          8.8 │          1.14 │
│         17 │ docker     │      134595.0 │          8.4 │          1.13 │
│         18 │ redshift   │      130000.0 │          8.7 │          1.13 │
│         19 │ hadoop     │      130500.0 │          8.6 │          1.12 │
│         20 │ pandas     │      140000.0 │          8.0 │          1.12 │
│         21 │ mongodb    │      135200.0 │          8.2 │           1.1 │
│         22 │ nosql      │      130000.0 │          8.4 │          1.09 │
│         23 │ rust       │      200000.0 │          5.4 │          1.09 │
│         24 │ bigquery   │      130000.0 │          8.2 │          1.06 │
│         25 │ go         │      135200.0 │          7.6 │          1.03 │
└────────────┴────────────┴───────────────┴──────────────┴───────────────┘

Key Insights:
1. SQL and Python are the most optimal skills for remote data engineers, balancing high demand and competitive salaries, making them essential for career growth in this field.
2. Cloud platforms (AWS, Azure, GCP) and big data tools (Spark, Airflow) also rank highly, indicating their importance in the data engineering landscape.
3. The optimal score provides a balanced view of both salary and demand, helping data engineers prioritize skills that offer the best career opportunities in the remote job market.
*/