IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Professors]'))
	DROP VIEW [dbo].[vw_Professors]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_Professors] AS
SELECT	U.PK_User_Id AS [id], U.Name AS [name], U.Last_Name_1 AS [last_name_1], U.Last_Name_2 AS [last_name_2],
		RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS [full_name],
		U.Email AS [email], U.Username AS [username], U.Gender AS [gender], U.Phone AS [phone],
		u.Created_At AS [created_at], u.Updated_At AS [updated_at], S.Name AS [state]
FROM Professors AS P
INNER JOIN Users AS U ON P.FK_User_Id = U.PK_User_Id
INNER JOIN States AS S ON U.FK_State_Id = S.PK_State_Id
GO