-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_operations;

USE hospital_operations;


-- ============================================================
-- 2. REVIEW RAW DATA
-- ============================================================

-- Import the original CSV into a table named:
-- hospital_patient_flow_raw

SELECT *
FROM hospital_patient_flow_raw
LIMIT 10;


-- Count total records
SELECT
    COUNT(*) AS total_records
FROM hospital_patient_flow_raw;


-- Review the table structure
DESCRIBE hospital_patient_flow_raw;


-- ============================================================
-- 3. CHECK FOR DUPLICATES
-- ============================================================

-- Check for completely duplicated records
SELECT
    `Patient Id`,
    `Patient Admission Date`,
    `Patient Admission Time`,
    COUNT(*) AS duplicate_count
FROM hospital_patient_flow_raw
GROUP BY
    `Patient Id`,
    `Patient Admission Date`,
    `Patient Admission Time`
HAVING COUNT(*) > 1;


-- Check for duplicate patient IDs
SELECT
    `Patient Id`,
    COUNT(*) AS patient_id_count
FROM hospital_patient_flow_raw
GROUP BY `Patient Id`
HAVING COUNT(*) > 1;


-- ============================================================
-- 4. REVIEW MISSING VALUES
-- ============================================================

SELECT
    SUM(
        CASE
            WHEN `Patient Id` IS NULL
                OR TRIM(`Patient Id`) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_patient_ids,

    SUM(
        CASE
            WHEN `Patient Admission Date` IS NULL
                OR TRIM(`Patient Admission Date`) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_admission_dates,

    SUM(
        CASE
            WHEN `Patient Admission Time` IS NULL
                OR TRIM(`Patient Admission Time`) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_admission_times,

    SUM(
        CASE
            WHEN `Patient Gender` IS NULL
                OR TRIM(`Patient Gender`) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_gender_values,

    SUM(
        CASE
            WHEN `Patient Age` IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_age_values,

    SUM(
        CASE
            WHEN `Patient Race` IS NULL
                OR TRIM(`Patient Race`) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_race_values,

    SUM(
        CASE
            WHEN `Department Referral` IS NULL
                OR TRIM(`Department Referral`) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_department_referrals,

    SUM(
        CASE
            WHEN `Patient Admission Flag` IS NULL
                OR TRIM(`Patient Admission Flag`) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_admission_flags,

    SUM(
        CASE
            WHEN `Patient Satisfaction Score` IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_satisfaction_scores,

    SUM(
        CASE
            WHEN `Patient Waittime` IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_wait_times
FROM hospital_patient_flow_raw;


-- ============================================================
-- 5. REVIEW CATEGORICAL VALUES
-- ============================================================

-- Review gender values
SELECT
    `Patient Gender`,
    COUNT(*) AS total_records
FROM hospital_patient_flow_raw
GROUP BY `Patient Gender`
ORDER BY total_records DESC;


-- Review department values
SELECT
    `Department Referral`,
    COUNT(*) AS total_records
FROM hospital_patient_flow_raw
GROUP BY `Department Referral`
ORDER BY total_records DESC;


-- Review admission-status values
SELECT
    `Patient Admission Flag`,
    COUNT(*) AS total_records
FROM hospital_patient_flow_raw
GROUP BY `Patient Admission Flag`
ORDER BY total_records DESC;


-- Review race values
SELECT
    `Patient Race`,
    COUNT(*) AS total_records
FROM hospital_patient_flow_raw
GROUP BY `Patient Race`
ORDER BY total_records DESC;


-- ============================================================
-- 6. CREATE CLEANED TABLE
-- ============================================================

DROP TABLE IF EXISTS hospital_patient_flow;

CREATE TABLE hospital_patient_flow AS

SELECT
    -- Replace sensitive patient IDs with anonymous sequential IDs
    CONCAT(
        'PAT-',
        LPAD(
            ROW_NUMBER() OVER (
                ORDER BY
                    STR_TO_DATE(
                        TRIM(`Patient Admission Date`),
                        '%m/%d/%Y'
                    ),
                    STR_TO_DATE(
                        TRIM(`Patient Admission Time`),
                        '%h:%i:%s %p'
                    ),
                    `Patient Id`
            ),
            5,
            '0'
        )
    ) AS patient_id,

    -- Convert the admission date from text to DATE
    STR_TO_DATE(
        TRIM(`Patient Admission Date`),
        '%m/%d/%Y'
    ) AS admission_date,

    -- Convert the admission time from text to TIME
    STR_TO_DATE(
        TRIM(`Patient Admission Time`),
        '%h:%i:%s %p'
    ) AS admission_time,

    -- Combine the standardized date and time
    STR_TO_DATE(
        CONCAT(
            TRIM(`Patient Admission Date`),
            ' ',
            TRIM(`Patient Admission Time`)
        ),
        '%m/%d/%Y %h:%i:%s %p'
    ) AS admission_datetime,

    -- Correct the misspelled gender value
    CASE
        WHEN TRIM(`Patient Gender`) = 'Femaleemale'
            THEN 'Female'
        WHEN TRIM(`Patient Gender`) = 'Female'
            THEN 'Female'
        WHEN TRIM(`Patient Gender`) = 'Male'
            THEN 'Male'
        ELSE 'Unknown'
    END AS gender,

    -- Preserve valid age values
    CAST(`Patient Age` AS UNSIGNED) AS age,

    -- Standardize race values
    TRIM(`Patient Race`) AS race,

    -- Replace missing department referrals with a clear category
    CASE
        WHEN `Department Referral` IS NULL
            OR TRIM(`Department Referral`) = ''
            THEN 'No Referral'
        ELSE TRIM(`Department Referral`)
    END AS department_referral,

    -- Standardize admission-status terminology
    CASE
        WHEN TRIM(`Patient Admission Flag`) = 'Admission'
            THEN 'Admitted'
        WHEN TRIM(`Patient Admission Flag`) = 'Not Admission'
            THEN 'Not Admitted'
        ELSE 'Unknown'
    END AS admission_status,

    -- Preserve missing satisfaction scores as NULL
    CASE
        WHEN `Patient Satisfaction Score` IS NULL
            THEN NULL
        ELSE CAST(`Patient Satisfaction Score` AS DECIMAL(4,2))
    END AS satisfaction_score,

    -- Standardize wait-time naming and type
    CAST(`Patient Waittime` AS UNSIGNED) AS wait_time_minutes,

    -- Create fields for time-based analysis
    DAYNAME(
        STR_TO_DATE(
            TRIM(`Patient Admission Date`),
            '%m/%d/%Y'
        )
    ) AS admission_day,

    DAYOFWEEK(
        STR_TO_DATE(
            TRIM(`Patient Admission Date`),
            '%m/%d/%Y'
        )
    ) AS admission_day_number,

    HOUR(
        STR_TO_DATE(
            TRIM(`Patient Admission Time`),
            '%h:%i:%s %p'
        )
    ) AS admission_hour,

    MONTH(
        STR_TO_DATE(
            TRIM(`Patient Admission Date`),
            '%m/%d/%Y'
        )
    ) AS admission_month,

    MONTHNAME(
        STR_TO_DATE(
            TRIM(`Patient Admission Date`),
            '%m/%d/%Y'
        )
    ) AS admission_month_name,

    YEAR(
        STR_TO_DATE(
            TRIM(`Patient Admission Date`),
            '%m/%d/%Y'
        )
    ) AS admission_year

FROM hospital_patient_flow_raw;


-- ============================================================
-- 7. MODIFY CLEANED TABLE DATA TYPES
-- ============================================================

ALTER TABLE hospital_patient_flow
    MODIFY patient_id VARCHAR(20) NOT NULL,
    MODIFY admission_date DATE NOT NULL,
    MODIFY admission_time TIME NOT NULL,
    MODIFY admission_datetime DATETIME NOT NULL,
    MODIFY gender VARCHAR(20) NOT NULL,
    MODIFY age INT NOT NULL,
    MODIFY race VARCHAR(100) NOT NULL,
    MODIFY department_referral VARCHAR(100) NOT NULL,
    MODIFY admission_status VARCHAR(30) NOT NULL,
    MODIFY satisfaction_score DECIMAL(4,2) NULL,
    MODIFY wait_time_minutes INT NOT NULL,
    MODIFY admission_day VARCHAR(20) NOT NULL,
    MODIFY admission_day_number INT NOT NULL,
    MODIFY admission_hour INT NOT NULL,
    MODIFY admission_month INT NOT NULL,
    MODIFY admission_month_name VARCHAR(20) NOT NULL,
    MODIFY admission_year INT NOT NULL;


-- Add a primary key
ALTER TABLE hospital_patient_flow
ADD PRIMARY KEY (patient_id);


-- ============================================================
-- 8. VALIDATE CLEANED DATA
-- ============================================================

-- Confirm record count
SELECT
    COUNT(*) AS cleaned_record_count
FROM hospital_patient_flow;


-- Preview cleaned records
SELECT *
FROM hospital_patient_flow
LIMIT 10;


-- Confirm patient IDs are unique
SELECT
    patient_id,
    COUNT(*) AS duplicate_count
FROM hospital_patient_flow
GROUP BY patient_id
HAVING COUNT(*) > 1;


-- Confirm standardized gender values
SELECT
    gender,
    COUNT(*) AS patient_count
FROM hospital_patient_flow
GROUP BY gender
ORDER BY patient_count DESC;


-- Confirm standardized department values
SELECT
    department_referral,
    COUNT(*) AS patient_count
FROM hospital_patient_flow
GROUP BY department_referral
ORDER BY patient_count DESC;


-- Confirm standardized admission-status values
SELECT
    admission_status,
    COUNT(*) AS patient_count
FROM hospital_patient_flow
GROUP BY admission_status
ORDER BY patient_count DESC;


-- Check for invalid ages
SELECT *
FROM hospital_patient_flow
WHERE age < 0
   OR age > 120;


-- Check for invalid wait times
SELECT *
FROM hospital_patient_flow
WHERE wait_time_minutes < 0;


-- Check for invalid satisfaction scores
SELECT *
FROM hospital_patient_flow
WHERE satisfaction_score IS NOT NULL
  AND (
      satisfaction_score < 0
      OR satisfaction_score > 10
  );


-- Check required fields for missing values
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


-- ============================================================
-- 9. FINAL DATA QUALITY SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT patient_id) AS unique_patient_ids,
    COUNT(satisfaction_score) AS completed_satisfaction_surveys,
    SUM(
        CASE
            WHEN satisfaction_score IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_satisfaction_scores,
    ROUND(AVG(age), 2) AS average_patient_age,
    ROUND(AVG(wait_time_minutes), 2)
        AS average_wait_time_minutes,
    ROUND(AVG(satisfaction_score), 2)
        AS average_satisfaction_score
FROM hospital_patient_flow;


/*
Cleaning Results:

- All 9,216 patient records were retained.
- Sensitive SSN-formatted patient IDs were replaced with anonymous IDs.
- The redundant Merged column was excluded.
- The Femaleemale gender typo was corrected to Female.
- Missing department referrals were categorized as No Referral.
- Admission status values were standardized.
- Dates and times were converted to valid SQL data types.
- Missing satisfaction scores were preserved as NULL.
- Additional date and time fields were created for analysis.
- The cleaned table was validated for duplicates, missing required
  fields, and invalid numeric values.
*/
