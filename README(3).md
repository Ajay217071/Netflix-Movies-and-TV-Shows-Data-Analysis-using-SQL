# Netflix Movies and TV Shows Data Analysis using SQL

## Overview

SQL project analysing Netflix Movies and TV Shows data using PostgreSQL.

## Objectives

-   Compare Movies and TV Shows.
-   Find common ratings.
-   Analyse countries, genres and release years.
-   Find directors, actors and movie durations.
-   Use SQL to answer 15 business problems.

## Dataset

-   File: `netflix_titles.csv`
-   Rows: 8,807
-   Columns: 12
-   Database: PostgreSQL

## Schema

``` sql
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
    show_id VARCHAR(6),
    type VARCHAR(15),
    title VARCHAR(150),
    director VARCHAR(256),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);
```

## Business Problems and Solutions

### 1. Count Movies vs TV Shows

``` sql
SELECT type,
       COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

### 2. Find the Most Common Rating

``` sql
SELECT type, rating
FROM (
    SELECT type, rating,
           COUNT(*),
           RANK() OVER(
               PARTITION BY type
               ORDER BY COUNT(*) DESC
           ) AS ranking
    FROM netflix
    GROUP BY 1, 2
) AS t1
WHERE ranking = 1;
```

### 3. List Movies Released in 2020

``` sql
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;
```

### 4. Top 5 Countries with Most Content

``` sql
SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
       COUNT(show_id) AS total_contents
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### 5. Identify the Longest Movie

``` sql
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(
    REPLACE(COALESCE(duration, '0 min'), ' min', '') AS INT
) DESC
LIMIT 1;
```

### 6. Content Added in the Last 5 Years

``` sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY')
      >= CURRENT_DATE - INTERVAL '5 Years';
```

### 7. Content by Director Rajiv Chilaka

``` sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

### 8. TV Shows with More Than 5 Seasons

``` sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;
```

### 9. Count Content in Each Genre

``` sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
       COUNT(*)
FROM netflix
GROUP BY genre;
```

### 10. Top 5 Years for Indian Content

``` sql
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_content,
    COUNT(*)::NUMERIC /
    (SELECT COUNT(*)
     FROM netflix
     WHERE country = 'India')::NUMERIC * 100
     AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY avg_content_per_year DESC
LIMIT 5;
```

### 11. Find Documentary Content

``` sql
WITH cte AS (
    SELECT *,
           UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
    FROM netflix
)
SELECT COUNT(*) AS total_count
FROM cte
WHERE genre ILIKE 'Documentaries';
```

### 12. Find Content Without a Director

``` sql
SELECT title
FROM netflix
WHERE director IS NULL;
```

### 13. Salman Khan Movies in the Last 10 Years

``` sql
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### 14. Top 10 Actors in Indian Content

``` sql
SELECT
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

### 15. Categorise Content Using Keywords

``` sql
WITH new_table AS (
    SELECT *,
           CASE
               WHEN description ILIKE '%kill%'
                 OR description ILIKE '%violence%'
               THEN 'Bad Content'
               ELSE 'Good Content'
           END AS category
    FROM netflix
)
SELECT category,
       COUNT(*) AS total_content
FROM new_table
GROUP BY category;
```

## SQL Skills Used

-   SELECT / WHERE
-   GROUP BY / ORDER BY
-   COUNT
-   CTE
-   Subqueries
-   RANK()
-   CASE
-   UNNEST()
-   STRING_TO_ARRAY()
-   SPLIT_PART()
-   Date functions
-   ILIKE

## Project Structure

``` text
Netflix-SQL-Project/
├── netflix_titles.csv
├── netflix_analysis.sql
└── README.md
```

## Conclusion

This project demonstrates how SQL can be used to answer practical
business questions from Netflix content data.

## Author

**Ajay**

Business Analytics / Data Analytics Portfolio Project
