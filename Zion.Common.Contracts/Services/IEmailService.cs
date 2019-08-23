using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IEmailService
	{
		Task<bool> SendEmail(string MessageTo, string MessageFrom, string MessageSubject, string MessageBody, string cc = "", string fileName = "");
		
		string GetWebUrl();
	}
}