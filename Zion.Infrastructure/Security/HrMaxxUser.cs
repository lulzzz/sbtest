using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Helpers;

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
			get { return FindFirst(claim => claim.Type == HrMaxxClaimTypes.Name).Value; }
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

		public string eMail
		{
			get { return FindFirst(claim => claim.Type == HrMaxxClaimTypes.Email).Value; }
		}

		
		public bool HasClaim(string claimType, string claimValue)
		{
			return HasClaim(claim => claim.Type == claimType && claim.Value == claimValue);
		}

		
	}
}