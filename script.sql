USE [master]
GO
/****** Object:  Database [db_billingsystem]    Script Date: 6/18/2025 9:23:21 PM ******/
CREATE DATABASE [db_billingsystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'db_billingsystem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\db_billingsystem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'db_billingsystem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\db_billingsystem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [db_billingsystem] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [db_billingsystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [db_billingsystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [db_billingsystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [db_billingsystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [db_billingsystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [db_billingsystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [db_billingsystem] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [db_billingsystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [db_billingsystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [db_billingsystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [db_billingsystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [db_billingsystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [db_billingsystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [db_billingsystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [db_billingsystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [db_billingsystem] SET  ENABLE_BROKER 
GO
ALTER DATABASE [db_billingsystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [db_billingsystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [db_billingsystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [db_billingsystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [db_billingsystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [db_billingsystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [db_billingsystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [db_billingsystem] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [db_billingsystem] SET  MULTI_USER 
GO
ALTER DATABASE [db_billingsystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [db_billingsystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [db_billingsystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [db_billingsystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [db_billingsystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [db_billingsystem] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [db_billingsystem] SET QUERY_STORE = ON
GO
ALTER DATABASE [db_billingsystem] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [db_billingsystem]
GO
/****** Object:  Table [dbo].[AdminInvoiceItems]    Script Date: 6/18/2025 9:23:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdminInvoiceItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [varchar](50) NULL,
	[ProductName] [varchar](100) NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](10, 2) NULL,
	[Total] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AdminInvoices]    Script Date: 6/18/2025 9:23:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdminInvoices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [varchar](50) NULL,
	[AdminName] [varchar](100) NULL,
	[CustomerName] [varchar](100) NULL,
	[DateCreated] [datetime] NULL,
	[TotalAmount] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 6/18/2025 9:23:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
	[productId] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[added_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InvoiceItems]    Script Date: 6/18/2025 9:23:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [varchar](50) NULL,
	[ItemName] [varchar](100) NULL,
	[Price] [decimal](10, 2) NULL,
	[Quantity] [int] NULL,
	[Total] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 6/18/2025 9:23:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[InvoiceID] [varchar](50) NULL,
	[Date] [varchar](20) NULL,
	[Subtotal] [decimal](10, 2) NULL,
	[Tax] [decimal](10, 2) NULL,
	[Total] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 6/18/2025 9:23:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[stock] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StaffSalary]    Script Date: 6/18/2025 9:23:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffSalary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffName] [varchar](100) NULL,
	[Amount] [decimal](10, 2) NULL,
	[Status] [varchar](20) NULL,
	[DatePaid] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 6/18/2025 9:23:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[phone_number] [varchar](20) NOT NULL,
	[password_hash] [varchar](255) NOT NULL,
	[role] [varchar](10) NOT NULL,
	[created_at] [datetime] NULL,
	[address] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AdminInvoiceItems] ON 

INSERT [dbo].[AdminInvoiceItems] ([Id], [InvoiceID], [ProductName], [Quantity], [Price], [Total]) VALUES (1, N'INV-3', N'syringe 3cc', 3, CAST(200.00 AS Decimal(10, 2)), CAST(600.00 AS Decimal(10, 2)))
INSERT [dbo].[AdminInvoiceItems] ([Id], [InvoiceID], [ProductName], [Quantity], [Price], [Total]) VALUES (2, N'INV-3', N'apple juice', 1, CAST(50.00 AS Decimal(10, 2)), CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[AdminInvoiceItems] ([Id], [InvoiceID], [ProductName], [Quantity], [Price], [Total]) VALUES (3, N'INV-6', N'inhaler', 2, CAST(300.00 AS Decimal(10, 2)), CAST(600.00 AS Decimal(10, 2)))
INSERT [dbo].[AdminInvoiceItems] ([Id], [InvoiceID], [ProductName], [Quantity], [Price], [Total]) VALUES (4, N'INV-6', N'Losartan', 1, CAST(100.00 AS Decimal(10, 2)), CAST(100.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[AdminInvoiceItems] OFF
GO
SET IDENTITY_INSERT [dbo].[AdminInvoices] ON 

INSERT [dbo].[AdminInvoices] ([Id], [InvoiceID], [AdminName], [CustomerName], [DateCreated], [TotalAmount]) VALUES (1, N'INV-3', N'Admin1', N'M.Arshad', CAST(N'2025-06-18T07:10:17.017' AS DateTime), CAST(650.00 AS Decimal(10, 2)))
INSERT [dbo].[AdminInvoices] ([Id], [InvoiceID], [AdminName], [CustomerName], [DateCreated], [TotalAmount]) VALUES (2, N'INV-6', N'Admin1', N'Mariyam Arshad', CAST(N'2025-06-18T17:55:57.237' AS DateTime), CAST(700.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[AdminInvoices] OFF
GO
SET IDENTITY_INSERT [dbo].[InvoiceItems] ON 

INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (6, N'INV66837', N'Ibuprofen 400mg (Brufen)', CAST(50.00 AS Decimal(10, 2)), 1, CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (7, N'INV66837', N'Antiseptic Cream (Soframycin)', CAST(130.00 AS Decimal(10, 2)), 1, CAST(130.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (8, N'INV65220', N'Ibuprofen 400mg (Brufen)', CAST(50.00 AS Decimal(10, 2)), 1, CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (9, N'INV65220', N'Antiseptic Cream (Soframycin)', CAST(130.00 AS Decimal(10, 2)), 1, CAST(130.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (10, N'INV42645', N'Ibuprofen 400mg (Brufen)', CAST(50.00 AS Decimal(10, 2)), 1, CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (11, N'INV42645', N'antacid (gelusil)', CAST(50.00 AS Decimal(10, 2)), 1, CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (12, N'INV43142', N'Ibuprofen 400mg (Brufen)', CAST(50.00 AS Decimal(10, 2)), 1, CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (13, N'INV54257', N'Ibuprofen 400mg (Brufen)', CAST(50.00 AS Decimal(10, 2)), 1, CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (14, N'INV54257', N'juice', CAST(40.00 AS Decimal(10, 2)), 1, CAST(40.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (15, N'INV24660', N'Misar 40mg', CAST(300.00 AS Decimal(10, 2)), 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (16, N'INV24660', N'inhaler', CAST(100.00 AS Decimal(10, 2)), 1, CAST(100.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (17, N'INV90966', N'Ibuprofen 400mg (Brufen)', CAST(50.00 AS Decimal(10, 2)), 1, CAST(50.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (18, N'INV66443', N'antacid (gelusil)', CAST(50.00 AS Decimal(10, 2)), 2, CAST(100.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (19, N'INV66443', N'Antiseptic Cream (Soframycin)', CAST(130.00 AS Decimal(10, 2)), 5, CAST(650.00 AS Decimal(10, 2)))
INSERT [dbo].[InvoiceItems] ([Id], [InvoiceID], [ItemName], [Price], [Quantity], [Total]) VALUES (20, N'INV66443', N'guaze Pads (Pack of 10)', CAST(110.00 AS Decimal(10, 2)), 1, CAST(110.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[InvoiceItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoices] ON 

INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (2, 1, N'INV66837', N'6/18/2025', CAST(180.00 AS Decimal(10, 2)), CAST(9.00 AS Decimal(10, 2)), CAST(189.00 AS Decimal(10, 2)))
INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (3, 1, N'INV65220', N'6/18/2025', CAST(180.00 AS Decimal(10, 2)), CAST(9.00 AS Decimal(10, 2)), CAST(189.00 AS Decimal(10, 2)))
INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (4, 1, N'INV42645', N'6/18/2025', CAST(100.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(105.00 AS Decimal(10, 2)))
INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (5, 1, N'INV43142', N'6/18/2025', CAST(50.00 AS Decimal(10, 2)), CAST(2.50 AS Decimal(10, 2)), CAST(52.50 AS Decimal(10, 2)))
INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (6, 1, N'INV54257', N'6/18/2025', CAST(90.00 AS Decimal(10, 2)), CAST(4.50 AS Decimal(10, 2)), CAST(94.50 AS Decimal(10, 2)))
INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (7, 1, N'INV24660', N'6/18/2025', CAST(400.00 AS Decimal(10, 2)), CAST(20.00 AS Decimal(10, 2)), CAST(420.00 AS Decimal(10, 2)))
INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (8, 1, N'INV90966', N'6/18/2025', CAST(50.00 AS Decimal(10, 2)), CAST(2.50 AS Decimal(10, 2)), CAST(52.50 AS Decimal(10, 2)))
INSERT [dbo].[Invoices] ([Id], [UserId], [InvoiceID], [Date], [Subtotal], [Tax], [Total]) VALUES (9, 1, N'INV66443', N'6/18/2025', CAST(860.00 AS Decimal(10, 2)), CAST(43.00 AS Decimal(10, 2)), CAST(903.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[Invoices] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (4, N'antacid (gelusil)', CAST(50.00 AS Decimal(10, 2)), 80)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (5, N'Ibuprofen 400mg (Brufen)', CAST(50.00 AS Decimal(10, 2)), 80)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (6, N'Band-Aids (Pack of 20)', CAST(100.00 AS Decimal(10, 2)), 70)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (7, N'Antiseptic Cream (Soframycin)', CAST(130.00 AS Decimal(10, 2)), 50)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (8, N'Cotton Roll 100g', CAST(90.00 AS Decimal(10, 2)), 100)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (9, N'guaze Pads (Pack of 10)', CAST(110.00 AS Decimal(10, 2)), 75)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (11, N'inhaler', CAST(100.00 AS Decimal(10, 2)), 20)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (13, N'zoopent', CAST(176.00 AS Decimal(10, 2)), 20)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (16, N'Misar 40mg', CAST(300.00 AS Decimal(10, 2)), 100)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (26, N'Amoxicillin 625mg', CAST(50.00 AS Decimal(10, 2)), 35)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (27, N'Metformin 500mg', CAST(35.00 AS Decimal(10, 2)), 100)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (28, N'Voltaren Gel 20g', CAST(140.00 AS Decimal(10, 2)), 75)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (29, N'panadol', CAST(60.00 AS Decimal(10, 2)), 60)
INSERT [dbo].[Products] ([id], [name], [price], [stock]) VALUES (30, N'Strepsils (Pack of 8)', CAST(60.00 AS Decimal(10, 2)), 200)
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffSalary] ON 

INSERT [dbo].[StaffSalary] ([Id], [StaffName], [Amount], [Status], [DatePaid]) VALUES (1, N'ali', CAST(25000.00 AS Decimal(10, 2)), N'Paid', CAST(N'2025-06-18T14:48:35.863' AS DateTime))
INSERT [dbo].[StaffSalary] ([Id], [StaffName], [Amount], [Status], [DatePaid]) VALUES (2, N'Mirza hassan', CAST(12500.00 AS Decimal(10, 2)), N'Pending', CAST(N'2025-06-18T14:49:21.310' AS DateTime))
INSERT [dbo].[StaffSalary] ([Id], [StaffName], [Amount], [Status], [DatePaid]) VALUES (3, N'Mariyam Arshad', CAST(15000.00 AS Decimal(10, 2)), N'Paid', CAST(N'2025-06-18T14:49:39.890' AS DateTime))
INSERT [dbo].[StaffSalary] ([Id], [StaffName], [Amount], [Status], [DatePaid]) VALUES (4, N'Akbar', CAST(20000.00 AS Decimal(10, 2)), N'Pending', CAST(N'2025-06-18T14:49:57.643' AS DateTime))
SET IDENTITY_INSERT [dbo].[StaffSalary] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (1, N'mariyam', N'marsh@gmail.com', N'03350647252', N'mariyam1122', N'User', CAST(N'2025-06-14T15:19:32.270' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (2, N'laiba', N'laiba@gmail.com', N'03340221342', N'laiba110', N'Admin', CAST(N'2025-06-14T15:31:27.480' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (3, N'Rubina Arshad', N'rubinaarshad101@gmail.com', N'03347857700', N'rubina110', N'User', CAST(N'2025-06-14T18:12:54.883' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (4, N'Arshad', N'muhammadarshad1084@gmail.com', N'03086157714', N'arsh110', N'User', CAST(N'2025-06-14T18:15:46.270' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (5, N'fatima raza', N'fatima1970@gmail.com', N'03327863939', N'fat19X2', N'Admin', CAST(N'2025-06-14T18:21:29.380' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (6, N'Ahmed', N'ahmed223@gmail.com', N'03098763366', N'00190', N'Admin', CAST(N'2025-06-15T12:31:20.370' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (7, N'Hina Mohsin', N'hinamohsin@gmail.com', N'03217863029', N'hina110', N'User', CAST(N'2025-06-16T22:24:53.130' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (8, N'zain', N'zain@gmail.com', N'09980982277', N'zain110', N'Admin', CAST(N'2025-06-17T13:41:06.707' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (9, N'sana', N'sana@gmail.com', N'03392888292', N'$2b$10$azKL2gJ7dZ9dWDpnmxAcX./ndVSZZYMckj.QVbz/BQLaUGvuzmRV6', N'User', CAST(N'2025-06-17T18:48:05.890' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (10, N'rida', N'rida@gmail.com', N'021930129021', N'$2b$10$m39JgCuFaRG.3sKA/fYm/.GAgzvI6ALPfZFdpMZ4ZLQmywH3a2NS.', N'User', CAST(N'2025-06-17T21:59:04.900' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (11, N'abdul mateen', N'mateen@gmail.com', N'02992828282', N'mateen110', N'User', CAST(N'2025-06-18T00:54:51.337' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (12, N'aribah ahmed', N'aribah@gmail.com', N'03398279999', N'aribah110', N'User', CAST(N'2025-06-18T17:51:00.243' AS DateTime), NULL)
INSERT [dbo].[users] ([id], [name], [email], [phone_number], [password_hash], [role], [created_at], [address]) VALUES (13, N'admin', N'admin@gmail.com', N'02293837733', N'admin', N'Admin', CAST(N'2025-06-18T17:51:57.077' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__AB6E616498520762]    Script Date: 6/18/2025 9:23:22 PM ******/
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AdminInvoices] ADD  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT (getdate()) FOR [added_at]
GO
ALTER TABLE [dbo].[StaffSalary] ADD  DEFAULT (getdate()) FOR [DatePaid]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (NULL) FOR [address]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([productId])
REFERENCES [dbo].[Products] ([id])
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[StaffSalary]  WITH CHECK ADD CHECK  (([Status]='Pending' OR [Status]='Paid'))
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD CHECK  (([role]='Admin' OR [role]='User'))
GO
USE [master]
GO
ALTER DATABASE [db_billingsystem] SET  READ_WRITE 
GO
