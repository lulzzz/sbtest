using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Repository.Taxation
{
	public interface ITaxationRepository
	{
		USTaxTables FillTaxTables(int year);
		USTaxTables FillTaxTablesByContext();
		void SaveTaxTables(int year, USTaxTables taxTables, USTaxTables tables);
		void CreateTaxes(int year);
		List<int> GetTaxTableYears();
	}
}
