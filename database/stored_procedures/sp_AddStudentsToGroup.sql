IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AddStudentsToGroup]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_AddStudentsToGroup]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Add a list of students to a group.
-- =============================================
CREATE PROCEDURE [dbo].[sp_AddStudentsToGroup]
(
	@requester_id	INT,					-- The identity of the requester user.
	@group			INT,					-- The group identity.
	@students		AS UserList READONLY	-- The list of student usernames.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	INSERT INTO StudentsByGroup(FK_Group_Id, FK_Student_Id)
	SELECT @group, U.PK_User_Id
	FROM @students AS S
	INNER JOIN Users AS U ON U.Username = S.Username
	WHERE NOT EXISTS
	(
		SELECT 1 FROM StudentsByGroup
		WHERE FK_Group_Id = @group AND 
		      FK_Student_Id = U.PK_User_Id
	);
	
	UPDATE Groups
	SET Updated_At = SYSDATETIMEOFFSET()
	WHERE PK_Group_Id = @group;
	
	COMMIT TRANSACTION T;
END
GO