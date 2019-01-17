--done: Question, Course, Student, Topic, StudentCourse, Department, StudentAnswers, Exam, ExamQuestions, Instructor, InstructorCourses

create database EXAMDB5
go

use EXAMDB5

create table Department
(
	[ID] [int] primary key NOT NULL identity,
	[Name] [nvarchar](50),
	[Description] [nvarchar](100),
	[Location] [nvarchar](50)
)

create table Instructor
(
	ID int primary key not null identity,
	Name nvarchar(50),
	Degree nvarchar(50),
	Salary money,
	Department int not null references Department(ID) 
)


create table Course
(
	ID int primary key not null identity,
	Name nvarchar(20),
	Duration int
)

create table Topic
(
	ID int not null identity,
	Name nvarchar(20),
	Course int not null references Course(ID) on delete cascade,
	primary key(ID, Course)
)

create table Student
(
	ID int primary key not null identity,
	FirstName nvarchar(20),
	LastName nvarchar(20),
	Address nvarchar(50),
	Department int not null references Department(ID)
)

create table Question
(
	ID int not null identity,
	Type nvarchar(20) check (Type in ('TrueOrFalse', 'MCQ')),
	Body nvarchar(max),
	ModelAnswer nchar(1) check (ModelAnswer in('T', 'F', 'A', 'B', 'C', 'D')),
	Grade int not null,
	Course int not null references Course(ID),
	primary key(ID)
)

create table Exam
(
	ID int not null primary key identity
)

create table InstructorCourses
(
	Instructor int references Instructor(ID),
	Course int references Course(ID),
	primary key(Instructor, Course)
)

create table ExamQuestions
(
	Exam int not null references Exam(ID),
	Question int not null references Question(ID),
	primary key(Exam, Question)
)

create table StudentAnswers
(
	Student int not null references Student(ID),
	Exam int not null references Exam(ID),
	Question int not null references Question(ID),
	Answer nchar(1) check (Answer in('T', 'F', 'A', 'B', 'C', 'D', 'E')),
	primary key(Student, Exam, Question)
)

create table StudentCourses
(
	Student int not null references Student(ID),
	Course int not null references Course(ID),
	Grade int,
	primary key(Student, Course)
)
go




-----Student table procedures
create procedure SelectStudent @ID int
as
select * from Student where @ID = ID
go

create procedure InsertStudent @FName nvarchar(20), @LName nvarchar(20), @Address nvarchar(50), @Department int
as
insert into Student values (@FName, @LName, @Address, @Department) 
go

