using System;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Threading.Tasks;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;

namespace HrMaxx.Common.Services.Email
{
	public class EmailService : BaseService, IEmailService
	{
		private readonly bool _emailService;
		private readonly string _smptServer;
		private readonly string _webUrl;
		private readonly string _achPackCC;

		public EmailService(bool emailService, string smtpServer, string webUrl, string achpackcc)
		{
			_emailService = emailService;
			_smptServer = smtpServer;
			_webUrl = webUrl;
			_achPackCC = achpackcc;
		}

		public string GetACHPackCC()
		{
			return _achPackCC;
		}

		public string GetWebUrl()
		{
			return _webUrl;
		}

		public async Task<bool> SendEmail(string to, string subject, string body, string from = "cs.paxol@gmail.com", string cc = "", string fileName = "")
		{
			try
			{

				using (var mail = new MailMessage(from, to))
				{
					mail.From = new MailAddress(from, "PAXol Support");
					mail.IsBodyHtml = true;
					var client = new SmtpClient
					{
						Port = 587, EnableSsl=true,
						DeliveryMethod = SmtpDeliveryMethod.Network,
						UseDefaultCredentials = false,
						Host = _smptServer,
						Credentials = new NetworkCredential("cs.paxol@gmail.com", "Paxol1234!")
					};
					mail.Subject = subject;
					mail.Body = body;
					if (!string.IsNullOrWhiteSpace(cc))
						mail.CC.Add(cc);

					if (!string.IsNullOrWhiteSpace(fileName))
					{
						var data = new Attachment(fileName, MediaTypeNames.Application.Octet);

						// Add time stamp information for the file.
						var disposition = data.ContentDisposition;
						disposition.CreationDate = System.IO.File.GetCreationTime(fileName);
						disposition.ModificationDate = System.IO.File.GetLastWriteTime(fileName);
						disposition.ReadDate = System.IO.File.GetLastAccessTime(fileName);

						// Add the file attachment to this e-mail message.
						mail.Attachments.Add(data);
					}

					if (_emailService)
						client.Send(mail);
					Log.Info("Email sent to " + to + ". Subject " + subject);
					await Task.FromResult(0);
				}
				
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX,
					"Send Email for " + subject + " to " + to);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			return true;
		}
		
	}
}