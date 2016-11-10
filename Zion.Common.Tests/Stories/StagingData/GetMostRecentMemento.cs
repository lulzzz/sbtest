using System;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Tests.Stories.StagingData.Helpers;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.StagingData
{
	public class GetMostRecentMemento : SpecsFor<StagingDataService>
	{
		private static readonly Guid MementoId = Guid.NewGuid();

		protected override void Given()
		{
			Given<MementosExistAndTheMostRecentVersionIsRequested>();
			base.Given();
		}

		protected override void When()
		{
			SUT.GetMostRecentStagingData<TestObject>(MementoId);
		}

		private class MementosExistAndTheMostRecentVersionIsRequested : IContext<StagingDataService>
		{
			public void Initialize(ISpecs<StagingDataService> state)
			{
				Memento<TestObject> memento = TestObjectMemento.Create(new TestObject
				{
					Name = "TestName",
					Description = "TestDescription",
					Id = 233
				}, EntityTypeEnum.General, string.Empty);

				state.GetMockFor<IStagingDataRepository>()
					.Setup(a => a.GetMostRecentMemento<TestObject>(It.IsAny<Guid>()))
					.Returns(new StagingDataDto
					{
						Memento = memento.State,
						OriginatorType = memento.OriginatorTypeName,
						MementoId = MementoId,
						DateCreated = DateTime.Now
					});
			}
		}

		[Test]
		public void then_a_call_should_be_made_to_the_repository_to_get_the_most_recent_memento_for_the_relevant_type()
		{
			GetMockFor<IStagingDataRepository>()
				.Verify(a => a.GetMostRecentMemento<TestObject>(MementoId), Times.Once());
		}
	}
}