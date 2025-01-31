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
