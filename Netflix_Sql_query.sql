-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix

(show_id VARCHAR(6),
type VARCHAR (15),
title VARCHAR (150),
director VARCHAR (256),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR (10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250));


SELECT 
   DISTINCT type
FROM netflix

-- 15 Business problems

/*1.Count the numbers of Movies vs TV Shows.*/

SELECT type,
COUNT(*) AS total_content
FROM netflix
GROUP BY type

/* 2. Find the most common rating for Movies and TV show. */
SELECT type, rating
FROM
(SELECT type, rating,
COUNT (*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1,2
ORDER BY 3 DESC) AS t1
WHERE ranking = 1

/* 3. List all movies released in a specific year (e.g 2020)*/

SELECT* FROM netflix
WHERE type = 'Movie'
        AND release_year = 2020

/* 4. Find the top 5 countries with the most content on Netflix. */

SELECT 
      UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	  COUNT (show_id) AS total_contents
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

/* 5. Identify the longest movie. */


SELECT *
FROM netflix
WHERE type = 'Movie'
  AND CAST(REPLACE(duration, ' min', '') AS INT) = (
      SELECT MAX(CAST(REPLACE(duration, ' min', '') AS INT))
      FROM netflix
      WHERE type = 'Movie'
  );
  
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(COALESCE(duration, '0 min'), ' min', '') AS INT) DESC
LIMIT 1;

/* 6. Find the content added in the last 5 years */

SELECT * 
FROM netflix

WHERE 
TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 Years'

/* 7. Find all the movies/ TV shows by director 'Rajiv Chilaka'. */

SELECT *
 FROM (SELECT *,
UNNEST(STRING_TO_ARRAY(director,',')) AS New_director
FROM netflix)
WHERE New_director ='Rajiv Chilaka'

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

/* 8. List all TV Shows with more than 5 seasons. */

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT) > 5;

SELECT * FROM netflix
WHERE type ='TV Show'
        AND CAST (SPLIT_PART(duration,' ',1) AS INT) > 5

/* 9. Count the no. of content in each genre.*/

SELECT
 UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre, COUNT(*)
FROM netflix
GROUP BY genre

/* 10. Find each year and the average number of content releases by India on Netflix. */


SELECT 
     EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as year,
	 COUNT(*),
	 COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country ='India')::numeric *100 as avg_content_per_year
	 FROM netflix
WHERE country ='India'
GROUP BY 1

/* 11. List all movies that are documentaries. */

WITH cte AS
(SELECT *,
UNNEST (STRING_TO_ARRAY(listed_in,',')) AS genre
FROM netflix)

SELECT
COUNT(*) AS total_count
FROM cte
WHERE  genre ILIKE 'Documentaries'

/* 12. Find all content without a Director. */

SELECT title
FROM netflix
WHERE director IS NULL

/* 13. Find how many movies actor Salman Khan appeared in over the last 10 years. */

SELECT * FROM netflix

SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%' 
      AND release_year > EXTRACT (YEAR FROM CURRENT_DATE)-10

/* 14. Find the top 10 actors who appeared in the highest number of movoes produced in India.*/
SELECT 
--show_id,
--casts,
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM Netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/* 15. Categorise the contents based on presence of keywords 'kill' and 'violence' in description field. label content as "Bad" and all other content as "Good".
count count how many items fall into each category.*/

WITH new_table as (SELECT *,
CASE
WHEN 
   description ILIKE '%kill%' OR
   description ILIKE '%violence%' THEN 'Bad Content'
   ELSE 'Good Content'
 END category
FROM netflix)
       









