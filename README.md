[![Introduction to Databases](https://github.com/lingyuehao/introduction_to_databases/actions/workflows/blank.yml/badge.svg)](https://github.com/lingyuehao/introduction_to_databases/actions/workflows/blank.yml)
# introduction_to_databases

## Connect to Database
I used SQLite in VS Code with the SQLite extension. 
First I downloaded the database and saved in the folder. 
Then I connected to the provided database file `university_database.db` by running this in the terminal:

```bash
sqlite3 university_database.db
```
![Screenshot](./img/connect_to_database%20.png)


## Basic Analysis
### (1) Count total rows, unique universities, countries, and range of years
```bash
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT institution) AS unique_institutions,
    COUNT(DISTINCT country) AS unique_countries,
    MIN(year) AS earliest_year,
    MAX(year) AS latest_year
FROM university_rankings;
```
Result: 2200 rows, 1024 unique universities, 59 countries, data from 2012–2015.

### (2) Score statistics by year
```bash
SELECT year,
       MAX(score) AS highest_score,
       MIN(score) AS lowest_score,
       ROUND(AVG(score), 2) AS average_score
FROM university_rankings
GROUP BY year
ORDER BY year;
```
Insight:
Average scores peaked in 2013 (55.27) but dropped steadily afterward, indicating overall performance declined even though top universities maintained perfect scores (100 each year).

### (3) Average score per country (Top 10)
```bash
SELECT country, ROUND(AVG(score), 2) AS avg_score
FROM university_rankings
GROUP BY country
ORDER BY AVG(score) DESC
LIMIT 10;
```
Top Countries: Israel, USA, Switzerland, Singapore, United Kingdom, Netherlands, Sweden, Denmark, Russia, Canada.

### （4）Number of ranked universities per year
```bash
SELECT year, COUNT(DISTINCT institution) AS universities_per_year
FROM university_rankings
GROUP BY year
ORDER BY year;
```
Result：Consistent number of ranked institutions per year (about 1000 in later years).

### (5) Country with the highest average score each year
```bash
WITH yearly_avg AS (
  SELECT year, country, AVG(score) AS avg_score
  FROM university_rankings
  GROUP BY year, country
),
max_avg AS (
  SELECT year, MAX(avg_score) AS max_score
  FROM yearly_avg
  GROUP BY year
)
SELECT y.year, y.country, ROUND(y.avg_score, 2) AS avg_score
FROM yearly_avg y
JOIN max_avg m
  ON y.year = m.year AND y.avg_score = m.max_score
ORDER BY y.year;
```
Result:
2012 – United Kingdom (57.95)
2013 – United Kingdom (62.84)
2014 – Israel (52.14)
2015 – Singapore (51.37)

## CRUD Operations
### (1) Create
```bash
INSERT INTO university_rankings (institution, country, world_rank, score, year)
VALUES ('Duke Tech', 'USA', 350, 60.5, 2014);
```
Added a new record for Duke Tech in 2014.

### (2) Read
```bash
SELECT COUNT(*) AS japan_top200_2013
FROM university_rankings
WHERE country = 'Japan'
  AND year = 2013
  AND world_rank <= 200;
```
Counted 6 universities from Japan in the global top 200 for 2013.

### (3) Update
```bash
UPDATE university_rankings
SET score = score + 1.2
WHERE institution = 'University of Oxford'
  AND year = 2014;
```
Corrected University of Oxford’s 2014 score by +1.2 points.

### (4) Delete
```bash
DELETE FROM university_rankings
WHERE year = 2015
  AND score < 45;
```
Removed all universities from 2015 with scores below 45 as per the committee’s review.
