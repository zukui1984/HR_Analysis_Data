# HR Analysis Report - MySQL & Power BI

## Data points
Based on HR data consisting of over 22,000 rows from the year 2000 to 2020. 
The dataset includes information such as employee IDs, gender, race/ethnicity, age, location, hire, termination dates, departments, job titles

![Before](https://github.com/zukui1984/hr_analysis_data/blob/master/images/before_cleaning.png) Before cleaning
![After](https://github.com/zukui1984/hr_analysis_data/blob/master/images/after_cleaning.png) After cleaning

## [SQL Code](https://github.com/zukui1984/hr_analysis_data/blob/master/hr_data.sql) - All queries



## Questions
1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

## Key Findings:
- Gender Distribution: 51% male, 46% female, 3% non-binary.
- Departmental Gender Balance: Balanced across departments, but more male employees overall.
- Ethnicity Breakdown: 29% White, 6% Native Hawaiian/American Indian.
- Age Diversity: Spanning from 20 to 57, with 25-34 group largest.
- Work Location: 75% headquarters, rest remote.
- Average Tenure: Around 8 years, slightly longer for males.
- Turnover Rate: Marketing highest, Research Development lowest.
- Geographic Distribution: 81% from Ohio.
- Employee Growth: Net increase over years.
- Tenure by Department: Legal/Auditing highest, Services/Sales/Marketing lowest.

## Limitations:
- Excluded records with negative ages (4%).
- Excluded records with future term dates (1599 records).
