using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
	}
}
