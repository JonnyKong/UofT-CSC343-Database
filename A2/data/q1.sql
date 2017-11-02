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

-- If votes_valid field is NULL, fill it with the sum of valid votes of parties
CREATE VIEW election_full AS
SELECT id, country_id, e_date,
	(CASE WHEN votes_valid IS NOT NULL THEN votes_valid
		ELSE (SELECT SUM(votes) FROM election_result 
			WHERE election_result.election_id = election.id)
	END) AS votes_total
FROM election;

-- GROUP BY year, country and party
SELECT EXTRACT(year FROM e_date) AS year, country_id, party_id, 
	(CASE WHEN (SUM(votes)) IS NOT NULL THEN (SUM(votes)) ELSE 0) 
	AS vote_range
FROM election_result, election_full
WHERE election_result.election_id = election_full.id
	AND e_date >= '1996-01-01' AND e_date <= '2016-12-31'
GROUP BY EXTRACT(year FROM e_date), country_id, party_id;



-- the answer to the query 
--insert into q1 

