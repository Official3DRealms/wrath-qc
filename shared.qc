void(float index, float type, .string) SV_AddStatString = #232;

void(float index, float type, .float) SV_AddStatFloat = #232;

// vector xmacro
#define FORVECTOR			\
		VECSET(0)			\
		VECSET(1)			\
		VECSET(2)

// Entity Sending

.float(entity to, float sendflags) SendEntity;
.float SendFlags ;
.float Version;


.float item_cnt;
.float wrath_debug_screen;
.float enhealth;
.float enframe;
.float timels;
.float msg;
.string msg_icon;
.string msg_text;
.float lf;

.entity vweapon;
.float vweaponstate;
.float crosshairflag;
.float tetherhasmodel;

.float deadmenuflag;
.float wlightning;
.vector ltdest;
.vector lorigin;
.float artifacttime;
.float tethertime;
.float tether_global_time;

.float hubstate;
.float damagescreen;
.float shrine;
.float relics;
.float oldrelics;
.float slot_keys;
.float slot_relics;
.string s_relics;
.string s_keys;
.entity hudsync;
.float spotted_maps;
.float time_hudmessage;
.float stat_time_hudmessage;


.float foundedrelics;


float EF_NOPVSCULL 				= 8192;

float AS_STRING = 1;
float AS_FLOAT_TRUNCATED = 2;
float AS_FLOAT = 8;

float MSG_ENTITY = 5;

enum ENT:float {
	HUDMSG,
	HMMSG,
	HUDMSG2,
	HUDSYNC,
	ORREY,
	EYEBALL,
	BOSS3HALO,
	PLACE_SHEPHERD,
};

enum TEMPENT:float {
	CUSTOMSTART = 100,
	NOTIFICATION,
	NOTIFICATION_CONTROL,
	NOTIFICATION_NOTE,
	ACHIEVEMENT_UNLOCK,
	STAT_INCREMENT,
	STAT_SET,
	CRYSTALLIZER_BEZIER,
	BOSS_BEAM,
	LOCALIZATION_FILES,
	EXPANDING_ORB,
	OUTLANDER_UNLOCK,
	CENTERPRINT,
	CONTROLLER_RUMBLE,
	CONTROLLER_RUMBLETRIGGER,
};

enumflags HUDSYNC {
	RELICS,
	KEYS,
};

#ifdef SSQC
float SendEntity_HudSync(entity to, float sendflags)
{
	if (to != self.owner)
		return FALSE;

	WriteByte(MSG_ENTITY, ENT::HUDSYNC);
	WriteByte(MSG_ENTITY, sendflags);
	if (sendflags & HUDSYNC::RELICS)
		WriteString(MSG_ENTITY, to.s_relics);
	if (sendflags & HUDSYNC::KEYS)
		WriteString(MSG_ENTITY, to.s_keys);
	return TRUE;
}
#endif
#ifdef CSQC
string huds_relics;
string huds_keys;
void EntUpdate_HudSync()
{
	float sendflags = ReadByte();
	if (sendflags & HUDSYNC::RELICS)
	{
		if (huds_relics)
			strunzone(huds_relics);
		huds_relics = strzone(ReadString());
	}
	if (sendflags & HUDSYNC::KEYS)
	{
		if (huds_keys)
			strunzone(huds_keys);
		huds_keys = strzone(ReadString());
	}
}
#endif

// Reki (April 11 2023)
// refactored dynamic lights to use these constants,
// because it was a real copy/paste mess and I didn't want
// to type the same fields 85+ times
// (primarily done to add PFLAGS_LODFADE)
typedef struct lightparams_t
{
	float radius;
	float pflags;
	vector color;
	float lstyle;
};

#define SET_DYNAMIC_LIGHT_PROPERTIES(e, dl) \
	e.light_lev = dl.radius; 				\
	e.pflags = dl.pflags;					\
	e.color = dl.color;						\
	e.style = dl.lstyle;

const lightparams_t dl_hpvial = {
	15,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'3 0 0',
	0
};

const lightparams_t dl_hpbeaker = {
	25,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'3 0 0',
	0
};

const lightparams_t dl_hpchalice = {
	32,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'3 0 0',
	0
};

const lightparams_t dl_readable = {
	32,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'1 1 0.5',
	0
};

const lightparams_t dl_cofferkey = {
	48,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'1 1 1',
	0
};

