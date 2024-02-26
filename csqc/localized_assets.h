
#if 1 // deathmenu
#define LIST_DEATHMENU_ASSETS \
	X(SOULTETHER) \
	X(SOULTETHER_ACTIVE) \
	X(SHRINE) \
	X(SHRINE_ACTIVE) \
	X(RESTART) \
	X(RESTART_ACTIVE) \
	X(DEPART) \
	X(DEPART_ACTIVE) 
	
#define X(s) s,
enum DEATHMENU_IMG
{
	LIST_DEATHMENU_ASSETS
	MAX
};
#undef X

#define IS_DEATHMENUASSET_STR_LOC(a, i, s) (strcmp(a[i], strcat("UI_DEATHMENU_", s)) != 0)
string deathmenu_assets[DEATHMENU_IMG::MAX];
string deathmenu_assets_string[] = {
	#define X(s) _("UI_DEATHMENU_" #s),
	LIST_DEATHMENU_ASSETS
	#undef X
};
#endif // deathmenu

#if 1 // journal
#define LIST_JOURNAL_ASSETS \
	X(JOURNAL) \
	X(STATS_HUB) \
	X(STATS_LEVEL) \
	X(SHRINE_ACTIVE) \
	X(TABA_ACTIVE) \
	X(TABB_ACTIVE) \
	X(TABC_ACTIVE) \
	X(TABD_ACTIVE) 
	
#define X(s) s,
enum JOURNAL_IMG
{
	LIST_JOURNAL_ASSETS
	MAX
};
#undef X

string journal_assets[JOURNAL_IMG::MAX];
#endif // journal

#if 1 // journal pages
#define LIST_JOURNAL_PAGE_ASSETS \
	X(INTRO) \
	X(HUB1) \
	X(HUB2) \
	X(HUB3) \
	X(BOSS1) \
	X(BOSS2) \
	X(BOSS3) \
	X(E1M1) \
	X(E1M2) \
	X(E1M3) \
	X(E1M4) \
	X(E1M5) \
	X(E2M1) \
	X(E2M2) \
	X(E2M3) \
	X(E2M4) \
	X(E2M5) \
	X(E3M1) \
	X(E3M2) \
	X(E3M3) \
	X(E3M4) \
	X(E3M5) 
	
enum JOURNAL_PAGE_IMG
{
	#define X(s) s,
	LIST_JOURNAL_PAGE_ASSETS
	#undef X
	RELIC_START,
	#define X(s) s##_RELIC,
	LIST_JOURNAL_PAGE_ASSETS
	#undef X
	MAX
};

string journal_page_assets[JOURNAL_PAGE_IMG::MAX];
float journal_page_blank[JOURNAL_PAGE_IMG::MAX];
#endif // journal pages

#if 1 // journal labels
#define LIST_JOURNAL_LABEL_ASSETS \
	X(AFFLICTED) \
	X(BOSS1) \
	X(BOSS2) \
	X(BOSS3) \
	X(BRUTE) \
	X(CANNON) \
	X(COACHGUN) \
	X(CRYSTALLIZER) \
	X(E1M1) \
	X(E1M2) \
	X(E1M3) \
	X(E1M4) \
	X(E1M5) \
	X(E2M1) \
	X(E2M2) \
	X(E2M3) \
	X(E2M4) \
	X(E2M5) \
	X(E3M1) \
	X(E3M2) \
	X(E3M3) \
	X(E3M4) \
	X(E3M5) \
	X(EXECUTIONER) \
	X(FALLEN) \
	X(HERETIC) \
	X(HUB1) \
	X(HUB2) \
	X(HUB3) \
	X(INTRO) \
	X(INVADER) \
	X(KEEPER) \
	X(LANCE) \
	X(LURKER) \
	X(MACE) \
	X(MELEE) \
	X(OPPRESSOR) \
	X(PROWLER) \
	X(RETCHER) \
	X(REVOLVER) \
	X(SHOTGUN) \
	X(SPITTER) \
	X(STRICKEN) \
	X(SYMBOL) \
	X(WIDOW) \
	X(WRAITH) \
	X(WRETCH) 
	
#define X(s) s, ##s##_ACTIVE, 
enum JOURNAL_LABEL_IMG
{
	LIST_JOURNAL_LABEL_ASSETS
	MAX
};
#undef X

#define IS_JOURNAL_LABEL_ASSET_STR_LOC(a, i, s) (strcmp(a[i], strcat("UI_JOURNAL_LABEL_", s)) != 0)
string journal_label_assets[JOURNAL_LABEL_IMG::MAX];
string journal_label_assets_string[] = {
	#define X(s) _("UI_JOURNAL_LABEL_" #s), _("UI_JOURNAL_LABEL_" #s "_ACTIVE"),
	LIST_JOURNAL_LABEL_ASSETS
	#undef X
};
#endif // journal labels

