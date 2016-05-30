using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Attributes;
using Newtonsoft.Json;

namespace HrMaxx.Bus.Contracts
{
	[ServiceBusMessage]
	public abstract class Event : IMessage
	{
		protected Event(Command command)
		{
			CorrespondingCommandCacheInvalidationKeys = command == null
				? new List<string>()
				: command.CacheInvalidationKeys;
		}

		protected Event()
		{
			CorrespondingCommandCacheInvalidationKeys = new List<string>();
		}

		/// <summary>
		///   These are recorded here so that we can use them for cache invalidation.
		/// </summary>
		public List<string> CorrespondingCommandCacheInvalidationKeys { get; set; }

		public IEnumerable<string> GetValidationErrors()
		{
			/*
			 Events don't validate, they are a past occurrence so there is no way that they can be invalid.
			 What's done is done.
			*/
			return Enumerable.Empty<string>();
		}

		public override string ToString()
		{
			return JsonConvert.SerializeObject(this);
		}
	}
}