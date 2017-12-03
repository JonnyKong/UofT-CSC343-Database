\i schema.sql
INSERT INTO class VALUES(345, 1, 1, 'John');
INSERT INTO class VALUES(369, 1, 2, 'Smith');

INSERT INTO student Values(1004654288, 'Jonny', 'Kong');

INSERT INTO quiz VALUES('1', 'The first test quiz', 345, '1:30 pm, Oct 1, 2017', false);
INSERT INTO question_bank VALUES(1, 'What is your name?', 0, 777);
INSERT INTO quiz_question VALUES('1', 1, 0.5);

INSERT INTO student_quiz_answer