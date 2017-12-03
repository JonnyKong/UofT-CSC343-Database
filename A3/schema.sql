-- Schema for storing running quizzes online

DROP SCHEMA IF EXISTS quizzes CASCADE;
CREATE SCHEMA quizzes;

SET SEARCH_PATH to quizzes;

CREATE TABLE class (
	id INT PRIMARY KEY,
	-- The grade of the class
	grade INT NOT NULL,
	-- Room of the class
	room INT NOT NULL,
	-- Teacher of this class
	teacher VARCHAR(64) NOT NULL
);

CREATE TABLE student (
	id BIGINT PRIMARY KEY,
	-- The first name of the student
	studentFirstName VARCHAR(32) NOT NULL,
	-- The last name of the student
	studentLastName VARCHAR(32) NOT NULL
);

CREATE TABLE enroll (
	studentId BIGINT REFERENCES student(id) NOT NULL,
	classId INT REFERENCES class(id) NOT NULL
);

CREATE TABLE quiz (
	id VARCHAR(32) PRIMARY KEY,
	title VARCHAR(128) NOT NULL,
	classId INT REFERENCES class(id),
	dueTime TIMESTAMP NOT NULL,
	hint BOOLEAN NOT NULL
);

CREATE TABLE question_bank (
	id INT PRIMARY KEY,
	questionText VARCHAR(256) NOT NULL,
	questionType INT NOT NULL,
	correctAns INT NOT NULL
);

CREATE TABLE quiz_question (
	quizId VARCHAR(32) REFERENCES quiz(id) NOT NULL,
	questionId INT REFERENCES question_bank(id) NOT NULL,
	questionWeight NUMERIC NOT NULL
);

CREATE TABLE student_quiz_answer (
	studentId BIGINT REFERENCES student(id) NOT NULL,
	quizId VARCHAR(32) REFERENCES quiz(id) NOT NULL,
	questionId INT REFERENCES question_bank(id) NOT NULL,
	answer INT
);

CREATE TABLE multi_hint (
	questionId INT REFERENCES question_bank(id) NOT NULL,
	choiceId INT NOT NULL,
	mText VARCHAR(128) NOT NULL,
	mHint VARCHAR(128),
	PRIMARY KEY(questionId, choiceId)
);

CREATE TABLE numeric_hint (
	questionId INT REFERENCES question_bank(id) NOT NULL,
	hint1 INT,
	hint2 INT,
	range1 INT NOT NULL,
	range2 INT NOT NULL,
	CHECK(range1 < range2),
	PRIMARY KEY(questionId, range1, range2)
);

-- Trigger to enforce a room have <=2 classes and same teacher
CREATE OR REPLACE FUNCTION classes_f()
	RETURNS trigger AS
$classes_t$
DECLARE
	classes_cnt integer := 0;
BEGIN
	SELECT COUNT(*) INTO classes_cnt FROM class WHERE room = NEW.room;
	IF classes_cnt < 2 THEN
		IF ((SELECT COUNT(teacher) FROM class WHERE room = New.room) = 0 OR (SELECT teacher FROM class WHERE room = New.room) = New.teacher) THEN
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'A room can never have more than one teacher';
			RETURN NULL;
		END IF;
	ELSE
		RAISE EXCEPTION 'A room cannot have more than two classes';
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$classes_t$
LANGUAGE plpgsql;
CREATE TRIGGER classes_t 
	BEFORE INSERT OR UPDATE ON class
	FOR EACH ROW EXECUTE PROCEDURE classes_f();

-- Trigger to enforce a student answers a quiz belonging to a class he enrolled in
CREATE OR REPLACE FUNCTION take_f()
	RETURNS trigger AS
$take_t$
BEGIN
	IF EXISTS(SELECT * FROM student, enroll, class, quiz 
		WHERE student.id = enroll.studentId AND enroll.classId = class.id AND class.id = quiz.classId
		AND student.id = New.studentId AND quiz.Id = New.quizId) 
	AND EXISTS(SELECT * FROM quiz_question 
		WHERE New.quizId = quiz_question.quizId AND New.questionId = quiz_question.questionId) THEN
		RETURN NEW;
	ELSIF NOT EXISTS(SELECT * FROM quiz_question 
		WHERE New.quizId = quiz_question.quizId AND New.questionId = quiz_question.questionId) THEN
		RAISE EXCEPTION 'Question not belonging to this quiz';
		RETURN NULL;
	ELSE
		RAISE EXCEPTION 'Cannot answer quizzes in course not enrolled';
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$take_t$
LANGUAGE plpgsql;
CREATE TRIGGER take_t
	BEFORE INSERT OR UPDATE ON student_quiz_answer
	FOR EACH ROW EXECUTE PROCEDURE take_f();
