INSERT INTO quizzes.question_bank VALUES
(782,'What do you promise when you take the oath of citizenship?', 2, 1),
(566,'The Prime Minister, Justin Trudeau, is Canada''s Head of State.', 1, 2),
(601,'During the "Quiet Revolution," Quebec experienced rapid change. In what decade did this occur? 
      (Enter the year that began the decade, e.g., 1840.)', 3, 1960),
(625,'What is the Underground Railroad?', 2, 4),
(790,'During the War of 1812 the Americans burned down the Parliament Buildings in
      York (now Toronto). What did the British and Canadians do in return?', 2, 3);

INSERT INTO quizzes.multi_hint VALUES
(782,1, 'To pledge your loyalty to the Sovereign, Queen Elizabeth II', NULL),
(782,2, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian', NULL),
(782,3, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian', 'Think regally.'),
(782,4, 'To pledge your loyalty to Canada from sea to sea', NULL),
(625,1, 'The first railway to cross Canada', 'The Underground Railroad was generally south to gggg, not east-west.'),
(625,2, 'The CPR''s secret railway line', 'The Underground Railroad was secret, but it had nothing to do with trains.'),
(625,3, 'The TTC subway system', 'The TTC is relatively recent; the Underground Railroad was in operation over 100 years ago.'),
(625,4, 'A network used by slaves who escaped the United States into Canada', NULL),
(790,1, 'They attacked American merchant ships', NULL),
(790,2, 'They expanded their defence system, including Fort York', NULL),
(790,3, 'They burned down the White House in Washington D.C.', NULL),
(790,4, 'They captured Niagara Falls', NULL);

  
INSERT INTO quizzes.numeric_hint VALUES
(601,1800,1900,'The Quiet Revolution happened during the 20th Century.'),
(601,2000,2010,'The Quiet Revolution happened some time ago.'),
(601,2020,3000,'The Quiet Revolution has already happened!');


INSERT INTO quizzes.class VALUES
(1,8,120,'Mr Higgins'),
(2,5,366,'Miss Nyers');


INSERT INTO quizzes.quiz VALUES
('Pr1-220310','Citizenship Test Practise Questions', 1, '2017-10-01 13:30:00',TRUE);


INSERT INTO quizzes.quiz_question VALUES
('Pr1-220310',601, 2),
('Pr1-220310',566, 1),
('Pr1-220310',790, 3),
('Pr1-220310',625, 2);


INSERT INTO quizzes.student VALUES
(0998801234,'Lena','Headey'),
(0010784522,'Peter','Dinklage'),
(0997733991,'Emilia','Clarke'),
(5555555555,'Kit','Harrington'),
(1111111111,'Sophie','Turner'),
(2222222222,'Maisie','Williams');


INSERT INTO quizzes.enroll VALUES
(0998801234,1),
(0010784522,1),
(0997733991,1),
(5555555555,1),
(1111111111,1),
(2222222222,2);


INSERT INTO quizzes.student_quiz_answer VALUES
(0998801234,'Pr1-220310',601,1950),
(0998801234,'Pr1-220310',566,2),
(0998801234,'Pr1-220310',790,2),
(0998801234,'Pr1-220310',625,4),
(0010784522,'Pr1-220310',601,1960),
(0010784522,'Pr1-220310',566,2),
(0010784522,'Pr1-220310',790,3),
(0010784522,'Pr1-220310',625,4),
(0997733991,'Pr1-220310',601,1960),
(0997733991,'Pr1-220310',566,1),
(0997733991,'Pr1-220310',790,3),
(0997733991,'Pr1-220310',625,2),
(5555555555,'Pr1-220310',601,NULL),
(5555555555,'Pr1-220310',566,2),
(5555555555,'Pr1-220310',790,4),
(5555555555,'Pr1-220310',625,NULL),
(1111111111,'Pr1-220310',601,NULL),
(1111111111,'Pr1-220310',566,NULL),
(1111111111,'Pr1-220310',790,NULL),
(1111111111,'Pr1-220310',625,NULL);

