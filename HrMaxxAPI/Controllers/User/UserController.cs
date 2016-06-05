using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxxAPI.Controllers
{
	public class UserController : BaseApiController
	{
		private readonly IUserService _userService;

		public UserController(IUserService userService)
		{
			_userService = userService;
		}

		[HttpGet]
		[Route(UserRoutes.User)]
		public UserProfile GetUser(Guid userId)
		{
			return MakeServiceCall(() => _userService.GetUserProfile(userId), string.Format("Get User Profile By User Id={0}", userId), true);
		}
		[HttpPost]
		[Route(UserRoutes.SaveUser)]
		public void SaveUser(UserProfile user)
		{
			MakeServiceCall(() => _userService.SaveUserProfile(user), string.Format("Save User Profile By User Id={0}", user.UserId));
		}
	}
}