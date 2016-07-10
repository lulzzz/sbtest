using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Repository.Host
{
	public class HostRepository : IHostRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		private string _domain;
		public HostRepository(IMapper mapper, OnlinePayrollEntities dbContext, string domain)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			_domain = domain;
		}

		public IList<Models.Host> GetHostList()
		{
			var hosts = _dbContext.Hosts.ToList();
			return _mapper.Map<List<Models.DataModel.Host>, List<Models.Host>>(hosts);
		}

		public Models.Host GetHost(Guid cpaId)
		{
			var cpa = _dbContext.Hosts.FirstOrDefault(c => c.Id.Equals(cpaId));
			if(cpa==null)
				return new Models.Host();
			return _mapper.Map<Models.DataModel.Host, Models.Host>(cpa);
		}

		public void Save(Models.Host cpa)
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
			}
			_dbContext.SaveChanges();
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

		public Models.Host GetHostByUrl(string url)
		{
			var hosts = _dbContext.Hosts.ToList();
			if (!hosts.Any())
				return null;
			var host = hosts.FirstOrDefault(h => string.Format(_domain, h.Url).Equals(url));
			if (host == null)
				host = hosts.First();
			return _mapper.Map<Models.DataModel.Host, Models.Host>(host);
		}

		public Models.Host GetHostByFirmName(string firmName)
		{
			var hosts = _dbContext.Hosts.ToList();
			var host = hosts.FirstOrDefault(h => h.FirmName.ToLower().Equals(firmName.ToLower()));
			if (host == null)
				host = hosts.First(h => h.Url.ToLower().Equals("payroll"));
			return _mapper.Map<Models.DataModel.Host, Models.Host>(host);
		}
	}
}
