IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'IsCleared')
Alter table Journal Add IsCleared bit not null Default(0), ClearedBy varchar(max), ClearedOn datetime;
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CheckbookJournal'
                 AND COLUMN_NAME = 'IsCleared')
Alter table CheckbookJournal Add IsCleared bit not null Default(0), ClearedBy varchar(max), ClearedOn datetime;

Go
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalIsCleared')
CREATE NONCLUSTERED INDEX [IX_JournalIsCleared] ON [dbo].[Journal]
(
	[IsCleared] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalIsCleared')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalIsCleared] ON [dbo].[CheckbookJournal]
(
	[IsCleared] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
Update Journal set IsCleared=1, ClearedBy='System', ClearedOn=getdate();
Update CheckbookJournal set IsCleared=1, ClearedBy='System', ClearedOn=getdate();