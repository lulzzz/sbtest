using System.Collections.Generic;
using System.Linq;
using FizzWare.NBuilder;
using Moq;
using NUnit.Framework;
using SpecsFor;
using Zion.API.Controllers;
using Zion.Common.Contracts.Messages.RequestResponse;
using Zion.Common.Contracts.Services;
using Zion.Common.Models.Dtos;
using Zion.API.Resources.Common;
using Zion.Infrastructure.Mapping;
using log4net;
using Zion.Infrastructure.Security;
using Zion.TestSupport.UnitTestHelpers;
using System.Security.Claims;
using Zion.Infrastructure.Enums;
using System;
using Zion.Common.Services.Notifications;
using Zion.Common.Repository.Notification;
using Zion.Infrastructure.Exceptions;
namespace Zion.Common.Tests.Stories.NotificationRead.BusinessLayer
{
	public class NotificationRead : SpecsFor<NotificationService>
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

		[Test]
		public void then_call_repository_layer_to_mark_notification_as_read()
		{
			GetMockFor<INotificationRepository>().Verify(i => i.NotificationRead(_Context.NotificationID), Times.Once());
		}
		[Test]
		public void then_call_repository_layer_throw_exception()
		{
			Assert.That(_Context.error, Is.InstanceOf<ZionApplicationException>());
		}
		[Test]
		public void then_logger_called_once()
		{
			GetMockFor<ILog>().Verify(l => l.Error(_Context.error.Message, _Context.error.InnerException), Times.Once());
		}
		private class ExistingNotifications : IContext<NotificationService>
		{
			public Guid NotificationID = Guid.NewGuid();
			public Exception error;
			public void Initialize(ISpecs<NotificationService> state)
			{
				state.SUT.Log = state.GetMockFor<ILog>().Object;
				state.GetMockFor<INotificationRepository>().Setup(i => i.NotificationRead(NotificationID)).Throws(new Exception("Repository Error"));
			}
		}
	}
}
