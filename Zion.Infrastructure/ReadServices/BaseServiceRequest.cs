using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Validation;
using Newtonsoft.Json;

namespace HrMaxx.Infrastructure.ReadServices
{
	public abstract class BaseServiceRequest : IValidatable
	{
		private readonly MessageValidator _validator;

		protected BaseServiceRequest()
		{
			_validator = new MessageValidator(this);
			CachePriority = HrMaxxCacheItemPriority.None;
		}

		public virtual string CacheKey
		{
			get { return GetType().ToString(); }
		}

		public HrMaxxCacheItemPriority CachePriority { get; set; }

		public bool ForceACacheRefreshForRequest { get; set; }

		public virtual IEnumerable<string> GetValidationErrors()
		{
			return _validator.GetValidationErrors();
		}

		public virtual void Validate()
		{
			IEnumerable<string> validationErrors = GetValidationErrors();
			if (!validationErrors.Any()) return;

			throw new ValidationException {ValidationErrors = validationErrors};
		}

		public override string ToString()
		{
			var settings = new JsonSerializerSettings
			{
				ReferenceLoopHandling = ReferenceLoopHandling.Ignore
			};
			return JsonConvert.SerializeObject(this, settings);
		}
	}
}