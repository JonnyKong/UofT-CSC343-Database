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

-- Create a table which includes end date of each cabinet(if it is not the most recent)
CREATE VIEW end_time AS
SELECT c1.id AS cabinet_id,  c2.start_date AS endDate
FROM cabinet c1 JOIN cabinet c2 ON c1.id=c2. previous_cabinet_id;

-- Create a table as cabinet but with end date of each cabinet. For the most recent cabinet, set NULL for the endDate.
CREATE VIEW with_end_time AS
SELECT * FROM cabinet NATURAL FULL JOIN end_time ;

-- Create a table as with_end_time with the party id of the primary minister party of each cabinet
CREATE VIEW with_party_prime_minister AS
SELECT w.country_id, w.id AS cabinetId, w.start_date AS startDate, w.endDate, c.party_id
FROM with_end_time w JOIN cabinet_party c ON w.cabinet_id = c.cabinet_id WHERE c.pm ;

-- Create a table as with_party_prime_minister but from country id to country name
CREATE VIEW with_country_name AS
SELECT c.name AS countryName, w.cabinetId, w.startDate, w.endDate, w.party_id
FROM with_party_prime_minister w JOIN country c ON w.country_id = c.id ;

-- the answer to the query 
-- As woth_country_name but from party id to party name
insert into q6 

SELECT w.countryName, w.cabinetId, w.startDate, w.endDate, w.party_id, p.name AS pmParty
FROM with_country_name w, party p ON w.party_id = p.id ;
