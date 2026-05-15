
-- =========================================================
-- HR ATTRITION ANALYTICS PROJECT
-- Objective:
-- Analyze employee attrition patterns to identify
-- workforce trends, employee risk factors,
-- and key business insights.
-- =========================================================



-- =========================================================
-- PART 1: DATA IMPORT & INITIAL DATA VALIDATION
-- Objective:
-- Validate dataset structure, check data quality,
-- and understand employee information before
-- performing business analysis.
-- =========================================================


USE hr_attrition_analysis;

-- View complete dataset
SELECT 
    *
FROM
    HR_Attrition_Data;


-- Check total employee records
SELECT 
    COUNT(*) AS total_employees
FROM
    HR_Attrition_Data;


-- Display unique departments
SELECT DISTINCT
    department
FROM
    HR_Attrition_Data;


-- Display unique job roles
SELECT DISTINCT
    job_role
FROM
    HR_Attrition_Data;


-- Check missing values in important columns
SELECT 
    SUM(CASE
        WHEN attrition IS NULL THEN 1
        ELSE 0
    END) AS missing_attrition,
    SUM(CASE
        WHEN monthly_income IS NULL THEN 1
        ELSE 0
    END) AS missing_income,
    SUM(CASE
        WHEN department IS NULL THEN 1
        ELSE 0
    END) AS missing_department
FROM
    HR_Attrition_Data;


-- Check duplicate employee records
SELECT 
    employee_number, COUNT(*) AS duplicate_count
FROM
    HR_Attrition_Data
GROUP BY employee_number
HAVING COUNT(*) > 1;


-- Compare total rows vs unique employees
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT employee_number) AS unique_employees
FROM
    HR_Attrition_Data;


-- Preview important employee columns
SELECT 
    employee_number,
    department,
    job_role,
    monthly_income,
    attrition
FROM
    HR_Attrition_Data
LIMIT 10;



-- =========================================================
-- PART 2: CORE KPI & ATTRITION ANALYSIS
-- Objective:
-- Measure overall attrition performance and analyze
-- employee turnover patterns across the organization.
-- =========================================================

SELECT 
    attrition, COUNT(*) AS employee_count
FROM
    HR_Attrition_Data
GROUP BY attrition;


-- Calculate overall attrition rate
SELECT 
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data;


-- Calculate average monthly income
SELECT 
    ROUND(AVG(monthly_income), 2) AS average_monthly_income
FROM
    HR_Attrition_Data;


-- Compare average income by attrition status
SELECT 
    attrition,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM
    HR_Attrition_Data
GROUP BY attrition;


-- Analyze attrition by gender
SELECT 
    gender,
    COUNT(*) AS total_employees,
    SUM(CASE
        WHEN attrition = 'Yes' THEN 1
        ELSE 0
    END) AS attrition_count,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY gender;


-- Analyze attrition by marital status
SELECT 
    marital_status,
    COUNT(*) AS total_employees,
    SUM(CASE
        WHEN attrition = 'Yes' THEN 1
        ELSE 0
    END) AS attrition_count,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY marital_status
ORDER BY attrition_rate DESC;



-- =========================================================
-- PART 3: DEPARTMENT & JOB ROLE ANALYSIS
-- Objective:
-- Identify departments and job roles with
-- higher employee attrition risk and analyze
-- workforce distribution across business areas.
-- =========================================================

SELECT 
    department,
    COUNT(*) AS total_employees,
    SUM(CASE
        WHEN attrition = 'Yes' THEN 1
        ELSE 0
    END) AS attrition_count,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY department
ORDER BY attrition_rate DESC;


-- Analyze job role-wise attrition
SELECT 
    job_role,
    COUNT(*) AS total_employees,
    SUM(CASE
        WHEN attrition = 'Yes' THEN 1
        ELSE 0
    END) AS attrition_count,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY job_role
ORDER BY attrition_rate DESC;


-- Analyze employee distribution by department
SELECT 
    department, COUNT(*) AS employee_count
FROM
    HR_Attrition_Data
GROUP BY department
ORDER BY employee_count DESC;


-- Compare average salary across departments
SELECT 
    department, ROUND(AVG(monthly_income), 2) AS avg_salary
FROM
    HR_Attrition_Data
GROUP BY department
ORDER BY avg_salary DESC;


-- Compare average salary across job roles
SELECT 
    job_role, ROUND(AVG(monthly_income), 2) AS avg_salary
