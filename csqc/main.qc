// --------------------------------------------------------------------------
// BEGIN REQUIRED CSQC FUNCTIONS

#include "uielement.h"
#include "journal.h"
#include "localization.h"

void() Hud_Init;
void() rewritefriktether = {};
void() rewritefrikshrine = {};
void() pulse_health;
void() pulse_armor;
void() pulse_darmor;
void() pulse_ammo;
void HUD_InitializeUnderUI(void);
void HUD_InitializeUI(void);
void HUD_InitializeArtifactRadial(void);
void HUD_InitializeNotifications(void);
void HUD_InitializeBackfill(void);
void HUD_InitializeDeathMenu(void);
void HUD_InitializeCaptions(void);
void HUD_InitializeEndscreen(void);
void HUD_InitializeCenterprint(void);
float rmenu;

// CSQC_Init : Called every time the CSQC code is initialized (essentially at map load)
void CSQC_Init(void)
{
	local string strCmd;
	strCmd = "";
	//	strCmd = strcat (strCmd, "vid_conwidth 960 \n");
	//	strCmd = strcat (strCmd, "vid_conheight 540 \n");
	///strCmd = ("exec fonts/font.cfg \n");
	//localcmd(strCmd);
	cvar_set("r_glsl_postprocess_uservec1", "0 0 0 0");
	//cvar_set("r_viewscale", "1");
	cvar_set("sv_maxvelocity", "100000");
	localization_precaches();
	Hud_Init();
	check_frikfile();
	msgtime = gettime(GETTIME_UPTIME);
	float noqcprecaches = cvar("cl_noqcprecache");	
	if(noqcprecaches != 1)
		csqc_precaches();
	registercommand(CLIENTCOMMAND_GET_FOG);
	registercommand(CLIENTCOMMAND_DELETE_QNG);
	registercommand(CLIENTCOMMAND_DUMP_SPAWNERS);
	registercommand(CLIENTCOMMAND_NOATTACK);
	registercommand(CLIENTCOMMAND_PULSE_HEALTH);
	registercommand(CLIENTCOMMAND_PULSE_ARMOR);
	registercommand(CLIENTCOMMAND_PULSE_DARMOR);
	registercommand(CLIENTCOMMAND_PULSE_AMMO);
	registercommand(CLIENTCOMMAND_JASON);
	registercommand(CLIENTCOMMAND_REMOVEMONSTERS);
	registercommand(CLIENTCOMMAND_REPORTMONSTERS);
	registercommand(CLIENTCOMMAND_MARKMONSTERS);
	registercommand(CLIENTCOMMAND_REMOVEITEMS);
	registercommand(CLIENTCOMMAND_PULSE_ARTIFACT);
	registercommand(CLIENTCOMMAND_REMOVEALL);
	registercommand(CLIENTCOMMAND_ENCOUNTER);
	registercommand(CLIENTCOMMAND_FORCEDONOR);
	registercommand(CLIENTCOMMAND_LISTENTITIES);
	registercommand(CLIENTCOMMAND_REMOVEBYCLASSNAME);
	registercvar ("_fog_d",ftos(getproperty(VF_FOG_DENSITY)));
	registercvar("_fog_color",vtos(getpropertyvec(VF_FOG_COLOR)));
	//registercvar ("_fog_r",ftos(getproperty(VF_FOG_COLOR_R)));
	//registercvar ("_fog_g",ftos(getproperty(VF_FOG_COLOR_G)));
	//registercvar ("_fog_b",ftos(getproperty(VF_FOG_COLOR_B)));
	registercvar ("_fog_a",ftos(getproperty(VF_FOG_ALPHA)));
	registercvar ("_fog_s",ftos(getproperty(VF_FOG_START)));
	registercvar ("_fog_e",ftos(getproperty(VF_FOG_END)));
	registercvar ("_fog_h",ftos(getproperty(VF_FOG_HEIGHT)));
	registercvar ("_fog_f",ftos(getproperty(VF_FOG_FADEDEPTH)));

	float scale_crosshair = cvar ("saved8");
	if(scale_crosshair < 1)
	strCmd = ("saved8 1\n");
	localcmd(strCmd);

	// Reki: Zoom
	localcmd("alias +zoom +button8\n");
	localcmd("alias -zoom -button8\n");
	localcmd("alias togglezoom \"impulse 184\"\n");
	
	// Reki: precache notes and generate note entities
	string searchpath = sprintf("data/notes/%s/*.txt", cvar_string("prvm_language_fallback"));
	float searchhandle = search_begin(searchpath, TRUE, TRUE);
	if (searchhandle >= 0)
	{
		float searchsize = search_getsize(searchhandle);
		for(float i = 0; i < searchsize; i++)
			Journal_ParseEntry(search_getfilename(searchhandle, i));
		search_end(searchhandle);
	}
	string searchpath = sprintf("data/notes/%s/*.txt", cvar_string("prvm_language"));
	float searchhandle = search_begin(searchpath, TRUE, TRUE);
	if (searchhandle >= 0)
	{
		float searchsize = search_getsize(searchhandle);
		for(float i = 0; i < searchsize; i++)
			Journal_ParseEntry(search_getfilename(searchhandle, i));
		search_end(searchhandle);
	}
	// Precache hud notification icons
	string searchpath = "gfx/hud/messages/icons/*.tga";
	float searchhandle = search_begin(searchpath, TRUE, TRUE);
	if (searchhandle >= 0)
	{
		float searchsize = search_getsize(searchhandle);
		for(float i = 0; i < searchsize; i++)
			precache_pic(search_getfilename(searchhandle, i));
		search_end(searchhandle);
	}
	string searchpath = sprintf("gfx/hud/messages/%s/*.tga", cvar_string("prvm_language"));
	float searchhandle = search_begin(searchpath, TRUE, TRUE);
	if (searchhandle >= 0)
	{
		float searchsize = search_getsize(searchhandle);
		for(float i = 0; i < searchsize; i++)
			precache_pic(search_getfilename(searchhandle, i));
		search_end(searchhandle);
	}
	string searchpath = sprintf("gfx/hud/messages/%s/*.tga", cvar_string("prvm_language_fallback"));
	float searchhandle = search_begin(searchpath, TRUE, TRUE);
	if (searchhandle >= 0)
	{
		float searchsize = search_getsize(searchhandle);
		for(float i = 0; i < searchsize; i++)
			precache_pic(search_getfilename(searchhandle, i));
		search_end(searchhandle);
	}
	// Reki: Init HUD elements
	HUD_InitializeUnderUI();
	ui_hud = spawn(uielement_c, flags: UIFLAG::STRETCH | UIFLAG::MULTALPHA, alpha: 1);
	HUD_InitializeNotifications();
	HUD_InitializeUI();
	HUD_InitializeCaptions();
	HUD_InitializeCenterprint();
	HUD_InitializeBackfill();
	// Artifact menu
	HUD_InitializeArtifactRadial();
	// Journal UI
	Journal_Init();
	// Death Menu
	HUD_InitializeDeathMenu();
	// Credits screen
	HUD_InitializeEndscreen();
	//

	// Reki (May 8 2023): Init steam stuff
	Steam_InitStats();
	
	// Reki (May 31 2023): Init common.LANG.po
	// Reki (October 8 2023): Init csprogs.LANG.po as well
	// Reki (October 8 2023): Use fallback language if needed
	string csprogname = cvar_string("csqc_progname");
	if (!csprogname)
		csprogname = "csprogs";
	
	if (cvar_string("prvm_language"))
	{
		Localization_LoadFile(csprogname, cvar_string("prvm_language"));
		Localization_LoadFile("common", cvar_string("prvm_language"));
	}
	if (cvar_string("prvm_language_fallback"))
	{
		Localization_LoadFile(csprogname, cvar_string("prvm_language_fallback"));
		Localization_LoadFile("common", cvar_string("prvm_language_fallback"));
	}
	//

	// Reki (July 17 2023): Precache some models
	precache_model("models/dev/sphere.md3");
};

