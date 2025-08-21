DROP TABLE IF EXISTS Netflix;
Create table Netflix(
show_id varchar(6),
type varchar(10),
title varchar(150),
director varchar(210),
casts varchar(1000),
country	varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(250),
description varchar(300)
);

Select * from Netflix;

--- 15 Business Problems & Solutions ---

1. Count the number of Movies vs TV Shows

Select type, 
COUNT(*) from Netflix
GROUP BY 1;


2. Find the most common rating for movies and TV shows

Select type , rating,
COUNT(*) as Rating_count from Netflix
GROUP BY type,rating
ORDER BY 1 , 3 DESC
;

3. List all movies released in a specific year (e.g., 2020)


Select type ,release_year from Netflix
Where release_year=2020 
AND
type='Movie';



4. Find the top 5 countries with the most content on Netflix


SELECT UNNEST(STRING_TO_ARRAY (COUNTRY, ',')) AS New_country, 
COUNT(show_id) as Total_Content from Netflix
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5;


5. Identify the longest movie


Select * from Netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) from Netflix);


6. Find content added in the last 5 years


Select * from Netflix
Where
TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 year';
	

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

Select type , director from Netflix
WHERE director LIKE '%Rajiv Chilaka%';


8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;


9. Count the number of content items in each genre

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 50;


11. List all movies that are documentaries

SELECT * FROM Netflix
WHERE  type='Movie' and listed_in ILIKE '%documentaries%';





12. Find all content without a director

Select * from Netflix
WHERE director is null;



13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;