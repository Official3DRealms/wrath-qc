// Reki (May 8 2023)
// steam.qc:
// file for interacting with the steam
// builtins in the engine (which go on to poke at the pipe)
// so all of this is very asynchronous, annoyingly.

#include "achievements.h"

#ifdef MENU
float steam_initTime;

float statistics_FileOpTime;
class achievementFileOp_c;
class statsFileOp_c;
achievementFileOp_c achievement_fileOpList;
statsFileOp_c stats_fileOpList;
#define FILEOP_GET		1
#define FILEOP_SET		2

class achievementFileOp_c {
	float type;
	string ach_id;
	float val;

	achievementFileOp_c _next;

	void achievementFileOp_c()
	{
		this.ach_id = strzone(this.ach_id);
		this._next = achievement_fileOpList;
		achievement_fileOpList = this;
	};
};

class statsFileOp_c {
	float type;
	string stat_id;
	float val;

	statsFileOp_c _next;

	void statsFileOp_c()
	{
		this.stat_id = strzone(this.stat_id);
		this._next = stats_fileOpList;
		stats_fileOpList = this;
	};
};

void Menu_Steam_AchievementValue(string achievement_name, float value);
void Menu_Steam_StatValue(string achievement_name, float value)

void Stats_RunFileOperations()
{
	if (stats_fileOpList)
	{ // stats file operations
		float write_needed = FALSE;
		float total = 0;
		strbuf strbuf_nm = buf_create();
		strbuf strbuf_vl = buf_create();
		float f = fopen("statistics/stats", FILE_READ);
		if (f >= 0)
		{
			while(1)
			{
				string fr = fgets(f);
				if (fr == __NULL__)
					break;
				
				if (fr == "")
					continue;

				tokenizebyseparator(fr, "=");
				string fr_nm = argv(0);
				string fr_vl = argv(1);
				
				float j;
				for(j = 0; j < ST_STATS::MAX; j++)
				{
					if (steam_statlist[j].name == fr_nm)
						break;
				}

				if (j == ST_STATS::MAX) // this isn't found
					continue;

				bufstr_set(strbuf_nm, total, fr_nm);
				bufstr_set(strbuf_vl, total, fr_vl);
				total++;
			}
			fclose(f);
		}

		statsFileOp_c fop = stats_fileOpList;
		while (fop)
		{
			statsFileOp_c h = fop;
			
			float i;
			for(i = 0; i < total; i++)
			{
				string nm = bufstr_get(strbuf_nm, i);
				if (nm != fop.stat_id)
					continue;
				if (fop.type == FILEOP_GET)
				{
					float vl = stof(bufstr_get(strbuf_vl, i));
					Menu_Steam_StatValue(nm, vl);
					if (clientstate() == CS_CONNECTED)
						cmd("cl_cmd statvalue ", nm, " ", ftos(vl), "\n");
				}
				else if (fop.type == FILEOP_SET)
				{
					#if 1
					float vl = 0;
					for(float j = 0; j < ST_STATS::MAX; j++)
					{
						if (steam_statlist[j].name != nm)
							continue;
						
						vl = steam_statlist[j].value;
					}

					bufstr_set(strbuf_vl, i, ftos(vl));
					#else
					bufstr_set(strbuf_vl, i, ftos(fop.val));
					#endif
					write_needed = TRUE;
				}
				break;
			}
			
			if (i == total) // we never found it...
			{
				bufstr_add(strbuf_nm, fop.stat_id, 0);
				bufstr_add(strbuf_vl, ftos(fop.val), 0);
				write_needed = TRUE;
				total++;
			}

			fop = fop._next;
			strunzone(h.stat_id);
			remove(h);
		}

		if (write_needed)
		{
			f = fopen("statistics/stats", FILE_WRITE);
			if (f >= 0)
			{
				for(float i = 0; i < total; i++)
				{
					string fr_nm = bufstr_get(strbuf_nm, i);
					string fr_vl = bufstr_get(strbuf_vl, i);
					fputs(f, sprintf("%s=%s\n", fr_nm, fr_vl));
				}
				fclose(f);
			}
		}

		buf_del(strbuf_nm);
		buf_del(strbuf_vl);
		stats_fileOpList = 0;
	}
}

