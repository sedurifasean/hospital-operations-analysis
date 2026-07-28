## Data Cleaning

Before beginning the analysis, the dataset was cleaned and standardized to improve data quality, ensure consistency, and prepare the data for SQL analysis.

### Cleaning Process

- Reviewed the dataset for missing values, duplicates, and inconsistent formatting.
- Removed personally identifiable information (PII) by excluding patient names and replacing patient IDs with anonymous identifiers.
- Corrected inconsistent gender values (e.g., `Femaleemale` → `Female`).
- Standardized admission date and time formats.
- Converted numeric fields to the appropriate data types:
  - Age
  - Wait Time
  - Patient Satisfaction Score
- Standardized categorical values across:
  - Department Referral
  - Gender
  - Race
  - Admission Status
- Trimmed extra spaces and corrected inconsistent text formatting.
- Preserved missing Patient Satisfaction Score values as `NULL` since they represent unanswered surveys rather than data entry errors.
- Created additional fields for time-based analysis:
  - Admission DateTime
  - Admission Day of Week
  - Admission Hour
- Validated the cleaned dataset to ensure consistency and confirmed there were no duplicate records.

---

## Data Quality Checks

| Check | Status |
|--------|--------|
| Duplicate Records | ✅ None Found |
| Invalid Gender Values | ✅ Corrected |
| Date & Time Formats | ✅ Standardized |
| Numeric Data Types | ✅ Validated |
| Categorical Values | ✅ Standardized |
| Missing Satisfaction Scores | ✅ Preserved as NULL |
| Personally Identifiable Information | ✅ Removed/Anonymized |

---

**Result:** The dataset was successfully cleaned, validated, and prepared for SQL analysis.
