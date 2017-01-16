using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.ReadRepository;

namespace HrMaxx.OnlinePayroll.ReadServices
{
  public class ReaderService: BaseService, IReaderService
  {
	  private readonly IReadRepository _reader;

	  public ReaderService(IReadRepository reader)
	  {
		  _reader = reader;
	  }

	  public T GetDataFromStoreProc<T>(string proc, List<FilterParam> paramList)
	  {
		  try
		  {
			  return _reader.GetDataFromStoredProc<T>(proc, paramList);
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("Proc:{0} Params:{1}", proc, paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }
  }
}
