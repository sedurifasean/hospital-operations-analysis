# Exploratory Data Analysis

The exploratory data analysis was conducted to understand the structure, completeness, and overall distribution of the hospital patient flow dataset before answering the main business questions.

## Dataset Overview

The cleaned dataset contains patient-level hospital operations data, including:

- Admission date and time
- Patient age
- Gender
- Race
- Department referral
- Admission status
- Wait time
- Patient satisfaction score

## Exploratory Analysis Performed

The initial analysis included:

- Reviewing the total number of patient records
- Checking for duplicate patient identifiers
- Identifying missing values
- Reviewing the date range of the dataset
- Calculating summary statistics for age, wait time, and satisfaction
- Examining patient distributions by gender, race, and age group
- Analyzing admission volume by department
- Reviewing admission status distributions
- Identifying admission patterns by day and hour
- Grouping patients into wait-time categories
- Measuring survey completion rates

## Data Quality Observations

- No duplicate patient identifiers were found.
- Missing satisfaction scores were preserved as `NULL`.
- Patient identifiers were anonymized before publication.
- Admission dates and times were standardized.
- Categorical fields were standardized for consistent analysis.
- Numeric columns were validated before calculations were performed.

## Purpose of the EDA

The exploratory analysis helped establish a reliable foundation for the project by identifying important patterns, confirming data quality, and determining which variables were most useful for the business analysis.