const lightparams_t dl_redkey = {
	48,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'1 0 0',
	0
};

const lightparams_t dl_bluekey = {
	48,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'0 0.2 1',
	0
};

const lightparams_t dl_yellowkey = {
	48,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'1 1 0',
	0
};

const lightparams_t dl_armor_shard = {
	20,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'0.9 0.9 1',
	0
};

const lightparams_t dl_armor_helm = {
	25,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'0.9 0.9 1',
	0
};

const lightparams_t dl_armor = {
	32,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'0.9 0.9 1',
	0
};

const lightparams_t dl_darkarmor_shard = {
	20,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'0.7 0.7 1',
	0
};

const lightparams_t dl_darkarmor_helm = {
	25,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'0.7 0.7 1',
	0
};

const lightparams_t dl_darkarmor = {
	32,
	PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE,
	'0.7 0.7 1',
	0
};
//

.float ammo_revolver;
.float ammo_bombs;
.float ammo_cannon;
.float ammo_lance;
.float ammo_spitter;
.float ammo_retcher;
.float ammo_spitter;
.float ammo_shotgun;
.float ammo_crystal;
.float ammo_bfg;
.float cam_org_x;
.float cam_org_y;
.float cam_org_z;
.float cam_ang_x;
.float cam_ang_y;
.float cam_ang_z;

// stats!
const float		STAT_VIEWHEIGHT					= 16;
const float STAT_RMENU = 34;
const float STAT_LF = 35;
const float STAT_AMMO_FLAMETHROWER = 36;
const float STAT_AMMO_REVOLVER = 37;
const float STAT_AMMO_CANNON = 38;
const float STAT_AMMO_BOMBS = 39;
const float STAT_AMMO_SHOTGUN = 40;
const float STAT_AMMO_LANCE = 41;
const float STAT_AMMO_CRYSTAL = 42;
const float STAT_AMMO_MACE = 43;





const float STAT_RD_MR = 50; // mark revelation
const float STAT_RD_DA = 51; // drowner apparattus
const float STAT_RD_BE = 52; // bersek
const float STAT_RD_CA = 53; // counfounding Attar
const float STAT_RD_VG = 54; // void grenade
const float STAT_RD_LS = 55; // life siphon
const float STAT_RD_TR = 56; // trinket reflection
const float STAT_RD_AE = 57; // cruel aegis
const float STAT_RD_VI = 58; // vicious idol
const float STAT_RD_RF = 59;// Ring of fire


const float STAT_RD_ST = 60;// soul tether


const float STAT_ARTIFACTTIME = 61;
const float STAT_RADIALACTIVE = 62;
const float STAT_WRATHDEBUGSCREEN = 63;
const float STAT_VWEAPONFRAME = 64;
const float STAT_ENHEALTH = 65;
const float STAT_ENFRAME = 66;
const float STAT_TIMEFLY = 67;
const float STAT_TIMELS = 68;
const float STAT_THWOFG = 69;


const float STAT_JOURNAL = 70;
const float STAT_JOURNAL_MESSAGES = 71;
const float STAT_JOURNAL_MESSAGESM = 72;
const float STAT_JOURNAL_MESSAGESB = 73;

const float STAT_NORMAL_MESSAGES = 74;

const float STAT_VWEAPONSTATE = 75;
const float STAT_LASTWEAPON = 76;
const float STAT_DEADMENU = 77;
const float STAT_DAMAGESCREEN = 78;
const float STAT_CROSSHAIR = 79;


const float STAT_SHRINE = 80;
const float STAT_TETHER = 81;	// fix that, use shrine stat instead


const float STAT_RELICS = 82;	// 
const float STAT_SLOT_KEYS = 83;	// 
const float STAT_SLOT_RELICS = 84;	// 
const float STAT_TIME_HUDMESSAGE = 85;	// 
const float STAT_SPOTTED_MAPS = 87;
const float STAT_USED_RELICS = 88;
const float STAT_FOUND_RELICS = 89;
const float STAT_TETHERTIME = 90;
const float STAT_HUBSTATE = 92;
const float STAT_DARM = 93;
const float STAT_RARM = 94;

const float CAM_ORG_X = 100;
const float CAM_ORG_Y = 101;
const float CAM_ORG_Z = 102;
const float CAM_ANG_X = 103;
const float CAM_ANG_Y = 104;
const float CAM_ANG_Z = 105;

