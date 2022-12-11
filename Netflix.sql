--1.	How many movies/shows are there on Netflix?

SELECT count(id) total_id
FROM Titles


SELECT count(title) total_title
FROM Titles

SELECT*
FROM(
	SELECT title, count(id) total_id
	FROM Titles
	group by title)sub
where total_id>1
order by total_id desc




--2.	How many actors acted in each movie/show?

SELECT T.ID, Title, count(name) cnt
FROM Titles T
join Credits C
on T.id= C.id
where role='actor'
group by T.id, Title

--3.	In what year was the most movies/show released?

SELECT release_year, count(title) cnt
FROM Titles
group by release_year
order by cnt desc


--4.	Which top 5 actors have the most features in both movies and shows

SELECT *
FROM(
	SELECT * , dense_rank() over(order by cnt desc) rnk
	FROM(
		SELECT name, count(title) cnt
		FROM Titles T
		join Credits C
		on T.id= C.id
		where role='actor'
		group by name) sub
	group by name, cnt)sub2
where rnk<6
order by cnt desc, name




--5.	Fetch the director who has most movies/shows to his name.

SELECT *
FROM(
	SELECT * , dense_rank() over(order by cnt desc) rnk
	FROM(
		SELECT name, count(title) cnt
		FROM Titles T
		join Credits C
		on T.id= C.id
		where role='director'
		group by name) sub
	group by name, cnt)sub2
where rnk=1
order by cnt desc, name


--6.	Fetch the years that have the most and least genres released


SELECT distinct
      concat(first_value(release_year) over(order by total_genre),' - ', first_value(total_genre) over(order by total_genre, release_year)) as Lowest,
      concat(first_value(release_year) over(order by total_genre desc), ' - ', first_value(total_genre) over(order by total_genre desc, release_year)) as Highest
FROM(
	SELECT distinct release_year, count(genres) total_genre
	FROM Titles
	group by release_year) sub




--7.	What is the ratio of Movies to Shows on Netflix?
with mov as
	(SELECT count(title) mv
	FROM Titles
	where type='movie'),
shw as
	(SELECT count(title) sh
	FROM Titles
	where type='show')
Select CONCAT('1:', Cast(Round(sh/Cast(mv As decimal(8,2)),2) As Float)) As Ratio From mov,shw



--8.	List the top 3 movies/shows with the most actors
SELECT *
FROM(
	SELECT *, DENSE_RANK()over(order by num_of_actors desc) rnk
	FROM(
		SELECT title, count(name) num_of_actors
		FROM Titles T
		join Credits C
		on T.id= C.id
		where role= 'actor'
		group by title)sub)sub2
where rnk<4


--9.	Fetch the movie/show that have the most IMDB score and most IMDB votes

SELECT	distinct Concat((FIRST_VALUE(title) Over(order by imdb_score desc)), '-',(FIRST_VALUE(imdb_score) Over(order by imdb_score desc))) As Max_ImdbScore,
		Concat((FIRST_VALUE(title) Over(order by imdb_votes desc)), '-',(FIRST_VALUE(imdb_votes) Over(order by imdb_votes desc))) As Max_ImdbVotes
FROM(
	SELECT Title, coalesce(imdb_score, 0) as imdb_score, coalesce(imdb_votes, 0) as imdb_votes
	FROM Titles)sub


--10.	List all movies/shows that have comedy listed in their genre 

SELECT title, genres
FROM Titles
where genres like '%comedy%'

SELECT count(genres)
FROM Titles
where genres like '%comedy%'

--11.	How many movies/show has Robert De Niro casted in?

SELECT name, count(title) num_of_features
FROM Titles T
join Credits C
on T.id= C.id
where name = 'robert de niro'
group by name

--12.	Identify the number actors that has only acted in one movie/show


SELECT count(num_of_features) cnt
FROM(
	SELECT name, count(title) num_of_features
	FROM Titles T
	join Credits C
	on T.id= C.id
	where role='actor'
	group by name)sub
