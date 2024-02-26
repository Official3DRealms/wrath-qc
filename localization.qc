
// Reki (May 31 2023)
// localization_table.qc:
// defines hashtable and functions for
// interacting with dynamically localized
// strings (as opposed to static localization
// at load time done by the engine)

#include "localization.h"

// only for SSQC
#ifdef SSQC
void spawnfunc_info_localization(void)
{
	self.classname = "info_localization";
	
	if (!self.message)
	{
		remove(self);
		return;
	}
}

void Localization_ResendFileList(entity to)
{
	msg_entity = to;
	WriteByte(MSG_ONE, SVC_TEMPENTITY);
	WriteByte(MSG_ONE, TEMPENT::LOCALIZATION_FILES);
	for(entity list = findchain(classname, "info_localization"); list; list = list.chain)
	{
		WriteString(MSG_ONE, list.message);
	}
	WriteString(MSG_ONE, "eof");
}
#endif

// only for CSQC and MenuQC
#ifndef SSQC
class loc_entry_c;
class loc_entry_c
{
	string loc_name;
	string loc_text;
	loc_entry_c _next;
};

loc_entry_c loc_hashtable[50];

float Localization_GetHash(string name)
{
	float hashval = 0;
	float nmlength = strlen(name);
	for(float i = 0; i < nmlength; i++)
	{
		float cha = str2chr(name, i);
		cha = bound(0, cha - 64, 31);

		hashval = ((hashval << 5) + cha) % 50;
	}

	return hashval;
}

void Localization_AddToTable(string name, string text)
{
	name = strtoupper(name); // convert to upper because we don't want case sensitivity
	float hash = Localization_GetHash(name);

	for(loc_entry_c list = loc_hashtable[hash]; list; list = list._next)
	{
		if (strcmp(list.loc_name, name))
			continue;

		return; // if we found a duplicate, we don't need to add it to the table
	}

	loc_entry_c new = spawn(loc_entry_c);
	new.loc_name = strzone(name);
	new.loc_text = strzone(text);
	new._next = loc_hashtable[hash];
	loc_hashtable[hash] = new;
}

string Localization_GetText(string name)
{
	name = strtoupper(name); // convert to upper because we don't want case sensitivity
	float hash = Localization_GetHash(name);

	for(loc_entry_c list = loc_hashtable[hash]; list; list = list._next)
	{
		if (strcmp(list.loc_name, name))
			continue;
		
		return list.loc_text; 
	}
	return name;
}

void Localization_LoadFile(string path, string lang)
{
	path = strcat(path, ".", lang, ".po");

	float f = fopen(path, FILE_READ);
	if (f < 0)
		return;
	
	dprint(__func__, ": opened localization file \"", path, "\"\n");

	string loc_currenttag;

	string txt = fgets(f);
	while(1)
	{
		tokenize(txt);
		string firstsix = argv(0);
		string body = argv(1);

		if (firstsix == "msgid") // set loc tag
		{
			loc_currenttag = body;
		}
		else if (firstsix == "msgstr")
		{
			if (loc_currenttag)
			{
				Localization_AddToTable(loc_currenttag, body);
			}
		}

		txt = fgets(f);

		if (txt == __NULL__) // Reki: this is a shitty hack, because for some reason DP has no way to detect EOF
		{
			float i;
			for(i = 0; i < 20; i++)
			{
				txt = fgets(f);
				if (txt)
					break;
			}
			if (i == 20)
				break;
		}
	}

	fclose(f);
}

string Localization_FindFile(string path, float primaryonly = FALSE)
{
	string langpath = cvar_string("prvm_language");
	string fallbackpath = cvar_string("prvm_language_fallback");
	if (!langpath)
		langpath = "null";
	if (!fallbackpath)
		fallbackpath = "null";

	langpath = sprintf(path, langpath);
	fallbackpath = sprintf(path, fallbackpath);

	if (fexists_pak(langpath))
		return langpath;
	else if (fexists_pak(fallbackpath) && !primaryonly)
		return fallbackpath;
	return path; // Reki FIXME: this should probably return something else, but I'm afraid of bad path errors so I'm leaving it
}

