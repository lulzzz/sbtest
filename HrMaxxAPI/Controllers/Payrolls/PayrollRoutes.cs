namespace HrMaxxAPI.Controllers.Payrolls
{
	public class PayrollRoutes
	{
		public const string Payrolls = "Payroll/Payrolls";
		public const string ProcessPayroll = "Payroll/Process";
		public const string CommitPayroll = "Payroll/Commit";
		public const string VoidPayCheck = "Payroll/VoidPayCheck/{payrollId:guid}/{payCheckId:int}";
		public const string PayCheck = "Payroll/PayCheck/{checkId:int}";
	}
}