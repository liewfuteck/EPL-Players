CREATE DATABASE epl_players;
USE epl_players;
CREATE TABLE player_info (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(255),
	club VARCHAR(100),
    age INT NOT NULL,
    age_cat INT NOT NULL,
    nationality VARCHAR(100),
    region VARCHAR(2),
    position CHAR(2),
    position_cat INT NOT NULL);
     
CREATE TABLE player_value (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	market_value FLOAT(4,2) NOT NULL,
    page_views INT NOT NULL,
    fpl_value DEC(3,1) NOT NULL,
    fpl_sel VARCHAR(6) NOT NULL,
    fpl_points INT NOT NULL);
    
CREATE TABLE extra_info (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	new_foreign INT NOT NULL,
    club_id INT NOT NULL,
    big_club_id INT NOT NULL,
    new_signing INT NOT NULL);
    
CREATE TABLE big_clubs (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    club_id INT NOT NULL,
    club VARCHAR(100));
	
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/epldata_final.csv'
INTO TABLE player_info
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@name, @club, @age, @position, @position_cat, @market_value, @page_views, @fpl_value, @fpl_sel, @fpl_points, @region,
@nationality, @new_foreign, @age_cat, @club_id, @big_club, @new_signing) 
SET id=@id, player_name = @name, club = @club, age = @age, age_cat = @age_cat, nationality = @nationality,
region = @region, position = @position, position_cat = @position_cat;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/epldata_final.csv'
INTO TABLE player_value
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@name, @club, @age, @position, @position_cat, @market_value, @page_views, @fpl_value, @fpl_sel, @fpl_points, @region,
@nationality, @new_foreign, @age_cat, @club_id, @big_club, @new_signing) 
SET id=@id, market_value = @market_value, page_views = @page_views, fpl_value = @fpl_value, fpl_sel = @fpl_sel,
fpl_points = @fpl_points;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/epldata_final.csv'
INTO TABLE extra_info
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@name, @club, @age, @position, @position_cat, @market_value, @page_views, @fpl_value, @fpl_sel, @fpl_points, @region,
@nationality, @new_foreign, @age_cat, @club_id, @big_club, @new_signing) 
SET id=@id, new_foreign = @new_foreign, club_id = @club_id, big_club_id = @big_club, new_signing = @new_signing;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/epldata_final.csv'
INTO TABLE big_clubs
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@name, @club, @age, @position, @position_cat, @market_value, @page_views, @fpl_value, @fpl_sel, @fpl_points, @region,
@nationality, @new_foreign, @age_cat, @club_id, @big_club, @new_signing) 
SET id=@id, club_id = @club_id, club = @club;

# We also want to remove the + sign for club names with more than 1 word in it eg. Manchester+United
UPDATE player_info
SET club = REPLACE(club,"+"," ");

UPDATE big_clubs
SET club = REPLACE(club,"+"," ");

# We also have 1 footballer, namely Steve Mounie whose region is given as NA. A quick Google search shows that he is from Benin, and hence we can classify him as "Rest of the World" instead.
UPDATE player_info
SET region = 4
WHERE player_name = "Steve Mounie";
