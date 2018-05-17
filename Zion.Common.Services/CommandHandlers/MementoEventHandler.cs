using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Models;
using MassTransit;

namespace HrMaxx.Common.Services.CommandHandlers
{
	public class MementoEventHandler : BaseService, Consumes<CreateMementoEvent<PayCheck>>.All, Consumes<CreateMementoEvent<PayrollInvoice>>.All
	{
		public readonly IMementoDataService _mementoDataService;
		public MementoEventHandler(IMementoDataService mementoDataService)
		{
			_mementoDataService = mementoDataService;
		}

		public void Consume(CreateMementoEvent<PayCheck> event1)
		{
			try
			{
				event1.List.ForEach(t =>
				{
					var memento = Memento<PayCheck>.Create(t, event1.EntityType, event1.UserName, event1.Notes, event1.UserId);
					_mementoDataService.AddMementoData(memento);
				});
				Log.Info(event1.LogNotes);
			}
			catch (Exception e)
			{
				Log.Error(string.Format("Erorr in Creating Mementos for PayChecks {0}", event1.LogNotes));
			}

		}
		public void Consume(CreateMementoEvent<PayrollInvoice> event1)
		{
			try
			{
				event1.List.ForEach(t =>
				{
					var memento = Memento<PayrollInvoice>.Create(t, event1.EntityType, event1.UserName, event1.Notes, event1.UserId);
					_mementoDataService.AddMementoData(memento);
				});
				Log.Info(event1.LogNotes);
			}
			catch (Exception e)
			{
				Log.Error(string.Format("Erorr in Creating Mementos for Invoice {0}", event1.LogNotes));
			}

		}
		
	}
}