void Achievements_RunFileOperations()
{
	if (achievement_fileOpList)
	{ // achievement file operations
		float write_needed = FALSE;
		float total = 0;
		strbuf strbuf_nm = buf_create();
		strbuf strbuf_vl = buf_create();
		float f = fopen("statistics/achievements", FILE_READ);
		if (f >= 0)
		{
			while(1)
			{
				string fr = fgets(f);
				if (fr == __NULL__)
					break;
				
				if (fr == "")
					continue;

				tokenizebyseparator(fr, "=");
				string fr_nm = argv(0);
				string fr_vl = argv(1);
				
				float j;
				for(j = 0; j < ST_ACHIEVEMENTS::MAX; j++)
				{
					if (steam_achievementlist[j].name == fr_nm)
						break;
				}

				if (j == ST_ACHIEVEMENTS::MAX) // this isn't found
					continue;

				bufstr_set(strbuf_nm, total, fr_nm);
				bufstr_set(strbuf_vl, total, fr_vl);
				total++;
			}
			fclose(f);
		}

		achievementFileOp_c fop = achievement_fileOpList;
		while (fop)
		{
			achievementFileOp_c h = fop;
			
			float i;
			for(i = 0; i < total; i++)
			{
				string nm = bufstr_get(strbuf_nm, i);
				if (nm != fop.ach_id)
					continue;
				if (fop.type == FILEOP_GET)
				{
					float vl = stof(bufstr_get(strbuf_vl, i));
					Menu_Steam_AchievementValue(nm, vl);
					if (clientstate() == CS_CONNECTED)
						cmd("cl_cmd achievementvalue ", nm, " ", ftos(vl), "\n");
				}
				else if (fop.type == FILEOP_SET)
				{
					#if 1
					float vl = 0;
					for(float j = 0; j < ST_ACHIEVEMENTS::MAX; j++)
					{
						if (steam_achievementlist[j].name != nm)
							continue;
						
						vl = steam_achievementlist[j].value;
					}

					bufstr_set(strbuf_vl, i, ftos(vl));
					#else
					bufstr_set(strbuf_vl, i, ftos(fop.val));
					#endif
					write_needed = TRUE;
				}
				break;
			}

			if (i == total) // we never found it...
			{
				bufstr_add(strbuf_nm, fop.ach_id, 0);
				bufstr_add(strbuf_vl, ftos(fop.val), 0);
				write_needed = TRUE;
				total++;
			}

			fop = fop._next;
			strunzone(h.ach_id);
			remove(h);
		}

		if (write_needed)
		{
			f = fopen("statistics/achievements", FILE_WRITE);
			if (f >= 0)
			{
				for(float i = 0; i < total; i++)
				{
					string fr_nm = bufstr_get(strbuf_nm, i);
					string fr_vl = bufstr_get(strbuf_vl, i);
					fputs(f, sprintf("%s=%s\n", fr_nm, fr_vl));
				}
				fclose(f);
			}
		}

		buf_del(strbuf_nm);
		buf_del(strbuf_vl);
		achievement_fileOpList = 0;
	}
}
#endif

// Callbacks
void StatCallback_monsters_killed(string name, float val)
{
	// Reki (May 22 2023): Steam does this automatically, but for DRM-free we need to
	// manually unlock achievements once a milestone is achieved.
	if (val >= 5000)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_KILLS_5000].name);
	}
}

void StatCallback_blade_lunge_kills(string name, float val)
{
	if (val >= 100)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_BLADE].name);
	}
}

void StatCallback_confounding_kills(string name, float val)
{
	if (val >= 10)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_ATTAR].name);
	}
}

