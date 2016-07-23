using System;
using AutoMapper;
using AutoMapper.Mappers;
using HrMaxxAPI.Code.Mappers;
using NUnit.Framework;

namespace HrMaxx.OnlinePayroll.Tests.Mappers
{
	public class OnlinePayrollResourceMapperTests
	{
		private MappingEngine _mappingEngine;

		[SetUp]
		public void SetUp()
		{
			var configurationStore = new ConfigurationStore(new TypeMapFactory(), MapperRegistry.Mappers);
			configurationStore.AddProfile(
				new OnlinePayrollResourceMapperProfile(new Lazy<IMappingEngine>(() => _mappingEngine)));

			_mappingEngine = new MappingEngine(configurationStore);
		}

		[Test]
		public void MapConfiguration_ForAllMappers_IsValid()
		{
			_mappingEngine.ConfigurationProvider.AssertConfigurationIsValid();
		}
	}
}