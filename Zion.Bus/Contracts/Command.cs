using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Validation;
using Magnum;
using Newtonsoft.Json;

namespace HrMaxx.Bus.Contracts
{
	public abstract class Command : IMessage
	{
		private readonly MessageValidator _validator;

		protected Command()
		{
			CacheInvalidationKeys = new List<string>();
			_validator = new MessageValidator(this);

			Id = CombGuid.Generate();
		}

		public Guid Id { get; private set; }
		public List<string> CacheInvalidationKeys { get; set; }

		public virtual IEnumerable<string> GetValidationErrors()
		{
			return _validator.GetValidationErrors();
		}

		public virtual void Validate()
		{
			IEnumerable<string> validationErrors = GetValidationErrors();
			if (validationErrors == null || !validationErrors.Any()) return;

			throw new ValidationException {ValidationErrors = validationErrors};
		}

		public override string ToString()
		{
			return JsonConvert.SerializeObject(this);
		}
	}
}