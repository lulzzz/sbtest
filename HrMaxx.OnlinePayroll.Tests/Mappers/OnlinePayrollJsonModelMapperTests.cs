using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using AutoMapper.Mappers;
using HrMaxx.OnlinePayroll.ReadServices.Mappers;
using NUnit.Framework;

namespace HrMaxx.OnlinePayroll.Tests.Mappers
{
	public class OnlinePayrollJsonModelMapperTests
	{
		private MappingEngine _mappingEngine;

		[SetUp]
		public void SetUp()
		{
			var configurationStore = new ConfigurationStore(new TypeMapFactory(), MapperRegistry.Mappers);
			configurationStore.AddProfile(
				new OnlinePayrollJsonModelMapperProfile(new Lazy<IMappingEngine>(() => _mappingEngine)));

			_mappingEngine = new MappingEngine(configurationStore);
		}

		[Test]
		public void MapConfiguration_ForAllMappers_IsValid()
		{
			_mappingEngine.ConfigurationProvider.AssertConfigurationIsValid();
		}
	}
}
