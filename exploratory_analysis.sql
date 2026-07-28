/*
Project: Hospital Operations & Patient Flow Analysis
File: 01_exploratory_data_analysis.sql

Purpose:
Perform an initial exploratory analysis of the cleaned hospital patient
flow dataset before answering the primary business questions.
*/

-- ============================================================
-- 1. REVIEW THE DATASET
-- ============================================================

-- Preview the first records
SELECT *
FROM hospital_patient_flow
LIMIT 10;


-- Count the total number of patient records
SELECT
    COUNT(*) AS total_patient_records
FROM hospital_patient_flow;


-- Review the available columns and data types
DESCRIBE hospital_patient_flow;


-- ============================================================
-- 2. CHECK FOR DUPLICATE RECORDS
-- ============================================================

-- Identify duplicate patient IDs
SELECT
    patient_id,
    COUNT(*) AS record_count
FROM hospital_patient_flow
GROUP BY patient_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 3. CHECK FOR MISSING VALUES
-- ============================================================

SELECT
    SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END)
        AS missing_patient_ids,
    SUM(CASE WHEN admission_date IS NULL THEN 1 ELSE 0 END)
        AS missing_admission_dates,
    SUM(CASE WHEN admission_time IS NULL THEN 1 ELSE 0 END)
        AS missing_admission_times,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END)
        AS missing_gender_values,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END)
        AS missing_age_values,
    SUM(CASE WHEN race IS NULL THEN 1 ELSE 0 END)
        AS missing_race_values,
    SUM(CASE WHEN department_referral IS NULL THEN 1 ELSE 0 END)
        AS missing_department_values,
    SUM(CASE WHEN admission_status IS NULL THEN 1 ELSE 0 END)
        AS missing_admission_status_values,
    SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END)
        AS missing_satisfaction_scores,
    SUM(CASE WHEN wait_time_minutes IS NULL THEN 1 ELSE 0 END)
        AS missing_wait_times
FROM hospital_patient_flow;


-- Calculate the percentage of patients with a satisfaction score
SELECT
    COUNT(*) AS total_patients,
    COUNT(satisfaction_score) AS completed_surveys,
    ROUND(
        COUNT(satisfaction_score) * 100.0 / COUNT(*),
        2
    ) AS survey_completion_rate
FROM hospital_patient_flow;


-- ============================================================
-- 4. REVIEW NUMERIC VARIABLES
-- ============================================================

-- Summary statistics for age
SELECT
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age,
    ROUND(AVG(age), 2) AS average_age
FROM hospital_patient_flow;


-- Summary statistics for wait time
SELECT
    MIN(wait_time_minutes) AS minimum_wait_time,
    MAX(wait_time_minutes) AS maximum_wait_time,
    ROUND(AVG(wait_time_minutes), 2) AS average_wait_time
FROM hospital_patient_flow;


-- Summary statistics for patient satisfaction
SELECT
    MIN(satisfaction_score) AS minimum_satisfaction_score,
    MAX(satisfaction_score) AS maximum_satisfaction_score,
    ROUND(AVG(satisfaction_score), 2) AS average_satisfaction_score
FROM hospital_patient_flow
WHERE satisfaction_score IS NOT NULL;


-- ============================================================
-- 5. REVIEW CATEGORICAL VARIABLES
-- ============================================================

-- Patient count by gender
SELECT
    gender,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM hospital_patient_flow
GROUP BY gender
ORDER BY patient_count DESC;


-- Patient count by race
SELECT
    race,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM hospital_patient_flow
GROUP BY race
ORDER BY patient_count DESC;


-- Patient count by department
SELECT
    department_referral,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM hospital_patient_flow
GROUP BY department_referral
ORDER BY patient_count DESC;


-- Patient count by admission status
SELECT
    admission_status,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM hospital_patient_flow
GROUP BY admission_status
ORDER BY patient_count DESC;


-- ============================================================
-- 6. REVIEW ADMISSION TRENDS
-- ============================================================

-- Admission date range
SELECT
    MIN(admission_date) AS earliest_admission_date,
    MAX(admission_date) AS latest_admission_date
FROM hospital_patient_flow;


-- Admissions by day of the week
SELECT
    admission_day,
    COUNT(*) AS patient_count
FROM hospital_patient_flow
GROUP BY admission_day
ORDER BY patient_count DESC;


-- Admissions by hour
SELECT
    admission_hour,
    COUNT(*) AS patient_count
FROM hospital_patient_flow
GROUP BY admission_hour
ORDER BY patient_count DESC;


-- Admissions by month
SELECT
    YEAR(admission_date) AS admission_year,
    MONTH(admission_date) AS admission_month,
    COUNT(*) AS patient_count
FROM hospital_patient_flow
GROUP BY
    YEAR(admission_date),
    MONTH(admission_date)
ORDER BY
    admission_year,
    admission_month;


-- ============================================================
-- 7. CREATE AGE GROUPS
-- ============================================================

WITH patient_age_groups AS (
    SELECT
        patient_id,
        age,
        CASE
            WHEN age < 18 THEN 'Under 18'
            WHEN age BETWEEN 18 AND 24 THEN '18-24'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            WHEN age BETWEEN 55 AND 64 THEN '55-64'
            ELSE '65+'
        END AS age_group
    FROM hospital_patient_flow
)

SELECT
    age_group,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM patient_age_groups
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN 'Under 18' THEN 1
        WHEN '18-24' THEN 2
        WHEN '25-34' THEN 3
        WHEN '35-44' THEN 4
        WHEN '45-54' THEN 5
        WHEN '55-64' THEN 6
        WHEN '65+' THEN 7
    END;


-- ============================================================
-- 8. CREATE WAIT-TIME GROUPS
-- ============================================================

WITH wait_time_groups AS (
    SELECT
        patient_id,
        wait_time_minutes,
        CASE
            WHEN wait_time_minutes < 15 THEN 'Under 15 Minutes'
            WHEN wait_time_minutes BETWEEN 15 AND 29
                THEN '15-29 Minutes'
            WHEN wait_time_minutes BETWEEN 30 AND 44
                THEN '30-44 Minutes'
            WHEN wait_time_minutes BETWEEN 45 AND 59
                THEN '45-59 Minutes'
            ELSE '60+ Minutes'
        END AS wait_time_group
    FROM hospital_patient_flow
)

SELECT
    wait_time_group,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM wait_time_groups
GROUP BY wait_time_group
ORDER BY
    CASE wait_time_group
        WHEN 'Under 15 Minutes' THEN 1
        WHEN '15-29 Minutes' THEN 2
        WHEN '30-44 Minutes' THEN 3
        WHEN '45-59 Minutes' THEN 4
        WHEN '60+ Minutes' THEN 5
    END;
