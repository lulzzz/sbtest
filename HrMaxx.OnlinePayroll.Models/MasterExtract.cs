﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class MasterExtract
	{
		public int Id { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public string ExtractName { get; set; }
		public DateTime DepositDate { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public Extract Extract { get; set; }
		public bool IsFederal { get; set; }
		public List<int> Journals { get; set; }
		public string ConfirmationNo { get; set; }
		public string ConfirmationNoUser { get; set; }
		public DateTime? ConfirmationNoTS { get; set; }
 
	}
	public class ACHMasterExtract
	{
		public int Id { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public ACHExtract Extract { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime DepositDate { get; set; }
	}
}
