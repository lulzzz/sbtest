using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Security.Claims;
using System.Web.Http;
using FizzWare.NBuilder;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.TestSupport.UnitTestHelpers;
using HrMaxxAPI.Controllers;
using HrMaxxAPI.Resources.Common;
using log4net;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.GetNotifications.Controller
{
	public class GetNotifications_NothingFound : SpecsFor<NotificationsController>
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
				_Context.Notifications = SUT.GetNotifications();
			}
			catch (Exception ex)
			{
				_Context.serviceError = ex;
			}
		}

		private class ExistingNotifications : IContext<NotificationsController>
		{
			public Exception serviceError;
			public string testUser = "Test";
			public List<NotificationsResource> Notifications { get; set; }
			public List<NotificationDto> MockedNotifications { get; set; }

			public void Initialize(ISpecs<NotificationsController> state)
			{
				MockedNotifications = Builder<NotificationDto>.CreateListOfSize(10).Build().ToList();
				state.SUT.Mapper = state.GetMockFor<IMapper>().Object;
				state.SUT.GiveControllerContext(new List<Claim>
				{
					new Claim(HrMaxxClaimTypes.UserID, "Test"),
					new Claim(HrMaxxClaimTypes.Name, "Test"),
					new Claim(HrMaxxClaimTypes.Email, "Test@test.com"),
					new Claim(HrMaxxClaimTypes.Version, Assembly.GetExecutingAssembly().GetName().Version.ToString()),
				});

				state.SUT.Logger = state.GetMockFor<ILog>().Object;
				state.GetMockFor<INotificationService>()
					.Setup(i => i.GetNotifications(testUser))
					.Returns((List<NotificationDto>) null);
			}
		}

		[Test]
		public void then_business_layer_throws_exception()
		{
			Assert.That(_Context.serviceError, Is.InstanceOf<HttpResponseException>());
		}

		[Test]
		public void then_call_business_layer_to_get_notifications()
		{
			GetMockFor<INotificationService>().Verify(i => i.GetNotifications(_Context.testUser), Times.Once());
		}

		[Test]
		public void then_ensure_exception_is_404()
		{
			var exception = (HttpResponseException) _Context.serviceError;
			Assert.That(exception.Response.StatusCode, Is.EqualTo(HttpStatusCode.NotFound));
		}

		[Test]
		public void then_ensure_isSuccessCode_is_false()
		{
			var exception = (HttpResponseException) _Context.serviceError;
			Assert.That(exception.Response.IsSuccessStatusCode, Is.EqualTo(false));
		}

		[Test]
		public void then_ensure_mapper_is_not_called()
		{
			GetMockFor<IMapper>()
				.Verify(mapper => mapper.Map<NotificationDto, NotificationsResource>(It.IsAny<NotificationDto>()), Times.Never);
		}
	}
}