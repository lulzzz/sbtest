using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Common.Services.Security;
using HrMaxx.Infrastructure.Helpers;
using HrMaxxAPI.Resources;
using HrMaxxAPI.Resources.Common;
using Microsoft.AspNet.Identity.Owin;
using RestSharp;

namespace HrMaxxAPI.Controllers.User
{
	public class UserController : BaseApiController
	{
		private readonly IUserService _userService;
		
		

		public UserController(IUserService userService )
		{
			_userService = userService;
			
		}
		public ApplicationUserManager UserManager
		{
			get
			{
				return  HttpContext.Current.GetOwinContext().GetUserManager<ApplicationUserManager>();
			}
			
		}
		[HttpGet]
		[Route(UserRoutes.User)]
		public UserProfile GetUser()
		{
			return MakeServiceCall(() => _userService.GetUserProfile(new Guid(CurrentUser.UserId)), string.Format("Get User Profile By User Id={0}", CurrentUser.UserId), true);
		}

		[HttpGet]
		[Route(UserRoutes.Users)]
		public List<UserResource> GetUsers(Guid? hostId = null, Guid? companyId = null)
		{
			var users = MakeServiceCall(() => _userService.GetUsers(hostId, companyId), string.Format("Get Users for scope"), true);
			if (CurrentUser.Host != Guid.Empty)
			{
				if (CurrentUser.Company != Guid.Empty)
				{
					users = users.Where(u => u.Company.HasValue && u.Company.Value == CurrentUser.Company).ToList();
				}
				else
				{
					users = users.Where(u => u.Host.HasValue && u.Host.Value == CurrentUser.Host).ToList();
				}
			}
			return Mapper.Map<List<UserModel>, List<UserResource>>(users);
		}

		[HttpPost]
		[Route(UserRoutes.SaveUserProfile)]
		public void SaveUserProfile(UserProfile user)
		{
			MakeServiceCall(() => _userService.SaveUserProfile(user), string.Format("Save User Profile By User Id={0}", user.UserId));
		}

		[HttpPost]
		[Route(UserRoutes.ResetPassword)]
		public async Task UserPasswordReset(UserResource resource)
		{
			try
			{
				var user = await UserManager.FindByNameAsync(resource.UserName);
				if (user == null)
				{
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.BadRequest,
						ReasonPhrase = "No matching user found"
					});
				}
				string code = GetCode(user.Id, false);
				var callbackUrl = string.Format("{0}/{1}/{2}?userId={3}&code={4}", ConfigurationManager.AppSettings["WebURL"],
					"Account", "ResetPassword", user.Id, HttpUtility.UrlEncode(code));
				await UserManager.SendEmailAsync(user.Id, "Reset Password", "Please reset your password by clicking <a href=\"" + callbackUrl + "\">here</a>");
			}
			catch (Exception e)
			{
				Logger.Error("Error Resetting password", e);
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = "Unexpected error occured while sending a reset password request"
				});
			}
			
			
		}

		[HttpPost]
		[Route(UserRoutes.UserPasswordChange)]
		public async Task ChangePassword(UserPasswordChangeRequest resource)
		{
			var userExists = await UserManager.FindByEmailAsync(CurrentUser.eMail);
			if (userExists == null)
			{
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.BadRequest,
					ReasonPhrase = "this user does not exist"
				});
			}
			try
			{
				var result = await UserManager.ChangePasswordAsync(CurrentUser.UserId, resource.OldPassword, resource.NewPassword);
				if (!result.Succeeded)
				{
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.InternalServerError,
						ReasonPhrase = result.Errors.Any() ? result.Errors.First() : " Failed to Change User Password"
					});

				}
			}
			catch (Exception e)
			{
				Logger.Error("Error creating user", e);
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = "Failed to complete change user password"
				});
			}
			
		}

		[HttpPost]
		[Route(UserRoutes.SaveUser)]
		public async Task<UserResource> SaveUser(UserResource model)
		{
			var userExists = await UserManager.FindByNameAsync(model.UserName);
			
			if (userExists!=null)
			{
				if (model.UserId.HasValue)
				{
					var usermodel = Mapper.Map<UserResource, UserModel>(model);
					if (userExists.Email != usermodel.Email)
					{
						usermodel.Active = false;
						userExists.EmailConfirmed = false;
					}
						
					MakeServiceCall(() => _userService.SaveUser(usermodel),
						string.Format("Save User details for User Id={0}", model.UserId));
					await UserManager.UpdateAsync(userExists);
					if (!userExists.EmailConfirmed)
						await SendEmailConfirmationTokenAsync(userExists.Id, "Confirm your account");
					return model;
				}
				else
				{
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.BadRequest,
						ReasonPhrase = "A user already exists with this user name"
					});
				}
				
			}
			try
			{
				var user = new ApplicationUser { UserName = model.UserName, Email = model.Email, FirstName = model.FirstName, LastName = model.LastName, Host = model.HostId, Company = model.CompanyId, Active = model.Active, PhoneNumber = model.Phone };
				var result = await UserManager.CreateAsync(user, "HrMaxx1234!");
				if (result.Succeeded)
				{
					var role = string.Empty;
					if (!model.SourceTypeId.HasValue)
					{
						role = RoleTypeEnum.Admin.GetDbName();
					}
					else
					{
						if (model.SourceTypeId.Value == EntityTypeEnum.Employee && model.EmployeeId.HasValue)
							role = RoleTypeEnum.Employee.GetDbName();
						else if (model.SourceTypeId.Value == EntityTypeEnum.Company && model.CompanyId.HasValue)
							role = RoleTypeEnum.Company.GetDbName();
						else
						{
							role = RoleTypeEnum.Host.GetDbName();
						}
					}
					await UserManager.AddToRoleAsync(user.Id, role);
					model.UserId = new Guid(user.Id);
					string callbackUrl = await SendEmailConfirmationTokenAsync(user.Id, "Confirm your account");
					return model;
				}
				else
				{
					
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.Conflict,
						ReasonPhrase = result.Errors.Any() ? result.Errors.First() : " Failed to Save User"
					});

				}
			}
			catch (Exception e)
			{
				Logger.Error("Error creating user", e);
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = "Failed to complete user creation"
				});
			}
			
			
		}
		private async Task<string> SendEmailConfirmationTokenAsync(string userID, string subject)
		{
			string code = GetCode(userID, true);//await UserManager.GenerateEmailConfirmationTokenAsync(userID));
			
			var callbackUrl = string.Format("{0}/{1}/{2}?userId={3}&code={4}", ConfigurationManager.AppSettings["WebURL"],
				"Account", "ConfirmEmail", userID, HttpUtility.UrlEncode(code));
			
			await UserManager.SendEmailAsync(userID, subject,
				 "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>");

			return callbackUrl;
		}

		private string GetCode(string userId, bool confirmEmail)
		{
			try
			{
				var client = new RestClient { BaseUrl = new Uri(ConfigurationManager.AppSettings["WebURL"] + "/Account/Token") };

				var request = new RestRequest { UseDefaultCredentials = true };
				request.AddParameter("userId", userId, ParameterType.QueryString); // used on every request
				request.AddParameter("confirmEmail", confirmEmail, ParameterType.QueryString); // used on every request

				var response = client.Execute(request);
				return response.Content;

			}
			catch (Exception e)
			{
				Logger.Error("Error getting email token from Web", e);
				return string.Empty;
			}
			
		}
	}
}