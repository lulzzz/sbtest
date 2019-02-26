﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.Xsl;
using Newtonsoft.Json;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;

namespace HrMaxx.Infrastructure.Helpers
{
	public static class Utilities
	{
		public static string NumberToWords(decimal number)
		{
			if (number == 0)
				return "Zero";

			if (number < 0)
				return "minus " + NumberToWords(Math.Abs(number));

			string words = "";
			
			if ((int)(number / 1000000) > 0)
			{
				words += NumberToWords((int)number / 1000000) + " Million ";
				number %= 1000000;
			}

			if (((int) number / 1000) > 0)
			{
				words += NumberToWords((int) number / 1000) + " Thousand ";
				number %= 1000;
			}

			if (((int) number / 100) > 0)
			{
				words += NumberToWords((int) number / 100) + " Hundred ";
				number %= 100;
			}

			if (number > 0)
			{
				if (words != "")
					words += "and ";

				var unitsMap = new[] { "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
				var tensMap = new[] { "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

				if (number < 20)
					words += unitsMap[(int)number];
				else
				{
					words += tensMap[(int)number / 10];
					if ((number % 10) > 0)
						words += "-" + unitsMap[(int)number % 10];
				}
			}

			return words;
		}

		public static bool IsValidEmail(string email)
		{
			try
			{
				var mail = new System.Net.Mail.MailAddress(email);
				return true;
			}
			catch
			{
				return false;
			}
		}

		public static T GetCopy<T>(T source)
		{
			return JsonConvert.DeserializeObject<T>(JsonConvert.SerializeObject(source));
		}

		public static Guid GetGuidFromEntityTypeAndId(int type, int id)
		{
			var str = string.Format("{0}-0000-0000-0000-{1}", type.ToString().PadLeft(8, '0'),
					id.ToString().PadLeft(12, '0'));
			return new Guid(str);
		}

		public static string GetCommaSeperatedList<T>(List<T> list )
		{
			var str = list.Aggregate(string.Empty, (current, m) => current + Convert.ToInt16(m) + ",");
			return str.Substring(0, str.Length - 1);
		}

		public static T Deserialize<T>(string xmlStream, XmlRootAttribute rootAttribute)
		{

			if (string.IsNullOrWhiteSpace(xmlStream))
				return default(T);
			using (var reader = new MemoryStream(Encoding.UTF8.GetBytes(xmlStream)))
			{
				//var serializer = new XmlSerializer(typeof(T), rootAttribute);
				var serializer = XmlSerializerCache.Create(typeof(T), rootAttribute);
				return (T)serializer.Deserialize(reader);
			}
		}
		public static T Deserialize<T>(string xmlStream)
		{

			if (string.IsNullOrWhiteSpace(xmlStream))
				return default(T);
			using (var reader = new MemoryStream(Encoding.UTF8.GetBytes(xmlStream)))
			{
				var serializer = new XmlSerializer(typeof(T));
				return (T)serializer.Deserialize(reader);
			}
		}
		public static XmlDocument GetXml<T>(T data)
		{

			XmlDocument xd = null;

			using (var memStm = new MemoryStream())
			{
				var ser = new XmlSerializer(typeof(T));
				ser.Serialize(memStm, data);

				memStm.Position = 0;

				var settings = new XmlReaderSettings();
				settings.IgnoreWhitespace = true;

				using (var xtr = XmlReader.Create(memStm, settings))
				{
					xd = new XmlDocument();
					xd.Load(xtr);
				}
			}

			return xd;
		}

		public static string XmlTransform(XmlDocument source, string transformer, XsltArgumentList args)
		{
			string strOutput = null;
			var sb = new System.Text.StringBuilder();

			using (TextWriter xtw = new StringWriter(sb))
			{
				var xslt = new XslCompiledTransform();// Mvp.Xml.Exslt.ExsltTransform();

				xslt.Load(transformer);
				xslt.Transform(source, args, xtw);
				xtw.Flush();
			}
			strOutput = sb.ToString();
			return strOutput;
		}
	}
}
