IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateLaboratory]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateLaboratory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Create a new laboratory.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateLaboratory]
(
	@requester_id			INT,						-- The identity of the requester user.
	@name					VARCHAR(500),				-- The laboratory name.
	@seats					INT,						-- The number of seats.
	@appointment_priority	INT,						-- The appointment priority.
	@reservation_priority	INT,						-- The reservation priority.
	@software				AS SoftwareList READONLY	-- The list of software codes.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	DECLARE @id INT;
	INSERT INTO Laboratories (Name, Seats, Appointment_Priority, Reservation_Priority, FK_State_Id) VALUES
	(@name, @seats, @appointment_priority, @reservation_priority, dbo.fn_GetStateID('LABORATORY', 'Activo'));
	SET @id = SCOPE_IDENTITY();
	
	IF EXISTS (SELECT 1 FROM @software)
	BEGIN
		EXEC dbo.sp_AddSoftwareToLaboratory @requester_id, @id, @software;
	END
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetLaboratory @requester_id, @id, '*';
END
GO