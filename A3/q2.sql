--Create the final answer in which report the question by its question id with
--its first 50th character question text and the number of hints of that specific question
--Note in our schema, we store the hints of multiple choice question and numeric question
--in two views, that's why we use union in this question
SELECT question_bank.id, 
	left(question_bank.questionText, 50),
	hint_count.count
FROM 
	((SELECT questionId, COUNT(mhint) AS count
	FROM multi_hint
	GROUP BY questionId)
	UNION
	(SELECT questionId, COUNT(hint) AS count
	FROM numeric_hint
	GROUP BY questionId)) AS hint_count
RIGHT JOIN question_bank
ON hint_count.questionId = question_bank.id;
