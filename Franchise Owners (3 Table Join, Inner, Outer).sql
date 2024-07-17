/* 
In this project, I created a table with the top 15 wealthiest NBA owners. 
After, I created a seperate table with information on what they did to gain wealth and join the tables to create readable lists.

This project contains 3 tables with at least 15 rows in total. 
The data is from 2020 and was sourced from Just Richest (https://justrichest.com/all-the-nba-team-owners-and-their-net-worth/) and Google searches.

This project includes the use of 3 tables joins, outer joins, inner joins and more.
*/

CREATE TABLE nba_owners (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER,
    gender VARCHAR(10),
    team VARCHAR(50)
);
CREATE TABLE wealth (
    owner_id INTEGER,
    net_worth_billion INTEGER,
    source_wealth VARCHAR(100),
    industry_wealth VARCHAR(100),
    FOREIGN KEY (owner_id) REFERENCES nba_owners(id)
);
CREATE TABLE personal (
    owner_id INTEGER,
    relationship_status VARCHAR(50),
    spouse_name VARCHAR(50),
    no_of_children INTEGER,
    college_name VARCHAR(100),
    hobbies VARCHAR(100),
    FOREIGN KEY (owner_id) REFERENCES nba_owners(id)
);
INSERT INTO nba_owners (id, name, age, gender, team) VALUES
    (1, "Steve Ballmer", 64, "male", "LA Clippers"),
    (2, "Dan Gilbert", 60, "male", "Cleveland Cavaliers"),
    (3, "Paul Allen Estate", 82, "male", "Portland Trailblazers"),
    (4, "Joe Tsai", 49, "male", "Brooklyn Nets"),
    (5, "Robert Pera", 42, "male", "Memphis Grizzles"),
    (6, "Phillip Anschutz", 88, "male", "LA Lakers"),
    (7, "Stanley Kroenke", 76, "male", "Denver Nuggets"),
    (8, "Tom Gores", 63, "male", "Detroit Pistons"),
    (9, "Richard Devos Estate", 78, "male", "Orlando Magic"),
    (10, "Joshua Harris", 63, "male", "Philadelphia 76ers"),
    (11, "Mark Cuban", 62, "male", "Dallas Mavericks"),
    (12, "Tilman Fertitta", 63, "male", "Houston Rockets"),
    (13, "Tony Ressler", 63, "male", "Atlanta Hawks"),
    (14, "Gayle Benson", 75, "male", "New Orleans Pelicans");
    
INSERT INTO wealth (owner_id, net_worth_billion, source_wealth, industry_wealth) VALUES
    (1, 75.6, "Microsoft", "Technology"),
    (2, 44.8, "Quicken", "Finance"),
    (3, 20.3, "Microsoft", "Technology"),
    (4, 14.2, "Alibaba", "Consumer Goods"),
    (5, 14.1, "Ubiquiti", "Technology"),
    (6, 10.1, "Oil", "Diversified"),
    (7, 8.3, "Real Estate", "Diversified"),
    (8, 5.9, "Carnival Corp", "Cruiseline"),
    (9, 5.7, "Diversified", "Diversified"),
    (10, 5.4, "Amway", "Consumer Goods"),
    (11, 4.6, "Diversified", "Technology"),
    (12, 4.2, "Diversified", "Technology"),
    (13, 4.1, "Diversified", "Diversified"),
    (14, 3.9, "Private Equity", "Finance"),
    (15, 3.3, "Inheritance", "Diversified");    
    
INSERT INTO personal (owner_id, relationship_status, spouse_name, no_of_children, college_name, hobbies) VALUES
    (1, "married", "Connie Synder", 3, "Harvard", "watching basketball, golf"),
    (2, "married", "Jennifer Gilbert", 5, "Michigan State", "sports"),
    (3, "married", "Connie Allen", 3, "Harvard University", "watching basketball"),
    (4, "married", "Clara Wu", 3, "Yale", "solar cars, music synthesizers"),
    (5, "single", "none", "0", "San Diego", "Pickleball"),
    (6, "married", "Nancy Anschultz", 3, "Kansas", "Piano, Tennis"),
    (7, "married", "Ann Walton", 2, "Missouri", "Reading books"),
    (8, "married", "Maddie Arison", 2, "Drop Out", "Jet Ski"),
    (9, "married", "Holly Gores", 3, "Michigan State", "Playing sports"),
    (10, "widowed", "Helen Van Wesep", 4, "Calvin College", "Reading, Watching movies, Jungle adventure"),
    (11, "married", "Marjorie Harris", 5, "Harvard", "Submarine exploration"),
    (12, "married", "Tiffany Stewart", 3, "Pittsburgh", "Philanthropy"),
    (13, "married", "Lauren Ware", 4, "Drop Out", "Reading, Travelling"),
    (14, "married", "Jami Gertz", 3, "Georgetown", "yacht-racing"),
    (15, "widowed", "Tom Benson", n/a, "None", "Reading, Playing piano");

--Q1.(3 TABLE JOIN) Show owners along with their net worth and hobbies. Order by net worth.
SELECT 
  n.name
  ,w.net_worth_billion
  ,p.hobbies
FROM wealth w
JOIN personal p ON p.owner_id = w.owner_id
JOIN nba_owners n ON n.id = w.owner_id
ORDER BY w.net_worth_billion desc;

--Q2.(INNER JOIN) Find the net worth of each billionaire ordered from highest to lowest.
SELECT 
  name
  ,net_worth_billion
FROM nba_owners
JOIN wealth ON nba_owners.id = wealth.owner_id
ORDER BY net_worth_billion desc;

--Q3.(LEFT OUTER JOIN) Show owners and their number of kids, including those without kids.
SELECT 
  name
  ,no_of_children
FROM nba_owners
LEFT OUTER JOIN personal ON nba_owners.id = personal.owner_id;

--Q4.(INNER JOIN) Find the source of wealth for each owner.
SELECT 
  name
  ,source_wealth
FROM nba_owners
JOIN wealth ON nba_owners.id = wealth.id;

--Q5.(INNER JOIN) Which billionaires have a net worth of at least $30 billion from the technology industry?
SELECT 
  name
  ,net_worth_billion
  ,industry_wealth
FROM nba_owners
JOIN wealth ON nba_owners.id = wealth.owner_id
WHERE net_worth_billion >= 30 
  AND industry_wealth = 'Technology';
