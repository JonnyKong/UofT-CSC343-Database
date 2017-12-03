SELECT *
FROM student_quiz_answer, question_bank
WHERE student_quiz_answer.answer = question_bank.correctAns AND
	student_quiz_answer.questionId = question_bank.id;