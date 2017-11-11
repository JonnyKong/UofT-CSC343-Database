-- Left-right

SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
        countryName VARCHAR(50),
        r0_2 INT,
        r2_4 INT,
        r4_6 INT,
        r6_8 INT,
        r8_10 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Fond the number of party in the range [0,2),[2,4),[4,6),[6,8),[8,10) separately for each country
CREATE number_in_0_2 AS 
SELECT count(*)AS r0_2, party.country_id
FROM party,party_position ON party.id = party_position.party_id
WHERE party_position.left_right < 2
GROUP BY party.country_id ;

CREATE number_in_2_4 AS 
SELECT count(*)AS r2_4, party.country_id
FROM party,party_position ON party.id = party_position.party_id
WHERE 2 < party_position.left_right < 4
GROUP BY party.country_id ;

CREATE number_in_4_6 AS 
SELECT count(*)AS r4_6, party.country_id
FROM party,party_position ON party.id = party_position.party_id
WHERE 4 < party_position.left_right < 6
GROUP BY party.country_id ;

CREATE number_in_6_8 AS 
SELECT count(*)AS r6_8, party.country_id
FROM party,party_position ON party.id = party_position.party_id
WHERE 4 < party_position.left_right < 6
GROUP BY party.country_id ;

CREATE number_in_8_10 AS 
SELECT count(*)AS r8_10, party.country_id
FROM party,party_position ON party.id = party_position.party_id
WHERE 8 < party_position.left_right < 10
GROUP BY party.country_id ;


-- the answer to the query 
INSERT INTO q4 

SELECT name,r0_2,r2_4,r4_6, r6_8,r8_10
FROM country NATURAL JOIN number_in_0_2 NATURAL JOIN number_in_2_4 NATURAL JOIN number_in_4_6 NATURAL JOIN number_in_6_8 NATURAL JOIN number_in_8_10 ;
