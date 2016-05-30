using System.Reflection;
using Autofac;
using Autofac.Integration.Mvc;
using Module = Autofac.Module;

namespace HrMaxx.Web.Code.IOC
{
	public class ControllerModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterControllers(Assembly.GetExecutingAssembly()).PropertiesAutowired();
			builder.RegisterFilterProvider();
		}
	}
}