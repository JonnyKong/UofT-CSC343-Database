-- Winners

SET SEARCH_PATH TO parlgov;
drop table if exists q2 cascade;

-- You must not change this table definition.

create table q2(
countryName VARCHaR(100),
partyName VARCHaR(100),
partyFamily VARCHaR(100),
wonElections INT,
mostRecentlyWonElectionId INT,
mostRecentlyWonElectionYear INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

--Find the number of vote that win that election for each election
CREATE VIEW winner_vote AS 
SELECT election_id,max(votes)AS max_vote FROM election_result GROUP BY election_id ;

--Find the party that wins the election for each election
CREATE VIEW winner AS
SELECT party_id,country_id FROM election_result NATURAL JOIN winner_vote JOIN party ON party.id = election_result.party_id
       WHERE winner_vote.max_vote = election_result.votes ;

--Find the number of win for each party. For the party that does not win, set 0.
CREATE VIEW num_win AS
SELECT winner.party_id, count(country_id) AS num_of_winning 
FROM winner  RIGHT JOIN party ON winner.party_id = party.id GROUP BY party_id

--Find the average number of winning elections of each country
CREATE VIEW country_avg_win AS
SELECT party.country_id, sum(num_win.num_of_winning)/count(party.party_id) AS average 
       FROM num_win FULL JOIN party ON num_win.party_id = party.party_id GROUP BY party.country_id ;

--Find the party that that have won three times the average number of winning elections of parties of the same country
CREATE VIEW Answer_party AS
SELECT party_id, country_id FROM num_win NATURAL JOIN country_avg_win WHERE 3*average < num_of_winning ;

-- the answer to the query 
insert into q2 
SELECT country.name, party.name, party_family.family, num_of_winning FROM num_win n, country c, party p, party_family pf
       WHERE n.party_id = p.id, n.country_id = c.id, n.party_id = pf.party_id ;

