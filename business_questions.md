# Business Questions and Results

The SQL analysis was designed to answer practical questions related to hospital patient flow, department performance, wait times, admissions, and patient satisfaction.

## 1. Which hospital departments have the longest average wait times?

Neurology had the longest average wait time at **36.80 minutes**, followed by Physiotherapy at **36.57 minutes** and Gastroenterology at **35.83 minutes**.

| Department | Total Patients | Average Wait Time |
|---|---:|---:|
| Neurology | 193 | 36.80 minutes |
| Physiotherapy | 276 | 36.57 minutes |
| Gastroenterology | 178 | 35.83 minutes |
| Cardiology | 248 | 35.35 minutes |
| No Referral | 5,400 | 35.29 minutes |
| Orthopedics | 995 | 34.98 minutes |
| General Practice | 1,840 | 34.91 minutes |
| Renal | 86 | 34.70 minutes |

### Finding

Average wait times were relatively similar across departments, ranging from approximately **34.70 to 36.80 minutes**. Neurology had the highest average wait time, although its patient volume was considerably lower than General Practice and No Referral.

---

## 2. What are the busiest admission days and hours?

Saturday recorded the highest patient volume with **1,368 admissions**, followed closely by Sunday with **1,361 admissions**.

| Admission Day | Total Admissions |
|---|---:|
| Saturday | 1,368 |
| Sunday | 1,361 |
| Wednesday | 1,330 |
| Tuesday | 1,322 |
| Monday | 1,296 |
| Friday | 1,270 |
| Thursday | 1,269 |

The busiest admission hour was **11:00 PM**, with **436 admissions**.

| Admission Hour | Total Admissions |
|---|---:|
| 11:00 PM | 436 |
| 7:00 AM | 415 |
| 1:00 PM | 410 |
| 12:00 AM | 406 |
| 11:00 AM | 403 |

### Finding

Weekend admissions were slightly higher than weekday admissions. Patient arrivals were distributed throughout the day, but the highest volume occurred at **11:00 PM**.

---

## 3. Which departments receive the highest patient satisfaction scores?

Gastroenterology received the highest average satisfaction score at **5.80**, followed by Neurology at **5.28** and Cardiology at **5.14**.

| Department | Completed Surveys | Average Satisfaction Score |
|---|---:|---:|
| Gastroenterology | 54 | 5.80 |
| Neurology | 53 | 5.28 |
| Cardiology | 71 | 5.14 |
| General Practice | 503 | 5.06 |
| Physiotherapy | 83 | 4.99 |
| No Referral | 1,440 | 4.95 |
| Orthopedics | 290 | 4.86 |
| Renal | 23 | 4.57 |

### Finding

Gastroenterology had the highest average satisfaction score. However, the department had only **54 completed surveys**, so results should be interpreted alongside survey volume.

---

## 4. How does patient satisfaction change as wait times increase?

Patients waiting fewer than 15 minutes reported the highest average satisfaction score of **5.38**. Patients waiting 60 minutes reported the lowest average score of **4.55**.

| Wait-Time Group | Patients | Completed Surveys | Average Satisfaction |
|---|---:|---:|---:|
| Under 15 Minutes | 887 | 258 | 5.38 |
| 15–29 Minutes | 2,645 | 693 | 4.99 |
| 30–44 Minutes | 2,737 | 761 | 4.83 |
| 45–59 Minutes | 2,764 | 750 | 5.05 |
| 60+ Minutes | 183 | 55 | 4.55 |

### Finding

Overall, shorter wait times were associated with higher patient satisfaction. Satisfaction did not decline consistently across every wait-time category, but patients waiting 60 minutes had the lowest average rating.

---

## 5. Which demographic groups account for the highest patient volume?

### Gender

Male patients represented **51.31%** of the dataset, while female patients represented **48.69%**.

| Gender | Patient Count | Percentage |
|---|---:|---:|
| Male | 4,729 | 51.31% |
| Female | 4,487 | 48.69% |

### Race

White patients represented the largest racial group with **2,571 patients**, accounting for **27.90%** of total patient volume.

| Race | Patient Count | Percentage |
|---|---:|---:|
| White | 2,571 | 27.90% |
| African American | 1,951 | 21.17% |
| Two or More Races | 1,557 | 16.89% |
| Asian | 1,060 | 11.50% |
| Declined to Identify | 1,030 | 11.18% |
| Pacific Islander | 549 | 5.96% |
| Native American/Alaska Native | 498 | 5.40% |

### Age Group

Patients under age 18 accounted for the largest age group with **1,971 patients**, followed by patients age 65 and older with **1,736 patients**.

| Age Group | Patient Count | Percentage |
|---|---:|---:|
| Under 18 | 1,971 | 21.39% |
| 65+ | 1,736 | 18.84% |
| 25–34 | 1,205 | 13.08% |
| 35–44 | 1,188 | 12.89% |
| 45–54 | 1,154 | 12.52% |
| 55–64 | 1,148 | 12.46% |
| 18–24 | 814 | 8.83% |

### Finding

The gender distribution was relatively balanced. Patients under 18 represented the largest age group, while White patients represented the largest racial group in the dataset.

---

## 6. How are admissions distributed across hospital departments?

Patients with no department referral accounted for the largest portion of the dataset, representing **58.59%** of all records. General Practice was the largest named department, representing **19.97%** of patient volume.

| Department | Total Patients | Percentage of Patients |
|---|---:|---:|
| No Referral | 5,400 | 58.59% |
| General Practice | 1,840 | 19.97% |
| Orthopedics | 995 | 10.80% |
| Physiotherapy | 276 | 2.99% |
| Cardiology | 248 | 2.69% |
| Neurology | 193 | 2.09% |
| Gastroenterology | 178 | 1.93% |
| Renal | 86 | 0.93% |

### Finding

Most patients did not have a recorded department referral. Among patients with a referral, General Practice received the highest patient volume, followed by Orthopedics.

---

## Key Insights

- Neurology had the longest average wait time at **36.80 minutes**.
- Saturday was the busiest admission day with **1,368 admissions**.
- The busiest admission hour was **11:00 PM**, with **436 admissions**.
- Gastroenterology had the highest average satisfaction score at **5.80**.
- Patients waiting fewer than 15 minutes reported the highest average satisfaction.
- Patients waiting 60 minutes reported the lowest average satisfaction.
- Patients under 18 represented the largest age group.
- General Practice was the highest-volume named department.
- More than half of all patients had no recorded department referral.

## Business Recommendations

- Review staffing levels during weekends and high-volume admission hours.
- Investigate workflow delays within Neurology and other departments with above-average wait times.
- Prioritize reducing waits of 60 minutes or longer because this group reported the lowest satisfaction.
- Monitor survey response rates when comparing satisfaction across departments.
- Investigate why a large percentage of patients have no recorded department referral.
- Allocate resources based on department volume, particularly in General Practice and Orthopedics.
- Continue tracking patient volume, wait time, satisfaction, and admission patterns as recurring operational KPIs.
