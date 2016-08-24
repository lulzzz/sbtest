using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Http;
using Autofac.Features.Metadata;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources;
using HrMaxxAPI.Resources.Journals;

namespace HrMaxxAPI.Controllers.Journals
{
	/// <summary>
	///   HrMaxx Controller is the API for common areas
	/// </summary>
	public class JournalController : BaseApiController
	{
		public readonly IJournalService _journalService;
		public readonly IMetaDataService _metaDataService;

		public JournalController(IJournalService journalService, IMetaDataService metaDataService)
		{
			_journalService = journalService;
			_metaDataService = metaDataService;
		}

		[HttpPost]
		[Route(JournalRoutes.JournalList)]
		public JournalListResource GetJournalList(JournalFilterResource filter)
		{
			var journal = MakeServiceCall(() => _journalService.GetJournalListByCompanyAccount(filter.CompanyId, filter.AccountId, filter.StartDate, filter.EndDate), string.Format("get list of payrolls for company={0}", filter.CompanyId));
			return Mapper.Map<JournalList, JournalListResource>(journal);
		}

		[HttpPost]
		[Route(JournalRoutes.AccountWithJournalList)]
		public List<AccountWithJournal> GetAccountJournalList(JournalFilterResource filter)
		{
			return MakeServiceCall(() => _journalService.GetCompanyAccountsWithJournals(filter.CompanyId, filter.AccountId, filter.StartDate, filter.EndDate), string.Format("get list of payrolls for company={0}", filter.CompanyId));
			
		}

		[HttpGet]
		[Route(JournalRoutes.GetJournalMetaData)]
		public object GetJournalMetaData(Guid companyId)
		{
			return MakeServiceCall(() => _metaDataService.GetJournalMetaData(companyId), "Get journal meta data", true);
		}

		[HttpPost]
		[Route(JournalRoutes.SaveJournal)]
		public JournalResource SaveJournal(JournalResource resource)
		{
			var mapped = Mapper.Map<JournalResource, Journal>(resource);
			mapped.LastModified = DateTime.Now;
			mapped.LastModifiedBy = CurrentUser.FullName;
			mapped.JournalDetails.ForEach(jd =>
			{
				jd.LastModfied = mapped.LastModified;
				jd.LastModifiedBy = mapped.LastModifiedBy;
			});
			var journal = MakeServiceCall(() => _journalService.SaveCheckbookEntry(mapped), string.Format("save journal entry for company={0}", mapped.CompanyId));
			return Mapper.Map<Journal, JournalResource>(journal);
		}

		[HttpPost]
		[Route(JournalRoutes.VoidJournal)]
		public JournalResource VoidJournal(JournalResource resource)
		{
			var mapped = Mapper.Map<JournalResource, Journal>(resource);
			mapped.LastModified = DateTime.Now;
			mapped.LastModifiedBy = CurrentUser.FullName;
			mapped.JournalDetails.ForEach(jd =>
			{
				jd.LastModfied = mapped.LastModified;
				jd.LastModifiedBy = mapped.LastModifiedBy;
			});
			var journal = MakeServiceCall(() => _journalService.VoidCheckbookEntry(mapped), string.Format("void journal entry for company={0}", mapped.CompanyId));
			return Mapper.Map<Journal, JournalResource>(journal);
		}
	}
}