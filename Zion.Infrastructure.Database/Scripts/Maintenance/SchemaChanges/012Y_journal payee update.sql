/****** Object:  StoredProcedure [dbo].[GetJournalPayees]    Script Date: 23/05/2019 1:44:43 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalPayees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournalPayees]
GO
/****** Object:  StoredProcedure [dbo].[GetJournalPayees]    Script Date: 23/05/2019 1:44:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalPayees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournalPayees] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetJournalPayees]
	@company uniqueidentifier = null,
	@payeeId uniqueidentifier = null,
	@payeeType int = null
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	@payeeId1 uniqueidentifier = @payeeId,
	@payeeType1 int = @payeeType

	declare @host uniqueidentifier, @IsHostCompany bit
	select @host = HostId, @IsHostCompany = IsHostCompany from Company where Id=@company1

	select a.* from
	(
		select Id, CompanyName as PayeeName, 'Company' as PayeeType,
		(
			select top(1) TargetObject
			from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=Company.Id
			
		) Contact, CompanyAddress Address
		from Company where HostId=@host and IsHostCompany=0 and @IsHostCompany=1
		union
		select Id, (FirstName + ' ' + MiddleInitial + ' ' + LastName) PayeeName, 'Employee' as PayeeType, Contact, '' Address
		from Employee where CompanyId=@company1
		union
		select Id, Name as PayeeName, case when IsVendor=1 then 'Vendor' else 'Customer' end PayeeType, Contact, '' Address
		from VendorCustomer where CompanyId=@company1 or CompanyId is null
	)a, EntityType et
	where a.PayeeType = et.EntityTypeName
	and ((@payeeId1 is not null and Id=@payeeId1) or @payeeId1 is null)
	and ((@payeeType1 is not null and et.EntityTypeId=@payeeType1) or @payeeType1 is null)
	for Xml path('JournalPayeeJson'), root('JournalPayeeList') , elements, type
		
	
	

END
GO