const float STAT_SATURATION = 110;
const float STAT_HEALTHHAZE = 111;
const float STAT_ZOOM = 112;

const float STAT_ENDSCREENSTART = 113;

const float STAT_WRATHACTIVE = 120;

const float TZOID_MONSTER = 0.4;

// items
float IT_REVOLVER = 1;
float IT_SHOTGUN = 2;
float IT_SPITTER = 4;
float IT_RETCHER = 8;
float IT_CANNON = 16;
float IT_MELEE = 32;
float IT_LANCE = 64;
//float IT_EXTRA_WEAPON = 128;
float IT_CRYSTAL = 128;
float IT_VIEWMODEL = 512;
float IT_MACE = 1024;

float IT_CELLS = 2048;
float IT_CANNON2 = 4096;

float IT_COFFERKEY1 = 65536;
float IT_COFFERKEY2 = 8192;
float IT_COFFERKEY3 = 16384;

float IT_ARMOR3 = 32768;
float IT_SUPERHEALTH = 65536;

float IT_KEY1 = 131072;
float IT_KEY2 = 262144;
float IT_KEY3 = 256;


float IT_SUIT = 2097152;
float IT_QUAD = 4194304;


// relics
float RL_E1M1  = 0x000001;
float RL_E1M2  = 0x000002;
float RL_E1M3  = 0x000004;
float RL_E1M4  = 0x000008;
float RL_E1M5  = 0x000010;
float RL_E2M1  = 0x000020;
float RL_E2M2  = 0x000040;
float RL_E2M3  = 0x000080;
float RL_E2M4  = 0x000100;
float RL_E2M5  = 0x000200;
float RL_E3M1  = 0x000400;
float RL_E3M2  = 0x000800;
float RL_E3M3  = 0x001000;
float RL_E3M4  = 0x002000;
float RL_E3M5  = 0x004000;
float RL_INTR  = 0x008000;
float RL_BOSS1 = 0x010000;
float RL_BOSS2 = 0x020000;
float RL_BOSS3 = 0x040000;


float SLOT_ARMOR1 = 1;
float SLOT_ARMOR2 = 2;
float SLOT_ARMOR3 = 4;
float SLOT_ARMOR4 = 8;
float SLOT_ARMOR5 = 16;
float SLOT_ARMOR6 = 32;
float SLOT_ARMOR7 = 64;
float SLOT_ARMOR8 = 128;
float SLOT_ARMOR9 = 256;
float SLOT_ARMOR10 = 512;

#define FULLSEND 0xffffff

float SVC_SETVIEW = 5;
float SVC_SETVIEWANGLES = 10;

.float journal_jmessages;
.float journal_jmessagesb;

float JM_A = 1;
float JM_B = 2;
float JM_C = 4;
float JM_D = 8;
float JM_E = 16;
float JM_F = 32;
float JM_G = 64;
float JM_H = 128;
float JM_I = 256;
float JM_J = 512;
float JM_K = 1024;
float JM_L = 2048;
float JM_M = 4096;
float JM_N = 8192;
float JM_O = 16384;
float JM_P = 32768;
float JM_Q = 65536;
float JM_R = 131072;
float JM_S = 262144;
float JM_T = 524288;	
float JM_U = 1048576;
float JM_V = 2097152;
float JM_W = 4194304;
float JM_X = 8388608;

.float journal_jmessagesm;
/*
1 = fallen
2 = wraith
3 = afflicted
4 = widow
5 = invader
6 = heretic
7 = executioner
8 = stricken
9 = wretch
*/

float JB_A = 1;
float JB_B = 2;
float JB_C = 4;
float JB_D = 8;
float JB_E = 16;
float JB_F = 32;
float JB_G = 64;
float JB_H = 128;
float JB_I = 256;
float JB_J = 512;
float JB_K = 1024;
float JB_L = 2048;
float JB_M = 4096;
float JB_N = 8192;
float JB_O = 16384;
float JB_P = 32768;
float JB_Q = 65536;
float JB_R = 131072;
float JB_S = 262144;
float JB_T = 524288;	
float JB_U = 1048576;
float JB_V = 2097152;
float JB_W = 4194304;
float JB_X = 8388608;


