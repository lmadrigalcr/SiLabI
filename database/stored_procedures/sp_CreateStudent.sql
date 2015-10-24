IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateStudent]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateStudent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Create a new student.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateStudent]
(
	@requester_id	INT,			-- The identity of the requester user.
	@name			VARCHAR(70),	-- The first name.
	@last_name_1	VARCHAR(70),	-- The first last name.
	@last_name_2	VARCHAR(70),	-- The second last name. [Nullable]
	@gender			VARCHAR(10),	-- The gender.
	@username		VARCHAR(70),	-- The username.
	@password		VARCHAR(70),	-- The password.
	@email			VARCHAR(100),	-- The email. [Nullable]
	@phone			VARCHAR(20)		-- The phone. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if user exists.
	IF EXISTS (SELECT 1 FROM Users WHERE Username = @username)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un usuario con el username [%s].', 15, 1, @username);
		RETURN -1;
	END
	
	DECLARE @id INT;
	EXEC dbo.sp_CreateUser @id OUTPUT, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone;
	INSERT INTO Students (FK_User_Id) VALUES(@id);
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetStudentByUsername @requester_id, @username, '*';
END
GO