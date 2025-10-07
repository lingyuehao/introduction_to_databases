-- Basic Analysis 
-- 1. Count total rows, unique universities and countries, and the range of years.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT institution) AS unique_institutions,
    COUNT(DISTINCT country) AS unique_countries,
    MIN(year) AS earliest_year,
    MAX(year) AS latest_year
FROM university_rankings;
-- Output of query 1: 2200|1024|59|2012|2015
-- So we have 2200 rows, 1024 unique universities, 59 unique countries, and data from 2012 to 2015.

-- 2. Score Statistics
SELECT year,
       MAX(score) AS highest_score,
       MIN(score) AS lowest_score,
       ROUND(AVG(score), 2) AS average_score
FROM university_rankings
GROUP BY year
ORDER BY year;
-- Output of query 2:
-- 2012|100.0|0.0|54.94
-- 2013|100.0|0.0|55.27
-- 2014|100.0|0.0|47.27
-- 2015|100.0|0.0|46.86

-- 3. Average score per country
SELECT country, ROUND(AVG(score), 2) AS avg_score
FROM university_rankings
GROUP BY country
ORDER BY AVG(score) DESC
LIMIT 10;
-- Output of query 3:
-- Israel|52.65
-- USA|51.85
-- Switzerland|51.21
-- Singapore|50.16
-- United Kingdom|49.47
-- Netherlands|47.96
-- Sweden|47.89
-- Denmark|47.77
-- Russia|47.38
-- Canada|47.36


-- 4. Number of universities ranked each year
SELECT year, COUNT(DISTINCT institution) AS universities_per_year
FROM university_rankings
GROUP BY year
ORDER BY year;
-- Output of query 4:
--2012｜100
--2013｜100
--2014｜1000
--2015｜1000

-- 5. Which country achieved the highest average score each year
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
-- Output of query 5:
-- 2012|United Kingdom|57.95
-- 2013|United Kingdom|62.84
-- 2014|Israel|52.14
-- 2015|Singapore|51.37


-- CRUD Operations for University Rankings
-- Create
INSERT INTO university_rankings (institution, country, world_rank, score, year)
VALUES ('Duke Tech', 'USA', 350, 60.5, 2014);

-- Read
SELECT COUNT(*) AS japan_top200_2013
FROM university_rankings
WHERE country = 'Japan'
  AND year = 2013
  AND world_rank <= 200;
-- Output: 6

-- Update
UPDATE university_rankings
SET score = score + 1.2
WHERE institution = 'University of Oxford'
  AND year = 2014;

-- Delete
DELETE FROM university_rankings
WHERE year = 2015
  AND score < 45;


 
