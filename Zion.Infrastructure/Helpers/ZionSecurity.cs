using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Claims;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Infrastructure.Helpers
{
	public static class HrMaaxxSecurity
	{
		public static T? GetEnumFromUAMId<T>(int UamId) where T : struct, IConvertible
		{
			foreach (T enumValue in Enum.GetValues(typeof (T)))
			{
				FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
				var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
				if (attribs.Length == 0) continue;

				if (attribs[0].UAMId == UamId)
					return enumValue;
			}
			return null;
		}

		public static T? GetEnumFromUAMName<T>(string UamName) where T : struct, IConvertible
		{
			foreach (T enumValue in Enum.GetValues(typeof (T)))
			{
				FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
				var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
				if (attribs.Length == 0) continue;

				if (attribs[0].UAMName == UamName)
					return enumValue;
			}
			return null;
		}

		public static T? GetEnumFromHrMaxxId<T>(Guid hrMaxxid) where T : struct, IConvertible
		{
			foreach (T enumValue in Enum.GetValues(typeof (T)))
			{
				FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
				var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
				if (attribs != null && attribs.Length == 0) continue;

				var enumHrMaxxId = new Guid();
				if (attribs != null && !Guid.TryParse(attribs[0].HrMaxxId, out enumHrMaxxId)) continue;
				if (enumHrMaxxId == hrMaxxid)
					return enumValue;
			}
			return null;
		}

		public static int? GetUAMIdFrom<T>(T enumValue) where T : struct, IConvertible
		{
			FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return attribs[0].UAMId;
		}

		public static Guid? GetHrMaxxIdFromEnum<T>(T enumValue) where T : struct, IConvertible
		{
			FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;

			Guid enumHrMaxxId;
			if (Guid.TryParse(attribs[0].HrMaxxId, out enumHrMaxxId))
				return enumHrMaxxId;
			return null;
		}

		public static List<T> GetEnumFromClaims<T>(List<Claim> claims) where T : struct, IConvertible
		{
			var enumClaims = new List<T>();

			claims.ForEach(claim =>
			{
				T enumValue;
				if (Enum.TryParse(claim.Value, out enumValue))
				{
					enumClaims.Add(enumValue);
				}
			});
			return enumClaims;
		}

		public static List<string> GetStringValuesFromClaims(List<Claim> claims)
		{
			var values = new List<string>();

			claims.ForEach(claim => values.Add(claim.Value));
			return values;
		}

		public static List<Guid> GetHrMaxxIdFromEnumList<T>(List<T> enums) where T : struct, IConvertible
		{
			var claimGuids = new List<Guid>();
			enums.ForEach(@enum =>
			{
				Guid? hrmaxxId = GetHrMaxxIdFromEnum(@enum);
				if (hrmaxxId.HasValue)
					claimGuids.Add(hrmaxxId.Value);
			});
			return claimGuids;
		}

		public static int? GetUAMId(this Enum enumValue)
		{
			FieldInfo fieldInfo = enumValue.GetType().GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return attribs[0].UAMId;
		}

		public static string GetUAMName(this Enum enumValue)
		{
			FieldInfo fieldInfo = enumValue.GetType().GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return attribs[0].UAMName;
		}

		public static Guid? GetHrMaxxId(this Enum enumValue)
		{
			FieldInfo fieldInfo = enumValue.GetType().GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return new Guid(attribs[0].HrMaxxId);
		}
	}
}