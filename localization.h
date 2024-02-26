#pragma once

#ifdef SSQC
void spawnfunc_info_localization(void);
void Localization_ResendFileList(entity to);
#endif

#ifndef SSQC // MenuQC and CSQC
void Localization_LoadFile(string path, string lang);
string Localization_GetText(string name);
string strlocalize(string strbody);
string strlocalize_full(string strbody, float hint_glyphs);
string strcontrols(string strbody, float hint_glyphs);
#ifdef MENU
enum LANGFONT:float {
	CENTERPRINT,
	MAINMENU,
	USER0,
	USER1,
	USER2,
	USER3,
	USER4,
	USER5,
	CREDITS,
	JOURNAL,
	MAX
};

string fontnames[] = {
	"centerprint",
	"menu",
	"user0",
	"user1",
	"user2",
	"user3",
	"user4",
	"user5",
	"user6",
	"user7"
};

string altfontnames[] = {
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"credits",
	"journal"
};

string fontsizes[] = {
	"6 8 12 14 16 24 32 40 64", // centerprint
	"6 8 12 14 16 20 24 32 40 64", // menu
	"6 8 12 14 16 24 32 40 64", // user0
	"6 8 12 14 16 24 32 40 64", // user1
	"6 8 12 14 16 24 32 40 64", // user2
	"6 8 12 14 16 24 32 40 64", // user3
	"6 8 12 14 16 24 32 40 64", // user4
	"6 8 12 14 16 24 32 40 64", // user5
	"6 8 12 14 16 20 24 32 40 64", // credits
	"6 8 12 14 16 24 32 40 64"  // journal
};

float fontscales[] = {
	2, // centerprint
	1.667, // menu
	1, // user0
	1, // user1
	1, // user2
	1, // user3
	1, // user4
	1, // user5
	1, // credits
	1  // journal
};

class langname_c {
	string lang; // lang code
	string title; // title

	langname_c _next;
};
class langfont_c {
	float index;
	string file;

	langfont_c _next;
};
class language_c {
	string lang; // lang code
	string nativename; // name of the language in localized format
	float fontcode; // font index for language selection menu
	langname_c namelist; // list of localized names for this language
	langfont_c fontlist; // list of font replacements for this language

	language_c _next;
};

language_c language_list;
language_c language_current;
.language_c langset;

language_c LanguageDef_Find(string);
string LanguageDef_FindFont(language_c lang, float ind);
string LanguageDef_FindName(language_c, string);
void LanguageDef_LoadFonts(language_c lang);
void LanguageDef_LoadFile(string);
#endif
#endif



