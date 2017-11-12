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
SELECT party_id,country_id, election_result.election_id
FROM election_result NATURAL JOIN winner_vote JOIN party ON party.id = election_result.party_id
WHERE winner_vote.max_vote = election_result.votes ;

--Find the number of win for each party. For the party that does not win, set 0
CREATE VIEW num_win AS
SELECT winner.party_id , party.country_id, count(party.country_id) AS num_of_winning 
FROM winner  RIGHT JOIN party ON winner.party_id = party.id GROUP BY party_id ;

--Find the average number of winning elections of each country
CREATE VIEW country_avg_win AS
SELECT party.country_id, sum(num_win.num_of_winning)/count(party.id) AS average 
FROM num_win RIGHT JOIN party ON num_win.party_id = party.id GROUP BY party.country_id ;

--Find the party that that have won three times the average number of winning elections of parties of the same country
CREATE VIEW answer_party AS
SELECT party_id ,country_id FROM num_win n JOIN country_avg_win c ON n.country_id = c.country_id WHERE 3*average < num_of_winning ;

--Anwser except mostRecentlyWonElectionId and mostRecentlyWonElectionYear
CREATE VIEW answer_without_two_attributes AS
SELECT a.party_id,c.name AS countryName, p.name AS partyName, pf.family AS partyFamily, num_of_winning AS wonElections
FROM ((anwser_party a JOIN country c ON a.country_id=c.id)JOIN party p ON a.party_id=p.id)JOIN party_family pf ON a.party_id=pf.party_id;

--Find the most recentwon election for each party.
CREATE VIEW most_recent_won AS
SELECT winner.party_id, winner.election_id, MAX(election.e_date)
FROM winner LEFT JOIN election ON winner.election_id = election.id GROUP BY winner.party_id;

-- the answer to the query 
insert into q2 
SELECT *
FROM answer_without_two_attributes a JOIN most_recent_won m ON a.party_id = m.party_id;
