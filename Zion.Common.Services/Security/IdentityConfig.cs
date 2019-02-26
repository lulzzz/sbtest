using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web.Mvc;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Security;
using MassTransit.Util;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Microsoft.Owin.Security;

namespace HrMaxx.Common.Services.Security
{
    public class EmailService : IIdentityMessageService
    {
			public async Task SendAsync(IdentityMessage message)
			{
				await SendEmailasync(message);
			}

			// Use NuGet to install SendGrid (Basic C# client lib) 
			private async Task SendEmailasync(IdentityMessage message)
			{
				var credentials = new NetworkCredential("payrollApp@hrmaxx.com", "hrMaxx123");
				var mail = new MailMessage("PayrollTaxDepartment@hrmaxx.com", message.Destination);
				var client = new SmtpClient
				{
					Port = 25,
					DeliveryMethod = SmtpDeliveryMethod.Network,
					UseDefaultCredentials = false,
					Host = ConfigurationManager.AppSettings["SMTPServer"],
				  Credentials = credentials
				};


				mail.IsBodyHtml = true;
				mail.Subject = message.Subject;
				mail.Body = message.Body;
				client.Send(mail);
				await Task.FromResult(0);

			}
    }

    public class SmsService : IIdentityMessageService
    {
        public Task SendAsync(IdentityMessage message)
        {
            // Plug in your SMS service here to send a text message.
            return Task.FromResult(0);
        }
    }

    // Configure the application user manager used in this application. UserManager is defined in ASP.NET Identity and is used by the application.
    public class ApplicationUserManager : UserManager<ApplicationUser>
    {
	   public ApplicationUserManager(IUserStore<ApplicationUser> store)
            : base(store)
        {
	       
        }

        public static ApplicationUserManager Create(IdentityFactoryOptions<ApplicationUserManager> options, IOwinContext context) 
        {
            var manager = new ApplicationUserManager(new UserStore<ApplicationUser>(context.Get<ApplicationDbContext>()));
            // Configure validation logic for usernames
            manager.UserValidator = new UserValidator<ApplicationUser>(manager)
            {
                AllowOnlyAlphanumericUserNames = true,
                RequireUniqueEmail = false
            };
					

            // Configure validation logic for passwords
						//manager.PasswordValidator = new PasswordValidator
						//{ 
						//		RequiredLength = 6,
						//		RequireNonLetterOrDigit = true,
						//		RequireDigit = true,
						//		RequireLowercase = true,
						//		RequireUppercase = true,
						//};

						manager.PasswordValidator = new PasswordValidator
						{
							RequiredLength = 1,
							RequireNonLetterOrDigit = false,
							RequireDigit = false,
							RequireLowercase = false,
							RequireUppercase = false,
						};
						
            // Configure user lockout defaults
            manager.UserLockoutEnabledByDefault = true;
            manager.DefaultAccountLockoutTimeSpan = TimeSpan.FromMinutes(5);
            manager.MaxFailedAccessAttemptsBeforeLockout = 5;

            // Register two factor authentication providers. This application uses Phone and Emails as a step of receiving a code for verifying the user
            // You can write your own provider and plug it in here.
            manager.RegisterTwoFactorProvider("Phone Code", new PhoneNumberTokenProvider<ApplicationUser>
            {
                MessageFormat = "Your security code is {0}"
            });
            manager.RegisterTwoFactorProvider("Email Code", new EmailTokenProvider<ApplicationUser>
            {
                Subject = "Security Code",
                BodyFormat = "Your security code is {0}"
            });
						
						manager.EmailService = new EmailService();
            manager.SmsService = new SmsService();
            var dataProtectionProvider = options.DataProtectionProvider;
            if (dataProtectionProvider != null)
            {
	            manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(dataProtectionProvider.Create("ASP.NET Identity"));
            }
            return manager;
        }
    }

    // Configure the application sign-in manager which is used in this application.
    public class ApplicationSignInManager : SignInManager<ApplicationUser, string>
    {
        public ApplicationSignInManager(ApplicationUserManager userManager, IAuthenticationManager authenticationManager)
            : base(userManager, authenticationManager)
        {
        }

        public override Task<ClaimsIdentity> CreateUserIdentityAsync(ApplicationUser user)
        {

					return user.GenerateUserIdentityAsync((ApplicationUserManager)UserManager);
	       
        }

        public static ApplicationSignInManager Create(IdentityFactoryOptions<ApplicationSignInManager> options, IOwinContext context)
        {
            return new ApplicationSignInManager(context.GetUserManager<ApplicationUserManager>(), context.Authentication);
        }
    }
}
