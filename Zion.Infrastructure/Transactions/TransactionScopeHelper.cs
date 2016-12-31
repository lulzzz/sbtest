using System;
using System.Transactions;

namespace HrMaxx.Infrastructure.Transactions
{
	public static class TransactionScopeHelper
	{
		public static TransactionScope Transaction(TransactionScopeOption option = TransactionScopeOption.Required,
			IsolationLevel isolationLevel = IsolationLevel.ReadCommitted)
		{
			return new TransactionScope(option,
				new TransactionOptions {IsolationLevel = isolationLevel, Timeout = TimeSpan.FromSeconds(120)});
		}
		public static TransactionScope TransactionNoTimeout(TransactionScopeOption option = TransactionScopeOption.Required,
			IsolationLevel isolationLevel = IsolationLevel.ReadCommitted)
		{
			return new TransactionScope(option,
				new TransactionOptions { IsolationLevel = isolationLevel, Timeout =TransactionManager.MaximumTimeout });
		}

		public static void Wrap(Action action)
		{
			using (TransactionScope transactionScope = Transaction())
			{
				action();

				transactionScope.Complete();
			}
		}

		public static T Wrap<T>(Func<T> action)
		{
			using (TransactionScope transactionScope = Transaction())
			{
				T wrap = action();

				transactionScope.Complete();

				return wrap;
			}
		}
	}
}