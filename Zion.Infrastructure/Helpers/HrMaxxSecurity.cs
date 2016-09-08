using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Claims;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Infrastructure.Helpers
{
	public static class HrMaaxxSecurity
	{
		public static T? GetEnumFromDbId<T>(int dbId) where T : struct, IConvertible
		{
			foreach (T enumValue in Enum.GetValues(typeof (T)))
			{
				FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
				var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
				if (attribs.Length == 0) continue;

				if (attribs[0].DbId == dbId)
					return enumValue;
			}
			return null;
		}

		public static T? GetEnumFromDbName<T>(string dbName) where T : struct, IConvertible
		{
			foreach (T enumValue in Enum.GetValues(typeof (T)))
			{
				FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
				var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
				if (attribs.Length == 0) continue;

				if (attribs[0].DbName == dbName)
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

		public static int? GetDbIdFrom<T>(T enumValue) where T : struct, IConvertible
		{
			FieldInfo fieldInfo = typeof (T).GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return attribs[0].DbId;
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
		public static List<KeyValuePair<int, string>> GetEnumList<T>()
		{
			var result = new List<KeyValuePair<int, string>>();
			Enum.GetValues(typeof(T)).Cast<T>().ToList().ForEach(@enum =>
			{

				FieldInfo fieldInfo = @enum.GetType().GetField(@enum.ToString());
				var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
				result.Add(new KeyValuePair<int, string>(attribs[0].DbId, attribs[0].DbName));
			});
			return result;
		}

		public static int? GetDbId(this Enum enumValue)
		{
			FieldInfo fieldInfo = enumValue.GetType().GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return attribs[0].DbId;
		}

		public static string GetDbName(this Enum enumValue)
		{
			FieldInfo fieldInfo = enumValue.GetType().GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return attribs[0].DbName;
		}

		public static Guid? GetHrMaxxId(this Enum enumValue)
		{
			FieldInfo fieldInfo = enumValue.GetType().GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof (HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return new Guid(attribs[0].HrMaxxId);
		}

		public static string GetHrMaxxName(this Enum enumValue)
		{
			FieldInfo fieldInfo = enumValue.GetType().GetField(enumValue.ToString());
			var attribs = fieldInfo.GetCustomAttributes(typeof(HrMaxxSecurityAttribute), false) as HrMaxxSecurityAttribute[];
			if (attribs.Length == 0) return null;
			return attribs[0].HrMaxxName;
		}
	}
}