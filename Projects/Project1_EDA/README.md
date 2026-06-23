# Project 1 - Exploratory Data Analysis for Data Engineer Skills

## Project Summary
This project explores the remote Data Engineer job market by analyzing skills demand, compensation, and the optimal balance between the two. The analysis uses the available job posting dataset and focuses on remote positions with the job title `Data Engineer`.

## Files and Analysis

### `01_top_demand_skills.sql`
- Objective: Identify the top 10 most in-demand skills for remote Data Engineer roles.
- Approach: Count the number of remote Data Engineer job postings associated with each skill and calculate the percentage of demand relative to all remote Data Engineer postings.
- Key findings: `SQL` and `Python` are the top remote Data Engineer skills, followed by major cloud and data engineering technologies such as `AWS`, `Azure`, `Spark`, `Airflow`, `Snowflake`, `Databricks`, `Java`, and `GCP`.

### `02_highest_paying_skills.sql`
- Objective: Determine which skills command the highest median salary for remote Data Engineer positions.
- Approach: Calculate median annual salary for each skill by using annual salary directly when available and converting hourly salary to annual using 2,080 hours per year. Focus is on remote Data Engineer postings with salary data.
- Key findings: Some specialized skills such as `Rust`, `Next.js`, `Haskell`, `Erlang`, `OCaml`, `Neo4j`, and `Solidity` appear at the top of the median salary ranking. This query also includes the frequency of each skill, showing how commonly each high-paying skill occurs.

### `03_most_optimal_skills.sql`
- Objective: Rank skills based on a combined measure of demand and salary to identify the most valuable skills for remote Data Engineers.
- Approach: Compute an optimal score using median salary multiplied by the natural logarithm of the skill frequency, then rank skills by that score.
- Key findings: The highest-ranked skills that balance strong demand and solid compensation include `SQL`, `Python`, `Spark`, `Airflow`, `AWS`, `Terraform`, `Kafka`, `Snowflake`, `Java`, and `Azure`.

## Overall Insights
- Core technical skills like `SQL` and `Python` remain essential for remote Data Engineer roles.
- Cloud platforms and big data tools are critical, with cloud providers (`AWS`, `Azure`, `GCP`) and orchestration technologies (`Spark`, `Airflow`, `Snowflake`, `Databricks`) appearing across analyses.
- High salary does not always align with highest demand. Rare or niche skills can pay well, but the most broadly valuable skills are those that combine high demand and strong compensation.
- The optimal skills ranking helps prioritize growth in areas that are both widely required and financially rewarding.

## How to Use
1. Open the SQL files in a local SQL engine such as DuckDB.
2. Execute the queries against the job postings dataset.
3. Review the results to understand demand, salary, and balanced skill value for remote Data Engineers.

## Notes
- Analysis is limited to remote Data Engineer postings.
- Salary analysis uses median values to reduce the effect of outliers.
- Hourly salaries are converted to annual using a standard 2,080-hour work year.
