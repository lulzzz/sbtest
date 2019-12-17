/****** Object:  Table [dbo].[FITW4Table]    Script Date: 17/12/2019 12:41:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FITW4Table]') AND type in (N'U'))
DROP TABLE [dbo].[FITW4Table]
GO
/****** Object:  Table [dbo].[FITW4Table]    Script Date: 17/12/2019 12:41:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FITW4Table](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FilingStatus] varchar(50) NOT NULL,
	[DependentWageLimit] [decimal](18, 2) NOT NULL,
	[DependentAllowance1] [decimal](18, 2) NOT NULL,
	[DependentAllowance2] [decimal](18, 2) NOT NULL,
	[AdditionalDeductionW4] [decimal](18, 2) NOT NULL,
	[DeductionForExemption] [decimal](18, 0) NOT NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_FITW4Table] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[FITAlienAdjustmentTable]    Script Date: 17/12/2019 12:41:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FITAlienAdjustmentTable]') AND type in (N'U'))
DROP TABLE [dbo].[FITAlienAdjustmentTable]
GO
/****** Object:  Table [dbo].[FITAlienAdjustmentTable]    Script Date: 17/12/2019 12:41:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FITAlienAdjustmentTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Pre2020] bit not null default(0),
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_FITAlienAdjustmentTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

IF NOT EXISTS(SELECT 1 FROM sys.objects WHERE type = 'PK' AND  parent_object_id = OBJECT_ID ('TaxDeductionPrecedence'))
BEGIN
	Alter table TaxDeductionPrecedence Alter column TaxCode varchar(20) not null;
	ALTER TABLE TaxDeductionPrecedence ADD PRIMARY KEY (TaxCode, DeductionTypeId);
END
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TaxYearRate]') AND name = N'IX_TaxYearRate')
CREATE NONCLUSTERED INDEX [IX_TaxYearRate] ON [dbo].[TaxYearRate]
(
	[TaxYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[FITTaxTable]') AND name = N'IX_FITTaxTable')
CREATE NONCLUSTERED INDEX [IX_FITTaxTable] ON [dbo].[FITTaxTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[FITWithholdingAllowanceTable]') AND name = N'IX_FITWithholdingAllowanceTable')
CREATE NONCLUSTERED INDEX [IX_FITWithholdingAllowanceTable] ON [dbo].[FITWithholdingAllowanceTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[FITAlienAdjustmentTable]') AND name = N'IX_FITAlienAdjustmentTable')
CREATE NONCLUSTERED INDEX [IX_FITAlienAdjustmentTable] ON [dbo].[FITAlienAdjustmentTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[FITW4Table]') AND name = N'IX_FITW4Table')
CREATE NONCLUSTERED INDEX [IX_FITW4Table] ON [dbo].[FITW4Table]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HISITTaxTable]') AND name = N'IX_HISITTaxTable')
CREATE NONCLUSTERED INDEX [IX_HISITTaxTable] ON [dbo].[HISITTaxTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HISITWithholdingAllowanceTable]') AND name = N'IX_HISITWithholdingAllowanceTable')
CREATE NONCLUSTERED INDEX [IX_HISITWithholdingAllowanceTable] ON [dbo].[HISITWithholdingAllowanceTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SITTaxTable]') AND name = N'IX_SITTaxTable')
CREATE NONCLUSTERED INDEX [IX_SITTaxTable] ON [dbo].[SITTaxTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SITLowIncomeTaxTable]') AND name = N'IX_SITLowIncomeTaxTable')
CREATE NONCLUSTERED INDEX [IX_SITLowIncomeTaxTable] ON [dbo].[SITLowIncomeTaxTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[StandardDeductionTable]') AND name = N'IX_StandardDeductionTable')
CREATE NONCLUSTERED INDEX [IX_StandardDeductionTable] ON [dbo].[StandardDeductionTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EstimatedDeductionsTable]') AND name = N'IX_EstimatedDeductionsTable')
CREATE NONCLUSTERED INDEX [IX_EstimatedDeductionsTable] ON [dbo].[EstimatedDeductionsTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExemptionAllowanceTable]') AND name = N'IX_ExemptionAllowanceTable')
CREATE NONCLUSTERED INDEX [IX_ExemptionAllowanceTable] ON [dbo].[ExemptionAllowanceTable]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT Exists(select 'x' from FITW4Table where Year=2020)
BEGIN
insert into FITW4Table (FilingStatus, DependentWageLimit, DependentAllowance1, DependentAllowance2, AdditionalDeductionW4, DeductionForExemption, Year) values('Single', 200000, 2000, 500, 8400, 4200, 2020);
insert into FITW4Table (FilingStatus, DependentWageLimit, DependentAllowance1, DependentAllowance2, AdditionalDeductionW4, DeductionForExemption, Year) values('HeadofHousehold', 200000, 2000, 500, 8400, 4200, 2020);
insert into FITW4Table (FilingStatus, DependentWageLimit, DependentAllowance1, DependentAllowance2, AdditionalDeductionW4, DeductionForExemption, Year) values('Married', 400000, 2000, 500, 12600, 4200, 2020);
END
IF NOT Exists(select 'x' from FITAlienAdjustmentTable where Year=2020)
BEGIN
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(1, 153.80, 1, 2020);
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(2, 307.70, 1, 2020);
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(3, 330.30, 1, 2020);
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(4, 666.70, 1, 2020);
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(1, 234.60, 0, 2020);
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(2, 469.20, 0, 2020);
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(3, 508.30, 0, 2020);
insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values(4, 1016.70, 0, 2020);

END
IF Exists(select 'x' from FITTaxTable where Year=2020)
	DELETE from FITTaxTable where Year=2020;
IF NOT Exists(select 'x' from FITTaxTable where Year=2020)
BEGIN
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 0, 11900, 0, 0, 0, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 11900, 31650, 0, 0.1, 11900, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 31650, 92150, 1975, 0.12, 31650, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 92150, 182950, 9235, 0.22, 92150, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 182950, 338500, 29211, 0.24, 182950, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 338500, 426600, 66543, 0.32, 338500, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 426600, 633950, 94735, 0.35, 426600, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 633950, null, 167307.5, 0.37, 633950, 2020, 0);

insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 0, 3800, 0, 0, 0, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 3800, 13675, 0, 0.1, 3800, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 13675, 43925, 987.5, 0.12, 13675, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 43925, 89325, 4617.5, 0.22, 43925, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 89325, 167100, 14605.5, 0.24, 89325, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 167100, 211150, 33271.5, 0.32, 167100, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 211150, 522200, 47367.5, 0.35, 211150, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 522200, null, 156235, 0.37, 522200, 2020, 0);

insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 0, 10050, 0, 0, 0, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 10050, 24150, 0, 0.1, 10050, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 24150, 63750, 1410, 0.12, 24150, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 63750, 95550, 6162, 0.22, 63750, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 95550, 173350, 13158, 0.24, 95550, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 173350, 217400, 31830, 0.32, 173350, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 217400, 528450, 45926, 0.35, 217400, 2020, 0);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 528450, null, 154793.5, 0.37, 528450, 2020, 0);

insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 0, 12400, 0, 0, 0, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 12400, 22275, 0, 0.1, 12400, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 22275, 52525, 987.5, 0.12, 22275, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 52525, 97925, 4617.5, 0.22, 52525, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 97925, 175700, 14605.5, 0.24, 97925, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 175700, 219750, 33271.5, 0.32, 175700, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 219750, 323425, 47367.5, 0.35, 219750, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Married', 323425, null, 83653.75, 0.37, 323425, 2020, 1);

insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 0, 6200, 0, 0, 0, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 6200, 11137.5, 0, 0.1, 6200, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 11137.5, 26262.5, 493.75, 0.12, 11137.5, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 26262.5, 48962.5, 2308.75, 0.22, 26262.5, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 48962.5, 87850, 7302.75, 0.24, 48962.5, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 87850, 109875, 16635.75, 0.32, 87850, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 109875, 265400, 23683.75, 0.35, 109875, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'Single', 265400, null, 78117.5, 0.37, 265400, 2020, 1);

insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 0, 9325, 0, 0, 0, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 9325, 16375, 0, 0.1, 9325, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 16375, 36175, 705, 0.12, 16375, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 36175, 52075, 3081, 0.22, 36175, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 52075, 90975, 6579, 0.24, 52075, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 90975, 113000, 15915, 0.32, 90975, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 113000, 268525, 22963, 0.35, 113000, 2020, 1);
insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(5, 'HeadofHousehold', 268525, null, 77396.75, 0.37, 268525, 2020, 1);

END

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'FITTaxTable'
                 AND COLUMN_NAME = 'ForMultiJobs')
Alter table FITTaxTable Add ForMultiJobs bit(1) not null default(0);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'UseW4Fields')
	Alter table Employee Add UseW4Fields bit, DependentChildren int, OtherDependent int, MultipleJobs bit, OtherIncome decimal(18,2), FederalDeductions decimal(18,2), FederalAdditionalWithholding decimal(18,2)
GO
