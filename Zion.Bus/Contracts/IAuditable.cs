using System;

namespace HrMaxx.Bus.Contracts
{
	public interface IAuditable
	{
		DateTime MessageDate { get; set; }
		string IdentityOfProtagonist { get; set; }
	}
}