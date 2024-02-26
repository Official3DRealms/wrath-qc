#pragma once
uielement_c menu_current;
uielement_c menu_main;
uielement_c menu_main_game;
uielement_c menu_quitconfirm;
uielement_c menu_options;
uielement_c menu_options_controller;
uielement_c menu_options_mouse;
uielement_c menu_options_keybinds;
uielement_c menu_options_graphics;
uielement_c menu_options_resolution;
uielement_c menu_options_audio;
uielement_c menu_options_gameplay;
uielement_c menu_loadprofile;
uielement_c menu_deleteconfirm;
uielement_c menu_createprofile;
uielement_c menu_createprofile_difficulty;
uielement_c menu_achievements;
uielement_c menu_gameoverlay;
uielement_c menu_loading;
float in_game;
float in_loadingscreen;

.float button_index;

void MenuInit_Backdrop(void);
void MenuInit_Main(void);
void MenuInit_Main_Game(void);
void MenuInit_Options(void);
void MenuInit_Options_Controller(void);
void MenuInit_Options_Mouse(void);
void MenuInit_Options_Binds(void);
void MenuInit_Options_Video(void);
void MenuInit_Options_Resolution(void);
void MenuInit_Options_Audio(void);
void MenuInit_Options_Gameplay(void);
void MenuInit_LoadProfile(void);
void MenuInit_DeleteConfirm(void);
void MenuInit_CreateProfile(void);
void MenuInit_CreateProfile_Difficulty(void);
void MenuInit_Achievements(void);
void MenuInit_Overlay(void);
void MenuInit_LoadingScreen(void);


#define LIST_OFFICIAL_MAPS \
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
	X(E3M5) \
	X(OUTRO)

#define LIST_MENU_ASSETS \
	X(OPTIONS)	\
	X(OPTIONS_ACTIVE) \
	X(RESUME) \
	X(RESUME_ACTIVE) \
	X(RETURN) \
	X(RETURN_ACTIVE) \
	X(SWITCH_SLOT) \
	X(SWITCH_SLOT_ACTIVE) \
	X(BEGIN) \
	X(BEGIN_ACTIVE) \
	X(ACHIEVEMENTS) \
	X(ACHIEVEMENTS_ACTIVE) \
	X(DEPART) \
	X(DEPART_ACTIVE) \
	X(LOAD_GAME) \
	X(LOAD_GAME_ACTIVE) \
	X(LOAD_GAME_ACTIVE2) \
	X(DELETE_PROFILE) \
	X(DELETE_PROFILE_ACTIVE) \
	XIMG(LOAD_MENU) \
	XIMG(LOAD_MENU_INTRO) \
	XIMG(LOAD_MENU_HUB1) \
	XIMG(LOAD_MENU_HUB2) \
	XIMG(LOAD_MENU_HUB3) \
	XIMG(LOAD_MENU_BOSS1) \
	XIMG(LOAD_MENU_BOSS2) \
	XIMG(LOAD_MENU_BOSS3) \
	XIMG(LOAD_MENU_E1M1) \
	XIMG(LOAD_MENU_E1M2) \
	XIMG(LOAD_MENU_E1M3) \
	XIMG(LOAD_MENU_E1M4) \
	XIMG(LOAD_MENU_E1M5) \
	XIMG(LOAD_MENU_E2M1) \
	XIMG(LOAD_MENU_E2M2) \
	XIMG(LOAD_MENU_E2M3) \
	XIMG(LOAD_MENU_E2M4) \
	XIMG(LOAD_MENU_E2M5) \
	XIMG(LOAD_MENU_E3M1) \
	XIMG(LOAD_MENU_E3M2) \
	XIMG(LOAD_MENU_E3M3) \
	XIMG(LOAD_MENU_E3M4) \
	XIMG(LOAD_MENU_E3M5)
	
#define X(s) s,
#define XIMG(s) X(s)
enum MENU_IMG
{
	LIST_MENU_ASSETS
	MAX
};
#undef XIMG
#undef X

#define IS_MENUASSET_STR_LOC(a, i, s) (strcmp(a[i], strcat("UI_", s)) != 0)
string menu_assets[MENU_IMG::MAX];
string menu_assets_string[] = {
	#define X(s) _("UI_" #s),
	#define XIMG(s) "UI_" #s,
	LIST_MENU_ASSETS
	#undef X
	#undef XIMG
};

#define XIMG(s) X(s)