.float func_read_messages;
float FR_A = 1;
float FR_B = 2;
float FR_C = 4;
float FR_D = 8;
float FR_E = 16;
float FR_F = 32;
float FR_G = 64;
float FR_H = 128;
float FR_I = 256;
float FR_J = 512;
float FR_K = 1024;
float FR_L = 2048;
float FR_M = 4096;
float FR_N = 8192;
float FR_O = 16384;
float FR_P = 32768;
float FR_Q = 65536;
float FR_R = 131072;
float FR_S = 262144;
float FR_T = 524288;	
float FR_U = 1048576;
float FR_V = 2097152;
float FR_W = 4194304;
float FR_X = 8388608;


.float func_read_messages2;
float FR2_A = 1;
float FR2_B = 2;
float FR2_C = 4;
float FR2_D = 8;
float FR2_E = 16;
float FR2_F = 32;
float FR2_G = 64;
float FR2_H = 128;
float FR2_I = 256;
float FR2_J = 512;
float FR2_K = 1024;
float FR2_L = 2048;
float FR2_M = 4096;
float FR2_N = 8192;
float FR2_O = 16384;
float FR2_P = 32768;
float FR2_Q = 65536;
float FR2_R = 131072;
float FR2_S = 262144;
float FR2_T = 1048576;
float FR2_U = 2097152;
float FR2_V = 4194304;
float FR2_W = 8388608;


.float perfect_maps;
.float opened_coffers;
.float explored_maps;
float LE_INTRO = 2097152;
float LE_HUB1 = 1048576; // well we need it
float LE_HUB2 = 1;
float LE_HUB3 = 2;
float LE_E1M1 = 4;
float LE_E1M2 = 8;
float LE_E1M3 = 16;
float LE_E1M4 = 32;
float LE_E1M5 = 64;
float LE_E2M1 = 128;
float LE_E2M2 = 256;
float LE_E2M3 = 512;
float LE_E2M4 = 1024;
float LE_E2M5 = 2048;
float LE_E3M1 = 4096;
float LE_E3M2 = 8192;
float LE_E3M3 = 16384;
float LE_E3M4 = 32768;
float LE_E3M5 = 65536;
float LE_BOSS1 = 131072;
float LE_BOSS2 = 262144;
float LE_BOSS3 = 524288;

typedef struct {
	string name;
	float bit;
} regmap_t; // map register

typedef struct {
	float bits;
	float ach;
} perfectep_t; // full episode register

regmap_t rmap_list[] = { // Reki (July 24 2023): registered map list, aka "official" maps
	{"intro", LE_INTRO},
	{"hub1", LE_HUB1},
	{"hub2", LE_HUB2},
	{"hub3", LE_HUB3},
	{"e1m1", LE_E1M1},
	{"e1m2", LE_E1M2},
	{"e1m3", LE_E1M3},
	{"e1m4", LE_E1M4},
	{"e1m5", LE_E1M5},
	{"e2m1", LE_E2M1},
	{"e2m2", LE_E2M2},
	{"e2m3", LE_E2M3},
	{"e2m4", LE_E2M4},
	{"e2m5", LE_E2M5},
	{"e3m1", LE_E3M1},
	{"e3m2", LE_E3M2},
	{"e3m3", LE_E3M3},
	{"e3m4", LE_E3M4},
	{"e3m5", LE_E3M5},
	{"boss1", LE_BOSS1},
	{"boss2", LE_BOSS2},
	{"boss3", LE_BOSS3},
};

const float PERFECT_EPISODE1 = (LE_HUB1 | LE_E1M1 | LE_E1M2 | LE_E1M3 | LE_E1M4 | LE_E1M5); // | LE_BOSS1); sigh... no secrets in boss1
const float PERFECT_EPISODE2 = (LE_HUB2 | LE_E2M1 | LE_E2M2 | LE_E2M3 | LE_E2M4 | LE_E2M5 | LE_BOSS2);
const float PERFECT_EPISODE3 = (LE_HUB3 | LE_E3M1 | LE_E3M2 | LE_E3M3 | LE_E3M4 | LE_E3M5 | LE_BOSS3);

const float PERFECT_LOREA = 0x3FFFFF; // bits 1 through 22
const float PERFECT_LOREB = 0x000000;

