using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.OnlinePayroll.Models
{
	public class PayrollStaging : IOriginator<PayrollStaging>
	{
		public Payroll Payroll { get; set; }
		public Guid CompanyId { get; set; }
		public Guid MementoId { get { return CompanyId; } }
		public void ApplyMemento(Memento<PayrollStaging> memento)
		{
			throw new NotImplementedException();
		}
	}
}
