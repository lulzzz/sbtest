set identity_insert [Common].[Memento] On
insert into [Common].[Memento](Id, Memento, OriginatorType, SourceTypeId, MementoId, Version, DateCreated, CreatedBy, Comments, UserId) 
select Id, Memento, OriginatorType, SourceTypeId, MementoId, Version, DateCreated, CreatedBy, Comments, UserId from PaxolProd.Common.Memento

set identity_insert [Common].[Memento] Off

insert into [Common].[StagingData](Id, OriginatorType, MementoId, Memento, DateCreated) select * from PaxolProd.Common.StagingData;

insert into MasterExtract select Id, Extract from PaxolProd.dbo.MasterExtracts
drop table PaxolProd.Common.Memento;
drop table PaxolProd.Common.Mementos;
drop table PaxolProd.Common.StagingData;
Alter table PaxolProd.dbo.MasterExtracts drop column [Extract];