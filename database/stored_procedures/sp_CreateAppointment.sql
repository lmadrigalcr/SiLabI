IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateAppointment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateAppointment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Create a new appointment.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateAppointment]
(
	@requester_id	INT,				-- The identity of the requester user.
	@student		VARCHAR(70),		-- The student username.
	@laboratory		VARCHAR(500),		-- [Nullable] The laboratory name. If NULL then laboratory will be assigned automatically.
	@software		VARCHAR(20),		-- The software code.
	@group			INT,				-- The group identity.
	@date			DATETIMEOFFSET(3)	-- The appointment date.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	DECLARE @id INT, @studentId INT, @laboratoryId INT, @softwareId INT;
	DECLARE @isValidDate BIT;
	
	-- Get the student identity.
	SELECT @studentId = FK_User_Id FROM Students AS S INNER JOIN Users AS U ON S.FK_User_Id = U.PK_User_Id WHERE U.Username = @student;
	IF @studentId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El estudiante ingresado no existe: %s.', 15, 1, @student);
		RETURN -1;
	END
	
	-- Throw error if a student is creating an appointment for other student.
	IF dbo.fn_GetUserType(@requester_id) = 'Estudiante' AND @requester_id <> @studentId
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('No se permite realizar citas para otros estudiantes.', 15, 1);
		RETURN -1;
	END
	
	-- Check if appointment exists.
	IF dbo.fn_StudentHasAppointment(@studentId, @date) = 1
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe una cita con los datos proporcionados.', 15, 1);
		RETURN -1;
	END
	
	-- Check that the day is after now.
	IF @date < SYSDATETIMEOFFSET()
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ingrese un día posterior a la fecha actual.', 15, 1);
		RETURN -1;
	END
	
	-- Check if user exceed the maximun weekly appointments.
	IF (dbo.fn_GetStudentWeeklyAppointmentsCount(@studentId, @date) >= 2)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Se alcanzó el máximo de citas disponibles para la semana ingresada.', 15, 1);
		RETURN -1;
	END

	-- Get the software identity.
	SELECT @softwareId = PK_Software_Id FROM Software WHERE Code = @software;
	IF @softwareId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El software ingresado no existe: %s.', 15, 1, @software);
		RETURN -1;
	END
	
	-- Get the laboratory identity.
	IF @laboratory IS NULL
	BEGIN
		-- Select the first laboratory, ordered by the appointment priority, that is not reserved and have available seats.
		SELECT TOP 1 @laboratoryId = PK_Laboratory_Id FROM Laboratories
		WHERE dbo.fn_IsLaboratoryReserved(PK_Laboratory_Id, @date, @date) = 0
		AND dbo.fn_GetLaboratoryAvailableSeats(PK_Laboratory_Id, @date) > 0
		ORDER BY Appointment_Priority;

		IF @laboratoryId IS NULL
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('No se encuentran laboratorios disponibles en la hora ingresada.', 15, 1);
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
		
		-- Check if the laboratory have available seats.
		IF (dbo.fn_GetLaboratoryAvailableSeats(@laboratoryId, @date) <= 0)
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('No hay espacios disponibles en este laboratorio en la hora ingresada.', 15, 1);
			RETURN -1;
		END
		
		-- Check if laboratory is reserved.
		IF (dbo.fn_IsLaboratoryReserved(@laboratoryId, @date, @date) = 1)
		BEGIN
			ROLLBACK TRANSACTION T;
			RAISERROR('El laboratorio se encuentra reservado en la hora ingresada.', 15, 1);
			RETURN -1;
		END
	END

	-- Check that the group belongs to the user.
	IF NOT EXISTS (SELECT 1 FROM StudentsByGroup WHERE FK_Group_Id = @group AND FK_Student_Id = @studentId)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El estudiante no pertenece al grupo ingresado.', 15, 1);
		RETURN -1;
	END
	
	-- Check if the date match the group period.
	IF dbo.fn_IsValidDateForGroup(@group, @date) = 0
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('La fecha ingresada no coincide con el periodo lectivo del grupo.', 15, 1);
		RETURN -1;
	END
	
	-- Insert appointment.
	INSERT INTO Appointments(Date, FK_Student_Id, FK_Laboratory_Id, FK_Software_Id, FK_Group_Id, FK_State_Id) VALUES
	(@date, @studentId, @laboratoryId, @softwareId, @group, dbo.fn_GetStateID('APPOINTMENT', 'Por iniciar'));
	SET @id = SCOPE_IDENTITY();
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetAppointment @requester_id, @id, '*';
END
GO