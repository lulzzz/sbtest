using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;
using System.Xml.Serialization;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Repository.Host
{
	public class HostRepository : BaseDapperRepository, IHostRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		private string _domain;
		public HostRepository(IMapper mapper, OnlinePayrollEntities dbContext, string domain, DbConnection connection):base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			_domain = domain;
		}

		public IList<Models.Host> GetHostList(Guid host)
		{
			//var hosts = _dbContext.Hosts.AsQueryable();
			var sql = $"select *," +
				$"(select CompanyJson.*, case when exists(select 'x' from company where parentid = CompanyJson.Id) then 1 else 0 end HasLocations," +
				$"(select *, (select * from DeductionType where Id = CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) from(select * from CompanyDeduction left outer join DeductionCompanyWithheld on Id = CompanyDeductionId where CompanyId = CompanyJson.Id) CompanyDeduction for xml auto, elements, type) CompanyDeductions," +
				$"(select * from CompanyWorkerCompensation Where CompanyId = CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations," +
				$"(select *, (select * from PayType Where Id = CompanyAccumlatedPayType.PayTypeId for xml path('PayType'), elements, type) from CompanyAccumlatedPayType Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes, " +
				$"(select * from CompanyContract Where CompanyId = CompanyJson.Id for xml path('CompanyContract'), elements, type), " +
				$"(select * from CompanyRecurringCharge Where CompanyId = CompanyJson.Id for xml auto, elements, type) RecurringCharges, " +
				$"(select *, (select * from Tax where Id = CompanyTaxRate.TaxId for xml path('Tax'), elements, type) from CompanyTaxRate Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyTaxRates, " +
				$"(select * from CompanyTaxState Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, " +
				$"(select * from CompanyPayCode Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyPayCodes," +
				$"(select * from CompanyRenewal Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyRenewals,	" +
				$"(select * from Company Where ParentId = CompanyJson.Id for xml path('CompanyJson'), elements, type) Locations, " +
				$"(select * from InsuranceGroup Where Id = CompanyJson.InsuranceGroupNo for xml auto, elements, type), " +
				$"(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId = 2 and SourceEntityId = CompanyJson.Id and TargetEntityTypeId = 4 order by EntityRelation.EntityRelationId desc) Contact " +
				$"From Company CompanyJson		where CompanyJson.Id = Host.CompanyId for Xml path('Company'), elements, type)	" +
				$"from Host for xml auto, elements, type, root('HostList')";
			var hosts = QueryXmlList<List<Models.JsonDataModel.Host>>(sql, rootAttribute: new XmlRootAttribute("HostList"));
			if (host != Guid.Empty)
				hosts = hosts.Where(h => h.Id == host).ToList();
			return _mapper.Map<List<Models.JsonDataModel.Host>, List<Models.Host>>(hosts);
		}

		public Models.Host GetHost(Guid cpaId)
		{
			//var cpa = _dbContext.Hosts.FirstOrDefault(c => c.Id.Equals(cpaId));
			var sql = $"select *," +
				$"(select CompanyJson.*, case when exists(select 'x' from company where parentid = CompanyJson.Id) then 1 else 0 end HasLocations," +
				$"(select *, (select * from DeductionType where Id = CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) from(select * from CompanyDeduction left outer join DeductionCompanyWithheld on Id = CompanyDeductionId where CompanyId = CompanyJson.Id) CompanyDeduction for xml auto, elements, type) CompanyDeductions," +
				$"(select * from CompanyWorkerCompensation Where CompanyId = CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations," +
				$"(select *, (select * from PayType Where Id = CompanyAccumlatedPayType.PayTypeId for xml path('PayType'), elements, type) from CompanyAccumlatedPayType Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes, " +
				$"(select * from CompanyContract Where CompanyId = CompanyJson.Id for xml path('CompanyContract'), elements, type), " +
				$"(select * from CompanyRecurringCharge Where CompanyId = CompanyJson.Id for xml auto, elements, type) RecurringCharges, " +
				$"(select *, (select * from Tax where Id = CompanyTaxRate.TaxId for xml path('Tax'), elements, type) from CompanyTaxRate Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyTaxRates, " +
				$"(select * from CompanyTaxState Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, " +
				$"(select * from CompanyPayCode Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyPayCodes," +
				$"(select * from CompanyRenewal Where CompanyId = CompanyJson.Id for xml auto, elements, type) CompanyRenewals,	" +
				$"(select * from Company Where ParentId = CompanyJson.Id for xml path('CompanyJson'), elements, type) Locations, " +
				$"(select * from InsuranceGroup Where Id = CompanyJson.InsuranceGroupNo for xml auto, elements, type), " +
				$"(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId = 2 and SourceEntityId = CompanyJson.Id and TargetEntityTypeId = 4 order by EntityRelation.EntityRelationId desc) Contact " +
				$"From Company CompanyJson		where CompanyJson.Id = Host.CompanyId for Xml path('Company'), elements, type)	" +
				$"from Host where Id=@Id for xml auto, elements, type, root('HostList')";
			var hosts = QueryXmlList<List<Models.JsonDataModel.Host>>(sql, new { Id=cpaId}, rootAttribute: new XmlRootAttribute("HostList"));
			if (hosts==null || !hosts.Any())
				return new Models.Host();
			return _mapper.Map<Models.JsonDataModel.Host, Models.Host>(hosts.First());
		}

		public Models.Host Save(Models.Host cpa)
		{
			var mappedCPA = _mapper.Map<Models.Host, Models.DataModel.Host>(cpa);
			var dbCPA = _dbContext.Hosts.FirstOrDefault(c => c.Id.Equals(mappedCPA.Id));
			if (dbCPA == null)
			{
				_dbContext.Hosts.Add(mappedCPA);
			}
			else
			{
				dbCPA.FirmName = mappedCPA.FirmName;
				dbCPA.LastModified = mappedCPA.LastModified;
				dbCPA.LastModifiedBy = mappedCPA.LastModifiedBy;
				dbCPA.EffectiveDate = mappedCPA.EffectiveDate;
				dbCPA.TerminationDate = mappedCPA.TerminationDate;
				dbCPA.StatusId = mappedCPA.StatusId;
				dbCPA.CompanyId = mappedCPA.CompanyId;
				dbCPA.PIN940941 = mappedCPA.PIN940941;
				dbCPA.PTIN = mappedCPA.PTIN;
				dbCPA.DesigneeName940941 = mappedCPA.DesigneeName940941;
				dbCPA.IsPeoHost = mappedCPA.IsPeoHost;
				dbCPA.BankCustomerId = mappedCPA.BankCustomerId;
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.Host, Models.Host>(mappedCPA);
		}

		public string GetHostHomePage(Guid cpaiId)
		{
			return _dbContext.Hosts.First(c => c.Id.Equals(cpaiId)).HomePage;
		}

		public void SaveHomePage(Guid cpaId, string homePage)
		{
			var cpa = _dbContext.Hosts.FirstOrDefault(c => c.Id.Equals(cpaId));
			if (cpa != null)
			{
				cpa.HomePage = homePage;
				_dbContext.SaveChanges();
			}
		}

		public Models.Host GetHostByUrl(string url, Guid hostId, Guid? rootHostId)
		{
			var hosts = _dbContext.Hosts.ToList();
			if (!hosts.Any())
				return null;
			
			if (!hostId.Equals(Guid.Empty))
			{
				var host = hosts.FirstOrDefault(h => h.Id == hostId);
				return _mapper.Map<Models.DataModel.Host, Models.Host>(host);
			}
			else
			{
				var host = hosts.FirstOrDefault(h => h.Url.ToLower().Equals(url.ToLower()));
				if (host == null)
					host = hosts.First(h=>h.Id==rootHostId);
				return _mapper.Map<Models.DataModel.Host, Models.Host>(host);
			}
		}

		public Models.Host GetHostByFirmName(string firmName, Guid hostId)
		{
			var hosts = _dbContext.Hosts.ToList();
			if (!hosts.Any())
				return null;
			if (!hostId.Equals(Guid.Empty))
			{
				var host = hosts.FirstOrDefault(h => h.Id == hostId);
				return _mapper.Map<Models.DataModel.Host, Models.Host>(host);
			}
			else
			{
				var host = hosts.FirstOrDefault(h => h.FirmName.ToLower().Equals(firmName.ToLower()));
				if (host == null)
					host = hosts.First();
				return _mapper.Map<Models.DataModel.Host, Models.Host>(host);
			}
		}

		public Models.Host GetHostById(int hostId)
		{
			//var cpa = _dbContext.Hosts.FirstOrDefault(c => c.HostIntId.Equals(hostId));
			var cpa = QueryObject<Models.DataModel.Host>("select * from Host where HostIntId=@HostIntId", new { HostIntId=hostId});
			if (cpa == null)
				return new Models.Host();
			return _mapper.Map<Models.DataModel.Host, Models.Host>(cpa);
		}
	}
}
