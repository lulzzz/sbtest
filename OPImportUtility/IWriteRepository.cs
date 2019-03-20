using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models;
using Host = HrMaxx.OnlinePayroll.Models.DataModel.Host;
using VendorCustomer = HrMaxx.OnlinePayroll.Models.DataModel.VendorCustomer;

namespace OPImportUtility
{
	public interface IWriteRepository
	{
		void CopyBaseData();
		void SaveHosts(List<Host> dbhosts);
		void SaveCompanies(List<HrMaxx.OnlinePayroll.Models.DataModel.Company> dbcompanies);
		void SaveCompanyContract(Guid companyIntId, ContractDetails contract);
		void SaveCompanyAssociatedData(int companyId);

		void ExecuteQuery(string sql, object unknown);
		void SaveBanks(List<HrMaxx.OnlinePayroll.Models.DataModel.BankAccount> mbanks);
		void SaveVendors(List<VendorCustomer> dbvendors);
		void SaveEmployees(List<HrMaxx.OnlinePayroll.Models.DataModel.Employee> emplList, int companyId);
		void SavePayrolls(List<HrMaxx.OnlinePayroll.Models.DataModel.Payroll> payrolls);
		void SaveJournals(List<HrMaxx.OnlinePayroll.Models.DataModel.Journal> journals);
		int AddExtract(MasterExtract extract, List<HrMaxx.OnlinePayroll.Models.DataModel.Journal> journals );
		void AddToExtract(DateTime startdate, DateTime enddate, HrMaxx.OnlinePayroll.Models.DataModel.Journal journalId, string extractName, MasterExtract extract);
	}
}
