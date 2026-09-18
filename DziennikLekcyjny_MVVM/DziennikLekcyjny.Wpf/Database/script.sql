USE [master]
GO
/****** Object:  Database [Projekt bazy danych dziennika lekcyjnego]    Script Date: 18.09.2026 12:33:42 ******/
CREATE DATABASE [Projekt bazy danych dziennika lekcyjnego]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Projekt bazy danych dziennika lekcyjnego', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Projekt bazy danych dziennika lekcyjnego.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Projekt bazy danych dziennika lekcyjnego_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Projekt bazy danych dziennika lekcyjnego_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Projekt bazy danych dziennika lekcyjnego].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET ARITHABORT OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET  MULTI_USER 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET QUERY_STORE = ON
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Projekt bazy danych dziennika lekcyjnego]
GO
/****** Object:  UserDefinedFunction [dbo].[SprawdzDateObecnosci]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SprawdzDateObecnosci] (@data DATE)
RETURNS BIT
AS
BEGIN
    IF @data <= GETDATE()
        RETURN 1
    RETURN 0
END;
GO
/****** Object:  UserDefinedFunction [dbo].[SprawdzDzienTygodnia]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SprawdzDzienTygodnia] (@dzien VARCHAR(15))
RETURNS BIT
AS
BEGIN
    IF @dzien IN ('Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek')
        RETURN 1
    RETURN 0
END;
GO
/****** Object:  UserDefinedFunction [dbo].[SprawdzGodzine]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SprawdzGodzine] (@godzina TIME)
RETURNS BIT
AS
BEGIN
    IF @godzina >= '07:00' AND @godzina <= '17:00'
        RETURN 1
    RETURN 0
END;
GO
/****** Object:  UserDefinedFunction [dbo].[SprawdzOcene]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SprawdzOcene] (@ocena DECIMAL(3,1))
RETURNS BIT
AS
BEGIN
    IF @ocena >= 0.0 AND @ocena <= 5.0
        RETURN 1
    RETURN 0
END;
GO
/****** Object:  UserDefinedFunction [dbo].[SprawdzPesel]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SprawdzPesel] (@pesel VARCHAR(11))
RETURNS BIT
AS
BEGIN
    IF LEN(@pesel) = 11 AND @pesel NOT LIKE '%[^0-9]%'
        RETURN 1
    RETURN 0
END;
GO
/****** Object:  Table [dbo].[Ocena]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ocena](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_studenta] [int] NOT NULL,
	[ID_przedmiotu] [int] NOT NULL,
	[Data] [date] NOT NULL,
	[Ocena] [decimal](3, 1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[ID_studenta] [int] IDENTITY(1,1) NOT NULL,
	[Imie] [varchar](50) NOT NULL,
	[Nazwisko] [varchar](50) NOT NULL,
	[Pesel] [varchar](11) NOT NULL,
	[Data_urodzenia] [date] NOT NULL,
	[ID_klasy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_studenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SredniaOcenaUcznia]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Widok: Średnia ocen ucznia
CREATE   VIEW [dbo].[SredniaOcenaUcznia]
AS
SELECT 
    S.ID_studenta,
    S.Imie,
    S.Nazwisko,
    AVG(O.Ocena) AS Srednia_ocena
FROM Student AS S
INNER JOIN Ocena AS O ON S.ID_studenta = O.ID_studenta
GROUP BY S.ID_studenta, S.Imie, S.Nazwisko
GO
/****** Object:  Table [dbo].[Obecnosc]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Obecnosc](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_studenta] [int] NOT NULL,
	[Data] [date] NOT NULL,
	[Status] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StatystykaObecnosci]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Widok: Statystyka obecności uczniów
CREATE   VIEW [dbo].[StatystykaObecnosci]
AS
SELECT 
    S.ID_studenta,
    S.Imie,
    S.Nazwisko,
    COUNT(CASE WHEN O.Status = 'Nieobecny' THEN 1 END) AS Liczba_nieobecnosci
FROM Student AS S
LEFT JOIN Obecnosc AS O ON S.ID_studenta = O.ID_studenta
GROUP BY S.ID_studenta, S.Imie, S.Nazwisko
GO
/****** Object:  Table [dbo].[Klasa]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Klasa](
	[ID_klasy] [int] IDENTITY(1,1) NOT NULL,
	[Nazwa_klasy] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_klasy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Przedmiot]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Przedmiot](
	[ID_przedmiotu] [int] IDENTITY(1,1) NOT NULL,
	[Nazwa_przedmiotu] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_przedmiotu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Nauczyciel]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nauczyciel](
	[ID_nauczyciela] [int] IDENTITY(1,1) NOT NULL,
	[Imie] [varchar](50) NOT NULL,
	[Nazwisko] [varchar](50) NOT NULL,
	[Pesel] [varchar](11) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_nauczyciela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Plan_lekcji]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Plan_lekcji](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_klasy] [int] NOT NULL,
	[ID_przedmiotu] [int] NOT NULL,
	[ID_nauczyciela] [int] NOT NULL,
	[Dzien_tygodnia] [varchar](15) NOT NULL,
	[Godzina] [time](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PlanLekcjiKlasy]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Widok: Plan lekcji klasy
CREATE   VIEW [dbo].[PlanLekcjiKlasy]
AS
SELECT 
    K.Nazwa_klasy,
    P.Nazwa_przedmiotu,
    N.Imie + ' ' + N.Nazwisko AS Nauczyciel,
    PL.Dzien_tygodnia,
    PL.Godzina
FROM Plan_lekcji AS PL
INNER JOIN Klasa AS K ON PL.ID_klasy = K.ID_klasy
INNER JOIN Przedmiot AS P ON PL.ID_przedmiotu = P.ID_przedmiotu
INNER JOIN Nauczyciel AS N ON PL.ID_nauczyciela = N.ID_nauczyciela
GO
SET IDENTITY_INSERT [dbo].[Klasa] ON 

INSERT [dbo].[Klasa] ([ID_klasy], [Nazwa_klasy]) VALUES (1, N'1A')
INSERT [dbo].[Klasa] ([ID_klasy], [Nazwa_klasy]) VALUES (2, N'2B')
INSERT [dbo].[Klasa] ([ID_klasy], [Nazwa_klasy]) VALUES (1002, N'3A')
SET IDENTITY_INSERT [dbo].[Klasa] OFF
GO
SET IDENTITY_INSERT [dbo].[Nauczyciel] ON 

INSERT [dbo].[Nauczyciel] ([ID_nauczyciela], [Imie], [Nazwisko], [Pesel]) VALUES (1, N'Anna', N'Kowalska', N'90010112345')
INSERT [dbo].[Nauczyciel] ([ID_nauczyciela], [Imie], [Nazwisko], [Pesel]) VALUES (2, N'Jan', N'Nowak', N'85021254321')
SET IDENTITY_INSERT [dbo].[Nauczyciel] OFF
GO
SET IDENTITY_INSERT [dbo].[Obecnosc] ON 

INSERT [dbo].[Obecnosc] ([ID], [ID_studenta], [Data], [Status]) VALUES (1, 1, CAST(N'2025-06-01' AS Date), N'Obecny')
INSERT [dbo].[Obecnosc] ([ID], [ID_studenta], [Data], [Status]) VALUES (2, 2, CAST(N'2025-06-01' AS Date), N'Nieobecny')
INSERT [dbo].[Obecnosc] ([ID], [ID_studenta], [Data], [Status]) VALUES (3, 3, CAST(N'2025-06-01' AS Date), N'Obecny')
SET IDENTITY_INSERT [dbo].[Obecnosc] OFF
GO
SET IDENTITY_INSERT [dbo].[Ocena] ON 

INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (1, 1, 1, CAST(N'2025-06-01' AS Date), CAST(5.0 AS Decimal(3, 1)))
INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (2, 2, 2, CAST(N'2025-06-02' AS Date), CAST(4.0 AS Decimal(3, 1)))
INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (3, 3, 1, CAST(N'2025-06-03' AS Date), CAST(3.0 AS Decimal(3, 1)))
INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (36, 1, 1, CAST(N'2025-06-07' AS Date), CAST(5.0 AS Decimal(3, 1)))
INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (37, 1, 1, CAST(N'2025-06-07' AS Date), CAST(5.0 AS Decimal(3, 1)))
INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (39, 1, 1, CAST(N'2025-06-07' AS Date), CAST(5.0 AS Decimal(3, 1)))
INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (41, 1, 1, CAST(N'2025-06-07' AS Date), CAST(5.0 AS Decimal(3, 1)))
INSERT [dbo].[Ocena] ([ID], [ID_studenta], [ID_przedmiotu], [Data], [Ocena]) VALUES (43, 1, 1, CAST(N'2025-06-07' AS Date), CAST(5.0 AS Decimal(3, 1)))
SET IDENTITY_INSERT [dbo].[Ocena] OFF
GO
SET IDENTITY_INSERT [dbo].[Plan_lekcji] ON 

INSERT [dbo].[Plan_lekcji] ([ID], [ID_klasy], [ID_przedmiotu], [ID_nauczyciela], [Dzien_tygodnia], [Godzina]) VALUES (1, 1, 1, 1, N'Poniedzialek', CAST(N'08:00:00' AS Time))
INSERT [dbo].[Plan_lekcji] ([ID], [ID_klasy], [ID_przedmiotu], [ID_nauczyciela], [Dzien_tygodnia], [Godzina]) VALUES (2, 1, 2, 2, N'Wtorek', CAST(N'09:00:00' AS Time))
INSERT [dbo].[Plan_lekcji] ([ID], [ID_klasy], [ID_przedmiotu], [ID_nauczyciela], [Dzien_tygodnia], [Godzina]) VALUES (1001, 2, 1, 2, N'Wtorek', CAST(N'10:00:00' AS Time))
SET IDENTITY_INSERT [dbo].[Plan_lekcji] OFF
GO
SET IDENTITY_INSERT [dbo].[Przedmiot] ON 

INSERT [dbo].[Przedmiot] ([ID_przedmiotu], [Nazwa_przedmiotu]) VALUES (1, N'Matematyka')
INSERT [dbo].[Przedmiot] ([ID_przedmiotu], [Nazwa_przedmiotu]) VALUES (2, N'Biologia')
SET IDENTITY_INSERT [dbo].[Przedmiot] OFF
GO
SET IDENTITY_INSERT [dbo].[Student] ON 

INSERT [dbo].[Student] ([ID_studenta], [Imie], [Nazwisko], [Pesel], [Data_urodzenia], [ID_klasy]) VALUES (1, N'Marta', N'Zielinska', N'05120398765', CAST(N'2005-12-03' AS Date), 1)
INSERT [dbo].[Student] ([ID_studenta], [Imie], [Nazwisko], [Pesel], [Data_urodzenia], [ID_klasy]) VALUES (2, N'Piotr', N'Wojcik', N'06071587654', CAST(N'2006-07-15' AS Date), 1)
INSERT [dbo].[Student] ([ID_studenta], [Imie], [Nazwisko], [Pesel], [Data_urodzenia], [ID_klasy]) VALUES (3, N'Anna', N'Kaczmarek', N'05120112345', CAST(N'2005-12-01' AS Date), 2)
SET IDENTITY_INSERT [dbo].[Student] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Nauczyci__48A5F71770E1EC60]    Script Date: 18.09.2026 12:33:43 ******/
ALTER TABLE [dbo].[Nauczyciel] ADD UNIQUE NONCLUSTERED 
(
	[Pesel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Student__48A5F717FCC2E865]    Script Date: 18.09.2026 12:33:43 ******/
ALTER TABLE [dbo].[Student] ADD UNIQUE NONCLUSTERED 
(
	[Pesel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Obecnosc]  WITH NOCHECK ADD FOREIGN KEY([ID_studenta])
REFERENCES [dbo].[Student] ([ID_studenta])
GO
ALTER TABLE [dbo].[Ocena]  WITH NOCHECK ADD FOREIGN KEY([ID_przedmiotu])
REFERENCES [dbo].[Przedmiot] ([ID_przedmiotu])
GO
ALTER TABLE [dbo].[Ocena]  WITH NOCHECK ADD FOREIGN KEY([ID_studenta])
REFERENCES [dbo].[Student] ([ID_studenta])
GO
ALTER TABLE [dbo].[Plan_lekcji]  WITH NOCHECK ADD FOREIGN KEY([ID_klasy])
REFERENCES [dbo].[Klasa] ([ID_klasy])
GO
ALTER TABLE [dbo].[Plan_lekcji]  WITH NOCHECK ADD FOREIGN KEY([ID_nauczyciela])
REFERENCES [dbo].[Nauczyciel] ([ID_nauczyciela])
GO
ALTER TABLE [dbo].[Plan_lekcji]  WITH NOCHECK ADD FOREIGN KEY([ID_przedmiotu])
REFERENCES [dbo].[Przedmiot] ([ID_przedmiotu])
GO
ALTER TABLE [dbo].[Student]  WITH NOCHECK ADD FOREIGN KEY([ID_klasy])
REFERENCES [dbo].[Klasa] ([ID_klasy])
GO
/****** Object:  StoredProcedure [dbo].[DodajNauczyciela]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajNauczyciela]
    @Imie VARCHAR(50),
    @Nazwisko VARCHAR(50),
    @Pesel VARCHAR(11)
AS
BEGIN
    IF dbo.SprawdzPesel(@Pesel) = 0
    BEGIN
        RAISERROR('Niepoprawny PESEL.', 16, 1);
        RETURN;
    END

    INSERT INTO Nauczyciel (Imie, Nazwisko, Pesel)
    VALUES (@Imie, @Nazwisko, @Pesel);
END;
GO
/****** Object:  StoredProcedure [dbo].[DodajOcene]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajOcene]
    @IDStudenta INT,
    @IDPrzedmiotu INT,
    @Ocena DECIMAL(3,1),
    @Data DATE
AS
BEGIN
    IF dbo.SprawdzOcene(@Ocena) = 0
    BEGIN
        RAISERROR('Ocena poza zakresem 0.0–6.0.', 16, 1);
        RETURN;
    END

    INSERT INTO Ocena (ID_studenta, ID_przedmiotu, Ocena, Data)
    VALUES (@IDStudenta, @IDPrzedmiotu, @Ocena, @Data);
END;
GO
/****** Object:  StoredProcedure [dbo].[DodajStudenta]    Script Date: 18.09.2026 12:33:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajStudenta]
    @Imie VARCHAR(50),
    @Nazwisko VARCHAR(50),
    @Pesel VARCHAR(11),
    @DataUrodzenia DATE,
    @IDKlasy INT
AS
BEGIN
    IF dbo.SprawdzPesel(@Pesel) = 0
    BEGIN
        RAISERROR('Niepoprawny PESEL.', 16, 1);
        RETURN;
    END

    INSERT INTO Student (Imie, Nazwisko, Pesel, Data_urodzenia, ID_klasy)
    VALUES (@Imie, @Nazwisko, @Pesel, @DataUrodzenia, @IDKlasy);
END;
GO
USE [master]
GO
ALTER DATABASE [Projekt bazy danych dziennika lekcyjnego] SET  READ_WRITE 
GO
