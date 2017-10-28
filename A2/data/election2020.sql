INSERT INTO party VALUES
(10000, 29, 'Liberal', 'Liberal'),
(10001, 29, 'Green', 'Green'),
(10002, 29, 'Rhino', 'Rhinocerous'),
(10003, 29, 'NDP', 'NDP'),
(10004, 29, 'Con', 'Conservative');

INSERT INTO election VALUES
(20000, 29, '2020-01-01', null, 10000, 100000, null, null, null, null, null, 'Parliamentary election');

INSERT INTO election_result VALUES
(30000, 20000, 10000, null),
(30001, 20000, 10001, 30000),
(30002, 20000, 10002, 30000),
(30003, 20000, 10003, null),
(30004, 20000, 10004, 30003);
