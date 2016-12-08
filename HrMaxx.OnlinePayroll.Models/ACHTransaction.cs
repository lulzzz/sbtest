using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ACHTransaction
	{
		public int Id { get; set; }
		public Guid SourceParentId { get; set; }
		public int SourceId { get; set; }
		public ACHTransactionType TransactionType { get; set; }
		public string TransactionDescription { get; set; }
		public DateTime TransactionDate { get; set; }
		public decimal Amount { get; set; }
		public EntityTypeEnum OriginatorType { get; set; }
		public EntityTypeEnum ReceiverType { get; set; }
		public Guid OriginatorId { get; set; }
		public Guid ReceiverId { get; set; }
		public string Name { get; set; }
		public List<EmployeeBankAccount> EmployeeBankAccounts { get; set; }
		public BankAccount CompanyBankAccount { get; set; }

		public string TransactionTypeText
		{
			get { return TransactionType.GetDbName(); }
			
		}
	}

	
}
