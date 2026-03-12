--SQLQuery1 - INSERT Schedule
USE PV_522_Import;
SET DATEFIRST 1;

--DELETE FROM Schedule;

DECLARE @group				AS INT		=	(SELECT group_id FROM Groups WHERE group_name=N'PV_522');
DECLARE @discipline			AS SMALLINT	= (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE N'%ADO.NET');
DECLARE @number_of_lessons	AS TINYINT	= (SELECT number_of_lessons FROM Disciplines WHERE discipline_name LIKE N'%ADO.NET');
DECLARE @lesson_number		AS TINYINT	= 0;
DECLARE @teacher			AS SMALLINT = (SELECT teacher_id FROM Teachers WHERE first_name = N'Олег');
DECLARE @start_date			AS DATE		= N'2026-03-03';
DECLARE @start_time			AS TIME(0)	= N'18:30';
DECLARE @date				AS DATE		= @start_date;
DECLARE @time				AS TIME(0)	= @start_time;

PRINT @group;
PRINT @discipline;
PRINT @teacher;
PRINT @start_date;
PRINT @start_time;
PRINT @number_of_lessons;
PRINT N'==========================================';

WHILE @lesson_number<@number_of_lessons
BEGIN
		SET @time=@start_time;
		PRINT FORMATMESSAGE (N'%i %s %s %s',@lesson_number, CAST (@date AS NVARCHAR(12)), DATENAME(WEEKDAY,@date), CAST (@time AS NVARCHAR(24)));
		IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date]=@date AND [time]=@time)
		INSERT Schedule 
					([group],discipline,teacher,[date],[time],spent)
		VALUES		(@group,@discipline,@teacher,@date,@time,IIF(@date<GETDATE(),1,0));
		SET @time = DATEADD(MINUTE,95,@time);
		SET @lesson_number+=1;
		PRINT FORMATMESSAGE (N'%i %s %s %s',@lesson_number, CAST (@date AS NVARCHAR(12)), DATENAME(WEEKDAY,@date), CAST (@time AS NVARCHAR(24)));
		IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date]=@date AND [time]=@time)
		INSERT Schedule 
					([group],discipline,teacher,[date],[time],spent)
		VALUES		(@group,@discipline,@teacher,@date,@time,IIF(@date<GETDATE(),1,0));
		SET @lesson_number+=1;
		SET @date=DATEADD(DAY,IIF(DATEPART(WEEKDAY,@date)=6,3,2),@date);
END;

SELECT 
		[Группа]		=	group_name,
		[Дисциплина]	=	discipline_name,
		[Преподаватель]	=	FORMATMESSAGE(N'%s %s %s', last_name,first_name,middle_name),
		[Дата]			=	[date],
		[День недели]	=	DATENAME(WEEKDAY,[date]),
		[Время]			=	[time],
		[Статус]		=	IIF(spent=1,N'Проведено','Запланировано')
FROM Schedule,Groups,Teachers,Disciplines
WHERE	[group]	=	group_id
AND		discipline	=	discipline_id
AND		teacher		=	teacher_id
;