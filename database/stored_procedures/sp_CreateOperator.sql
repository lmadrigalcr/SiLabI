IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateOperator]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_CreateOperator]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Andrés García Sáenz
-- Create date: 24/10/2015
-- Description:	Assign the Operator role to a student, for a specific period.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateOperator]
(
	@requester_id   INT,		 -- The identity of the requester user.
	@user_id		INT,		 -- The identity of the user that will be an operator.
	@period_value	INT,		 -- The period value. (1, 2, ...)
	@period_type	VARCHAR(50), -- The period type ('Semestre', 'Bimestre', ...)
	@period_year	INT			 -- The year. (2014, 2015, ...)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	DECLARE @period_id INT, @operator_id INT;
	
	SELECT @period_id = P.PK_Period_Id FROM Periods AS P 
	INNER JOIN PeriodTypes AS PT ON P.FK_Period_Type_Id = PT.PK_Period_Type_Id 
	WHERE P.Value = @period_value AND PT.Name = @period_type;
	
	-- Check if student exists.
	IF NOT EXISTS (SELECT 1 FROM Students WHERE FK_User_Id = @user_id)
	BEGIN
		RAISERROR('Estudiante no encontrado.', 15, 1);
		ROLLBACK TRANSACTION T;
		RETURN -1;
	END

	-- Check for valid period.
	IF @period_id IS NULL
	BEGIN
		RAISERROR('Periodo inválido.', 15, 1);
		ROLLBACK TRANSACTION T;
		RETURN -1;
	END
	
	SELECT @operator_id = PK_Operator_Id FROM Operators
	WHERE FK_User_Id = @user_id AND FK_Period_Id = @period_id AND Period_Year = @period_year;
	
	-- Check if operator exists.
	IF @operator_id IS NOT NULL
	BEGIN
		-- Operator already exists, only has to be activated.
		UPDATE Operators
		SET FK_State_Id = dbo.fn_GetStateID('OPERATOR', 'Activo'),
			Updated_At = SYSDATETIMEOFFSET()
		WHERE FK_User_Id = @user_id AND FK_Period_Id = @period_id AND Period_Year = @period_year
	END
	ELSE
	BEGIN
		-- Operator doesn't exist yet, has to be inserted.
		INSERT INTO Operators (FK_User_Id, FK_Period_Id, Period_Year, FK_State_Id)
		SELECT @user_id, @period_id, @period_year, dbo.fn_GetStateID('OPERATOR', 'Activo');
		SET @operator_id = SCOPE_IDENTITY();
	END
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetOperator @requester_id, @operator_id, '*';
END
GO