string strcontrols(string strbody, float hint_glyphs)
{
	string final = "";
	while (strbody)
	{
		float ofs_tag = strstrofs(strbody, "@", 0);
		if (ofs_tag < 0) // we don't have any more tags
		{
			final = strcat(final, strbody);
			break;
		}
		else // we have a tag
		{
			// add preceding text
			final = strcat(final, substring(strbody, 0, ofs_tag));
			strbody = substring(strbody, ofs_tag + 1, strlen(strbody) - (ofs_tag - 1));

			float ofs_openbracket = strstrofs(strbody, "{", 0);
			float ofs_closebracket = strstrofs(strbody, "}", 0);

			if (ofs_openbracket < 0 || ofs_closebracket < 0) // syntax error
			{
				final = strcat(final, "SYNTAX ERROR");
				return final;
			}

			string cmd = substring(strbody, ofs_openbracket + 1, (ofs_closebracket - ofs_openbracket - 1));
			float argc = tokenize(findkeysforcommand(cmd, 0));
			float keynum = -1;
			for(float j = 0; j < argc; j++)
			{
				keynum = stof(argv(j));
				float type = bind_gettype(keynum);
				if (IS_KBM_KEY(type) && (input_mode == IN_MODE_KEYBOARD || input_mode == IN_MODE_MOUSE))
					break;
				else if (type == INPUT_TYPE::XBOX && input_mode == IN_MODE_GAMEPAD)
					break;
				else if (type == INPUT_TYPE::JOYSTICK && input_mode == IN_MODE_JOYSTICK)
					break;
			}

			string s_key;
			if (keynum != -1)
			{
				if (bind_gettype(keynum) == INPUT_TYPE::XBOX && hint_glyphs)
				{
					s_key = sprintf("{GLYPH_%.0f}", keynum);
				}
				else
				{
					#ifdef CSQC
					s_key = case_fixed(keynumtostring(keynum));
					#else
					s_key = keynumtostring(keynum);
					#endif
				}
			}
			else
				s_key = "[UNBOUND]";

			final = strcat(final, s_key);
			strbody = substring(strbody, ofs_closebracket + 1, strlen(strbody) - (ofs_closebracket + 1));
		}
	}

	return final;
}

string strlocalize_full(string strbody, float hint_glyphs)
{
	string final = "";
	while (strbody)
	{
		float ofs_tag = strstrofs(strbody, "$", 0);
		if (ofs_tag < 0) // we don't have any more tags
		{
			final = strcat(final, strbody);
			break;
		}
		else // we have a tag
		{
			// add preceding text
			final = strcat(final, substring(strbody, 0, ofs_tag));
			strbody = substring(strbody, ofs_tag + 1, strlen(strbody) - (ofs_tag - 1));

			float ofs_space = strstrofs(strbody, ":", 0);
			if (ofs_space < 0)
				ofs_space = strstrofs(strbody, " ", 0);
			if (ofs_space < 0)
				ofs_space = strstrofs(strbody, "\n", 0);

			if (ofs_space < 0) // our localization is the entire rest of the string
			{
				final = strcat(final, Localization_GetText(strbody));
				break;
			}
			
			final = strcat(final, Localization_GetText(substring(strbody, 0, ofs_space)));
			strbody = substring(strbody, ofs_space, strlen(strbody) - (ofs_space));
		}
	}

	if (strstrofs(final, "$", 0) >= 0) // we have some nested localizations to parse... why would somebody do this :(
		return strlocalize(final);
	if (strstrofs(final, "@", 0) >= 0) // we have some key prompts to parse
		return strcontrols(final, hint_glyphs);
	return final; // finally done...
}

string strlocalize(string strbody)
{
	return strlocalize_full(strbody, FALSE);
}

#ifdef CSQC
void TempEnt_Localization_Files(void)
{
	for(string line = ReadString(); line != "eof"; line = ReadString())
	{
		if (cvar_string("prvm_language"))
			Localization_LoadFile(line, cvar_string("prvm_language"));
		if (cvar_string("prvm_language_fallback"))
			Localization_LoadFile(line, cvar_string("prvm_language_fallback"));
	}
}
#endif
#ifdef MENU
float LanguageDef_CodeToHash(string lcode)
{
	float val;
	val += bound(0, str2chr(strtoupper(lcode), 0) - 65, 24) * 24;
	val += bound(0, str2chr(strtoupper(lcode), 1) - 65, 24);

	return val;
}

language_c LanguageDef_Find(string lcode)
{
	for(language_c lst = language_list; lst; lst = lst._next)
	{
		if (lst.lang == lcode)
			return lst;
	}

	return 0;
}

string LanguageDef_FindName(language_c lang, string lcode)
{
	for(langname_c lst = lang.namelist; lst; lst = lst._next)
	{
		if (lst.lang != lcode)
			continue;
		
		return (lst.title);
	}

	return __NULL__;
}

string LanguageDef_FindFont(language_c lang, float ind)
{
	for(langfont_c lst = lang.fontlist; lst; lst = lst._next)
	{
		if (lst.index != ind)
			continue;
		
		return (lst.file);
	}

	return __NULL__;
}

