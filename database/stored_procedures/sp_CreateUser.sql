IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateUser]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateUser]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Create a new user.
--
-- This procedure should be called only by sp_CreateStudent and sp_CreateProffesor.
-- Don't execute the procedure by itself.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUser]
(
	@id				INT OUTPUT,		-- The user identity will be returned here.
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
	
	INSERT INTO Users (Name, Last_Name_1, Last_Name_2, Username, Password, Email, Phone, Gender, FK_State_Id) VALUES
	(@name, @last_name_1, CAST(dbo.fn_IsNull(@last_name_2, NULL) AS VARCHAR(70)), @username, @password, CAST(dbo.fn_IsNull(@email, NULL) AS VARCHAR(100)), CAST(dbo.fn_IsNull(@phone, NULL) AS VARCHAR(20)), @gender, dbo.fn_GetStateID('USER', 'Activo'));
	
	SET @id = SCOPE_IDENTITY();
END
