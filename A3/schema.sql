-- Schema for storing running quizzes online

DROP SCHEMA IF EXISTS quizzes CASCADE;
CREATE SCHEMA quizzes;

SET SEARCH_PATH to quizzes;

-- Each class have an unique id
CREATE TABLE class (
	id INT PRIMARY KEY,
	-- The grade of the class
	grade INT NOT NULL,
	-- Room of the class
	room INT NOT NULL,
	-- A class can only have one teacher
	teacher VARCHAR(64) NOT NULL
);

-- Each student have a unique student number
CREATE TABLE student (
	id BIGINT PRIMARY KEY,
	-- The first name of the student
	studentFirstName VARCHAR(32) NOT NULL,
	-- The last name of the student
	studentLastName VARCHAR(32) NOT NULL
);

-- Student enroll in course
CREATE TABLE enroll (
	studentId BIGINT REFERENCES student(id) NOT NULL,
	classId INT REFERENCES class(id) NOT NULL
);

-- Each quiz have a unique id
CREATE TABLE quiz (
	id VARCHAR(32) PRIMARY KEY,
	-- The title of the quiz
	title VARCHAR(128) NOT NULL,
	-- -- The class this quiz belongs to
	-- classId INT REFERENCES class(id),
	-- The due time of this quiz
	dueTime TIMESTAMP NOT NULL,
	-- Whether hint is enabled for this quiz
	hint BOOLEAN NOT NULL
);

-- A class can have many quizzes. A quiz can be in many classes
CREATE TABLE class_quiz (
	quizId VARCHAR(32) REFERENCES quiz(id) NOT NULL,
	classId INT REFERENCES class(id) NOT NULL
);

-- All questions are stored in a question bank
CREATE TABLE question_bank (
	id INT PRIMARY KEY,
	-- Text of question
	questionText VARCHAR(256) NOT NULL,
	-- Type of question
	questionType INT NOT NULL,
	-- Correct answer of this question in Integer
	correctAns INT NOT NULL
);

-- Relation of questions assigned to quizzes
CREATE TABLE quiz_question (
	-- Create Id for each entry of this relation as primary key
	quizId VARCHAR(32) REFERENCES quiz(id) NOT NULL,
	-- IDs of questions and quizzes
	questionId INT REFERENCES question_bank(id) NOT NULL,
	questionWeight NUMERIC NOT NULL
);

-- A triple relation of a student answer a quiz belonging to a question
CREATE TABLE student_quiz_answer (
	-- IDs of student, quiz and question
	studentId BIGINT REFERENCES student(id) NOT NULL,
	quizId VARCHAR(32) REFERENCES quiz(id) NOT NULL,
	questionId INT REFERENCES question_bank(id) NOT NULL,
	-- Student's answer to this question
	answer INT
);

-- Answer and hint for multiple choice questions
CREATE TABLE multi_hint (
	-- Id if this question
	questionId INT REFERENCES question_bank(id) NOT NULL,
	-- The choice id for this particular question
	choiceId INT NOT NULL,
	-- Text for this choice
	mText VARCHAR(128) NOT NULL,
	-- Hint for this choice (could be null)
	mHint VARCHAR(128),
	-- Question and choice combined makes primary key
	PRIMARY KEY(questionId, choiceId)
);
-- Range and hint for numeric questions
CREATE TABLE numeric_hint (
	-- Question ID this answer range/hint corresponds to
	questionId INT REFERENCES question_bank(id) NOT NULL,
	-- Lower and upper ranges
	range1 INT NOT NULL,
	range2 INT NOT NULL,
	-- Hint text for this range
	hint VARCHAR(128) NOT NULL,
	-- Enforce that range1 is lower range, range2 is higher range
	CHECK(range1 < range2),
	-- Question Id and range combined makes primary key
	PRIMARY KEY(questionId, range1, range2)
);

-- Trigger to enforce a room have <=2 classes and same teacher
CREATE OR REPLACE FUNCTION classes_f()
	RETURNS trigger AS
$classes_t$
DECLARE
	-- Stores the classes already taught in this room
	classes_cnt integer := 0;
BEGIN
	-- Count existing classes in this room
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
	-- Check before a new class in inserted
	BEFORE INSERT OR UPDATE ON class
	FOR EACH ROW EXECUTE PROCEDURE classes_f();


-- Trigger to enforce a student answers a quiz belonging to a class he enrolled in
CREATE OR REPLACE FUNCTION take_f()
	RETURNS trigger AS
$take_t$
BEGIN
	-- If question student answered belongs to course he enrolled in 
	IF EXISTS(SELECT * FROM student, enroll, class, quiz, class_quiz 
		WHERE student.id = enroll.studentId AND enroll.classId = class.id AND
		class.id = class_quiz.classId AND quiz.id = class_quiz.quizId AND
		student.id = New.studentId AND quiz.Id = New.quizId) 
	-- If this question belongs to this quiz
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
	-- Check for this constraint upon a student answers a question
	BEFORE INSERT OR UPDATE ON student_quiz_answer
	FOR EACH ROW EXECUTE PROCEDURE take_f();
