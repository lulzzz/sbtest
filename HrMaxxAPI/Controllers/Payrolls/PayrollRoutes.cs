﻿namespace HrMaxxAPI.Controllers.Payrolls
{
	public class PayrollRoutes
	{
		public const string UnPrintedPayrolls = "Payroll/UnPrintedPayrolls";
		public const string Payrolls = "Payroll/Payrolls";
		public const string ProcessPayroll = "Payroll/Process";
		public const string CommitPayroll = "Payroll/Commit";
		public const string VoidPayCheck = "Payroll/VoidPayCheck/{payrollId:guid}/{payCheckId:int}";
		public const string PayCheck = "Payroll/PayCheck/{checkId:int}";
		
		public const string PrintPayCheck = "Payroll/PrintPayCheck/{payrollId:guid}/{checkId:int}";
		public const string Print = "Payroll/Print";
		public const string MarkPayCheckPrinted = "Payroll/MarkPrinted/{payCheckId:int}";
		public const string ReIssuePayCheck = "Payroll/ReIssueCheck/{payCheckId:int}";
		public const string PrintPayrollReport = "Payroll/PrintPayrollReport";
		public const string PrintPayrollTimesheet = "Payroll/PrintPayrollTimesheet";
		public const string PrintPayrollChecks = "Payroll/PrintPayrollChecks";
		public const string FixCompanyCubes = "Payroll/FixCompanyCubes/{year:int}";
		public const string CreatePayrollInvoice = "Payroll/CreatePayrollInvoice";
		
		public const string ApprovedInvoices = "Payroll/ApprovedInvoices";
		public const string PayrollInvoice = "Payroll/PayrollInvoice";
		public const string DeletePayrollInvoice = "Payroll/DeletePayrollInvoice/{invoiceId:guid}";
		public const string GetInvoiceById = "Payroll/PayrollInvoice/{invoiceId:guid}";
		public const string FixPayrollData = "Payroll/FixPayrollData";
		public const string FixPayrollDataForCompany = "Payroll/FixPayrollData/{companyId:guid}";
		public const string RecreateInvoice = "Payroll/RecreateInvoice/{invoiceId:guid}"; 
		public const string DelayTaxes = "Payroll/DelayTaxes/{invoiceId:guid}";
		public const string RedateInvoice = "Payroll/RedateInvoice";
		public const string ImportTimesheets = "Payroll/ImportTimesheets";
		public const string ImportTimesheetsWithMap = "Payroll/ImportTimesheetsWithMap";
		public const string ImportTimesheetsTemplate = "Payroll/TimesheetImportTemplate";
		public const string ClaimDelivery = "Payroll/ClaimDelivery";
		public const string SaveProcessedPayroll = "Payroll/SaveProcessedPayroll";
		public const string DeletePayroll = "Payroll/DeletePayroll";
		public const string VoidPayroll = "Payroll/VoidPayroll";
		public const string InvoiceDeliveryClaims = "Payroll/InvoiceDeliveryClaims";
		public const string EmployeeChecks = "Payroll/EmployeeChecks/{companyId:guid}/{employeeId:guid}";
		public const string FixInvoices = "Payroll/FixInvoices";
		public const string PayrollInvoices = "Payroll/PayrollInvoices";
		public const string UpdatePayrollDates = "Payroll/UpdatePayrollDates";
		public const string FixCubesByCompany = "Payroll/FixCubesByCompany/{companyId:guid}/{year:int}";
		public const string FillPayCheckNormalized = "Payroll/FillPayCheckNormalized";
		public const string UpdateAccumulation = "Payroll/UpdateAccumulation";
		public const string MovePayrolls = "Payroll/MovePayrolls/{source:guid}/{target:guid}";
		public const string CopyPayrolls = "Payroll/CopyPayrolls/{source:guid}/{target:guid}";
		public const string SaveInvoiceDelivery = "Payroll/SaveInvoiceDelivery";
	}
}