using System;

namespace HrMaxx.Infrastructure.Mapping
{
	public interface IMapper
	{
		TDestination Map<TSource, TDestination>(TSource entity);

		void Map<TSource, TDestination>(TSource sourceEntity, TDestination destinationEntity);

		TDestination Map<TSource, TDestination>(TSource sourceEntity, Type sourceType, Type destinationType)
			where TDestination : class;

		void Map<TSource, TDestination>(TSource sourceEntity, TDestination destinationEntity, Type sourceType,
			Type destinationType);
	}
}