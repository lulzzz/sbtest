using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Serialization;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using HrMaxx.OnlinePayroll.ReadRepository;
using HrMaxx.OnlinePayroll.Repository;
using Magnum.Reflection;

namespace HrMaxx.OnlinePayroll.Services
{
	public class MetaDataService : BaseService, IMetaDataService
	{
		private readonly ICommonService _commonService;
		private readonly ICompanyService _companyService;
		
		private readonly IMetaDataRepository _metaDataRepository;
		private readonly IReaderService _readerService;
		private readonly IReadRepository _reader;
		private readonly ITaxationService _taxationService;
		

		public MetaDataService(IMetaDataRepository metaDataRepository, ICommonService commonService, ICompanyService companyService, IReaderService readerService, ITaxationService taxationService, IReadRepository reader)
		{
			_metaDataRepository = metaDataRepository;
			_commonService = commonService;
			_companyService = companyService;
			_taxationService = taxationService;
			_readerService = readerService;
			_reader = reader;
		}

		public object GetCompanyMetaData()
		{
			try
			{
				var countries = _commonService.GetCountries();
				var taxes = _metaDataRepository.GetCompanyOverridableTaxes();
				var deductiontypes = _metaDataRepository.GetDeductionTypes();
				var paytypes = _metaDataRepository.GetAccumulablePayTypes();
				var insurancegroups = _commonService.GetInsuranceGroups();
				var minWages = _taxationService.GetMinWageTable();
				
				return new CompanyMetaData(){Countries = countries, Taxes = taxes, DeductionTypes = deductiontypes, PayTypes = paytypes, InsuranceGroups= insurancegroups, MinWages = minWages};
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Company");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public DocumentServiceMetaData GetDocumentServiceMetaData(Guid companyId)
		{
			try
			{
				const string sql = "select " +
												 "(select * from DocumentType where Id<6 for xml auto, elements, type) Types, " +
												 "(select *, (select * from DocumentType where Id=Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where CompanyId='{0}' for xml path('CompanyDocumentSubType'), elements, type) CompanyDocumentSubTypes, " +
												 "(select * from Document where SourceEntityId='{0}' and SourceEntityTypeId=2 and Type<>6 for xml path('Document'), elements, type) Docs " +
												 "for Xml path('DocumentServiceMetaData') , elements, type";
				
				//var docs =_metaDataRepository.GetDocumentServiceMetaData(companyId);
				var docs = _reader.GetQueryData<DocumentServiceMetaData>(string.Format(sql, companyId), new XmlRootAttribute("DocumentServiceMetaData"));
				return docs;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Documents");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public EmployeeDocumentMetaData GetEmployeeDocumentServiceMetaData(Guid companyId, Guid employeeId)
		{
			try
			{
				const string sql = "select (select ed.Id, d.TargetEntityId DocumentId," +
				                   "(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type), " +
				                   "FirstAccessed, LastAccessed, '{1}' EmployeeId, " +
				                   "(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type), " +
				                   "(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=d.CompanyDocumentSubType for Xml path('CompanyDocumentSubType'), elements, type) " +
				                   "from Document where TargetEntityId=d.TargetEntityId for Xml path('Document'), elements, type) " +
				                   "from Document d inner join CompanyDocumentSubType cd on d.Type=cd.Type and d.CompanyDocumentSubType=cd.Id	" +
				                   "left outer join EmployeeDocumentAccess ed on ed.DocumentId=d.TargetEntityId and ed.EmployeeId='{1}' " +
				                   "where cd.TrackAccess=1 and cd.CompanyId='{0}' and cd.Type in (3,4) " +
				                   "for xml path('EmployeeDocumentAccess'), elements, type) EmployeeDocumentAccesses, " +
													 "(select ed.Id, (select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),DateUploaded, ed.UploadedBy, '{1}' EmployeeId, '{0}' CompanyId, " +
				                   "(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type), " +
				                   "(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type) " +
				                   "from Document where TargetEntityId=ed.DocumentId for Xml path('Document'), elements, type) " +
				                   "from CompanyDocumentSubType cd left outer join EmployeeDocument ed on ed.CompanyDocumentSubType=cd.Id and ed.EmployeeId='{1}' " +
				                   "where cd.CompanyId='{0}' and cd.Type in (5) " +
				                   "for xml path('EmployeeDocument'), elements, type) EmployeeDocumentRequirements " +
				                   "for xml path('EmployeeDocumentMetaData'), elements, type";

				//var docs =_metaDataRepository.GetDocumentServiceMetaData(companyId);
				var docs = _reader.GetQueryData<EmployeeDocumentMetaData>(string.Format(sql, companyId, employeeId), new XmlRootAttribute("EmployeeDocumentMetaData"));
				return docs;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Employee Documents");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetAccountsMetaData()
		{
			return
				new AccountsMetaData
				{
					Types = HrMaaxxSecurity.GetEnumList<AccountType>(),
					SubTypes = HrMaaxxSecurity.GetEnumList<AccountSubType>()
				};
		}

		public object GetEmployeeMetaData()
		{
			try
			{
				var paytypes = _metaDataRepository.GetAllPayTypes();
				var agencies = _metaDataRepository.GetGarnishmentAgencies();
				var minWages = _taxationService.GetMinWageTable();
				return new EmployeeMetaData { PayTypes = paytypes, Agencies = agencies, MinWages = minWages };
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Employee");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetPayrollMetaData(CheckBookMetaDataRequest request)
		{
			try
			{
				var paytypes = _metaDataRepository.GetAllPayTypes();
				var bankAccount = _metaDataRepository.GetPayrollAccount(request.CompanyId);
				var hostAccount = _metaDataRepository.GetPayrollAccount(request.HostCompanyId);
				var maxCheckNumber = (int) 0;
				var maxPeoNumber = _taxationService.GetPEOMaxCheckNumber();
				if (request.InvoiceSetup != null && request.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
				{
					if (maxPeoNumber > 0)
						maxCheckNumber = maxPeoNumber+1;
					else
					{
						maxCheckNumber = _metaDataRepository.GetMaxCheckNumber(request.HostCompanyIntId, true);
						_taxationService.SetPEOMaxCheckNumber(maxCheckNumber-1);
					}
				}
				else
				{
					maxCheckNumber = _metaDataRepository.GetMaxCheckNumber(request.CompanyIntId, false);
				}
				//var maxCheckNumber = _metaDataRepository.GetMaxCheckNumber((request.InvoiceSetup != null && request.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck) ? request.HostCompanyIntId : request.CompanyIntId, (request.InvoiceSetup != null && request.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck));
				var importMap = _metaDataRepository.GetCompanyTsImportMap(request.CompanyId);
				var agencies = _metaDataRepository.GetGarnishmentAgencies();
				var minWages = _taxationService.GetMinWageTable();
				return new { PayTypes = paytypes, StartingCheckNumber = maxCheckNumber, PayrollAccount = bankAccount, HostPayrollAccount = hostAccount, ImportMap = importMap, Agencies = agencies, MinWages = minWages };
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Payroll for company " + request.CompanyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetJournalMetaData(Guid companyId, int companyIntId)
		{
			try
			{
				var companyAccounts = _companyService.GetComanyAccounts(companyId);
				var payees = _readerService.GetJournalPayees(companyId);
				var maxCheckNumber = _metaDataRepository.GetMaxRegularCheckNumber(companyIntId);
				var maxAdjustmentNumber = _metaDataRepository.GetMaxAdjustmenetNumber(companyIntId);
				return new { Accounts = companyAccounts, Payees = payees, startingCheckNumber = maxCheckNumber, StartingAdjustmentNumber = maxAdjustmentNumber };
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Journal for company " + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetInvoiceMetaData(Guid companyId)
		{
			try
			{
				var payrolls = _metaDataRepository.GetUnInvoicedPayrolls(companyId).Where(p=>p.TotalCost>0).ToList();
				var maxCheckNumber = _metaDataRepository.GetMaxInvoiceNumber(companyId);
				return new {Payrolls = payrolls, StartingInvoiceNumber = maxCheckNumber};
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Invoice for company " + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetUsersMetaData(Guid? host, Guid? company, Guid? employee)
		{
			try
			{
				return _metaDataRepository.GetMetaDataForUser(host==Guid.Empty? null : host, company==Guid.Empty?null : company, employee==Guid.Empty?null : employee);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Usrs ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetDeductionTypes()
		{
			try
			{
				var types = _metaDataRepository.GetDeductionTypes();
				var precedence = _metaDataRepository.GetDeductionTaxPrecendence();
				var precGroups = precedence.GroupBy(p => p.DeductionTypeId).Select(g => new { TypeId= g.Key, List= g.ToList().GroupBy(p1 => p1.StateCode).Select(g2 => new { State = g2.Key, List = g2.ToList() }).ToList()}).ToList();
				return new { Types = types, Precedence = precGroups };
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Usrs ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<TaxByYear> GetCompanyTaxesForYear(int year)
		{
			var taxes = _metaDataRepository.GetCompanyOverridableTaxes();
			return taxes.Where(t => t.TaxYear == year).ToList();
		}

		public List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTax> rates)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var saved = _metaDataRepository.SaveTaxRates(rates);
					txn.Complete();
				}
				return rates;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "saving import of tax rates " + rates.First().TaxYear);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<SearchResult> FillSearchTable()
		{
			try
			{
				var companies = _readerService.GetCompanies(status:0); //_companyService.GetAllCompanies();
				var employees = _readerService.GetEmployees(status:0);
				var searchResults = new List<SearchResult>();
				foreach (var company in companies)
				{
					searchResults.Add(new SearchResult()
					{
						Id = 0,
						SourceTypeId = EntityTypeEnum.Company,
						SourceId = company.Id,
						HostId = company.HostId,
						CompanyId = company.Id,
						SearchText = company.GetSearchText
					});
				}
				foreach (var employee in employees)
				{
					searchResults.Add(new SearchResult()
					{
						Id = 0,
						SourceTypeId = EntityTypeEnum.Employee,
						SourceId = employee.Id,
						HostId = companies.First(c => c.Id == employee.CompanyId).HostId,
						CompanyId = employee.CompanyId,
						SearchText = employee.GetSearchText
					});
				}
				return _metaDataRepository.FillSearchResults(searchResults);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "fill search table ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public List<CompanySUIRate> GetPEOCompanies()
		{
			var companies = _readerService.GetCompanies().Where(c=>c.Contract.InvoiceSetup.InvoiceType==CompanyInvoiceType.PEOASOCoCheck).ToList();
			return
				companies.Select(
					c =>
						new
						CompanySUIRate{
							Id = c.Id,
							CompanyNo = c.CompanyNo,
							TaxRates = c.CompanyTaxRates,
							SUIManagementRate = c.Contract.InvoiceSetup.SUIManagement,
							Name = c.Name
						}).ToList();
		}

		public List<Access> GetAccessMetaData()
		{
			return _readerService.GetDataFromStoredProc<List<Access>, List<Access>>(
					"GetAccessMetaData", new List<FilterParam>(), new XmlRootAttribute("AccessList"));
		}

		public DeductionType SaveDeductionType(DeductionType dt, List<PreTaxDeduction> precedence)
		{
			try
			{
				var dedType = _metaDataRepository.SaveDeductionType(dt);
				_metaDataRepository.SaveDeductionPrecedence(precedence);
				_taxationService.UpdateTaxDeductionPrecedence(precedence);
				return dedType;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " deduction type ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public CompanyDocumentSubType SaveDocumentSubType(CompanyDocumentSubType dt)
		{
			try
			{
				return _metaDataRepository.SaveDocumentSubType(dt);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " deduction type ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SetEmployeeAccess(Guid employeeId, Guid documentId)
		{
			try
			{
				_metaDataRepository.SetEmployeeDocumentAccess(employeeId, documentId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update employee document view ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

        public IList<PayType> GetAllPayTypes()
        {
            try
            {
               var list = _metaDataRepository.GetAllPayTypes();
               return list;
            }
            catch (Exception e)
            {
                var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Pay types ");
                Log.Error(message, e);
                throw new HrMaxxApplicationException(message, e);
            }
        }

        public PayType SavePayType(PayType payType)
        {
            try
            {
                var saved = _metaDataRepository.SavePayType(payType);
                return saved;
            }
            catch (Exception e)
            {
                var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Pay type ");
                Log.Error(message, e);
                throw new HrMaxxApplicationException(message, e);
            }
        }

        public List<KeyValuePair<int, DateTime>> GetBankHolidays()
		{
			try
			{
				var list = _metaDataRepository.GetBankHolidays();
				if (list == null)
					return new List<KeyValuePair<int, DateTime>>();
				else
					return list;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " bank holidays ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object SaveBankHoliday(DateTime holiday, bool action)
		{
			try
			{
				return _metaDataRepository.SaveBankHoliday(holiday, action);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " bank holiday ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}
