# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/Ajay217071/Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL/blob/main/Netflix%20Data%20Analysis_%20Stories%20in%20SQL.png)

## Overview

This project analyses Netflix Movies and TV Shows data using PostgreSQL and answers 15 business problems using SQL.

## Dataset

* File: `netflix_titles.csv`
* Rows: 8,807
* Columns: 12
* Database: PostgreSQL

## Schema

```sql
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

## 15 Business Problems

### 1. Count the numbers of Movies vs TV Shows.

```sql
SELECT type,
       COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

### 2. Find the most common rating for Movies and TV show.

```sql
SELECT type, rating
FROM (
    SELECT type, rating,
           COUNT(*),
           RANK() OVER(
               PARTITION BY type
               ORDER BY COUNT(*) DESC
           ) AS ranking
    FROM netflix
    GROUP BY 1,2
) AS t1
WHERE ranking = 1;
```

### 3. List all movies released in a specific year (e.g 2020)

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;
```

### 4. Find the top 5 countries with the most content on Netflix.

```sql
SELECT
    UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
    COUNT(show_id) AS total_contents
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### 5. Identify the longest movie.

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(
    REPLACE(COALESCE(duration, '0 min'), ' min', '') AS INT
) DESC
LIMIT 1;
```

### 6. Find the content added in the last 5 years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD, YYYY')
      >= CURRENT_DATE - INTERVAL '5 Years';
```

### 7. Find all the movies/ TV shows by director 'Rajiv Chilaka'.

```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

### 8. List all TV Shows with more than 5 seasons.

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration,' ',1) AS INT) > 5;
```

### 9. Count the no. of content in each genre.

```sql
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
    COUNT(*)
FROM netflix
GROUP BY genre;
```

### 10. Find each year and the average number of content releases by India on Netflix.

```sql
SELECT
    EXTRACT(
        YEAR FROM TO_DATE(date_added,'Month DD, YYYY')
    ) AS year,
    COUNT(*),
    COUNT(*)::NUMERIC /
    (
        SELECT COUNT(*)
        FROM netflix
        WHERE country = 'India'
    )::NUMERIC * 100 AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;
```

### 11. List all movies that are documentaries.

```sql
WITH cte AS (
    SELECT *,
           UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre
    FROM netflix
)
SELECT COUNT(*) AS total_count
FROM cte
WHERE genre ILIKE 'Documentaries';
```

### 12. Find all content without a Director.

```sql
SELECT title
FROM netflix
WHERE director IS NULL;
```

### 13. Find how many movies actor Salman Khan appeared in over the last 10 years.

```sql
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;
```

### 14. Find the top 10 actors who appeared in the highest number of movoes produced in India.

```sql
SELECT
    UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

### 15. Categorise the contents based on presence of keywords 'kill' and 'violence' in description field. label content as "Bad" and all other content as "Good". count count how many items fall into each category.

```sql
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

* SELECT
* WHERE
* GROUP BY
* ORDER BY
* COUNT
* CTE
* Subqueries
* RANK()
* CASE
* UNNEST()
* STRING_TO_ARRAY()
* SPLIT_PART()
* Date Functions
* ILIKE

## Project Structure

```text
Netflix-SQL-Project/
├── netflix_titles.csv
├── netflix_analysis.sql
└── README.md
```

## Conclusion

This project demonstrates the use of SQL to solve practical business problems using Netflix Movies and TV Shows data.

## Author

**Ajay**

Business Analytics / Data Analytics Portfolio Project
