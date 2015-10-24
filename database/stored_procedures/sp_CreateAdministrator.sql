IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateAdministrator]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateAdministrator]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Assign the Administrator role to and user.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateAdministrator]
(
	@requester_id	INT,	-- The identity of the requester user.
	@user_id		INT		-- The identity of the user that will be an administrator.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Administrator already exists, only has to be activated.
	IF EXISTS (SELECT 1 FROM Administrators WHERE FK_User_Id = @user_id)
	BEGIN
		UPDATE Administrators
		SET FK_State_Id = dbo.fn_GetStateID('ADMINISTRATOR', 'Activo'),
			Updated_At = SYSDATETIMEOFFSET()
		WHERE FK_User_Id = @user_id
	END
	-- Administrator doesn't exist yet, has to be inserted.
	ELSE
	BEGIN
		INSERT INTO Administrators (FK_User_Id, FK_State_Id)
		SELECT @user_id, dbo.fn_GetStateID('ADMINISTRATOR', 'Activo');
	END
	
	EXEC dbo.sp_GetAdministrator @requester_id, @user_id, '*';
END
GO