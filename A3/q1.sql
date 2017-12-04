--Create the final answer in which report all the student's fullname
--in the database with their student id
SELECT (studentFirstName || ' ' || studentLastName) AS fullname, 
	lpad(id::text, 10, '0') AS student_number
FROM student;
