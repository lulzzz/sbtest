using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Autofac;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.TestSupport;
using Magnum;
using NUnit.Framework;
using StoryQ;

namespace HrMaxx.OnlinePayroll.IntegrationTests.Stories.ConfirmPayroll
{
	public class TwentyPEOPayrollConfirmation : BaseIntegrationTestFixture
	{

		private List<Payroll> originalPayrolls = new List<Payroll>();
		private List<Payroll> confirmedPayrolls = new List<Payroll>();
		private List<Payroll> savedPayrolls = new List<Payroll>();

		[Test]
		public void SavePhotoCheckList_PhotoCheckListDoesNotExist()
		{
			
				new Story("Confirm 20 PEO Payrolls")
					.InOrderTo("Save the Payrolls in a sequence")
					.AsA("User")
					.IWant("to confirm payrolls")
					.WithScenario("multiple payrolls with PEO check number to be saved in a queue")
					.Given(ProcessedPayrolls)
					.When(PayrollsConfirmed)
					.Then(PayrollsConfirmedCorrectly)
					.ExecuteWithReport(MethodBase.GetCurrentMethod());
			
		}

		public void ProcessedPayrolls()
		{
			using (var scope = TestLifetimeScope.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollService = scope.Resolve<IPayrollService>();

				originalPayrolls = _readerService.GetPayrolls(null, startDate: new DateTime(2018,1,1).Date, endDate: new DateTime(2018,1,10).Date).Where(p=>p.PEOASOCoCheck).OrderByDescending(p => p.PayDay).Take(1).ToList();
				originalPayrolls.ForEach(p =>
				{
					p.Id = CombGuid.Generate();
					p.Status = PayrollStatus.Draft;
					p.UserId = Guid.Empty;
					p.UserName = "Test";
					p = _payrollService.ProcessPayroll(p);
				});
			}
		}

		public void PayrollsConfirmed()
		{

			//originalPayrolls.ForEach(p => Task.Factory.StartNew(() => ConfirmPayroll(p)));
			using (var scope = TestLifetimeScope.BeginLifetimeScope())
			{
				var _payrollService = scope.Resolve<IPayrollService>();
				originalPayrolls.ForEach(p => confirmedPayrolls.Add(_payrollService.ConfirmPayroll(p)));
				
			}
			
		}
	
		public void PayrollsConfirmedCorrectly()
		{
			using (var scope = TestLifetimeScope.BeginLifetimeScope())
			{
				var _taxationService = scope.Resolve<ITaxationService>();
				var _readerService = scope.Resolve<IReaderService>();
				while (confirmedPayrolls.Any(p => savedPayrolls.All(p1 => p1.Id != p.Id)))
				{
					confirmedPayrolls.Where(p=>savedPayrolls.All(p1 => p1.Id != p.Id)).ToList().ForEach(p =>
					{
						var queueItem = _taxationService.GetConfirmPayrollQueueItem(p.Id);
						if (queueItem == null || queueItem.ConfirmedTime.HasValue)
						{
							savedPayrolls.Add(_readerService.GetPayroll(p.Id));
						}
					});
					
				}
			}
			Assert.That(originalPayrolls.Count, Is.EqualTo(confirmedPayrolls.Count));
			
		}
		[TearDown]
		public void VoidAndDeleteSavedPayrolls()
		{
			using (var scope = TestLifetimeScope.BeginLifetimeScope())
			{
				var _payrollService = scope.Resolve<IPayrollService>();
				savedPayrolls.ForEach(p =>
				{
					_payrollService.VoidPayroll(p, "Test", Guid.Empty.ToString());
					_payrollService.DeletePayroll(p);
				});
			}

		}
	}
}
