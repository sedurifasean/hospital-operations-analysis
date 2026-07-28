## Data Cleaning

Before conducting the analysis, the dataset was cleaned and standardized to improve data quality, ensure consistency, and prepare the data for SQL analysis.

### Cleaning Steps

- Reviewed the dataset for missing values, duplicate records, and inconsistent formatting.
- Removed personally identifiable information (PII) by anonymizing patient identifiers and excluding patient names.
- Corrected inconsistent gender values (e.g., `Femaleemale` → `Female`).
- Standardized admission date and time formats.
- Converted numeric fields (`Age`, `Wait Time`, and `Patient Satisfaction Score`) to the appropriate data types.
- Standardized categorical values across the following fields:
  - Department Referral
  - Gender
  - Race
  - Admission Status
- Removed extra spaces and corrected inconsistent text formatting.
- Preserved missing `Patient Satisfaction Score` values as `NULL`, as they represent unanswered surveys rather than data entry errors.
- Created additional date and time fields to support trend analysis:
  - `Admission DateTime`
  - `Admission Day of Week`
  - `Admission Hour`
- Validated the cleaned dataset to ensure consistency and confirmed there were no duplicate records.

## Data Quality Summary

| Check | Result |
| :----- | :----- |
| Duplicate Records | None Found |
| Missing Values | Preserved where appropriate (`NULL`) |
| Invalid Gender Values | Corrected |
| Date & Time Formats | Standardized |
| Numeric Data Types | Validated |
| Categorical Values | Standardized |
| Personally Identifiable Information (PII) | Removed/Anonymized |
| Dataset Status | Ready for SQL Analysis |
