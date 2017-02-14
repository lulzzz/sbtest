set PATH=%PATH%;C:\Program Files\Microsoft SQL Server\110\Tools\Binn;
set server=%1
set db=%2
set userid=%3
set password=%4

sqlcmd -S %server% -v db=%db% -U %userid% -P %password% -i Initialize\CreateDatabase.sql
sqlcmd -S %server% -v db=%db%Archive -U %userid% -P %password% -i Initialize\CreateDatabase.sql
sqlcmd -S %server% -d %db% -U %userid% -P %password% -i Initialize\CreateTables_Common.sql