void LanguageDef_LoadFonts(language_c langdef)
{
	dprint("^3", __func__, ": ", langdef.lang, "\n");
	float fontslots[] = {
		FONT_CENTERPRINT,
		FONT_MENU,
		FONT_USER0,
		FONT_USER1,
		FONT_USER2,
		FONT_USER3,
		FONT_USER4,
		FONT_USER5,
		FONT_USER6,
		FONT_USER7,
	};
	float fontwritten[fontslots.length];
	for(float i = 0; i < fontwritten.length; i++)
		fontwritten[i] = FALSE;

	for(langfont_c lst = langdef.fontlist; lst; lst = lst._next)
	{
		float slot = lst.index;
		//if (slot < 0 || slot >= fontslots.length); // er... wat
		//	continue;

		loadfont("", lst.file, fontsizes[slot], fontslots[slot], fontscales[slot], 0);
		print(sprintf("loading font %s in slot %.0f\n", lst.file, fontslots[slot]));

		fontwritten[slot] = TRUE;
	}

	for(float i = 0; i < LANGFONT::MAX; i++) // reinit with conchars
	{
		if (fontwritten[i])
			continue;
		
		loadfont("", "gfx/conchars", fontsizes[i], fontslots[i], 1, 0);
	}
}

void LanguageDef_LoadFile(string lcode)
{
	string path = sprintf("localization/%s.lang", lcode);

	float f = fopen(path, FILE_READ);
	if (f < 0) // doh
		return;
	
	if (LanguageDef_Find(lcode)) // doh! we already have this language defined somehow?
		return;
	
	language_c langdef = spawn(language_c, lang: strzone(lcode), nativename: strzone(" "));
	float sortval = (LanguageDef_CodeToHash(lcode));

	if (language_list) // we need to sort alphabetically
	{
		language_c lst, hold;
		for(lst = language_list, hold = 0; lst; hold = lst, lst = lst._next)
		{
			float sort = (LanguageDef_CodeToHash(lst.lang));
			if (sort <= sortval)
				continue;
			
			if (!hold)
			{
				language_list = langdef;
				langdef._next = lst;
				break;
			}
			
			hold._next = langdef;
			langdef._next = lst;
			break;
		}

		if (!lst) // uh oh, we never got linked in (we're last)
		{
			hold._next = langdef; 
			langdef._next = lst;
		}
	}
	else // just begin the list
	{
		langdef._next = language_list;
		language_list = langdef;
	}

	float k = 16; // only tolerate 16 blank lines in a row, stupid DP not letting us check EOF
	chara s;
	while(TRUE)
	{
		s = str_removeblank(fgets(f));
		if (!s || s == "" || s == __NULL__) // if this line is blank, tell it to FUK'OFF
		{
			k--;
			if (k < 0)
				break;
			continue;
		}
		k = 16; // we found a good line, reset!

		float fsz = 20;
		uielement_c block;
		if (s[0] == "<") // we have a special statement
		{
			float o = strstrofs(s, ">", 0);
			string fullcmd = substring(s, 1, o - 1);
			float argc = tokenizebyseparator(fullcmd, ",");
			string cmd = argv(0);
			s = str_removeblank(substring(s, o + 1, strlen(s))); // remove special case from the string

			switch (cmd)
			{
				case "font":
					string type = argv(1);
					float ind = -1;
					for(float j = 0; j < LANGFONT::MAX; j++)
					{
						if (type == fontnames[j] || (altfontnames[j] != "" && type == altfontnames[j]))
						{
							ind = j;
							break;
						}
					}
					
					if (ind < 0)
					{
						print(sprintf("^1INVALID FONT TYPE %s IN LANG DEFINITION (%s)\n", type, langdef.lang));
						break;
					}

					dprint(sprintf("^3   %s=%s font registered (%s)\n", fontnames[ind], s, langdef.lang));
					langfont_c fnt = spawn(langfont_c, index: ind, file: strzone(s));
					fnt._next = langdef.fontlist;
					langdef.fontlist = fnt;
				break;
				case "name":
					if (argc < 2)
					{
						print(sprintf("^1MISSING NAME IN LANG DEFINITION (%s)\n", langdef.lang));
						break;
					}	
					
					string langcode = argv(1);
					dprint(sprintf("^3   %s=%s name registered (%s)\n", langcode, s, langdef.lang));
					langname_c nm = spawn(langname_c, lang: strzone(langcode), title: strzone(s));
					nm._next = langdef.namelist;
					langdef.namelist = nm;

					if (langcode == langdef.lang) // native name!
					{
						if (langdef.nativename)
							strunzone(langdef.nativename);
						langdef.nativename = strzone(s);
						dprint(sprintf("^3      ^ native name found (%s)\n", langdef.lang));
					}
				break;
			}
		}
	}


	// register menu font (for language selection)
	langdef.fontcode = FONT_MENU;
	string menufontfile = LanguageDef_FindFont(langdef, LANGFONT::MAINMENU);
	if (menufontfile)
	{
		langdef.fontcode = loadfont(langdef.lang, menufontfile, fontsizes[LANGFONT::MAINMENU], -1, fontscales[LANGFONT::MAINMENU], 0);
	}
	else
	{
		langdef.fontcode = loadfont(langdef.lang, "fonts/journal", fontsizes[LANGFONT::MAINMENU], -1, fontscales[LANGFONT::MAINMENU], 0);
	}

	//print(ftos(langdef.fontcode), "\n");


	fclose(f);
}


#endif
#endif