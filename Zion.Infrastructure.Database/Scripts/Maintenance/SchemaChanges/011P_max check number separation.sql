CREATE TABLE [dbo].[CompanyMaxCheckNumber](
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[CheckNumber] [int] NOT NULL,
 CONSTRAINT [PK_CompanyMaxCheckNumber] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC,
	[TransactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

insert into CompanyMaxCheckNumber
select CompanyId, TransactionType, Max(CheckNumber) from Journal 
where isvoid=0
and TransactionType=1
group by CompanyId, TransactionType;

insert into CompanyMaxCheckNumber
select CompanyId, TransactionType, Max(CheckNumber) from Journal 
where TransactionType in (2,4,6)
group by CompanyId, TransactionType;