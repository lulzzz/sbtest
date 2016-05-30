using System;
using System.Collections.Generic;

namespace HrMaxx.Infrastructure.Exceptions
{
	public class HrMaxxConcurrencyException : ApplicationException
	{
		private readonly List<string> _errors;

		public HrMaxxConcurrencyException(string message) : base(message)
		{
		}

		public HrMaxxConcurrencyException(string message, List<string> errors)
			: base(message)
		{
			_errors = errors;
		}

		public HrMaxxConcurrencyException(string message, Exception innerException) : base(message, innerException)
		{
		}

		public HrMaxxConcurrencyException()
		{
		}

		public List<string> Errors
		{
			get
			{
				if (_errors != null && _errors.Count > 0)
					return _errors;

				return new List<string> {Message};
			}
		}
	}
}