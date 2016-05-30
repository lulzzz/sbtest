using System.Configuration;
using HrMaxx.Infrastructure.Tracing;

namespace HrMaxx.Infrastructure.Extensions
{
	public static class TestConnectionExtensions
	{
		private static bool? _isIntegrationTest;

		public static bool? IsIntegrationTest
		{
			get
			{
				return _isIntegrationTest ?? (_isIntegrationTest = ConfigurationManager.AppSettings["IsIntegrationTest"] != null &&
				                                                   bool.Parse(ConfigurationManager.AppSettings["IsIntegrationTest"]));
			}
		}

		public static string ConvertToTestConnectionStringAsRequired(this string connectionString)
		{
			string newConnectionString = connectionString;

			if (IsIntegrationTest.Value)
			{
				newConnectionString = newConnectionString.Replace("initial catalog=HrMaxx", "initial catalog=HrMaxxTest");
				HrMaxxTrace.TraceInformation("Switching connection:\r\n\t {0}\r\n to integration test connection:\r\n\t{1}\r\n",
					connectionString, newConnectionString);
			}

			return newConnectionString;
		}

		public static string ConvertToTestConnectionStringAsRequired(this ConnectionStringSettings connectionStringSettings)
		{
			HrMaxxTrace.TraceInformation("Reading connection string from config. Settings: {0}", connectionStringSettings);
			string newConnectionString = connectionStringSettings.ConnectionString;

			if (IsIntegrationTest.Value)
			{
				newConnectionString = newConnectionString.Replace("initial catalog=HrMaxx", "initial catalog=HrMaxxTest");
				HrMaxxTrace.TraceInformation("Switching connection:\r\n\t {0}\r\n to integration test connection:\r\n\t{1}\r\n",
					connectionStringSettings.ConnectionString, newConnectionString);
			}

			return newConnectionString;
		}
	}
}