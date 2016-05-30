IF NOT EXISTS (SELECT schema_name 
    FROM information_schema.schemata 
    WHERE schema_name = 'Common' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA Common;';
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[StagingData]') AND type in (N'U'))
	DROP TABLE [Common].[StagingData]
GO

CREATE TABLE Common.StagingData
(
	Id 				[uniqueidentifier]		NOT NULL DEFAULT newid(),
	OriginatorType 	VARCHAR(255)			NOT NULL,
	MementoId 		[uniqueidentifier]		NOT NULL,
	Memento 		varchar(max)			NOT NULL,
	[DateCreated]	[datetime]				NOT NULL
);

ALTER TABLE Common.StagingData ADD CONSTRAINT
	PK__StagingData PRIMARY KEY NONCLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


CREATE CLUSTERED INDEX IX_Mementos_Id_OriginatorType ON Common.StagingData
	(
	MementoId,
	OriginatorType
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [Common].[StagingData] ADD  CONSTRAINT [DF_StagingData_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

