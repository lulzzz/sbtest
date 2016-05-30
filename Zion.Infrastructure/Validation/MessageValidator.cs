using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection;

namespace HrMaxx.Infrastructure.Validation
{
	public class MessageValidator
	{
		private readonly object _objectToValidate;

		public MessageValidator(object objectToValidate)
		{
			_objectToValidate = objectToValidate;
		}

		public IEnumerable<string> GetValidationErrors()
		{
			var context = new ValidationContext(_objectToValidate, null, null);

			IList<ValidationResult> results = new List<ValidationResult>();
			Validator.TryValidateObject(_objectToValidate, context, results, true);

			IEnumerable<string> subObjectErrors = GetSubObjectErrors(v => v.GetValidationErrors());

			return results.Select(v => v.ErrorMessage).Concat(subObjectErrors);
		}

		private IEnumerable<string> GetSubObjectErrors(Func<IValidatable, IEnumerable<string>> getErrors)
		{
			return from prop in _objectToValidate.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance)
				where typeof (IValidatable).IsAssignableFrom(prop.PropertyType)
				let propertyValue = (IValidatable) prop.GetValue(_objectToValidate, null)
				select propertyValue != null ? getErrors(propertyValue) : Enumerable.Empty<string>()
				into errorsFromProp
				from error in errorsFromProp
				select error;
		}
	}
}