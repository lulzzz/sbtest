using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Host : BaseEntityDto, IOriginator<Host>
	{
		public string FirmName { get; set; }
		public string Url { get; set; }
		public DateTime EffectiveDate { get; set; }
		public DateTime? TerminationDate { get; set; }
		public int StatusId { get; set; }
		public Guid? CompanyId { get; set; }
		public Company Company { get; set; }
		public string PTIN { get; set; }
		public string DesigneeName940941 { get; set; }
		public string PIN940941 { get; set; }
		public HostHomePage HomePage { get; set; }
		public bool IsPeoHost { get; set; }
		public Guid MementoId { get { return Id; } }
		public void ApplyMemento(Memento<Host> memento)
		{
			throw new NotImplementedException();
		}
	}
}
