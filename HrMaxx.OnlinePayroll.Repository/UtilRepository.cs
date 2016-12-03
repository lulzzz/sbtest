using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using BankAccount = HrMaxx.OnlinePayroll.Models.BankAccount;

namespace HrMaxx.OnlinePayroll.Repository
{
	public class UtilRepository : IUtilRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;

		public UtilRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}


		public BankAccount SaveBankAccount(BankAccount bankAccount)
		{
			var mappedAccount = _mapper.Map<BankAccount, Models.DataModel.BankAccount>(bankAccount);
			if (mappedAccount.Id == 0)
			{
				_dbContext.BankAccounts.Add(mappedAccount);
			}
			else
			{
				var dbBankAccount = _dbContext.BankAccounts.First(ba => ba.Id == mappedAccount.Id);
				if (dbBankAccount != null)
				{
					dbBankAccount.AccountType = mappedAccount.AccountType;
					dbBankAccount.AccountName = mappedAccount.AccountName;
					dbBankAccount.AccountNumber = mappedAccount.AccountNumber;
					dbBankAccount.BankName = mappedAccount.BankName;
					dbBankAccount.LastModified = mappedAccount.LastModified;
					dbBankAccount.LastModifiedBy = mappedAccount.LastModifiedBy;
					dbBankAccount.RoutingNumber = mappedAccount.RoutingNumber;
					dbBankAccount.EntityTypeId = mappedAccount.EntityTypeId;
					dbBankAccount.EntityId = mappedAccount.EntityId;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.BankAccount, BankAccount>(mappedAccount);

		}

		public void FillCompanyAccounts(Guid companyId, string userName)
		{
			var companyAccount = _dbContext.CompanyAccounts.Where(c => c.CompanyId == companyId && c.TemplateId.HasValue).Select(ca=>ca.TemplateId).ToList();
			var accountTemplates = _dbContext.AccountTemplates.Where(at=>!companyAccount.Contains(at.Id)).ToList();

			if (accountTemplates.Any())
			{
				var companyAccounts = _mapper.Map<List<AccountTemplate>, List<CompanyAccount>>(accountTemplates);
				companyAccounts.ForEach(ac =>
				{
					ac.CompanyId = companyId;
					ac.LastModifiedBy = userName;
				});
				_dbContext.CompanyAccounts.AddRange(companyAccounts);
				_dbContext.SaveChanges();
			}
			
		}
	}
}
