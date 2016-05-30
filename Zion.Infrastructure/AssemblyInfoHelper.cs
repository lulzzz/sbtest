using System;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.InteropServices;

namespace HrMaxx.Infrastructure
{
	public class AssemblyInfoHelper
	{
		private static Assembly _assembly;

		public AssemblyInfoHelper(Assembly assembly)
		{
			_assembly = assembly;
		}

		public AssemblyInfoHelper(Type type)
		{
			_assembly = Assembly.GetAssembly(type);
		}

		public string Title
		{
			get { return CustomAttributes<AssemblyTitleAttribute>().Title; }
		}

		public string Description
		{
			get { return CustomAttributes<AssemblyDescriptionAttribute>().Description; }
		}

		public string Company
		{
			get { return CustomAttributes<AssemblyCompanyAttribute>().Company; }
		}

		public string Product
		{
			get { return CustomAttributes<AssemblyProductAttribute>().Product; }
		}

		public string Copyright
		{
			get { return CustomAttributes<AssemblyCopyrightAttribute>().Copyright; }
		}

		public string Trademark
		{
			get { return CustomAttributes<AssemblyTrademarkAttribute>().Trademark; }
		}

		public string AssemblyVersion
		{
			get { return _assembly.GetName().Version.ToString(); }
		}

		public string FileVersion
		{
			get
			{
				FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(_assembly.Location);
				return fvi.FileVersion;
			}
		}

		public string Guid
		{
			get { return CustomAttributes<GuidAttribute>().Value; }
		}

		public string FileName
		{
			get
			{
				FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(_assembly.Location);
				return fvi.OriginalFilename;
			}
		}

		public string FilePath
		{
			get
			{
				FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(_assembly.Location);
				return fvi.FileName;
			}
		}

		public string ProductVersion
		{
			get
			{
				FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(_assembly.Location);
				return fvi.ProductVersion;
			}
		}

		private T CustomAttributes<T>() where T : Attribute
		{
			object[] customAttributes = _assembly.GetCustomAttributes(typeof (T), false);

			if (customAttributes.Length > 0)
			{
				return ((T) customAttributes[0]);
			}

			throw new InvalidOperationException();
		}
	}
}