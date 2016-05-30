using System;
using System.Collections.Generic;

namespace HrMaxx.Infrastructure.Exceptions
{
	public class HrMaxxApplicationException : ApplicationException
	{
		private readonly List<string> _errors;

		public HrMaxxApplicationException(string message) : base(message)
		{
		}

		public HrMaxxApplicationException(string message, List<string> errors)
			: base(message)
		{
			_errors = errors;
		}

		public HrMaxxApplicationException(string message, Exception innerException) : base(message, innerException)
		{
		}

		public HrMaxxApplicationException()
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