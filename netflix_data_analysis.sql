SELECT * FROM netflix_data;

-- 15 Business Problems & Solutions --

-- 1. Count the number of Movies vs TV Shows --
SELECT COUNT(show_id) as movies_VS_tvshows, show_type FROM netflix_data
GROUP BY show_type;

-- 2. Find the most common rating for movies and TV shows --
SELECT show_type, rating, COUNT(*)AS count
FROM netflix_data
GROUP BY show_type, rating
ORDER BY count DESC;

-- 3. List all movies released in a specific year (e.g., 2020) --
SELECT title, release_year FROM netflix_data
WHERE release_year = 2020 AND show_type = "Movie";

-- 4. Find the top 5 countries with the most content on Netflix --

DELETE from netflix_data
WHERE country IS NULL OR TRIM (country)= '';

SELECT country, COUNT(*) AS most_content FROM netflix_data
GROUP BY country
HAVING country is NOT NULL
ORDER BY most_content DESC
LIMIT 5;

-- 5. Identify the longest movie -- 
SELECT title, duration
FROM netflix_data
WHERE show_type = 'Movie' AND duration LIKE '%min'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;

-- 6. Find content added in the last 5 years --
SELECT *, release_year FROM netflix_data
WHERE release_year IN ( 2021, 2020, 2019,2018, 2017)
ORDER BY release_year DESC;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'! --
SELECT show_type, director, title FROM netflix_data
WHERE director = "Rajiv Chilaka";

-- 8. List all TV shows with more than 5 seasons --
SELECT * FROM netflix_data
WHERE show_type = 'TV Show' AND duration LIKE '%Season%'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 9. Count the number of content items in each genre -- 
SELECT listed_in, COUNT(*) AS count
FROM netflix_data
GROUP BY listed_in
ORDER BY count DESC;

-- 10.Find each year and the average numbers of content release in India on netflix & return top 5 year with highest avg content release! --
SELECT COUNT(*) AS average_content, release_year
FROM netflix_data
WHERE country = "India"
GROUP BY release_year
ORDER BY average_content DESC
LIMIT 5;

-- 11. List all movies that are documentaries --
SELECT * FROM netflix_data
WHERE show_type = "Movie" AND listed_in LIKE "%Documentaries%";

-- 12. Find all content without a director -- 
SELECT * FROM netflix_data
WHERE director IS NULL OR TRIM(director) = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years! --
SELECT COUNT(*) AS movie_count
FROM netflix_data
WHERE show_type = 'Movie'
AND cast LIKE '%Salman Khan%'
AND release_year >= YEAR(CURDATE()) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.-- 
SELECT actor, COUNT(*) AS movie_count
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', n.n), ',', -1)) AS actor
    FROM netflix_data
    JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM 
            (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
            (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    ) n
    WHERE show_type = 'Movie' AND country LIKE '%India%' AND cast IS NOT NULL AND n.n <= LENGTH(cast) - LENGTH(REPLACE(cast, ',', '')) + 1
) AS actors
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category. --
SELECT 
	CASE
		WHEN LOWER(description) LIKE "%kill%" OR LOWER(description) LIKE "%violence%" THEN "Bad"
        ELSE "Good"
	END AS category,
COUNT(*) AS count
FROM netflix_data
GROUP BY category;


