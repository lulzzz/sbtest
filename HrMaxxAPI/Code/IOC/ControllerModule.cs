using System.Reflection;
using Autofac;
using Autofac.Integration.WebApi;
using Module = Autofac.Module;

namespace HrMaxxAPI.Code.IOC
{
	public class ControllerModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterApiControllers(Assembly.GetAssembly(typeof (ControllerModule))).PropertiesAutowired();
		}
	}
}