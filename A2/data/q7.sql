-- Alliances

SET SEARCH_PATH TO parlgov;
drop table if exists q7 cascade;

-- You must not change this table definition.

DROP TABLE IF EXISTS q7 CASCADE;
CREATE TABLE q7(
        countryId INT, 
        alliedParty1 INT, 
        alliedParty2 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.
-- Select the <party, party> pair where they formed alliance in some election in some country
CREATE VIEW pairs AS
SELECT ER1.party_id AS p1, ER2.party_id AS p2, ER1.election_id, election.country_id
FROM election_result ER1, election_result ER2, election
WHERE ER1.election_id = ER2.election_id AND
        (ER1.alliance_id = ER2.id OR ER1.id = ER2.alliance_id) AND
        ER1.election_id = election.id AND
        ER1.party_id < ER2.party_id
GROUP BY(ER1.election_id, ER1.party_id, ER2.party_id, election.country_id);

-- Number of elections in each country
CREATE VIEW sum_elections AS
SELECT country_id, COUNT(*) AS election_cnt
FROM election
GROUP BY country_id;

-- Sum the pairs to see if its more than 1/3 of that country



-- the answer to the query 
insert into q7 
SELECT pairs.country_id AS countryId, 
        pairs.p1 AS alliedParty1, 
        pairs.p2 AS alliedParty2
FROM pairs, sum_elections
WHERE pairs.country_id = sum_elections.country_id
GROUP BY pairs.p1, pairs.p2, pairs.country_id, sum_elections.election_cnt
HAVING COUNT(*) >= (sum_elections.election_cnt::numeric * 0.3);