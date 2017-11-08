SELECT election.id, cabinet.name, election.e_date
FROM election, country, cabinet
WHERE election.country_id = country.id AND
	election.id = cabinet.election_id AND
	country.name = 'Canada'
ORDER BY election.e_date DESC;


SELECT id, description
FROM politician_president;