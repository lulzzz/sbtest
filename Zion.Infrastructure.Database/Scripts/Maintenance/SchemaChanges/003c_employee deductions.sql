IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDeduction_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]'))
ALTER TABLE [dbo].[EmployeeDeduction] DROP CONSTRAINT [FK_EmployeeDeduction_Employee]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDeduction_CompanyDeduction]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]'))
ALTER TABLE [dbo].[EmployeeDeduction] DROP CONSTRAINT [FK_EmployeeDeduction_CompanyDeduction]
GO
/****** Object:  Table [dbo].[EmployeeDeduction]    Script Date: 7/08/2016 6:35:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]') AND type in (N'U'))
DROP TABLE [dbo].[EmployeeDeduction]
GO
/****** Object:  Table [dbo].[EmployeeDeduction]    Script Date: 7/08/2016 6:35:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeDeduction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[Method] [int] NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[AnnualMax] [decimal](18, 2) NULL,
	[CompanyDeductionId] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeDeduction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDeduction_CompanyDeduction]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]'))
ALTER TABLE [dbo].[EmployeeDeduction]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDeduction_CompanyDeduction] FOREIGN KEY([CompanyDeductionId])
REFERENCES [dbo].[CompanyDeduction] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDeduction_CompanyDeduction]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]'))
ALTER TABLE [dbo].[EmployeeDeduction] CHECK CONSTRAINT [FK_EmployeeDeduction_CompanyDeduction]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDeduction_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]'))
ALTER TABLE [dbo].[EmployeeDeduction]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDeduction_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDeduction_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDeduction]'))
ALTER TABLE [dbo].[EmployeeDeduction] CHECK CONSTRAINT [FK_EmployeeDeduction_Employee]
GO
