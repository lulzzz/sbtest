using System.IO;
using Newtonsoft.Json;

namespace HrMaxx.Infrastructure.Extensions
{
	public static class ObjectExtensions
	{
		public static string ToJson(this object obj)
		{
			JsonSerializer serialiser = JsonSerializer.Create(new JsonSerializerSettings());
			var writer = new StringWriter();
			serialiser.Serialize(writer, obj);
			return writer.ToString();
		}
	}
}