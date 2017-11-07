-- Participate

SET SEARCH_PATH TO parlgov;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
        countryName varchar(50),
        year int,
        participationRatio real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- If votes_cast empty, speculate from sum of election results
CREATE VIEW election_full AS 
SELECT election.id, election.country_id, election.e_date, electorate,
        (CASE WHEN votes_cast IS NOT NULL THEN votes_cast
        ELSE (
                SELECT SUM(votes) 
                FROM election_result
                WHERE election_result.election_id = election.id)
                END) AS votes_cast
FROM election;


-- Group by each country and year
CREATE VIEW participation_ratio AS 
SELECT EXTRACT(year FROM e_date) AS year, country_id, AVG(votes_cast::numeric / electorate::numeric) AS ratio
FROM election_full
WHERE e_date > '2001-01-01' AND e_date < '2016-12-31'
GROUP BY year, country_id;

-- SELECT ID of countries not valid
CREATE VIEW cid_not_valid AS
SELECT DISTINCT country_id
FROM participation_ratio
WHERE EXISTS (
        SELECT * 
        FROM participation_ratio p
        WHERE 
                participation_ratio.year > p.year AND
                participation_ratio.ratio < p.ratio);

-- SELECT ID of countries that are valid
CREATE VIEW cid_valid AS
SELECT id
FROM country
WHERE NOT EXISTS (
        SELECT * 
        FROM cid_not_valid
        WHERE country.id = cid_not_valid.country_id
);


-- the answer to the query 
insert into q3 
SELECT country.name AS countryName, 
        participation_ratio.year AS year, 
        participation_ratio.ratio AS participationRatio
FROM participation_ratio, country, cid_valid
WHERE participation_ratio.country_id = country.id AND 
        participation_ratio.country_id = cid_valid.id; 