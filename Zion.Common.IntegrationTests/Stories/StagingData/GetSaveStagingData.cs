using System;
using System.Reflection;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.TestSupport;
using NUnit.Framework;
using StoryQ;

namespace HrMaxx.Common.IntegrationTests.Stories.StagingData
{
	public class GetSaveStagingData : BaseIntegrationTestFixture
	{
		private Memento<SomeTestObjectForSavingValidMemento> _memento;
		private IStagingDataService _service;
		private SomeTestObjectForSavingValidMemento _testObject;

		[Test]
		public void SavingStagingData_SavesAndGetsTheStagingDataSuccessfully()
		{
			using (TransactionScopeHelper.Transaction())
			{
				using (ILifetimeScope scope = TestLifetimeScope.BeginLifetimeScope())
				{
					_service = scope.Resolve<IStagingDataService>();

					new Story("Save Staging Data until Commit message is received")
						.InOrderTo("Protect the system from connection failures")
						.AsA("User")
						.IWant("to hold data in a staging area until commit message is received")
						.WithScenario("PCL Instance Photo Deleted")
						.Given(ATestObject)
						.When(SaveInStagingData)
						.Then(ObjectIsSavedCorrectly)
						.ExecuteWithReport(MethodBase.GetCurrentMethod());
				}
			}
		}

		private void ATestObject()
		{
			_testObject = new SomeTestObjectForSavingValidMemento {Id = Guid.NewGuid(), Name = "Test Name"};
		}

		private void SaveInStagingData()
		{
			_memento = Memento<SomeTestObjectForSavingValidMemento>.Create(_testObject, EntityTypeEnum.General, string.Empty);
			_service.AddStagingData(_memento);
		}

		private void ObjectIsSavedCorrectly()
		{
			Memento<SomeTestObjectForSavingValidMemento> mementoFromDb =
				_service.GetMostRecentStagingData<SomeTestObjectForSavingValidMemento>(_testObject.MementoId);

			Assert.That(mementoFromDb.Id, Is.EqualTo(_memento.Id));
			Assert.That(mementoFromDb.OriginatorTypeName, Is.EqualTo(_memento.OriginatorTypeName));
			Assert.That(mementoFromDb.State, Is.EqualTo(_memento.State));
		}


		internal class SomeTestObjectForSavingValidMemento : IOriginator<SomeTestObjectForSavingValidMemento>
		{
			public Guid Id { get; set; }
			public string Name { get; set; }

			public void ApplyMemento(Memento<SomeTestObjectForSavingValidMemento> memento)
			{
				SomeTestObjectForSavingValidMemento mementoObject = memento.Deserialize();
				Id = mementoObject.Id;
				Name = mementoObject.Name;
			}

			public Guid MementoId
			{
				get { return Id; }
			}
		}
	}
}