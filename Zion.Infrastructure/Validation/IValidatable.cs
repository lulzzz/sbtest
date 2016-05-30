using System.Collections.Generic;

namespace HrMaxx.Infrastructure.Validation
{
	public interface IValidatable
	{
		IEnumerable<string> GetValidationErrors();
	}
}