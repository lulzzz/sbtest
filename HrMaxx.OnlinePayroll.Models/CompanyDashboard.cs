using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;

namespace HrMaxx.OnlinePayroll.Models
{
	public class CompanyDashboard
	{
        public Accumulation Accumulation { get; set; }
        public List<TaxExtract> ExtractHistory { get; set; }
		public List<TaxExtract> PendingExtracts { get; set; }
		public List<TaxExtract> PendingExtractsByDates { get; set; }
		public List<TaxExtract> PendingExtractsByCompany { get; set; }
		public List<TaxExtract> PendingExtractsBySchedule { get; set; }
		public EmployeeDocumentMetaData EmployeeDocumentMetaData { get; set; }
		public List<PayrollMetric> PayrollHistory { get; set; }
        
        public List<PayCheckPayTypeAccumulation> Accumulations { get; set; }
		public int? YTDYear { get { return LastPayroll!=null ? LastPayroll.PayDay.Year : default(int?); } }
        public TaxExtract Last941Extract 
		{ 
			get
			{
				return ExtractHistory.FirstOrDefault(e => e.ExtractName.Equals("Federal941") && e.DRank == 1);
			} 
		}
		public TaxExtract Last940Extract
		{
			get
			{
				return ExtractHistory.FirstOrDefault(e => e.ExtractName.Equals("Federal940") && e.DRank == 1);
			}
		}
		public TaxExtract LastCAPITExtract
		{
			get
			{
				return ExtractHistory.FirstOrDefault(e => e.ExtractName.Equals("StateCAPIT") && e.DRank == 1);
			}
		}
		public TaxExtract LastCAUIETTExtract
		{
			get
			{
				return ExtractHistory.FirstOrDefault(e => e.ExtractName.Equals("StateCAUI") && e.DRank == 1);
			}
		}
		public decimal Ytd941Extract
		{
			get
			{
				return ExtractHistory.Where(e => e.ExtractName.Equals("Federal941") && e.DepositDate.Year==DateTime.Today.Year).Sum(e=>e.Amount);
			}
		}
		public decimal Ytd940Extract
		{
			get
			{
				return ExtractHistory.Where(e => e.ExtractName.Equals("Federal940") && e.DepositDate.Year == DateTime.Today.Year).Sum(e => e.Amount);
			}
		}
		public decimal YtdCAPITExtract
		{
			get
			{
				return ExtractHistory.Where(e => e.ExtractName.Equals("StateCAPIT") && e.DepositDate.Year == DateTime.Today.Year).Sum(e => e.Amount);
			}
		}
		public decimal YtdCAUIETTExtract
		{
			get
			{
				return ExtractHistory.Where(e => e.ExtractName.Equals("StateCAUI") && e.DepositDate.Year == DateTime.Today.Year).Sum(e => e.Amount);
			}
		}

		public PayrollMetric LastPayroll
		{
			get { return PayrollHistory.FirstOrDefault(p => p.DRank == 1); }
		}

		public List<TaxExtract> Pending941 { get
		{
			return PendingExtracts.Where(e => e.ExtractName.Equals("Federal941") && !e.TaxesDelayed).ToList();
		} }
		public List<TaxExtract> Pending940
		{
			get
			{
				return PendingExtracts.Where(e => e.ExtractName.Equals("Federal940") && !e.TaxesDelayed).ToList();
			}
		}
		public List<TaxExtract> PendingPit
		{
			get
			{
				return PendingExtracts.Where(e => e.ExtractName.Equals("StateCAPIT") && !e.TaxesDelayed).ToList();
			}
		}
		public List<TaxExtract> PendingUiEtt
		{
			get
			{
				return PendingExtracts.Where(e => e.ExtractName.Equals("StateCAUI") && !e.TaxesDelayed).ToList();
			}
		}
		public List<TaxExtract> PendingDelayed941
		{
			get
			{
				return PendingExtracts.Where(e => e.ExtractName.Equals("Federal941") && e.TaxesDelayed).ToList();
			}
		}
		public List<TaxExtract> PendingDelayed940
		{
			get
			{
				return PendingExtracts.Where(e => e.ExtractName.Equals("Federal940") && e.TaxesDelayed).ToList();
			}
		}
		public List<TaxExtract> PendingDelayedPit
		{
			get
			{
				return PendingExtracts.Where(e => e.ExtractName.Equals("StateCAPIT") && e.TaxesDelayed).ToList();
			}
		}
		public List<TaxExtract> PendingDelayedUiEtt
		{
			get
			{
				return PendingExtracts.Where(e => e.ExtractName.Equals("StateCAUI") && e.TaxesDelayed).ToList();
			}
		}
		public decimal Pending941Amount { get { return Pending941.Sum(e => e.Amount); } }
		public decimal Pending940Amount { get { return Pending940.Sum(e => e.Amount); } }
		public decimal PendingPitAmount { get { return PendingPit.Sum(e => e.Amount); } }
		public decimal PendingUiEttAmount { get { return PendingUiEtt.Sum(e => e.Amount); } }
		public decimal PendingDelayed941Amount { get { return PendingDelayed941.Sum(e => e.Amount); } }
		public decimal PendingDelayed940Amount { get { return PendingDelayed940.Sum(e => e.Amount); } }
		public decimal PendingDelayedPitAmount { get { return PendingDelayedPit.Sum(e => e.Amount); } }
		public decimal PendingDelayedUiEttAmount { get { return PendingDelayedUiEtt.Sum(e => e.Amount); } }

		public PayrollMetric YtdPayroll { get
		{
			return new PayrollMetric
			{
				GrossWage = PayrollHistory.Sum(p => p.GrossWage),
				NetWage = PayrollHistory.Sum(p => p.NetWage),
				EmployeeTaxes = PayrollHistory.Sum(p => p.EmployeeTaxes),
				EmployerTaxes = PayrollHistory.Sum(p => p.EmployerTaxes),
				Deductions = PayrollHistory.Sum(p => p.Deductions),
				NoOfChecks = PayrollHistory.Sum(p=>p.NoOfChecks)
                
            };
		} 
		}

        
    }

	public class TaxExtract
	{
		public DateTime DepositDate { get; set; }
		public string CompanyName { get; set; }
		public string ExtractName { get; set; }
		public decimal Amount { get; set; }
		public int DRank { get; set; }
		public bool TaxesDelayed { get; set; }
		public DepositSchedule941 Schedule { get; set; }
		public string ScheduleText => Schedule.GetDbName();
		public List<TaxExtract> Details { get; set; } 
	}

	public class PayrollMetric
	{
		public DateTime PayDay { get; set; }
		public int NoOfChecks { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public decimal EmployeeTaxes { get; set; }
		public decimal EmployerTaxes { get; set; }
		public decimal Deductions { get; set; }
		public int DRank { get; set; }
        public List<PayrollDeduction> DeductionList { get; set; }
        public List<PayTypeAccumulation> Accumulations { get; set; }
        
    }
}
