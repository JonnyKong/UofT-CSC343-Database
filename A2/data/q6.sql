-- Sequences

SET SEARCH_PATH TO parlgov;
drop table if exists q6 cascade;

-- You must not change this table definition.

CREATE TABLE q6(
        countryName VARCHAR(50),
        cabinetId INT, 
        startDate DATE,
        endDate DATE,
        pmParty VARCHAR(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Create a table as cabinet but with end date of each cabinet. For the most recent cabinet, set NULL for the endDate.
CREATE VIEW with_end_time AS
SELECT c1.id AS cabinet_id, c1.country_id, c1.start_date, c2.start_date AS endDate 
FROM cabinet c1 LEFT JOIN cabinet c2 ON c1.id = c2.previous_cabinet_id;

-- Create a table as with_end_time with the party id of the primary minister party of each cabinet except those without prime minister.
CREATE VIEW with_party_prime_minister_not_null AS
SELECT w.country_id, w.cabinet_id, w.start_date, w.endDate, c.party_id
FROM with_end_time w LEFT JOIN cabinet_party c ON w.cabinet_id = c.cabinet_id WHERE c.pm ;

-- Create a table as with_party_prime_minister_not_null with the party name of 
--the primary minister party of each cabinet except those without prime minister.
CREATE VIEW with_party_name_not_null AS
SELECT w.country_id, w.cabinet_id, w.start_date, w.endDate, p.name
FROM with_party_prime_minister_not_null w LEFT JOIN party p ON w.party_id = p.id ;

-- Create a table as with_end_time with the party name of the primary minister party of each cabinet.For those without pm, set NULL.
CREATE VIEW with_party_prime_minister AS
SELECT w1.country_id, w1.cabinet_id, w1.start_date, w1.endDate, w2.name
FROM with_end_time w1 LEFT JOIN with_party_name_not_null w2 ON w1.cabinet_id = w2.cabinet_id ;

-- the answer to the query 
-- Create a table as with_party_prime_minister but from country id to country name
insert into q6 

SELECT c.name AS countryName, w.cabinet_id AS cabinetId, w.start_date AS startDate, w.endDate, w.name AS pmParty
FROM with_party_prime_minister w JOIN country c ON w.country_id = c.id ;
