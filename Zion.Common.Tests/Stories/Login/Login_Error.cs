using System;
using System.Collections.Generic;
using System.Security.Claims;
using FizzWare.NBuilder;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.TestSupport.UnitTestHelpers;
using HrMaxxWeb.Controllers;
using HrMaxxWeb.Models;
using log4net;
using Moq;
using NUnit.Framework;
using SpecsFor;

namespace HrMaxx.Common.Tests.Stories.Login
{
	public class Login_Error : SpecsFor<AccountController>
	{
		private LoginWithServerError _Context;

		protected override void Given()
		{
			_Context = new LoginWithServerError();
			Given(_Context);
			base.Given();
		}

		protected override void When()
		{
			SUT.Login(_Context.AccountViewModel, "");
		}

		private class LoginWithServerError : IContext<AccountController>
		{
			public Exception AuthServiceException { get; set; }
			public LoginViewModel AccountViewModel { get; set; }

			public void Initialize(ISpecs<AccountController> state)
			{
				state.SUT.GiveControllerContext(new List<Claim>());

				AccountViewModel = Builder<LoginViewModel>.CreateNew().Build();
				state.SUT.Logger = state.GetMockFor<ILog>().Object;

				AuthServiceException = new Exception();
				state.GetMockFor<IAuthenticationService>()
					.Setup(a => a.Authenticate(AccountViewModel.Email, AccountViewModel.Password))
					.Throws(AuthServiceException);
			}
		}

		[Test]
		public void then_authentication_service_is_called()
		{
			GetMockFor<IAuthenticationService>()
				.Verify(a => a.Authenticate(_Context.AccountViewModel.Email, _Context.AccountViewModel.Password), Times.Once());
		}

		[Test]
		public void then_logger_will_log_an_exception()
		{
			GetMockFor<ILog>().Verify(l => l.Error(It.IsAny<string>(), _Context.AuthServiceException));
		}
	}
}