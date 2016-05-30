using System;
using HrMaxx.Common.Repository.Notifications;
using HrMaxx.Common.Services.Notifications;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.NotificationRead.Services
{
	public class NotificationRead_ThrowsError : SpecsFor<NotificationService>
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

		private class ExistingNotifications : IContext<NotificationService>
		{
			public readonly Guid NotificationID = Guid.NewGuid();

			public void Initialize(ISpecs<NotificationService> state)
			{
				state.GetMockFor<INotificationRepository>().Setup(i => i.NotificationRead(NotificationID));
			}
		}

		[Test]
		public void then_call_repository_layer_to_mark_notification_as_read()
		{
			GetMockFor<INotificationRepository>().Verify(i => i.NotificationRead(_Context.NotificationID), Times.Once());
		}
	}
}