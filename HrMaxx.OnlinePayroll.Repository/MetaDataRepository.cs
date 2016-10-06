using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using Newtonsoft.Json;
using DeductionType = HrMaxx.OnlinePayroll.Models.DeductionType;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;

namespace HrMaxx.OnlinePayroll.Repository
{
	public class MetaDataRepository : IMetaDataRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		
		public MetaDataRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public IList<TaxByYear> GetCompanyOverridableTaxes()
		{
			var taxes = _dbContext.TaxYearRates.Where(t=>t.Tax.IsCompanySpecific).ToList();
			return _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxes);
		}

		public IList<DeductionType> GetDeductionTypes()
		{
			var types = _dbContext.DeductionTypes.ToList();
			return _mapper.Map<List<Models.DataModel.DeductionType>, List<DeductionType>>(types);
		}

		public IList<PayType> GetAccumulablePayTypes()
		{
			var paytypes = _dbContext.PayTypes.Where(pt=>pt.IsAccumulable).ToList();
			return _mapper.Map<List<Models.DataModel.PayType>, List<PayType>>(paytypes);
		}

		public IList<PayType> GetAllPayTypes()
		{
			var paytypes = _dbContext.PayTypes.ToList();
			return _mapper.Map<List<Models.DataModel.PayType>, List<PayType>>(paytypes);
		}

		public IList<TaxByYear> GetAllTaxes()
		{
			var taxes = _dbContext.TaxYearRates.ToList();
			return _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxes);
		}

		public Account GetPayrollAccount(Guid companyId)
		{
			var account =
				_dbContext.CompanyAccounts.FirstOrDefault(
					c =>
						c.CompanyId == companyId && c.Type == (int) AccountType.Assets && c.SubType == (int) AccountSubType.Bank &&
						c.UsedInPayroll);
			return _mapper.Map<CompanyAccount, Account>(account);
		}

		public int GetMaxCheckNumber(Guid companyId)
		{
			var journals = _dbContext.Journals.Where(p => p.CompanyId == companyId && !p.IsVoid).ToList();
			if (journals.Any())
			{
				var max  = journals.Max(p => p.CheckNumber) + 1;
				max = max <= 0 ? 1001 : max;
				return max; 
			}
				
			else
			{
				return 1001;
			}
		}

		public int GetMaxAdjustmenetNumber(Guid companyId)
		{
			var journals = _dbContext.Journals.Where(p => p.CompanyId == companyId && !p.IsVoid && p.TransactionType==(int)TransactionType.Adjustment).ToList();
			if (journals.Any())
			{
				var max = journals.Max(p => p.CheckNumber) + 1;
				max = max <= 0 ? 1 : max;
				return max;
			}

			else
			{
				return 1;
			}
		}

		public List<Models.Payroll> GetUnInvoicedPayrolls(Guid companyId)
		{
			var payrolls = _dbContext.Payrolls.Where(p => p.CompanyId == companyId && !p.InvoiceId.HasValue && p.Status==3);
			return _mapper.Map<List<Models.DataModel.Payroll>, List<Models.Payroll>>(payrolls.ToList());
		}

		public string GetMaxInvoiceNumber(Guid companyId)
		{
			var maxInvoiceNumber = string.Empty;
			var invoices =
				_dbContext.Invoices.Where(i => i.CompanyId == companyId).OrderByDescending(i => i.InvoiceDate).ToList();
			if (invoices.Any())
				return invoices.First().InvoiceNumber;
			else
			{
				return "1111".PadLeft(8, '0');
			}
		}

		public object GetMetaDataForUser(Guid? host, Guid? company, Guid? employee)
		{
			var hosts = _dbContext.Hosts.Where(h => (host.HasValue && h.Id == host.Value) || (!host.HasValue)).Select(h=>new { h.Id, Name = h.FirmName }).ToList();
			var companies = _dbContext.Companies.Where(c => ((host.HasValue && c.HostId == host.Value) || (!host.HasValue))
																					&& ((company.HasValue && c.Id == company.Value) || (!company.HasValue))).Select(h => new { h.Id, Name = h.CompanyName }).ToList();
			var employees = _dbContext.Employees.Where(e => ((employee.HasValue && e.Id == employee.Value) || !employee.HasValue)
			                                                &&
			                                                ((company.HasValue && e.CompanyId == company.Value) ||
			                                                 !company.HasValue)
			                                                &&
			                                                ((host.HasValue && e.Company.HostId == host.Value) || !host.HasValue)
				).Select(e => new {e.Id, Name = e.FirstName + " " + e.LastName}).ToList();
			return new {Hosts = hosts, Companies = companies, Employees = employees};
		}

		public ApplicationConfig GetConfigurations()
		{
			var config = _dbContext.ApplicationConfigurations.First().config;
			return JsonConvert.DeserializeObject<ApplicationConfig>(config);
		}

		public void SaveApplicationConfig(ApplicationConfig config)
		{
			var dbConfig = _dbContext.ApplicationConfigurations.First();
			dbConfig.config = JsonConvert.SerializeObject(config);
			_dbContext.SaveChanges();

		}
	}
}
