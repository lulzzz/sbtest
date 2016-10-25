namespace HrMaxxAPI.Controllers.Payrolls
{
	public class PayrollRoutes
	{
		public const string Payrolls = "Payroll/Payrolls";
		public const string ProcessPayroll = "Payroll/Process";
		public const string CommitPayroll = "Payroll/Commit";
		public const string VoidPayCheck = "Payroll/VoidPayCheck/{payrollId:guid}/{payCheckId:int}";
		public const string PayCheck = "Payroll/PayCheck/{checkId:int}";
		public const string Invoices = "Payroll/Invoices/{companyId:guid}";
		public const string SaveInvoice = "Payroll/Invoice";
		public const string GetInvoice = "Payroll/Invoice/{invoiceId:guid}";
		public const string GetInvoicePayroll = "Payroll/PayrollsForInvoice/{invoiceId:guid}";
		public const string PrintPayCheck = "Payroll/PrintPayCheck/{payrollId:guid}/{checkId:int}";
		public const string Print = "Payroll/Print";
		public const string MarkPayCheckPrinted = "Payroll/MarkPrinted/{payCheckId:int}";
		public const string PrintPayroll = "Payroll/PrintPayroll";
		public const string FixCompanyCubes = "Payroll/FixCompanyCubes/{companyId:guid}/{year:int}";
		public const string CreatePayrollInvoice = "Payroll/CreatePayrollInvoice";
		public const string HostInvoices = "Payroll/HostInvoices";
		public const string PayrollInvoice = "Payroll/PayrollInvoice";
		public const string DeletePayrollInvoice = "Payroll/DeletePayrollInvoice/{invoiceId:guid}";
		public const string FixPayrollData = "Payroll/FixPayrollData";
		public const string RecreateInvoice = "Payroll/RecreateInvoice/{invoiceId:guid}"; 
		public const string DelayTaxes = "Payroll/DelayTaxes/{invoiceId:guid}";
		public const string RedateInvoice = "Payroll/RedateInvoice";
		public const string ImportTimesheets = "Payroll/ImportTimesheets";
		public const string ImportTimesheetsTemplate = "Payroll/TimesheetImportTemplate";
	}
}