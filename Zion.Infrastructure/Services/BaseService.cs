using HrMaxx.Infrastructure.Mapping;
using log4net;

namespace HrMaxx.Infrastructure.Services
{
	public abstract class BaseService
	{
		public ILog Log { get; set; }
		public IMapper Mapper { get; set; }
	}
}