-- ============================================================
-- BUSINESS QUESTION 1
-- Which hospital departments have the longest average wait times?
-- ============================================================

SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(wait_time_minutes), 2) AS average_wait_time_minutes,
    MIN(wait_time_minutes) AS minimum_wait_time_minutes,
    MAX(wait_time_minutes) AS maximum_wait_time_minutes
FROM hospital_patient_flow
GROUP BY department_referral
ORDER BY average_wait_time_minutes DESC;


-- Rank departments by average wait time
WITH department_wait_times AS (
    SELECT
        department_referral,
        COUNT(*) AS total_patients,
        ROUND(AVG(wait_time_minutes), 2)
            AS average_wait_time_minutes
    FROM hospital_patient_flow
    GROUP BY department_referral
)

SELECT
    department_referral,
    total_patients,
    average_wait_time_minutes,
    DENSE_RANK() OVER (
        ORDER BY average_wait_time_minutes DESC
    ) AS wait_time_rank
FROM department_wait_times
ORDER BY wait_time_rank;


-- ============================================================
-- BUSINESS QUESTION 2
-- What are the busiest admission days and hours?
-- ============================================================

-- Busiest admission days
SELECT
    admission_day,
    COUNT(*) AS total_admissions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_admissions
FROM hospital_patient_flow
GROUP BY admission_day
ORDER BY total_admissions DESC;


-- Busiest admission hours
SELECT
    admission_hour,
    COUNT(*) AS total_admissions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_admissions
FROM hospital_patient_flow
GROUP BY admission_hour
ORDER BY total_admissions DESC;


-- Busiest combinations of admission day and hour
SELECT
    admission_day,
    admission_hour,
    COUNT(*) AS total_admissions
FROM hospital_patient_flow
GROUP BY
    admission_day,
    admission_hour
ORDER BY total_admissions DESC
LIMIT 10;


-- ============================================================
-- BUSINESS QUESTION 3
-- Which departments receive the highest patient satisfaction
-- scores?
-- ============================================================

SELECT
    department_referral,
    COUNT(satisfaction_score) AS completed_surveys,
    ROUND(AVG(satisfaction_score), 2)
        AS average_satisfaction_score
FROM hospital_patient_flow
WHERE satisfaction_score IS NOT NULL
GROUP BY department_referral
ORDER BY average_satisfaction_score DESC;


-- Include survey response rate by department
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    COUNT(satisfaction_score) AS completed_surveys,
    ROUND(
        COUNT(satisfaction_score) * 100.0 / COUNT(*),
        2
    ) AS survey_response_rate,
    ROUND(AVG(satisfaction_score), 2)
        AS average_satisfaction_score
FROM hospital_patient_flow
GROUP BY department_referral
ORDER BY average_satisfaction_score DESC;


-- ============================================================
-- BUSINESS QUESTION 4
-- How does patient satisfaction change as wait times increase?
-- ============================================================

WITH wait_time_categories AS (
    SELECT
        patient_id,
        wait_time_minutes,
        satisfaction_score,
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
    WHERE satisfaction_score IS NOT NULL
)

SELECT
    wait_time_group,
    COUNT(*) AS completed_surveys,
    ROUND(AVG(wait_time_minutes), 2)
        AS average_wait_time_minutes,
    ROUND(AVG(satisfaction_score), 2)
        AS average_satisfaction_score
FROM wait_time_categories
GROUP BY wait_time_group
ORDER BY
    CASE wait_time_group
        WHEN 'Under 15 Minutes' THEN 1
        WHEN '15-29 Minutes' THEN 2
        WHEN '30-44 Minutes' THEN 3
        WHEN '45-59 Minutes' THEN 4
        WHEN '60+ Minutes' THEN 5
    END;


-- Compare satisfaction scores at each wait-time value
SELECT
    wait_time_minutes,
    COUNT(satisfaction_score) AS completed_surveys,
    ROUND(AVG(satisfaction_score), 2)
        AS average_satisfaction_score
FROM hospital_patient_flow
WHERE satisfaction_score IS NOT NULL
GROUP BY wait_time_minutes
ORDER BY wait_time_minutes;


-- ============================================================
-- BUSINESS QUESTION 5
-- Which demographic groups account for the highest patient volume?
-- ============================================================

-- Patient volume by gender
SELECT
    gender,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM hospital_patient_flow
GROUP BY gender
ORDER BY total_patients DESC;


-- Patient volume by race
SELECT
    race,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM hospital_patient_flow
GROUP BY race
ORDER BY total_patients DESC;


-- Patient volume by age group
WITH age_groups AS (
    SELECT
        patient_id,
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
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_patients
FROM age_groups
GROUP BY age_group
ORDER BY total_patients DESC;


-- Combined demographic analysis
WITH patient_demographics AS (
    SELECT
        patient_id,
        gender,
        race,
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
    gender,
    race,
    COUNT(*) AS total_patients
FROM patient_demographics
GROUP BY
    age_group,
    gender,
    race
ORDER BY total_patients DESC
LIMIT 10;


-- ============================================================
-- BUSINESS QUESTION 6
-- How are admissions distributed across hospital departments?
-- ============================================================

SELECT
    department_referral,
    COUNT(*) AS total_admissions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
        AS percentage_of_admissions
FROM hospital_patient_flow
GROUP BY department_referral
ORDER BY total_admissions DESC;


-- Admission status by department
SELECT
    department_referral,
    admission_status,
    COUNT(*) AS total_patients
FROM hospital_patient_flow
GROUP BY
    department_referral,
    admission_status
ORDER BY
    department_referral,
    total_patients DESC;


-- Admission rate by department
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    SUM(
        CASE
            WHEN admission_status = 'Admitted' THEN 1
            ELSE 0
        END
    ) AS admitted_patients,
    ROUND(
        SUM(
            CASE
                WHEN admission_status = 'Admitted' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS admission_rate
FROM hospital_patient_flow
GROUP BY department_referral
ORDER BY admission_rate DESC;


-- ============================================================
-- DEPARTMENT PERFORMANCE COMPARISON
-- ============================================================

SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(wait_time_minutes), 2)
        AS average_wait_time_minutes,
    COUNT(satisfaction_score) AS completed_surveys,
    ROUND(AVG(satisfaction_score), 2)
        AS average_satisfaction_score,
    ROUND(
        SUM(
            CASE
                WHEN admission_status = 'Admitted' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS admission_rate
FROM hospital_patient_flow
GROUP BY department_referral
ORDER BY total_patients DESC;
