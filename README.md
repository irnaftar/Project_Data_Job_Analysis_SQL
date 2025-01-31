# Introduction 
As I move into this data job market, the data analyzed focused on Data Analyst roles. The project explores top-paying jobs, in-demand skills, and where high-demand skills meet high salaries in Data Analytics.

SQL queries? Check them out here: [Open project_sql](./project_sql/)

# Background
## The questions I wanted to answer through my SQL queries were: 
    1. What are the top-paying jobs for my role? 
    2. What are the skills required for these top-paying roles? 
    3. What are the most in demand skills for my role? 
    4. What are the top skills based on salary for my role? 
    5. What are the most optimal skills to learn? 
Optimal: High Demand AND High Paying 
# Tools I used
For the analysis, the tools that were utilized: 
- **SQL**: This tool allowed me to query the database and discover critical insights outlined in this document.
- **PostgresSQL**: The chosen database management system, ideal for handling the job posting data. 
- **Visual Studio Code**: Used for database management and executing SQL queries. 
- **Git, GitHub Desktop, Github**: Essential for version contorl and sharing my SQL scripts and analysis. 
# The Analysis
5 queries were executed and each focused on identifying a specific aspect of the analysis: 

### 1. Top Paying Data Analyst Jobs
![Top pay jobs](<project_sql/assets/Top paying jobs.png>)

```SQL
/*
Question: What are the top-paying data analyst jobs? 
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focus on job postings with specified salaries (remove nulls).
-Why? Highlight the top-paying opportunities for Data Analysts.
*/

SELECT
    JP.job_id,
    JP.job_title,
    Company.name AS company_name,
    JP.job_location, 
    JP.job_schedule_type,
    JP.salary_year_avg,
    JP.job_posted_date
    

FROM
    job_postings_fact AS JP
    LEFT JOIN company_dim AS Company ON JP.company_id = Company.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10; 


```
### 2. Top paying skills

![Top 10 Data Skills](<project_sql/assets/Top 10 Data Analyst skills.png>)

```SQL
/*
Question: WHat skills are required for the top-paying data analyst jobs? 
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specifi skills required for these roles
-Why? To provide a detailed look at which high-paying jobs demand certain skills
*/


WITH top_paying_jobs AS (SELECT
    JP.job_id,
    JP.job_title,
    Company.name AS company_name,
    JP.salary_year_avg
FROM
    job_postings_fact AS JP
    LEFT JOIN company_dim AS Company ON JP.company_id = Company.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10)

SELECT
    top_paying_jobs.*, --(the .* selects all information in the top_paying_jobs table)
    skills
FROM 
    top_paying_jobs 
    INNER JOIN skills_job_dim AS skills ON top_paying_jobs.job_id = skills.job_id
    INNER JOIN skills_dim ON skills.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
The break down of the most demand skill is as follows:

- SQL is leading with a bold count of 8.
- Python follows closely with a bold count of 7.
- Tableau is also highly sough after, with a bold count of 6.
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.
*/
```
### 3. Top demanded skill
![Top 5 Demanded Skills](<project_sql/assets/Top 5 Demanded skills.png>)

``` SQL
/*
Question: What are the most in-demand skills for data analysts? 
- Join job postings to inner join table similar to query 2 
- Identify the top 5 in-demand skills for a data analyst. 
- Focus on all job postings. 
- Why? Retrieves the top 5 skills with the highest demand in the job market,
    This will provide insight insight into the most valuable skills for job seekers.
*/

SELECT     
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
### 4. Top skills based on salary 
![Skills based on salary](<project_sql/assets/Top 10 Skills based on salary.png>)
``` SQL
/*
Question: What are the top skills based on salary? 
- Look at the average salary associated with each skill for Data Analyst positions
-Focuses on rooles with specified salaried, regardless of location 
-Why? To show how different skills impact salary levels for Data Analysts and the most financially rewarding skill to acquire
*/ 



SELECT     
    skills,
    ROUND (AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

-- Retrieve job titles associated with the top-paying skills
SELECT 
    jp.job_title_short, 
    s.skills, 
    ROUND (AVG(jp.salary_year_avg),0) AS avg_salary
FROM job_postings_fact jp
INNER JOIN skills_job_dim sjd ON jp.job_id = sjd.job_id
INNER JOIN skills_dim s ON sjd.skill_id = s.skill_id
WHERE s.skills IN ('pyspark', 'bitbucket', 'couchbase', 'watson', 'datarobot', 
                   'gitlab', 'swift', 'jupyter', 'pandas', 'elasticsearch', 
                   'golang', 'numpy', 'databricks', 'linux', 'kubernetes', 
              'atlassian', 'twilio', 'airflow', 'scikit-learn', 'jenkins', 
                 'notion', 'scala', 'postgresql', 'gcp', 'microstrategy')
                    AND salary_year_avg IS NOT NULL
                     AND job_work_from_home = True
GROUP BY jp.job_title_short, s.skills
ORDER BY avg_salary DESC
LIMIT 25;
```

### 5. Optimal skills
![alt text](<project_sql/assets/10 Optimal skills.png>)
``` SQL
/*
Question: What are the most optimal skils to learm (A.K.A tje skills are in high demand and a high-paying skill)? 
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
-Why? Targeting skills that offer job security (high demand) and financial benefits (high salaries)
*/
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND (AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25; 
```
# What I learned

### Breakdown of what was learned: 
1. **Salary Range:** Top 10 Data Analyst roles span for $184K to 650K, which indicates significant salary potential. 
2. **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries. 
3. **Job titles variety** There is a high diversity in job titels, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within Data Analytics. 
4. **Top paying skills** 
- SQL is leading with a bold count of 8
- Python follows closely with a bold count of 7.
- Tableau is also highly sough after, with a bold count of 6.
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

# Lessons learned as a person who just started out with SQL: 

Throughout this process, I have gain a great amount of value in solidifying my foundation with SQL. 

**Basic SQL**
Over the past three weeks, I completed Luke Barousse’s SQL course, which provided a strong foundation in SQL for data analytics. The course covered:

1. Basic SQL – Writing queries using SELECT, FROM, WHERE, ORDER BY, and filtering data.

2. Advanced SQL – More complex operations like GROUP BY, HAVING, and CTEs.

3. Handling Dates – Working with date and time functions to manipulate temporal data.

4. CASE Expressions – Using conditional statements for data transformations.

5. Subqueries & CTEs – Breaking down complex queries using subqueries and Common Table Expressions (CTEs).

6. UNION & Joins – Combining multiple datasets efficiently.

7. Capstone Project – Applied all the concepts learned in a hands-on project.



Big thanks to Luke Barousse for the structured and practical approach! His teaching made learning SQL much easier and fun.


