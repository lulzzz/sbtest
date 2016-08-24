using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Repository.Taxation
{
	public interface ITaxationRepository
	{
		USTaxTables FillTaxTables();
	}
}
