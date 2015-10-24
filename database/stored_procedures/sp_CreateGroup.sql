IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateGroup]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateGroup]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Create a new group.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateGroup]
(
	@requester_id	INT,					-- The identity of the requester user.
	@course			VARCHAR(20),			-- The course code.
	@number			INT,					-- The group number.
	@professor		VARCHAR(70),			-- The professor username.
	@period_value	INT,					-- The period value. (1, 2, ...)
	@period_type	VARCHAR(50),			-- The period type ('Semestre', 'Bimestre', ...)
	@period_year	INT,					-- The year. (2014, 2015, ...)
	@students		AS UserList READONLY	-- The list of student usernames.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	DECLARE @groupId INT, @courseId INT, @professorId INT, @periodId INT;
	SELECT @courseId = PK_Course_Id FROM Courses WHERE Code = @course;
	SELECT @professorId = PK_User_Id FROM Users WHERE Username = @professor;
	SELECT @periodId = PK_Period_Id FROM Periods INNER JOIN PeriodTypes ON FK_Period_Type_Id = PK_Period_Type_Id WHERE Value = @period_value AND Name = @period_type;
	
	IF @courseId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El curso ingresado no existe: %s.', 15, 1, @course);
		RETURN -1;
	END
	
	IF @professorId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El profesor ingresado no existe: %s.', 15, 1, @professor);
		RETURN -1;
	END
	
	IF @courseId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El periodo ingresado es inválido.', 15, 1);
		RETURN -1;
	END
	
	-- Check if group exists.
	IF EXISTS (SELECT 1 FROM Groups WHERE FK_Course_Id = @courseId AND FK_Professor_Id = @professorId AND FK_Period_Id = @periodId AND Period_Year = @period_year AND Number = @number)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un grupo con estos datos.', 15, 1);
		RETURN -1;
	END
	
	INSERT INTO Groups(FK_Course_Id, FK_Professor_Id, FK_Period_Id, Period_Year, Number, FK_State_Id) VALUES
	(@courseId, @professorId, @periodId, @period_year, @number, dbo.fn_GetStateID('GROUP', 'Activo'));
	SET @groupId = SCOPE_IDENTITY();
	
	IF EXISTS (SELECT 1 FROM @students)
	BEGIN
		EXEC dbo.sp_AddStudentsToGroup @requester_id, @groupId, @students;
	END
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetGroup @requester_id, @groupId, '*';
END
GO