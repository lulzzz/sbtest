﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac;
using HrMaxx.Infrastructure.Mapping;

namespace OPImportUtility
{
	public class MappingModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<OPImportMapperProfile>().As<ProfileLazy>();

		}
	}
}
