using System;
using System.Collections.Generic;

namespace HrMaxx.Infrastructure.Validation
{
	public class ValidationException : Exception
	{
		public IEnumerable<string> ValidationErrors { get; set; }

		public string FlatErrorValidationMessage
		{
			get
			{
				var errorList = new List<string>(ValidationErrors);
				return String.Join(", ", errorList);
			}
		}
	}
}