using Owin;

namespace HrMaxx.TestSupport
{
	public interface IOwinStartup
	{
		void Configuration(IAppBuilder appBuilder);
	}
}