using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using HrMaxx.OnlinePayroll.Repository;

namespace HrMaxx.OnlinePayroll.Services
{
	public class MetaDataService : BaseService, IMetaDataService
	{
		private readonly ICommonService _commonService;
		private readonly ICompanyService _companyService;
		private readonly IHostService _hostService;
		private readonly IMetaDataRepository _metaDataRepository;
		public MetaDataService(IMetaDataRepository metaDataRepository, ICommonService commonService, ICompanyService companyService, IHostService hostService)
		{
			_metaDataRepository = metaDataRepository;
			_commonService = commonService;
			_companyService = companyService;
			_hostService = hostService;
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
				return new {Countries = countries, Taxes = taxes, DeductionTypes = deductiontypes, PayTypes = paytypes, InsuranceGroups= insurancegroups};
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Company");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetAccountsMetaData()
		{
			return
				new
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
				return new { PayTypes = paytypes };
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Employee");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetPayrollMetaData(Guid companyId)
		{
			try
			{
				var company = _companyService.GetCompanyById(companyId);
				var host = _hostService.GetHost(company.HostId);
				var paytypes = _metaDataRepository.GetAllPayTypes();
				var bankAccount = _metaDataRepository.GetPayrollAccount(companyId);
				var hostAccount = _metaDataRepository.GetPayrollAccount(host.Company.Id);
				var maxCheckNumber = _metaDataRepository.GetMaxCheckNumber((company.Contract.BillingOption==BillingOptions.Invoice && company.Contract.InvoiceSetup!=null && company.Contract.InvoiceSetup.InvoiceType==CompanyInvoiceType.PEOASOCoCheck) ? host.Company.Id : companyId);
				
				return new { PayTypes = paytypes, StartingCheckNumber = maxCheckNumber, PayrollAccount = bankAccount, HostPayrollAccount = hostAccount };
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Payroll for company " + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetJournalMetaData(Guid companyId)
		{
			try
			{
				var companyAccounts = _companyService.GetComanyAccounts(companyId);
				var vendors = _companyService.GetVendorCustomers(companyId, true);
				var customers = _companyService.GetVendorCustomers(companyId, false);
				var maxCheckNumber = _metaDataRepository.GetMaxCheckNumber(companyId);
				var maxAdjustmentNumber = _metaDataRepository.GetMaxAdjustmenetNumber(companyId);
				return new { Accounts = companyAccounts, Vendors = vendors, Customers = customers, startingCheckNumber = maxCheckNumber, StartingAdjustmentNumber = maxAdjustmentNumber };
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
	}
}
