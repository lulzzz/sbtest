using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Claims;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Security;
using HrMaxx.TestSupport.UnitTestHelpers;
using HrMaxxAPI.Controllers;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.NotificationRead.Controller
{
	public class NotificationRead : SpecsFor<NotificationsController>
	{
		private ExistingNotifications _Context;

		protected override void Given()
		{
			_Context = new ExistingNotifications();
			base.Given(_Context);
		}

		protected override void When()
		{
			SUT.NotificationRead(_Context.NotificationID);
		}

		private class ExistingNotifications : IContext<NotificationsController>
		{
			public readonly Guid NotificationID = Guid.NewGuid();

			public void Initialize(ISpecs<NotificationsController> state)
			{
				state.SUT.GiveControllerContext(new List<Claim>
				{
					new Claim(HrMaxxClaimTypes.UserID, "Test"),
					new Claim(HrMaxxClaimTypes.Name, "Test"),
					new Claim(HrMaxxClaimTypes.Email, "Test@test.com"),
					new Claim(HrMaxxClaimTypes.Version, Assembly.GetExecutingAssembly().GetName().Version.ToString()),
				});
				state.GetMockFor<INotificationService>().Setup(i => i.NotificationRead(NotificationID));
			}
		}

		[Test]
		public void then_call_business_layer_to_mark_notification_as_read()
		{
			GetMockFor<INotificationService>().Verify(i => i.NotificationRead(_Context.NotificationID), Times.Once());
		}
	}
}