// CSQC_Shutdown : Called every time the CSQC code is shutdown (changing maps, quitting, etc)
void CSQC_Shutdown(void) {};


void()get_fog_values =
{

	/*
	#define VF_FOG_DENSITY        202 //(float)
	#define VF_FOG_COLOR        203 //(vector)
	#define VF_FOG_COLOR_R        204 //(float)
	#define VF_FOG_COLOR_G        205 //(float)
	#define VF_FOG_COLOR_B        206 //(float)
	#define VF_FOG_ALPHA        207 //(float)
	#define VF_FOG_START        208 //(float)
	#define VF_FOG_END           209 //(float)
	#define VF_FOG_HEIGHT        210 //(float)
	#define VF_FOG_FADEDEPTH    211 //(float)
	*/

	//float fog_d, fog_r, fog_g, fog_b, fog_a, fog_s, fog_e, fog_h, fog_f;

	cvar_set("_fog_d",ftos(getproperty(VF_FOG_DENSITY)));
	cvar_set ("_fog_color",vtos(getpropertyvec(VF_FOG_COLOR)));
	cvar_set ("_fog_a",ftos(getproperty(VF_FOG_ALPHA)));
	cvar_set ("_fog_s",ftos(getproperty(VF_FOG_START)));
	cvar_set ("_fog_e",ftos(getproperty(VF_FOG_END)));
	cvar_set ("_fog_h",ftos(getproperty(VF_FOG_HEIGHT)));
	cvar_set ("_fog_f",ftos(getproperty(VF_FOG_FADEDEPTH)));
}

