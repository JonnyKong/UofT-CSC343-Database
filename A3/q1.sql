SELECT (studentFirstName || ' ' || studentLastName) AS fullname, 
	lpad(id::text, 10, '0') AS student_number
FROM student;