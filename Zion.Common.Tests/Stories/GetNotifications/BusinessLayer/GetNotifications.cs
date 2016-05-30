using Moq;
using NUnit.Framework;
using SpecsFor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Zion.Common.Models.Dtos;
using Zion.Common.Repository.Notification;
using Zion.Common.Services.Notifications;

namespace Zion.Common.Tests.Stories.GetNotifications.BusinessLayer
{
	public class GetNotifications : SpecsFor<NotificationService>
	{
		private ExistingNotifications _Context;
		protected override void Given()
		{
			_Context = new ExistingNotifications();
			Given(_Context);
		}

		protected override void When()
		{
			_Context.response = SUT.GetNotifications(_Context.loggedinUser);
		}

		[Test]
		public void then_common_repository_is_called_to_get_notifications()
		{
			GetMockFor<INotificationRepository>().Verify(repo => repo.GetNotifications(_Context.loggedinUser), Times.Once());
		}

		[Test]
		public void then_correct_number_of_notifications_are_returned()
		{
			Assert.That(_Context.response.Count, Is.EqualTo(5));
		}
		private class ExistingNotifications : IContext<NotificationService>
		{

			public string loggedinUser = "test";
			public List< NotificationDto> response;

			public void Initialize(ISpecs<NotificationService> state)
			{
				var notifications = FizzWare.NBuilder.Builder<Models.Dtos.NotificationDto>.CreateListOfSize(5).Build().ToList();
				state.GetMockFor<INotificationRepository>().Setup(i => i.GetNotifications(loggedinUser)).Returns(notifications);
			}
		}
	}
}
