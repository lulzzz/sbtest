using System;
using System.Diagnostics;
using System.IO;

namespace HrMaxx.Infrastructure.Helpers
{
	public static class TestInfrastructure
	{
		public static void StopIIS()
		{
			var startInfo = new ProcessStartInfo("iisreset.exe", " /stop");
			Process process = Process.Start(startInfo);
			process.WaitForExit();
			process.Close();
			process.Dispose();
		}

		public static void StartIIS()
		{
			var startInfo = new ProcessStartInfo("iisreset.exe", " /start");
			Process process = Process.Start(startInfo);
			process.WaitForExit();
			process.Close();
			process.Dispose();
		}

		public static DirectoryInfo GetSolutionRoot()
		{
			return new DirectoryInfo(Environment.CurrentDirectory).Parent.Parent.Parent;
		}

		public static void RunDatabaseScript(string arguments, string mode = "Debug")
		{
			DirectoryInfo info = GetSolutionRoot();
			string path = Path.Combine(info.FullName, string.Format(@"Zion.Infrastructure.Database\bin\{0}\", mode));

			var dbCreateProcess = new Process
			{
				StartInfo =
				{
					FileName = path + "HrMaxx.Infrastructure.Database.exe",
					CreateNoWindow = true,
					WorkingDirectory = path,
					Arguments = arguments,
					RedirectStandardError = true,
					RedirectStandardOutput = true,
					UseShellExecute = false
				}
			};

			dbCreateProcess.OutputDataReceived += (sender, eventArgs) => Console.WriteLine(eventArgs.Data);

			dbCreateProcess.Start();
			dbCreateProcess.BeginOutputReadLine();
			string errorOutput = dbCreateProcess.StandardError.ReadToEnd();

			dbCreateProcess.WaitForExit();
			dbCreateProcess.Close();
			dbCreateProcess.Dispose();

			if (errorOutput.Length > 0)
				throw new ApplicationException("Could not create database! " + errorOutput);
		}
	}
}