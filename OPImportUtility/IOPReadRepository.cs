using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OPImportUtility
{
	public interface IOPReadRepository
	{
		List<T> GetQueryData<T>(string query);
	}
}
