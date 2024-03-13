// Reki (May 8 2023):
// achievements.h
// header file for types/structs for interacting with the steam achievements
#pragma once

#define STEAM_IS_CONNECTED (cvar_string("steam_id") != "")

#if !defined(SSQC)
// Reki (May 22 2023): Our own achievement handler to be equivalent to steam
void Achievement_DRMFreeUnlock(string achievement_name);
void Achievement_DRMFreeQueryValue(string achievement_name);
void Stats_DRMFreeQueryValue(string stat_name);
void Stats_DRMFreeIncrement(string stat_name, float value);
void Stats_DRMFreeSet(string stat_name, float value);
//

void StatCallback_blade_lunge_kills(string name, float val);
void StatCallback_confounding_kills(string name, float val);
void StatCallback_animus_kills(string name, float val);
void StatCallback_heads_kicked(string name, float val);
void StatCallback_saved_tethers(string name, float val);
void StatCallback_saved_shrines(string name, float val);
void StatCallback_siphon_health(string name, float val);
void StatCallback_projectiles_deflected(string name, float val);
void StatCallback_souls_harvested(string name, float val);
#endif

typedef struct
{
	float index;
	string name;
	float type;
	float value;
	float initialized;
	void(string name, float val) callback;
} steamstat_t;

typedef struct
{
	float index;
	string name;
	float value;
	float initialized;
	void(string name, float val) callback;

	string display_name;
	string display_desc;
} steamachievement_t;

#define ACHIEVEMENT_LIST \
	/* ================= story progression =================*/ \
	_ACH_ID(SP_STORY_INTRO, __NULL__) \
	_ACH_ID(SP_STORY_HUB1, __NULL__) \
	_ACH_ID(SP_STORY_BOSS1, __NULL__) \
	_ACH_ID(SP_STORY_HUB2, __NULL__) \
	_ACH_ID(SP_STORY_ORRERY, __NULL__) \
	_ACH_ID(SP_STORY_BOSS2, __NULL__) \
	_ACH_ID(SP_STORY_HUB3, __NULL__) \
	_ACH_ID(SP_STORY_CHAIN, __NULL__) \
	_ACH_ID(SP_STORY_BOSS3, __NULL__) \
	/* ================= secret achievements =================*/ \
	_ACH_ID(SP_SECRET_LIFT, __NULL__) \
	_ACH_ID(SP_SECRET_INTRO, __NULL__) \
	_ACH_ID(SP_SECRET_E1M2, __NULL__) \
	_ACH_ID(SP_SECRET_E2M1, __NULL__) \
	_ACH_ID(SP_SECRET_E3M3, __NULL__) \
	_ACH_ID(SP_SECRET_E3M4, __NULL__) \
	/* ================= feats =================*/ \
	_ACH_ID(SP_FEAT_SECRETS_LEVEL, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_SECRETS_E1, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_SECRETS_E2, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_SECRETS_E3, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_SECRETS_ALL, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_COFFER_26, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_COFFER_ALL, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_EASY, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_OUTLANDER, __NULL__) /* done 7/24 */ \
	_ACH_ID(SP_FEAT_BOSS1, __NULL__) \
	_ACH_ID(SP_FEAT_BOSS2, __NULL__) \
	_ACH_ID(SP_FEAT_BOSS3, __NULL__) \
	_ACH_ID(SP_FEAT_1HP, __NULL__) /* done 7/19 */ \
	_ACH_ID(SP_FEAT_CRYSTALSPREAD, __NULL__) /* done 7/30 */ \
	_ACH_ID(SP_FEAT_SCATTER, __NULL__) /* done 7/30 */ \
	_ACH_ID(SP_FEAT_CYST_PLANT, __NULL__) /* done 7/25 */ \
	_ACH_ID(AL_FEAT_ROCKETJUMP, __NULL__) /* done 7/18 */ \
	/* ================= time =================*/ \
	_ACH_ID(AL_TIME_DROWN, __NULL__) /* done 7/17 */ \
	_ACH_ID(AL_TIME_LAVA, __NULL__) /* done 7/17 */ \
	/* ================= joke =================*/ \
	_ACH_ID(SP_JOKE_WRETCH, __NULL__) /* done 7/25 */ \
	_ACH_ID(SP_JOKE_E2M3, __NULL__) \
	_ACH_ID(SP_JOKE_E3M2, __NULL__) /* done 7/24 */ \
	/* ================= grind =================*/ \
	_ACH_ID(SP_GRIND_SOULTETHER, __NULL__) /* done 7/17 */ \
	_ACH_ID(SP_GRIND_LORE_ALL, __NULL__) \
	_ACH_ID(SP_GRIND_KICK, __NULL__) /* done 7/17 */ \
	_ACH_ID(SP_GRIND_BLADE, __NULL__) /* done 7/17 */ \
	_ACH_ID(SP_GRIND_KILLS_5000, __NULL__) /* done 7/17 */ \
	_ACH_ID(SP_GRIND_FLASK, __NULL__) /* done 7/30 */ \
	_ACH_ID(SP_GRIND_ANIMUS, __NULL__) /* done 7/17 */ \
	_ACH_ID(SP_GRIND_ATTAR, __NULL__) /* done 7/17 */ \
	_ACH_ID(SP_GRIND_SHOCKWAVE, __NULL__) /* done 7/30 */ \
	_ACH_ID(SP_GRIND_VOID, __NULL__) /* done 7/30 */ \
	_ACH_ID(SP_GRIND_SIPHON, __NULL__) /* done 7/19 */ \
	_ACH_ID(SP_GRIND_MACE, __NULL__) /* done 7/30 */ \
	_ACH_ID(SP_GRIND_DEFLECTION, __NULL__) /* done 7/30 */

