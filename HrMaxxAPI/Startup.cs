using System.Web.Http;
using Autofac;
using HrMaxxAPI.Code.IOC;
using HrMaxx.TestSupport;
using Microsoft.Owin;
using Microsoft.Owin.Cors;
using Owin;

[assembly: OwinStartup(typeof(HrMaxxAPI.Startup))]

namespace HrMaxxAPI
{
    public partial class Startup : IOwinStartup
    {
        public void Configuration(IAppBuilder app)
        {
					var config = new HttpConfiguration();

					IContainer container = IOCBootstrapper.Bootstrap();
					app.UseAutofacMiddleware(container);
					app.UseAutofacWebApi(config);

          ConfigureAuth(app);

					WebApiConfig.Register(config);

					app.UseWebApi(config);
					app.UseCors(CorsOptions.AllowAll);
        }
    }
}
