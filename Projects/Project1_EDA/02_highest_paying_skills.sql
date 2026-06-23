/*
Question: What are the hightest-paying skills for data engineer?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? 
    - Helps identify which skills command the highest compensation
      while also showing how common those skills are, providing a more
      complete picture for skill development priorities.
    - The median is used instead of the average to reduce the impact of outlier salary
*/

WITH skill_salaries AS(
    SELECT 
        jpf.job_id,
        jpf.job_title_short,
        sd.skills,
        CASE
        WHEN jpf.salary_year_avg IS NOT NULL THEN jpf.salary_year_avg
        WHEN jpf.salary_hour_avg IS NOT NULL THEN jpf.salary_hour_avg * 2080
        ELSE NULL
    END AS yearly_avg_salary
    FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
    (jpf.job_title_short = 'Data Engineer' AND jpf.job_work_from_home = True) 
)

SELECT 
    skills,
    ROUND(MEDIAN(yearly_avg_salary), 1) AS median_salary,
    COUNT(job_id) AS skill_frequency
FROM skill_salaries
GROUP BY skills
ORDER BY median_salary DESC
LIMIT 25;

/*
Output:
┌───────────────┬───────────────┬─────────────────┐
│    skills     │ median_salary │ skill_frequency │
│    varchar    │    double     │      int64      │
├───────────────┼───────────────┼─────────────────┤
│ rust          │      200000.0 │             232 │
│ next.js       │      180000.0 │              19 │
│ haskell       │      172500.0 │              17 │
│ erlang        │      172500.0 │               9 │
│ ocaml         │      172500.0 │               1 │
│ neo4j         │      171237.8 │             277 │
│ solidity      │      166250.0 │              45 │
│ ggplot2       │      162500.0 │              15 │
│ centos        │      159350.0 │              31 │
│ mxnet         │      157500.0 │               5 │
│ terraform     │      156000.0 │            3248 │
│ zoom          │      156000.0 │             127 │
│ drupal        │      156000.0 │               9 │
│ groovy        │      156000.0 │             118 │
│ mongo         │      156000.0 │             265 │
│ django        │      155000.0 │             265 │
│ elixir        │      155000.0 │              37 │
│ gdpr          │      155000.0 │             582 │
│ graphql       │      155000.0 │             445 │
│ trello        │      155000.0 │              36 │
│ db2           │      151250.0 │             404 │
│ svelte        │      150800.0 │               4 │
│ julia         │      150500.0 │              34 │
│ ruby on rails │      150000.0 │              75 │
│ sharepoint    │      150000.0 │             189 │
└───────────────┴───────────────┴─────────────────┘

Key insights:

*/
