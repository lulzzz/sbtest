delete from ACHTransactionExtract where ACHTransactionId in 
		(select Id from
			(
			select *, rn=row_number() over (partition by SourceParentId, SourceId, TransactionType order by Id)
			from ACHTransaction 
			)a where rn>1
		);
delete a from (
select *, rn=row_number() over (partition by SourceParentId, SourceId, TransactionType order by Id)
from ACHTransaction 
)a where rn>1;
if not exists(SELECT * FROM INFORMATION_SCHEMA.Table_CONSTRAINTS WHERE CONSTRAINT_NAME='ACHUnique')
	ALTER TABLE ACHTransaction ADD Constraint ACHUnique UNIQUE (SourceParentId, SourceId, TransactionType);