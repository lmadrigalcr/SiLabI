USE [SiLabI];
SET NOCOUNT ON;
DECLARE @STUDENT_i INT, @STUDENT_rows INT;

SET @STUDENT_i = 1;
SET @STUDENT_rows = 800;

WHILE @STUDENT_i <= @STUDENT_rows
BEGIN
	INSERT INTO Students (FK_User_Id) VALUES (@STUDENT_i);
	SET @STUDENT_i = @STUDENT_i + 1;
END

USE [master];