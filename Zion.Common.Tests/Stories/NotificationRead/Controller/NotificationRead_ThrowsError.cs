using System;
using System.Collections.Generic;
using System.Net;
using System.Reflection;
using System.Security.Claims;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Security;
using HrMaxx.TestSupport.UnitTestHelpers;
using HrMaxxAPI.Controllers;
using log4net;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.NotificationRead.Controller
{
	public class NotificationRead_ThrowsError : SpecsFor<NotificationsController>
	{
		private ExistingNotifications _Context;

		protected override void Given()
		{
			_Context = new ExistingNotifications();
			base.Given(_Context);
		}

		protected override void When()
		{
			try
			{
				SUT.NotificationRead(_Context.NotificationID);
			}
			catch (Exception e)
			{
				_Context.error = e;
			}
		}

		private class ExistingNotifications : IContext<NotificationsController>
		{
			public readonly Guid NotificationID = Guid.NewGuid();
			public Exception error;

			public void Initialize(ISpecs<NotificationsController> state)
			{
				state.SUT.GiveControllerContext(new List<Claim>
				{
					new Claim(HrMaxxClaimTypes.UserID, "Test"),
					new Claim(HrMaxxClaimTypes.Name, "Test"),
					new Claim(HrMaxxClaimTypes.Email, "Test@test.com"),
					new Claim(HrMaxxClaimTypes.Version, Assembly.GetExecutingAssembly().GetName().Version.ToString()),
				});
				state.SUT.Logger = state.GetMockFor<ILog>().Object;
				state.GetMockFor<INotificationService>()
					.Setup(i => i.NotificationRead(NotificationID))
					.Throws(new Exception("Service error"));
			}
		}

		[Test]
		public void then_call_business_layer_to_mark_notification_as_read()
		{
			GetMockFor<INotificationService>().Verify(i => i.NotificationRead(_Context.NotificationID), Times.Once());
		}

		[Test]
		public void then_ensure_exception_is_not_404()
		{
			var exception = (HttpResponseException) _Context.error;
			Assert.That(exception.Response.StatusCode, Is.Not.EqualTo(HttpStatusCode.NotFound));
		}

		[Test]
		public void then_exception_is_thrown()
		{
			Assert.That(_Context.error, Is.InstanceOf<HttpResponseException>());
		}
	}
}