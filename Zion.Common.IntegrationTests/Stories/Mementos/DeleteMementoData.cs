﻿using System;
using System.Collections.Generic;
using System.IO;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.TestSupport;
using NUnit.Framework;

namespace HrMaxx.Common.IntegrationTests.Stories.Mementos
{
	public class DeleteMementoData : BaseIntegrationTestFixture
	{
		[Test]
		public void DeleteMementoData_ForAExistingMementos_DeletesTheMementosSuccessfully()
		{
			var testObject = new SomeTestObjectForSavingValidMemento { Id = 0, ObjectId = Guid.NewGuid(), Name = "Test Name", SourceTypeId = EntityTypeEnum.General, CreatedBy = "Some User" };
			Memento<SomeTestObjectForSavingValidMemento> memento = Memento<SomeTestObjectForSavingValidMemento>.Create(testObject, testObject.SourceTypeId, testObject.CreatedBy);

			using (TransactionScopeHelper.Transaction())
			{
				var stagingDataSvc = TestLifetimeScope.Resolve<IMementoDataService>();
				var _fileRepository = TestLifetimeScope.Resolve<IFileRepository>();

				stagingDataSvc.AddMementoData(memento);

				Memento<SomeTestObjectForSavingValidMemento> savedMemento =
					stagingDataSvc.GetMostRecentMementoData<SomeTestObjectForSavingValidMemento>(memento.MementoId);
				Assert.That(savedMemento.Id, Is.EqualTo(testObject.Id));
				Assert.That(savedMemento.OriginatorTypeName, Is.EqualTo(typeof (SomeTestObjectForSavingValidMemento).FullName));
				Assert.That(savedMemento.State, Is.EqualTo(memento.State));

				stagingDataSvc.DeleteMementoData<SomeTestObjectForSavingValidMemento>(memento.MementoId);

				List<Memento<SomeTestObjectForSavingValidMemento>> mementoAfterDelete =
					stagingDataSvc.GetMementoData<SomeTestObjectForSavingValidMemento>(memento.MementoId);

				Assert.IsNull(mementoAfterDelete);
				
				Assert.Throws<DirectoryNotFoundException>(() => _fileRepository.GetArchiveJson(ArchiveTypes.Mementos.GetDbName(),
						memento.SourceTypeId.GetDbName() + "\\" + memento.Id.ToString(), savedMemento.Id.ToString()));
			}
		}

		internal class SomeTestObjectForSavingValidMemento : IOriginator<SomeTestObjectForSavingValidMemento>
		{
			public int Id { get; set; }
			public Guid ObjectId { get; set; }
			public string Name { get; set; }
			public EntityTypeEnum SourceTypeId { get; set; }
			public string CreatedBy { get; set; }

			public void ApplyMemento(Memento<SomeTestObjectForSavingValidMemento> memento)
			{
				SomeTestObjectForSavingValidMemento mementoObject = memento.Deserialize();
				Id = mementoObject.Id;
				Name = mementoObject.Name;
			}

			public Guid MementoId
			{
				get { return ObjectId; }
			}
		}
	}
}