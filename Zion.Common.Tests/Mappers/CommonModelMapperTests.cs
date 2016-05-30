using System;
using AutoMapper;
using AutoMapper.Mappers;
using HrMaxx.Common.Services.Mappers;
using NUnit.Framework;

namespace HrMaxx.Common.Tests.Mappers
{
	public class CommonModelMapperTests
	{
		private MappingEngine _mappingEngine;

		[SetUp]
		public void SetUp()
		{
			var configurationStore = new ConfigurationStore(new TypeMapFactory(), MapperRegistry.Mappers);
			configurationStore.AddProfile(
				new CommonModelMapperProfile(new Lazy<IMappingEngine>(() => _mappingEngine)));

			_mappingEngine = new MappingEngine(configurationStore);
		}

		[Test]
		public void MapConfiguration_ForAllMappers_IsValid()
		{
			_mappingEngine.ConfigurationProvider.AssertConfigurationIsValid();
		}
	}
}