IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetStudent]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_GetStudent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Jos� Andr�s Garc�a S�enz
-- Create date: 24/10/2015
-- Description:	Get a student data.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetStudent]
(
	@requester_id	INT,			-- The identity of the requester user.
	@id				INT,			-- The student identity.
	@fields			VARCHAR(MAX)	-- The fields to include in the SELECT clause. [Nullable]
)
AS
BEGIN
	DECLARE @where VARCHAR(MAX) = 'id=' + CAST(@id AS VARCHAR);
	EXEC dbo.sp_GetOne 'vw_Students', @fields, @where;
END
GO


