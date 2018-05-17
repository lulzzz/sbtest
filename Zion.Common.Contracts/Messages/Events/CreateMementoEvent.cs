using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Contracts.Messages.Events
{
	public class CreateMementoEvent<T> : Event
	{
		public List<T> List;
		public EntityTypeEnum EntityType;
		public string UserName;
		public Guid UserId;
		public string Notes;
		public string LogNotes;
	}
}