float nexartifacticon;
float nexartifacticon_int;
void() pulse_artifact = 
{
	string strCmd = ("impulse 188\n");
	localcmd(strCmd);
    nexartifacticon = 50;
	nexartifacticon_int = 2;
};

void() dump_spawner =
{
	string strCmd = ("impulse 196\n");
	localcmd(strCmd);
};
void() removemonsters =
{
	string strCmd = ("impulse 236\n");
	localcmd(strCmd);
};
void() removeitems=
{
	string strCmd = ("impulse 238\n");
	localcmd(strCmd);
};

void() delete_qng = 
{
	string strCmd = ("impulse 198\n");
	localcmd(strCmd);
};
void() jason =
{
	float jason = cvar ("jason_mode");
	if(jason == 1)
	{	
		string strCmd = ("set jason_mode 0\n");
		localcmd(strCmd);
		print ("Jason Mode OFF\n");
	}
	else
	{
		string strCmd = ("set jason_mode 1\n");
		localcmd(strCmd);
		print ("Jason Mode ON\n");
	}
	string strCmd = ("impulse 160\n");
	localcmd(strCmd);
};
void() force_donor =
{
	string strCmd = ("impulse 70\n");
	localcmd(strCmd);
};
void() noattack =
{
	string strCmd = ("impulse 195\n");
	localcmd(strCmd);
};

void() reportmonsters =
{
	string strCmd = ("impulse 196\n");
	localcmd(strCmd);
};

void() markmonsters =
{
	string strCmd = ("impulse 186\n");
	localcmd(strCmd);
};

// Reki (October 13 2023): Added outlander unlock tempent, triggered by info_achievement_gamecomplete
void TempEnt_OutlanderUnlock(void)
{
	float f;
	f = fopen("statistics/gamecomplete", FILE_WRITE);
	if (f >= 0)
	{
		fputs(f, "mainstory,1");
		fclose(f);
	}
}

// CSQC_ConsoleCommand : Used to parse commands in the console that have been registered with the "registercmd" function
// Return value should be 1 if CSQC handled the command, otherwise return 0 to have the engine handle it.
float CSQC_ConsoleCommand(string strMessage)
{
	local float nReturn;
	nReturn = true;

	// Tokenize String
	tokenize(strMessage);
	// Acquire Command

	local string strCmd;
	strCmd = argv(0);
	switch (strCmd)
	{
		case CLIENTCOMMAND_ENCOUNTER:
		case CLIENTCOMMAND_REMOVEALL:
		case CLIENTCOMMAND_LISTENTITIES:
		case CLIENTCOMMAND_REMOVEBYCLASSNAME:
		localcmd("cmd ", strMessage, "\n");
		break;			
		case CLIENTCOMMAND_GET_FOG:
		get_fog_values();
		/*
		case CLIENTCOMMAND_GRAVITYFIX:
		{strCmd = ("exec fonts/font.cfg \n");localcmd(strCmd);}
		case CLIENTCOMMAND_NOGRAVITYFIX:
		get_fog_values();
		case CLIENTCOMMAND_GLSL_SATURATION:
		get_fog_values();
		case CLIENTCOMMAND_NOGLSL_SATURATION:
		get_fog_values();
		*/
		break;
		case CLIENTCOMMAND_PULSE_HEALTH:
		pulse_health();
		break;
		case CLIENTCOMMAND_PULSE_ARMOR:
		pulse_armor();
		break;
		case CLIENTCOMMAND_FORCEDONOR:
		force_donor();
		break;
		case CLIENTCOMMAND_PULSE_DARMOR:
		pulse_darmor();
		break;
		case CLIENTCOMMAND_PULSE_AMMO:
		pulse_ammo();
		break;
		case CLIENTCOMMAND_PULSE_ARTIFACT:
		pulse_artifact();
		break;
		case CLIENTCOMMAND_DELETE_QNG:
		delete_qng();
		break;
		case CLIENTCOMMAND_NOATTACK:
		noattack();
		break;
		case CLIENTCOMMAND_JASON:
		jason();
		break;
		case CLIENTCOMMAND_REMOVEMONSTERS:
		removemonsters();
		break;
		case CLIENTCOMMAND_REPORTMONSTERS:
		reportmonsters();
		break;
		case CLIENTCOMMAND_MARKMONSTERS:
		markmonsters();
		break;
		case CLIENTCOMMAND_REMOVEITEMS:
		removeitems();
		break;
		case CLIENTCOMMAND_DUMP_SPAWNERS:
		dump_spawner();
		break;
	default:
		nReturn = false;
		break;
	}

	return nReturn;
};

