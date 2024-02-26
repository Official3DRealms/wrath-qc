// Reki (February 14 2024):
// save_salvage.qc
// happy (late) valentines day to any modders.
// this system is here to salvage saves which would otherwise
// become broken when map or progs changes happen
//
// the quake save system really should have been
// replaced from the ground up a very long time ago...
// but the hour is late



// if something with the hubs is desperately wrong, bump the version number by 10
#define HUB_BROKEN_THRESHOLD 100
#define HUB_VERSION 0
#define CODE_VERSION 0
#define PROG_SAVE_VERSION	(CODE_VERSION + (HUB_VERSION * HUB_BROKEN_THRESHOLD))

#ifdef SSQC
nosave var float prog_save_version;
nosave var float map_save_version;
.float map_version;
.float prog_version;

enum MAP_TYPE:float {
	NORMAL,
	HUB,
	BOSS,
};

#define LIST_EPISODE1_MAPS \
	X(E1M1, MAP_TYPE::NORMAL) \
	X(E1M2, MAP_TYPE::NORMAL) \
	X(E1M3, MAP_TYPE::NORMAL) \
	X(E1M4, MAP_TYPE::NORMAL) \
	X(E1M5, MAP_TYPE::NORMAL) 

#define LIST_EPISODE2_MAPS \
	X(E2M1, MAP_TYPE::NORMAL) \
	X(E2M2, MAP_TYPE::NORMAL) \
	X(E2M3, MAP_TYPE::NORMAL) \
	X(E2M4, MAP_TYPE::NORMAL) \
	X(E2M5, MAP_TYPE::NORMAL) 

#define LIST_EPISODE3_MAPS \
	X(E3M1, MAP_TYPE::NORMAL) \
	X(E3M2, MAP_TYPE::NORMAL) \
	X(E3M3, MAP_TYPE::NORMAL) \
	X(E3M4, MAP_TYPE::NORMAL) \
	X(E3M5, MAP_TYPE::NORMAL)

#define LIST_OFFICIAL_MAPS \
	X(INTRO, MAP_TYPE::NORMAL) \
	X(HUB1, MAP_TYPE::HUB) \
	X(HUB2, MAP_TYPE::HUB) \
	X(HUB3, MAP_TYPE::HUB) \
	X(BOSS1, MAP_TYPE::BOSS) \
	X(BOSS2, MAP_TYPE::BOSS) \
	X(BOSS3, MAP_TYPE::BOSS) \
	X(OUTRO, MAP_TYPE::NORMAL) \
	LIST_EPISODE1_MAPS \
	LIST_EPISODE2_MAPS \
	LIST_EPISODE3_MAPS

enum OFFICIAL_MAP:float {
	#define X(x, t) x,
	LIST_OFFICIAL_MAPS
	#undef X
	MAX
};

typedef struct {
	string mapname;
	float relic;
	MAP_TYPE map_type;
} officialmap_t;

#define RL_INTRO RL_INTR
#define RL_HUB1 1
#define RL_HUB2 2
#define RL_HUB3 3
#define RL_OUTRO 0

officialmap_t officialmaps[] = {
	#define X(x, t) {#x, RL_##x, t},
	LIST_OFFICIAL_MAPS
	#undef X
};

#define stricmp(s1, s2) strcmp(strtolower(s1), strtolower(s2))

void() null;
void DecodeLevelParms(void);
void Check_SaveCompatibility(void)
{
	dprint(sprintf("^3%s: (%.0f vs %.0f) (%.0f vs %.0f)\n", __func__, world.prog_version, prog_save_version, world.map_version, map_save_version));

	self = single_player;
	if (world.prog_version != prog_save_version || world.map_version != map_save_version) // our save is incompatible :(
	{
		float map_index = -1;
		for(float i = 0; i < OFFICIAL_MAP::MAX; i++)
		{
			if (stricmp(officialmaps[i].mapname, mapname))
				continue;
			map_index = i;
			break;
		}

		if (map_index >= 0) // official map!
		{
			officialmap_t map = officialmaps[map_index];

			if (map.map_type == MAP_TYPE::HUB) // hubs are pretty safe...
			{
				if (fabs(map_save_version - world.map_version) < HUB_BROKEN_THRESHOLD && fabs(prog_save_version - world.prog_version) < HUB_BROKEN_THRESHOLD)
				{
					// we can let this one go...
					return;
				}
				else
				{
					// sadly, we need to just give the player back any relics and call it a day
					float have_relics = self.foundedrelics;

					// restore any relics we had found from this episode
					self.relics = 0;
					self.s_relics = 0;
					#define X(x, t) RL_##x,
					if (map.relic == 1)
						float e_relics[] = {LIST_EPISODE1_MAPS};
					else if (map.relic == 2)
						float e_relics[] = {LIST_EPISODE2_MAPS};
					else
						float e_relics[] = {LIST_EPISODE3_MAPS};
					#undef X

					// don't mind the blatant QuakeC quirky scope abuse here... yikes
					//dprint(sprintf("^3ADDING RELICS... %x\n", have_relics));
					for(float i = 0; i < 5; i++)
					{
						//dprint(sprintf("^3RELIC %.0f: %x\n", i, e_relics[i]));
						if (have_relics & e_relics[i]) {
							//dprint("adding!\n");
							relic_addtoslot(self, e_relics[i]);
						}
					}

					self.foundedrelics = have_relics;
					//

					dprint(sprintf("^3%s: self.relics = %.0f\n", __func__, self.relics));
					goto resetmap_keepitems;
				}
			}
			else if (map.map_type == MAP_TYPE::BOSS)
			{
				// this one always needs a reset sadly...
				setspawnparms(self);
				DecodeLevelParms();
				goto resetmap;
			}
			else
			{
				// hope to GOD our parms haven't been fucked with erroneously.
				// this SHOULD get us back to the state the last time we entered this level...
				// except now all the enemies have respawned and most people will be very confused
				// :\ sad but no way around it really
				DecodeLevelParms();
				goto resetmap_keepitems;
			}
		}
		
		setspawnparms(self);
		DecodeLevelParms();
		goto resetmap;

		resetmap_keepitems:
		// try to undo the coffer count...
		entity lst = world;
		while(lst = find(lst, classname, "coffer"))
		{
			if (lst.use != null)
				continue;
			self.opened_coffers--;
		}
		lst = world;
		while(lst = find(lst, classname, "coffer_open")) // why....
		{
			if (lst.use != null)
				continue;
			self.opened_coffers--;
		}
		//

		resetmap:
		// change to 'reset' the map
		changelevel(mapname);
		//
	}
}

#endif
