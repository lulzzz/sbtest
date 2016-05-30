/****** Object:  StoredProcedure [dbo].[GetQuotationMetaData]    Script Date: 3/08/2015 5:13:10 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetQuotationMetaData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetQuotationMetaData]
GO
/****** Object:  StoredProcedure [dbo].[GetQuotationMetaData]    Script Date: 3/08/2015 5:13:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetQuotationMetaData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetQuotationMetaData]
	@projectId varchar(max),
	@workId int
AS
BEGIN
	IF @projectId = ''B0DCC87E-CEC0-47AE-A334-C64E68F9D8F7''
	BEGIN
	declare @query varchar(max)
	declare @sourceDb varchar(max)
	select @sourceDb = SourceDb from ProjectSourceDb where ProjectID=@projectId
	
	set @query = ''Select
		(SELECT W.WorkId, W.SiteId, W.SiteName,
			(
				select * from
				(Select ClientRateId ClientRateCodeId, ClientRateCode ClientRateCodeName, 1 WorkTypeId, (select WorkType from '' + @sourceDb + ''tblWorkTypes where worktypeid=1) WorkTypeName
				FROM '' + @sourceDb + ''tblclientratecodes
				where clientrateid = w.clientRateId
				union
				Select ClientRateId ClientRateCodeId, ClientRateCode ClientRateCodeName, 2 WorkTypeId, (select WorkType from '' + @sourceDb + ''tblWorkTypes where worktypeid=2) WorkTypeName
				FROM '' + @sourceDb + ''tblclientratecodes
				where clientrateid = w.civilclientRateId
				)a
				for xml path (''''ClientRateCode''''), ELEMENTS, type
			) ClientRateCodes
			FROM '' + @sourceDb + ''TBLWORKS W
			Where w.workid='' + cast(@workId as varchar) +''
			for xml path (''''WorkOrderDetails''''), ELEMENTS, type),

		(Select WorkTypeID, WorkType, ClientWorkType
		from '' + @sourceDb + ''tblWorkTypes
		for xml path (''''SourceWorkType''''), ELEMENTS, type) ProjectWorkTypes,

		(Select WorkTypeId ID, WorkType as Name
		from QuotationWorkType
		for xml path (''''WorkType''''), ELEMENTS, type) QuotationWorkTypes,

		(Select StatusID, Status
		from QuotationStatus
		for xml path (''''QuoteStatus''''), ELEMENTS, type) QuotationStatuses,

		(Select TaskID, TaskCode, TaskDescription
		from '' + @sourceDb + ''tblTasks 
		for xml path (''''Task''''), ELEMENTS, type) ProjectTasks,

		(Select SubTaskId, SubTask as SubTaskName, WorkTypeId
		from '' + @sourceDb + ''tblSubTask
		for xml path (''''SubTask''''), ELEMENTS, type) ProjectSubTasks,

		(Select QuotationId, ProjectId,WorkId, ClientRateId,QuoteWorkType,RefNo, Version,ProjectWorkType,SubmittedOn Submitted, ApprovedOn Approved, replace(qs.Status,'''' '''','''''''') QuoteStatus,Comment, 
				TotalDJC, TotalSell,LastModifiedBy [User],
				case When not exists( select ''''x'''' from QuotationApprovalStatus where QuotationId = q.QuotationID) then
					''''NotStarted''''
					else
						(select top(1) qvs.VPLStatusName from 
						QuotationApprovalStatus qaps, QuotationVPLStatus qvs
						where qaps.VPLStatus = qvs.VPLStatusId
						and qaps.QuotationId = q.QuotationId
						order by VplStatusTS desc
						)
				end
				ApprovalStatus,
				(Select QuotationItemId, TaskId, ItemId, Quantity, DJC, Sell, Comment
				from [dbo].[QuotationStandardSOR]
				Where QuotationId=q.QuotationID
				for xml path (''''QuotationStandardSOR''''), ELEMENTS, type) StandardSOR,
				(Select QuotationNonStandardItemId, Item, Quantity, DJC, Sell, Comment,MarkupPercentage,
						(Select SubTaskId, SubTask, Quantity, Cost, Comment
						from [dbo].[QuotationNonStandardSORSubTask]
						Where QuotationNonStandardItemID=qnsi.QuotationNonStandardItemId
						for xml path (''''QuotationNonStandardSORSubTask''''), ELEMENTS, type) SubTasks
				from [dbo].[QuotationNonStandardSOR] qnsi
				Where QuotationId=q.QuotationID
				for xml path (''''QuotationNonStandardSOR''''), ELEMENTS, type) NonStandardSOR,
				(
					Select 
						qvps.VPLStatusName as ApprovalStatus, qaps.VPLStatusBy as ApprovalStatusUserId, qaps.VPLStatusByName as ApprovalStatusBy, qaps.VPLStatusTS as ApprovalStatusOn, qaps.Comments
					from [dbo].[QuotationApprovalStatus] qaps, [dbo].[QuotationVPLStatus] qvps
					Where QuotationId=q.QuotationID
					and qaps.VPLStatus = qvps.VPLStatusID
					for xml path (''''QuoteApprovalStatusLog''''), ELEMENTS, type
				) ApprovalStatusLog
		from Quotation q, QuotationStatus qs
		Where 
		q.QuoteStatusID = qs.StatusID
		and q.WorkID = '' + cast(@workId as varchar) +''
		and q.ProjectID = '''''' + @projectId + ''''''
		for xml path (''''Quote''''), ELEMENTS, type) Quotations,

		(Select t.ItemID, t.ItemCode, t.ItemDescription, t.Unit, icr.DJC, icr.Sell,isnull(t.StandardYN,0) IsStandard, ti.WorkTypeId,icr.ClientRateId,
			(Select TaskID, TaskCode, TaskDescription
				from '' + @sourceDb + ''tblTasks
				Where TaskId = ti.TaskId
				for xml path (''''Task''''), ELEMENTS, type)

		from '' + @sourceDb + ''tblItemsTemplate ti,
		'' + @sourceDb + ''tblItems t,
		'' + @sourceDb + ''tblItemClientRates icr
		where ti.ItemId = t.ItemId
		and t.ItemId = icr.ItemId
		and icr.ClientRateId = ti.ClientRateId
		and isnull(t.StandardYN,0) = 1
		for xml path (''''Item''''), ELEMENTS, type) ProjectItems,

		(Select ItemId, ItemDescription, isnull(MarkUp,0) MarkupPercentage, WorkTypeId
		from '' + @sourceDb + ''tblItems
		where isnull(standardyn,0)=0
		for xml path (''''NonStandardItem''''), ELEMENTS, type) ProjectNonStandardItems

	for xml path(''''QuotationMetaData'''')''
	execute(@query)
	END
END' 
END
GO
