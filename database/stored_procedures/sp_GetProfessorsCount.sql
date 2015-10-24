IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetProfessorsCount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_GetProfessorsCount]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Jos� Andr�s Garc�a S�enz
-- Create date: 24/10/2015
-- Description:	Count the number of professors that match a query.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetProfessorsCount]
(
	@requester_id	INT,			-- The identity of the requester user.
	@where			VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	EXEC dbo.sp_GetCount 'vw_Professors', @where; 
END
GO