void GameCommand(string s)
{
	float argc = tokenize(s);
	string cmd = argv(0);

	if (cmd == "achievementvalue")
		CSQC_Steam_AchievementValue(argv(1), stof(argv(2)));
	else if (cmd == "statvalue")
		CSQC_Steam_StatValue(argv(1), stof(argv(2)));
}

// CSQC_InputEvent : Used to perform actions based on any key pressed or released by the client.
// Return value should be 1 if CSQC handled the key press, otherwise return 0 to have the key passed to the engine.

float tether;
float dmenualpha;
float lastsoundjournal;
vector radial_pos;
vector radial_thumbstick;

float CSQC_InputEvent(float EventType, float charx, float scany)
{
	// determine input type
	// Reki (December 3 2023): Added this to change behavior based on input type
	input_modeswitching(EventType, charx, scany);
	//

	// Reki (December 3 2023): Made this happen always, since we want to track this state
	// even if the player isn't in the radial (since joyaxis only happens when the value CHANGES)
	input_thumbsticks(EventType, charx, scany);
	//

	if ((EventType == 0) && (charx == K_ESCAPE))
	{
		localcmd("cmd dmenu_close\n");
		//localcmd("impulse 90\n");
	}
	
	if ((EventType == 0) && (DMselected >= 1))
	{
		if ((charx == 512) && (dmenualpha == 1))	// mouse1
		{
			localcmd("crosshair 2\n");
			if (DMselected == 1)
			{
				write_tether2(1);
				localcmd("stopsound\n");
				localcmd("slowmo 1\n");
				//localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_tether();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 2)
			{
				write_shrine(1);
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				//localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_shrine();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 3)
			{
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				//localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_autosave();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 4)
			{
				localcmd("wmenu\n");
				localcmd("stopsound\n");
				localcmd("menu_cmd backtomainmenu\n");
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			return 1;
		}

		if ((charx == (12 + 1)) && (dmenualpha == 1))	// enter
		{
			localcmd("crosshair 2\n");
			if (DMselected == 1)
			{
				write_tether2(1);
				rewritefriktether();
				localcmd("stopsound\n");
				localcmd("slowmo 1\n");
				//localcmd("r_glsl_saturation 1\n");
				load_tether();
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			if (DMselected == 2)
			{
				write_shrine(1);
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				//localcmd("r_glsl_saturation 1\n");
				load_shrine();
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			if (DMselected == 3)
			{
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				//localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_autosave();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 4)
			{
				localcmd("wmenu\n");
				localcmd("stopsound\n");
				localcmd("menu_cmd backtomainmenu\n");
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			return 1;
		}
	}

	//float showjournal;
	showjournal = getstatf(STAT_JOURNAL);
	if ((EventType == 0) && (charx == K_ESCAPE) && (showjournal > 0))
	{
		localcmd("cmd journal_close\n");
		//localcmd("impulse 35\n");
		return TRUE;
	}

	// Reki: Input for UI elements
	if (EventType == 0)
	{
		float ui_handled = 0;
		for(uielement_c ui_chain = ui_screen_queue; ui_chain; ui_chain = ui_chain._next)
		{
			ui_handled |= UI_CheckInput(ui_chain, charx, scany, 0);
		}

		if (ui_handled)
			return TRUE;

		if (charx == K_MOUSE1 && ui_usemouse)
		{
			ui_mouseposition = getpointerpos();
			uielement_c old_selected = ui_selected;
			ui_selected = __NULL__;
			for(uielement_c ui_chain = ui_screen_queue; ui_chain; ui_chain = ui_chain._next)
			{
				UI_CheckClick(ui_chain);
			}
			if (!ui_usemouse)
				ui_selected = __NULL__;
			
			if ((ui_selected.flags & UIFLAG::CLICKABLE) && !(ui_selected.flags & UIFLAG::SELECTABLE))
			{
				uielement_c u_sel = ui_selected;
				if (ui_selected && ui_selected.m_click)
					ui_selected.m_click(ui_selected);
				if (ui_selected == u_sel) // if our click transferred to another default select, don't stomp it
					ui_selected = __NULL__;
			}
			
			// keep select means blank space doesn't matter
			if (old_selected.flags & UIFLAG::KEEPSELECT && !ui_selected)
			{
				ui_selected = old_selected;
			}
			
			if (old_selected && ui_selected != old_selected)
			{
				if (old_selected.m_unclick)
					old_selected.m_unclick(old_selected);
			}

			if (ui_selected && ui_selected != old_selected && ui_selected.m_click)
				ui_selected.m_click(ui_selected);
			
			return TRUE;
		}
	}
	else if (EventType == 1)
	{
		float ui_handled = 0;
		for(uielement_c ui_chain = ui_screen_queue; ui_chain; ui_chain = ui_chain._next)
		{
			ui_handled |= UI_CheckInput(ui_chain, charx, scany, 1);
		}

		if (ui_handled)
			return TRUE;
	}
	//
	
	if (EventType == 0)
	{
		if (getkeybind(charx) == "+showscores")
		{
			showscores = TRUE;
			return TRUE;
		}
	}

	if (EventType == 1)
	{
		if (getkeybind(charx) == "+showscores")
		{
			showscores = FALSE;
			return TRUE;
		}
	}

	if (rmenu)
	{
		if (EventType == IE_MOUSEDELTA)
		{
			radial_pos += [charx / ui_scale[0], scany / ui_scale[1]] * 0.08;
			//radial_pos += [charx, scany] * 0.03 * autocvar_sensitivity;

			float radial_dist = vlen(radial_pos);
			vector radial_norm = normalize(radial_pos);
			radial_dist = bound(0, radial_dist, 20);
			radial_pos = (radial_norm * radial_dist);

			return TRUE;
		}
	}

	local float bSkipKey;
	bSkipKey = false;
	return bSkipKey;
}

// END REQUIRED CSQC FUNCTIONS
// --------------------------------------------------------------------------

// --------------------------------------------------------------------------
// BEGIN OPTIONAL CSQC FUNCTIONS

// Reki: Added this function from FTE spec, allows CSQC to customize input
// before it's sent off to the server as a clc
float zoom_toggle;
void CSQC_Input_Frame()
{
	// zoom functionality
	if (input_impulse == 184)
	{
		zoom_toggle = !zoom_toggle;
		input_impulse = 0;
	}
	if (zoom_toggle)
		input_buttons |= 0x0080;
	//
}

//#ifdef USE_CSQC_OPTIONALFUNCTIONS
// CSQC_Ent_Update : Called every frame that the server has indicated an update to the SSQC / CSQC entity has occured.
// The only parameter reflects if the entity is "new" to the client, meaning it just came into the client's PVS.
void CSQC_Ent_Update(float bIsNewEntity)
{
	self.enttype = ReadByte();
	switch (self.enttype)
	{
		case ENT::HUDMSG: Hud_Messages(bIsNewEntity); break;
		case ENT::HUDMSG2: Hud_Messages2(bIsNewEntity); break;
		case ENT::HMMSG: Health_Indicator(bIsNewEntity); break;
		case ENT::HUDSYNC: EntUpdate_HudSync(bIsNewEntity); break;
		case ENT::ORREY: EntUpdate_Orrey(bIsNewEntity); break;
		case ENT::EYEBALL: EntUpdate_Eyeball(bIsNewEntity); break;
		case ENT::BOSS3HALO: EntUpdate_Boss3Halo(bIsNewEntity); break;
		case ENT::PLACE_SHEPHERD: EntUpdate_place_shepherd(bIsNewEntity); break;
	}
	/*	
	if (self.enttype == ENT_ARTIFACT)
		artifact_spawn(bIsNewEntity); */
};

// CSQC_Ent_Remove : Called when the server requests a SSQC / CSQC entity to be removed.  Essentially call remove(self) as well.
void CSQC_Ent_Remove()
{
	if (self.enttype == ENT::HUDMSG)
		Remove_Message();
	else if (self.enttype == ENT::HUDMSG2)
		Remove_Message2();
	else if (self.enttype == ENT::BOSS3HALO)
		Boss3Halo_Destructor();
	else
		remove(self);
};

// CSQC_Parse_StuffCmd : Provides the stuffcmd string in the first parameter that the server provided.  To execute standard behavior, simply execute localcmd with the string.
void CSQC_Parse_StuffCmd(string strMessage)
{
	localcmd(strMessage);
};

// CSQC_Parse_Print : Provides the print string in the first parameter that the server provided.  To execute standard behavior, simply execute print with the string.
void CSQC_Parse_Print(string strMessage)
{
	print(strlocalize(strMessage));
};

// CSQC_Parse_CenterPrint : Provides the centerprint string in the first parameter that the server provided.  To execute standard behavior, simply execute cprint with the string.
void CSQC_Parse_CenterPrint(string strMessage)
{
	if (substring(strMessage, 0, 1) == "&") // if first character is an '&' then we print to the dialog box
	{
		strMessage = substring(strMessage, 1, -1);
		spawn(caption_text_c, text: strlocalize(strMessage));
		return;
	}
	
	centerprint(strlocalize_full(strMessage, TRUE));
};

// CSQC_Parse_TempEntity : Handles all temporary entity network data in the CSQC layer.
// You must ALWAYS first acquire the temporary ID, which is sent as a byte.
// Return value should be 1 if CSQC handled the temporary entity, otherwise return 0 to have the engine process the event.
float CSQC_Parse_TempEntity()
{
	local float bHandled;
	bHandled = true;
	// Acquire TE ID
	local float nTEID;
	nTEID = ReadByte();
	switch (nTEID)
	{
		//case TE_GUNSHOT:
		//	Do something cool with TE_GUNSHOT!
		//	break;
		case TEMPENT::NOTIFICATION:
			float m_flags = ReadByte();
			string s_icon = ReadString();
			string s_label = ReadString();
			string s_msg = strlocalize(ReadString());

			float msg_mode = 0;
			//string s_msg_pic = sprintf("gfx/hud/messages/%s/msg_%s.tga", cvar_string("prvm_language"), s_label);
			string s_msg_pic = Localization_FindFile(sprintf("gfx/hud/messages/%%s/msg_%s.tga", s_label), TRUE);
			if (fexists_pak(s_msg_pic))
				msg_mode |= 0x01;
			s_icon = sprintf("gfx/hud/messages/icons/msgicon_%s.tga", s_icon);
			if (fexists_pak(s_icon))
				msg_mode |= 0x02;
			

			// search for duplicates to aggregate
			if (m_flags & HUDMSGFLAG::AGGREGATE)
			{
				for(float i = 0; i < HUD_NOTIFY_LINES; i++)
				{
					uielement_c line = ui_notify_lines[i];
					if (!line.skin)
						break;
					if (line.skin - time < 1.5)
					{
						uielement_c nextline;
						if (i < HUD_NOTIFY_LINES - 1)
							nextline = ui_notify_lines[i + 1];
						if (!nextline.skin) // if this is the last notification, refresh its time
							line.skin += HUD_NOTIFY_TIME * 0.4;
						else
							continue;
					}
					
					line = ui_notify_lines[i];
					uipicture_c icon = (uipicture_c)line.partner;
					uitext_c msg = (uitext_c)line.partner2;
					uitext_c cnt = (uitext_c)line.partner4;
					uispritesheet_c cntimg = (uispritesheet_c)line.partner5;

					if (msg.text != s_msg || icon.image != s_icon) // make sure they're identical
						continue;

					line.frame++;
					if (cnt.text)
						strunzone(cnt.text);
					if (cntimg.image)
						strunzone(cntimg.image);
					
					cnt.text = strzone(sprintf("x%g", line.frame));
					//cntimg.image = strzone(sprintf("gfx/hud/messages/icons/count/count_%g.tga", line.frame));
					if (line.frame <= 99) // we only go to 99 on the sheet...
					{
						cntimg.image = strzone("gfx/hud/messages/icons/count_sheet.tga"); // Reki (October 6 2023): We could move this to be a constant now that it's a spritesheet, but I'm gonna leave it just in case
						cntimg.sheet_size = '10 10';
						cntimg.sprite = [line.frame % 10, floor(line.frame) / 10];
					}
					else
					{
						cntimg.image = strzone(sprintf("gfx/hud/messages/icons/count/count_%g.tga", line.frame)); // try just in case, I guess
					}


					if (fexists_pak(cntimg.image))
					{
						cnt.flags |= UIFLAG::HIDE;
						cntimg.flags &= ~UIFLAG::HIDE;

						vector isize = draw_getimagesize(cntimg.image);
						isize[1] = max(isize[1], 1); // prevent div0 error
						cntimg.size = [(isize[0] / isize[1]) * cntimg.size[1], cntimg.size[1]];
					}
					else
					{
						cnt.flags &= ~UIFLAG::HIDE;
						cntimg.flags |= UIFLAG::HIDE;
					}

					return TRUE;
				}
			}
			//

			uielement_c line = HUD_AllocateLine();
			uipicture_c icon = (uipicture_c)line.partner;
			uitext_c msg = (uitext_c)line.partner2;
			uipicture_c msgpic = (uipicture_c)line.partner3;
			uitext_c cnt = (uitext_c)line.partner4;
			uipicture_c cntimg = (uipicture_c)line.partner5;
			cnt.flags |= UIFLAG::HIDE; // hide count on new elements
			cntimg.flags |= UIFLAG::HIDE;

			// figure out icon size
			if (msg_mode & 0x02)
			{
				vector isize = draw_getimagesize(s_icon);
				isize[1] = max(isize[1], 1); // prevent div0 error
				icon.size = [(isize[0] / isize[1]) * 32, 32];

				msg.origin = msgpic.origin = [icon.size[0] + 6, 0];

				precache_pic(s_icon);
				icon.flags &= ~UIFLAG::HIDE;
			}
			else
			{
				msg.origin = msgpic.origin = '0 0';
				icon.flags |= UIFLAG::HIDE;
			}
			//

			icon.image = strzone(s_icon);
			if (msg_mode & 0x01) // img mode
			{
				msg.text = strzone(s_msg);
				msg.flags |= UIFLAG::HIDE;

				precache_pic(s_msg_pic);
				msgpic.image = strzone(s_msg_pic);
				msgpic.flags &= ~UIFLAG::HIDE;

				vector isize = draw_getimagesize(s_msg_pic);
				isize[1] = max(isize[1], 1); // prevent div0 error
				msgpic.size = [(isize[0] / isize[1]) * 32, 32];

				// count needs to be adjusted to the end of the msgpic
				cnt.origin = cntimg.origin = msgpic.origin + [msgpic.size[0], 0];
			}
			else // text mode
			{
				msg.text = strzone(s_msg);
				msg.flags &= ~UIFLAG::HIDE;

				msgpic.image = strzone("");
				msgpic.flags |= UIFLAG::HIDE;

				cnt.origin = cntimg.origin = msg.origin + [msg.totalsize()[0] + 8, 0];
			}
		break;
		case TEMPENT::NOTIFICATION_NOTE:
			string s_icon = ReadString();
			float note = ReadByte();

			s_icon = sprintf("gfx/hud/messages/icons/msgicon_%s.tga", s_icon);
			precache_pic(s_icon);

			uielement_c line = HUD_AllocateLine();
			uipicture_c icon = (uipicture_c)line.partner;
			uitext_c msg = (uitext_c)line.partner2;
			uipicture_c msgimg = (uipicture_c)line.partner3;

			// figure out icon size
			vector isize = draw_getimagesize(s_icon);
			isize[1] = max(isize[1], 1); // prevent div0 error
			icon.size = [(isize[0] / isize[1]) * 32, 32];
			msg.origin = [icon.size[0] + 6, 0];
			//

			icon.flags &= ~UIFLAG::HIDE;
			msg.flags &= ~UIFLAG::HIDE;
			msgimg.flags |= UIFLAG::HIDE;

			icon.image = strzone(s_icon);
			string note_name = "INVALID NOTE";
			journalentry_c jentry = Journal_FindEntry(note);
			if (jentry)
				note_name = jentry.title;

			string s_msg = strzone(sprintf("%s: %s", _("NOTIFY_JOURNAL_NOTEADDED"), note_name));
			//string s_msg_pic = sprintf("gfx/hud/messages/%s/note_%s.tga", cvar_string("prvm_language"), jentry.msgimg);
			string s_msg_pic = Localization_FindFile(sprintf("gfx/hud/messages/%%s/note_%s.tga", jentry.msgimg), TRUE);
			if (fexists_pak(s_msg_pic))
			{
				msgimg.image = strzone(s_msg_pic);

				msg.text = strzone(s_msg);
				msg.flags |= UIFLAG::HIDE;

				precache_pic(s_msg_pic);
				msgimg.image = strzone(s_msg_pic);
				msgimg.flags &= ~UIFLAG::HIDE;

				vector isize = draw_getimagesize(s_msg_pic);
				isize[1] = max(isize[1], 1); // prevent div0 error
				msgimg.size = [(isize[0] / isize[1]) * 32, 32];
			}
			else
			{
				msg.text = strzone(s_msg);
				msg.flags &= ~UIFLAG::HIDE;

				msgimg.image = strzone("");
				msgimg.flags |= UIFLAG::HIDE;
			}
		break;
		case TEMPENT::NOTIFICATION_CONTROL:
			float is_double = ReadByte();
			string s_format = ReadString();
			string s_cmd = ReadString();
			
			if (is_double)
			{
				string s_cmd2 = ReadString();
				// get bound key
				tokenize(findkeysforcommand(s_cmd, 0));
				string s_key;
				if (argv(0) != "-1")
					s_key = case_fixed(keynumtostring(stof(argv(0))));
				else
					s_key = "UNBOUND";
				// get bound key
				tokenize(findkeysforcommand(s_cmd2, 0));
				string s_key2;
				if (argv(0) != "-1")
					s_key2 = case_fixed(keynumtostring(stof(argv(0))));
				else
					s_key2 = "UNBOUND";
				
				centerprint(sprintf(s_format, s_key, s_key2));
			}
			else
			{
				// get bound key
				tokenize(findkeysforcommand(s_cmd, 0));
				string s_key;
				if (argv(0) != "-1")
					s_key = case_fixed(keynumtostring(stof(argv(0))));
				else
					s_key = "UNBOUND";
				
				centerprint(sprintf(s_format, s_key));
			}
		break;
		case TEMPENT::ACHIEVEMENT_UNLOCK:
			float achievement = ReadShort();
			Steam_AchievementUnlock(world, achievement);
		break;
		case TEMPENT::STAT_INCREMENT:
			float stat = ReadShort();
			float value = ReadLong() / 100;
			Steam_StatIncrement(world, stat, value);
		break;
		case TEMPENT::STAT_SET:
			float stat = ReadShort();
			float value = ReadLong() / 100;
			Steam_StatSet(world, stat, value);
		break;
		case TEMPENT::CRYSTALLIZER_BEZIER:
			TempEnt_Crystallizer_Bezier();
		break;
		case TEMPENT::BOSS_BEAM:
			TempEnt_Boss_Beam();
		break;
		case TEMPENT::LOCALIZATION_FILES:
			TempEnt_Localization_Files();
		break;
		case TEMPENT::EXPANDING_ORB:
			TempEnt_ExpandingOrb();
		break;
		case TEMPENT::OUTLANDER_UNLOCK:
			TempEnt_OutlanderUnlock();
		break;
		case TEMPENT::CENTERPRINT:
			TempEnt_Centerprint();
		break;
		case TEMPENT::CONTROLLER_RUMBLE:
			Controller_Rumble(0, ReadShort() / 2048, ReadShort() / 2048, ReadShort());
		break;
		case TEMPENT::CONTROLLER_RUMBLETRIGGER:
			Controller_RumbleTriggers(0, ReadShort() / 2048, ReadShort() / 2048, ReadShort());
		break;
		default:
			// No special logic for this temporary entity; return 0 so the engine can handle it
			bHandled = false;
		break;
	}

	return bHandled;
};

float CSQC_Event_Sound(float ent, float channel, string soundname, float vol, float attenuation, vector pos, float pitchmod, float flags, float tzoid)
{
	return FALSE;
}
//endif	///////////////