void StatCallback_animus_kills(string name, float val)
{
	if (val >= 10)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_ANIMUS].name);
	}
}

void StatCallback_heads_kicked(string name, float val)
{
	if (val >= 100)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_KICK].name);
	}
}

void StatCallback_saved_tethers(string name, float val)
{
	if (val >= 10)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_SOULTETHER].name);
	}
}

void StatCallback_saved_shrines(string name, float val)
{
	/* Reki (July 17 2023): achievement cut
	if (val >= 3)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_SHRINE].name);
	}
	*/
}

void StatCallback_siphon_health(string name, float val)
{
	if (val >= 1000)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_SIPHON].name);
	}
}

void StatCallback_projectiles_deflected(string name, float val)
{
	if (val >= 100)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_DEFLECTION].name);
	}
}

void StatCallback_souls_harvested(string name, float val)
{
	if (val >= 100)
	{
		Achievement_DRMFreeUnlock(steam_achievementlist[SP_GRIND_MACE].name);
	}
}
//

void Steam_InitStats()
{
	#undef _STAT_ID
	#define _STAT_ID(st, type, func) steam_statlist[ST_STATS::st].callback = func;
	STAT_LIST

	for(float i = 0; i < ST_STATS::MAX; i++)
	{
		steamstat_t stat = steam_statlist[i];
		ststat_register(stat.name, stat.type);
		ststat_query(stat.name);

		if (!STEAM_IS_CONNECTED) // drm-free only
		{
			#ifdef MENU
			statsFileOp_c fileop = spawn(statsFileOp_c, type: FILEOP_GET, stat_id: stat.name);
			#else
			Stats_DRMFreeQueryValue(stat.name);
			#endif
		}
	}


	#undef _ACH_ID
	#define _ACH_ID(id, func) steam_achievementlist[ST_ACHIEVEMENTS::id].callback = func;
	ACHIEVEMENT_LIST

	for(float i = 0; i < ST_ACHIEVEMENTS::MAX; i++)
	{
		steamachievement_t ach = steam_achievementlist[i];
		stachievement_register(ach.name);
		stachievement_query(ach.name);

		if (!STEAM_IS_CONNECTED) // drm-free only
		{
			#ifdef MENU
			achievementFileOp_c fileop = spawn(achievementFileOp_c, type: FILEOP_GET, ach_id: ach.name);
			#else
			Achievement_DRMFreeQueryValue(ach.name);
			#endif
		}
	}
}

#ifdef CSQC
void CSQC_Steam_StatValue(string stat_name, float value)
#else
void Menu_Steam_StatValue(string stat_name, float value)
#endif
{
	for(float i = 0; i < ST_STATS::MAX; i++)
	{
		steamstat_t stat = steam_statlist[i];
		if (stat_name != stat.name)
			continue;
		
		if (stat.callback && stat.initialized)
		{
			steam_statlist[i].value = value;
			if (stat.value != value)
				stat.callback(stat_name, value);
		}
		
		steam_statlist[i].initialized = TRUE;
		steam_statlist[i].value = value;
		return;
	}
}

#ifdef CSQC
void CSQC_Steam_AchievementValue(string achievement_name, float value)
#else
void Overlay_NewAchievement(string id, string name, string desc);
float achievement_notify_time;
void Menu_Steam_AchievementValue(string achievement_name, float value)
#endif
{
	string prog = "???";
	#ifdef CSQC
	prog = "CSPROGS";
	#elif defined(MENU)
	prog = "MENU";
	#endif
	if (cvar("developer") >= 2)
		print(sprintf("^1ACHIEVEMENT (%s): %s = %.0f\n", prog, achievement_name, value));

	for(float i = 0; i < ST_ACHIEVEMENTS::MAX; i++)
	{
		steamachievement_t ach = steam_achievementlist[i];
		if (achievement_name != ach.name)
			continue;

		#ifdef MENU
		if (//!STEAM_IS_CONNECTED &&  // Reki (December 1 2023): Removed because we decided the papyrus looks nice, even with double notifications
			ach.initialized && value && (value != ach.value))
		{
			Overlay_NewAchievement(ach.name, ach.display_name, ach.display_desc);
		}
		#endif

		if (ach.callback && ach.initialized)
		{
			steam_achievementlist[i].value = value;
			if (ach.value != value)
				ach.callback(achievement_name, value);
		}
		
		steam_achievementlist[i].initialized = TRUE;
		steam_achievementlist[i].value = value;
		return;
	}
}

