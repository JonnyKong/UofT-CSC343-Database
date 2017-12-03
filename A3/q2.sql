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