FROM
    HR_Attrition_Data
GROUP BY job_role
ORDER BY avg_salary DESC;


-- Analyze attrition by job level
SELECT 
    job_level,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY job_level
ORDER BY attrition_rate DESC;



-- =========================================================
-- PART 4: AGE, EXPERIENCE & CAREER ANALYSIS
-- Objective:
-- Analyze employee attrition patterns across
-- age groups, work experience, and career stage
-- to identify workforce stability trends.
-- =========================================================

SELECT 
    age_group,
    COUNT(*) AS total_employees,
    SUM(CASE
        WHEN attrition = 'Yes' THEN 1
        ELSE 0
    END) AS attrition_count,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY age_group
ORDER BY attrition_rate DESC;


-- Analyze attrition by tenure group
SELECT 
    tenure_group,
    COUNT(*) AS total_employees,
    SUM(CASE
        WHEN attrition = 'Yes' THEN 1
        ELSE 0
    END) AS attrition_count,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY tenure_group
ORDER BY attrition_rate DESC;


-- Analyze average working years by attrition
SELECT 
    attrition,
    ROUND(AVG(total_working_years), 2) AS avg_working_years
FROM
    HR_Attrition_Data
GROUP BY attrition;


-- Compare years at company by attrition status
SELECT 
    attrition,
    ROUND(AVG(years_at_company), 2) AS avg_years_at_company
FROM
    HR_Attrition_Data
GROUP BY attrition;


-- Analyze years since last promotion
SELECT 
    attrition,
    ROUND(AVG(years_since_last_promotion), 2) AS avg_years_since_promotion
FROM
    HR_Attrition_Data
GROUP BY attrition;


-- Analyze current role experience
SELECT 
    attrition,
    ROUND(AVG(years_current_role), 2) AS avg_years_current_role
FROM
    HR_Attrition_Data
GROUP BY attrition;



-- =========================================================
-- PART 5: SALARY & EMPLOYEE SATISFACTION ANALYSIS
-- Objective:
-- Analyze the impact of salary structure,
-- job satisfaction, and workplace environment
-- on employee attrition behavior.
-- =========================================================

SELECT 
    salary_band,
    COUNT(*) AS total_employees,
    SUM(CASE
        WHEN attrition = 'Yes' THEN 1
        ELSE 0
    END) AS attrition_count,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY salary_band
ORDER BY attrition_rate DESC;


-- Analyze average salary by attrition status
SELECT 
    attrition,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM
    HR_Attrition_Data
GROUP BY attrition;


-- Analyze job satisfaction impact on attrition
SELECT 
    job_satisfaction,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY job_satisfaction
ORDER BY attrition_rate DESC;


-- Analyze environment satisfaction impact
SELECT 
    environment_satisfaction,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY environment_satisfaction
ORDER BY attrition_rate DESC;


-- Analyze relationship satisfaction impact
SELECT 
    relationship_satisfaction,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY relationship_satisfaction
ORDER BY attrition_rate DESC;


-- Analyze performance rating by attrition
SELECT 
    performance_rating,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY performance_rating
ORDER BY attrition_rate DESC;



-- =========================================================
-- PART 6: FINAL BUSINESS INSIGHTS & SUMMARY
-- Objective:
-- Generate final business summaries and identify
-- high-risk workforce segments requiring
-- retention-focused decision making.
-- =========================================================

SELECT 
    department,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY department
ORDER BY attrition_rate DESC
LIMIT 1;


-- Identify highest risk job role
SELECT 
    job_role,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY job_role
ORDER BY attrition_rate DESC
LIMIT 1;


-- Identify highest attrition salary band
SELECT 
    salary_band,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY salary_band
ORDER BY attrition_rate DESC
LIMIT 1;


-- Identify most affected age group
SELECT 
    age_group,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY age_group
ORDER BY attrition_rate DESC
LIMIT 1;


-- Create department-wise business summary
SELECT 
    department,
    COUNT(*) AS total_employees,
    ROUND(AVG(monthly_income), 2) AS avg_salary,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY department
ORDER BY attrition_rate DESC;


-- Create job role business summary
SELECT 
    job_role,
    COUNT(*) AS total_employees,
    ROUND(AVG(monthly_income), 2) AS avg_salary,
    ROUND(SUM(CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*),
            4) AS attrition_rate
FROM
    HR_Attrition_Data
GROUP BY job_role
ORDER BY attrition_rate DESC;