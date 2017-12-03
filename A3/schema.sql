-- Schema for storing running quizzes online

DROP SCHEMA IF EXISTS quizzes CASCADE;
CREATE SCHEMA quizzes;

CREATE TABLE classes (
	id INT PRIMARY KEY,
	-- The grade of the class
	grade INT NOT NULL,
	-- Room of the class
	room INT NOT NULL,
	-- Teacher of this class
	teacher VARCHAR(64)
)

CREATE OR REPLACE FUNCTION classes_f()
	RETURNS trigger AS
$$
BEGIN
	IF (SELECT COUNT(*) FROM classes WHERE room = NEW.room) < 2 THEN
		IF (SELECT COUNT(teacher) FROM classes WHERE room = New.room) = 0 OR
		(SELECT teacher FROM classes WHERE room = New.room) = New.teacher THEN
			INSERT INTO classes VALUES(NEW.id, NEW.grade, NEW.room, NEW.teacher)
		ELSE
			RAISE ERROR 'A room can never have more than one teacher'
		ENDIF
	ELSE
		RAISE ERROR 'A room cannot have more than two classes'
	ENDIF
END
$$
LANGUAGE 'plpgsql'

-- Trigger to enforce a room have <=2 classes and same teacher
CREATE TRIGGER classes_t 
	INSTEAD OF INSERT OR UPDATE
	ON classes
	FOR EACH ROW
	EXECUTE PROCEDURE classes_f();
	