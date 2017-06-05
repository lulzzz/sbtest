using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface ITaxationService
	{
		List<PayrollTax> ProcessTaxes(Company company, PayCheck employee, DateTime payDay, decimal grossWage, Company company1, Accumulation employeeAccumulation);
		ApplicationConfig GetApplicationConfig();
		ApplicationConfig SaveApplicationConfiguration(ApplicationConfig configs);
		int PullReportConstant(string form940, int quarterly);
		USTaxTables GetTaxTables();
		USTaxTables GetTaxTablesByContext();
		USTaxTables SaveTaxTables(int year, USTaxTables taxTables);
		USTaxTables CreateTaxes(int year);
	}
}
