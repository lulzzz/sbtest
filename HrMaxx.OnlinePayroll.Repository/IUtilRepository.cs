using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository
{
	public interface IUtilRepository
	{
		BankAccount SaveBankAccount(BankAccount bankAccount);
		void FillCompanyAccounts(Guid id, string userName, List<int> stateId);
	}
}