#define _ACH_ID(id, callback) id,
enum ST_ACHIEVEMENTS:float
{
	ACHIEVEMENT_LIST
	MAX
};

#undef _ACH_ID
#define _ACH_ID(id, callback) { id, #id, 0, 0, __NULL__, _("ACHIEVE_NAME_" #id), _("ACHIEVE_DESC_" #id) }, // SSQC doesn't get callbacks... fixme ?
var steamachievement_t steam_achievementlist[] = {
	ACHIEVEMENT_LIST
};

#define STAT_LIST \
	_STAT_ID(monsters_killed, 0, StatCallback_monsters_killed) \
	_STAT_ID(blade_lunge_kills, 0, StatCallback_blade_lunge_kills) \
	_STAT_ID(confounding_kills, 0, StatCallback_confounding_kills) \
	_STAT_ID(animus_kills, 0, StatCallback_animus_kills) \
	_STAT_ID(heads_kicked, 0, StatCallback_heads_kicked) \
	_STAT_ID(saved_tethers, 0, StatCallback_saved_tethers) \
	_STAT_ID(saved_shrines, 0, StatCallback_saved_shrines) /* unused */ \
	_STAT_ID(siphon_health, 0, StatCallback_siphon_health) \
	_STAT_ID(projectiles_deflected, 0, StatCallback_projectiles_deflected) \
	_STAT_ID(souls_harvested, 0, StatCallback_souls_harvested) \
	_STAT_ID(killed_by_fallen, 0, __NULL__) \
	_STAT_ID(killed_by_invader, 0, __NULL__) \
	_STAT_ID(killed_by_wretch, 0, __NULL__) \
	_STAT_ID(killed_by_afflicted, 0, __NULL__) \
	_STAT_ID(killed_by_widow, 0, __NULL__) \
	_STAT_ID(killed_by_wraith, 0, __NULL__) \
	_STAT_ID(killed_by_heretic, 0, __NULL__) \
	_STAT_ID(killed_by_lurker, 0, __NULL__) \
	_STAT_ID(killed_by_oppressor, 0, __NULL__) \
	_STAT_ID(killed_by_executioner, 0, __NULL__) \
	_STAT_ID(killed_by_stricken, 0, __NULL__) \
	_STAT_ID(killed_by_prowler, 0, __NULL__) \
	_STAT_ID(killed_by_symbol, 0, __NULL__) \
	_STAT_ID(killed_by_brute, 0, __NULL__) \
	_STAT_ID(killed_by_keeper, 0, __NULL__) \
	_STAT_ID(killed_by_boss1, 0, __NULL__) \
	_STAT_ID(killed_by_boss2, 0, __NULL__) \
	_STAT_ID(killed_by_boss3, 0, __NULL__) \
	_STAT_ID(killed_by_boss3skull, 0, __NULL__) \
	_STAT_ID(killed_by_drowning, 0, __NULL__) \
	_STAT_ID(killed_by_lava, 0, __NULL__) \
	_STAT_ID(killed_by_crusher, 0, __NULL__) \
	_STAT_ID(killed_by_suicide, 0, __NULL__)
	

#define _STAT_ID(st, type, callback) st,
enum ST_STATS:float
{
	STAT_LIST
	MAX
};

#undef _STAT_ID
#define _STAT_ID(st, type, callback) { st, #st, type, 0, 0, __NULL__ }, // SSQC doesn't get callbacks... fixme ?
var steamstat_t steam_statlist[] = {
	STAT_LIST
};

