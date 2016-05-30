namespace HrMaxx.Infrastructure.Tracing
{
	public enum PerfTraceType
	{
		ComponentServiceCall,
		BusinessLayerCall,
		ReadRepositoryCall,
		WriteRepositoryCall,
		SendBusMessage
	}
}