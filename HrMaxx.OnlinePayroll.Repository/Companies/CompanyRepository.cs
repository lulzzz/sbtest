using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Newtonsoft.Json;
using Company = HrMaxx.OnlinePayroll.Models.Company;
using CompanyDeduction = HrMaxx.OnlinePayroll.Models.CompanyDeduction;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using CompanyTaxState = HrMaxx.OnlinePayroll.Models.CompanyTaxState;
using CompanyWorkerCompensation = HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation;

namespace HrMaxx.OnlinePayroll.Repository.Companies
{
	public class CompanyRepository : ICompanyRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;

		public CompanyRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public IList<Company> GetCompanies(Guid hostId, Guid companyId)
		{
			var companies = _dbContext.Companies.Where(c => c.HostId == hostId);
			if (companyId != Guid.Empty)
				companies = companies.Where(c => c.Id == companyId);
			return _mapper.Map<List<Models.DataModel.Company>, List<Models.Company>>(companies.ToList());
		}

		public Models.Company SaveCompany(Models.Company company)
		{
			var dbMappedCompany = _mapper.Map<Models.Company, Models.DataModel.Company>(company);
			var dbCompany = _dbContext.Companies.FirstOrDefault(c => c.Id == company.Id);
			if (dbCompany == null)
			{
				_dbContext.Companies.Add(dbMappedCompany);
			}
			else
			{
				dbCompany.BusinessAddress = dbMappedCompany.BusinessAddress;
				dbCompany.CompanyAddress = dbMappedCompany.CompanyAddress;
				dbCompany.CompanyName = dbMappedCompany.CompanyName;
				dbCompany.CompanyNo = dbMappedCompany.CompanyNo;
				dbCompany.DepositSchedule941 = dbMappedCompany.DepositSchedule941;
				dbCompany.DirectDebitPayer = dbMappedCompany.DirectDebitPayer;
				dbCompany.FederalEIN = dbMappedCompany.FederalEIN;
				dbCompany.FederalPin = dbMappedCompany.FederalPin;
				dbCompany.FileUnderHost = dbMappedCompany.FileUnderHost;
				dbCompany.HostId = dbMappedCompany.HostId;
				dbCompany.InsuranceGroupNo = dbMappedCompany.InsuranceGroupNo;
				dbCompany.IsAddressSame = dbMappedCompany.IsAddressSame;
				dbCompany.IsVisibleToHost = dbMappedCompany.IsVisibleToHost;
				dbCompany.LastModified = dbMappedCompany.LastModified;
				dbCompany.LastModifiedBy = dbMappedCompany.LastModifiedBy;
				dbCompany.ManageEFileForms = dbMappedCompany.ManageEFileForms;
				dbCompany.ManageTaxPayment = dbMappedCompany.ManageTaxPayment;
				dbCompany.PayCheckStock = dbMappedCompany.PayCheckStock;
				dbCompany.PayrollDaysInPast = dbMappedCompany.PayrollDaysInPast;
				dbCompany.PayrollSchedule = dbMappedCompany.PayrollSchedule;
				dbCompany.StatusId = dbMappedCompany.StatusId;
				dbCompany.TaxFilingName = dbMappedCompany.TaxFilingName;
				
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.Company, Models.Company>(dbMappedCompany);
		}

		public ContractDetails SaveCompanyContract(Company savedcompany, ContractDetails contract)
		{
			var mapped = _mapper.Map<ContractDetails, CompanyContract>(contract);
			mapped.CompanyId = savedcompany.Id;
			var dbContract = _dbContext.CompanyContracts.FirstOrDefault(c => c.CompanyId == savedcompany.Id);
			if (dbContract == null)
			{
				_dbContext.CompanyContracts.Add(mapped);
			}
			else
			{
				dbContract.BankDetails = mapped.BankDetails;
				dbContract.CardDetails = mapped.CardDetails;
				dbContract.BillingType = mapped.BillingType;
				dbContract.InvoiceRate = mapped.InvoiceRate;
				dbContract.Type = mapped.Type;
				
			}
			_dbContext.SaveChanges();
			return _mapper.Map<CompanyContract, ContractDetails>(mapped);
		}

		public List<CompanyTaxState> SaveTaxStates(Company savedcompany, List<CompanyTaxState> states)
		{
			var mapped = _mapper.Map<List<CompanyTaxState>, List<Models.DataModel.CompanyTaxState>>(states);
			mapped.ForEach(ct=>ct.CompanyId=savedcompany.Id);
			_dbContext.CompanyTaxStates.AddRange(mapped.Where(s => s.Id == 0));
			var dbStates = _dbContext.CompanyTaxStates.Where(c => c.CompanyId == savedcompany.Id).ToList();
			foreach (var existingState in mapped.Where(s=>s.Id!=0))
			{
				var dbState = dbStates.First(s => s.Id == existingState.Id);
				dbState.EIN = existingState.EIN;
				dbState.Pin = existingState.Pin;
			}
			_dbContext.SaveChanges();
			return _mapper.Map<List<Models.DataModel.CompanyTaxState>, List<CompanyTaxState>>(dbStates);
		}

		public CompanyDeduction SaveDeduction(CompanyDeduction deduction)
		{
			var mappeddeduction = _mapper.Map<CompanyDeduction, Models.DataModel.CompanyDeduction>(deduction);
			if (mappeddeduction.Id == 0)
			{
				_dbContext.CompanyDeductions.Add(mappeddeduction);
			}
			else
			{
				var dbdeduction = _dbContext.CompanyDeductions.FirstOrDefault(cd => cd.Id == mappeddeduction.Id);
				if (dbdeduction != null)
				{
					dbdeduction.TypeId = mappeddeduction.TypeId;
					dbdeduction.Description = mappeddeduction.Description;
					dbdeduction.Name = mappeddeduction.Name;
					dbdeduction.AnnualMax = mappeddeduction.AnnualMax;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.CompanyDeduction, CompanyDeduction>(mappeddeduction);
		}

		public CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation)
		{
			var mappedwc = _mapper.Map<CompanyWorkerCompensation, Models.DataModel.CompanyWorkerCompensation>(workerCompensation);
			if (mappedwc.Id == 0)
			{
				_dbContext.CompanyWorkerCompensations.Add(mappedwc);
			}
			else
			{
				var wc = _dbContext.CompanyWorkerCompensations.FirstOrDefault(cd => cd.Id == mappedwc.Id);
				if (wc != null)
				{
					wc.Code = mappedwc.Code;
					wc.Description = mappedwc.Description;
					wc.Rate = mappedwc.Rate;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.CompanyWorkerCompensation, CompanyWorkerCompensation>(mappedwc);
		}

		public AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedAccPayType)
		{
			var mappedwc = _mapper.Map<AccumulatedPayType, Models.DataModel.CompanyAccumlatedPayType>(mappedAccPayType);
			if (mappedwc.Id == 0)
			{
				_dbContext.CompanyAccumlatedPayTypes.Add(mappedwc);
			}
			else
			{
				var wc = _dbContext.CompanyAccumlatedPayTypes.FirstOrDefault(cd => cd.Id == mappedwc.Id);
				if (wc != null)
				{
					wc.RatePerHour = mappedwc.RatePerHour;
					wc.AnnualLimit = mappedwc.AnnualLimit;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.CompanyAccumlatedPayType, AccumulatedPayType>(mappedwc);
		}

		public CompanyPayCode SavePayCode(CompanyPayCode mappedResource)
		{
			var mappedpc = _mapper.Map<CompanyPayCode, Models.DataModel.CompanyPayCode>(mappedResource);
			if (mappedpc.Id == 0)
			{
				_dbContext.CompanyPayCodes.Add(mappedpc);
			}
			else
			{
				var wc = _dbContext.CompanyPayCodes.FirstOrDefault(cd => cd.Id == mappedpc.Id);
				if (wc != null)
				{
					wc.Code = mappedpc.Code;
					wc.Description = mappedpc.Description;
					wc.HourlyRate = mappedpc.HourlyRate;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.CompanyPayCode, CompanyPayCode>(mappedpc);
		}
	}
}
