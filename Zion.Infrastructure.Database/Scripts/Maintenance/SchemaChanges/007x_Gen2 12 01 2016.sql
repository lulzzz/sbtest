IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyDeduction'
                 AND COLUMN_NAME = 'FloorPerCheck')
Alter table CompanyDeduction Add FloorPerCheck decimal(18,2);
Go;
/****** Object:  Index [IX_Memento]    Script Date: 2/12/2016 3:38:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Memento] ON [Common].[Memento]
(
	[SourceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_Memento_1]    Script Date: 2/12/2016 3:39:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Memento_1] ON [Common].[Memento]
(
	[MementoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO