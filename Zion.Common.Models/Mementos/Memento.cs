using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Enum;
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
		public int Id { get; private set; }
		public Guid MementoId { get; private set; }
		public decimal Version { get; set; }
		public DateTime DateCreated { get; set; }
		public string CreatedBy { get; set; }
		public EntityTypeEnum SourceTypeId { get; set; }
		public T Object { get; set; }

		public static Memento<T> Create(IOriginator<T> originator, EntityTypeEnum sourceType, string createdBy)
		{
			if (originator == null)
				return null;

			var memento = new Memento<T>();
			memento.Serialize(originator);
			memento.OriginatorTypeName = typeof (T).FullName;
			memento.MementoId = originator.MementoId;
			memento.CreatedBy = createdBy;
			memento.SourceTypeId = sourceType;
			return memento;
		}
		
		public static Memento<T> Create(Guid mementoId, string mementoState)
		{
			var memento = new Memento<T> {MementoId = mementoId, State = mementoState, OriginatorTypeName = typeof (T).FullName};
			return memento;
		}

		public static Memento<T> Create(Guid mementoId, decimal version, DateTime dateCreated, string mementoState, string createdBy, EntityTypeEnum sourceType)
		{
			var memento = new Memento<T>
			{
				MementoId = mementoId,
				Version = version,
				DateCreated = dateCreated,
				State = mementoState,
				OriginatorTypeName = typeof (T).FullName,
				CreatedBy = createdBy,
				SourceTypeId = sourceType
				
			};
			memento.Object = memento.Deserialize();
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