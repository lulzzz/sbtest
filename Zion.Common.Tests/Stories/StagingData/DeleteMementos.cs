using System;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Tests.Stories.StagingData.Helpers;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.StagingData
{
	public class DeleteMementos : SpecsFor<StagingDataService>
	{
		private Guid _mementoId;

		protected override void Given()
		{
			Given<NormalBehaviour>();
			base.Given();
		}

		protected override void When()
		{
			_mementoId = Guid.NewGuid();
			SUT.DeleteStagingData<TestObject>(_mementoId);
		}

		private class NormalBehaviour : IContext<StagingDataService>
		{
			public void Initialize(ISpecs<StagingDataService> state)
			{
			}
		}

		[Test]
		public void then_a_call_to_delete_the_mementos_is_made()
		{
			GetMockFor<IStagingDataRepository>()
				.Verify(a => a.DeleteStagingData<TestObject>(_mementoId));
		}
	}
}