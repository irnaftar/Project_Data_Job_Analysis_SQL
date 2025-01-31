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
