using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;

namespace HrMaxx.OnlinePayroll.Services
{
	public class CompanyService : BaseService, ICompanyService
	{
		private readonly ICompanyRepository _companyRepository;
		public CompanyService(ICompanyRepository companyRepository)
		{
			_companyRepository = companyRepository;
		}

		public IList<Company> GetCompanies(Guid hostId, Guid companyId)
		{
			try
			{
				var companies = _companyRepository.GetCompanies(hostId, companyId);
				return companies;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "company list for host");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Company Save(Company company)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					company.CompanyTaxRates.ForEach(ct =>
					{
						ct.CompanyId = company.Id;

					});
					var savedcompany = _companyRepository.SaveCompany(company);
					var savedcontract = _companyRepository.SaveCompanyContract(savedcompany, company.Contract);
					var savedstates = _companyRepository.SaveTaxStates(savedcompany, company.States);
					savedcompany.Contract = savedcontract;
					savedcompany.States = savedstates;
					txn.Complete();
					return savedcompany;
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "company details for company " + company.Name);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}

		}

		public CompanyDeduction SaveDeduction(CompanyDeduction deduction)
		{
			try
			{
				return _companyRepository.SaveDeduction(deduction);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "deduction for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation)
		{
			try
			{
				return _companyRepository.SaveWorkerCompensation(workerCompensation);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "worker compensation for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource)
		{
			try
			{
				return _companyRepository.SaveAccumulatedPayType(mappedResource);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "accumulated pay type for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyPayCode SavePayCode(CompanyPayCode mappedResource)
		{
			try
			{
				return _companyRepository.SavePayCode(mappedResource);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "pay code for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}
