USE [SiLabI];
SET NOCOUNT ON;
DECLARE @APPOINTMENT_state INT, @APPOINTMENT_student INT, @APPOINTMENT_laboratory INT, @APPOINTMENT_software INT;
DECLARE @APPOINTMENT_i INT, @APPOINTMENT_rows INT;
SELECT @APPOINTMENT_state = PK_State_Id FROM States WHERE Type = 'APPOINTMENT' AND Name = 'Por iniciar';

SET @APPOINTMENT_i = 0;
SET @APPOINTMENT_rows = 200;

WHILE @APPOINTMENT_i < @APPOINTMENT_rows
BEGIN
	SELECT TOP 1 @APPOINTMENT_student = FK_User_Id FROM Students ORDER BY NEWID();
	SELECT TOP 1 @APPOINTMENT_laboratory = PK_Laboratory_Id FROM Laboratories ORDER BY NEWID();
	SELECT TOP 1 @APPOINTMENT_software = PK_Software_Id FROM Software ORDER BY NEWID();

	IF NOT EXISTS (SELECT 1 FROM Appointments WHERE FK_Laboratory_Id = @APPOINTMENT_laboratory AND FK_Software_Id = @APPOINTMENT_software AND FK_Student_Id = @APPOINTMENT_student)
	BEGIN
		INSERT INTO Appointments(Date, FK_State_Id, FK_Student_Id, FK_Laboratory_Id, FK_Software_Id) VALUES
		(GETDATE(), @APPOINTMENT_state, @APPOINTMENT_student, @APPOINTMENT_laboratory, @APPOINTMENT_software)

		SET @APPOINTMENT_i = @APPOINTMENT_i + 1;
	END
END

USE [master];