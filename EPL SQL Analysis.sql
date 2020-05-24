USE epl_players;

# We first see the number of players on each team
SELECT club, count(*)
FROM player_info
GROUP BY club
ORDER BY count(*) DESC;

-- This is surprising, since it is likely for big clubs to have more players on the team for more competitions. However, we see
-- that many top teams such as Chelsea and Manchester City are near the bottom half of the table.

# Next, we explore the ratio of goalkeepers to defenders to midfielders to strikers. We see from the position_cat field that 1 = Strikers, 2 = Midfielders, 3 = Defenders and 4 = Goalkeepers
SELECT position_cat, COUNT(*)
FROM player_info
GROUP BY position_cat
ORDER BY position_cat;
-- We see that there are 42 goalkeepers, 153 defenders, 112 midfielders and 154 strikers.

-- We can explore a little further to see the exact counts of all the different positions in football.
SELECT position, COUNT(*)
FROM player_info
GROUP BY position
ORDER BY COUNT(*) DESC;
-- We see that the most common position in EPL is the central-back. This may be because defenders are required to be more physical, and hence a higher chance of injury.
-- We also see that there is a much higher proportion of players who are playing centrally as compared to those on the left and right. Is it possible that those who play on the wings command a higher market value due to lack of supply?
-- Hence, we can check 2 things. Firstly, we check the top 50 players in EPL with the highest market fee, and see their positions.

SELECT i.player_name, i.position_cat, v.market_value
FROM player_info i
LEFT JOIN player_value v
ON i.id = v.id
ORDER BY v.market_value DESC
LIMIT 50;
-- We see that most of the top 50 players belong to player_cat 1, signifying that strikers and attacking footballers tend to command the highest transfer fees.
-- To get a better idea, we see exactly how many of each position_cat there are in the top 50 players.

SELECT tmp.position_cat, COUNT(*) FROM
(SELECT i.position_cat
FROM player_info i
LEFT JOIN player_value v
ON i.id = v.id
ORDER BY v.market_value DESC
LIMIT 50)
AS tmp
GROUP BY tmp.position_cat
ORDER BY tmp.position_cat;
-- Using this nested subquery, we observe that more than half (54%) of the top 50 most expensive footballers are strikers. Followed by midfielders, then defenders and goalkeepers. Could there be a correlation between the prices of players and the number of players in EPL (cheaper, so able to buy more defenders)?

SELECT i.club, i.player_name, i.position, i.position_cat, MAX(v.market_value) AS highest_market_value
FROM player_info i
LEFT JOIN player_value v
ON i.id = v.id
GROUP BY i.club
ORDER BY highest_market_value DESC;
-- Unsurprisingly, we see that most of the players in this list are 1's (i.e. attacking footballers)

-- We can also do some analysis based on region of the footballers. We first get an idea of the number of players from each region in the entire EPL.
-- Recall that 1 is for England, 2 for EU, 3 for Americas and 4 for Rest of World
SELECT i.region, COUNT(*), ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM player_info i),2) AS Percentage
FROM player_info i
GROUP BY i.region
ORDER BY i.region;
-- Every 1 in 3 player in the EPL comes from England. This could lead to insights into the development of English football (academies etc.). If there is sufficient data, we could also compare against the home-grown to foreign players in other top leagues such as Spain and Germany, to gauge
-- the performance of England's academies.


-- We carry out 2 queries to find both the number of English footballers, and the number of footballers for each football team.
-- Number of English footballers for each football team
SELECT i.club, COUNT(*) as count
FROM player_info i
WHERE i.region = 1 
GROUP BY i.club
ORDER BY i.club;

-- Number of footballers for each football team
SELECT i.club, COUNT(*) as count
FROM player_info i
GROUP BY i.club
ORDER BY i.club;

-- To get a better idea, we see the number and percentage of English footballers on each team.
SELECT i.club, COUNT(*) AS count_players, 
				SUM(CASE WHEN i.region=1 THEN 1 ELSE 0 END) AS count_eng_players, 	
                ROUND(AVG(i.region=1)*100,2) AS percentage
FROM player_info i
GROUP BY i.club
ORDER BY percentage DESC;
-- From this query, we see that only 3 clubs have at least 50% English players. In fact, last-ranking Chelsea (who was the champion in the season before) only has 5% of English players.


-- We next explore the most common age, compared to the mean age in the Premier League. We filter out Goalkeepers for a separate query, since it is known that Goalkeepers are usually of a higher age
SELECT i.age, COUNT(*)
FROM player_info i
WHERE NOT i.position_cat = 4
GROUP BY i.age
ORDER BY i.age;
-- We can do a histogram plot for this in R, see if it fits a normal distribution, and find other summary statistics.

SELECT i.age, COUNT(*)
FROM player_info i
WHERE i.position_cat = 4
GROUP BY i.age
ORDER BY i.age;
-- Leave the summary statistics for these in RStudio


-- We again want to gather some summary statistics for big_club players and FPL_selection.
-- We first see the proportion of big_club players when it comes to highest FPL_selection percentage
-- We can leave the testing of independence between FPL_selection and FPL_points by doing a chi-square distribution in R

SELECT i.player_name, i.club, v.fpl_value, e.big_club_id
FROM player_info i
LEFT JOIN  player_value v
ON i.id = v.id
LEFT JOIN extra_info e
ON i.id = e.id
ORDER BY v.fpl_value DESC
LIMIT 50;
-- From this table, it seems that there is a strong correlation between a high fpl_value and being from a big club (ie. big_club_id = 1)

-- We can also check if there is a relationship between fpl_points and being from a big club.
SELECT i.player_name, i.club, v.fpl_points, e.big_club_id
FROM player_info i
LEFT JOIN  player_value v
ON i.id = v.id
LEFT JOIN extra_info e
ON i.id = e.id
ORDER BY v.fpl_points DESC
LIMIT 50;
-- Again, it seems that there is a strong correlation between fpl_points and big_club_id = 1. 

-- Finally, we do a quick check of the relationship between high_fpl_sel and high page views (likely as a metric of popularity).
SELECT i.player_name, i.club, v.page_views, v.fpl_sel, e.big_club_id
FROM player_info i
LEFT JOIN  player_value v
ON i.id = v.id
LEFT JOIN extra_info e
ON i.id = e.id
ORDER BY v.page_views DESC
LIMIT 50;
-- Again, there is a strong correlation between page_views and big_club. However, hard to say if there is a correlation between fpl_sel and page_views. We can try doing either a chi-square test, or ANOVA table.