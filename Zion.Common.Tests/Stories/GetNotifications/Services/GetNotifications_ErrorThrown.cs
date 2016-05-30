using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Repository.Notifications;
using HrMaxx.Common.Services.Notifications;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Mapping;
using log4net;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.GetNotifications.Services
{
	public class GetNotifications_ErrorThrown : SpecsFor<NotificationService>
	{
		private ExistingNotifications _Context;

		protected override void Given()
		{
			_Context = new ExistingNotifications();
			Given(_Context);
		}

		protected override void When()
		{
			try
			{
				_Context.response = SUT.GetNotifications(_Context.loggedinUser);
			}
			catch (Exception e)
			{
				_Context.error = e;
			}
		}

		private class ExistingNotifications : IContext<NotificationService>
		{
			public Exception error;
			public string loggedinUser = "test";
			public List<NotificationDto> response;

			public void Initialize(ISpecs<NotificationService> state)
			{
				state.SUT.Mapper = state.GetMockFor<IMapper>().Object;
				state.SUT.Log = state.GetMockFor<ILog>().Object;
				state.GetMockFor<INotificationRepository>()
					.Setup(i => i.GetNotifications(loggedinUser))
					.Throws(new Exception("Repository error"));
			}
		}

		[Test]
		public void then_common_repository_is_called_to_get_notifications()
		{
			GetMockFor<INotificationRepository>().Verify(repo => repo.GetNotifications(_Context.loggedinUser), Times.Once());
		}

		[Test]
		public void then_error_is_logged()
		{
			GetMockFor<ILog>().Verify(log => log.Error(_Context.error.Message, _Context.error.InnerException), Times.Once());
		}

		[Test]
		public void then_error_is_thrown_from_repository()
		{
			Assert.That(_Context.error, Is.InstanceOf<HrMaxxApplicationException>());
		}
	}
}