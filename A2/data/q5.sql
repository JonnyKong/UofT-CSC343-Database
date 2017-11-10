-- Committed

SET SEARCH_PATH TO parlgov;
drop table if exists q5 cascade;

-- You must not change this table definition.

CREATE TABLE q5(
        countryName VARCHAR(50),
        partyName VARCHAR(100),
        partyFamily VARCHAR(50),
        stateMarket REAL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Count cabinet of each country 1996-2016
CREATE VIEW cabinet_country_count AS
SELECT country_id, COUNT(DISTINCT id) AS cabinet_number
FROM cabinet
WHERE start_date >= '1996-01-01' AND 
        start_date < '2017-01-01'
GROUP BY country_id;

-- Count of time in cabinet for each party
CREATE VIEW cabinet_party_count AS
SELECT cabinet_party.party_id, 
        COUNT(cabinet.id) AS party_cabinet_cnt,  
        cabinet.country_id
FROM cabinet_party, cabinet
WHERE cabinet_party.cabinet_id = cabinet.id AND
        cabinet.start_date >= '1996-01-01' AND
        cabinet.start_date < '2017-01-01'
GROUP BY cabinet_party.party_id, cabinet.country_id;

-- Select party id that in all cabinets
CREATE VIEW party_valid AS
SELECT cabinet_party_count.party_id,
        cabinet_party_count.country_id
FROM cabinet_country_count, 
        cabinet_party_count
WHERE cabinet_country_count.country_id = cabinet_party_count.country_id AND
        party_cabinet_cnt = cabinet_number;

-- Final answer
insert into q5 
SELECT country.name AS countryName,
        party.name AS partyName,
        party_family.family AS partyFamily,
        party_position.state_market AS stateMarket
FROM party_valid, country, party, party_family, party_position
WHERE party_valid.country_id = country.id AND
        party_valid.party_id = party.id AND
        party_valid.party_id = party_family.party_id AND
        party_valid.party_id = party_position.party_id;
