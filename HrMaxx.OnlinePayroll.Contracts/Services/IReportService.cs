using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IReportService
	{
		ReportResponse GetReport(ReportRequest request);
		FileDto GetReportDocument(ReportRequest request);
		Extract GetExtractDocument(ReportRequest request);
		FileDto PrintPayrollSummary(Payroll payroll, bool saveToDisk = false, string path = "");
		FileDto PrintCertifiedReport(Payroll payroll, List<TimesheetEntry> timesheets, bool saveToDisk = false, string path = "", bool xml = false);
		List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest);
		List<MasterExtract> GetExtractList(string report);
		List<SearchResult> GetSearchResults(string criteria, string role, Guid host, Guid company);
		ACHExtract GetACHReport(ReportRequest request);
		ACHExtract GetACHExtract(ACHExtract data, string fullName);
		
		FileDto PrintPayrollWithoutSummary(Payroll payroll, List<Guid> documents);
		FileDto PrintPayrollTimesheet(Payroll payroll);
		FileDto PrintPayrollWithoutSummary(Payroll payroll, List<FileDto> documents);
		Extract GetExtractTransformedWithFile(Extract extract);
		MasterExtract GetExtract(int id);
		ACHMasterExtract GetAchReportExtract(int id);
		CommissionsExtract GetCommissionsReport(CommissionsReportRequest request);
		MasterExtract PayCommissions(CommissionsExtract extract, string fullName);
		CommissionsExtract GetCommissionsExtract(int id);
		void DeleteExtract(int extractId);
		MasterExtract ConfirmExtract(MasterExtract extract);
		CPAReport GetCPAReport(ReportRequest request);
		FileDto GetExtractTransformedAndPrinted(Extract extract);
		FileDto GetExtractTransformedAndPrintedZip(Extract extract);
		List<MinWageEligibileCompany> GetMinWageEligibilityReport(MinWageEligibilityCriteria criteria);
		CompanyDashboard GetCompanyDashboard(Guid id);
		CompanyDashboard GetEmployeeDashboard(Guid companyId, Guid id);
		CompanyDashboard GetExtractDashboard();

		StaffDashboard GetStaffDashboard(Guid? hostId, Guid guid);
		EmployeeDocumentMetaData GetStaffDashboardDocuments(Guid? hostId);        
    }
}
