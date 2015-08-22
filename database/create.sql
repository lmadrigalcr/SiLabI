/****** #####                 ##### ******/
/****** ##### CREATE DATABASE ##### ******/
/****** #####                 ##### ******/


USE [master]
GO

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'SiLabI')
BEGIN
/****** Object:  Database [SiLabI]    Script Date: 08/11/2015 10:51:00 ******/
CREATE DATABASE [SiLabI] ON  PRIMARY 
( NAME = N'SiLabI', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\SiLabI.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SiLabI_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\SiLabI_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
END
GO

ALTER DATABASE [SiLabI] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
	EXEC [SiLabI].[dbo].[sp_fulltext_database] @action = 'enable'
END
GO

ALTER DATABASE [SiLabI] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [SiLabI] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [SiLabI] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [SiLabI] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [SiLabI] SET ARITHABORT OFF 
GO

ALTER DATABASE [SiLabI] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [SiLabI] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [SiLabI] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [SiLabI] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [SiLabI] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [SiLabI] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [SiLabI] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [SiLabI] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [SiLabI] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [SiLabI] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [SiLabI] SET  DISABLE_BROKER 
GO

ALTER DATABASE [SiLabI] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [SiLabI] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [SiLabI] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [SiLabI] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [SiLabI] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [SiLabI] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [SiLabI] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [SiLabI] SET  READ_WRITE 
GO

ALTER DATABASE [SiLabI] SET RECOVERY FULL 
GO

ALTER DATABASE [SiLabI] SET  MULTI_USER 
GO

ALTER DATABASE [SiLabI] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [SiLabI] SET DB_CHAINING OFF 
GO


/****** #####                ##### ******/
/****** ##### CREATE OBJECTS ##### ******/
/****** #####                ##### ******/


USE [SiLabI]
GO
/****** Object:  Table [dbo].[States]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[States]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[States](
	[PK_State_Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](30) NOT NULL,
	[Name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED 
(
	[PK_State_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fn_NullableField]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_NullableField]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*
 * Recieve a value and a table field.
 * If the value is empty then return NULL.
 * If the value is NULL then return the field.
 * Else return the value.
*/
CREATE FUNCTION [dbo].[fn_NullableField]
(
	@param sql_variant,
	@field sql_variant
)
RETURNS sql_variant
AS
BEGIN
	DECLARE @value sql_variant;
	
	SELECT @value =
	CASE 
		WHEN @param IS NULL THEN @field
		WHEN @param = '''' THEN NULL
		ELSE @param
	END
	
	RETURN @value;
END' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CurrentIP]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_CurrentIP]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[fn_CurrentIP] ()
RETURNS varchar(255)
AS
BEGIN
    DECLARE @IP_Address varchar(255);

    SELECT @IP_Address = client_net_address
    FROM sys.dm_exec_connections
    WHERE Session_id = @@SPID;
    
    IF (@IP_Address = ''<local machine>'')
	BEGIN
		SET @IP_Address = ''127.0.0.1'';
	END

    Return @IP_Address;
END
' 
END
GO
/****** Object:  Table [dbo].[PeriodTypes]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PeriodTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PeriodTypes](
	[PK_Period_Type_Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Max_Value] [int] NOT NULL,
 CONSTRAINT [PK_PeriodTypes] PRIMARY KEY CLUSTERED 
(
	[PK_Period_Type_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAdministratorsCount]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetAdministratorsCount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetAdministratorsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '''') = '''')
		SET @where = ''1=1'';

	SET @sql =	''SELECT COUNT(*) AS count FROM Administrators '' +
				''INNER JOIN Users ON Administrators.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where;
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAdministrators]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetAdministrators]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetAdministrators]
(
	@fields		VARCHAR(MAX),	-- The fields to include in the SELECT clause. [Nullable]
	@order_by	VARCHAR(MAX),	-- The fields to include in the ORDER BY clause. [Nullable]
	@where		VARCHAR(MAX),	-- The fields to include in the WHERE clause. [Nullable]
	@page		INT,			-- The page number. [Nullable]
	@limit		INT				-- The rows per page. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);
	DECLARE @start INT, @end INT;

	-- SET default values.	
	SET @fields = COALESCE(@fields, '''');
	SET @order_by = COALESCE(@order_by, '''');
	SET @where = COALESCE(@where, '''');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '''')
	BEGIN
		SET @fields = ''
			Users.PK_User_Id AS id, Users.Username AS username, Users.Name AS name, 
			Users.Last_Name_1 AS last_name_1, Users.Last_Name_2 AS last_name_2, 
			Users.Gender AS gender, Users.Email AS email, Users.Phone AS phone,
			Administrators.Created_At AS created_at, Administrators.Updated_At AS updated_at,
			States.Name AS state'';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '''') SET @order_by = ''RAND()'';
	
	-- SET default WHERE query.
	IF (@where = '''') SET @where = ''1=1'';

	SET @sql =	''SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY '' + @order_by + '') AS rn, '' +
				@fields + '' FROM Administrators '' +
				''INNER JOIN Users ON Administrators.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Administrators.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where + '') AS Sub WHERE rn >= '' + CAST(@start AS VARCHAR) +
				'' AND rn <= '' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProfessorsCount]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetProfessorsCount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetProfessorsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '''') = '''')
		SET @where = ''1=1'';

	SET @sql =	''SELECT COUNT(*) AS count FROM Professors '' +
				''INNER JOIN Users ON Professors.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where;
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProfessors]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetProfessors]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetProfessors]
(
	@fields		VARCHAR(MAX),	-- The fields to include in the SELECT clause. [Nullable]
	@order_by	VARCHAR(MAX),	-- The fields to include in the ORDER BY clause. [Nullable]
	@where		VARCHAR(MAX),	-- The fields to include in the WHERE clause. [Nullable]
	@page		INT,			-- The page number. [Nullable]
	@limit		INT				-- The rows per page. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);
	DECLARE @start INT, @end INT;

	-- SET default values.	
	SET @fields = COALESCE(@fields, '''');
	SET @order_by = COALESCE(@order_by, '''');
	SET @where = COALESCE(@where, '''');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '''')
	BEGIN
		SET @fields = ''
			Users.PK_User_Id AS id, Users.Username AS username, Users.Name AS name, 
			Users.Last_Name_1 AS last_name_1, Users.Last_Name_2 AS last_name_2, 
			Users.Gender AS gender, Users.Email AS email, Users.Phone AS phone,
			Users.Created_At AS created_at, Users.Updated_At AS updated_at,
			States.Name AS state'';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '''') SET @order_by = ''RAND()'';
	
	-- SET default WHERE query.
	IF (@where = '''') SET @where = ''1=1'';

	SET @sql =	''SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY '' + @order_by + '') AS rn, '' +
				@fields + '' FROM Professors '' +
				''INNER JOIN Users ON Professors.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where + '') AS Sub WHERE rn >= '' + CAST(@start AS VARCHAR) +
				'' AND rn <= '' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUsersCount]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetUsersCount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetUsersCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '''') = '''')
		SET @where = ''1=1'';

	SET @sql =	''SELECT COUNT(*) AS count FROM vw_Users AS Users '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where;
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUsers]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetUsers]
(
	@fields		VARCHAR(MAX),	-- The fields to include in the SELECT clause. [Nullable]
	@order_by	VARCHAR(MAX),	-- The fields to include in the ORDER BY clause. [Nullable]
	@where		VARCHAR(MAX),	-- The fields to include in the WHERE clause. [Nullable]
	@page		INT,			-- The page number. [Nullable]
	@limit		INT				-- The rows per page. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);
	DECLARE @start INT, @end INT;

	-- SET default values.	
	SET @fields = COALESCE(@fields, '''');
	SET @order_by = COALESCE(@order_by, '''');
	SET @where = COALESCE(@where, '''');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '''')
	BEGIN
		SET @fields = ''
			Users.PK_User_Id AS id, Users.Username AS username, Users.Name AS name, 
			Users.Last_Name_1 AS last_name_1, Users.Last_Name_2 AS last_name_2, 
			Users.Gender AS gender, Users.Email AS email, Users.Phone AS phone,
			Users.Created_At AS created_at, Users.Updated_At AS updated_at,
			Users.Type AS type, States.Name AS state'';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '''') SET @order_by = ''RAND()'';
	
	-- SET default WHERE query.
	IF (@where = '''') SET @where = ''1=1'';

	SET @sql =	''SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY '' + @order_by + '') AS rn, '' +
				@fields + '' FROM vw_Users AS Users '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where + '') AS Sub WHERE rn >= '' + CAST(@start AS VARCHAR) +
				'' AND rn <= '' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetOperatorsCount]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetOperatorsCount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetOperatorsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '''') = '''')
		SET @where = ''1=1'';

	SET @sql =	''SELECT COUNT(*) AS count FROM Operators '' +
				''INNER JOIN Users ON Operators.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where;
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetOperators]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetOperators]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetOperators]
(
	@fields		VARCHAR(MAX),	-- The fields to include in the SELECT clause. [Nullable]
	@order_by	VARCHAR(MAX),	-- The fields to include in the ORDER BY clause. [Nullable]
	@where		VARCHAR(MAX),	-- The fields to include in the WHERE clause. [Nullable]
	@page		INT,			-- The page number. [Nullable]
	@limit		INT				-- The rows per page. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);
	DECLARE @start INT, @end INT;

	-- SET default values.	
	SET @fields = COALESCE(@fields, '''');
	SET @order_by = COALESCE(@order_by, '''');
	SET @where = COALESCE(@where, '''');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '''')
	BEGIN
		SET @fields = ''
			Users.PK_User_Id AS id, Users.Username AS username, Users.Name AS name, 
			Users.Last_Name_1 AS last_name_1, Users.Last_Name_2 AS last_name_2, 
			Users.Gender AS gender, Users.Email AS email, Users.Phone AS phone,
			Operators.Created_At AS created_at, Operators.Updated_At AS updated_at,
			States.Name AS state'';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '''') SET @order_by = ''RAND()'';
	
	-- SET default WHERE query.
	IF (@where = '''') SET @where = ''1=1'';

	SET @sql =	''SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY '' + @order_by + '') AS rn, '' +
				@fields + '' FROM Operators '' +
				''INNER JOIN Users ON Operators.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Operators.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where + '') AS Sub WHERE rn >= '' + CAST(@start AS VARCHAR) +
				'' AND rn <= '' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudentsCount]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetStudentsCount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetStudentsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '''') = '''')
		SET @where = ''1=1'';

	SET @sql =	''SELECT COUNT(*) AS count FROM Students '' +
				''INNER JOIN Users ON Students.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where;
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudents]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetStudents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetStudents]
(
	@fields		VARCHAR(MAX),	-- The fields to include in the SELECT clause. [Nullable]
	@order_by	VARCHAR(MAX),	-- The fields to include in the ORDER BY clause. [Nullable]
	@where		VARCHAR(MAX),	-- The fields to include in the WHERE clause. [Nullable]
	@page		INT,			-- The page number. [Nullable]
	@limit		INT				-- The rows per page. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);
	DECLARE @start INT, @end INT;

	-- SET default values.	
	SET @fields = COALESCE(@fields, '''');
	SET @order_by = COALESCE(@order_by, '''');
	SET @where = COALESCE(@where, '''');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '''')
	BEGIN
		SET @fields = ''
			Users.PK_User_Id AS id, Users.Username AS username, Users.Name AS name, 
			Users.Last_Name_1 AS last_name_1, Users.Last_Name_2 AS last_name_2, 
			Users.Gender AS gender, Users.Email AS email, Users.Phone AS phone,
			Users.Created_At AS created_at, Users.Updated_At AS updated_at,
			States.Name AS state'';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '''') SET @order_by = ''RAND()'';
	
	-- SET default WHERE query.
	IF (@where = '''') SET @where = ''1=1'';

	SET @sql =	''SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY '' + @order_by + '') AS rn, '' +
				@fields + '' FROM Students '' +
				''INNER JOIN Users ON Students.FK_User_Id = Users.PK_User_Id '' +
				''INNER JOIN States ON Users.FK_State_Id = States.PK_State_Id '' +
				''WHERE '' + @where + '') AS Sub WHERE rn >= '' + CAST(@start AS VARCHAR) +
				'' AND rn <= '' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END' 
END
GO
/****** Object:  Table [dbo].[Software]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Software]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Software](
	[PK_Software_Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
 CONSTRAINT [PK_Software] PRIMARY KEY CLUSTERED 
(
	[PK_Software_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Laboratories]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Laboratories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Laboratories](
	[PK_Laboratory_Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Seats] [int] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
 CONSTRAINT [PK_Laboratories] PRIMARY KEY CLUSTERED 
(
	[PK_Laboratory_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Periods]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Periods]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Periods](
	[PK_Period_Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [int] NOT NULL,
	[FK_Period_Type_Id] [int] NOT NULL,
 CONSTRAINT [PK_Periods] PRIMARY KEY CLUSTERED 
(
	[PK_Period_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StateId]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_StateId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_StateId]
(
	@state_type VARCHAR(30),
	@state_name VARCHAR(30)
)
RETURNS INT
AS
BEGIN
	DECLARE @state_id INT;
	
	SELECT @state_id = PK_State_Id FROM States
	WHERE Type = @state_type AND Name = @state_name;
	
	RETURN @state_id
END' 
END
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Courses]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Courses](
	[PK_Course_Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
 CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED 
(
	[PK_Course_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[PK_User_Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](70) NOT NULL,
	[Last_Name_1] [varchar](70) NOT NULL,
	[Last_Name_2] [varchar](70) NULL,
	[Username] [varchar](70) NOT NULL,
	[Password] [varchar](70) NOT NULL,
	[Gender] [varchar](10) NOT NULL,
	[Email] [varchar](100) NULL,
	[Phone] [varchar](20) NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[PK_User_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Username] UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateUser]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_UpdateUser]
(
	@id				INT,			-- The user id.
	@name			VARCHAR(70),	-- The first name.
	@last_name_1	VARCHAR(70),	-- The first last name.
	@last_name_2	VARCHAR(70),	-- The second last name. [Nullable]
	@gender			VARCHAR(10),	-- The gender.
	@username		VARCHAR(70),	-- The username.
	@password		VARCHAR(70),	-- The password.
	@email			VARCHAR(100),	-- The email. [Nullable]
	@phone			VARCHAR(20),	-- The phone. [Nullable]
	@state			VARCHAR(30)		-- The state. (''active'', ''disabled'', ''blocked'')
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	IF EXISTS (SELECT 1 FROM Users WHERE Username = @username AND PK_User_Id <> @id)
	BEGIN
		RAISERROR(''Ya existe un usuario con el username [%s].'', 15, 1, @username);
		ROLLBACK TRANSACTION T;
	END
	ELSE
	BEGIN
		UPDATE Users
		SET [Name] = ISNULL(@name, [Name]),
		[Last_Name_1] = ISNULL(@last_name_1, [Last_Name_1]),
		[Last_Name_2] =  CAST(dbo.fn_NullableField(@last_name_2, [Last_Name_2]) AS VARCHAR(70)),
		[Username] = ISNULL(@username, [Username]),
		[Password] = ISNULL(@password, [Password]),
		[Email] = CAST(dbo.fn_NullableField(@email, [Email]) AS VARCHAR(100)),
		[Phone] =  CAST(dbo.fn_NullableField(@phone, [Phone]) AS VARCHAR(20)),
		[Gender] = ISNULL(@gender, [Gender]),
		[FK_State_Id] = ISNULL(dbo.fn_StateId(''USER'', @state), [FK_State_Id]),
		[Updated_At] = GETDATE()
		WHERE PK_User_Id = @id;

		COMMIT TRANSACTION T;
	END
END' 
END
GO
/****** Object:  Table [dbo].[Students]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Students]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Students](
	[FK_User_Id] [int] NOT NULL,
 CONSTRAINT [IX_Students_User_Id] UNIQUE NONCLUSTERED 
(
	[FK_User_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Administrators]    Script Date: 08/22/2015 14:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Administrators]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Administrators](
	[FK_User_Id] [int] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
 CONSTRAINT [IX_Administrators_User_Id] UNIQUE NONCLUSTERED 
(
	[FK_User_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Professors]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Professors]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Professors](
	[FK_User_Id] [int] NOT NULL,
 CONSTRAINT [IX_Professors_User_Id] UNIQUE NONCLUSTERED 
(
	[FK_User_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateUser]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_CreateUser]
(
	@id				INT OUTPUT,		-- The inserted row id will be saved here.
	@name			VARCHAR(70),	-- The first name.
	@last_name_1	VARCHAR(70),	-- The first last name.
	@last_name_2	VARCHAR(70),	-- The second last name. [Nullable]
	@gender			VARCHAR(10),	-- The gender.
	@username		VARCHAR(70),	-- The username.
	@password		VARCHAR(70),	-- The password.
	@email			VARCHAR(100),	-- The email. [Nullable]
	@phone			VARCHAR(20)		-- The phone. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO Users (Name, Last_Name_1, Last_Name_2, Username, Password, Email, Phone, Gender, FK_State_Id, Created_At, Updated_At)
	SELECT 
	@name, 
	@last_name_1, 
	CAST(dbo.fn_NullableField(@last_name_2, NULL) AS VARCHAR(70)), 
	@username, 
	@password, 
	CAST(dbo.fn_NullableField(@email, NULL) AS VARCHAR(100)),
	CAST(dbo.fn_NullableField(@phone, NULL) AS VARCHAR(20)),
	@gender, 
	S.PK_State_Id, 
	GETDATE(),
	GETDATE()
	FROM States AS S
	WHERE S.Type = ''USER'' AND S.Name = ''Activo'';
	
	SET @id = SCOPE_IDENTITY();
END' 
END
GO
/****** Object:  Table [dbo].[SoftwareByLaboratory]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SoftwareByLaboratory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SoftwareByLaboratory](
	[FK_Software_Id] [int] NOT NULL,
	[FK_Laboratory_Id] [int] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteAdministrator]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteAdministrator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_DeleteAdministrator]
(
	@user_id INT	-- The User Id.
)
AS
BEGIN
	UPDATE Administrators
	SET FK_State_Id = dbo.fn_StateId(''ADMINISTRATOR'', ''Inactivo''),
		Updated_At = GETDATE()
	WHERE FK_User_Id = @user_id;
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateAdministrator]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateAdministrator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_CreateAdministrator]
(
	@user_id INT	-- The user ID.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Administrator already exists, only has to be activated.
	IF EXISTS (SELECT 1 FROM Administrators WHERE FK_User_Id = @user_id)
	BEGIN
		UPDATE Administrators
		SET FK_State_Id = dbo.fn_StateId(''ADMINISTRATOR'', ''Activo''),
			Updated_At = GETDATE()
		WHERE FK_User_Id = @user_id
	END
	-- Administrator doesn''t exist yet, has to be inserted.
	ELSE
	BEGIN
		INSERT INTO Administrators (FK_User_Id, FK_State_Id)
		SELECT @user_id, dbo.fn_StateId(''ADMINISTRATOR'', ''Activo'');
	END
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudent]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetStudent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetStudent]
(
	@user_id INT	-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		U.PK_User_Id AS id, U.Username AS username, U.Name AS name, 
		U.Last_Name_1 AS last_name_1, U.Last_Name_2 AS last_name_2, 
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		U.Created_At AS created_at, U.Updated_At AS updated_at,
		E.Name AS state
	FROM Students AS S
	INNER JOIN Users AS U ON S.FK_User_Id = U.PK_User_Id
	INNER JOIN States AS E ON U.FK_State_Id = E.PK_State_Id
	WHERE U.PK_User_Id = @user_id;
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProfessor]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetProfessor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetProfessor]
(
	@user_id INT	-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		U.PK_User_Id AS id, U.Username AS username, U.Name AS name, 
		U.Last_Name_1 AS last_name_1, U.Last_Name_2 AS last_name_2, 
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		U.Created_At AS created_at, U.Updated_At AS updated_at,
		E.Name AS state
	FROM Professors AS P
	INNER JOIN Users AS U ON P.FK_User_Id = U.PK_User_Id
	INNER JOIN States AS E ON U.FK_State_Id = E.PK_State_Id
	WHERE U.PK_User_Id = @user_id;
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAdministrator]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetAdministrator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetAdministrator]
(
	@user_id INT	-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		U.PK_User_Id AS id, U.Username AS username, U.Name AS name, 
		U.Last_Name_1 AS last_name_1, U.Last_Name_2 AS last_name_2, 
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		A.Created_At AS created_at, A.Updated_At AS updated_at,
		S.Name AS state
	FROM Administrators AS A
	INNER JOIN Users AS U ON U.PK_User_Id = A.FK_User_Id
	INNER JOIN States AS S ON S.PK_State_Id = A.FK_State_Id
	WHERE U.PK_User_Id = @user_id;
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteStudent]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteStudent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_DeleteStudent]
(
	@user_id	INT		-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	IF EXISTS (SELECT 1 FROM Students WHERE FK_User_Id = @user_id)
	BEGIN
		UPDATE Users
		SET FK_State_Id = dbo.fn_StateId(''USER'', ''Inactivo''),
		Updated_At = GETDATE()
		WHERE PK_User_Id = @user_id;
		
		COMMIT TRANSACTION T;
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR(''El usuario ingresado no corresponde a un estudiante.'', 15, 1);
	END
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteProfessor]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteProfessor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_DeleteProfessor]
(
	@user_id	INT		-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	IF EXISTS (SELECT 1 FROM Professors WHERE FK_User_Id = @user_id)
	BEGIN
		UPDATE Users
		SET FK_State_Id = dbo.fn_StateId(''USER'', ''Inactivo''),
		Updated_At = GETDATE()
		WHERE PK_User_Id = @user_id;
		
		COMMIT TRANSACTION T;
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR(''El usuario ingresado no corresponde a un docente.'', 15, 1);
	END
END' 
END
GO
/****** Object:  Table [dbo].[Appointments]    Script Date: 08/22/2015 14:51:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Appointments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Appointments](
	[PK_Appointment_Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_Student_Id] [int] NOT NULL,
	[FK_Laboratory_Id] [int] NOT NULL,
	[FK_Software_Id] [int] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
 CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED 
(
	[PK_Appointment_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Operators]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Operators]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Operators](
	[FK_User_Id] [int] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Period_Year] [int] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
	[FK_Period_Id] [int] NOT NULL,
 CONSTRAINT [IX_Operators] UNIQUE NONCLUSTERED 
(
	[FK_User_Id] ASC,
	[FK_Period_Id] ASC,
	[Period_Year] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Groups]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Groups](
	[PK_Group_Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [int] NOT NULL,
	[Period_Year] [int] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_Course_Id] [int] NOT NULL,
	[FK_Professor_Id] [int] NOT NULL,
	[FK_Period_Id] [int] NOT NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[PK_Group_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Groups] UNIQUE NONCLUSTERED 
(
	[Number] ASC,
	[FK_Professor_Id] ASC,
	[FK_Course_Id] ASC,
	[FK_Period_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_UserType]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_UserType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[fn_UserType](@UserId INT)
RETURNS VARCHAR(30)
AS
BEGIN
	IF EXISTS 
	(
		SELECT 1 FROM Administrators AS A
		INNER JOIN States AS S ON S.PK_State_Id = A.FK_State_Id
		WHERE A.FK_User_Id = @UserId AND S.Type = ''ADMINISTRATOR'' AND S.Name = ''active''
	)
    RETURN ''Administrador''

    IF EXISTS
	(
		SELECT 1 FROM Operators AS O
		INNER JOIN States AS S ON S.PK_State_Id = O.FK_State_Id
		WHERE O.FK_User_Id = @UserId AND S.Type = ''OPERATOR'' AND S.Name = ''active''
	)
	RETURN ''Operador''
    
    IF EXISTS (SELECT 1 FROM Students WHERE FK_User_Id = @UserId)
    RETURN ''Estudiante''
    
    IF EXISTS (SELECT 1 FROM Professors WHERE FK_User_Id = @UserId)
    RETURN ''Docente''
    
    RETURN NULL
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteOperator]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteOperator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_DeleteOperator]
(
	@user_id INT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE Operators
	SET FK_State_Id = dbo.fn_StateId(''OPERATOR'', ''Inactivo''),
		Updated_At = GETDATE()
	WHERE FK_User_Id = @user_id;
END



' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetOperator]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetOperator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetOperator]
(
	@user_id INT	-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		U.PK_User_Id AS id, U.Username AS username, U.Name AS name, 
		U.Last_Name_1 AS last_name_1, U.Last_Name_2 AS last_name_2, 
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		O.Created_At AS created_at, O.Updated_At AS updated_at,
		S.Name AS state
	FROM Operators AS O
	INNER JOIN Users AS U ON U.PK_User_Id = O.FK_User_Id
	INNER JOIN States AS S ON S.PK_State_Id = O.FK_State_Id
	WHERE U.PK_User_Id = @user_id;
END' 
END
GO
/****** Object:  Table [dbo].[Reservations]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reservations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Reservations](
	[PK_Reservation_Id] [int] IDENTITY(1,1) NOT NULL,
	[Start_Time] [datetime] NOT NULL,
	[End_Time] [datetime] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_Professor_Id] [int] NOT NULL,
	[FK_Group_Id] [int] NULL,
	[FK_Laboratory_Id] [int] NOT NULL,
	[FK_Software_Id] [int] NULL,
	[FK_State_Id] [int] NOT NULL,
 CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED 
(
	[PK_Reservation_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateStudent]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateStudent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_CreateStudent]
(
	@name			VARCHAR(70),	-- The first name.
	@last_name_1	VARCHAR(70),	-- The first last name.
	@last_name_2	VARCHAR(70),	-- The second last name. [Nullable]
	@gender			VARCHAR(10),	-- The gender.
	@username		VARCHAR(70),	-- The username.
	@password		VARCHAR(70),	-- The password.
	@email			VARCHAR(100),	-- The email. [Nullable]
	@phone			VARCHAR(20)		-- The phone. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	BEGIN TRY
		DECLARE @id INT;
		
		EXEC dbo.sp_CreateUser @id OUTPUT, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone;
		
		INSERT INTO Students (FK_User_Id) VALUES
		(@id);
		
		COMMIT TRANSACTION T;
		
		EXEC dbo.sp_GetStudent @id;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION T;
		RAISERROR(''El estudiante [%s] ya existe.'', 15, 1, @username);
	END CATCH
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateProfessor]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateProfessor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_CreateProfessor]
(
	@name			VARCHAR(70),	-- The first name.
	@last_name_1	VARCHAR(70),	-- The first last name.
	@last_name_2	VARCHAR(70),	-- The second last name. [Nullable]
	@gender			VARCHAR(10),	-- The gender.
	@username		VARCHAR(70),	-- The username.
	@password		VARCHAR(70),	-- The password.
	@email			VARCHAR(100),	-- The email. [Nullable]
	@phone			VARCHAR(20)		-- The phone. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	BEGIN TRY
		DECLARE @id INT;
		
		EXEC dbo.sp_CreateUser @id OUTPUT, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone;
		
		INSERT INTO Professors (FK_User_Id) VALUES
		(@id);
		
		COMMIT TRANSACTION T;
		
		EXEC dbo.sp_GetProfessor @id;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION T;
		RAISERROR(''El docente [%s] ya existe.'', 15, 1, @username);
	END CATCH
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateOperator]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateOperator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_CreateOperator]
(
	@user_id		INT,		 -- The user ID.
	@period_value	INT,		 -- The period value. (1, 2, ...)
	@period_type	VARCHAR(50), -- The period type (''Semestre'', ''Bimestre'', ...)
	@period_year	INT			 -- The year. (2014, 2015, ...)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	IF EXISTS
	(
		SELECT 1 FROM Operators AS O
		INNER JOIN Periods AS P ON O.FK_Period_Id = P.PK_Period_Id
		INNER JOIN PeriodTypes AS PT ON P.FK_Period_Type_Id = PT.PK_Period_Type_Id
		WHERE O.FK_User_Id = @user_id AND PT.Name = @period_type 
		AND P.Value = @period_value AND O.Period_Year = @period_year
	)
	BEGIN
		-- Operator already exists, only has to be activated.
		UPDATE Operators
		SET FK_State_Id = dbo.fn_StateId(''OPERATOR'', ''Activo''),
			Updated_At = GETDATE()
		WHERE FK_User_Id = @user_id AND 
			  FK_Period_Id = (SELECT P.PK_Period_Id FROM Periods AS P INNER JOIN PeriodTypes AS PT ON P.FK_Period_Type_Id = PT.PK_Period_Type_Id WHERE PT.Name = @period_type AND P.Value = @period_value) AND
			  Period_Year = @period_year
	END
	ELSE
	BEGIN
		-- Operator doesn''t exist yet, has to be inserted.
		INSERT INTO Operators (Period_Year, FK_User_Id, FK_Period_Id, FK_State_Id)
		SELECT @period_year, @user_id, P.PK_Period_Id, dbo.fn_StateId(''OPERATOR'',''active'')
		FROM Periods AS P
		INNER JOIN PeriodTypes AS PT ON P.FK_Period_Type_Id = PT.PK_Period_Type_Id
		WHERE PT.Name = @period_type AND P.Value = @period_value;
	END
	
	COMMIT TRANSACTION T;
END' 
END
GO
/****** Object:  Table [dbo].[StudentsByGroup]    Script Date: 08/22/2015 14:51:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentsByGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StudentsByGroup](
	[FK_Student_Id] [int] NOT NULL,
	[FK_Group_Id] [int] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateStudent]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateStudent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_UpdateStudent]
(
	@id				INT,			-- The user id.
	@name			VARCHAR(70),	-- The first name.
	@last_name_1	VARCHAR(70),	-- The first last name.
	@last_name_2	VARCHAR(70),	-- The second last name. [Nullable]
	@gender			VARCHAR(10),	-- The gender.
	@username		VARCHAR(70),	-- The username.
	@password		VARCHAR(70),	-- The password.
	@email			VARCHAR(100),	-- The email. [Nullable]
	@phone			VARCHAR(20),	-- The phone. [Nullable]
	@state			VARCHAR(30)		-- The state. (''active'', ''disabled'', ''blocked'')
)
AS
BEGIN
	SET NOCOUNT ON;
	EXEC dbo.sp_UpdateUser @id, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone, @state;
	EXEC dbo.sp_GetStudent @id;
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProfessor]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateProfessor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_UpdateProfessor]
(
	@id				INT,			-- The user id.
	@name			VARCHAR(70),	-- The first name.
	@last_name_1	VARCHAR(70),	-- The first last name.
	@last_name_2	VARCHAR(70),	-- The second last name. [Nullable]
	@gender			VARCHAR(10),	-- The gender.
	@username		VARCHAR(70),	-- The username.
	@password		VARCHAR(70),	-- The password.
	@email			VARCHAR(100),	-- The email. [Nullable]
	@phone			VARCHAR(20),	-- The phone. [Nullable]
	@state			VARCHAR(30)		-- The state. (''active'', ''disabled'', ''blocked'')
)
AS
BEGIN
	SET NOCOUNT ON;
	EXEC dbo.sp_UpdateUser @id, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone, @state;
	EXEC dbo.sp_GetProfessor @id;
END' 
END
GO
/****** Object:  View [dbo].[vw_Users]    Script Date: 08/22/2015 14:51:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Users]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_Users]
AS
SELECT     PK_User_Id, Name, Last_Name_1, Last_Name_2, Username, Email, Gender, Phone, Created_At, Updated_At, dbo.fn_UserType(PK_User_Id) AS Type, 
                      FK_State_Id
FROM         dbo.Users AS U
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'vw_Users', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Users'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'vw_Users', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Users'
GO
/****** Object:  StoredProcedure [dbo].[sp_Authenticate]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_Authenticate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[sp_Authenticate]
(
@username VARCHAR(70),    -- The username.
@password VARCHAR(70)     -- The password.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP 1
		U.PK_User_Id AS id, U.Username AS username, U.Name AS name, 
		U.Last_Name_1 AS last_name_1, U.Last_Name_2 AS last_name_2, 
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		U.Created_At AS created_at, U.Updated_At AS updated_at,
		dbo.fn_UserType(U.PK_User_Id) AS type
	FROM Users AS U
	INNER JOIN States AS S ON S.PK_State_Id = U.FK_State_Id 
	WHERE U.Username = @username AND U.Password = @password AND S.Name = ''Activo'';
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUser]    Script Date: 08/22/2015 14:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetUser]
(
	@username VARCHAR(70)	-- The Username.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		U.PK_User_Id AS id, U.Username AS username, U.Name AS name, 
		U.Last_Name_1 AS last_name_1, U.Last_Name_2 AS last_name_2, 
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		U.Created_At AS created_at, U.Updated_At AS updated_at,
		U.Type AS type, S.Name AS state
	FROM vw_Users AS U
	INNER JOIN States AS S ON S.PK_State_Id = U.FK_State_Id
	WHERE U.Username = @username;
END' 
END
GO
/****** Object:  Default [DF_Administrators_Created_At]    Script Date: 08/22/2015 14:51:31 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Administrators_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Administrators]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Administrators_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Administrators] ADD  CONSTRAINT [DF_Administrators_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Administrators_Updated_At]    Script Date: 08/22/2015 14:51:31 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Administrators_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Administrators]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Administrators_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Administrators] ADD  CONSTRAINT [DF_Administrators_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Appointments_Created_At]    Script Date: 08/22/2015 14:51:31 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Appointments_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Appointments_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Appointments] ADD  CONSTRAINT [DF_Appointments_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Appointments_Updated_At]    Script Date: 08/22/2015 14:51:31 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Appointments_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Appointments_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Appointments] ADD  CONSTRAINT [DF_Appointments_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Courses_Created_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Courses_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Courses]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Courses_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Courses] ADD  CONSTRAINT [DF_Courses_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Courses_Updated_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Courses_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Courses]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Courses_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Courses] ADD  CONSTRAINT [DF_Courses_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Groups_Period_Year]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Groups_Period_Year]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Groups_Period_Year]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_Period_Year]  DEFAULT (datepart(year,getdate())) FOR [Period_Year]
END


End
GO
/****** Object:  Default [DF_Groups_Created_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Groups_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Groups_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Groups_Updated_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Groups_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Groups_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Laboratories_Created_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Laboratories_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Laboratories]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Laboratories_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Laboratories] ADD  CONSTRAINT [DF_Laboratories_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Laboratories_Updated_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Laboratories_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Laboratories]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Laboratories_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Laboratories] ADD  CONSTRAINT [DF_Laboratories_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Operators_Updated_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Operators_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Operators_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Operators] ADD  CONSTRAINT [DF_Operators_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Operators_Created_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Operators_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Operators_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Operators] ADD  CONSTRAINT [DF_Operators_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Operators_Period_Year]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Operators_Period_Year]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Operators_Period_Year]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Operators] ADD  CONSTRAINT [DF_Operators_Period_Year]  DEFAULT (datepart(year,getdate())) FOR [Period_Year]
END


End
GO
/****** Object:  Default [DF_Reservations_Created_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Reservations_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Reservations_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Reservations] ADD  CONSTRAINT [DF_Reservations_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Reservations_Updated_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Reservations_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Reservations_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Reservations] ADD  CONSTRAINT [DF_Reservations_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Software_Created_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Software_Created_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Software]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Software_Created_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Software] ADD  CONSTRAINT [DF_Software_Created_At]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Software_Updated_At]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Software_Updated_At]') AND parent_object_id = OBJECT_ID(N'[dbo].[Software]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Software_Updated_At]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Software] ADD  CONSTRAINT [DF_Software_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Default [DF_Users_created_at]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Users_created_at]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Users_created_at]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_created_at]  DEFAULT (getdate()) FOR [Created_At]
END


End
GO
/****** Object:  Default [DF_Users_updated_at]    Script Date: 08/22/2015 14:51:32 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_Users_updated_at]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Users_updated_at]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_updated_at]  DEFAULT (getdate()) FOR [Updated_At]
END


End
GO
/****** Object:  Check [CK_Reservations_Time]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_Reservations_Time]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [CK_Reservations_Time] CHECK  (([End_Time]>[Start_Time]))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_Reservations_Time]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [CK_Reservations_Time]
GO
/****** Object:  ForeignKey [FK_Administrators_States]    Script Date: 08/22/2015 14:51:31 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Administrators_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Administrators]'))
ALTER TABLE [dbo].[Administrators]  WITH CHECK ADD  CONSTRAINT [FK_Administrators_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Administrators_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Administrators]'))
ALTER TABLE [dbo].[Administrators] CHECK CONSTRAINT [FK_Administrators_States]
GO
/****** Object:  ForeignKey [FK_Administrators_Users]    Script Date: 08/22/2015 14:51:31 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Administrators_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Administrators]'))
ALTER TABLE [dbo].[Administrators]  WITH CHECK ADD  CONSTRAINT [FK_Administrators_Users] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Users] ([PK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Administrators_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Administrators]'))
ALTER TABLE [dbo].[Administrators] CHECK CONSTRAINT [FK_Administrators_Users]
GO
/****** Object:  ForeignKey [FK_Appointments_Laboratories]    Script Date: 08/22/2015 14:51:31 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_Laboratories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Laboratories] FOREIGN KEY([FK_Laboratory_Id])
REFERENCES [dbo].[Laboratories] ([PK_Laboratory_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_Laboratories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Laboratories]
GO
/****** Object:  ForeignKey [FK_Appointments_Software]    Script Date: 08/22/2015 14:51:31 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_Software]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Software] FOREIGN KEY([FK_Software_Id])
REFERENCES [dbo].[Software] ([PK_Software_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_Software]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Software]
GO
/****** Object:  ForeignKey [FK_Appointments_States]    Script Date: 08/22/2015 14:51:31 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_States]
GO
/****** Object:  ForeignKey [FK_Appointments_Students]    Script Date: 08/22/2015 14:51:31 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_Students]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Students] FOREIGN KEY([FK_Student_Id])
REFERENCES [dbo].[Students] ([FK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Appointments_Students]') AND parent_object_id = OBJECT_ID(N'[dbo].[Appointments]'))
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Students]
GO
/****** Object:  ForeignKey [FK_Courses_States]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Courses_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Courses]'))
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [FK_Courses_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Courses_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Courses]'))
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [FK_Courses_States]
GO
/****** Object:  ForeignKey [FK_Groups_Courses]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Groups_Courses]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_Courses] FOREIGN KEY([FK_Course_Id])
REFERENCES [dbo].[Courses] ([PK_Course_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Groups_Courses]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_Groups_Courses]
GO
/****** Object:  ForeignKey [FK_Groups_Periods]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Groups_Periods]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_Periods] FOREIGN KEY([FK_Period_Id])
REFERENCES [dbo].[Periods] ([PK_Period_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Groups_Periods]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_Groups_Periods]
GO
/****** Object:  ForeignKey [FK_Groups_Professors]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Groups_Professors]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_Professors] FOREIGN KEY([FK_Professor_Id])
REFERENCES [dbo].[Professors] ([FK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Groups_Professors]') AND parent_object_id = OBJECT_ID(N'[dbo].[Groups]'))
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_Groups_Professors]
GO
/****** Object:  ForeignKey [FK_Laboratories_States]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Laboratories_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Laboratories]'))
ALTER TABLE [dbo].[Laboratories]  WITH CHECK ADD  CONSTRAINT [FK_Laboratories_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Laboratories_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Laboratories]'))
ALTER TABLE [dbo].[Laboratories] CHECK CONSTRAINT [FK_Laboratories_States]
GO
/****** Object:  ForeignKey [FK_Operators_Periods]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Operators_Periods]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
ALTER TABLE [dbo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_Periods] FOREIGN KEY([FK_Period_Id])
REFERENCES [dbo].[Periods] ([PK_Period_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Operators_Periods]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
ALTER TABLE [dbo].[Operators] CHECK CONSTRAINT [FK_Operators_Periods]
GO
/****** Object:  ForeignKey [FK_Operators_States]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Operators_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
ALTER TABLE [dbo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Operators_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
ALTER TABLE [dbo].[Operators] CHECK CONSTRAINT [FK_Operators_States]
GO
/****** Object:  ForeignKey [FK_Operators_Students]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Operators_Students]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
ALTER TABLE [dbo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_Students] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Students] ([FK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Operators_Students]') AND parent_object_id = OBJECT_ID(N'[dbo].[Operators]'))
ALTER TABLE [dbo].[Operators] CHECK CONSTRAINT [FK_Operators_Students]
GO
/****** Object:  ForeignKey [FK_Periods_PeriodTypes]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Periods_PeriodTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Periods]'))
ALTER TABLE [dbo].[Periods]  WITH CHECK ADD  CONSTRAINT [FK_Periods_PeriodTypes] FOREIGN KEY([FK_Period_Type_Id])
REFERENCES [dbo].[PeriodTypes] ([PK_Period_Type_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Periods_PeriodTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Periods]'))
ALTER TABLE [dbo].[Periods] CHECK CONSTRAINT [FK_Periods_PeriodTypes]
GO
/****** Object:  ForeignKey [FK_Professors_Users]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Professors_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Professors]'))
ALTER TABLE [dbo].[Professors]  WITH CHECK ADD  CONSTRAINT [FK_Professors_Users] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Users] ([PK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Professors_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Professors]'))
ALTER TABLE [dbo].[Professors] CHECK CONSTRAINT [FK_Professors_Users]
GO
/****** Object:  ForeignKey [FK_Reservations_Groups]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Groups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Groups] FOREIGN KEY([FK_Group_Id])
REFERENCES [dbo].[Groups] ([PK_Group_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Groups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Groups]
GO
/****** Object:  ForeignKey [FK_Reservations_Laboratories]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Laboratories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Laboratories] FOREIGN KEY([FK_Laboratory_Id])
REFERENCES [dbo].[Laboratories] ([PK_Laboratory_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Laboratories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Laboratories]
GO
/****** Object:  ForeignKey [FK_Reservations_Professors]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Professors]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Professors] FOREIGN KEY([FK_Professor_Id])
REFERENCES [dbo].[Professors] ([FK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Professors]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Professors]
GO
/****** Object:  ForeignKey [FK_Reservations_Software]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Software]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Software] FOREIGN KEY([FK_Software_Id])
REFERENCES [dbo].[Software] ([PK_Software_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_Software]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Software]
GO
/****** Object:  ForeignKey [FK_Reservations_States]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reservations_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Reservations]'))
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_States]
GO
/****** Object:  ForeignKey [FK_Software_States]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Software_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Software]'))
ALTER TABLE [dbo].[Software]  WITH CHECK ADD  CONSTRAINT [FK_Software_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Software_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Software]'))
ALTER TABLE [dbo].[Software] CHECK CONSTRAINT [FK_Software_States]
GO
/****** Object:  ForeignKey [FK_SoftwareByLaboratory_Laboratories]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SoftwareByLaboratory_Laboratories]') AND parent_object_id = OBJECT_ID(N'[dbo].[SoftwareByLaboratory]'))
ALTER TABLE [dbo].[SoftwareByLaboratory]  WITH CHECK ADD  CONSTRAINT [FK_SoftwareByLaboratory_Laboratories] FOREIGN KEY([FK_Laboratory_Id])
REFERENCES [dbo].[Laboratories] ([PK_Laboratory_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SoftwareByLaboratory_Laboratories]') AND parent_object_id = OBJECT_ID(N'[dbo].[SoftwareByLaboratory]'))
ALTER TABLE [dbo].[SoftwareByLaboratory] CHECK CONSTRAINT [FK_SoftwareByLaboratory_Laboratories]
GO
/****** Object:  ForeignKey [FK_SoftwareByLaboratory_Software]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SoftwareByLaboratory_Software]') AND parent_object_id = OBJECT_ID(N'[dbo].[SoftwareByLaboratory]'))
ALTER TABLE [dbo].[SoftwareByLaboratory]  WITH CHECK ADD  CONSTRAINT [FK_SoftwareByLaboratory_Software] FOREIGN KEY([FK_Software_Id])
REFERENCES [dbo].[Software] ([PK_Software_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SoftwareByLaboratory_Software]') AND parent_object_id = OBJECT_ID(N'[dbo].[SoftwareByLaboratory]'))
ALTER TABLE [dbo].[SoftwareByLaboratory] CHECK CONSTRAINT [FK_SoftwareByLaboratory_Software]
GO
/****** Object:  ForeignKey [FK_Students_Users]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Students_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Students]'))
ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Users] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Users] ([PK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Students_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Students]'))
ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Users]
GO
/****** Object:  ForeignKey [FK_StudentsByGroup_Groups]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentsByGroup_Groups]') AND parent_object_id = OBJECT_ID(N'[dbo].[StudentsByGroup]'))
ALTER TABLE [dbo].[StudentsByGroup]  WITH CHECK ADD  CONSTRAINT [FK_StudentsByGroup_Groups] FOREIGN KEY([FK_Group_Id])
REFERENCES [dbo].[Groups] ([PK_Group_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentsByGroup_Groups]') AND parent_object_id = OBJECT_ID(N'[dbo].[StudentsByGroup]'))
ALTER TABLE [dbo].[StudentsByGroup] CHECK CONSTRAINT [FK_StudentsByGroup_Groups]
GO
/****** Object:  ForeignKey [FK_StudentsByGroup_Students]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentsByGroup_Students]') AND parent_object_id = OBJECT_ID(N'[dbo].[StudentsByGroup]'))
ALTER TABLE [dbo].[StudentsByGroup]  WITH CHECK ADD  CONSTRAINT [FK_StudentsByGroup_Students] FOREIGN KEY([FK_Student_Id])
REFERENCES [dbo].[Students] ([FK_User_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentsByGroup_Students]') AND parent_object_id = OBJECT_ID(N'[dbo].[StudentsByGroup]'))
ALTER TABLE [dbo].[StudentsByGroup] CHECK CONSTRAINT [FK_StudentsByGroup_Students]
GO
/****** Object:  ForeignKey [FK_Users_States]    Script Date: 08/22/2015 14:51:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_States]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_States]
GO


/****** #####             ##### ******/
/****** ##### CREATE USER ##### ******/
/****** #####             ##### ******/


USE [master]
GO

IF NOT EXISTS (SELECT loginname FROM syslogins WHERE name = 'WebServiceLogin' and dbname = 'SiLabI')
BEGIN
	CREATE LOGIN [WebServiceLogin] WITH PASSWORD = 'password', DEFAULT_DATABASE=[SiLabI], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
END
GO

USE [SiLabI]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'WebService')
BEGIN
	CREATE USER [WebService] FOR LOGIN [WebServiceLogin] WITH DEFAULT_SCHEMA=[dbo]
	GRANT EXECUTE TO WebService
	EXEC sp_addrolemember 'db_datareader', 'WebService'
END
GO

USE [master]
GO