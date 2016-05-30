﻿namespace HrMaxx.Bus.Contracts
{
	public interface ICommandSender
	{
		void Send<T>(T command) where T : Command;
	}
}