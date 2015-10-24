IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AddSoftwareToLaboratory]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_AddSoftwareToLaboratory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Add a list of software to a laboratory.
-- =============================================
CREATE PROCEDURE [dbo].[sp_AddSoftwareToLaboratory]
(
	@requester_id	INT,						-- The identity of the requester user.
	@laboratory		INT,						-- The laboratory identity.
	@softwares		AS SoftwareList READONLY	-- The list of software codes.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	INSERT INTO SoftwareByLaboratory(FK_Laboratory_Id, FK_Software_Id)
	SELECT @laboratory, S2.PK_Software_Id
	FROM @softwares AS S1
	INNER JOIN Software AS S2 ON S1.Code = S2.Code
	WHERE NOT EXISTS
	(
		SELECT 1 FROM SoftwareByLaboratory
		WHERE FK_Laboratory_Id = @laboratory AND 
			  FK_Software_Id = S2.PK_Software_Id
	);
	
	UPDATE Laboratories
	SET Updated_At = SYSDATETIMEOFFSET()
	WHERE PK_Laboratory_Id = @laboratory;
	
	COMMIT TRANSACTION T;
END
GO