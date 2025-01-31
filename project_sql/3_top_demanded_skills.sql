/*
Question: What are the most in-demand skills for data analysts? 
- Join job postings to inner join table similar to query 2 
- Identify the top 5 in-demand skills for a data analyst. 
- Focus on all job postings. 
- Why? Retrieves the top 5 skills with the highest demand in the job market,
    This will provide insight insight into the most valuable skills for job seekers.
*/

SELECT * 
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim AS skills ON job_postings_fact.job_id = skills.job_id
    INNER JOIN skills_dim ON skills.skill_id = skills_dim.skill_id
LIMIT 5;