.float centerprint_messages;
/*
1 = first artifact
2 = first time to open inventory
4 =  first soul tether
8 =  first use of soul tether
16 =
32 = 
64 =
128 =
256 =
512 =
1024 =
2048 =
4096 =
8192 =
16384 =
32768  =
65536 =
131072 = 
262144 =
1048576 =
2097152 =
4194304 =  
8388608 =
*/
float CENTERPRINT_A = 1;
float CENTERPRINT_B = 2;
float CENTERPRINT_C = 4;
float CENTERPRINT_D = 8;
float CENTERPRINT_E = 16;
float CENTERPRINT_F = 32;
float CENTERPRINT_G = 64;
float CENTERPRINT_H = 128;
float CENTERPRINT_I = 256;
float CENTERPRINT_J = 512;
float CENTERPRINT_K = 1024;
float CENTERPRINT_L = 2048;
float CENTERPRINT_M = 4096;
float CENTERPRINT_N = 8192;
float CENTERPRINT_O = 16384;
float CENTERPRINT_P = 32768;
float CENTERPRINT_Q = 65536;
float CENTERPRINT_R = 131072;
float CENTERPRINT_S = 262144;
float CENTERPRINT_T = 1048576;
float CENTERPRINT_U = 2097152;
float CENTERPRINT_V = 4194304;
float CENTERPRINT_W = 8388608;

// Hud noficiation message flags
// Reki (April 27 2023)
enumflags HUDMSGFLAG {
	AGGREGATE,
};


float SG_MathModulus(float a, float b)
{
	return (a - (floor(a / b) *b));
}

string SG_GetFormattedTimeStringUnZoned(float tTime)
{
	local float nTime;
	nTime = rint(tTime);
	local string strTime;
	local float nMinutes;
	nMinutes = floor(nTime / 60);
	strTime = ftos(nMinutes);
	strTime = strcat(strTime, ":");
	local float nSeconds;
	nSeconds = SG_MathModulus(nTime, 60);
	if (nSeconds < 10)
		strTime = strcat(strTime, "0", ftos(nSeconds));
	else
		strTime = strcat(strTime, ftos(nSeconds));
	return strTime;
}

string(string strtofix) case_fixed = {
	if (strlen(strtofix) == 1)
		strtofix = strtoupper(strtofix);
	else
	{
		strtofix = strtolower(strtofix);
		string uppercase = substring(strtofix, 0, 1);
		uppercase = strtoupper(uppercase);
		string restoftheword = substring(strtofix, 1, strlen(strtofix));
		strtofix = strcat(uppercase, restoftheword);
	}
	if (cvar_string("prvm_language") == "en")
	{
		if (strtofix == "Shift")
			strtofix = "Left Shift";
		if (strtofix == "Ctrl")
			strtofix = "Left Control";
		if (strtofix == "Mouse1")
			strtofix = "Left Mouse";
		if (strtofix == "Mouse2")
			strtofix = "Right Mouse";
		if (strtofix == "Mouse3")
			strtofix = "Middle Mouse";
		if (strtofix == "Mwheelup")
			strtofix = "Mouse Wheel Up";
		if (strtofix == "Mwheeldown")
			strtofix = "Mouse Wheel Down";
	}
	else
	{
		strtofix = strtoupper(strtofix);
	}
	strtofix = strcat("[", strtofix, "]");
	return strtofix;
}

// Reki (September 24 2023): taken from xonotic 0.84
float boxesoverlap(vector m1, vector m2, vector m3, vector m4)
{
	return m2_x >= m3_x && m1_x <= m4_x && m2_y >= m3_y && m1_y <= m4_y && m2_z >= m3_z && m1_z <= m4_z;
}

float lerp(float x0, float x1, float t)
{
    return x0 + t*(x1-x0);
}

float slerp(float x0, float x1, float t)
{
	t = ((t) * (t) * (t) * ((t) * ((t) * 6 - 15) + 10));
    return x0 + t*(x1-x0);
}

vector(vector a, vector b, float mix) lerpVector =
{
	if (mix <= 0) return a;
	if (mix >= 1) return b;
	return (b * mix + a * ( 1 - mix ) );
}

// binary utils
// Returns position of the only set bit in 'n' 
float powerofTwo(float n) 
{ 
    return n && (!(n & (n - 1))); 
} 

float findPosition(float n) 
{
    if !(powerofTwo(n))
	{
		return 0;
	}
	
	float i = 1;
	float pos = 0;
	
	
    while (!(i & n)) { 
        // shift over to next bit, inserting a 0 in its place
        i = i << 1; 
  
        // increment return value by 1
        pos++; 
    } 
  
    return pos; 
} 

