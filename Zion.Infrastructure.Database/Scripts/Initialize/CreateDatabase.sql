USE master
GO

declare @db_path varchar (max)
declare @script varchar (max)

SELECT @db_path = physical_name FROM sys.master_files WHERE database_id = DB_ID(N'master') AND type_desc = 'ROWS'

set @db_path = REPLACE(@db_path, 'master.mdf','')

IF EXISTS(select * from sys.databases where name='$(DB)')
begin
	ALTER DATABASE [$(DB)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(DB)];
end

set @script = 'CREATE DATABASE [$(DB)]
ON 
( NAME =$(DB)_dat,
   FILENAME = ''' + @db_path + '$(DB)dat.mdf'',
   SIZE = 10,
   MAXSIZE = 50,
   FILEGROWTH = 5 )
LOG ON
( NAME = ''$(DB)_log'',
   FILENAME = ''' + @db_path + '$(DB)log.ldf'',
   SIZE = 5MB,
   MAXSIZE = 25MB,
   FILEGROWTH = 5MB )'

EXECUTE (@script)