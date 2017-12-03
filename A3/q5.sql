DROP TABLE IF EXISTS no_ans CASCADE;
CREATE TABLE no_ans AS
SELECT student_quiz_answer.questionId AS question_id,
	COUNT(*) AS count_no_ans
FROM student_quiz_answer, quiz, class
WHERE student_quiz_answer.quizId = quiz.id AND
	quiz.classId = class.id AND
	quiz.id = 'Pr1-220310' AND
	class.grade = 8 AND
	class.room = 120 AND
	class.teacher = 'Mr Higgins' AND
	student_quiz_answer.answer IS NULL
GROUP BY student_quiz_answer.questionId;

DROP TABLE IF EXISTS correct_ans CASCADE;
CREATE TABLE correct_ans AS
SELECT question_bank.id AS question_id,
	COUNT(*) AS count_correct_ans
FROM student_quiz_answer, quiz, class, quiz_question, question_bank
WHERE student_quiz_answer.quizId = quiz.id AND
	student_quiz_answer.questionId = question_bank.id AND
	quiz.classId = class.id AND
	quiz.Id = quiz_question.quizId AND
	quiz_question.questionId = question_bank.id AND
	quiz.id = 'Pr1-220310' AND
	class.grade = 8 AND
	class.room = 120 AND
	class.teacher = 'Mr Higgins' AND
	student_quiz_answer.answer = question_bank.correctAns
GROUP BY question_bank.id;

DROP TABLE IF EXISTS total_student_count CASCADE;
CREATE TABLE total_student_count AS
SELECT COUNT(*) AS student_count
FROM student_quiz_answer
WHERE quizId = 'Pr1-220310'
GROUP BY questionId
LIMIT 1;


SELECT no_ans.question_id AS question_id,
	correct_ans.count_correct_ans AS correct,
	no_ans.count_no_ans AS no_ans,
	(SELECT student_count FROM total_student_count) - 
		correct_ans.count_correct_ans - no_ans.count_no_ans AS incorrect
FROM no_ans, correct_ans
WHERE no_ans.question_id = correct_ans.question_id;