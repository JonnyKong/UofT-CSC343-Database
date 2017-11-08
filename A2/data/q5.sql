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

-- SELECT cabinet, their country and party within last 20 years
CREATE VIEW cabinet_valid AS
SELECT cabinet.id, cabinet.country_id, cabinet_party.party_id
FROM cabinet, cabinet_party
WHERE start_date >= '1996-01-01' AND 
        start_date <= '2016-12-31' AND
        cabinet.id = cabinet_party.cabinet_id;

-- SELECT country WHERE more than 1 party was cabinet in last 20 years
CREATE VIEW invalid_country AS
SELECT c1.country_id AS id
FROM cabinet_valid c1, cabinet_valid c2
WHERE c1.country_id = c2.country_id AND
        c1.party_id <> c2.party_id;

-- SELECT country only 1 party was in cabinet
CREATE VIEW valid_country AS
(SELECT DISTINCT id FROM country)
EXCEPT
(SELECT id FROM invalid_country);

-- SELECT these's countries and their only 1 cabinet and its party
CREATE VIEW valid_country_party AS
SELECT cabinet_valid.country_id, cabinet_valid.id, cabinet_valid.party_id
FROM cabinet_valid
WHERE cabinet_valid.country_id IN (SELECT id FROM valid_country);

-- the answer to the query 
insert into q5 
SELECT country.name AS countryName,
        party.name AS partyName,
        party_family.family AS partyFamily,
        party_position.state_market AS stateMarket
FROM valid_country_party, country, party, party_family, party_position
WHERE valid_country_party.country_id = country.id AND
        valid_country_party.party_id = party.id AND
        valid_country_party.party_id = party_family.party_id AND
        valid_country_party.party_id = party_position.party_id;