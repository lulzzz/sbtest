using System;
using AutoMapper;

namespace HrMaxx.Infrastructure.Mapping
{
	public class Mapper : IMapper
	{
		private readonly IMappingEngine _engine;

		public Mapper(IMappingEngine engine)
		{
			_engine = engine;
		}

		public TDestination Map<TSource, TDestination>(TSource entity)
		{
			return _engine.Map<TSource, TDestination>(entity);
		}

		public void Map<TSource, TDestination>(TSource sourceEntity, TDestination destinationEntity)
		{
			_engine.Map(sourceEntity, destinationEntity);
		}

		public TDestination Map<TSource, TDestination>(TSource sourceEntity, Type sourceType, Type destinationType)
			where TDestination : class
		{
			return _engine.Map(sourceEntity, sourceType, destinationType) as TDestination;
		}

		public void Map<TSource, TDestination>(TSource sourceEntity, TDestination destinationEntity, Type sourceType,
			Type destinationType)
		{
			_engine.Map(sourceEntity, destinationEntity, sourceType, destinationType);
		}
	}
}