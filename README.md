# Hospital Operations & Patient Flow Analysis

## Overview

In this project, I used SQL to analyze hospital patient flow data and evaluate key operational metrics, including admissions, wait times, patient satisfaction, and department performance. The project demonstrates how SQL can be used to clean healthcare data, answer business questions, and generate insights that support operational efficiency, staffing decisions, and resource planning.

---

## Dataset

**Source:** Kaggle Healthcare Patient Flow Dataset

The dataset includes patient-level hospital operations data, including:

- Patient Admission Date
- Patient Admission Time
- Age
- Gender
- Race
- Department Referral
- Admission Status
- Wait Time
- Patient Satisfaction Score

---
## Data Cleaning

Before conducting the analysis, the dataset was cleaned and standardized to improve data quality and prepare it for SQL analysis.

### Cleaning Steps

- Reviewed the dataset for missing values, duplicate records, and inconsistent formatting.
- Removed personally identifiable information (PII) by anonymizing patient identifiers.
- Corrected inconsistent gender values.
- Standardized admission date and time formats.
- Converted numeric fields to appropriate data types.
- Standardized categorical values.
- Removed extra spaces and inconsistent text formatting.
- Preserved missing patient satisfaction scores as `NULL`.
- Validated the cleaned dataset and confirmed no duplicate records.

---

## Business Questions

Throughout this project, I explored the following questions:

- Which hospital departments have the longest average wait times?
- What are the busiest admission days and hours?
- Which departments receive the highest patient satisfaction scores?
- How does patient satisfaction change as wait times increase?
- Which demographic groups account for the highest patient volume?
- How are admissions distributed across hospital departments?

---

## SQL Analysis

Using SQL, I performed analyses including:

- Patient admissions by department
- Average wait time by department
- Peak admission days and hours
- Patient satisfaction analysis
- Demographic breakdowns
- Admission status distribution
- Department performance comparisons

---

## Key Insights

- Identified the busiest hospital departments based on patient volume.
- Analyzed admission trends to determine peak operating hours.
- Compared average wait times across departments.
- Evaluated how wait times impact patient satisfaction.
- Identified demographic trends in hospital admissions.

---

## Business Recommendations

Based on the analysis, potential recommendations include:

- Increase staffing during peak admission periods.
- Reduce wait times in high-volume departments.
- Monitor patient satisfaction alongside operational metrics.
- Use patient flow data to improve scheduling and resource allocation.
- Continue tracking operational KPIs to support data-driven decision making.

---

## Skills Demonstrated

- SQL
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Aggregate Functions
- GROUP BY
- CASE Statements
- Common Table Expressions (CTEs)
- Window Functions
- Business Analysis
- Healthcare Analytics

---

## Project Structure

```
Hospital-Operations-Patient-Flow-Analysis/
│
├── Data/
│   └── original.csv
│   └── clean.csv
│
├── Docs/
│   └── exploratory_analysis.md
│   └── business_questions.md
│
├── SQL/
│   ├── data_cleaning.sql
│   ├── exploratory_analysis.sql
│   ├── business_questions.sql
│ 
└── README.md
```
