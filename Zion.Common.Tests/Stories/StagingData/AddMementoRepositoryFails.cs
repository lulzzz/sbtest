using System;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
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
	public class AddMementoRepositoryFails : SpecsFor<StagingDataService>
	{
		private static TestObject _originator;
		private static Memento<TestObject> _memento;
		private Exception _exception;

		protected override void Given()
		{
			Given<ANewMementoToSave>();
			base.Given();
		}

		protected override void When()
		{
			try
			{
				SUT.AddStagingData(_memento);
			}
			catch (Exception e)
			{
				_exception = e;
			}
		}

		private class ANewMementoToSave : IContext<StagingDataService>
		{
			public void Initialize(ISpecs<StagingDataService> state)
			{
				_originator = new TestObject();
				_memento = Memento<TestObject>.Create(_originator, EntityTypeEnum.General, string.Empty);

				state.SUT.Log = state.GetMockFor<ILog>().Object;

				state.GetMockFor<IStagingDataRepository>()
					.Setup(a => a.SaveMemento(It.IsAny<StagingDataDto>()))
					.Throws(new Exception("Bad things happened"));
			}
		}

		[Test]
		public void then_a_call_to_save_the_memento_is_made()
		{
			GetMockFor<IStagingDataRepository>()
				.Verify(a => a.SaveMemento(It.IsAny<StagingDataDto>()));
		}

		[Test]
		public void then_a_friendly_lapps_exception_is_thrown()
		{
			Assert.That(_exception, Is.TypeOf<HrMaxxApplicationException>());
			Assert.That(_exception.Message, Is.EqualTo(CommonStringResources.ERROR_CouldNotSaveMemento));
		}

		[Test]
		public void then_the_exception_is_logged()
		{
			GetMockFor<ILog>().LogsException();
		}
	}
}