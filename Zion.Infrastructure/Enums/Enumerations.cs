using System;
using System.ComponentModel;
using System.Reflection;

namespace HrMaxx.Infrastructure.Enums
{
	public static class Enumerations
	{
		public static string GetEnumDescription(this Enum enumValue)
		{
			FieldInfo fi = enumValue.GetType().GetField(enumValue.ToString());

			var attributes =
				(DescriptionAttribute[]) fi.GetCustomAttributes(
					typeof (DescriptionAttribute),
					false);

			if (attributes != null &&
			    attributes.Length > 0)
				return attributes[0].Description;
			return enumValue.ToString();
		}
	}
}