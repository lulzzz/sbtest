using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Repository.Taxation
{
	public interface ITaxationRepository
	{
		USTaxTables FillTaxTables();
		USTaxTables FillTaxTablesByContext();
		void SaveTaxTables(int year, USTaxTables taxTables, USTaxTables tables);
		void CreateTaxes(int year);
	}
}
