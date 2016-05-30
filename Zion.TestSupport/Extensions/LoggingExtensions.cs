using System;
using log4net;
using Moq;

namespace HrMaxx.TestSupport.Extensions
{
	public static class LoggingExtensions
	{
		public static void LogsException(this Mock<ILog> mockLog, int times = 1)
		{
			mockLog.Verify(l => l.Error(It.IsAny<string>(), It.IsAny<Exception>()), Times.Exactly(times));
		}
	}
}