create procedure UpdateStudent @ID int, @ColumnName varchar(20), @Value nvarchar(50)
as
execute('update student set ' + @ColumnName + ' = ''' + @Value + ''' where ID = ' + @ID)
go

create procedure DeleteStudent @ID int
as
delete from Student where ID = @ID
go



------------
-- Course table Procedures

--1)
CREATE PROCEDURE UpdateCourse  @ID INT , @CurseName nvarchar(50)

  AS
  if not exists ( select ID from Course where ID= @ID)
  print 'error'	
  else
   BEGIN
     UPDATE Course 
     SET Name =@CurseName
     WHERE ID = @ID
    END
	go
--2)
CREATE PROCEDURE DeleteCourse @ID INT
  AS
   if not exists ( select ID from Course where ID= @ID)
  print 'error'	
  ELSE 
	BEGIN
	   DELETE FROM Course WHERE ID = @ID 
	END
	GO

	
--3)
CREATE PROCEDURE InsertCourse  @Crs_Name nvarchar(50) , @Crs_Duration int  
AS
	BEGIN
			insert into Course 
			values ( @Crs_Name , @Crs_Duration)
	END 
	go

--4)
CREATE PROCEDURE SelectCourse @id int
AS
if not exists ( select ID from Course where ID= @id)
  print 'error'	
  ELSE

  BEGIN
	SELECT * FROM Course WHERE ID = @id

  END
  go



  











------------------------------------------------------------------------------------------------
--Question table Procedures
--1)
CREATE PROCEDURE UpdateQuestion  @ID INT  , @body varchar(200) 
  AS
  if not exists ( select ID from Question where ID= @ID)
  print 'error'	
  ELSE 
    BEGIN
     UPDATE Question 
     SET Body = @body
     WHERE ID = @ID
    END
	go

--2)
CREATE PROCEDURE DeleteQuestion @ID INT
  AS
   if not exists ( select ID from Question where ID= @ID)
  print 'error'	
  ELSE
	BEGIN
	   DELETE FROM Question WHERE ID = @ID 
	END
	go

--3)

CREATE PROCEDURE InsertQuestion   @type varchar(20), @body varchar(200), @modelanswer nchar(1) , @grade int  , @course int 
AS
	BEGIN
			insert into Question 
			values ( @type , @body  , @modelanswer  , @grade  , @course)
END
go

--4)

CREATE PROCEDURE SelectQuestion @id int
AS
 if not exists ( select ID from Question where ID= @id)
  print 'error'	
  ELSE
  BEGIN
	SELECT * FROM Question WHERE ID = @id

  END
  go













----------------------------------------------------------

--Topic  table Procedures

--1)
CREATE PROCEDURE UpdateTopic  @ID INT  , @Name  nvarchar(20) 
  AS
   if not exists ( select ID from Topic where ID= @id)
  print 'error'	
  ELSE
    BEGIN

     UPDATE Topic 
     SET Name = @Name
     WHERE ID = @ID
    END
	go

--2)
CREATE PROCEDURE DeleteTopic @ID INT
  AS
   if not exists ( select ID from Topic where ID= @ID)
  print 'error'	
  ELSE
	BEGIN
	   DELETE FROM Topic WHERE ID = @ID 
	END
	go

--3)

CREATE PROCEDURE InsertTopic   @name nvarchar(20) , @course int  
AS
	BEGIN
			insert into Topic 
			values (   @name , @course)
END
go

--4)

CREATE PROCEDURE SelectTopic  @id int
AS
 if not exists ( select ID from Topic where ID= @id)
  print 'error'	
  ELSE
  BEGIN
	SELECT * FROM Topic WHERE ID = @id

 END
 go
---------------------------------------------------------
--StudentCourse  table Procedures
--1)
CREATE PROCEDURE UpdateSudentCourse  @Student INT , @Course int , @Grade  int
  AS
  if not exists ( select Grade from StudentCourses WHERE Student = @Student and Course = @Course)
  print 'error'	
  ELSE
    BEGIN
     UPDATE StudentCourses 
     SET Grade = @Grade
     WHERE Student = @Student and Course = @Course
    END
	go

--2)
CREATE PROCEDURE DeleteStudentCourses  @Student INT , @course int
  AS
  if not exists ( select Grade from StudentCourses WHERE Student = @Student and Course = @Course)
  print 'error'	
  ELSE
	BEGIN
	   DELETE FROM StudentCourses WHERE Student = @Student and Course = @course
	END
	go

--3)

CREATE PROCEDURE InsertStudentCourses  @Student int  , @Course int , @Grade int
AS
	BEGIN
			insert into StudentCourses 
			values (   @Student , @Course , @Grade)
END
go

--4)

CREATE PROCEDURE SelectStudentCourses  @Student int , @Course int 
AS
if not exists ( select Grade from StudentCourses WHERE Student = @Student and Course = @Course)
  print 'error'	
  ELSE
  BEGIN
	SELECT * FROM StudentCourses WHERE Student = @Student and  Course = @Course

  END
  go


----------------------------------------------------
--Department Table Procedures
--1)

create procedure SelectDepartment(@id int)
as
begin

select Name,Description,Location
from Department
where ID=@id

end
go

--2)

create procedure InsertDepartment(@name nvarchar(50),@description nvarchar(100),@location nvarchar(50))
as
begin

insert into Department values(@name,@description,@location)

end
go

--3)

create procedure UpdateDepartment (@id int ,@name nvarchar(50),@description nvarchar(100),@location nvarchar(50))
as
begin
if not exists(select * from Department where ID=@id)
print 'can not update'
else
update Department set Description=@description,Location=@location,Name=@name
where ID=@id
end
go

--4)

create procedure DeleteDepartment (@department int)
as
begin
if exists(select * from student where Department=@department)  or  exists(select * from Instructor where Department=@department)
print 'can not delete'
else 
delete from Department where ID=@department
end

go

-------------------------------------
--StudentAnswer Procedure
--1)

create procedure SelectStudentAnswer (@student int , @question int , @exam int)
as
begin
select Answer from StudentAnswers where Student=@student and Question=@question and Exam=@exam
end
go


--2)
create procedure InsertStudentAnswer (@student int , @question int , @exam int,@answer nchar(1))
as begin

if exists(select * from Student where ID=@student) and 
exists (select * from Question where ID=@question) and
exists (select * from Exam where ID=@exam)
insert into StudentAnswers values(@student,@exam,@question,@answer)
else 
print 'can not insert'

end
go

--3)
create procedure UpdateStudentAnswer (@student int , @question int , @exam int,@answer nchar(1))
as
begin

update StudentAnswers set Answer=@answer where Student=@student and Question=@question and Answer=@answer

end
go

--4)
create procedure DeleteStudentAnswer (@student int , @question int , @exam int)
as
begin
delete from StudentAnswers where Student=@student and Question=@question and Exam=@exam
end
go
-----------













--------------
----Exam

create procedure SelectExam @ID int
as 
select * from Exam where ID = @ID
go

create procedure DeleteExam @ID int
as
begin
delete from StudentAnswers where Exam=@ID
delete from ExamQuestions where Exam=@ID
delete from exam where ID = @ID
end
go

create procedure UpdateExam @ID int 
as select 'Can''t update Exam'
go

create procedure InsertExam
as
insert into Exam default values
go
---------------



















------------
----ExamQuestions
create procedure SelectExamQuestion @ExamID int
as
select * from ExamQuestions where Exam = @ExamID
go

create procedure UpdateExamQuestion @ExamID int, @QuestionID int
as
update ExamQuestions set Question = @QuestionID where Exam = @ExamID
go

create procedure DeleteExamQuestion @ExamID int, @QuestionID int
as
delete from ExamQuestions where Exam = @ExamID and Question = @QuestionID
go

create procedure InsertExamQuestion @ExamID int, @QuestionID int
as
insert into ExamQuestions values (@ExamID, @QuestionID)
go














---------------------------------------------------------------------------
--Instructor TABLE

GO
CREATE PROC InsertInstructor (@insnam nvarchar(50), @deg int, @sal money, @dept int)
AS
	INSERT INTO Instructor( Name, Degree, Salary, Department ) 
	VALUES (@insnam, @deg, @sal, @dept)
	

GO
CREATE PROC SelectInstructor
AS
	SELECT *
	FROM Instructor



GO
CREATE PROC DeleteInstructor (@insid int)
AS
	IF @insid in (select ID from Instructor)
	begin
		DELETE FROM Instructor
		WHERE ID = @insid
	end


GO
CREATE PROC UpdateInstructor (@insid int, @colNam varchar(20), @val varchar(20))
AS
	IF @insid in (select ID from Instructor)
	begin
		
			if @colNam = 'Name'
				 update  Instructor set Name = @val where ID = @insid
			else if @colNam = 'Degree'
				 update  Instructor set Degree = @val where ID = @insid
			else if @colNam = 'salary'
				 update  Instructor set Salary = CONVERT(money, @val) where ID = @insid
				
		End
	



















---------------------------------------------------------------------------
--InstructorCourses TABLE

GO
CREATE PROC InsertInstructorCourses (@insid int, @crs int)
AS
	IF (@insid in (select ID from Instructor)) and (@crs in (select ID from Course))
	begin
		INSERT INTO InstructorCourses
		VALUES (@insid, @crs)
	end
	
	

GO
CREATE PROC SelectInstructorCourses
AS
	SELECT *
	FROM InstructorCourses


GO
CREATE PROC DeleteInstructorCourses (@insid int, @crs int)
AS
	DELETE FROM InstructorCourses
	WHERE Instructor = @insid and Course = @crs


GO
CREATE PROC UpdateInstructorCourses (@insid int, @colNam varchar(20), @val varchar(20))
AS
	IF @insid in (select Instructor from InstructorCourses) and (@val in (select ID from Course))
	begin
		EXECUTE ('Update InstructorCourses Set ' + @colNam + ' = ' + @val + ' Where ID = ' + @insid)
	end

	go




















--------------------------------------------------------------
--ahmed adel
	--•	Report that returns the students information according to Department No parameter.

create proc StudentInformation @X INT 
as
select Student.ID , FirstName ,LastName , Address , Department
from Student inner join Department 
on Department.ID = Student.ID 
where Department.ID = @X 

go


go
--	Report that takes the student ID and returns the grades of the student in all courses.

create proc StudentGrades @ID int
as
select Name , Grade 
from StudentCourses inner join Course
on Course.ID = StudentCourses.Course
where Student = @ID 
go

go
--•	Report that takes the instructor ID and returns the name of the courses that he teaches
--  and the number of student per course.
go
create proc GetInstructorCourses @ID INT
as 
select Name , COUNT(Student)
from Course inner join InstructorCourses
on InstructorCourses.Course = Course.ID inner join StudentCourses
on StudentCourses.Course=Course.ID
where InstructorCourses.Instructor =@ID
group by Name
go

go

-- Report that takes course ID and returns its topics   
create proc CourseTopics @ID INT
as 
select Topic.Name
from Topic inner join Course
on Course.ID = Topic.Course 
where Course.ID = @ID   

go

go
--•	Report that takes exam number and returns the Questions in it

create proc QuestionsExam @num INT 
as
select body
from Question inner join ExamQuestions 
on ExamQuestions.Question = Question.ID
where ExamQuestions.Exam = @num
 
go 


go 
 --•	Report that takes exam number and the student ID then 
 --    returns the Questions in this exam with the student answers.

create proc Questions_AnswersExam @num INT , @ID INT 
as
select body , ModelAnswer
from StudentAnswers inner join Question 
on StudentAnswers.Question =Question.ID 
where StudentAnswers.Student = @ID AND StudentAnswers.Exam = @num 

go
-----------------------













------------------
--john
---needs modification for exam identity
----------------------------------------------------
--Exam Generation


create procedure GenerateExam (@course int , @mcq int, @trueOrFalse int)
as
begin
	if @mcq >= 0 and @trueOrFalse >=0 and @course in (select ID from Course)
	begin
		insert into Exam default values
		declare @exam int = SCOPE_IDENTITY()
 
		 insert into ExamQuestions select top(@trueOrFalse) @exam,ID from Question where Course=@course and type ='TrueOrFalse' order by NEWID()

		 insert into ExamQuestions select top(@mcq) @exam,ID from Question where Course=@course and Type = 'MCQ' order by NEWID()

		select body,Type,Question.ID,ROW_NUMBER() over ( order by Type desc ) as rank from ExamQuestions inner join Question on ExamQuestions.Question = Question.ID and Exam=@exam
	end
end
go





----------------
--answer exam
create procedure AnswerExam (@exam int,@student int , @answers nvarchar(50))
as begin 
if @EXAM IN (select id from Exam) and @student in (select id from Student)
begin

select body,Type,ID,ROW_NUMBER() over ( order by Type desc) as rank into #TempQuestion from ExamQuestions inner join Question on ExamQuestions.Question = Question.ID where @exam = ExamQuestions.Exam
declare @tab table (answer nchar(1), rankk int identity)
insert into @tab select *from string_split(@answers,',')
insert into StudentAnswers select  @student, @exam, ID, answer from #TempQuestion left outer join @tab on rank=rankk
drop table #TempQuestion


declare @course int
select @course = Course from Question,ExamQuestions where ID = Question and Exam = @exam
declare @sumGrades int
select @sumGrades = sum(ExamGrade) from StudentExams where Student = @student and @exam in
(
select e.ID from Exam e, ExamQuestions eq, Question q, Course c where
e.ID = eq.Exam and eq.Question = q.ID and q.Course = c.ID and c.ID = @course group by e.ID
)
update StudentCourses set Grade = @sumGrades where Student = @student and Course = @course
end
end
go







----------------------------
--exam correction
create procedure CorrectExam (@exam int,@student int)
as
begin
declare @x int 
select Answer, ModelAnswer,StudentGrade from (

select Type as tp, Answer, ModelAnswer,case
	when Answer = ModelAnswer then Question.Grade
	else 0
end as StudentGrade
from StudentAnswers, Question where ID = Question and Exam = @exam and Student = @student 
union all
select '' as tp,'' as Answer,'' as ModelAnswer,sum (case
	when Answer = ModelAnswer then Question.Grade
	else 0
end) as StudentGrade
from StudentAnswers, Question where ID = Question and Exam = @exam and Student = @student 
)as t
order by t.tp desc

end

go
-------

create view StudentExams 
as
--(select Student,Exam from StudentAnswers group by Student, Exam)
select Student, Exam, sum(case
	when Answer = ModelAnswer then Grade
	else 0
end) as ExamGrade
from StudentAnswers inner join Question on Question=ID group by Student,Exam
go















----Some inserts

insert into Department values 
	('SD', 'System Development', 'Smart Village'),
	('Java', 'Java Technologies', 'Smart Village'),
	('EL', 'E-Learning', 'Mansoura'),
('MM', 'Multimedia', 'Alex'),
('Unix', 'Unix', 'Alex'),
('NC', 'Network', 'Cairo'),
('EB' ,'E-Business', 'Alex')

insert into Course values
	('C#', 12),
	('SQL', 7),
('HTML', 20),
('C Progamming', 60),
('OOP', 80),
('Unix', 50),
('Web Service', 20),
('Java', 60),
('Oracle', 50),
('ASP.Net', 60),
('Win_XP', 20),
('Photoshop', 30)

insert into Instructor values
('Ahmed', 'Master', NULL, 1),
('Hany', 'Master', NULL, 1),
('Reham', 'Master', NULL, 1),
('Yasmin', 'PHD', NULL, 1),
('Amany', 'PHD', NULL, 1),
('Eman', 'Master', NULL, 1),
('Saly', 'NULL', NULL, 1),
('Amr', 'NULL', NULL, 3),
('Hussien', 'NULL', NULL, 5),
('Khalid', 'NULL', NULL, 3),
('Salah', 'NULL', NULL, 7),
('Adel', 'NULL', NULL, 7),
('Fakry', 'NULL', NULL, 2),
('Amena', 'NULL', NULL, 2),
('Ghada', NULL, NULL ,4)


insert into InstructorCourses values
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 1),
(3, 6),
(3, 7),
(4, 2),
(4, 3),
(5, 8),
(5, 9),
(6, 5),
(6, 6),
(6, 9),
(6, 10),
(6, 11),
(7, 8),
(7, 9),
(8, 1),
(9, 2),
(10, 3),
(11, 8),
(11, 9),
(12, 10),
(12, 11),
(13, 3),
(13, 4)


insert into Topic values
('Events',1),
('Delegate',1),
('Lamda Expression',1),
('Procedure',2)

insert into Student values
	('Kerollos', 'Talaat', 'Giza', 1),
	('Muhammad', 'Osama', 'October', 1),
	('Amgad', 'Rady', 'October', 2),
	('John', 'Emad', 'Cairo', 2),
	('Ahmed', 'Adel', 'Giza', 1),
	('Ahmed', 'Hassan', 'Cairo', 1),
('Amr', 'Magdy', 'Cairo', 1),
('Mona', 'Saleh', 'Cairo', 1),
('Ahmed', 'Mohamed', 'Alex', 1),
('Khalid', 'Moahmed', 'Alex', 1),
('Heba', 'Farouk', 'Mansoura', 2),
('Ali', 'Hussien', 'Cairo', 2),
('Mohamed', 'Fars', 'Alex', 2),
('Saly', 'Ahmed', 'Mansoura', 3),
('Fady', 'Ali', 'Alex', 3),
('Marwa', 'Ahmed', 'Cairo', 3),
('Noha', 'Omar', 'Cairo', 4)




insert into StudentCourses values
(1, 1, null),
(2, 1, null),
(3, 1, null),
(4, 1, null),
(5, 1, null),
(6, 1, null),
(1, 2, null),
(2, 2, null),
(3, 2, null),
(4, 2, null),
(5, 2, null),
(7, 2, null),
(8, 2, null),
(9, 2, null),
(5, 3, null),
(6, 3, null),
(7, 3, null),
(10, 3, null),
(1, 4, null),
(2, 4, null),
(3, 4, null),
(4, 4, null),
(5, 4, null),
(6, 5, null),
(7, 6, null),
(8, 7, null),
(1, 8, null),
(9, 8, null),
(10, 8, null),
(2, 9, null),
(3, 9, null),
(4, 9, null),
(5, 9, null),
(1, 10, null),
(2, 10, null),
(3, 10, null)


insert into Question values
	('MCQ', 'Which of the following statements is correct about the C#.NET code snippet given below?

int a = 10; 
int b = 20; 
int c = 30;
enum color: byte
{
    red = a, 
    green = b,
    blue = c 
}
A.	Variables cannot be assigned to enum elements.
B.	Variables can be assigned to any one of the enum elements.
C.	Variables can be assigned only to the first enum element.
D.	Values assigned to enum elements must always be successive values.
E.	Values assigned to enum elements must always begin with 0.', 'A', 2, 1),
	('TrueOrFalse', 'A function can return more than one value.', 'F', 1, 1),
	('TrueOrFalse', 'In C#, a function needs to be defined using the static keyword, so that it can be called from the Main function.', 'T', 1, 1)



insert into Question(Type, Body, ModelAnswer, Grade, course)
values
	('MCQ', 'Which of the following variable types can be assigned a value directly in C#?
A) Value types
B) Reference types
C) Pointer types
D) All of the above.','A', 2, 1),
	('MCQ', 'Which of the following converts a type to a signed byte type in C#?
A) ToInt64
B) ToSbyte
C) ToSingle
D) ToInt32','B', 2, 1),
	('MCQ', 'Which of the following operator returns the type of a class in C#?
A) sizeof
B) typeof
C) &</a>
D) *','B', 2, 1),
	('MCQ', 'Which of the following access specifier in C# allows a class to hide its member variables and member functions from other functions and objects?
A) Public
B) Private
C) Protected
D) Internal','B', 2, 1),
	('MCQ', 'Which of the following property of Array class in C# gets the rank (number of dimensions) of the Array?
A) Rank
B) LongLength
C) Length
D) None of the above.','A', 2, 1),
	('MCQ', 'Which of the following is true about C# enumeration?
A) An enumerated type is declared using the enum keyword.
B) C# enumerations are value data type.
C) Enumeration contains its own values and cannot inherit or cannot pass inheritance.
D) All of the above.','D', 2, 1),
	('MCQ', 'Which of the following preprocessor directive lets you modify the compiler''s line number and (optionally) the file name output for errors and warnings in C#?
A) elif
B) endif
C) line
D) region','C', 2, 1),
	('MCQ', 'Which of the following is true about catch block in C#?
A) A program catches an exception with an exception handler at the place in a program where you want to handle the problem.
B) The catch keyword indicates the catching of an exception.
C) Both of the above.
D) None of the above.','C', 2, 1),
	('MCQ', 'Which of the following statements is correct?
A) Procedural Programming paradigm is different than structured programming paradigm.
B) Object Oriented Programming paradigm stresses on dividing the logic into smaller parts and writing procedures for each part.
C) Classes and objects are corner stones of structured programming paradigm.
D) Object Oriented Programming paradigm gives equal importance to data and the procedures that work on the data.','D', 2, 1),
	('MCQ', 'Which of the following statements is correct about classes and objects in C#.NET?
A) Class is a value type.
B) Since objects are typically big in size, they are created on the stack.
C) Objects of smaller size are created on the heap.
D) Objects are always nameless.','D', 2, 1),
	('MCQ', 'Which of the following statements is incorrect about delegate?
A) Delegates are reference types.
B) Delegates are object oriented.
C) Delegates serve the same purpose as function pointers in C and pointers to member function operators in C++.
D) Only one method can be called using a delegate.','D', 2, 1),
	('MCQ', 'Which of the following is the necessary condition for implementing delegates?
A) Class declaration
B) Inheritance
C) Run-time Polymorphism
D) Exceptions','A', 2, 1),
--true or false
('TrueOrFalse', 'Value type variables in C# are derived from the class System.ValueType?','T', 1, 1),
('TrueOrFalse', 'The conditional logical operators can be overloaded.','F', 1, 1),
('TrueOrFalse', 'A function can return more than one value.','F', 1, 1),
('TrueOrFalse', 'In C#, a function needs to be defined using the static keyword, so that it can be called from the Main function.','T', 1, 2),
('TrueOrFalse', 'If a function returns no value, the return type must be declared as void.','T', 1, 2),
('TrueOrFalse', 'In a function, The return statement is not required if the return type is anything other than void.','F', 1, 2),
('TrueOrFalse', 'A local variable declared in a function is not usable out side that function.','T', 1, 2),
('TrueOrFalse', 'A constructor of structure is used to initialize the variables of the structure.','T', 1, 2),
('TrueOrFalse', 'The new keyword can be used to create an object of a structure.','T', 1, 2),
('TrueOrFalse', 'A constructor of structure can have different name from the structure.','F', 1, 2),
('TrueOrFalse', 'The break command is used to exit a loop','T', 1, 2),
('TrueOrFalse', 'When an array is partially initialized, the rest of its elements will automatically be set to zero.','F', 1, 2),
('TrueOrFalse', 'The new keyword can be used to allocate spaces for an array.','T', 1, 2),
('TrueOrFalse', 'A two-dimensional array represents data in the form of table with rows and columns.','T', 1, 2)
----------------




























-----
--sql questions
--- amgad
-- insert MCQ questions SQL
insert into Question
 values('MCQ','Which statement is wrong about PRIMARY KEY constraint in SQL?
A)	The PRIMARY KEY uniquely identifies each record in a SQL database table
B)	Primary key can be made based on multiple columns
C)	Primary key must be made of any single columns
D)	Primary keys must contain UNIQUE values.' , 'C' ,2,2),
  
   ('MCQ' , 'Which is/are correct statements about primary key of a table?
A)	Primary keys can contain NULL values
B)	Primary keys can contain NULL values.
C)	A table can have only one primary key with single or multiple fields
D)	A table can have multiple primary keys with single or multiple fields' ,'C',2,2 ),

   ('MCQ' , 'In existing table, ALTER TABLE statement is used to
A.	Add columns
B.	Add constraints
C.	Delete columns
D.	All of the above
' ,'D',2,2 ),

  ('MCQ' , 'SQL Query to delete all rows in a table without deleting the table (structure, attributes, and indexes)
A.	DELETE FROM table_name;
B.	DELETE TABLE table_name;
C.	DROP TABLE table_name;
D.	NONE
' ,'A',2,2 ),
  ('MCQ' , 'Wrong statement about UPDATE keyword is
A.	If WHERE clause in missing in statement the all records will be updated.
B.	Only one record can be updated at a time using WHERE clause
C.	Multiple records can be updated at a time using WHERE clause
D.	None is wrong statement' , 'B',2,2),

  ('MCQ' , 'Wrong statement about ORDER BY keyword is
A.	Used to sort the result-set in ascending or descending order
B.	The ORDER BY keyword sorts the records in ascending order by default.
C.	To sort the records in ascending order, use the ASC keyword.
D.	To sort the records in descending order, use the DECENDING keyword.' , 'D',2,2),

         
  ('MCQ' , 'Correct syntax query syntax to drop a column from a table is
A.	DELETE COLUMN column_name;
B.	DROP COLUMN column_name;
C.	ALTER TABLE table_name DROP COLUMN column_name;
D.	None is correct.' , 'C',2,2),

  ('MCQ' , 'If you want to allow age of a person > 18 in the column Age of table Person, then which constraint will be applied to AGE column.
A.	Default
B.	Check
C.	NOT NULL
D.	None' , 'B',2,2),


 ('MCQ' , 'In a table, a column contains duplicate value, if you want to list all different value only, then which SQL clause is used?
A.	SQL DISTINCT
B.	SQL UNIQUE
C.	SQL BETWEEN
D.	SQL Exists' , 'B',2,2),


 ('MCQ' , 'To give a temporary name to a table, or a column in a table for more readability, what is used?
A.	SQL Wildcards
B.	SQL aliases
C.	SQL LIKES
D.	SQL Comments' , 'B',2,2)

-- insert true false questions SQL


insert into Question
 values('TrueOrFalse','The condition in a WHERE clause can refer to only one value.
A.True
B.False' , 'F' ,1,2),

('TrueOrFalse','The ADD command is used to enter one row of data or to add multiple rows as a result of a query.
A.True
B.False' , 'F' ,1,2),

('TrueOrFalse','SQL provides the AS keyword, which can be used to assign meaningful column names to the results of queries using the SQL built-in functions.
A.True
B.False' , 'T' ,1,2),

('TrueOrFalse','The SELECT command, with its various clauses, allows users to query the data contained in the tables and ask many different questions or ad hoc queries.
A.True
B.False' , 'T' ,1,2),

('TrueOrFalse','A SELECT statement within another SELECT statement and enclosed in square brackets ([...]) is called a subquery.
A.True
B.False' , 'F' ,1,2),

('TrueOrFalse','The rows of the result relation produced by a SELECT statement can be sorted, but only by one column.
A.True
B.False' , 'F' ,1,2),

('TrueOrFalse','There is an equivalent join expression that can be substituted for all subquery expressions.
A.True
B.False' , 'F' ,1,2),

('TrueOrFalse','A dynamic view is one whose contents materialize when referenced.
A.True
B.False' , 'T' ,1,2),

('TrueOrFalse','SQL is a programming language.
A.True
B.False' , 'F' ,1,2),

('TrueOrFalse','SELECT DISTINCT is used if a user wishes to see duplicate columns in a query.
A.True
B.False' , 'F' ,1,2)
go



-------------------------
/*

generateexam 1,3,7
generateexam 2,3,7



SELECT * FROM StudentAnswers

CORRECTEXAM 1,3

answerexam 1,2,'T,F,T,A,B,C,D,A,B,C,D,A'
answerexam 1,1,'T,F,T,A,B,C,D,A,B,C,D,A'
answerexam 1,3,'F,T,F,A,B,C,D,A,B,C,D,A'

answerexam 2,2,'T,F,T,A,B,C,D,A,B,C,D,A'
answerexam 2,1,'T,F,T,A,B,C,D,A,B,C,D,A'
answerexam 2,3,'F,T,F,A,B,C,D,A,B,C,D,A'


answerexam 3,2,'F,T,F,A,B,C,D,A,B,C,D,A'

select * from StudentExams

select * from StudentCourses

*/

