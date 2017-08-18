/****** Object:  Index [IX_JournalCheckNumber]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCheckNumber')
CREATE NONCLUSTERED INDEX [IX_JournalCheckNumber] ON [dbo].[Journal]
(
	[CheckNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalVoid]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalVoid')
CREATE NONCLUSTERED INDEX [IX_JournalVoid] ON [dbo].[Journal]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CompanyAccountType]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccount]') AND name = N'IX_CompanyAccountType')
CREATE NONCLUSTERED INDEX [IX_CompanyAccountType] ON [dbo].[CompanyAccount]
(
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CompanyAccountSubType]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccount]') AND name = N'IX_CompanyAccountSubType')
CREATE NONCLUSTERED INDEX [IX_CompanyAccountSubType] ON [dbo].[CompanyAccount]
(
	[SubType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SearchTableSourceType]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SearchTable]') AND name = N'IX_SearchTableSourceType')
CREATE NONCLUSTERED INDEX [IX_SearchTableSourceType] ON [dbo].[SearchTable]
(
	[SourceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SearchTableSourceId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SearchTable]') AND name = N'IX_SearchTableSourceId')
CREATE NONCLUSTERED INDEX [IX_SearchTableSourceId] ON [dbo].[SearchTable]
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SearchTableCompanyId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SearchTable]') AND name = N'IX_SearchTableCompanyId')
CREATE NONCLUSTERED INDEX [IX_SearchTableCompanyId] ON [dbo].[SearchTable]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SearchTableHostId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SearchTable]') AND name = N'IX_SearchTableHostId')
CREATE NONCLUSTERED INDEX [IX_SearchTableHostId] ON [dbo].[SearchTable]
(
	[HostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO