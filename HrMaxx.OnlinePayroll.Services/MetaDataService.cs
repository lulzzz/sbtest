using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository;

namespace HrMaxx.OnlinePayroll.Services
{
	public class MetaDataService : BaseService, IMetaDataService
	{
		private readonly ICommonService _commonService;
		private readonly ICompanyService _companyService;
		private readonly IMetaDataRepository _metaDataRepository;
		public MetaDataService(IMetaDataRepository metaDataRepository, ICommonService commonService, ICompanyService companyService)
		{
			_metaDataRepository = metaDataRepository;
			_commonService = commonService;
			_companyService = companyService;
		}

		public object GetCompanyMetaData()
		{
			try
			{
				var countries = _commonService.GetCountries();
				var taxes = _metaDataRepository.GetCompanyOverridableTaxes();
				var deductiontypes = _metaDataRepository.GetDeductionTypes();
				var paytypes = _metaDataRepository.GetAccumulablePayTypes();
				return new {Countries = countries, Taxes = taxes, DeductionTypes = deductiontypes, PayTypes = paytypes};
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
				var paytypes = _metaDataRepository.GetAllPayTypes();
				var bankAccount = _metaDataRepository.GetPayrollAccount(companyId);
				var maxCheckNumber = _metaDataRepository.GetMaxCheckNumber(companyId);
				return new { PayTypes = paytypes, StartingCheckNumber = maxCheckNumber, PayrollAccount = bankAccount };
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
	}
}
