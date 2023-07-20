--1. How many Olympics games have been held?
--Problem Statement: Write a SQL query to find the total no of Olympic Games held as per the dataset.
--Solution: 

Select count(Distinct(games)) as Total_sports from OLYMPICS_HISTORY

--2. List down all Olympics games held so far.
--Problem Statement: Write a SQL query to list down all the Olympic Games held so far.

--Solution: 
select oh.year, oh.season, city from olympics_history as oh

--3. Mention the total no of nations who participated in each olympics game?
--Problem Statement: SQL query to fetch total no of countries participated in each olympic games.

--Solution: 

select oh.games, count(distinct(ohr.region)) as total_countries from olympics_history as oh
inner join olympics_history_noc_regions ohr
on oh.noc = ohr.noc
group by oh.games

--11. Fetch the top 5 athletes who have won the most gold medals.
--Problem Statement: SQL query to fetch the top 5 athletes who have won the most gold medals.

--Solution: 

select * from (
select *,
dense_rank() over (order by Total_gold_medal desc) as r
from (SELECT name, team, count(medal) as Total_gold_medal FROM olympics_history 
where medal = 'Gold'
group by name, team
order by count(medal) desc
) as a1) as a2
where r <=5


--14. List down total gold, silver and bronze medals won by each country.
--Problem Statement: Write a SQL query to list down the total gold, silver and bronze medals won by each country
--CROSSTAB – transpose column to row
--Coalesce – to avoid null values
--Solution: 


select country,
coalesce (gold, 0) as gold,
coalesce (silver, 0) as silver,
coalesce (bronze, 0) as bronze
from crosstab ('select ohr.region as country, medal, count(1) as total_medal from olympics_history as oh
				join olympics_history_noc_regions as ohr
				on oh.noc = ohr.noc
				where oh.medal <>  ''NA''
				group by ohr.region, medal
				order by ohr.region, medal')
			as result (country varchar, bronze bigint, gold bigint, silver bigint)
order by gold desc, silver desc, bronze desc
