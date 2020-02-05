namespace SiteInspectionStatus_Utility
{
	public interface IWriteRepository
	{
		
		void ExecuteQuery(string sql, object unknown);
		
	}
}
