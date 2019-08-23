﻿using System;
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

		public EmailService(bool emailService, string smtpServer, string webUrl)
		{
			_emailService = emailService;
			_smptServer = smtpServer;
			_webUrl = webUrl;
		}

		public string GetWebUrl()
		{
			return _webUrl;
		}

		public async Task<bool> SendEmail(string MessageTo, string MessageFrom, string MessageSubject, string MessageBody, string CC = "", string fileName = "")
		{
			try
			{

				using (var mail = new MailMessage(MessageFrom, MessageTo))
				{
					mail.From = new MailAddress(MessageFrom, "PAXol");
					mail.IsBodyHtml = true;
					var client = new SmtpClient
					{
						Port = 25,
						DeliveryMethod = SmtpDeliveryMethod.Network,
						UseDefaultCredentials = false,
						Host = _smptServer,
						Credentials = new NetworkCredential("payrollApp@hrmaxx.com", "hrMaxx123")
					};
					mail.Subject = MessageSubject;
					mail.Body = MessageBody;
					if (!string.IsNullOrWhiteSpace(CC))
						mail.CC.Add(CC);

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
					Log.Info("Email sent to " + MessageTo + ". Subject " + MessageSubject);
					await Task.FromResult(0);
				}
				
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX,
					"Send Email for " + MessageSubject + " to " + MessageTo);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			return true;
		}
		
	}
}