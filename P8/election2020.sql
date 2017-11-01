INSERT INTO election VALUES
(20000, 29, '2020-01-01', null, 10000, 100000, null, null, null, null, null, 'Parliamentary election');

INSERT INTO election_result VALUES
(30000, 20000, (SELECT id FROM party WHERE name = 'Liberal Party of Canada'), null),
(30001, 20000, (SELECT id FROM party WHERE name = 'Green Party of Canada'), 30000),
(30002, 20000, (SELECT id FROM party WHERE name = 'Rhinoceros Party'), 30000),
(30003, 20000, (SELECT id FROM party WHERE name = 'National Democratic and Labour Party '), null),
(30004, 20000, (SELECT id FROM party WHERE name = 'Conservative Party of Canada'), 30003);
