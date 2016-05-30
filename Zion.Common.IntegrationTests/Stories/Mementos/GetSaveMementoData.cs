using System;
using System.Reflection;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.TestSupport;
using NUnit.Framework;
using StoryQ;

namespace HrMaxx.Common.IntegrationTests.Stories.Mementos
{
	public class GetSaveMementoData : BaseIntegrationTestFixture
	{
		private Memento<SomeTestObjectForSavingValidMemento> _memento;
		private IMementoDataService _service;
		private SomeTestObjectForSavingValidMemento _testObject;

		[Test]
		public void SavingMementoData_SavesAndGetsTheMementoDataSuccessfully()
		{
			using (TransactionScopeHelper.Transaction())
			{
				using (ILifetimeScope scope = TestLifetimeScope.BeginLifetimeScope())
				{
					_service = scope.Resolve<IMementoDataService>();

					new Story("Save Memento Data until Commit message is received")
						.InOrderTo("Protect the system from connection failures")
						.AsA("User")
						.IWant("to hold data in a memento area as history")
						.WithScenario("PCL")
						.Given(ATestObject)
						.When(SaveInMementoData)
						.Then(ObjectIsSavedCorrectly)
						.ExecuteWithReport(MethodBase.GetCurrentMethod());
				}
			}
		}

		private void ATestObject()
		{
			_testObject = new SomeTestObjectForSavingValidMemento {Id = Guid.NewGuid(), Name = "Test Name"};
		}

		private void SaveInMementoData()
		{
			_memento = Memento<SomeTestObjectForSavingValidMemento>.Create(_testObject);
			_service.AddMementoData(_memento);
		}

		private void ObjectIsSavedCorrectly()
		{
			Memento<SomeTestObjectForSavingValidMemento> mementoFromDb =
				_service.GetMostRecentMementoData<SomeTestObjectForSavingValidMemento>(_testObject.MementoId);

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