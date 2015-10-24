IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_Authenticate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_Authenticate]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Retrieve an user profile.
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Authenticate]
(
	@username VARCHAR(70),	-- The username.
	@password VARCHAR(70)	-- The password.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP 1
		U.PK_User_Id AS id, U.Username AS username, U.Name AS name, 
		U.Last_Name_1 AS last_name_1, U.Last_Name_2 AS last_name_2,
		RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS full_name,
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		U.Created_At AS created_at, U.Updated_At AS updated_at,
		dbo.fn_GetUserType(U.PK_User_Id) AS type
	FROM Users AS U
	INNER JOIN States AS S ON S.PK_State_Id = U.FK_State_Id 
	WHERE U.Username = @username AND U.Password = @password AND S.Name = 'Activo';
END
GO