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
	}
}