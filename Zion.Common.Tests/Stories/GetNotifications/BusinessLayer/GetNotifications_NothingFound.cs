using log4net;
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
using Zion.Infrastructure.Exceptions;
using Zion.Infrastructure.Mapping;

namespace Zion.Common.Tests.Stories.GetNotifications.BusinessLayer
{
	public class GetNotifications_NothingFound : SpecsFor<NotificationService>
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
		public void then_response_is_null()
		{
			Assert.That(_Context.response, Is.EqualTo(null));
		}
		
		private class ExistingNotifications : IContext<NotificationService>
		{

			public string loggedinUser = "test";
			public List<NotificationDto> response;
			
			public void Initialize(ISpecs<NotificationService> state)
			{
				state.SUT.Mapper = state.GetMockFor<IMapper>().Object;
				state.SUT.Log = state.GetMockFor<ILog>().Object;
				state.GetMockFor<INotificationRepository>().Setup(i => i.GetNotifications(loggedinUser)).Returns<List<NotificationDto>>(null);
			}
		}
	}
}
