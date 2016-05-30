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
	public class DeleteMementosRepositoryFails : SpecsFor<StagingDataService>
	{
		private Exception _exception;
		private readonly Guid _mementoId = Guid.NewGuid();

		protected override void Given()
		{
			Given<AMementoDeleteIsAttempted>();
			base.Given();
		}

		protected override void When()
		{
			try
			{
				SUT.DeleteStagingData<TestObject>(_mementoId);
			}
			catch (Exception e)
			{
				_exception = e;
			}
		}

		private class AMementoDeleteIsAttempted : IContext<StagingDataService>
		{
			public void Initialize(ISpecs<StagingDataService> state)
			{
				state.SUT.Log = state.GetMockFor<ILog>().Object;

				state.GetMockFor<IStagingDataRepository>()
					.Setup(a => a.DeleteStagingData<TestObject>(It.IsAny<Guid>()))
					.Throws(new Exception("Bad things happened"));
			}
		}

		[Test]
		public void then_a_call_to_delete_the_memento_is_made()
		{
			GetMockFor<IStagingDataRepository>()
				.Verify(a => a.DeleteStagingData<TestObject>(_mementoId));
		}

		[Test]
		public void then_a_friendly_lapps_exception_is_thrown()
		{
			Assert.That(_exception, Is.TypeOf<HrMaxxApplicationException>());
			Assert.That(_exception.Message, Is.EqualTo(CommonStringResources.ERROR_CouldNotDeleteMementos));
		}

		[Test]
		public void then_the_exception_is_logged()
		{
			GetMockFor<ILog>().LogsException();
		}
	}
}