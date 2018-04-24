using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Helpers;
using Newtonsoft.Json;

namespace HrMaxx.Infrastructure.Security
{
	public class HrMaxxUser : ClaimsPrincipal
	{
		public HrMaxxUser(ClaimsPrincipal principal)
			: base(principal)
		{
		}

		public string FullName
		{
			get { return HasClaim(claim => claim.Type == HrMaxxClaimTypes.Name) ? FindFirst(claim => claim.Type == HrMaxxClaimTypes.Name).Value : string.Empty; }
		}

		public string UserId
		{
			get { return FindFirst(claim => claim.Type == HrMaxxClaimTypes.UserID).Value; }
		}

		public string Photo
		{
			get
			{
				return HasClaim(claim => claim.Type == HrMaxxClaimTypes.Image)
					? FindFirst(claim => claim.Type == HrMaxxClaimTypes.Image).Value
					: "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg";
			}
		}

		public Guid Host
		{
			get
			{
				return HasClaim(claim => claim.Type == HrMaxxClaimTypes.Host)
						? new Guid(FindFirst(claim => claim.Type == HrMaxxClaimTypes.Host).Value)
						: Guid.Empty;	
			}
			
		}

		public string Role
		{
			get
			{
				return HasClaim(claim => claim.Type == ClaimTypes.Role)
					? FindFirst(c => c.Type == ClaimTypes.Role).Value
					: string.Empty;
			}
		}
		
		public Guid Company
		{
			get
			{
				return HasClaim(claim => claim.Type == HrMaxxClaimTypes.Company)
						? new Guid(FindFirst(claim => claim.Type == HrMaxxClaimTypes.Company).Value)
						: Guid.Empty;
			}

		}
		public Guid Employee
		{
			get
			{
				return HasClaim(claim => claim.Type == HrMaxxClaimTypes.Employee)
						? new Guid(FindFirst(claim => claim.Type == HrMaxxClaimTypes.Employee).Value)
						: Guid.Empty;
			}

		}

		public string eMail
		{
			get { return FindFirst(claim => claim.Type == HrMaxxClaimTypes.Email).Value; }
		}

		public string RoleVersion
		{
			get
			{
				return HasClaim(claim => claim.Type == HrMaxxClaimTypes.RoleVersion)
						? FindFirst(claim => claim.Type == HrMaxxClaimTypes.RoleVersion).Value
						: String.Empty;
			}
		}


		public override bool HasClaim(string claimType, string claimValue)
		{
			return HasClaim(claim => claim.Type == claimType && claim.Value == claimValue);
		}

		public bool HasClaim(string claimType)
		{
			return HasClaim(claim => claim.Type == claimType);
		}
		public string GetClaimsSerialized() { return JsonConvert.SerializeObject(Claims.Select(c=>new {Type = c.Type, Value=c.Value}).ToList()); }
		
	}
}