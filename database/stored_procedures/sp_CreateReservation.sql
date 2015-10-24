IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateReservation]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateReservation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Create a new reservation.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateReservation]
(
	@requester_id	INT,					-- The identity of the requester user.
	@professor		VARCHAR(70),			-- The professor username.
	@start_time		DATETIMEOFFSET(3),		-- The reservation start time.
	@end_time		DATETIMEOFFSET(3),		-- The reservation end time.
	@group			INT,					-- [Nullable] The group identity.
	@laboratory		VARCHAR(500),			-- [Nullable] The laboratory name. If NULL then laboratory will be assigned automatically.
	@software		VARCHAR(20)				-- [Nullable] The software code.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	DECLARE @id INT, @professorId INT, @laboratoryId INT, @softwareId INT;
	DECLARE @isValidDate BIT;
	
	-- Get the professor identity.
	SELECT @professorId = FK_User_Id FROM Professors AS P INNER JOIN Users AS U ON P.FK_User_Id = U.PK_User_Id WHERE U.Username = @professor;
	IF @professorId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El docente ingresado no existe: %s.', 15, 1, @professor);
		RETURN -1;
	END
	-- Throw error if a professor is creating a reservation for other professor.
	IF dbo.fn_GetUserType(@requester_id) = 'Docente' AND @requester_id <> @professorId
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('No se permite realizar reservaciones para otros docentes.', 15, 1);
		RETURN -1;
	END
	
	-- Get the software identity.
	SELECT @softwareId = PK_Software_Id FROM Software WHERE Code = @software;
	IF @software IS NOT NULL AND @softwareId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El software ingresado no existe: %s.', 15, 1, @software);
		RETURN -1;
	END
	
	-- Get the laboratory identity.
	IF @laboratory IS NULL
	BEGIN
		SELECT TOP 1 @laboratoryId = PK_Laboratory_Id FROM Laboratories
		WHERE dbo.fn_IsLaboratoryReserved(PK_Laboratory_Id, @start_time, @end_time) = 0
		AND dbo.fn_GetAppointmentsBetween(PK_Laboratory_Id, @start_time, @end_time) = 0
		ORDER BY Reservation_Priority;

		IF @laboratoryId IS NULL
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('No se encuentran laboratorios disponibles durante el tiempo ingresado.', 15, 1);
			RETURN -1;
		END
	END
	ELSE
	BEGIN
		SELECT @laboratoryId = PK_Laboratory_Id FROM Laboratories WHERE Name = @laboratory;
		IF @laboratoryId IS NULL
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('El laboratorio ingresado no existe: %s.', 15, 1, @laboratory);
			RETURN -1;
		END
		
		-- Check that the laboratory is available in the given time.
		IF NOT EXISTS
		(
			SELECT 1 FROM Laboratories
			WHERE PK_Laboratory_Id = @laboratoryId
			AND dbo.fn_IsLaboratoryReserved(PK_Laboratory_Id, @start_time, @end_time) = 0
			AND dbo.fn_GetAppointmentsBetween(PK_Laboratory_Id, @start_time, @end_time) = 0
		)
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('El laboratorio no se encuentra disponible durante el tiempo ingresado.', 15, 1);
			RETURN -1;
		END
	END
	
	IF @group IS NOT NULL
	BEGIN
		-- Check if the group belongs to the professor.
		IF NOT EXISTS (SELECT 1 FROM Groups WHERE PK_Group_Id = @group AND FK_Professor_Id = @professorId)
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('El grupo ingresado pertenece a otro docente.', 15, 1);
			RETURN -1;
		END
		
		-- Check if the date match the group period.
		SELECT TOP 1 @isValidDate = dbo.fn_IsDateInPeriod(@start_time, P.Value, PT.Name, G.Period_Year) & dbo.fn_IsDateInPeriod(@end_time, P.Value, PT.Name, G.Period_Year)
		FROM Groups AS G
		INNER JOIN Periods AS P ON G.FK_Period_Id = P.PK_Period_Id
		INNER JOIN PeriodTypes AS PT ON P.FK_Period_Type_Id = PT.PK_Period_Type_Id
		WHERE G.PK_Group_Id = @group;
		
		IF @isValidDate = 0
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('La fecha ingresada no coincide con el periodo lectivo del grupo.', 15, 1);
			RETURN -1;
		END
	END
	
	-- Insert reservation.
	INSERT INTO Reservations(Start_Time, End_Time, FK_Professor_Id, FK_Group_Id, FK_Laboratory_Id, FK_Software_Id, FK_State_Id) VALUES
	(@start_time, @end_time, @professorId, @group, @laboratoryId, @softwareId, dbo.fn_GetStateID('RESERVATION', 'Por iniciar'));
	SET @id = SCOPE_IDENTITY();
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetReservation @requester_id, @id, '*';
END
GO