void Achievement_DRMFreeUnlock(string achievement_name)
{
	if (STEAM_IS_CONNECTED)
		return;

	#ifdef CSQC
	cmd("menu_cmd achievementunlock ", achievement_name, "\n");
	#else
	for(float i = 0; i < ST_ACHIEVEMENTS::MAX; i++)
	{
		steamachievement_t ach = steam_achievementlist[i];
		if (achievement_name != ach.name)
			continue;
		
		if (ach.initialized)
		{
			if (ach.value != 1)
			{
				print("Achievement unlocked!\n");
				ach.value = 1;
				achievementFileOp_c fileop = spawn(achievementFileOp_c, type: FILEOP_SET, ach_id: ach.name, val: ach.value);
				Menu_Steam_AchievementValue(achievement_name, ach.value);
				if (clientstate() == CS_CONNECTED)
					cmd("cl_cmd achievementvalue ", achievement_name, " ", ftos(ach.value), "\n");
			}
		}
		return;
	}
	#endif
}

void Achievement_DRMFreeQueryValue(string achievement_name)
{
	#ifdef CSQC
	cmd("menu_cmd achievementvalue ", achievement_name, "\n");
	#else
	achievementFileOp_c fileop = spawn(achievementFileOp_c, type: FILEOP_GET, ach_id: achievement_name);
	#endif
}

void Stats_DRMFreeQueryValue(string stat_name)
{
	#ifdef CSQC
	cmd("menu_cmd statvalue ", stat_name, "\n");
	#else
	statsFileOp_c fileop = spawn(statsFileOp_c, type: FILEOP_GET, stat_id: stat_name);
	#endif
}

void Stats_DRMFreeIncrement(string stat_name, float value)
{
	#ifdef CSQC
	cmd("menu_cmd statincrement ", stat_name, " ", ftos(value), "\n");
	#else
	for(float i = 0; i < ST_STATS::MAX; i++)
	{
		steamstat_t stat = steam_statlist[i];
		if (stat_name != stat.name)
			continue;
		
		if (stat.initialized)
		{
			stat.value += value;
			steam_statlist[i].value = stat.value;
			statsFileOp_c fileop = spawn(statsFileOp_c, type: FILEOP_SET, stat_id: stat.name, val: stat.value);
			Menu_Steam_StatValue(stat_name, stat.value);
			if (clientstate() == CS_CONNECTED)
				cmd("cl_cmd statvalue ", stat_name, " ", ftos(stat.value), "\n");
		}
		return;
	}
	#endif
}

void Stats_DRMFreeSet(string stat_name, float value)
{
	#ifdef CSQC
	cmd("menu_cmd statset ", stat_name, " ", ftos(value), "\n");
	#else
	for(float i = 0; i < ST_STATS::MAX; i++)
	{
		steamstat_t stat = steam_statlist[i];
		if (stat_name != stat.name)
			continue;
		
		if (stat.initialized)
		{
			steam_statlist[i].value = stat.value = value;
			statsFileOp_c fileop = spawn(statsFileOp_c, type: FILEOP_SET, stat_id: stat.name, val: stat.value);
			Menu_Steam_StatValue(stat_name, stat.value);
			if (clientstate() == CS_CONNECTED)
				cmd("cl_cmd statvalue ", stat_name, " ", ftos(stat.value), "\n");
		}
		return;
	}
	#endif
}


