using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Zion.Common.Contracts.Momentos;
using Zion.Common.Repository.Mementos;
using Zion.Infrastructure.Transactions;
using Zion.TestSupport;
using Autofac;

namespace Zion.Common.IntegrationTests.Stories.StagingData
{
	public class SavingStagingData : BaseIntegrationTestFixture
	{
		[Test]
		public void AddMemento_ForANewValidMemento_AddsTheMementoSuccessfully()
		{
			var testObject = new SomeTestObjectForSavingValidMemento { Id = Guid.NewGuid(), Name = "Test Name" };
			Memento<SomeTestObjectForSavingValidMemento> memento = Memento<SomeTestObjectForSavingValidMemento>.Create(testObject);

			using (TransactionScopeHelper.Transaction())
			{
				var repository = TestLifetimeScope.Resolve<IStagingDataRepository>();

				repository.SaveMemento(new StagingDataDto
				{
					Memento = memento.State,
					OriginatorType = memento.OriginatorTypeName,
					MementoId = memento.Id
				});

				var mementoFromDb = repository.GetStagingData<SomeTestObjectForSavingValidMemento>(memento.Id);

				Assert.That(mementoFromDb.MementoId, Is.EqualTo(memento.Id));
				Assert.That(mementoFromDb.OriginatorType, Is.EqualTo(memento.OriginatorTypeName));
				Assert.That(mementoFromDb.Memento, Is.EqualTo(memento.State));
			}
		}

		//[Test]
		//public void AddMemento_WhenExecutedANumberOfTimesForAType_VersionsTheMementosCorrectly()
		//{
		//	using (TransactionScopeHelper.Transaction())
		//	{
		//		var repository = TestLifetimeScope.Resolve<IVersioningRepository>();

		//		string originatorTypeName = null;

		//		var testObject = new SomeTestObjectForSavingValidMemento { Id = Guid.NewGuid(), Name = "Test Name" };

		//		for (int i = 0; i < 3; i++)
		//		{
		//			testObject.Name += i;
		//			Memento<SomeTestObjectForSavingValidMemento> memento =
		//				Memento<SomeTestObjectForSavingValidMemento>.Create(testObject);

		//			repository.SaveMemento(new MementoPersistenceDto
		//			{
		//				Memento = memento.State,
		//				OriginatorType = memento.OriginatorTypeName,
		//				MementoId = memento.Id
		//			});

		//			originatorTypeName = memento.OriginatorTypeName;
		//		}

		//		var savedMementos = ADOWrapper.Query(base.LappsCoreSchemaDbConnection,
		//																				 String.Format("select * from core.Mementos where OriginatorType = '{0}' and MementoId = '{1}'",
		//																											 originatorTypeName, testObject.MementoId));

		//		Assert.That(savedMementos.Max(a => a.version), Is.EqualTo(3));
		//	}
		//}

		//[Test]
		//public void AddMemento_WhenExecutedANumberOfTimesForATypeWithMultipleIds_VersionsTheMementosCorrectly()
		//{
		//	using (TransactionScopeHelper.Transaction())
		//	{
		//		var repository = TestLifetimeScope.Resolve<IVersioningRepository>();

		//		string originatorTypeName = null;

		//		var testObject = new SomeTestObjectForSavingValidMemento { Id = Guid.NewGuid(), Name = "Test Name" };
		//		var testObject2 = new SomeTestObjectForSavingValidMemento { Id = Guid.NewGuid(), Name = "Test Name" };

		//		for (int i = 0; i < 3; i++)
		//		{
		//			testObject.Name += i;
		//			testObject2.Name += i;

		//			var memento = Memento<SomeTestObjectForSavingValidMemento>.Create(testObject);

		//			repository.SaveMemento(new MementoPersistenceDto
		//			{
		//				Memento = memento.State,
		//				OriginatorType = memento.OriginatorTypeName,
		//				MementoId = memento.Id
		//			});

		//			var memento2 = Memento<SomeTestObjectForSavingValidMemento>.Create(testObject2);

		//			repository.SaveMemento(new MementoPersistenceDto
		//			{
		//				Memento = memento2.State,
		//				OriginatorType = memento2.OriginatorTypeName,
		//				MementoId = memento2.Id
		//			});

		//			originatorTypeName = memento.OriginatorTypeName;
		//		}

		//		var savedMementos = ADOWrapper.Query(base.LappsCoreSchemaDbConnection,
		//																				 String.Format("select * from core.Mementos where OriginatorType = '{0}' and MementoId = '{1}'",
		//																											 originatorTypeName, testObject.MementoId));

		//		Assert.That(savedMementos.Max(a => a.version), Is.EqualTo(3));

		//		var savedMementosWithDifferringIds = ADOWrapper.Query(base.LappsCoreSchemaDbConnection,
		//																				 String.Format("select * from core.Mementos where OriginatorType = '{0}' and MementoId = '{1}'",
		//																											 originatorTypeName, testObject2.MementoId));

		//		Assert.That(savedMementosWithDifferringIds.Max(a => a.version), Is.EqualTo(3));
		//	}
		//}

		internal class SomeTestObjectForSavingValidMemento : IOriginator<SomeTestObjectForSavingValidMemento>
		{
			public Guid Id { get; set; }
			public string Name { get; set; }

			public void ApplyMemento(Memento<SomeTestObjectForSavingValidMemento> memento)
			{
				var mementoObject = memento.Deserialize();
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
