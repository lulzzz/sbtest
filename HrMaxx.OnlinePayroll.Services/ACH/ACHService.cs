using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Payroll;

namespace HrMaxx.OnlinePayroll.Services.ACH
{
	public class ACHService : BaseService, IACHService
	{
		private readonly IPayrollRepository _payrollRepository;
		public ACHService(IPayrollRepository payrollRepository)
		{
			_payrollRepository = payrollRepository;
		}
		public void FillACH()
		{
			try
			{
				FillACHInvoices();
				FillACHPayChecks();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Fill ACH table");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private void FillACHPayChecks()
		{
			
		}

		private void FillACHInvoices()
		{
			

		}
	}
}
