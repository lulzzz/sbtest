using Newtonsoft.Json;

namespace HrMaxx.Infrastructure.ReadServices
{
	public class BaseServiceResponse
	{
		public override string ToString()
		{
			return JsonConvert.SerializeObject(this);
		}
	}
}