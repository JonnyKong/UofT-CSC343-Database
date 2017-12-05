--First create a view in which find the student id and last name of the students who have
--at least one correct answer in the quiz and calculate their total grade of the quiz
--by adding weight of the questions which they give correct answers
DROP TABLE IF EXISTS score CASCADE;
CREATE TABLE score AS
SELECT lpad(student.id::text, 10, '0') AS student_number,
	student.studentLastName AS last_name,
	SUM(quiz_question.questionWeight) AS total_grade
FROM student_quiz_answer,
	quiz,
	class_quiz,
	class,
	student,
	quiz_question,
	question_bank
WHERE student_quiz_answer.studentId = student.id AND
	student_quiz_answer.quizId = quiz.Id AND
	quiz.Id = class_quiz.quizId AND
	class.Id = class_quiz.classId AND
	quiz.Id = quiz_question.quizId AND
	quiz_question.questionId = question_bank.id AND
	student_quiz_answer.questionId = question_bank.id AND
	quiz.id = 'Pr1-220310' AND
	class.grade = 8 AND
	class.room = 120 AND
	class.teacher = 'Mr Higgins' AND
	student_quiz_answer.answer = question_bank.correctAns
GROUP BY student.id;

--Create a view in which find the student id of students who have no any correct answer
DROP TABLE IF EXISTS remaining_id CASCADE;
CREATE TABLE remaining_id AS
(SELECT DISTINCT studentId AS student_number
FROM student_quiz_answer)
EXCEPT
(SELECT DISTINCT student_number::bigint
FROM score);

--Create a view in which set the total grade of the students who have no any correct answer to zero
DROP TABLE IF EXISTS remaining_score CASCADE;
CREATE TABLE remaining_score AS
SELECT lpad(student.id::text, 10, '0') AS student_number,
	student.studentLastName AS last_name,
	0 AS total_grade
FROM remaining_id, student
WHERE remaining_id.student_number = student.id;

--Create the final answer in which combine the two views in which students have nonzero scores and in which students have zero scores
(SELECT * FROM score)
UNION
(SELECT * FROM remaining_score);
