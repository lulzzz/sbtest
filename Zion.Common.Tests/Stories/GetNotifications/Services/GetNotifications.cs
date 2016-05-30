using System.Collections.Generic;
using System.Linq;
using FizzWare.NBuilder;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Repository.Notifications;
using HrMaxx.Common.Services.Notifications;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.GetNotifications.Services
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

		private class ExistingNotifications : IContext<NotificationService>
		{
			public string loggedinUser = "test";
			public List<NotificationDto> response;

			public void Initialize(ISpecs<NotificationService> state)
			{
				List<NotificationDto> notifications = Builder<NotificationDto>.CreateListOfSize(5).Build().ToList();
				state.GetMockFor<INotificationRepository>().Setup(i => i.GetNotifications(loggedinUser)).Returns(notifications);
			}
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
	}
}