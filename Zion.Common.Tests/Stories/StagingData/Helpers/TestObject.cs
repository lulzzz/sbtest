using System;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Tests.Stories.StagingData.Helpers
{
	internal class TestObject : IOriginator<TestObject>
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }

		public void ApplyMemento(Memento<TestObject> memento)
		{
			TestObject theMemento = memento.Deserialize();
			Id = theMemento.Id;
			Name = theMemento.Name;
			Description = theMemento.Description;
		}

		public Guid MementoId
		{
			get { return Guid.NewGuid(); }
		}
	}
}