using System;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Tests.Stories.StagingData.Helpers;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.TestSupport.Extensions;
using log4net;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.StagingData
{
	public class GetMostMementosForTypeFails : SpecsFor<StagingDataService>
	{
		private Exception _exception;
		private static readonly Guid MementoId = Guid.NewGuid();

		protected override void Given()
		{
			Given<TheRepositoryLookupFails>();
			base.Given();
		}

		protected override void When()
		{
			try
			{
				SUT.GetStagingData<TestObject>(MementoId);
			}
			catch (Exception e)
			{
				_exception = e;
			}
		}

		private class TheRepositoryLookupFails : IContext<StagingDataService>
		{
			public void Initialize(ISpecs<StagingDataService> state)
			{
				state.SUT.Log = state.GetMockFor<ILog>().Object;

				state.GetMockFor<IStagingDataRepository>()
					.Setup(a => a.GetStagingData<TestObject>(MementoId))
					.Throws(new Exception("Bad thinga happened"));
			}
		}

		[Test]
		public void then_a_call_should_be_made_to_the_repository_to_get_the_mementos_for_the_relevant_type()
		{
			GetMockFor<IStagingDataRepository>()
				.Verify(a => a.GetStagingData<TestObject>(MementoId), Times.Once());
		}

		[Test]
		public void then_a_friendly_lapps_exception_is_thrown()
		{
			Assert.That(_exception, Is.TypeOf<HrMaxxApplicationException>());
			Assert.That(_exception.Message, Is.EqualTo(CommonStringResources.ERROR_CouldNotRetrieveStagingData));
		}

		[Test]
		public void then_the_exception_is_logged()
		{
			GetMockFor<ILog>().LogsException();
		}
	}
}