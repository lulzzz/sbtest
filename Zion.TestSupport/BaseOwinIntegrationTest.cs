using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using Microsoft.Owin.Testing;
using NUnit.Framework;

namespace HrMaxx.TestSupport
{
	// TODO: Investigate the posibility of using OWIN TestServer in our unit tests as well instead of mocking HttpContext.

	/// <summary>
	/// </summary>
	/// <typeparam name="TStartup">The Owin App Builder Startup class used to configure the OWIN test server.</typeparam>
	public class BaseOwinIntegrationTestFixture<TStartup> where TStartup : IOwinStartup
	{
		protected TestServer OwinTestServer;

		protected virtual string Uri
		{
			get { throw new NotImplementedException(); }
		}

		protected virtual Dictionary<string, string> RequestHeaders { get; private set; }

		[TestFixtureSetUp]
		protected void BaseOwinIntegrationTestFixtureSetUp()
		{
			RequestHeaders = new Dictionary<string, string>();
			CreateOwinTestInfrastructure();
		}

		[TestFixtureTearDown]
		protected void BaseOwinIntegrationTestFixtureTearDown()
		{
		}

		private void CreateOwinTestInfrastructure()
		{
			OwinTestServer = TestServer.Create<TStartup>();
			PostSetup(OwinTestServer);
		}

		protected virtual void PostSetup(TestServer server)
		{
		}

		protected virtual HttpResponseMessage Get()
		{
			return GetAsync().Result;
		}

		protected virtual T Get<T>()
		{
			return GetAsync<T>().Result;
		}

		protected async Task<TResult> GetAsync<TResult>()
		{
			HttpResponseMessage response = await GetAsync();
			return await response.Content.ReadAsAsync<TResult>();
		}

		protected virtual async Task<HttpResponseMessage> GetAsync()
		{
			return await OwinTestServer.CreateRequest(Uri)
				.And(request => RequestHeaders.ToList().ForEach((header => request.Headers.Add(header.Key, header.Value))))
				.GetAsync();
		}

		protected virtual HttpResponseMessage Post<TModel>(TModel model)
		{
			return PostAsync(model).Result;
		}

		protected virtual async Task<HttpResponseMessage> PostAsync<TModel>(TModel model)
		{
			return await OwinTestServer.CreateRequest(Uri)
				.And(request => request.Content = new ObjectContent(typeof (TModel), model, new JsonMediaTypeFormatter()))
				.And(request => RequestHeaders.ToList().ForEach((header => request.Headers.Add(header.Key, header.Value))))
				.PostAsync();
		}
	}
}