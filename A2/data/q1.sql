-- VoteRange

SET SEARCH_PATH TO parlgov;
drop table if exists q1 cascade;

-- You must not change this table definition.

create table q1(
year INT,
countryName VARCHAR(50),
voteRange VARCHAR(20),
partyName VARCHAR(100)
);


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- If votes_valid field is NULL, speculate it with the sum of valid votes of parties
CREATE VIEW election_full AS
SELECT id, country_id, e_date,
	(CASE WHEN votes_valid IS NOT NULL THEN votes_valid
		ELSE (SELECT SUM(votes) FROM election_result 
			WHERE election_result.election_id = election.id)
	END) AS votes_total
FROM election;

-- Group result by each election
CREATE VIEW groupedByElection AS
SELECT MAX(e_date) AS e_date, country_id, party_id, COALESCE(((100 * SUM(votes)) / MAX(votes_total)), 0) AS vote_range
FROM election_result, election_full
WHERE election_result.election_id = election_full.id
	AND e_date >= '1996-01-01' AND e_date <= '2016-12-31'
GROUP BY election_full.id, country_id, party_id
ORDER BY party_id;

-- If multiple elections in a year, average all elections in this year
CREATE VIEW groupedByYear AS
SELECT EXTRACT(year FROM e_date) AS year, country_id, party_id, AVG(vote_range) AS vote_range_avg
FROM groupedByElection
GROUP BY EXTRACT(year FROM e_date), country_id, party_id
HAVING AVG(vote_range) > 0;


-- the answer to the query 
insert into q1 
SELECT groupedByYear.year AS year, country.name AS countryName,
	(CASE
	WHEN vote_range_avg <= 5 THEN '(0-5]'
	WHEN groupedByYear.vote_range_avg > 5 AND groupedByYear.vote_range_avg <= 10 THEN '(5-10]'
	WHEN groupedByYear.vote_range_avg > 10 AND groupedByYear.vote_range_avg <= 20 THEN '(10-20]'
	WHEN groupedByYear.vote_range_avg > 20 AND groupedByYear.vote_range_avg <= 30 THEN '(20-30]'
	WHEN groupedByYear.vote_range_avg > 30 AND groupedByYear.vote_range_avg <= 40 THEN '(30-40]'
	ELSE '(40-100]'
	END) AS voteRange,
	party.name AS partyName
FROM groupedByYear, country, party
WHERE groupedByYear.country_id = country.id AND groupedByYear.party_id = party.id;
