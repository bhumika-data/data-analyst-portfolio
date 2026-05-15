# =========================================================
# HR ATTRITION ANALYTICS PROJECT 
#
# Objective:
# Identify key drivers of employee attrition using data analysis
# =========================================================


# =========================================================
# PART 1: SETUP & DATA LOADING
# =========================================================

import pandas as pd
import numpy as np

df = pd.read_csv("data/HR_Attrition_Data.csv", encoding="latin1")

df.columns = df.columns.str.strip()

print("\n--- DATA LOADED SUCCESSFULLY ---")
print(df.head())


# =========================================================
# PART 2: DATA QUALITY CHECK
# =========================================================

print("\n--- DATA SHAPE ---")
print(df.shape)

print("\n--- MISSING VALUES ---")
print(df.isnull().sum())

print("\n--- DUPLICATES ---")
print(df.duplicated().sum())

df = df.drop_duplicates()

df = df[df["monthly_income"] > 0]

df["attrition_flag"] = df["attrition_flag"].astype(int)

print("\n--- CLEAN DATA READY ---")
print(df.shape)


# =========================================================
# PART 3: CORE BUSINESS KPIs
# =========================================================

total_employees = len(df)
attrition_rate = df["attrition_flag"].mean()
avg_income = df["monthly_income"].mean()

print("\n================ CORE KPIs ================")
print("Total Employees:", total_employees)
print("Attrition Rate:", round(attrition_rate, 4))
print("Average Monthly Income:", round(avg_income, 2))


# =========================================================
# PART 4: ATTRITION DRIVERS (KEY BUSINESS AREAS)
# =========================================================

dept_attrition = df.groupby("department")["attrition_flag"].mean()
role_attrition = df.groupby("job_role")["attrition_flag"].mean()
level_attrition = df.groupby("job_level")["attrition_flag"].mean()

print("\n================ DEPARTMENT ATTRITION ================")
print(dept_attrition)

print("\n================ JOB ROLE ATTRITION ================")
print(role_attrition)

print("\n================ JOB LEVEL ATTRITION ================")
print(level_attrition)


# =========================================================
# PART 5: DEMOGRAPHIC ANALYSIS
# =========================================================

age_attrition = df.groupby("age_group")["attrition_flag"].mean()
tenure_attrition = df.groupby("years_at_company")["attrition_flag"].mean()

print("\n================ AGE GROUP ATTRITION ================")
print(age_attrition)

print("\n================ TENURE ATTRITION ================")
print(tenure_attrition)


# =========================================================
# PART 6: SALARY & SATISFACTION DRIVERS
# =========================================================

salary_attrition = df.groupby("salary_band")["attrition_flag"].mean()
job_sat_attrition = df.groupby("job_satisfaction")["attrition_flag"].mean()
env_sat_attrition = df.groupby("environment_satisfaction")["attrition_flag"].mean()

print("\n================ SALARY ATTRITION ================")
print(salary_attrition)

print("\n================ JOB SATISFACTION ================")
print(job_sat_attrition)

print("\n================ ENVIRONMENT SATISFACTION ================")
print(env_sat_attrition)


# =========================================================
# PART 7: KEY INSIGHTS (BUSINESS LOGIC LAYER)
# =========================================================

print("\n================ KEY INSIGHTS ================")

highest_dept = dept_attrition.idxmax()
highest_role = role_attrition.idxmax()
highest_level = level_attrition.idxmax()
highest_age = age_attrition.idxmax()
highest_salary_band = salary_attrition.idxmax()

print("Highest Attrition Department:", highest_dept)
print("Highest Risk Job Role:", highest_role)
print("Highest Risk Job Level:", highest_level)
print("Most Affected Age Group:", highest_age)
print("Highest Risk Salary Band:", highest_salary_band)


# =========================================================
# PART 8: BUSINESS DECISION LOGIC
# =========================================================

print("\n================ BUSINESS RECOMMENDATION ================")

if attrition_rate > 0.15:
    print("ALERT: High attrition detected. Immediate retention strategy required.")
else:
    print("Attrition is under control but should be monitored.")


# =========================================================
# PART 9: EXPORT CLEAN DATA
# =========================================================

df.to_csv("output/hr_attrition_cleaned.csv", index=False)

print("\n--- FILE EXPORTED SUCCESSFULLY ---")
print("Project Completed Successfully")