void numfield_addtostring(__inout string numfield, float insert)
{
	float argc = tokenizebyseparator(numfield, "&")-1;
	string numstr = strcat(numfield);
	
	for(float i = 1; i <= argc; i++)
	{
		float val = stof(argv(i));
		if (val == insert)
			return;
	}

	if (numfield)
		strunzone(numfield);
	
	numfield = strzone(strcat(numstr, "&", ftos(floor(insert))));
}

void numfield_deletefromstring(__inout string numfield, float insert) 
{
	float argc = tokenizebyseparator(numfield, "&")-1;
	string numstr;
	
	for(float i = 1; i <= argc; i++)
	{
		float val = stof(argv(i));
		if (val == insert)
			continue;
		numstr = strcat(numstr, "&", ftos(floor(val)));
	}

	if (numfield)
		strunzone(numfield);
	numfield = strzone(numstr);
}

float numfield_fetchindex(string numfield, float index)
{
	tokenizebyseparator(numfield, "&");
	return stof(argv(index+1));
}

#ifdef SSQC
void relic_addtoslot(entity pl, float relic)
{
	numfield_addtostring(pl.s_relics, findPosition(relic) + 1);
	pl.relics |= relic;
	pl.hudsync.SendFlags |= HUDSYNC::RELICS;
}

void relic_removefromslot(entity pl, float relic)
{
	numfield_deletefromstring(pl.s_relics, findPosition(relic) + 1);
	pl.hudsync.SendFlags |= HUDSYNC::RELICS;
}
#endif

#ifdef SSQC
void WriteColor(float msg_type, vector value)
{
	WriteByte(msg_type, value[0] * 127);
	WriteByte(msg_type, value[1] * 127);
	WriteByte(msg_type, value[2] * 127);
}

void WriteVectorB(float msg_type, vector value)
{
	WriteChar(msg_type, value[0] * 64);
	WriteChar(msg_type, value[1] * 64);
	WriteChar(msg_type, value[2] * 64);
}

void WriteVectorA(float msg_type, vector value)
{
	WriteAngle(msg_type, value[0]);
	WriteAngle(msg_type, value[1]);
	WriteAngle(msg_type, value[2]);
}

void WriteVectorL(float msg_type, vector value)
{
	WriteCoord(msg_type, value[0]);
	WriteCoord(msg_type, value[1]);
	WriteCoord(msg_type, value[2]);
}

void WriteVectorS(float msg_type, vector value)
{
	WriteShort(msg_type, value[0]);
	WriteShort(msg_type, value[1]);
	WriteShort(msg_type, value[2]);
}

void WriteByte16(float msg_type, float value)
{
	WriteByte(msg_type, value * 16);
}
#endif
#ifdef CSQC
vector ReadColor()
{
	return [ReadByte() / 127, ReadByte() / 127, ReadByte() / 127];
}

vector ReadVectorB()
{
	return [ReadChar() / 64, ReadChar() / 64, ReadChar() / 64];
}

vector ReadVectorA()
{
	return [ReadAngle(), ReadAngle(), ReadAngle()];
}

vector ReadVectorL()
{
	return [ReadCoord(), ReadCoord(), ReadCoord()];
}

vector ReadVectorS()
{
	return [ReadShort(), ReadShort(), ReadShort()];
}

float ReadByte16()
{
	return ReadByte() / 16;
}
#endif


float crandom()
{ 
	return 2 *(random() - 0.5);
}

float crandom2()
{
	local float r, r2, rtrn;
	r = random() *0.5 + 0.5;
	r2 = random();
	if (r2 > 0.5)
		rtrn = r *-1;
	else
		rtrn = r * 1;
	return rtrn;
}

float crandom3()
{ 
	float r = random();
	if (r > 0.5)
		return 1;
	else
		return -1;
}

float prandom(float seed)
{
	// pseudo random number generator yoinked from GLSL
	
	seed = sin([seed, seed] * '12.9898 78.233') * 43758.5453;
	seed = fabs(seed);
	
	return (seed - floor(seed));
}

float cprandom(float seed)
{
	return (prandom(seed) - 0.5) * 2;
}

float (float x, float y) angle_difference =
{
    local float a;
    a = x - y;
    a = (a + 180) % 360 - 180;
    if (a > 180) a -= 360;
    if (a < -180) a += 360;
    
    return a;
}

