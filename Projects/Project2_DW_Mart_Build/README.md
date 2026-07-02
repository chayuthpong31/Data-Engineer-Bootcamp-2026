# 🏗️Data Warehouse & Mart Build: Production ETL Pipeline

## Executive Summary
![Project 2 ETL Pipeline](../../Images/1_2_Project2_Data_Pipeline.png)

This project builds a production-style data warehouse and analytical marts from job-posting data using DuckDB and SQL. The workflow creates a star schema, loads curated source data from CSV files, and produces business-ready marts for job analysis, skill demand tracking, and role prioritization. The design reflects a realistic analytics engineering process where raw source data is transformed into structured, reusable datasets for reporting and decision-making.

## Problem & Context
Organizations need a reliable, structured view of the labor market to understand hiring trends across companies, roles, and skills. Raw job data is often fragmented, inconsistent, and difficult to analyze directly, especially when the goal is to compare demand across regions, salary levels, and skill categories. This project addresses that challenge by transforming the data into a dimensional model that supports dashboards, reporting, and strategic workforce analysis.

## Tech Stack
- DuckDB for local data warehouse execution and SQL-based transformations
- SQL for schema creation, data loading, transformation, and mart production
- CSV ingestion using DuckDB's read_csv functionality
- Star schema design with fact and dimension tables for analytical efficiency
- Repeatable SQL scripts for end-to-end ETL orchestration and refresh workflows

## Analysis Overview
![Data Warehouse Architecture](../../Images/1_2_Data_Warehouse.png)

This architecture shows how the project organizes job-posting data into a central warehouse built around a fact table and supporting dimensions. The warehouse layer provides the foundation for the flat mart, skills mart, and priority mart by storing consistent, query-friendly data that can be reused across multiple analytical use cases.

The pipeline starts with normalized warehouse tables for companies, skills, job postings, and the bridge between jobs and skills. From these foundations, three analytical marts are created to answer different business questions:

![Flat Mart Structure](../../Images/1_2_Flat_Mart.png)

The flat mart provides a denormalized, job-level view that combines job posting facts with company and skill context. It is designed for broad exploratory analysis, making it easier to inspect job opportunities, associated skills, and company details in a single table.

- A flat mart for denormalized, job-level analysis with company and skill context
- A skills mart for monthly demand and posting characteristics by skill
- A priority mart for tracking high-priority roles and maintaining refreshed snapshot data

![Priority Mart Structure](../../Images/1_2_Priority_Mart.png)

The priority mart focuses on role-based tracking by organizing job postings into priority levels for strategic hiring and workforce planning. It helps highlight roles that deserve extra attention, such as high-value engineering positions, and supports snapshot-based updates as priorities change over time.

### Query Structure
The project is organized into a sequence of SQL scripts that execute in order to build the full data pipeline:
1. Create the core warehouse tables and relationships in the staging/warehouse layer
2. Load dimension and fact data from external CSV sources into the warehouse tables
3. Build the flat mart with denormalized job and company information for broad analysis
4. Create the skills demand mart with monthly aggregates and posting-level indicators
5. Build the priority mart with role-based priorities for strategic hiring analysis
6. Update and merge the priority snapshot so the mart stays current over time

### Key Insights
The resulting warehouse enables analysis of:
- Hiring patterns across companies and job titles
- Skill demand trends over time and by role
- Posting characteristics such as remote work, health insurance, and degree requirements
- Priority-based tracking for strategic hiring roles and workforce planning
- A scalable structure that can be extended with additional dimensions or metrics

## SQL Skills Demonstrated

### Query Design & Optimization
- Used primary and foreign keys to maintain data integrity and enforce relationships
- Applied dimensional modeling to simplify reporting and reduce repeated joins
- Built denormalized marts to improve analytical readability and performance
- Used MERGE and UPDATE logic to keep priority snapshots current and accurate
- Designed reusable SQL steps that can be executed as a complete ETL pipeline

### Data Analysis Techniques
- Joined fact and dimension tables to create business-ready views for reporting
- Aggregated posting counts by month, skill, and job title for trend analysis
- Calculated counts for remote, benefits-related, and no-degree postings to highlight job quality indicators
- Created a priority framework that supports role-based workforce planning and decision-making
- Structured the output so it can be consumed by BI tools or future dashboard layers

## How to Run
1. Open the project folder and make sure DuckDB is installed.
2. Run the main pipeline script from the project directory:
   ```bash
   duckdb dw_marts.duckdb -c ".read build_marts.sql"
   ```
3. This will execute the SQL files in sequence to create the warehouse schema, load data, and build all marts.
4. After execution, you can query the generated tables in DuckDB or inspect the database file for downstream analysis.

### Architecture Diagrams
- [Data Warehouse Schema](../../Images/1_2_Data_Warehouse.png)
- [Flat Mart Structure](../../Images/1_2_Flat_Mart.png)
- [Company and Skills Mart](../../Images/1_2_Company_Mart.png)
- [Priority Mart Structure](../../Images/1_2_Priority_Mart.png)
- [Project 2 ETL Pipeline](../../Images/1_2_Project2_Data_Pipeline.png)

