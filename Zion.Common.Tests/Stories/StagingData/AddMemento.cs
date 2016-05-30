using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Tests.Stories.StagingData.Helpers;
using Moq;
using NUnit.Framework;
using SpecsFor;
using SpecsFor.ShouldExtensions;

namespace HrMaxx.Common.Tests.Stories.StagingData
{
	public class AddMemento : SpecsFor<StagingDataService>
	{
		private static TestObject _originator;
		private static Memento<TestObject> _memento;
		private static StagingDataDto _persistedMemento;

		protected override void Given()
		{
			Given<ANewMementoToSave>();
			base.Given();
		}

		protected override void When()
		{
			SUT.AddStagingData(_memento);
		}

		private class ANewMementoToSave : IContext<StagingDataService>
		{
			public void Initialize(ISpecs<StagingDataService> state)
			{
				_originator = new TestObject();
				_memento = Memento<TestObject>.Create(_originator);

				state.GetMockFor<IStagingDataRepository>()
					.Setup(a => a.SaveMemento(It.IsAny<StagingDataDto>()))
					.Callback<StagingDataDto>(dto => _persistedMemento = dto);
			}
		}

		[Test]
		public void then_a_call_to_save_the_memento_is_made()
		{
			GetMockFor<IStagingDataRepository>()
				.Verify(a => a.SaveMemento(It.IsAny<StagingDataDto>()));
		}

		[Test]
		public void then_the_dto_which_is_persisted_should_contain_be_hydrated_correctly()
		{
			var expectedDto = new StagingDataDto
			{
				OriginatorType = _memento.OriginatorTypeName,
				Memento = _memento.State,
				MementoId = _memento.Id
			};

			_persistedMemento.ShouldLookLike(expectedDto);
		}
	}
}