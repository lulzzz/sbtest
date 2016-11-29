IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'Created')
Alter table Company Add Created datetime not null Default(getdate());
Go;

update Company set Created='1/1/2016';

update a set Created=b.Created1
from company a,
(select id, Created, (select min(datecreated) from Common.Memento where SourceTypeId=2 and MementoId=company.Id) Created1 from
Company
)b
where a.Id=b.Id
and b.created1 is not null;
