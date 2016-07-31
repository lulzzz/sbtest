using System.ComponentModel;

namespace HrMaxx.Common.Models.Enum
{
	public enum NotificationTypeEnum
	{
		[Description("Build Quality Submitted")] BuildQualitySubmitted = 1,
		[Description("Build Quality Approved")] BuildQualityApproved = 2,
		[Description("Build Quality Rejected")] BuildQualityRejected = 3,
		[Description("Photo Checklist Submitted")] PhotoChecklistSubmitted = 4,
		[Description("Photo Checklist Approved")] PhotoChecklistApproved = 5,
		[Description("Photo Checklist Rejected")] PhotoChecklistRejected = 6,
		[Description("Info")] Info = 7,
		[Description("Error")] Error = 8,
		[Description("Warning")] Warning = 9,
		[Description("Action Assigned")] ActionAssigned = 10,
		[Description("Created")]
		Created = 11,
		[Description("Updated")]
		Updated = 12
	}
}