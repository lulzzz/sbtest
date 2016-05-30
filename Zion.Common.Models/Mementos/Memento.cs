using System;
using Newtonsoft.Json;

namespace HrMaxx.Common.Models.Mementos
{
	public class Memento<T>
	{
		protected Memento()
		{
		}

		public string State { get; private set; }
		public string OriginatorTypeName { get; private set; }
		public Guid Id { get; private set; }
		public int Version { get; set; }
		public DateTime DateCreated { get; set; }

		public static Memento<T> Create(IOriginator<T> originator)
		{
			if (originator == null)
				return null;

			var memento = new Memento<T>();
			memento.Serialize(originator);
			memento.OriginatorTypeName = typeof (T).FullName;
			memento.Id = originator.MementoId;
			return memento;
		}

		public static Memento<T> Create(Guid mementoId, string mementoState)
		{
			var memento = new Memento<T> {Id = mementoId, State = mementoState, OriginatorTypeName = typeof (T).FullName};
			return memento;
		}

		public static Memento<T> Create(Guid mementoId, int version, DateTime dateCreated, string mementoState)
		{
			var memento = new Memento<T>
			{
				Id = mementoId,
				Version = version,
				DateCreated = dateCreated,
				State = mementoState,
				OriginatorTypeName = typeof (T).FullName
			};
			return memento;
		}

		private void Serialize(IOriginator<T> originator)
		{
			State = JsonConvert.SerializeObject(originator,
				new JsonSerializerSettings {ReferenceLoopHandling = ReferenceLoopHandling.Ignore});
		}

		public T Deserialize()
		{
			return JsonConvert.DeserializeObject<T>(State,
				new JsonSerializerSettings {ReferenceLoopHandling = ReferenceLoopHandling.Ignore});
		}
	}
}