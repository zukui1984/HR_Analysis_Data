## DATA CLEANING ## 
  
-- Correct ID
ALTER TABLE hr
CHANGE COLUMN ï»¿id id VARCHAR(30) NULL;

-- Change birthdate structure
SET sql_safe_updates = 0;
UPDATE hr
SET birthdate = 
CASE 
    WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%d-%m')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%d-%m')
    ELSE NULL
END;

-- Check data types
DESCRIBE hr;

-- Change termdate structure
SET sql_mode = 'ALLOW_INVALID_DATES';
UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;
ALTER TABLE hr 
MODIFY COLUMN termdate DATE;

-- Adding age column
ALTER TABLE hr ADD COLUMN age INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

#################################################################################################

## ANALYSIS PROCESS ##

-- Active this to proceed the analysis. Due termdate issue  
SET sql_mode = 'ALLOW_INVALID_DATES';

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count 
FROM hr 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender
ORDER BY COUNT(*) DESC;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count 
FROM hr 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY COUNT(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
  CASE
    WHEN age >=18 AND age <=24 THEN '18-24'
    WHEN age >=25 AND age <=34 THEN '25-34'   
    WHEN age >=35 AND age <=44 THEN '35-44' 
    WHEN age >=45 AND age <=54 THEN '45-54'
    WHEN age >=55 AND age <=64 THEN '55-64'
    ELSE '+65'
  END AS age_group, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT AVG(datediff(termdate, hire_date))/365 AS avg_length_dept
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department, 
       total_count, 
       terminated_count, 
       terminated_count / total_count AS terminated_rate
FROM (
    SELECT department, 
           COUNT(*) AS total_count, 
           SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY terminated_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT year, hires, terminations, 
	hires-terminations AS net_change,
    ROUND((hires-terminations)/hires * 100,2) AS net_change_percent
FROM (
	SELECT YEAR(hire_date) AS year,
    COUNT(*) AS hires,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age >= 18 
    GROUP BY YEAR(hire_date)
	) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, 
       ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;
