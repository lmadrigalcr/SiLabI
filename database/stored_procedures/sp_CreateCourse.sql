IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateCourse]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateCourse]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Create a new course.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateCourse]
(
	@requester_id	INT,			-- The identity of the requester user.
	@name			VARCHAR(500),	-- The course name.
	@code			VARCHAR(20)		-- The course code.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if course exists.
	IF EXISTS (SELECT 1 FROM Courses WHERE Code = @code)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un curso con el código %s.', 15, 1, @code);
		RETURN -1;
	END
	
	DECLARE @id INT;
	INSERT INTO Courses (Name, Code, FK_State_Id) VALUES
	(@name, @code, dbo.fn_GetStateID('COURSE', 'Activo'));
	SET @id = SCOPE_IDENTITY();
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetCourse @requester_id, @id, '*';
END
GO