using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Web;
using Newtonsoft.Json;

namespace HrMaxxAPI.Code.Helpers
{
	public static class FileUploadHelpers
	{
		public static MultipartFormDataStreamProvider GetMultipartProvider()
		{
			string uploadFolder = ConfigurationManager.AppSettings["SHEQTmpUploadPath"];
			string root = HttpContext.Current.Server.MapPath(uploadFolder);
			Directory.CreateDirectory(root);
			return new MultipartFormDataStreamProvider(root);
		}

		public static T GetFormData<T>(MultipartFormDataStreamProvider result)
		{
			if (result.FormData.HasKeys())
			{
				string unescapedFormData = result.FormData.GetValues(0).FirstOrDefault() ?? String.Empty;
				if (!String.IsNullOrEmpty(unescapedFormData))
					return JsonConvert.DeserializeObject<T>(unescapedFormData);
			}
			return default(T);
		}

		public static string GetDeserializedFileName(MultipartFileData fileData)
		{
			string fileName = GetFileName(fileData);

			return JsonConvert.DeserializeObject(fileName).ToString();
		}

		public static string GetFileName(MultipartFileData fileData)
		{
			return fileData.Headers.ContentDisposition.FileName;
		}
	}
}