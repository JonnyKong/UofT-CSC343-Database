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
SELECT party.id AS party_id,party.country_id, election_result.election_id
FROM (election_result NATURAL JOIN winner_vote )JOIN party ON party.id = election_result.party_id
WHERE winner_vote.max_vote = election_result.votes ;

--Find the number of win for each party. For the party that does not win, set 0
CREATE VIEW num_win AS
SELECT num.party_id, party.country_id, num.num_of_winning
FROM(SELECT winner.party_id , count(party.country_id) AS num_of_winning 
FROM winner  RIGHT JOIN party ON winner.party_id = party.id GROUP BY party_id )num  LEFT JOIN party ON party.id= num.party_id;

--Find the average number of winning elections of each country
CREATE VIEW country_avg_win AS
SELECT party.country_id, (sum(num_win.num_of_winning)/count(party.id) )AS average 
FROM num_win RIGHT JOIN party ON num_win.party_id = party.id GROUP BY party.country_id ;

--Find the party that that have won three times the average number of winning elections of parties of the same country
CREATE VIEW answer_party AS
SELECT n.party_id ,c country_id FROM num_win n JOIN country_avg_win c ON n.country_id = c.country_id 
WHERE 3*(c.average) < n.num_of_winning ;

--Anwser except mostRecentlyWonElectionId and mostRecentlyWonElectionYear
CREATE VIEW answer_without_five_attributes AS
SELECT a.party_id,c.name AS countryName
FROM answer_party a JOIN country c ON a.country_id=c.id;

CREATE VIEW answer_without_four_attributes AS
SELECT a.party_id, a.countryName, p.name AS partyName
FROM answer_without_five_attributes a JOIN party p ON a.party_id=p.id;

CREATE VIEW answer_without_three_attributes AS
SELECT a.party_id,a.countryName, a.partyName, pf.family AS partyFamily
FROM answer_without_four_attributes a JOIN party_family pf ON a.party_id=pf.party_id;

CREATE VIEW answer_without_two_attributes AS
SELECT a.party_id,a.countryName, a.partyName, a.partyFamily, n.num_of_winning AS wonElections
FROM answer_without_three_attributes a JOIN num_win n ON a.party_id = n.party_id;

--Find the most recentwon election for each party.
CREATE VIEW most_recent_won AS
SELECT recent.party_id,winner.election_id AS mostRecentlyWonElectionId, recent. mostRecentlyWonElectionId
FROM ((SELECT winner.party_id, MAX(election.e_date) AS mostRecentlyWonElectionId
     FROM winner LEFT JOIN election ON winner.election_id = election.id 
     GROUP BY winner.party_id) recent JOIN winner ON recent.party_id = winner.party_id) 
     JOIN election_result ON election_result.election_id = winner.election_id AND recent.mostRecentlyWonElectionId = election.e_date;

-- the answer to the query 
insert into q2 
SELECT a.countryName,a.partyName,a.partyFamily,a.wonElections, m.mostRecentlyWonElectionId,m.mostRecentlyWonElectionYear
FROM answer_without_two_attributes a JOIN most_recent_won m ON a.party_id = m.party_id;
