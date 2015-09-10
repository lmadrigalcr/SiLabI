/****** #####                 ##### ******/
/****** ##### CREATE DATABASE ##### ******/
/****** #####                 ##### ******/


USE [master]
GO

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'SiLabI')
BEGIN
/****** Object:  Database [SiLabI]    Script Date: 08/11/2015 10:51:00 ******/
CREATE DATABASE [SiLabI] ON  PRIMARY 
( NAME = N'SiLabI', FILENAME = N'C:\SiLabI\SiLabI.mdf' , SIZE = 5072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SiLabI_log', FILENAME = N'C:\SiLabI\SiLabI_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
/****** Object:  StoredProcedure [dbo].[sp_GetGroupsCount]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetGroupsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '') = '')
		SET @where = '1=1';

	SET @sql =	'SELECT COUNT(*) AS count FROM vw_Groups WHERE ' + @where;
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGroups]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetGroups]
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
	SET @fields = COALESCE(@fields, '');
	SET @order_by = COALESCE(@order_by, '');
	SET @where = COALESCE(@where, '');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '')
	BEGIN
		SET @fields = '*';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '') SET @order_by = 'RAND()';
	
	-- SET default WHERE query.
	IF (@where = '') SET @where = '1=1';

	SET @sql =	'SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ' + @order_by + ') AS rn, ' +
				@fields + ' FROM vw_Groups ' +
				'WHERE ' + @where + ') AS Sub WHERE rn >= ' + CAST(@start AS VARCHAR) +
				' AND rn <= ' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetOperatorsCount]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetOperatorsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause. [Nullable]
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '') = '')
		SET @where = '1=1';

	SET @sql =	'SELECT COUNT(*) AS count FROM vw_Operators WHERE ' + @where;
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetOperators]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetOperators]
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
	SET @fields = COALESCE(@fields, '');
	SET @order_by = COALESCE(@order_by, '');
	SET @where = COALESCE(@where, '');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '')
	BEGIN
		SET @fields = '*';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '') SET @order_by = 'RAND()';
	
	-- SET default WHERE query.
	IF (@where = '') SET @where = '1=1';

	SET @sql =	'SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ' + @order_by + ') AS rn, ' +
				@fields + ' FROM vw_Operators ' +
				'WHERE ' + @where + ') AS Sub WHERE rn >= ' + CAST(@start AS VARCHAR) +
				' AND rn <= ' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAdministratorsCount]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAdministratorsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '') = '')
		SET @where = '1=1';

	SET @sql =	'SELECT COUNT(*) AS count FROM vw_Administrators WHERE ' + @where;
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAdministrators]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAdministrators]
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
	SET @fields = COALESCE(@fields, '');
	SET @order_by = COALESCE(@order_by, '');
	SET @where = COALESCE(@where, '');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '')
	BEGIN
		SET @fields = '*';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '') SET @order_by = 'RAND()';
	
	-- SET default WHERE query.
	IF (@where = '') SET @where = '1=1';

	SET @sql =	'SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ' + @order_by + ') AS rn, ' +
				@fields + ' FROM vw_Administrators ' +
				'WHERE ' + @where + ') AS Sub WHERE rn >= ' + CAST(@start AS VARCHAR) +
				' AND rn <= ' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCoursesCount]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetCoursesCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '') = '')
		SET @where = '1=1';

	SET @sql =	'SELECT COUNT(*) AS count FROM vw_Courses WHERE ' + @where;
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCourses]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetCourses]
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
	SET @fields = COALESCE(@fields, '');
	SET @order_by = COALESCE(@order_by, '');
	SET @where = COALESCE(@where, '');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '')
	BEGIN
		SET @fields = '*';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '') SET @order_by = 'RAND()';
	
	-- SET default WHERE query.
	IF (@where = '') SET @where = '1=1';

	SET @sql =	'SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ' + @order_by + ') AS rn, ' +
				@fields + ' FROM vw_Courses ' +
				'WHERE ' + @where + ') AS Sub WHERE rn >= ' + CAST(@start AS VARCHAR) +
				' AND rn <= ' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProfessorsCount]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProfessorsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '') = '')
		SET @where = '1=1';

	SET @sql =	'SELECT COUNT(*) AS count FROM vw_Professors WHERE ' + @where;
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProfessors]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProfessors]
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
	SET @fields = COALESCE(@fields, '');
	SET @order_by = COALESCE(@order_by, '');
	SET @where = COALESCE(@where, '');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '')
	BEGIN
		SET @fields = '*';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '') SET @order_by = 'RAND()';
	
	-- SET default WHERE query.
	IF (@where = '') SET @where = '1=1';

	SET @sql =	'SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ' + @order_by + ') AS rn, ' +
				@fields + ' FROM vw_Professors ' +
				'WHERE ' + @where + ') AS Sub WHERE rn >= ' + CAST(@start AS VARCHAR) +
				' AND rn <= ' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudents]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetStudents]
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
	SET @fields = COALESCE(@fields, '');
	SET @order_by = COALESCE(@order_by, '');
	SET @where = COALESCE(@where, '');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '')
	BEGIN
		SET @fields = '*';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '') SET @order_by = 'RAND()';
	
	-- SET default WHERE query.
	IF (@where = '') SET @where = '1=1';

	SET @sql =	'SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ' + @order_by + ') AS rn, ' +
				@fields + ' FROM vw_Students ' +
				'WHERE ' + @where + ') AS Sub WHERE rn >= ' + CAST(@start AS VARCHAR) +
				' AND rn <= ' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUsersCount]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUsersCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '') = '')
		SET @where = '1=1';

	SET @sql =	'SELECT COUNT(*) AS count FROM vw_Users WHERE ' + @where;
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUsers]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUsers]
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
	SET @fields = COALESCE(@fields, '');
	SET @order_by = COALESCE(@order_by, '');
	SET @where = COALESCE(@where, '');
	SET @page = COALESCE(@page, 1);
	SET @limit = COALESCE(@limit, 20);
	
	-- SET the start and end rows.
	SET @start = ((@page - 1) * @limit) + 1;
	SET @end = @page * @limit;
	
	-- SET default fields to retrieve.
	IF (@fields = '')
	BEGIN
		SET @fields = '*';
	END
	
	-- SET default ORDER BY query.
	IF (@order_by = '') SET @order_by = 'RAND()';
	
	-- SET default WHERE query.
	IF (@where = '') SET @where = '1=1';

	SET @sql =	'SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ' + @order_by + ') AS rn, ' +
				@fields + ' FROM vw_Users ' +
				'WHERE ' + @where + ') AS Sub WHERE rn >= ' + CAST(@start AS VARCHAR) +
				' AND rn <= ' + CAST(@end AS VARCHAR);
				
	EXECUTE(@sql); 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudentsCount]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetStudentsCount]
(
	@where		VARCHAR(MAX)	-- The fields to include in the WHERE clause.
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);

	-- SET default values.	
	IF (COALESCE(@where, '') = '')
		SET @where = '1=1';

	SET @sql =	'SELECT COUNT(*) AS count FROM vw_Students WHERE ' + @where;
				
	EXECUTE(@sql); 
END
GO
/****** Object:  UserDefinedTableType [dbo].[UserList]    Script Date: 09/10/2015 16:08:34 ******/
CREATE TYPE [dbo].[UserList] AS TABLE(
	[Username] [varchar](70) NULL
)
GO
/****** Object:  Table [dbo].[States]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[States](
	[PK_State_Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](30) NOT NULL,
	[Name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED 
(
	[PK_State_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PeriodTypes]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PeriodTypes](
	[PK_Period_Type_Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Max_Value] [int] NOT NULL,
 CONSTRAINT [PK_PeriodTypes] PRIMARY KEY CLUSTERED 
(
	[PK_Period_Type_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fn_NullableField]    Script Date: 09/10/2015 16:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
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
		WHEN @param = '' THEN NULL
		ELSE @param
	END
	
	RETURN @value;
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CurrentIP]    Script Date: 09/10/2015 16:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_CurrentIP] ()
RETURNS varchar(255)
AS
BEGIN
    DECLARE @IP_Address varchar(255);

    SELECT @IP_Address = client_net_address
    FROM sys.dm_exec_connections
    WHERE Session_id = @@SPID;
    
    IF (@IP_Address = '<local machine>')
	BEGIN
		SET @IP_Address = '127.0.0.1';
	END

    Return @IP_Address;
END
GO
/****** Object:  Table [dbo].[Users]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StateId]    Script Date: 09/10/2015 16:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_StateId]
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
END
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Courses_Code] UNIQUE NONCLUSTERED 
(
	[PK_Course_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Periods]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Periods](
	[PK_Period_Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [int] NOT NULL,
	[FK_Period_Type_Id] [int] NOT NULL,
 CONSTRAINT [PK_Periods] PRIMARY KEY CLUSTERED 
(
	[PK_Period_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Software]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Laboratories]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Professors]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professors](
	[FK_User_Id] [int] NOT NULL,
 CONSTRAINT [IX_Professors_User_Id] UNIQUE NONCLUSTERED 
(
	[FK_User_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Administrators]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateUser]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateUser]
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
	WHERE S.Type = 'USER' AND S.Name = 'Activo';
	
	SET @id = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateUser]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateUser]
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
	@state			VARCHAR(30)		-- The state. ('active', 'disabled', 'blocked')
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF EXISTS (SELECT 1 FROM Users WHERE Username = @username AND PK_User_Id <> @id)
	BEGIN
		RAISERROR('Ya existe un usuario con identificado como %s.', 15, 1, @username);
		RETURN -1;
	END

	UPDATE Users
	SET[Name] = ISNULL(@name, [Name]),
	[Last_Name_1] = ISNULL(@last_name_1, [Last_Name_1]),
	[Last_Name_2] =  CAST(dbo.fn_NullableField(@last_name_2, [Last_Name_2]) AS VARCHAR(70)),
	[Username] = ISNULL(@username, [Username]),
	[Password] = ISNULL(@password, [Password]),
	[Email] = CAST(dbo.fn_NullableField(@email, [Email]) AS VARCHAR(100)),
	[Phone] =  CAST(dbo.fn_NullableField(@phone, [Phone]) AS VARCHAR(20)),
	[Gender] = ISNULL(@gender, [Gender]),
	[FK_State_Id] = ISNULL(dbo.fn_StateId('USER', @state), [FK_State_Id]),
	[Updated_At] = GETDATE()
	WHERE PK_User_Id = @id;
END
GO
/****** Object:  Table [dbo].[Students]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[FK_User_Id] [int] NOT NULL,
 CONSTRAINT [IX_Students_User_Id] UNIQUE NONCLUSTERED 
(
	[FK_User_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteCourse]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteCourse]
(
	@id		INT		-- The course id.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if course exists.
	IF NOT EXISTS (SELECT 1 FROM Courses WHERE PK_Course_Id = @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Curso no encontrado.', 15, 1);
		RETURN -1;
	END
	
	UPDATE Courses
	SET [FK_State_Id] = ISNULL(dbo.fn_StateId('COURSE', 'Inactivo'), [FK_State_Id]),
	[Updated_At] = GETDATE()
	WHERE [PK_Course_Id] = @id;
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  Table [dbo].[SoftwareByLaboratory]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SoftwareByLaboratory](
	[FK_Software_Id] [int] NOT NULL,
	[FK_Laboratory_Id] [int] NOT NULL,
 CONSTRAINT [IX_SoftwareByLaboratory] UNIQUE NONCLUSTERED 
(
	[FK_Software_Id] ASC,
	[FK_Laboratory_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_Courses]    Script Date: 09/10/2015 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Courses] AS
SELECT C.PK_Course_Id AS Id, C.Code, C.Name, C.Created_At, C.Updated_At, S.Name AS State
FROM Courses AS C
INNER JOIN States AS S ON C.FK_State_Id = S.PK_State_Id;
GO
/****** Object:  View [dbo].[vw_Administrators]    Script Date: 09/10/2015 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Administrators]
AS
SELECT     U.PK_User_Id AS id, U.Name, U.Last_Name_1, U.Last_Name_2, RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS full_name, U.Email, 
                      U.Gender, U.Phone, U.Username, A.Created_At, A.Updated_At, S.Name AS state
FROM         dbo.Administrators AS A INNER JOIN
                      dbo.Users AS U ON A.FK_User_Id = U.PK_User_Id INNER JOIN
                      dbo.States AS S ON A.FK_State_Id = S.PK_State_Id
GO
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
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 68
               Left = 512
               Bottom = 161
               Right = 663
            End
            DisplayFlags = 280
            TopColumn = 0
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Administrators'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Administrators'
GO
/****** Object:  View [dbo].[vw_Students]    Script Date: 09/10/2015 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Students]
AS
SELECT     U.PK_User_Id AS id, U.Name, U.Last_Name_1, U.Last_Name_2, RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS full_name, U.Email, 
                      U.Gender, U.Phone, U.Username, U.Created_At, U.Updated_At, E.Name AS state
FROM         dbo.Students AS S INNER JOIN
                      dbo.Users AS U ON S.FK_User_Id = U.PK_User_Id INNER JOIN
                      dbo.States AS E ON U.FK_State_Id = E.PK_State_Id
GO
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
         Begin Table = "S"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 69
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "E"
            Begin Extent = 
               Top = 72
               Left = 38
               Bottom = 165
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Students'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Students'
GO
/****** Object:  View [dbo].[vw_Professors]    Script Date: 09/10/2015 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Professors]
AS
SELECT     U.PK_User_Id AS id, U.Name, U.Last_Name_1, U.Last_Name_2, RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS full_name, U.Email, 
                      U.Gender, U.Phone, U.Username, U.Created_At, U.Updated_At, S.Name AS state
FROM         dbo.Professors AS P INNER JOIN
                      dbo.Users AS U ON P.FK_User_Id = U.PK_User_Id INNER JOIN
                      dbo.States AS S ON U.FK_State_Id = S.PK_State_Id
GO
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
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 69
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 72
               Left = 38
               Bottom = 165
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Professors'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Professors'
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCourse]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetCourse]
(
	@id		INT		-- The course id.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM vw_Courses WHERE Id = @id;
END
GO
/****** Object:  Table [dbo].[Operators]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operators](
	[PK_Operator_Id] [int] IDENTITY(1,1) NOT NULL,
	[FK_User_Id] [int] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Period_Year] [int] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
	[FK_Period_Id] [int] NOT NULL,
 CONSTRAINT [PK_Operators] PRIMARY KEY CLUSTERED 
(
	[PK_Operator_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Operators] UNIQUE NONCLUSTERED 
(
	[FK_User_Id] ASC,
	[FK_Period_Id] ASC,
	[Period_Year] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Appointments]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteStudent]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteStudent]
(
	@user_id	INT		-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	IF NOT EXISTS (SELECT 1 FROM Students WHERE FK_User_Id = @user_id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Estudiante no encontrado.', 15, 1);
		RETURN -1;
	END
	
	UPDATE Users
	SET FK_State_Id = dbo.fn_StateId('USER', 'Inactivo'),
	Updated_At = GETDATE()
	WHERE PK_User_Id = @user_id;
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteProfessor]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteProfessor]
(
	@user_id	INT		-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	IF NOT EXISTS (SELECT 1 FROM Professors WHERE FK_User_Id = @user_id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Docente no encontrado.', 15, 1);
		RETURN -1;
	END
	
	UPDATE Users
	SET FK_State_Id = dbo.fn_StateId('USER', 'Inactivo'),
	Updated_At = GETDATE()
	WHERE PK_User_Id = @user_id;
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[PK_Group_Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [int] NOT NULL,
	[Period_Year] [int] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NOT NULL,
	[FK_Course_Id] [int] NOT NULL,
	[FK_Professor_Id] [int] NOT NULL,
	[FK_Period_Id] [int] NOT NULL,
	[FK_State_Id] [int] NOT NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[PK_Group_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Groups] UNIQUE NONCLUSTERED 
(
	[Number] ASC,
	[FK_Professor_Id] ASC,
	[FK_Course_Id] ASC,
	[FK_Period_Id] ASC,
	[Period_Year] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_UserType]    Script Date: 09/10/2015 16:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_UserType](@UserId INT)
RETURNS VARCHAR(30)
AS
BEGIN
	IF EXISTS 
	(
		SELECT 1 FROM Administrators AS A
		INNER JOIN States AS S ON S.PK_State_Id = A.FK_State_Id
		WHERE A.FK_User_Id = @UserId AND S.Type = 'ADMINISTRATOR' AND S.Name = 'Activo'
	)
    RETURN 'Administrador'

    IF EXISTS
	(
		SELECT 1 FROM Operators AS O
		INNER JOIN States AS S ON S.PK_State_Id = O.FK_State_Id
		WHERE O.FK_User_Id = @UserId AND S.Type = 'OPERATOR' AND S.Name = 'Activo'
	)
	RETURN 'Operador'
    
    IF EXISTS (SELECT 1 FROM Students WHERE FK_User_Id = @UserId)
    RETURN 'Estudiante'
    
    IF EXISTS (SELECT 1 FROM Professors WHERE FK_User_Id = @UserId)
    RETURN 'Docente'
    
    RETURN NULL
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteOperator]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteOperator]
(
	@operator_id	INT		-- The operator ID.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE Operators
	SET FK_State_Id = dbo.fn_StateId('OPERATOR', 'Inactivo'),
		Updated_At = GETDATE()
	WHERE
		PK_Operator_Id = @operator_id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteGroup]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteGroup]
(
	@id		INT		-- The group id.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if group exists.
	IF NOT EXISTS (SELECT 1 FROM Groups WHERE PK_Group_Id = @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Grupo no encontrado.', 15, 1);
		RETURN -1;
	END
	
	UPDATE Groups
	SET FK_State_Id = dbo.fn_StateId('GROUP', 'Inactivo'),
	Updated_At = GETDATE()
	WHERE PK_Group_Id = @id;
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  Table [dbo].[Reservations]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateCourse]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateCourse]
(
	@name	VARCHAR(500),	-- The course name.
	@code	VARCHAR(20)		-- The course code.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if course exists.
	IF EXISTS (SELECT 1 FROM Courses WHERE Code = @code)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un curso con el código %s.', 15, 1, @code);
		RETURN -1;
	END
	
	DECLARE @id INT;
	INSERT INTO Courses (Name, Code, FK_State_Id) VALUES
	(@name, @code, dbo.fn_StateId('COURSE', 'Activo'));
	SET @id = SCOPE_IDENTITY();
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetCourse @id;
END
GO
/****** Object:  Table [dbo].[StudentsByGroup]    Script Date: 09/10/2015 16:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentsByGroup](
	[FK_Student_Id] [int] NOT NULL,
	[FK_Group_Id] [int] NOT NULL,
 CONSTRAINT [IX_StudentsByGroup] UNIQUE NONCLUSTERED 
(
	[FK_Student_Id] ASC,
	[FK_Group_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateStudent]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateStudent]
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
	@state			VARCHAR(30)		-- The state. ('active', 'disabled', 'blocked')
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if student exists.
	IF NOT EXISTS (SELECT 1 FROM vw_Students WHERE Id = @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Estudiante no encontrado.', 15, 1);
		RETURN -1;
	END
	ELSE
	BEGIN
		EXEC dbo.sp_UpdateUser @id, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone, @state;
		COMMIT TRANSACTION T;
	END
	
	SELECT * FROM vw_Students WHERE id = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProfessor]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateProfessor]
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
	@state			VARCHAR(30)		-- The state. ('active', 'disabled', 'blocked')
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if professor exists.
	IF NOT EXISTS (SELECT 1 FROM vw_Professors WHERE Id = @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Docente no encontrado.', 15, 1);
		RETURN -1;
	END
	
	EXEC dbo.sp_UpdateUser @id, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone, @state;
	COMMIT TRANSACTION T;
	
	SELECT * FROM vw_Professors WHERE id = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudentByUsername]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetStudentByUsername]
(
	@username VARCHAR(70)	-- The username.
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM vw_Students WHERE Username = @username;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudent]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetStudent]
(
	@id INT	-- The identification.
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM vw_Students WHERE id = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProfessorByUsername]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProfessorByUsername]
(
	@username VARCHAR(70)	-- The username.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM vw_Professors WHERE Username = @username;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProfessor]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProfessor]
(
	@id INT	-- The identification.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM vw_Professors WHERE id = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCourse]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateCourse]
(
	@id		INT,			-- The course id.
	@name	VARCHAR(500),	-- The course name.
	@code	VARCHAR(20),	-- The course code.
	@state	VARCHAR(30)		-- The course state.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if course exists.
	IF NOT EXISTS (SELECT 1 FROM Courses WHERE PK_Course_Id = @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Curso no encontrado.', 15, 1);
		RETURN -1;
	END
	
	-- Check if course exists.
	IF EXISTS (SELECT 1 FROM Courses WHERE Code = @code AND PK_Course_Id <> @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un curso con el código %s.', 15, 1, @code);
		RETURN -1;
	END
	
	UPDATE Courses
	SET [Code] = ISNULL(@code, [Code]),
	[Name] = ISNULL(@name, [Name]),
	[FK_State_Id] = ISNULL(dbo.fn_StateId('COURSE', @state), [FK_State_Id]),
	[Updated_At] = GETDATE()
	WHERE [PK_Course_Id] = @id;
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetCourse @id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteAdministrator]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteAdministrator]
(
	@user_id INT	-- The User Id.
)
AS
BEGIN
	BEGIN TRANSACTION T;
	DECLARE @count INT, @state VARCHAR(30);
	SELECT @count = COUNT(*) FROM vw_Administrators WHERE [state] = 'Activo';
	SELECT @state = [state] FROM vw_Administrators WHERE [id] = @user_id;
	
	IF (@count = 1 AND @state = 'Activo')
	BEGIN
		RAISERROR('No se puede eliminar este administrador.', 15, 1);
		ROLLBACK TRANSACTION T;
		RETURN -1;
	END
	
	UPDATE Administrators
	SET FK_State_Id = dbo.fn_StateId('ADMINISTRATOR', 'Inactivo'),
		Updated_At = GETDATE()
	WHERE FK_User_Id = @user_id;
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAdministrator]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAdministrator]
(
	@user_id INT	-- The User Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM vw_Administrators WHERE Id = @user_id;
END
GO
/****** Object:  View [dbo].[vw_Operators]    Script Date: 09/10/2015 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Operators]
AS
SELECT     O.PK_Operator_Id AS id, U.Name, U.Last_Name_1, U.Last_Name_2, RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS full_name, U.Email, 
                      U.Gender, U.Phone, U.Username, O.Created_At, O.Updated_At, P.Value AS [period.value], PT.Name AS [period.type], O.Period_Year AS [period.year], 
                      S.Name AS state
FROM         dbo.Operators AS O INNER JOIN
                      dbo.Users AS U ON O.FK_User_Id = U.PK_User_Id INNER JOIN
                      dbo.Periods AS P ON O.FK_Period_Id = P.PK_Period_Id INNER JOIN
                      dbo.PeriodTypes AS PT ON P.FK_Period_Type_Id = PT.PK_Period_Type_Id INNER JOIN
                      dbo.States AS S ON O.FK_State_Id = S.PK_State_Id
GO
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
         Begin Table = "O"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 196
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 234
               Bottom = 114
               Right = 385
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 207
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PT"
            Begin Extent = 
               Top = 114
               Left = 250
               Bottom = 207
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 210
               Left = 38
               Bottom = 303
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Operators'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Operators'
GO
/****** Object:  View [dbo].[vw_Groups]    Script Date: 09/10/2015 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Groups] AS
SELECT G.PK_Group_Id AS id, G.Number AS number, G.FK_Course_Id AS course, G.FK_Professor_Id AS professor,
P.Value AS [period.value], PT.Name AS [period.type], G.Period_Year AS [period.year], S.Name AS state,
G.Created_At AS created_at, G.Updated_At AS updated_at
FROM Groups AS G
INNER JOIN States AS S ON G.FK_State_Id = S.PK_State_Id
INNER JOIN Periods AS P ON G.FK_Period_Id = P.PK_Period_Id
INNER JOIN PeriodTypes AS PT ON P.FK_Period_Type_Id = PT.PK_Period_Type_Id;
GO
/****** Object:  View [dbo].[vw_Users]    Script Date: 09/10/2015 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Users]
AS
SELECT     U.PK_User_Id AS id, U.Name, U.Last_Name_1, U.Last_Name_2, RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS Full_Name, 
                      U.Username, U.Email, U.Gender, U.Phone, U.Created_At, U.Updated_At, dbo.fn_UserType(U.PK_User_Id) AS Type, S.Name AS State
FROM         dbo.Users AS U INNER JOIN
                      dbo.States AS S ON U.FK_State_Id = S.PK_State_Id
GO
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
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 99
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
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
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Users'
GO
/****** Object:  StoredProcedure [dbo].[sp_GetOperator]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetOperator]
(
	@operator_id INT	-- The Operator Id.
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM vw_Operators WHERE Id = @operator_id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGroupStudents]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetGroupStudents]
(
	@group INT			-- The group id.
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM vw_Students WHERE id IN (SELECT FK_Student_Id FROM StudentsByGroup WHERE FK_Group_Id = @group);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGroup]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetGroup]
(
	@id		INT		-- The group id.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM vw_Groups WHERE id = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudentsByGroup]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetStudentsByGroup]
(
	@group INT	-- The group id.
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM vw_Students WHERE id IN (SELECT FK_Student_Id FROM StudentsByGroup WHERE FK_Group_Id = @group);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RemoveStudentsFromGroup]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RemoveStudentsFromGroup]
(
	@group INT,						-- The group id.
	@students AS UserList READONLY	-- The list of students usernames.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	DELETE StudentsByGroup
	WHERE FK_Group_Id = @group
	AND FK_Student_Id IN (SELECT U.PK_User_Id FROM @students AS S INNER JOIN Users AS U ON S.Username = U.Username);
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateAdministrator]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateAdministrator]
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
		SET FK_State_Id = dbo.fn_StateId('ADMINISTRATOR', 'Activo'),
			Updated_At = GETDATE()
		WHERE FK_User_Id = @user_id
	END
	-- Administrator doesn't exist yet, has to be inserted.
	ELSE
	BEGIN
		INSERT INTO Administrators (FK_User_Id, FK_State_Id)
		SELECT @user_id, dbo.fn_StateId('ADMINISTRATOR', 'Activo');
	END
	
	EXEC dbo.sp_GetAdministrator @user_id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Authenticate]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
		RTRIM(U.Name + ' ' + U.Last_Name_1 + ' ' + ISNULL(U.Last_Name_2, '')) AS full_name,
		U.Gender AS gender, U.Email AS email, U.Phone AS phone,
		U.Created_At AS created_at, U.Updated_At AS updated_at,
		dbo.fn_UserType(U.PK_User_Id) AS type
	FROM Users AS U
	INNER JOIN States AS S ON S.PK_State_Id = U.FK_State_Id 
	WHERE U.Username = @username AND U.Password = @password AND S.Name = 'Activo';
END
GO
/****** Object:  StoredProcedure [dbo].[sp_AddStudentsToGroup]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AddStudentsToGroup]
(
	@group INT,						-- The group id.
	@students AS UserList READONLY	-- The list of students usernames.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	INSERT INTO StudentsByGroup(FK_Group_Id, FK_Student_Id)
	SELECT @group, U.PK_User_Id
	FROM @students AS S
	INNER JOIN Users AS U ON U.Username = S.Username
	WHERE NOT EXISTS (SELECT 1 FROM StudentsByGroup WHERE FK_Group_Id = @group AND FK_Student_Id = U.PK_User_Id);
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateStudent]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateStudent]
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
	
	-- Check if user exists.
	IF EXISTS (SELECT 1 FROM Users WHERE Username = @username)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un usuario con el username [%s].', 15, 1, @username);
		RETURN -1;
	END
	
	DECLARE @id INT;
	EXEC dbo.sp_CreateUser @id OUTPUT, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone;
	INSERT INTO Students (FK_User_Id) VALUES(@id);
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetStudent @username;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateProfessor]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateProfessor]
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
	
	-- Check if user exists.
	IF EXISTS (SELECT 1 FROM Users WHERE Username = @username)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un usuario con el username [%s].', 15, 1, @username);
		RETURN -1;
	END
	
	DECLARE @id INT;
	EXEC dbo.sp_CreateUser @id OUTPUT, @name, @last_name_1, @last_name_2, @gender, @username, @password, @email, @phone;
	INSERT INTO Professors (FK_User_Id) VALUES(@id);
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetProfessor @username;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateOperator]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateOperator]
(
	@user_id		INT,		 -- The user ID.
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
		SET FK_State_Id = dbo.fn_StateId('OPERATOR', 'Activo'),
			Updated_At = GETDATE()
		WHERE FK_User_Id = @user_id AND FK_Period_Id = @period_id AND Period_Year = @period_year
	END
	ELSE
	BEGIN
		-- Operator doesn't exist yet, has to be inserted.
		INSERT INTO Operators (FK_User_Id, FK_Period_Id, Period_Year, FK_State_Id)
		SELECT @user_id, @period_id, @period_year, dbo.fn_StateId('OPERATOR', 'Activo');
		SET @operator_id = SCOPE_IDENTITY();
	END
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetOperator @operator_id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateGroup]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateGroup]
(
	@course	VARCHAR(20),			-- The course code.
	@number	INT,					-- The group number.
	@professor VARCHAR(70),			-- The professor username.
	@period_value	INT,			-- The period value. (1, 2, ...)
	@period_type	VARCHAR(50),	-- The period type ('Semestre', 'Bimestre', ...)
	@period_year	INT,			-- The year. (2014, 2015, ...)
	@students AS UserList READONLY	-- The list of students usernames.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	DECLARE @groupId INT, @courseId INT, @professorId INT, @periodId INT;
	SELECT @courseId = PK_Course_Id FROM Courses WHERE Code = @course;
	SELECT @professorId = PK_User_Id FROM Users WHERE Username = @professor;
	SELECT @periodId = PK_Period_Id FROM Periods INNER JOIN PeriodTypes ON FK_Period_Type_Id = PK_Period_Type_Id WHERE Value = @period_value AND Name = @period_type;
	
	IF @courseId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El curso ingresado no existe: %s.', 15, 1, @course);
		RETURN -1;
	END
	
	IF @professorId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El profesor ingresado no existe: %s.', 15, 1, @professor);
		RETURN -1;
	END
	
	IF @courseId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El periodo ingresado es inválido.', 15, 1);
		RETURN -1;
	END
	
	-- Check if group exists.
	IF EXISTS (SELECT 1 FROM Groups WHERE FK_Course_Id = @courseId AND FK_Professor_Id = @professorId AND FK_Period_Id = @periodId AND Period_Year = @period_year AND Number = @number)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un grupo con estos datos.', 15, 1);
		RETURN -1;
	END
	
	INSERT INTO Groups(FK_Course_Id, FK_Professor_Id, FK_Period_Id, Period_Year, Number, FK_State_Id) VALUES
	(@courseId, @professorId, @periodId, @period_year, @number, dbo.fn_StateId('GROUP', 'Activo'));
	SET @groupId = SCOPE_IDENTITY();
	
	IF EXISTS (SELECT 1 FROM @students)
	BEGIN
		EXEC dbo.sp_AddStudentsToGroup @groupId, @students;
	END
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetGroup @groupId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUser]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUser]
(
	@username VARCHAR(70)	-- The Username.
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM vw_Users WHERE Username = @username;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateGroupStudents]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateGroupStudents]
(
	@group INT,						-- The group id.
	@students AS UserList READONLY	-- The list of students usernames.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	DELETE StudentsByGroup
	WHERE FK_Group_Id = @group;
	
	EXEC dbo.sp_AddStudentsToGroup @group, @students;
	
	COMMIT TRANSACTION T;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateGroup]    Script Date: 09/10/2015 16:08:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateGroup]
(
	@id	INT,						-- The group id.
	@course	VARCHAR(20),			-- The course code.
	@number	INT,					-- The group number.
	@professor VARCHAR(70),			-- The professor username.
	@period_value	INT,			-- The period value. (1, 2, ...)
	@period_type	VARCHAR(50),	-- The period type ('Semestre', 'Bimestre', ...)
	@period_year	INT,			-- The year. (2014, 2015, ...)
	@state VARCHAR(30),				-- The group state.
	@students AS UserList READONLY	-- The list of students usernames.
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION T;
	
	-- Check if group exists.
	IF NOT EXISTS (SELECT 1 FROM Groups WHERE PK_Group_Id = @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Grupo no encontrado.', 15, 1);
		RETURN -1;
	END
	
	DECLARE @courseId INT, @professorId INT, @periodId INT;
	SELECT @courseId = PK_Course_Id FROM Courses WHERE Code = @course;
	SELECT @professorId = PK_User_Id FROM Users WHERE Username = @professor;
	SELECT @periodId = PK_Period_Id FROM Periods INNER JOIN PeriodTypes ON FK_Period_Type_Id = PK_Period_Type_Id WHERE Value = @period_value AND Name = @period_type;
	
	IF @course IS NOT NULL AND @courseId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El curso ingresado no existe: %s.', 15, 1, @course);
		RETURN -1;
	END
	
	IF @professor IS NOT NULL AND @professorId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El profesor ingresado no existe: %s.', 15, 1, @professor);
		RETURN -1;
	END
	
	IF (@period_value IS NOT NULL OR @period_type IS NOT NULL) AND @periodId IS NULL
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('El periodo ingresado es inválido.', 15, 1);
		RETURN -1;
	END
	
	-- Check if group exists.
	IF EXISTS (SELECT 1 FROM Groups WHERE FK_Course_Id = @courseId AND FK_Professor_Id = @professorId AND FK_Period_Id = @periodId AND Period_Year = @period_year AND Number = @number AND PK_Group_Id <> @id)
	BEGIN
		ROLLBACK TRANSACTION T;
		RAISERROR('Ya existe un grupo con estos datos.', 15, 1);
		RETURN -1;
	END
	
	UPDATE Groups
	SET FK_Course_Id = ISNULL(@courseId, FK_Course_Id),
	FK_Professor_Id = ISNULL(@professorId, FK_Professor_Id),
	FK_Period_Id = ISNULL(@periodId, FK_Period_Id),
	FK_State_Id = ISNULL(dbo.fn_StateId('GROUP', @state), FK_State_Id),
	Number = ISNULL(@number, Number),
	Period_Year = ISNULL(@period_year, Period_Year)
	WHERE PK_Group_Id = @id;
	
	IF EXISTS (SELECT 1 FROM @students)
	BEGIN
		EXEC dbo.sp_UpdateGroupstudents @id, @students;
	END
	
	COMMIT TRANSACTION T;
	EXEC dbo.sp_GetGroup @id;
END
GO
/****** Object:  Default [DF_Administrators_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Administrators] ADD  CONSTRAINT [DF_Administrators_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Administrators_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Administrators] ADD  CONSTRAINT [DF_Administrators_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Appointments_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Appointments] ADD  CONSTRAINT [DF_Appointments_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Appointments_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Appointments] ADD  CONSTRAINT [DF_Appointments_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Courses_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Courses] ADD  CONSTRAINT [DF_Courses_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Courses_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Courses] ADD  CONSTRAINT [DF_Courses_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Groups_Period_Year]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_Period_Year]  DEFAULT (datepart(year,getdate())) FOR [Period_Year]
GO
/****** Object:  Default [DF_Groups_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Groups_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Laboratories_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Laboratories] ADD  CONSTRAINT [DF_Laboratories_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Laboratories_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Laboratories] ADD  CONSTRAINT [DF_Laboratories_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Operators_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Operators] ADD  CONSTRAINT [DF_Operators_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Operators_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Operators] ADD  CONSTRAINT [DF_Operators_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Operators_Period_Year]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Operators] ADD  CONSTRAINT [DF_Operators_Period_Year]  DEFAULT (datepart(year,getdate())) FOR [Period_Year]
GO
/****** Object:  Default [DF_Reservations_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations] ADD  CONSTRAINT [DF_Reservations_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Reservations_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations] ADD  CONSTRAINT [DF_Reservations_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Software_Created_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Software] ADD  CONSTRAINT [DF_Software_Created_At]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Software_Updated_At]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Software] ADD  CONSTRAINT [DF_Software_Updated_At]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Default [DF_Users_created_at]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_created_at]  DEFAULT (getdate()) FOR [Created_At]
GO
/****** Object:  Default [DF_Users_updated_at]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_updated_at]  DEFAULT (getdate()) FOR [Updated_At]
GO
/****** Object:  Check [CK_Reservations_Time]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [CK_Reservations_Time] CHECK  (([End_Time]>[Start_Time]))
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [CK_Reservations_Time]
GO
/****** Object:  ForeignKey [FK_Administrators_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Administrators]  WITH CHECK ADD  CONSTRAINT [FK_Administrators_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Administrators] CHECK CONSTRAINT [FK_Administrators_States]
GO
/****** Object:  ForeignKey [FK_Administrators_Users]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Administrators]  WITH CHECK ADD  CONSTRAINT [FK_Administrators_Users] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Users] ([PK_User_Id])
GO
ALTER TABLE [dbo].[Administrators] CHECK CONSTRAINT [FK_Administrators_Users]
GO
/****** Object:  ForeignKey [FK_Appointments_Laboratories]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Laboratories] FOREIGN KEY([FK_Laboratory_Id])
REFERENCES [dbo].[Laboratories] ([PK_Laboratory_Id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Laboratories]
GO
/****** Object:  ForeignKey [FK_Appointments_Software]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Software] FOREIGN KEY([FK_Software_Id])
REFERENCES [dbo].[Software] ([PK_Software_Id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Software]
GO
/****** Object:  ForeignKey [FK_Appointments_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_States]
GO
/****** Object:  ForeignKey [FK_Appointments_Students]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Students] FOREIGN KEY([FK_Student_Id])
REFERENCES [dbo].[Students] ([FK_User_Id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Students]
GO
/****** Object:  ForeignKey [FK_Courses_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [FK_Courses_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [FK_Courses_States]
GO
/****** Object:  ForeignKey [FK_Groups_Courses]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_Courses] FOREIGN KEY([FK_Course_Id])
REFERENCES [dbo].[Courses] ([PK_Course_Id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_Groups_Courses]
GO
/****** Object:  ForeignKey [FK_Groups_Periods]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_Periods] FOREIGN KEY([FK_Period_Id])
REFERENCES [dbo].[Periods] ([PK_Period_Id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_Groups_Periods]
GO
/****** Object:  ForeignKey [FK_Groups_Professors]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_Professors] FOREIGN KEY([FK_Professor_Id])
REFERENCES [dbo].[Professors] ([FK_User_Id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_Groups_Professors]
GO
/****** Object:  ForeignKey [FK_Groups_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_Groups_States]
GO
/****** Object:  ForeignKey [FK_Laboratories_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Laboratories]  WITH CHECK ADD  CONSTRAINT [FK_Laboratories_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Laboratories] CHECK CONSTRAINT [FK_Laboratories_States]
GO
/****** Object:  ForeignKey [FK_Operators_Periods]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_Periods] FOREIGN KEY([FK_Period_Id])
REFERENCES [dbo].[Periods] ([PK_Period_Id])
GO
ALTER TABLE [dbo].[Operators] CHECK CONSTRAINT [FK_Operators_Periods]
GO
/****** Object:  ForeignKey [FK_Operators_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Operators] CHECK CONSTRAINT [FK_Operators_States]
GO
/****** Object:  ForeignKey [FK_Operators_Students]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_Students] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Students] ([FK_User_Id])
GO
ALTER TABLE [dbo].[Operators] CHECK CONSTRAINT [FK_Operators_Students]
GO
/****** Object:  ForeignKey [FK_Periods_PeriodTypes]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Periods]  WITH CHECK ADD  CONSTRAINT [FK_Periods_PeriodTypes] FOREIGN KEY([FK_Period_Type_Id])
REFERENCES [dbo].[PeriodTypes] ([PK_Period_Type_Id])
GO
ALTER TABLE [dbo].[Periods] CHECK CONSTRAINT [FK_Periods_PeriodTypes]
GO
/****** Object:  ForeignKey [FK_Professors_Users]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Professors]  WITH CHECK ADD  CONSTRAINT [FK_Professors_Users] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Users] ([PK_User_Id])
GO
ALTER TABLE [dbo].[Professors] CHECK CONSTRAINT [FK_Professors_Users]
GO
/****** Object:  ForeignKey [FK_Reservations_Groups]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Groups] FOREIGN KEY([FK_Group_Id])
REFERENCES [dbo].[Groups] ([PK_Group_Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Groups]
GO
/****** Object:  ForeignKey [FK_Reservations_Laboratories]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Laboratories] FOREIGN KEY([FK_Laboratory_Id])
REFERENCES [dbo].[Laboratories] ([PK_Laboratory_Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Laboratories]
GO
/****** Object:  ForeignKey [FK_Reservations_Professors]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Professors] FOREIGN KEY([FK_Professor_Id])
REFERENCES [dbo].[Professors] ([FK_User_Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Professors]
GO
/****** Object:  ForeignKey [FK_Reservations_Software]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Software] FOREIGN KEY([FK_Software_Id])
REFERENCES [dbo].[Software] ([PK_Software_Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Software]
GO
/****** Object:  ForeignKey [FK_Reservations_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_States]
GO
/****** Object:  ForeignKey [FK_Software_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Software]  WITH CHECK ADD  CONSTRAINT [FK_Software_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
ALTER TABLE [dbo].[Software] CHECK CONSTRAINT [FK_Software_States]
GO
/****** Object:  ForeignKey [FK_SoftwareByLaboratory_Laboratories]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[SoftwareByLaboratory]  WITH CHECK ADD  CONSTRAINT [FK_SoftwareByLaboratory_Laboratories] FOREIGN KEY([FK_Laboratory_Id])
REFERENCES [dbo].[Laboratories] ([PK_Laboratory_Id])
GO
ALTER TABLE [dbo].[SoftwareByLaboratory] CHECK CONSTRAINT [FK_SoftwareByLaboratory_Laboratories]
GO
/****** Object:  ForeignKey [FK_SoftwareByLaboratory_Software]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[SoftwareByLaboratory]  WITH CHECK ADD  CONSTRAINT [FK_SoftwareByLaboratory_Software] FOREIGN KEY([FK_Software_Id])
REFERENCES [dbo].[Software] ([PK_Software_Id])
GO
ALTER TABLE [dbo].[SoftwareByLaboratory] CHECK CONSTRAINT [FK_SoftwareByLaboratory_Software]
GO
/****** Object:  ForeignKey [FK_Students_Users]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Users] FOREIGN KEY([FK_User_Id])
REFERENCES [dbo].[Users] ([PK_User_Id])
GO
ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Users]
GO
/****** Object:  ForeignKey [FK_StudentsByGroup_Groups]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[StudentsByGroup]  WITH CHECK ADD  CONSTRAINT [FK_StudentsByGroup_Groups] FOREIGN KEY([FK_Group_Id])
REFERENCES [dbo].[Groups] ([PK_Group_Id])
GO
ALTER TABLE [dbo].[StudentsByGroup] CHECK CONSTRAINT [FK_StudentsByGroup_Groups]
GO
/****** Object:  ForeignKey [FK_StudentsByGroup_Students]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[StudentsByGroup]  WITH CHECK ADD  CONSTRAINT [FK_StudentsByGroup_Students] FOREIGN KEY([FK_Student_Id])
REFERENCES [dbo].[Students] ([FK_User_Id])
GO
ALTER TABLE [dbo].[StudentsByGroup] CHECK CONSTRAINT [FK_StudentsByGroup_Students]
GO
/****** Object:  ForeignKey [FK_Users_States]    Script Date: 09/10/2015 16:08:34 ******/
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_States] FOREIGN KEY([FK_State_Id])
REFERENCES [dbo].[States] ([PK_State_Id])
GO
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