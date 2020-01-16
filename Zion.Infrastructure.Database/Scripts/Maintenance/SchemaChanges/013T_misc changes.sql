IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'ControlId')
Alter table Company Add ControlId varchar(max);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'ClockId')
Alter table Employee Add ClockId varchar(max);
Go
/****** Object:  Table [dbo].[ScheduledPayroll]    Script Date: 16/01/2020 7:35:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScheduledPayroll]') AND type in (N'U'))
DROP TABLE [dbo].[ScheduledPayroll]
GO
/****** Object:  Table [dbo].[ScheduledPayroll]    Script Date: 16/01/2020 7:35:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduledPayroll](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[PaySchedule] [int] NOT NULL,
	[ScheduleStartDate] [datetime] NOT NULL,
	[PayDateStart] [datetime] NOT NULL,
	[LastPayrollDate] [datetime] NULL,
	[Status] [int] NOT NULL,
	[Data] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_ScheduledPayroll] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

