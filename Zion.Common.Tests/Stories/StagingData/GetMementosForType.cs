using System;
using System.Collections.Generic;
using System.Linq;
using FizzWare.NBuilder;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Tests.Stories.StagingData.Helpers;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.StagingData
{
	public class GetMementosForType : SpecsFor<StagingDataService>
	{
		private List<Memento<TestObject>> _mementos;
		private static readonly Guid MementoId = Guid.NewGuid();
		private static List<StagingDataDto> _mementoPersistanceDtos;

		protected override void Given()
		{
			Given<MementosExistAndAllOfTheVersionsAreRequested>();
			base.Given();
		}

		protected override void When()
		{
			_mementos = SUT.GetStagingData<TestObject>(MementoId);
		}

		private class MementosExistAndAllOfTheVersionsAreRequested : IContext<StagingDataService>
		{
			public void Initialize(ISpecs<StagingDataService> state)
			{
				_mementoPersistanceDtos = Builder<StagingDataDto>.CreateListOfSize(3)
					.Build().ToList();

				state.GetMockFor<IStagingDataRepository>()
					.Setup(a => a.GetStagingData<TestObject>(MementoId))
					.Returns(_mementoPersistanceDtos);
			}
		}

		[Test]
		public void then_a_call_should_be_made_to_the_repository_to_get_the_mementos_for_the_relevant_type()
		{
			GetMockFor<IStagingDataRepository>()
				.Verify(a => a.GetStagingData<TestObject>(MementoId), Times.Once());
		}

		[Test]
		public void then_the_mementos_returned_have_the_correct_state()
		{
			for (int i = 0; i < _mementos.Count; i++)
			{
				Assert.That(_mementos[i].State, Is.EqualTo(_mementoPersistanceDtos[i].Memento));
			}
		}
	}
}