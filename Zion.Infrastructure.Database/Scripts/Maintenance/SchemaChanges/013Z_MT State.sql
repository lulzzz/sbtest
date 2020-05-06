IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyTaxState'
                 AND COLUMN_NAME = 'DepositSchedule')
Alter table CompanyTaxState Add DepositSchedule int Default(2);
Go
update cst set DepositSchedule=c.DepositSchedule941
from CompanyTaxState cst, Company c where cst.CompanyId=c.Id;
if not exists(select 'x' from Tax where StateId=25)
begin
set identity_insert dbo.Tax On
insert into Tax(Id, Code, Name, CountryId, StateId, IsCompanySpecific, DefaultRate, Paidby) values(16, 'MT-SIT', 'Montana SIT', 1, 25, 0, NULL, 'Employee');
insert into Tax(Id, Code, Name, CountryId, StateId, IsCompanySpecific, DefaultRate, Paidby) values(17, 'MT-AFT', 'Montana AFT', 1, 25, 1, 0.18, 'Employer');
insert into Tax(Id, Code, Name, CountryId, StateId, IsCompanySpecific, DefaultRate, Paidby) values(18, 'MT-UI', 'Montana SUI', 1, 25, 1, 2.4, 'Employer');

set identity_insert dbo.Tax Off
insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit, WeeklyMaxWage) values(16, 2020, NULL, NULL, NULL, NULL);
insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit, WeeklyMaxWage) values(17, 2020, 0.18, NULL, NULL, NULL);
insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit, WeeklyMaxWage) values(18, 2020, 2.4, 34100, 6.12, NULL);
end
/****** Object:  Table [dbo].[FITTaxTable]    Script Date: 19/02/2020 9:36:09 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTSITTaxTable]') AND type in (N'U'))
DROP TABLE [dbo].[MTSITTaxTable]
GO
/****** Object:  Table [dbo].[MTSITTaxTable]    Script Date: 19/02/2020 9:36:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MTSITTaxTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[StartRange] [decimal](18, 2) NULL,
	[EndRange] [decimal](18, 2) NULL,
	[FlatRate] [decimal](18, 2) NULL,
	[AdditionalPercentage] [decimal](18, 2) NULL,
	[ExcessOvrAmt] [decimal](18, 2) NULL,
	[Year] [int] NULL
 CONSTRAINT [PK_MTSITTaxTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FITWithholdingAllowanceTable]    Script Date: 19/02/2020 9:46:09 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTSITExemptionConstantTable]') AND type in (N'U'))
DROP TABLE [dbo].[MTSITExemptionConstantTable]
GO
/****** Object:  Table [dbo].[FITWithholdingAllowanceTable]    Script Date: 19/02/2020 9:46:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MTSITExemptionConstantTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_MTSITExemptionConstantTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
GO


if not exists(select 'x' from MTSITTaxTable)
begin
set identity_insert dbo.Tax On
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(1, 0, 134.99, 0, 1.8, 0, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(1, 135, 287.99, 2, 4.4, 135, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(1, 288, 2307.99, 9, 6, 288, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(1, 2308, null, 130, 6.6, 2308, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(2, 0, 268.99, 0, 1.8, 0, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(2, 269, 576.99, 5, 4.4, 269, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(2, 577, 4614.99, 18, 6, 577, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(2, 4615, null, 261, 6.6, 4615, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(3, 0, 291.99, 0, 1.8, 0, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(3, 292, 624.99, 5, 4.4, 292, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(3, 625, 4999.99, 20, 6, 625, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(3, 5000, null, 282, 6.6, 5000, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(4, 0, 582.99, 0, 1.8, 0, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(4, 583, 1249.99, 11, 4.4, 583, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(4, 1250, 9999.99, 40, 6, 1250, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(4, 10000, null, 565, 6.6, 10000, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(5, 0, 6999.99, 0, 1.8, 0, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(5, 7000, 14999.99, 126, 4.4, 7000, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(5, 15000, 119999.99, 478, 6, 15000, 2020);
insert into MTSITTaxTable(PayrollPeriodId, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(5, 120000, null, 6778, 6.6, 120000, 2020);

insert into [MTSITExemptionConstantTable](PayrollPeriodId, Amount, Year) values (1, 37, 2020);
insert into [MTSITExemptionConstantTable](PayrollPeriodId, Amount, Year) values (2, 73, 2020);
insert into [MTSITExemptionConstantTable](PayrollPeriodId, Amount, Year) values (3, 79, 2020);
insert into [MTSITExemptionConstantTable](PayrollPeriodId, Amount, Year) values (4, 158, 2020);
insert into [MTSITExemptionConstantTable](PayrollPeriodId, Amount, Year) values (5, 1900, 2020);

insert into AccountTemplate(Type, SubType, Name, TaxCode, StateId) values(3, 15,'Montana State Income Tax', 'MT-SIT', 25);
insert into AccountTemplate(Type, SubType, Name, TaxCode, StateId) values(3, 15,'Montana State Unemployment Tax', 'MT-UI', 25);
insert into AccountTemplate(Type, SubType, Name, TaxCode, StateId) values(3, 15,'Montana Employment Training Tax', 'MT-AFT', 25);
end