using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IEmailService
	{
		Task<bool> SendEmail(string to, string subject, string body, string from = "Paxol@hrmaxx.com", string cc = "", string fileName = "");

		string GetACHPackCC();
		string GetWebUrl();
	}
}