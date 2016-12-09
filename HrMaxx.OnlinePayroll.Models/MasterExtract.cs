using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class MasterExtract
	{
		public int Id { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public Extract Extract { get; set; }
		public bool IsFederal { get; set; }
		public List<int> Journals { get; set; }
 
	}
	public class ACHMasterExtract
	{
		public int Id { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public ACHExtract Extract { get; set; }
		

	}
}
