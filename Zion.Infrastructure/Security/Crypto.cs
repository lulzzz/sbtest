using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.Results;

namespace HrMaxx.Infrastructure.Security
{
	public static class Crypto
	{
		private static TripleDESCryptoServiceProvider m_des = new TripleDESCryptoServiceProvider();

    private static UTF32Encoding m_utf8  =  new UTF32Encoding();


		private static byte[] m_key = new byte[]
		{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24};

		private static byte[] m_iv = new byte[] {8, 7, 6, 5, 4, 3, 2, 1};

		public static string Encrypt(string value)
		{
			using (var cryptoProvider = new TripleDESCryptoServiceProvider())
			using (var memoryStream = new MemoryStream())
			using (var cryptoStream = new CryptoStream(memoryStream, cryptoProvider.CreateEncryptor(m_key,m_iv), CryptoStreamMode.Write))
			using (var writer = new StreamWriter(cryptoStream))
			{
				writer.Write(value);
				writer.Flush();
				cryptoStream.FlushFinalBlock();
				writer.Flush();
				return Convert.ToBase64String(memoryStream.GetBuffer(), 0, (int)memoryStream.Length);
			}
		}

		public static string Decrypt(string value)
		{
			using (var cryptoProvider = new TripleDESCryptoServiceProvider())
			using (var memoryStream = new MemoryStream(Convert.FromBase64String(value)))
			using (var cryptoStream = new CryptoStream(memoryStream, cryptoProvider.CreateDecryptor(m_key, m_iv), CryptoStreamMode.Read))
			using (var reader = new StreamReader(cryptoStream))
			{
				return reader.ReadToEnd();
			}
		}
        

	}
}
