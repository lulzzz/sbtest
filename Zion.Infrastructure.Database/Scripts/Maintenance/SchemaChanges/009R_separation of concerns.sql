/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 14/02/2017 7:39:02 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtracts]
GO
/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 14/02/2017 7:39:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtracts] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtracts]
	@extract varchar(max) = null,
	@id int = null
	
AS
BEGIN
	
	select Id, StartDate, EndDate, ExtractName, IsFederal, DepositDate, Journals, LastModified, LastModifiedBy,
	case when @id is not null then
		(select Extract from PaxolArchive.dbo.MasterExtract where MasterExtractId=@id)
		else
			null
		end Extract
	from MasterExtracts
	Where 
	((@id is not null and Id=@id) or (@id is null))
	and ((@extract is not null and ExtractName=@extract) or (@extract is null))
	for Xml path('MasterExtractJson'), root('MasterExtractList') , elements, type
		
	

END
GO
