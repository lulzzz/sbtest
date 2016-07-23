using System;
using System.Reflection;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.TestSupport;
using NUnit.Framework;
using StoryQ;

namespace HrMaxx.Common.IntegrationTests.Stories.Cryptography
{
	public class TestCryptography : BaseIntegrationTestFixture
	{
		private string data = "hello my friend we meet again";
		private string encrypted = string.Empty;
		private string decrypted = string.Empty;
		[Test]
		public void EncryptAndDecryptData()
		{
			using (TransactionScopeHelper.Transaction())
			{
				new Story("Encrypt And Decrypt Data")
					.InOrderTo("validate the storage, view and protection of sensitive information")
					.AsA("User")
					.IWant("encrypt and then decrypt")
					.WithScenario("PCL")
					.Given(ATestObject)
					.When(EncryptAndDecrypt)
					.Then(ValidateCrypto)
					.ExecuteWithReport(MethodBase.GetCurrentMethod());
			}

		}

		public void ATestObject()
		{
			data = "hello my friend we meet again";
			encrypted = string.Empty;
			decrypted = string.Empty;
		}

		public void EncryptAndDecrypt()
		{
			encrypted = Crypto.Encrypt(data);
			decrypted = Crypto.Decrypt(encrypted);
		}

		private void ValidateCrypto()
		{
			
			Assert.That(encrypted, !Is.EqualTo(data));
			Assert.IsNotEmpty(encrypted);
			Assert.That(decrypted, !Is.EqualTo(encrypted));
			Assert.IsNotEmpty(decrypted);
			Assert.That(decrypted, Is.EqualTo(data));
		}


		internal class SomeTestObjectForSavingValidMemento : IOriginator<SomeTestObjectForSavingValidMemento>
		{
			public Guid Id { get; set; }
			public string Name { get; set; }

			public void ApplyMemento(Memento<SomeTestObjectForSavingValidMemento> memento)
			{
				SomeTestObjectForSavingValidMemento mementoObject = memento.Deserialize();
				Id = mementoObject.Id;
				Name = mementoObject.Name;
			}

			public Guid MementoId
			{
				get { return Id; }
			}
		}
	}
}