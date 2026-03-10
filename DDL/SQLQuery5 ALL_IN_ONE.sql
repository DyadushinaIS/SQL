USE master;

CREATE DATABASE PV_522_ALL_IN_ONE
ON
(
	NAME = PV_522_ALL_IN_ONE,
	FILENAME = "D:\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_522_ALL_IN_ONE.mdf",
	SIZE = 8 MB,
	MAXSIZE = 500MB,
	FILEGROWTH = 8MB
)
LOG ON
(
	NAME = PV_522_ALL_IN_ONE_Log,
	FILENAME = "D:\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_522_ALL_IN_ONE.ldf",
	SIZE = 8 MB,
	MAXSIZE = 500MB,
	FILEGROWTH = 8MB
);
GO

USE PV_522_ALL_IN_ONE;

CREATE TABLE Directions
(
	direction_id	SMALLINT	PRIMARY KEY,
	direction_name	NVARCHAR(50)NOT NULL
);

CREATE TABLE Groups
(
	group_id		INT			PRIMARY KEY,
	group_name		NVARCHAR(24)NOT NULL,
	start_date		DATE		NOT NULL,
	start_time		TIME		NOT NULL,
	learning_days	INT			NOT NULL,
	direction		SMALLINT	NOT NULL
	CONSTRAINT	FK_Groups_Directions	FOREIGN KEY REFERENCES Directions(direction_id)
);

CREATE TABLE Students
(
	student_id	INT			PRIMARY KEY,
	last_name	NVARCHAR(50)NOT NULL,
	first_name	NVARCHAR(50)NOT NULL,
	middle_name	NVARCHAR(50)	NULL,
	birth_date	DATE		NOT NULL,
	[group]		INT			NOT NULL
	CONSTRAINT	FK_Students_Groups	FOREIGN KEY REFERENCES	Groups(group_id)
);
CREATE TABLE Teachers
(
	teacher_id	INT			PRIMARY KEY,
	last_name	NVARCHAR(50)NOT NULL,
	first_name	NVARCHAR(50)NOT NULL,
	middle_name	NVARCHAR(50)	NULL,
	birth_date	DATE		NOT NULL,
	rate		MONEY		NOT NULL	DEFAULT 50
);

CREATE TABLE Disciplines
(
discipline_id		SMALLINT	PRIMARY KEY,
discipline_name		NVARCHAR(150)	NOT NULL,
number_of_lessons	TINYINT		NOT NULL
);

CREATE TABLE TeachersDisciplineRelations
(
teacher INT,
discipline SMALLINT,
PRIMARY KEY (teacher, discipline),
CONSTRAINT FK_TDR_Teachers	FOREIGN KEY (teacher) REFERENCES Teachers(teacher_id),
CONSTRAINT FK_TDR_Discipline	FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id)
);

CREATE TABLE DisciplinesDirectionRelations
(
discipline SMALLINT,
direction SMALLINT,
PRIMARY KEY (discipline, direction),
CONSTRAINT FK_DDR_Discipline	FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id),
CONSTRAINT FK_DDR_Direction	FOREIGN KEY (direction) REFERENCES Directions(direction_id)
);

CREATE TABLE Schedule
(
lesson_id		BIGINT	PRIMARY KEY,
[group]			INT
CONSTRAINT 		FK_Schedule_Groups FOREIGN KEY REFERENCES Groups(group_id),
discipline 		SMALLINT,
date			DATE,
time			TIME(0),
teacher 		INT,
subject			NVARCHAR(256),
spent			BIT
);

CREATE TABLE Grades
(
student			INT
CONSTRAINT 		FK_Grades_Students FOREIGN KEY REFERENCES Students(student_id),
lesson			BIGINT
CONSTRAINT 		FK_Grades_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
PRIMARY KEY 		(student, lesson),
grade_1			INT,
grade_2			INT
);

CREATE TABLE Homeworks
(
lesson			BIGINT
CONSTRAINT 		FK_Homeworks_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
[group]			INT,
PRIMARY KEY 		(lesson, [group]),
data			VARBINARY(2000) NOT NULL,
description		VARCHAR(255),
deadline		DATE,
[column]		SMALLINT
);

CREATE TABLE HWResults
(
lesson			BIGINT,
[group]			INT,
student			INT
CONSTRAINT FK_HWResults_Students	FOREIGN KEY REFERENCES Students(student_id),
PRIMARY KEY 		(lesson, [group], student),
CONSTRAINT FK_HWResults_Homeworks
FOREIGN KEY (lesson, [group])  REFERENCES Homeworks(lesson, [group]),
description		VARCHAR(255),
data			VARBINARY(2000) NOT NULL,
grade			INT,
comment			NVARCHAR(255)
);

CREATE TABLE Exams
(
teacher 		INT NOT NULL,
student 		INT,
discipline 		SMALLINT,
PRIMARY KEY 		(student, discipline),
CONSTRAINT FK_Exams_Disciplines	FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id),
CONSTRAINT FK_Exams_Students	FOREIGN KEY (student) REFERENCES Students(student_id),
grade			INT,
[column]		INT
);
