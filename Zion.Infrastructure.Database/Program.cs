using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using DbUp;
using DbUp.Engine;

namespace HrMaxx.Infrastructure.Database
{
	internal class Program
	{
		private static int Main(string[] args)
		{
			/*
			 * /Scripts/Maintenance would contain embeded scripts which would be run every time
			 * /Scripts/Initialize would contain scripts to create database, create schemas, create tables etc
			 * /Scripts/Data would contain scripts to populate data in the database for Testing.
			 * /Commands would contain powershell commands which could run Initialize and Data scripts based on the type of deployment
			 * connection strings should be in app.config and linked to the deployment profile
			 * put the non-embeded db and powershell scripts in the outputdirectory so they can be referenced from there rather than a physical location
			 * */

			string profile = null;
			if (args.Length == 0)
			{
				Console.WriteLine("Profiles available: DEV, INTEGRATION_TEST, SIT, UAT, PROD, FUNCSIT, FUNCSIT2");
				while (string.IsNullOrEmpty(profile))
				{
					Console.WriteLine();
					Console.Write("Please enter profile name: ");
					profile = Console.ReadLine();
				}
			}
			else
			{
				profile = args[0].ToUpper();
			}
			string commandFile = string.Empty;

			string connectionString = ConfigurationManager.ConnectionStrings[profile].ConnectionString;
			if (string.IsNullOrWhiteSpace(connectionString))
				throw new Exception("Connection string does not exist for the specified profile");
			string scriptPath = Directory.GetCurrentDirectory();
			try
			{
				switch (profile.ToUpper())
				{
					case "DEV":
						//commandFile = scriptPath + @"\Commands\Dev.cmd";
						//if (!RunCommands(connectionString, commandFile, scriptPath))
						//	throw new Exception("Failed to run Command. ");
						break;

					case "INTEGRATION_TEST":
						commandFile = scriptPath + @"\Commands\IntegrationTest.cmd";
						if (!RunCommands(connectionString, commandFile, scriptPath))
							throw new Exception("Failed to run Command. ");
						break;

					case "PROD":
						//commandFile = scriptPath + @"\Commands\Prod.cmd";
						//if (!RunCommands(connectionString, commandFile, scriptPath))
						//	throw new Exception("Failed to run Command. ");
						break;
					case "UAT":
						//commandFile = scriptPath + @"\Commands\UAT.cmd";
						//if (!RunCommands(connectionString, commandFile, scriptPath))
						//	throw new Exception("Failed to run Command. ");
						break;
					default:
						break;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
			}

			UpgradeEngine upgrader =
				DeployChanges.To
					.SqlDatabase(connectionString)
					.WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
					.LogToConsole()
					.Build();

			DatabaseUpgradeResult result = upgrader.PerformUpgrade();

			if (!result.Successful)
			{
				ShowConsoleError(result.Error.ToString());
				return -1;
			}

			ShowConsoleSuccess();
			return 0;
		}

		private static bool RunCommands(string connectionString, string commandFile, string scriptPath)
		{
			var builder = new SqlConnectionStringBuilder(connectionString);

			try
			{
				var scripts = new Process();
				scripts.StartInfo.FileName = commandFile;
				scripts.StartInfo.Arguments = builder["Data Source"] + " " + builder["Initial Catalog"] + " " + builder["User ID"] +
				                              " " + builder["Password"];
				scripts.StartInfo.WorkingDirectory = Directory.GetCurrentDirectory() + @"\Scripts\";

				scripts.OutputDataReceived += (sender, eventArgs) => Console.WriteLine(eventArgs.Data);

				scripts.StartInfo.RedirectStandardError = true;
				scripts.StartInfo.RedirectStandardOutput = true;
				scripts.StartInfo.UseShellExecute = false;
				scripts.Start();
				scripts.BeginOutputReadLine();
				string errorOutput = scripts.StandardError.ReadToEnd();

				scripts.WaitForExit();
				scripts.Close();
				scripts.Dispose();

				if (errorOutput.Length > 0)
				{
					ShowConsoleError("DB scripts failed: " + errorOutput);
					return false;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
				Console.WriteLine(ex.StackTrace);
				return false;
			}
			return true;
		}

		private static void ShowConsoleSuccess()
		{
			Console.ForegroundColor = ConsoleColor.Green;
			Console.WriteLine("Success!");
			Console.ResetColor();
		}

		private static void ShowConsoleError(string message)
		{
			Console.ForegroundColor = ConsoleColor.Red;
			Console.WriteLine(message);
			Console.ResetColor();
		}
	}
}