#include "achievements.h"
void Steam_AchievementUnlock(entity who, float achievement)
{
	if (achievement < 0 || achievement > ST_ACHIEVEMENTS::MAX)
		error(sprintf("%s: achievement is out of range (0 to ST_ACHIEVEMENTS::MAX)", __func__));
	
	#ifdef SSQC // SSQC sends to clients
	float channel = MSG_ALL;
	if (who && who.flags & FL_CLIENT)
		channel = MSG_ONE;
	msg_entity = who;

	WriteByte(channel, SVC_TEMPENTITY);
	WriteByte(channel, TEMPENT::ACHIEVEMENT_UNLOCK);
	WriteShort(channel, achievement);
	#elif defined(CSQC) // CSQC just talks straight to the pipe (via the engine)
	steamachievement_t ach = steam_achievementlist[achievement];
	stachievement_unlock(ach.name);
	Achievement_DRMFreeUnlock(ach.name);
	#endif
}

void Steam_StatIncrement(entity who, float stat, float value)
{
	if (stat < 0 || stat > ST_STATS::MAX)
		error(sprintf("%s: stat is out of range (0 to ST_STATS::MAX)", __func__));
	
	#ifdef SSQC // SSQC sends to clients
	float channel = MSG_ALL;
	if (who && who.flags & FL_CLIENT)
		channel = MSG_ONE;
	msg_entity = who;

	WriteByte(channel, SVC_TEMPENTITY);
	WriteByte(channel, TEMPENT::STAT_INCREMENT);
	WriteShort(channel, stat);
	WriteLong(channel, value * 100);
	#elif defined(CSQC) // CSQC just talks straight to the pipe (via the engine)
	steamstat_t st = steam_statlist[stat];
	ststat_increment(st.name, value);
	Stats_DRMFreeIncrement(st.name, value);
	#endif
}

void Steam_StatSet(entity who, float stat, float value)
{
	if (stat < 0 || stat > ST_STATS::MAX)
		error(sprintf("%s: stat is out of range (0 to ST_STATS::MAX)", __func__));
	
	#ifdef SSQC // SSQC sends to clients
	float channel = MSG_ALL;
	if (who && who.flags & FL_CLIENT)
		channel = MSG_ONE;
	msg_entity = who;

	WriteByte(channel, SVC_TEMPENTITY);
	WriteByte(channel, TEMPENT::STAT_SET);
	WriteShort(channel, stat);
	WriteLong(channel, value * 100);
	#elif defined(CSQC) // CSQC just talks straight to the pipe (via the engine)
	steamstat_t st = steam_statlist[stat];
	ststat_setvalue(st.name, value);
	Stats_DRMFreeSet(st.name, value);
	#endif
}

void Controller_Rumble(entity who, float low, float high, float duration)
{
	#ifdef SSQC
	float channel = MSG_ALL;
	if (who && who.flags & FL_CLIENT)
		channel = MSG_ONE;
	msg_entity = who;

	WriteByte(channel, SVC_TEMPENTITY);
	WriteByte(channel, TEMPENT::CONTROLLER_RUMBLE);
	WriteShort(channel, low * 2048);
	WriteShort(channel, high * 2048);
	WriteShort(channel, duration);
	#elif defined(CSQC)
	if (!cvar("joy_active")) // we have no active controller right now
		return;

	if (input_mode != IN_MODE_GAMEPAD) // not using controller
		return;

	if (!cvar("joy_x360_rumble"))
		return;

	controller_rumble(cvar("joy_index"), low, high, duration);
	#endif
}

void Controller_RumbleTriggers(entity who, float left, float right, float duration)
{
	#ifdef SSQC
	float channel = MSG_ALL;
	if (who && who.flags & FL_CLIENT)
		channel = MSG_ONE;
	msg_entity = who;

	WriteByte(channel, SVC_TEMPENTITY);
	WriteByte(channel, TEMPENT::CONTROLLER_RUMBLETRIGGER);
	WriteShort(channel, left * 2048);
	WriteShort(channel, right * 2048);
	WriteShort(channel, duration);
	#elif defined(CSQC)
	if (!cvar("joy_active")) // we have no active controller right now
		return;

	if (input_mode != IN_MODE_GAMEPAD) // not using controller
		return;

	if (!cvar("joy_x360_rumble"))
		return;

	controller_rumbletriggers(cvar("joy_index"), left, right, duration);
	#endif
}