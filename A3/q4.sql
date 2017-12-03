SELECT student_quiz_answer.studentId AS student_number,
	student_quiz_answer.questionId AS question_id,
	left(question_bank.questionText, 50) AS question_text
FROM student_quiz_answer, question_bank, class, quiz
WHERE student_quiz_answer.questionId = question_bank.id AND
	student_quiz_answer.quizId = quiz.id AND
	quiz.classId = class.id AND
	student_quiz_answer.answer IS NULL AND
	quiz.id = 'Pr1-220310' AND
	class.grade = 8 AND
	class.room = 120 AND
	class.teacher = 'Mr Higgins';