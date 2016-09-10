using System;
using System.Linq;
using System.Net.Cache;
using HrMaxx.Bus.Contracts;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Reports;

namespace HrMaxx.OnlinePayroll.Services.Reports
{
	public class ReportService : BaseService, IReportService
	{
		private readonly IReportRepository _reportRepository;
		private readonly ICompanyRepository _companyRepository ;
		
		public IBus Bus { get; set; }

		public ReportService(IReportRepository reportRepository, ICompanyRepository companyRepository)
		{
			_reportRepository = reportRepository;
			_companyRepository = companyRepository;

		}


		public ReportResponse GetReport(ReportRequest request)
		{
			try
			{
				if (request.ReportName.Equals("PayrollRegister"))
					return GetPayrollRegisterReport(request);
				else if (request.ReportName.Equals("PayrollSummary"))
					return GetPayrollSummaryReport(request);
				else if (request.ReportName.Equals("PayrollSummary"))
					return GetDeductionsReport(request);
				return GetWorkerCompensationReport(request);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get report data for report={0} {1}-{2}", request.ReportName, request.StartDate.ToString(), request.EndDate.ToString()));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private ReportResponse GetWorkerCompensationReport(ReportRequest request)
		{
			var response = new ReportResponse
			{
				Company = _companyRepository.GetCompanyById(request.CompanyId),
				EmployeeAccumulations = _reportRepository.GetEmployeeGroupedChecks(request, false),
				CompanyAccumulation = new PayrollAccumulation()
			};
			response.EmployeeAccumulations.Where(ea => ea.Accumulation.EmployeeWorkerCompensations > 0).ToList().ForEach(ea => response.CompanyAccumulation.Add(ea.Accumulation));

			return response;
		}

		private ReportResponse GetDeductionsReport(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = _companyRepository.GetCompanyById(request.CompanyId);
			response.EmployeeAccumulations = _reportRepository.GetEmployeeGroupedChecks(request, false);
			response.CompanyAccumulation = new PayrollAccumulation();
			response.EmployeeAccumulations.Where(ea=>ea.Accumulation.EmployeeDeductions>0).ToList().ForEach(ea => response.CompanyAccumulation.Add(ea.Accumulation));
			
			return response;
		}

		private ReportResponse GetPayrollSummaryReport(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = _companyRepository.GetCompanyById(request.CompanyId);
			response.EmployeeAccumulations = _reportRepository.GetEmployeeGroupedChecks(request, false);
			if (request.Month > 0 || request.Quarter > 0)
				response.CompanyAccumulation = _reportRepository.GetCompanyPayrollCube(request);
			else
			{
				response.CompanyAccumulation = new PayrollAccumulation();
				response.EmployeeAccumulations.ForEach(ea=>response.CompanyAccumulation.Add(ea.Accumulation));
			}
			return response;
		}

		private ReportResponse GetPayrollRegisterReport(ReportRequest request)
		{
			var response = new ReportResponse();
			response.PayChecks = _reportRepository.GetReportPayChecks(request, true);
			return response;

		}
	}
}
