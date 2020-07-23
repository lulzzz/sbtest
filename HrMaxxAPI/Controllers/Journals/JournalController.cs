using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using Autofac.Features.Metadata;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
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
		public readonly IDocumentService _documentService;
		public readonly IReaderService _readerService;
		public JournalController(IJournalService journalService, IMetaDataService metaDataService, IDocumentService documentService, IReaderService readerService)
		{
			_journalService = journalService;
			_metaDataService = metaDataService;
			_documentService = documentService;
			_readerService = readerService;
		}
		[HttpPost]
		[Route(JournalRoutes.Print)]
		public HttpResponseMessage GetDocument(JournalResource journal)
		{
			
			var mapped = Mapper.Map<JournalResource, Journal>(journal);
			var printed = MakeServiceCall(() => _journalService.Print(mapped), "print journal with id " + mapped.Id, true);
			return Printed(printed);
		}
		private HttpResponseMessage Printed(FileDto document)
		{
			var response = new HttpResponseMessage { Content = new StreamContent(new MemoryStream(document.Data)) };
			response.Content.Headers.ContentType = new MediaTypeHeaderValue(document.MimeType);

			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = document.Filename + document.DocumentExtension
			};
			return response;
		}
		[HttpPost]
		[Route(JournalRoutes.JournalList)]
		public JournalListResource GetJournalList(JournalFilterResource filter)
		{
			var journal = MakeServiceCall(() => _journalService.GetJournalListByCompanyAccount(filter.CompanyId, filter.AccountId, filter.StartDate, filter.EndDate, filter.IncludePayrolls), string.Format("get list of journals for company={0}", filter.CompanyId));
			return Mapper.Map<JournalList, JournalListResource>(journal);
		}
		[HttpPost]
		[Route(JournalRoutes.VendorInvoiceList)]
		public List<CompanyInvoice> GetVendorInvoiceList(JournalFilterResource filter)
		{
			return MakeServiceCall(() => _readerService.GetVendorInvoices(filter.CompanyId, filter.StartDate, filter.EndDate), string.Format("get list of vendor invoices for company={0}", filter.CompanyId));
			
		}


		[HttpPost]
		[Route(JournalRoutes.AccountWithJournalList)]
		public List<AccountWithJournal> GetAccountJournalList(JournalFilterResource filter)
		{
			return MakeServiceCall(() => _journalService.GetCompanyAccountsWithJournals(filter.CompanyId, filter.AccountId, filter.StartDate, filter.EndDate), string.Format("get list of account journals for company={0}", filter.CompanyId));
			
		}

		[HttpGet]
		[Route(JournalRoutes.GetJournalMetaData)]
		public object GetJournalMetaData(Guid companyId, int companyIntId)
		{
			return MakeServiceCall(() => _metaDataService.GetJournalMetaData(companyId, companyIntId), "Get journal meta data", true);
		}
		[HttpGet]
		[Route(JournalRoutes.GetVendorInvoiceMetaData)]
		public object GetVendorInvoiceMetaData(Guid companyId, int companyIntId)
		{
			return MakeServiceCall(() => _metaDataService.GetVendorInvoiceMetaData(companyId, companyIntId), "Get vendor invoice meta data", true);
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
			var journal = MakeServiceCall(() => _journalService.SaveCheckbookEntry(mapped, new Guid(CurrentUser.UserId)), string.Format("save journal entry for company={0}", mapped.CompanyId));
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
			var journal = MakeServiceCall(() => _journalService.VoidCheckbookEntry(mapped, new Guid(CurrentUser.UserId)), string.Format("void journal entry for company={0}", mapped.CompanyId));
			return Mapper.Map<Journal, JournalResource>(journal);
		}
		[HttpPost]

		[Route(JournalRoutes.SaveVendorInvoice)]
		public CompanyInvoice SaveVendorInvoice(CompanyInvoice mapped)
		{
			
			mapped.LastModified = DateTime.Now;
			mapped.LastModifiedBy = CurrentUser.FullName;
			
			var journal = MakeServiceCall(() => _journalService.SaveVendorInvoice(mapped, new Guid(CurrentUser.UserId)), string.Format("save vendor invoice for company={0}", mapped.CompanyId));
			return journal;
		}

		[HttpPost]
		[Route(JournalRoutes.VoidVendorInvoice)]
		public CompanyInvoice VoidVendorInvoice(CompanyInvoice mapped)
		{
			
			mapped.LastModified = DateTime.Now;
			mapped.LastModifiedBy = CurrentUser.FullName;
			
			var journal = MakeServiceCall(() => _journalService.VoidVendorInvoice(mapped, CurrentUser.FullName, new Guid(CurrentUser.UserId)), string.Format("void vendor invoice for company={0}", mapped.CompanyId));
			return journal;
		}

		[HttpPost]
		[Route(JournalRoutes.MarkJournalCleared)]
		public JournalResource MarkJournalCleared(JournalResource resource)
		{
			var journal = Mapper.Map<JournalResource, Journal>(resource);
			var saved =  MakeServiceCall(() => _journalService.ClearJournal(journal, new Guid(CurrentUser.UserId), CurrentUser.FullName), string.Format("clear journal entry for company={0} - {1}",journal.Id, resource.TransactionTypeText));
			return Mapper.Map<Journal, JournalResource>(saved);
		}
	}
}