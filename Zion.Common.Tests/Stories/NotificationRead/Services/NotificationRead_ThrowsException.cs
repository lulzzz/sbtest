using System;
using HrMaxx.Common.Repository.Notifications;
using HrMaxx.Common.Services.Notifications;
using HrMaxx.Infrastructure.Exceptions;
using log4net;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.NotificationRead.Services
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

		private class ExistingNotifications : IContext<NotificationService>
		{
			public readonly Guid NotificationID = Guid.NewGuid();
			public Exception error;

			public void Initialize(ISpecs<NotificationService> state)
			{
				state.SUT.Log = state.GetMockFor<ILog>().Object;
				state.GetMockFor<INotificationRepository>()
					.Setup(i => i.NotificationRead(NotificationID))
					.Throws(new Exception("Repository Error"));
			}
		}

		[Test]
		public void then_call_repository_layer_throw_exception()
		{
			Assert.That(_Context.error, Is.InstanceOf<HrMaxxApplicationException>());
		}

		[Test]
		public void then_call_repository_layer_to_mark_notification_as_read()
		{
			GetMockFor<INotificationRepository>().Verify(i => i.NotificationRead(_Context.NotificationID), Times.Once());
		}

		[Test]
		public void then_logger_called_once()
		{
			GetMockFor<ILog>().Verify(l => l.Error(_Context.error.Message, _Context.error.InnerException), Times.Once());
		}
	}
}