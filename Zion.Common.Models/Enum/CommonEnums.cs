using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Common.Models.Enum
{
	public enum States
	{
		[HrMaxxSecurity(DbId = 1, DbName = "California", HrMaxxName = "CA")]
		California = 1,
		[HrMaxxSecurity(DbId = 2, DbName = "Alaska", HrMaxxName = "AK")]
		Alaska = 2,
		[HrMaxxSecurity(DbId = 3, DbName = "Arizona", HrMaxxName = "AZ")]
		Arizona = 3,
		[HrMaxxSecurity(DbId = 4, DbName = "Arkansas", HrMaxxName = "AR")]
		Arkansas = 4,
		[HrMaxxSecurity(DbId = 5, DbName = "Colorado", HrMaxxName = "CO")]
		Colorado = 5,
		[HrMaxxSecurity(DbId = 6, DbName = "Connecticut", HrMaxxName = "CT")]
		Connecticut = 6,
		[HrMaxxSecurity(DbId = 7, DbName = "Delaware", HrMaxxName = "DE")]
		Delaware = 7,
		[HrMaxxSecurity(DbId = 8, DbName = "Florida", HrMaxxName = "FL")]
		Florida = 8,
		[HrMaxxSecurity(DbId = 9, DbName = "Georgia", HrMaxxName = "GA")]
		Georgia = 9,
		[HrMaxxSecurity(DbId = 10, DbName = "Hawaii", HrMaxxName = "HI")]
		Hawaii = 10,
		[HrMaxxSecurity(DbId = 11, DbName = "Idaho", HrMaxxName = "ID")]
		Idaho = 11,
		[HrMaxxSecurity(DbId = 12, DbName = "Illinois", HrMaxxName = "IL")]
		Illinois = 12,
		[HrMaxxSecurity(DbId = 13, DbName = "Indiana", HrMaxxName = "IN")]
		Indiana = 13,
		[HrMaxxSecurity(DbId = 14, DbName = "Iowa", HrMaxxName = "IA")]
		Iowa = 14,
		[HrMaxxSecurity(DbId = 15, DbName = "Kansas", HrMaxxName = "KS")]
		Kansas = 15,
		[HrMaxxSecurity(DbId = 16, DbName = "Kentucky", HrMaxxName = "KY")]
		Kentucky = 16,
		[HrMaxxSecurity(DbId = 17, DbName = "Louisiana", HrMaxxName = "LA")]
		Louisiana = 17,
		[HrMaxxSecurity(DbId = 18, DbName = "Maine", HrMaxxName = "ME")]
		Maine = 18,
		[HrMaxxSecurity(DbId = 19, DbName = "Maryland", HrMaxxName = "MD")]
		Maryland = 19,
		[HrMaxxSecurity(DbId = 20, DbName = "Massachusetts", HrMaxxName = "MA")]
		Massachusetts = 20,
		[HrMaxxSecurity(DbId = 21, DbName = "Michigan", HrMaxxName = "MI")]
		Michigan = 21,
		[HrMaxxSecurity(DbId = 22, DbName = "Minnesota", HrMaxxName = "MN")]
		Minnesota = 22,
		[HrMaxxSecurity(DbId = 23, DbName = "Mississippi", HrMaxxName = "MS")]
		Mississippi = 23,
		[HrMaxxSecurity(DbId = 24, DbName = "Missouri", HrMaxxName = "MO")]
		Missouri = 24,
		[HrMaxxSecurity(DbId = 25, DbName = "Montana", HrMaxxName = "MT")]
		Montana = 25,
		[HrMaxxSecurity(DbId = 26, DbName = "Nebraska", HrMaxxName = "NE")]
		Nebraska = 26,
		[HrMaxxSecurity(DbId = 27, DbName = "Nevada", HrMaxxName = "NV")]
		Nevada = 27,
		[HrMaxxSecurity(DbId = 28, DbName = "New Hampshire", HrMaxxName = "NH")]
		NewHampshire = 28,
		[HrMaxxSecurity(DbId = 29, DbName = "New Jersey", HrMaxxName = "NJ")]
		NewJersey = 29,
		[HrMaxxSecurity(DbId = 30, DbName = "New Mexico", HrMaxxName = "NM")]
		NewMexico = 30,
		[HrMaxxSecurity(DbId = 31, DbName = "New York", HrMaxxName = "NY")]
		NewYork = 31,
		[HrMaxxSecurity(DbId = 32, DbName = "NorthCarolina", HrMaxxName = "NC")]
		NorthCarolina = 32,
		[HrMaxxSecurity(DbId = 33, DbName = "North Dakota", HrMaxxName = "ND")]
		NorthDakota = 33,
		[HrMaxxSecurity(DbId = 34, DbName = "Ohio", HrMaxxName = "OH")]
		Ohio = 34,
		[HrMaxxSecurity(DbId = 35, DbName = "Oklahoma", HrMaxxName = "OK")]
		Oklahoma = 35,
		[HrMaxxSecurity(DbId = 36, DbName = "Oregon", HrMaxxName = "OR")]
		Oregon = 36,
		[HrMaxxSecurity(DbId = 37, DbName = "Pennsylvania", HrMaxxName = "PA")]
		Pennsylvania = 37,
		[HrMaxxSecurity(DbId = 38, DbName = "Rhode Island", HrMaxxName = "RI")]
		RhodeIsland = 38,
		[HrMaxxSecurity(DbId = 39, DbName = "South Carolina", HrMaxxName = "SC")]
		SouthCarolina = 39,
		[HrMaxxSecurity(DbId = 40, DbName = "South Dakota", HrMaxxName = "SD")]
		SouthDakota = 40,
		[HrMaxxSecurity(DbId = 41, DbName = "Tennessee", HrMaxxName = "TN")]
		Tennessee = 41,
		[HrMaxxSecurity(DbId = 42, DbName = "Texas", HrMaxxName = "TX")]
		Texas = 42,
		[HrMaxxSecurity(DbId = 43, DbName = "Utah", HrMaxxName = "UT")]
		Utah = 43,
		[HrMaxxSecurity(DbId = 44, DbName = "Vermont", HrMaxxName = "VT")]
		Vermont = 44,
		[HrMaxxSecurity(DbId = 45, DbName = "Virginia", HrMaxxName = "VA")]
		Virginia = 45,
		[HrMaxxSecurity(DbId = 46, DbName = "Washington", HrMaxxName = "WA")]
		Washington = 46,
		[HrMaxxSecurity(DbId = 47, DbName = "Washington, DC", HrMaxxName = "DC")]
		WashingtonDC = 47,
		[HrMaxxSecurity(DbId = 48, DbName = "West Virginia", HrMaxxName = "WV")]
		WestVirginia = 48,
		[HrMaxxSecurity(DbId = 49, DbName = "Wisconsin", HrMaxxName = "WI")]
		Wisconsin = 49,
		[HrMaxxSecurity(DbId = 50, DbName = "Wyoming", HrMaxxName = "WY")]
		Wyoming = 50,
		[HrMaxxSecurity(DbId = 51, DbName = "Alabama", HrMaxxName = "AL")]
		Alabama = 51,
	}
	public enum USStates
	{
		[HrMaxxSecurity(DbId = 1, DbName = "California", HrMaxxName = "CA")]
		California=1,
		[HrMaxxSecurity(DbId = 2, DbName = "Alaska", HrMaxxName = "AK")]
		Alaska = 2,
		[HrMaxxSecurity(DbId = 3, DbName = "Arizona", HrMaxxName = "AZ")]
		Arizona = 3,
		[HrMaxxSecurity(DbId = 4, DbName = "Arkansas", HrMaxxName = "AR")]
		Arkansas = 4,
		[HrMaxxSecurity(DbId = 5, DbName = "Colorado", HrMaxxName = "CO")]
		Colorado = 5,
		[HrMaxxSecurity(DbId = 6, DbName = "Connecticut", HrMaxxName = "CT")]
		Connecticut = 6,
		[HrMaxxSecurity(DbId = 7, DbName = "Delaware", HrMaxxName = "DE")]
		Delaware = 7,
		[HrMaxxSecurity(DbId = 8, DbName = "Florida", HrMaxxName = "FL")]
		Florida = 8,
		[HrMaxxSecurity(DbId = 9, DbName = "Georgia", HrMaxxName = "GA")]
		Georgia = 9,
		[HrMaxxSecurity(DbId = 10, DbName = "Hawaii", HrMaxxName = "HI")]
		Hawaii = 10,
		[HrMaxxSecurity(DbId = 11, DbName = "Idaho", HrMaxxName = "ID")]
		Idaho = 11,
		[HrMaxxSecurity(DbId = 12, DbName = "Illinois", HrMaxxName = "IL")]
		Illinois = 12,
		[HrMaxxSecurity(DbId = 13, DbName = "Indiana", HrMaxxName = "IN")]
		Indiana = 13,
		[HrMaxxSecurity(DbId = 14, DbName = "Iowa", HrMaxxName = "IA")]
		Iowa = 14,
		[HrMaxxSecurity(DbId = 15, DbName = "Kansas", HrMaxxName = "KS")]
		Kansas = 15,
		[HrMaxxSecurity(DbId = 16, DbName = "Kentucky", HrMaxxName = "KY")]
		Kentucky = 16,
		[HrMaxxSecurity(DbId = 17, DbName = "Louisiana", HrMaxxName = "LA")]
		Louisiana = 17,
		[HrMaxxSecurity(DbId = 18, DbName = "Maine", HrMaxxName = "ME")]
		Maine = 18,
		[HrMaxxSecurity(DbId = 19, DbName = "Maryland", HrMaxxName = "MD")]
		Maryland = 19,
		[HrMaxxSecurity(DbId = 20, DbName = "Massachusetts", HrMaxxName = "MA")]
		Massachusetts = 20,
		[HrMaxxSecurity(DbId = 21, DbName = "Michigan", HrMaxxName = "MI")]
		Michigan = 21,
		[HrMaxxSecurity(DbId = 22, DbName = "Minnesota", HrMaxxName = "MN")]
		Minnesota = 22,
		[HrMaxxSecurity(DbId = 23, DbName = "Mississippi", HrMaxxName = "MS")]
		Mississippi = 23,
		[HrMaxxSecurity(DbId = 24, DbName = "Missouri", HrMaxxName = "MO")]
		Missouri = 24,
		[HrMaxxSecurity(DbId = 25, DbName = "Montana", HrMaxxName = "MT")]
		Montana = 25,
		[HrMaxxSecurity(DbId = 26, DbName = "Nebraska", HrMaxxName = "NE")]
		Nebraska = 26,
		[HrMaxxSecurity(DbId = 27, DbName = "Nevada", HrMaxxName = "NV")]
		Nevada = 27,
		[HrMaxxSecurity(DbId = 28, DbName = "New Hampshire", HrMaxxName = "NH")]
		NewHampshire = 28,
		[HrMaxxSecurity(DbId = 29, DbName = "New Jersey", HrMaxxName = "NJ")]
		NewJersey = 29,
		[HrMaxxSecurity(DbId = 30, DbName = "New Mexico", HrMaxxName = "NM")]
		NewMexico = 30,
		[HrMaxxSecurity(DbId = 31, DbName = "New York", HrMaxxName = "NY")]
		NewYork = 31,
		[HrMaxxSecurity(DbId = 32, DbName = "NorthCarolina", HrMaxxName = "NC")]
		NorthCarolina = 32,
		[HrMaxxSecurity(DbId = 33, DbName = "North Dakota", HrMaxxName = "ND")]
		NorthDakota = 33,
		[HrMaxxSecurity(DbId = 34, DbName = "Ohio", HrMaxxName = "OH")]
		Ohio = 34,
		[HrMaxxSecurity(DbId = 35, DbName = "Oklahoma", HrMaxxName = "OK")]
		Oklahoma = 35,
		[HrMaxxSecurity(DbId = 36, DbName = "Oregon", HrMaxxName = "OR")]
		Oregon = 36,
		[HrMaxxSecurity(DbId = 37, DbName = "Pennsylvania", HrMaxxName = "PA")]
		Pennsylvania = 37,
		[HrMaxxSecurity(DbId = 38, DbName = "Rhode Island", HrMaxxName = "RI")]
		RhodeIsland = 38,
		[HrMaxxSecurity(DbId = 39, DbName = "South Carolina", HrMaxxName = "SC")]
		SouthCarolina = 39,
		[HrMaxxSecurity(DbId = 40, DbName = "South Dakota", HrMaxxName = "SD")]
		SouthDakota = 40,
		[HrMaxxSecurity(DbId = 41, DbName = "Tennessee", HrMaxxName = "TN")]
		Tennessee = 41,
		[HrMaxxSecurity(DbId = 42, DbName = "Texas", HrMaxxName = "TX")]
		Texas = 42,
		[HrMaxxSecurity(DbId = 43, DbName = "Utah", HrMaxxName = "UT")]
		Utah = 43,
		[HrMaxxSecurity(DbId = 44, DbName = "Vermont", HrMaxxName = "VT")]
		Vermont = 44,
		[HrMaxxSecurity(DbId = 45, DbName = "Virginia", HrMaxxName = "VA")]
		Virginia = 45,
		[HrMaxxSecurity(DbId = 46, DbName = "Washington", HrMaxxName = "WA")]
		Washington = 46,
		[HrMaxxSecurity(DbId = 47, DbName = "Washington, DC", HrMaxxName = "DC")]
		WashingtonDC = 47,
		[HrMaxxSecurity(DbId = 48, DbName = "West Virginia", HrMaxxName = "WV")]
		WestVirginia = 48,
		[HrMaxxSecurity(DbId = 49, DbName = "Wisconsin", HrMaxxName = "WI")]
		Wisconsin = 49,
		[HrMaxxSecurity(DbId = 50, DbName = "Wyoming", HrMaxxName = "WY")]
		Wyoming = 50,
		[HrMaxxSecurity(DbId = 51, DbName = "Alabama", HrMaxxName = "AL")]
		Alabama = 51,
	}
}
