using System;
using AutoMapper;
using AutoMapper.Mappers;
using HrMaxx.OnlinePayroll.Services.Mappers;
using NUnit.Framework;
using SiteInspectionStatus_Utility;

namespace HrMaxx.ImportData.Tests.Mappers
{
	public class ImportModelMapperTests
	{
		private MappingEngine _mappingEngine;

		[SetUp]
		public void SetUp()
		{
			var configurationStore = new ConfigurationStore(new TypeMapFactory(), MapperRegistry.Mappers);
			configurationStore.AddProfile(
				new ImportMapperProfile(new Lazy<IMappingEngine>(() => _mappingEngine)));

			_mappingEngine = new MappingEngine(configurationStore);
		}

		[Test]
		public void MapConfiguration_ForAllMappers_IsValid()
		{
			_mappingEngine.ConfigurationProvider.AssertConfigurationIsValid();
		}
	}
}