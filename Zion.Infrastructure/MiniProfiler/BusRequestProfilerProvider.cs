using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;
using StackExchange.Profiling;

namespace HrMaxx.Infrastructure.MiniProfiler
{
	public class BusRequestProfilerProvider : BaseProfilerProvider
	{
		private const string CacheKey = ":mini-profiler:";

		/// <summary>
		///   Gets the currently running MiniProfiler for the current HttpContext; null if no MiniProfiler was <see cref="Start" />
		///   ed.
		/// </summary>
		private StackExchange.Profiling.MiniProfiler Current
		{
			get
			{
				MemoryCache context = MemoryCache.Default;
				if (context == null) return null;

				return context[CacheKey] as StackExchange.Profiling.MiniProfiler;
			}
			set
			{
				MemoryCache context = MemoryCache.Default;
				if (context == null) return;

				context.Add(CacheKey, value, new CacheItemPolicy());
			}
		}

		#pragma warning disable 1584,1711,1572,1581,1580
#pragma warning restore 1584,1711,1572,1581,1580
		/// <summary>
		///   Starts a new MiniProfiler and associates it with the current <see cref="HttpContext.Current" />.
		/// </summary>
		public override StackExchange.Profiling.MiniProfiler Start(ProfileLevel level, string sessionName = null)
		{
			var result = new StackExchange.Profiling.MiniProfiler("bus", level);
			Current = result;

			SetProfilerActive(result);

			// don't really want to pass in the context to MiniProfler's constructor or access it statically in there, either
			result.User = "Bus";

			return result;
		}

		#pragma warning disable 1584,1711,1572,1581,1580
#pragma warning restore 1584,1711,1572,1581,1580
		/// <summary>
		///   Starts a new MiniProfiler and associates it with the current <see cref="HttpContext.Current" />.
		/// </summary>
		public override StackExchange.Profiling.MiniProfiler Start(string sessionName = null)
		{
			var result = new StackExchange.Profiling.MiniProfiler("bus");
			Current = result;

			SetProfilerActive(result);

			// don't really want to pass in the context to MiniProfler's constructor or access it statically in there, either
			result.User = "Bus";

			return result;
		}

		/// <summary>
		///   Ends the current profiling session, if one exists.
		/// </summary>
		/// <param name="discardResults">
		///   When true, clears the
		///   <see
		///     cref="StackExchange.Profiling.StackExchange.Profiling.MiniProfiler.Current, allowing profiling to 
		/// be prematurely stopped and discarded. Useful for when a specific route does not need to be profiled.
		/// 
		/// </param>
		public override void Stop(bool discardResults)
		{
			StackExchange.Profiling.MiniProfiler current = Current;
			if (current == null)
				return;

			// stop our timings - when this is false, we've already called .Stop before on this session
			if (!StopProfiler(current))
				return;

			if (discardResults)
			{
				Current = null;
				return;
			}

			// set the profiler name to Controller/Action or /url
			EnsureName(current);

			// save the profiler
			SaveProfiler(current);

			try
			{
				List<Guid> arrayOfIds = StackExchange.Profiling.MiniProfiler.Settings.Storage.GetUnviewedIds(current.User);

				if (arrayOfIds != null && arrayOfIds.Count > StackExchange.Profiling.MiniProfiler.Settings.MaxUnviewedProfiles)
				{
					foreach (
						Guid id in arrayOfIds.Take(arrayOfIds.Count - StackExchange.Profiling.MiniProfiler.Settings.MaxUnviewedProfiles))
					{
						StackExchange.Profiling.MiniProfiler.Settings.Storage.SetViewed(current.User, id);
					}
				}
			}
			catch
			{
			} // headers blew up
		}


		/// <summary>
		///   Makes sure 'profiler' has a Name, pulling it from route data or url.
		/// </summary>
		private static void EnsureName(StackExchange.Profiling.MiniProfiler profiler)
		{
			// also set the profiler name to Controller/Action or /url
			profiler.Name = "bus";
		}

		/// <summary>
		///   Returns the current profiler
		/// </summary>
		/// <returns></returns>
		public override StackExchange.Profiling.MiniProfiler GetCurrentProfiler()
		{
			return Current;
		}
	}
}