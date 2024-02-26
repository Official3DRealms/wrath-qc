 
 #include "uielement.h"
 #if NEW_MENU
 #include "menudefs.h"
 #include "csqc/journal.h"
 #include "csqc/localized_assets.h"
 #endif
 
 void(float alternative) menu_type_confirmbind;
 void() menu_type_confirmresolution;
 void() menu_type_confirmantialias;
 void() menu_type_confirmfullscreen;
 void(vector txt_pos) menu_type_profile;
 void(vector txt_pos) menu_type_main;
 void() menu_type_resume;
 void() menu_type_options;
 void() menu_type_options_controls;
 void() menu_type_options_video;
 void() menu_type_options_resolution;
 void() menu_type_options_audio;
 void() menu_type_options_gameplay;
 void() menu_type_ingame;
 void() menu_type_difficult;

 float slayeralpha;
 float slayerstate;
void()menu_type_deleteprofile;
void()menu_type_options_controlbinds;
void()menu_type_confirmresettodefaults;
void() check_vectorcolors =
{
//	local float readparms, localmenuversion;
// 	local string readtext;
// 	readparms = fopen_wrath("colordata.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
// 	readtext = fgets(readparms);	//read the text
//	vectorred = stov(readtext);	//turn the text into the float u want (by using stof: string to float)
// 	readtext = fgets(readparms);	//read the text
// 	vectorwhite = stov(readtext);	//turn the text into the float u want (by using stof: string to float)
// 	fclose_wrath(readparms);
	vectorred = '-1 -1 -1';
	vectorwhite = '8 -1 -1';
	
};

#if NEW_MENU

float(uielement_c this) menu_conditional = {
	if (menu_current != this)
		return FALSE;
	return TRUE;
}

void(uipicture_c this, __inout string img_to_render) button_highlight = { if (ui_selected == this || ui_hover == this) img_to_render = this.image2; }
void(uilocpicture_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) text_highlight = {
	if (ui_selected == this || ui_hover == this)
		color_to_render = HIGHLIGHT_TEXT_COLOR;
}
void(uipicture_c this, __inout string img_to_render) button_owner_highlight = { if (ui_selected == this.owner || ui_hover == this.owner) img_to_render = this.image2; }
void(uilocpicture_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) text_owner_highlight = {
	if (ui_selected == this.owner || ui_hover == this.owner)
		color_to_render = HIGHLIGHT_TEXT_COLOR;
}

.uielement_c reinit_list;
.void(uielement_c this) reinit;
void Add_To_Reinit_List(uielement_c menu, uielement_c object)
{
	object.reinit_list = menu.reinit_list;
	menu.reinit_list = object;
}
void Run_Reinit_List(uielement_c object)
{
	while(object)
	{
		if (object.reinit)
			object.reinit(object);
		object = object.reinit_list;
	}
}

string quit_taunts[] = {
	_("UI_QUIT_TAUNT1"),
	_("UI_QUIT_TAUNT2"),
	_("UI_QUIT_TAUNT3"),
	_("UI_QUIT_TAUNT4"),
	_("UI_QUIT_TAUNT5"),
	_("UI_QUIT_TAUNT6"),
	_("UI_QUIT_TAUNT7"),
	_("UI_QUIT_TAUNT8"),
}

#define ACHIEVEMENT_NOTIFICATIONS_MAX	8
#define ACHIEVEMENT_NOTIFICATIONS_TIME	6
#define ACHIEVEMENT_NOTIFICATIONS_MAXSIZE 18
uielement_c achnotify_list[ACHIEVEMENT_NOTIFICATIONS_MAX];
string achnotify_icons[ST_ACHIEVEMENTS::MAX];

static string(void) ach_getnextscroll = {
	string pieces[] = {
		"gfx/achievements/achievementscroll_mid_0.tga",
		"gfx/achievements/achievementscroll_mid_1.tga",
		"gfx/achievements/achievementscroll_mid_2.tga",
		"gfx/achievements/achievementscroll_mid_3.tga",
		"gfx/achievements/achievementscroll_mid_4.tga",
		"gfx/achievements/achievementscroll_mid_5.tga",
	};

	static float last_piece = 0;
	float touse;
	while ((touse = floor(random(pieces.length))) == last_piece);
	last_piece = touse;

	return pieces[touse];
};

void Achievement_CleanupBox(uielement_c cleanup)
{
	cleanup.flags |= UIFLAG::HIDE;
	/*
	if (cleanstring)
	{
		if (((uipicture_c)cleanup.partner6).image)
		{
			strunzone(((uipicture_c)cleanup.partner6).image);
			((uipicture_c)cleanup.partner6).image = __NULL__;
		}
	}
	*/
	for(uipicture_c clean = (uipicture_c)cleanup.partner; clean; clean = clean.partner)
	{
		clean.flags |= UIFLAG::HIDE;
	}
}

void Overlay_AchievementShuffleDown(void)
{
	// Reki (October 10 2023): Perform cleanup on bottom cheevo box
	Achievement_CleanupBox(achnotify_list[0]);

	// Shuffle all boxes down one index
	for(float i = 1; i < ACHIEVEMENT_NOTIFICATIONS_MAX; i++)
	{
		uielement_c to = achnotify_list[i - 1];
		uielement_c from = achnotify_list[i];
		
		for(uipicture_c bd_to = (uipicture_c)to.partner,
			uipicture_c bd_from = (uipicture_c)from.partner;
			bd_to && bd_from;
			bd_to = bd_to.partner, bd_from = bd_from.partner)
		{
			bd_to.image = bd_from.image;
			bd_to.flags &= ~UIFLAG::HIDE;
			bd_to.flags |= (bd_from.flags & UIFLAG::HIDE);
			bd_to.origin[0] = bd_from.origin[0];
		}

		((uitext_c)to.partner4).text = ((uitext_c)from.partner4).text;
		((uitext_c)to.partner5).text = ((uitext_c)from.partner5).text;
		((uipicture_c)to.partner6).image = ((uipicture_c)from.partner6).image;

		to.flags = from.flags;
		to.origin[0] = from.origin[0];
	}

	// Reki (October 10 2023): Perform cleanup on top cheevo box
	Achievement_CleanupBox(achnotify_list[ACHIEVEMENT_NOTIFICATIONS_MAX - 1], FALSE);
}

void Overlay_AchievementShuffleUp(void)
{
	// Reki (October 10 2023): Perform cleanup on top cheevo box
	Achievement_CleanupBox(achnotify_list[ACHIEVEMENT_NOTIFICATIONS_MAX - 1]);

	// Reki (July 13 2023): fixed this... had a dumb logic error where it it would just copy up
	// since I didn't invert the loop. derp.
	for(float i = ACHIEVEMENT_NOTIFICATIONS_MAX - 1; i > 0; i--)
	{
		uielement_c to = achnotify_list[i];
		uielement_c from = achnotify_list[i - 1];

		for(uipicture_c bd_to = (uipicture_c)to.partner,
			uipicture_c bd_from = (uipicture_c)from.partner;
			bd_to && bd_from;
			bd_to = bd_to.partner, bd_from = bd_from.partner)
		{
			bd_to.image = bd_from.image;
			bd_to.flags &= ~UIFLAG::HIDE;
			bd_to.flags |= (bd_from.flags & UIFLAG::HIDE);
			bd_to.origin[0] = bd_from.origin[0];
		}

		((uitext_c)to.partner4).text = ((uitext_c)from.partner4).text;
		((uitext_c)to.partner5).text = ((uitext_c)from.partner5).text;
		((uipicture_c)to.partner6).image = ((uipicture_c)from.partner6).image;

		to.flags = from.flags;
		to.origin[0] = from.origin[0];
	}

	// Reki (October 10 2023): Perform cleanup on old cheevo box
	Achievement_CleanupBox(achnotify_list[0], FALSE);
}

void Overlay_NewAchievement(string id, string name, string desc)
{
	achievement_notify_time = cltime + 1;
	Overlay_AchievementShuffleUp();

	uielement_c to = achnotify_list[0];

	float o_font = drawfont; drawfont = FONT_CENTERPRINT;
	float max_width = max(stringwidth(_("ACHIEVEMENT_UNLOCKED"), TRUE, '6 6'), stringwidth(name, TRUE, '6 6'), stringwidth(desc, TRUE, '4 4')) - 16;
	float segments_needed = bound(3, round(max_width / 16), ACHIEVEMENT_NOTIFICATIONS_MAXSIZE);
	float sz = 24;
	drawfont = o_font;

	uipicture_c bd_to = (uipicture_c)to.partner.partner;
	for(float i = 0; i <= segments_needed && bd_to && bd_to != to.partner2; i++, bd_to = bd_to.partner)
	{
		bd_to.image = ach_getnextscroll();
		bd_to.flags &= ~UIFLAG::HIDE;
		sz += 16;
	}
	
	((uipicture_c)to.partner).flags &= ~UIFLAG::HIDE; // opener
	((uipicture_c)to.partner2).flags &= ~UIFLAG::HIDE; // ender
	((uipicture_c)to.partner2).origin[0] = sz;
	sz += 24;

	to.origin[0] = -sz/2; // center justify

	to.flags &= ~UIFLAG::HIDE;
	((uitext_c)to.partner4).text = name;
	((uitext_c)to.partner5).text = desc;

	float index;
	for(index = 0; index < ST_ACHIEVEMENTS::MAX; index++)
	{
		steamachievement_t ach = steam_achievementlist[index];
		if (ach.name == id)
			break;
	}

	//if (((uitext_c)to.partner6).text)
	//	strunzone(((uitext_c)to.partner6).text);
	//string ach_icon = sprintf("gfx/achievements/icon_%s.tga", strtolower(id));
	//if !(fexists_pak(ach_icon))
	//	ach_icon = "gfx/hud/messages/icons/msgicon_helm.tga";
	((uipicture_c)to.partner6).image = achnotify_icons[index];//strzone(ach_icon);
}

void MenuInit_Overlay(void)
{
	menu_gameoverlay = spawn(uielement_c, flags: UIFLAG::STRETCH);

	void(uielement_c this, __inout vector position) notify_preloop = {

		if (achnotify_list[0].flags & UIFLAG::HIDE)
			return;

		float frac = 0;
		if (cltime < achievement_notify_time)
		{
			// move up
			frac = (achievement_notify_time - cltime) / 0.4;
			//
		}
		else if (cltime > (achievement_notify_time + ACHIEVEMENT_NOTIFICATIONS_TIME))
		{
			// move down
			frac = (cltime - (achievement_notify_time + ACHIEVEMENT_NOTIFICATIONS_TIME)) / 0.3;
			//

			if (frac > 1)
			{
				achievement_notify_time = cltime - (ACHIEVEMENT_NOTIFICATIONS_TIME - 0.9);
				Overlay_AchievementShuffleDown();
			}
		}
		
		frac = bound(0, frac, 1);
		position[1] += 44 * frac;
	}

	uilist_c notifybox = spawn(uilist_c, owner: menu_gameoverlay, anchor: '0.5 1', separation: '0 -48');
	notifybox.preloop = notify_preloop;


	for(float i = 0; i < ACHIEVEMENT_NOTIFICATIONS_MAX; i++)
	{
		uielement_c container = spawn(uielement_c, owner: notifybox, anchor: '0.5 0', justify: '0 1', size: '0 48');
		achnotify_list[i] = container;
		container.flags |= UIFLAG::HIDE;
		
		uielement_c backdroplist;
		float xpos = 0;
		container.partner = backdroplist = spawn(uipicture_c, owner: container, origin: [xpos, 0], size: '48 48', image: "gfx/achievements/achievementscrolls_left.tga"); xpos += 48;
		for(float j = 0; j < ACHIEVEMENT_NOTIFICATIONS_MAXSIZE; j++)
		{
			backdroplist.partner = spawn(uipicture_c, owner: container, origin: [xpos, 0], size: '16 48', image: ach_getnextscroll());
			backdroplist = backdroplist.partner;
			xpos += 16;
		}
		container.partner2 = backdroplist.partner = spawn(uipicture_c, owner: container, origin: [xpos, 0], size: '48 48', image: "gfx/achievements/achievementscrolls_right.tga"); xpos += 48;
		uipicture_c icon = spawn(uipicture_c, owner: container, origin: '8 8', size: '32 32', image: strzone("gfx/hud/messages/icons/msgicon_helm.tga"));

		uielement_c textbody = spawn(uielement_c, owner: container, origin: '48 8');
		uitext_c cheevo = spawn(uitext_c, owner: textbody, origin: '0 4', text: _("ACHIEVEMENT_UNLOCKED"), size: '6 6', font: FONT_CENTERPRINT, alpha: 0.92, color: CONVERT_TO_DP_SHITTY_COLOR('0.5 0 0'));
		uitext_c cheevo_name = spawn(uitext_c, owner: textbody, origin: '0 16', text: "name", size: '6 6', font: FONT_CENTERPRINT, alpha: 0.84, color: CONVERT_TO_DP_SHITTY_COLOR('0.0 0.0 0.0'));
		uitext_c cheevo_desc = spawn(uitext_c, owner: textbody, origin: '0 26', text: "description", size: '4 4', font: FONT_CENTERPRINT, alpha: 0.84, color: CONVERT_TO_DP_SHITTY_COLOR('0.02 0.02 0.02'));

		container.partner3 = cheevo;
		container.partner4 = cheevo_name;
		container.partner5 = cheevo_desc;
		container.partner6 = icon;
	}

	/*
	for(float i = 0; i < ACHIEVEMENT_NOTIFICATIONS_MAX; i++)
	{
		uifill_c backdrop = spawn(uifill_c, owner: notifybox, justify: '0.5 1', size: '168 44', color: '0.8 0.8 0.8');
		achnotify_list[i] = backdrop;
		backdrop.flags |= UIFLAG::HIDE;

		uifill_c middle = spawn(uifill_c, owner: backdrop, anchor: '0.5 0.5', justify: '0.5 0.5', size: '164 40', color: '0.12 0.12 0.12');

		spawn(uifill_c, owner: middle, anchor: '0 0.5', justify: '0 0.5', origin: '4 0', size: '32 32', color: '0.01 0.01 0.01');
		uipicture_c icon = spawn(uipicture_c, owner: middle, anchor: '0 0.5', justify: '0 0.5', origin: '4 0', size: '32 32', image: strzone("gfx/hud/messages/icons/msgicon_helm.tga"));

		uielement_c textbody = spawn(uielement_c, owner: middle, origin: '38 4', size: '124 32');
		uitext_c cheevo = spawn(uitext_c, owner: textbody, origin: '0 4', text: _("ACHIEVEMENT_UNLOCKED"), size: '6 6', font: FONT_CENTERPRINT, color: HIGHLIGHT_TEXT_COLOR);
		uitext_c cheevo_name = spawn(uitext_c, owner: textbody, origin: '0 16', text: "name", size: '6 6', font: FONT_CENTERPRINT, color: '1 1 1');
		uitext_c cheevo_desc = spawn(uitext_c, owner: textbody, origin: '0 26', text: "description", size: '4 4', font: FONT_CENTERPRINT, color: '0.6 0.6 0.6');

		backdrop.partner = cheevo;
		backdrop.partner2 = cheevo_name;
		backdrop.partner3 = cheevo_desc;
	}
	*/
}

typedef struct {
	string mapfile;
	string locname;
} loadscreendef_t;

#define X(s) {#s, _("UI_JOURNAL_LABEL_" #s)},
loadscreendef_t loadscreen_list[] = {
	LIST_OFFICIAL_MAPS
};
#undef X

string autocvar_scr_loadingscreen_mapname;
float autocvar_scr_loadingscreen_waiting;
void MenuInit_LoadingScreen(void)
{

	float(uielement_c this) loading_active = { return in_loadingscreen; };
	void(uielement_c this, __inout vector position) splash_preloop = {
		static string load_mapname = __NULL__;
		static vector virtualscreen_size = '0 0';
		uipicture_c splash = (uipicture_c)this.partner;
		uipicture_c vignette = (uipicture_c)splash.partner2;
		uitext_c map_string = splash.partner;
		uielement_c screen = this;

		if (load_mapname != autocvar_scr_loadingscreen_mapname || virtualscreen_size != screen.size)
		{
			virtualscreen_size = screen.size;
			if (load_mapname)
				strunzone(load_mapname);
			load_mapname = strzone(autocvar_scr_loadingscreen_mapname);

			string path = sprintf("gfx/splashes/%s/%s_16-9.tga", cvar_string("prvm_language"), load_mapname);
			string path_generic = sprintf("gfx/splashes/%s_16-9.tga", load_mapname);
			if (splash.image)
				strunzone(splash.image);
			splash.image = __NULL__;
			float use_blank = FALSE;

			if (fexists_pak(path))
			{
				splash.image = strzone(path);
				map_string.flags |= UIFLAG::HIDE;
			}
			else if (fexists_pak(path_generic))
			{
				splash.image = strzone(path_generic);
				map_string.flags &= ~UIFLAG::HIDE;
				map_string.button_index = 1;
			}
			else
			{
				splash.image  = strzone(splash.image2);
				map_string.flags &= ~UIFLAG::HIDE;
				map_string.button_index = 0;
				use_blank = TRUE;
			}

			if !(map_string.flags & UIFLAG::HIDE)
			{
				string map_name = load_mapname;
				for(float i = 0; i < loadscreen_list.length; i++)
				{
					loadscreendef_t ls = loadscreen_list[i];
					if (load_mapname != strtolower(ls.mapfile))
						continue;
					if (ls.mapfile == "INTRO" || ls.mapfile == "OUTRO") // sigh... localization uses text so we can't just hack it with a blank label name :\
						map_name = "";
					else if (strcmp(ls.locname, sprintf("UI_JOURNAL_LABEL_%s", ls.mapfile)))
						map_name = ls.locname;
					break;
				}

				map_string.text = strzone(map_name);
			}

			vector i_size = drawgetimagesize(splash.image);
			if (use_blank)
				i_size = screen.size;

			vector i_ratio = [(i_size[0] / i_size[1]), (i_size[1] / i_size[0])];
			vector s_ratio = [(screen.size[0] / screen.size[1]), (screen.size[1] / screen.size[0])];
			
			float font_scale = 1;
			if (i_ratio[0] < s_ratio[0])
			{
				i_size[0] = screen.size[1] * i_ratio[0];
				i_size[1] = screen.size[1];
				splash.origin[0] = (screen.size[0] - i_size[0]) / 2;
				splash.origin[1] = 0;
			}
			else if (i_ratio[0] > s_ratio[0])
			{
				i_size[0] = screen.size[0];
				i_size[1] = screen.size[0] * i_ratio[1];
				splash.origin[0] = 0;
				splash.origin[1] = (screen.size[1] - i_size[1]) / 2;
			}
			else
			{
				i_size = screen.size;
				splash.origin = '0 0';
			}
			
			splash.size = i_size;
			
			if (map_string.button_index)
			{
				font_scale = (i_size[0]) / (960);
				map_string.size[0] = (72 * font_scale);
				map_string.size[1] = (72 * font_scale);
				map_string.color = CONVERT_TO_DP_SHITTY_COLOR('0.196 0.135 0.055');
				map_string.drawflags = DRAWFLAG_ADDITIVE;
			}
			else
			{
				map_string.size[0] = (32);
				map_string.size[1] = (32);
				map_string.color = CONVERT_TO_DP_SHITTY_COLOR('1 1 1');
				map_string.drawflags = DRAWFLAG_NORMAL;
			}
		}

		if (ui_renderframe)
		{
			if !(autocvar_scr_loadingscreen_waiting)
			{
				vignette.alpha = 0;
			}
			else
			{
				float delta = min(clframetime, 0.1);
				vignette.alpha = bound(0.001, vignette.alpha + (delta * 0.36), 1);
			}
		}
	};

	float(uielement_c this) loadscreen_show = {
		return TRUE;//(clientstate() != CS_DISCONNECTED); // Reki (January 31 2024): this fixes the vid_restart loading screen thing, but causes the load screen not to show up until the last second :(
	}

	menu_loading = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_loading.active_condition = loading_active;
		menu_loading.preloop = splash_preloop;

	uipicture_c pic = spawn(uipicture_c, owner: menu_loading, image2: "gfx/splashes/_blank.tga");
		pic.active_condition = loadscreen_show;
	menu_loading.partner = pic;

	void(uielement_c this, __inout vector position) text_shadow = {
		uitext_c txt = (uitext_c)this;
		uitext_c shadow = (uitext_c)txt.partner;

		shadow.size = txt.size;
		shadow.color = CONVERT_TO_DP_SHITTY_COLOR('0.108 0.065 0.019');
		shadow.font = txt.font;
		shadow.text = txt.text;
		shadow.alpha = 0.8;
		shadow.drawflags = DRAWFLAG_NORMAL;
		shadow.origin = '-1.2 1.2' * (txt.size[0] / 72);

		shadow.flags |= UIFLAG::HIDE;
		if (txt.button_index)
			shadow.flags &= ~UIFLAG::HIDE;
	};
	uitext_c txt = spawn(uitext_c, owner: pic, justify: '0 1', anchor: '0 1', origin: '16 -8', font: FONT_USER7, flags: UIFLAG::HIDE);
		txt.partner = spawn(uitext_c, owner: txt);
		txt.preloop = text_shadow;
		pic.partner = txt;

	
	uipicture_c vignette = spawn(uipicture_c, owner: pic, flags: UIFLAG::STRETCH, image: "gfx/splashes/vignette.tga");
		pic.partner2 = vignette;
}

void MenuInit_Backdrop(void)
{
	void(uipicture_c this, __inout string img_to_render) backdrop_prerender = {
		vector img_size = drawgetimagesize(img_to_render);
		this.size = [vid_width, vid_height];

		float s_ratio = vid_width / vid_height;
		float i_ratio = img_size[0] / img_size[1];
		
		if (s_ratio > i_ratio)
		{
			this.size[0] = vid_width;
			this.size[1] = vid_width * (img_size[1] / img_size[0]);
		}
		else if (s_ratio < i_ratio)
		{
			this.size[0] = vid_height * i_ratio;
			this.size[1] = vid_height;
		}

		this.size[0] /= ui_scale[0];
		this.size[1] /= ui_scale[1];
	};
	float(uielement_c this) backdrop_conditional = {
		return !in_game;
	};
	uipicture_c backdrop = spawn(uipicture_c, anchor: '0.5 0.5', justify: '0.5 0.5', size: '960 540', image: "gfx/menu/background.tga");
		backdrop.prerender = backdrop_prerender;
		backdrop.active_condition = backdrop_conditional;
	
	float(uielement_c this) backdrop_conditional = {
		if (in_game)
			this.alpha = 0.5;
		else
			this.alpha = 0.7;
		return menu_current != menu_main && menu_current != menu_quitconfirm;
	};
	uifill_c backfill = spawn(uifill_c, flags: UIFLAG::STRETCH, color: '-1 -1 -1');
		backfill.active_condition = backdrop_conditional;
}

void MenuInit_Main_Game(void)
{
	void(uipicture_c this, __inout string img_to_render) button_highlight = { if (ui_selected == this || ui_hover == this) img_to_render = this.image2; };
	menu_main_game = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_main_game.active_condition = menu_conditional;

	uilist_c menu_buttons = spawn(uilist_c, owner: menu_main_game, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 150', separation: '0 50');
	
	// return button
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		m_hide();
	};
	uielement_c container = spawn(uielement_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '192 48', flags: UIFLAG::CLICKABLE);
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: container, anchor: '0.5 0', justify: '0.5 0', size: '352 58',
		image: menu_assets[MENU_IMG::RESUME], image2: menu_assets[MENU_IMG::RESUME_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::RESUME]);
		lbutton.prerender = button_owner_highlight;
		lbutton.prerender_text = text_owner_highlight;
		container.m_click = button_click;
	
	// options button
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uielement_c container = spawn(uielement_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '192 48', flags: UIFLAG::CLICKABLE);
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: container, anchor: '0.5 0', justify: '0.5 0', size: '352 58',
		image: menu_assets[MENU_IMG::OPTIONS], image2: menu_assets[MENU_IMG::OPTIONS_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::OPTIONS]);
		lbutton.prerender = button_owner_highlight;
		lbutton.prerender_text = text_owner_highlight;
		container.m_click = button_click;
	
	// quit button
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_main;
		cmd("disconnect\n");
		cmd("cd play 6\n");
	};
	uielement_c container = spawn(uielement_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '192 48', flags: UIFLAG::CLICKABLE);
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: container, anchor: '0.5 0', justify: '0.5 0', size: '352 58',
		image: menu_assets[MENU_IMG::DEPART], image2: menu_assets[MENU_IMG::DEPART_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::DEPART]);
		lbutton.prerender = button_owner_highlight;
		lbutton.prerender_text = text_owner_highlight;
		container.m_click = button_click;
}

float steam_init_check;
void MenuInit_Main(void)
{
	steam_init_check = cvar("steam_firsttime") ? FALSE : TRUE;

	void(uielement_c this) menu_reinit = {
		uipicture_c resumebutton = (uipicture_c)this.partner;

		float search_length = 0;
		float sb = search_begin("data/profiles/*/menu.version", TRUE, TRUE);
		if (sb >= 0)
		{
			search_length = search_getsize(sb);
			search_end(sb);
		}

		resumebutton.flags |= UIFLAG::HIDE;
		if (search_length > 0)
			resumebutton.flags &= ~UIFLAG::HIDE;
	}

	menu_main = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_main.active_condition = menu_conditional;
		menu_main.reinit = menu_reinit;
	uilist_c menu_buttons = spawn(uilist_c, owner: menu_main, anchor: '0.5 0.45', justify: '0.5 0', origin: '0 0', size: '192 400', separation: '0 50');
	
	// logo
	spawn(uipicture_c, owner: menu_main, anchor: '0.5 0', justify: '0.5 0', origin: '0 64', size: '504 136', flags: UIFLAG::CLICKABLE, image: "gfx/menu/logo.tga");

	// begin button
	MenuInit_CreateProfile();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_createprofile;
		Run_Reinit_List(menu_createprofile);
	};
	uielement_c container = spawn(uielement_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '192 48', flags: UIFLAG::CLICKABLE);
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: container, anchor: '0.5 0.5', justify: '0.5 0.5', size: '352 58',
		image: menu_assets[MENU_IMG::BEGIN], image2: menu_assets[MENU_IMG::BEGIN_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::BEGIN]);
		lbutton.prerender = button_owner_highlight;
		lbutton.prerender_text = text_owner_highlight;
		container.m_click = button_click;
	
	// return button
	MenuInit_LoadProfile();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_loadprofile;
		Run_Reinit_List(menu_loadprofile);
	};
	uielement_c container = spawn(uielement_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '192 48', flags: UIFLAG::CLICKABLE);
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: container, anchor: '0.5 0.5', justify: '0.5 0.5', size: '352 58',
		image: menu_assets[MENU_IMG::RETURN], image2: menu_assets[MENU_IMG::RETURN_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::RETURN]);
		lbutton.prerender = button_owner_highlight;
		lbutton.prerender_text = text_owner_highlight;
		container.m_click = button_click;
		menu_main.partner = container;

	// options button
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uielement_c container = spawn(uielement_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '192 48', flags: UIFLAG::CLICKABLE);
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: container, anchor: '0.5 0.5', justify: '0.5 0.5', size: '352 58',
		image: menu_assets[MENU_IMG::OPTIONS], image2: menu_assets[MENU_IMG::OPTIONS_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::OPTIONS]);
		lbutton.prerender = button_owner_highlight;
		lbutton.prerender_text = text_owner_highlight;
		container.m_click = button_click;

	// achievements
	float(uielement_c this) achievement_conditional = {
		return (!(STEAM_IS_CONNECTED) && cltime > steam_initTime);
	}
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_achievements;
		Run_Reinit_List(menu_achievements);
	};
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: menu_main, anchor: '0.5 1', justify: '0.5 1', origin: '0 0', size: '352 58', flags: UIFLAG::CLICKABLE,
		image: menu_assets[MENU_IMG::ACHIEVEMENTS], image2: menu_assets[MENU_IMG::ACHIEVEMENTS_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::ACHIEVEMENTS], fallback_sz: '20 20');
		lbutton.active_condition = achievement_conditional;
		lbutton.prerender = button_highlight;
		lbutton.prerender_text = text_highlight;
		lbutton.m_click = button_click;

	// exit button
	// QUIT CONFIRM MENU
	menu_quitconfirm = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_quitconfirm.active_condition = menu_conditional;
	
	float(uielement_c this, float nkey, float ascii, float released) quit_input = {
		if (released)
			return;
		if (ascii == 'n' || nkey == K_ESCAPE)
		{
			localsound("sounds/menu.wav");
			menu_current = menu_main;
			Run_Reinit_List(menu_current);
		}
		else if (ascii == 'y')
		{
			localsound("sounds/menu.wav");
			cmd("quit\n");
		}

		return FALSE;
	};
	
	uielement_c quitconfirm_buttons = spawn(uielement_c, owner: menu_quitconfirm, anchor: '0.5 0.5', justify: '0.5 0', size: '192 32');
		quitconfirm_buttons.input = quit_input;

	spawn(uifill_c, owner: quitconfirm_buttons, anchor: '0.5 0', justify: '0.5 0', origin: '0 -64', size: '394 104', color: '0.05 0.05 0.05', alpha: 0.65);
	uitext_c txt = spawn(uitext_c, owner: quitconfirm_buttons, anchor: '0.5 0', origin: '0 -56', justify: '0.5 0', size: '24 24', text: quit_taunts[0], font: FONT_USER7);
		menu_quitconfirm.partner = txt; // partner is for taunt text
	uitext_c txt = spawn(uitext_c, owner: quitconfirm_buttons, anchor: '0.5 0', origin: '0 -32', justify: '0.5 0', size: '14 14', text: _("UI_QUITCONFIRM"), font: FONT_USER7);
	
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_main;
		Run_Reinit_List(menu_current);
	}
	uitext_c txtbutton = spawn(uitext_c, owner: quitconfirm_buttons, anchor: '0.5 0.5', justify: '0 0.5', origin: '-184 0', padding: '24 8',
		size: '32 32', text: _("UI_NO"), font: FONT_USER7, flags: UIFLAG::CLICKABLE);
		txtbutton.prerender = text_highlight;
		txtbutton.m_click = button_click;
	
	void(uielement_c this) button_click = {
		cmd("quit\n");
	}
	uitext_c txtbutton = spawn(uitext_c, owner: quitconfirm_buttons, anchor: '0.5 0.5', justify: '1 0.5', origin: '184 0', padding: '24 8',
		size: '32 32', text: _("UI_YES"), font: FONT_USER7, flags: UIFLAG::CLICKABLE);
		txtbutton.prerender = text_highlight;
		txtbutton.m_click = button_click;
	//
	
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_quitconfirm;
		uitext_c taunt = (uitext_c)menu_quitconfirm.partner;
		taunt.text = quit_taunts[floor(random(quit_taunts.length))];
	};
	uielement_c container = spawn(uielement_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '192 48', flags: UIFLAG::CLICKABLE);
	uilocpicture_c lbutton = spawn(uilocpicture_c, owner: container, anchor: '0.5 0.5', justify: '0.5 0.5', size: '352 58',
		image: menu_assets[MENU_IMG::DEPART], image2: menu_assets[MENU_IMG::DEPART_ACTIVE], fallback_txt: menu_assets_string[MENU_IMG::DEPART]);
		lbutton.prerender = button_owner_highlight;
		lbutton.prerender_text = text_owner_highlight;
		container.m_click = button_click;

	// Reki (February 18 2024): stupid hack to fix in DP lagging behind when disconnecting
	float(uielement_c this) hackfill_conditional = {
		return (clientstate() != CS_DISCONNECTED);
	}
	uifill_c hackfill = spawn(uifill_c, owner: menu_main, color: '0.01 0.01 0.01', flags: UIFLAG::STRETCH);
		hackfill.active_condition = hackfill_conditional;
}


void MenuInit_Achievements(void)
{
	static uielement_c achievement_menu_list[ST_ACHIEVEMENTS::MAX];

	// Reki (October 12 2023): Precache and allocate achievement icons
	for(float i = 0; i < ST_ACHIEVEMENTS::MAX; i++)
	{
		string ach_icon = sprintf("gfx/achievements/icon_%s.tga", strtolower(steam_achievementlist[i].name));
		if !(fexists_pak(ach_icon))
			ach_icon = "gfx/hud/messages/icons/msgicon_helm.tga";
		precache_pic(ach_icon);
		achnotify_icons[i] = strzone(ach_icon);
	}
	//

	float(uielement_c this, float nkey, float ascii, float released) achievement_input = {
		if (released)
			return FALSE;
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		if (in_game)
			menu_current = menu_main_game;
		else
			menu_current = menu_main;
		Run_Reinit_List(menu_current);

		return FALSE;
	};

	void(uielement_c this) achievement_reinit = {
		for(float i = 0; i < ST_ACHIEVEMENTS::MAX; i++)
		{
			uielement_c ach = achievement_menu_list[i];
			uitext_c txt = (uitext_c)ach.partner2;
			uipicture_c backdrop = (uipicture_c)ach.partner;

			if (steam_achievementlist[i].value)
			{
				txt.text = _("UI_UNLOCKED");
				txt.color = CONVERT_TO_DP_SHITTY_COLOR('0.4 0.9 0.7');
				//lck.flags |= UIFLAG::HIDE;

				while(backdrop)
				{
					backdrop.color = '1 1 1';
					backdrop = backdrop.partner;
				}
			}
			else
			{
				txt.text = _("UI_LOCKED");
				txt.color = CONVERT_TO_DP_SHITTY_COLOR('0.5 0 0');
				//lck.flags &= ~UIFLAG::HIDE;

				while(backdrop)
				{
					backdrop.color = '0.6 0.6 0.6';
					backdrop = backdrop.partner;
				}
			}
		}
	}

	void(uipicture_c this, __inout string img_to_render) scroll_prerender = { if (ui_hover == this) img_to_render = this.image2; };
	float(uielement_c this) scroll_conditional = {
		uilist_c list = (uilist_c)this.partner;

		// check if this scroll arrow should even show
		if (this.button_index > 0)
		{
			if (list.scroll >= (list.elements - list.scroll_count))
				return FALSE;
		}
		else if (list.scroll <= 0)
		{
			return FALSE;
		}
		//

		if (list.elements > list.scroll_count)
			return TRUE;
		return FALSE;
	}
	void(uielement_c this) scroll_click = {
		uilist_c list = (uilist_c)this.partner;
		list.scroll += this.button_index * 3;
		Journal_Sound();
	};

	ui_scale = '1 1';
	menu_achievements = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_achievements.active_condition = menu_conditional;
		menu_achievements.input = achievement_input;
		menu_achievements.reinit = achievement_reinit;

	uitext_c txt = spawn(uitext_c, owner: menu_achievements, anchor: '0.5 0', origin: '0 20', justify: '0.5 0', size: '16 16', text: _("UI_ACHIEVEMENTS"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	uilist_c column_list = spawn(uismoothlist_c, owner: menu_achievements, justify: '0.5 0', anchor: '0.5 0', origin: '0 60', size: '1024 384', separation: '0 48', flags: UIFLAG::CLIP);
	//uilist_c current_row;
	for(float i = 0; i < ST_ACHIEVEMENTS::MAX; i++)
	{	
		float mult = (i % 2);
		if (i % 2 == 0) // new row
		{
			//current_row = spawn(uielement_c, owner: column_list, size: '1024 96');//, separation: '178 0');
		}

		string disp_name = steam_achievementlist[i].display_name;
		string disp_desc = steam_achievementlist[i].display_desc;
		float o_font = drawfont; drawfont = FONT_CENTERPRINT;
		float max_width = max(stringwidth(disp_name, TRUE, '6 6'), stringwidth(disp_desc, TRUE, '4 4')) - 24;
		float segments_needed = max(1, round(max_width / 16));
		drawfont = o_font;

		uielement_c container = spawn(uielement_c, owner: column_list, anchor: '0.5 0', justify: '0.5 0', size: [48 + 48 + (segments_needed * 16), 48]);
		
		uielement_c backdroplist;
		float xpos = 0;
		container.partner = backdroplist = spawn(uipicture_c, owner: container, origin: [xpos, 0], size: '48 48', image: "gfx/achievements/achievementscrolls_left.tga"); xpos += 48;
		for(float j = 0; j < segments_needed; j++)
		{
			backdroplist.partner = spawn(uipicture_c, owner: container, origin: [xpos, 0], size: '16 48', image: ach_getnextscroll());
			backdroplist = backdroplist.partner;
			xpos += 16;
		}
		backdroplist.partner = spawn(uipicture_c, owner: container, origin: [xpos, 0], size: '48 48', image: "gfx/achievements/achievementscrolls_right.tga"); xpos += 48;


		/*
		string ach_icon = sprintf("gfx/achievements/icon_%s.tga", strtolower(steam_achievementlist[i].name));
		if !(fexists_pak(ach_icon))
		{
			spawn(uifill_c, owner: container, origin: '8 8', size: '32 32', color: '0.01 0.01 0.01', alpha: 0.8);
			ach_icon = "gfx/hud/messages/icons/msgicon_helm.tga";
		}
		*/
		spawn(uipicture_c, owner: container, origin: '8 8', size: '32 32', image: achnotify_icons[i]);


		//xpos += 16;
		//container.origin[0] -= xpos * mult;

		uielement_c textbody = spawn(uielement_c, owner: container, origin: '48 8');
		uitext_c cheevo = spawn(uitext_c, owner: textbody, origin: '0 4', text: _("UI_UNLOCKED"), size: '6 6', font: FONT_CENTERPRINT, alpha: 0.92, color: HIGHLIGHT_TEXT_COLOR);
		uitext_c cheevo_name = spawn(uitext_c, owner: textbody, origin: '0 16', text: disp_name, size: '6 6', font: FONT_CENTERPRINT, alpha: 0.87, color: CONVERT_TO_DP_SHITTY_COLOR('0 0 0'));
		uitext_c cheevo_desc = spawn(uitext_c, owner: textbody, origin: '0 26', text: disp_desc, size: '4 4', font: FONT_CENTERPRINT, alpha: 0.87, color: CONVERT_TO_DP_SHITTY_COLOR('0 0 0'));

		container.partner2 = cheevo;
		achievement_menu_list[i] = container;

		/*
		uifill_c backdrop = spawn(uifill_c, owner: current_row, size: '172 42', color: '0.6 0.6 0.6');
		achievement_menu_list[i] = backdrop;

		uifill_c middle = spawn(uifill_c, owner: backdrop, justify: '0.5 0.5', anchor: '0.5 0.5', size: '168 38', color: '0.1 0.1 0.1');

		uifill_c iconback = spawn(uifill_c, owner: middle, origin: '3 3', size: '32 32', color: '0.01 0.01 0.01');
		uipicture_c icon = spawn(uipicture_c, owner: iconback, flags: UIFLAG::STRETCH, image: "gfx/hud/messages/icons/msgicon_helm.tga");

		uielement_c textbody = spawn(uielement_c, owner: middle, origin: '38 4', size: '124 32');
		uitext_c cheevo = spawn(uitext_c, owner: textbody, origin: '0 4', text: _("UI_UNLOCKED"), size: '6 6', font: FONT_CENTERPRINT, color: HIGHLIGHT_TEXT_COLOR);
		uitext_c cheevo_name = spawn(uitext_c, owner: textbody, origin: '0 16', text: disp_name, size: '6 6', font: FONT_CENTERPRINT, color: '1 1 1');
		uitext_c cheevo_desc = spawn(uitext_c, owner: textbody, origin: '0 26', text: disp_desc, size: '4 4', font: FONT_CENTERPRINT, color: '0.6 0.6 0.6');
		
		uifill_c locked = spawn(uifill_c, owner: backdrop, flags: UIFLAG::STRETCH, color: '0.01 0.01 0.01', alpha: 0.8);

		backdrop.partner = cheevo;
		backdrop.partner2 = locked;
		*/
	}

	// scroll
	// scroll up
	uipicture_c scroll = spawn(uipicture_c, owner: menu_achievements, origin: '-156 60', anchor: '0.5 0', justify: '1 0', size: '32 40',
		flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/menu/a_arrow_up", image2: "gfx/menu/a_arrow_up_active", partner: column_list, button_index: -1);
		scroll.active_condition = scroll_conditional;
		scroll.prerender = scroll_prerender;
		scroll.m_click = scroll_click;
	// scroll down
	uipicture_c scroll = spawn(uipicture_c, owner: menu_achievements, origin: '-156 450', anchor: '0.5 0', justify: '1 1', size: '32 40',
		flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/menu/a_arrow_down", image2: "gfx/menu/a_arrow_down_active", partner: column_list, button_index: 1);
		scroll.active_condition = scroll_conditional;
		scroll.prerender = scroll_prerender;
		scroll.m_click = scroll_click;


	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		if (in_game)
			menu_current = menu_main_game;
		else
			menu_current = menu_main;
		Run_Reinit_List(menu_current);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_achievements, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
}

void MenuInit_Options(void)
{
	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
			return FALSE;
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		if (in_game)
			menu_current = menu_main_game;
		else
			menu_current = menu_main;
		Run_Reinit_List(menu_current);

		return FALSE;
	};
	
	ui_scale = '1 1';
	menu_options = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_options.active_condition = menu_conditional;
		menu_options.input = option_input;
	
	uilist_c menu_buttons = spawn(uilist_c, owner: menu_options, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380', origin: '0 -16', separation: '0 48');

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTIONS"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);


	// buttons

	// mouse
	MenuInit_Options_Mouse();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options_mouse;
		Run_Reinit_List(menu_options_mouse.reinit_list);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_MOUSE"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;

	// binds
	MenuInit_Options_Binds();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options_keybinds;
		Run_Reinit_List(menu_options_keybinds.reinit_list);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_BINDS"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;

	// controller
	MenuInit_Options_Controller();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options_controller;
		Run_Reinit_List(menu_options_controller.reinit_list);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_CONTROLLER"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;

	// video/graphics
	MenuInit_Options_Video();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options_graphics;
		Run_Reinit_List(menu_options_graphics.reinit_list);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_GRAPHICS"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;

	// resolution
	MenuInit_Options_Resolution();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options_resolution;
		Run_Reinit_List(menu_options_resolution.reinit_list);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_RESOLUTION"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;

	// audio
	MenuInit_Options_Audio();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options_audio;
		Run_Reinit_List(menu_options_audio.reinit_list);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_AUDIO"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;

	// gameplay
	MenuInit_Options_Gameplay();
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options_gameplay;
		Run_Reinit_List(menu_options_gameplay.reinit_list);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_GAMEPLAY"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	
	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		if (in_game)
			menu_current = menu_main_game;
		else
			menu_current = menu_main;
		Run_Reinit_List(menu_current);
	}
	uitext_c txt = spawn(uitext_c, owner: menu_options, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 30');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
}

.void(uielement_c slider, __inout float frac) bar_change;
.float bar_frac;
.float bar_scrollamt;
uielement_c slider_selected;
uielement_c slider_scroll_selected;
float slider_scroll_autotime;
uielement_c UI_Sliderbar(uielement_c own, vector org, vector anc, vector just, vector sz)
{
	// partner = slider tick
	// partner2 = scroll left
	// partner3 = scroll right
	// partner6 = bar

	void(uielement_c this, __inout vector position) bar_preloop = {
		uitext_c scroll_left = (uitext_c)this.partner2;
		uitext_c scroll_right = (uitext_c)this.partner3;
		uifill_c bar_back = (uifill_c)this.partner6;
		uifill_c slider = (uifill_c)this.partner;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (slider_selected == this || (!slider_selected && (ui_hover == this || ui_oldhover == scroll_left || ui_oldhover == scroll_right)))
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}

		if (slider_selected == this)
		{
			float frac = (ui_mouseposition[0] - ui_position[0]) / (this.size[0] * ui_scale[0]);
			frac = bound(0, frac, 1);
			if (this.bar_change)
				this.bar_change(slider, frac);
			this.bar_frac = frac;
		}
		
		// default slider 0-1 text
		if (!this.bar_change)
		{
			uitext_c txt = (uitext_c)slider.partner;
			if (txt.text)
				strunzone(txt.text);
			txt.text = strzone(sprintf("%.2f", this.bar_frac));
		}
		//

		slider.origin[0] = this.size[0] * this.bar_frac;
	};
	float(uielement_c this, float nkey, float ascii, float released) bar_input = {
		if (nkey != K_MOUSE1)
			return FALSE;
		
		if (released)
		{
			if (slider_selected == this)
				slider_selected = 0;
		}
		else
		{
			if (INBOUNDS(ui_mouseposition, ui_position, (ui_position + [this.size[0] * ui_scale[0], this.size[1] * ui_scale[1]])))
			{
				slider_selected = this;
			}
		}

		return FALSE;
	}
	void(uitext_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) scroll_button_predraw = {
		if (ui_hover == this && !slider_selected)
			color_to_render = HIGHLIGHT_TEXT_COLOR;
	};
	float(uielement_c this, float nkey, float ascii, float released) scroll_button_input = {
		if (slider_scroll_selected != this)
			return FALSE;
		
		if (nkey == K_MOUSE1 && released)
			slider_scroll_selected = 0;

		return FALSE;
	};
	void(uielement_c this, __inout vector position) scroll_button_preloop = {
		if (slider_scroll_selected == this)
		{
			if (!INBOUNDS(ui_mouseposition, ui_position, (ui_position + this.totalsize())))
			{
				slider_scroll_selected = 0;
				return;
			}

			if (time > slider_scroll_autotime) // do auto repeat
			{
				localsound("sounds/menu.wav");
				uielement_c bar = this.owner;
				uifill_c slider = (uifill_c)bar.partner;

				slider_scroll_autotime = time + 0.1;

				float frac = bar.bar_frac + (bar.bar_scrollamt * this.bar_scrollamt);
				frac = bound(0, frac, 1);
				if (bar.bar_change)
					bar.bar_change(slider, frac);
				bar.bar_frac = frac;
			}
		}
	};
	void(uielement_c this) scroll_button_click = {
		if (this.owner)
		{
			localsound("sounds/menu.wav");
			uielement_c bar = this.owner;
			uifill_c slider = (uifill_c)bar.partner;

			slider_scroll_selected = this;
			slider_scroll_autotime = time + 0.3;

			float frac = bar.bar_frac + (bar.bar_scrollamt * this.bar_scrollamt);
			frac = bound(0, frac, 1);
			if (bar.bar_change)
				bar.bar_change(slider, frac);
			bar.bar_frac = frac;
		}
	};

	uielement_c bar = spawn(uielement_c, owner: own, origin: org, anchor: anc, justify: just, size: sz + '0 24', flags: UIFLAG::HIGHLIGHT);
		bar.preloop = bar_preloop;
		bar.input = bar_input;
		bar.bar_scrollamt = 0.05;
	// bar itself
	bar.partner6 = spawn(uifill_c, owner: bar, justify: '0 0.5', anchor: '0 0.5', size: sz, color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// scroll buttons
	float scroll_sz = sz[1] + 12;
	bar.partner2 = spawn(uitext_c, owner: bar, anchor: '0 0.5', justify:'0 0.5', origin: '-24 2', size: [scroll_sz, scroll_sz], color: '1 1 1', alpha: 0.9, text: "<", flags: UIFLAG::CLICKABLE, bar_scrollamt: -1);
		((uitext_c)bar.partner2).prerender = scroll_button_predraw;
		bar.partner2.m_click = scroll_button_click;
		bar.partner2.preloop = scroll_button_preloop;
		bar.partner2.input = scroll_button_input;
	bar.partner3 = spawn(uitext_c, owner: bar, anchor: '1 0.5', justify:'1 0.5', origin: '24 2', size: [scroll_sz, scroll_sz], color: '1 1 1', alpha: 0.9, text: ">", flags: UIFLAG::CLICKABLE, bar_scrollamt: 1);
		((uitext_c)bar.partner3).prerender = scroll_button_predraw;
		bar.partner3.m_click = scroll_button_click;
		bar.partner3.preloop = scroll_button_preloop;
		bar.partner3.input = scroll_button_input;
	
	// slider tick and number text
	bar.partner = spawn(uifill_c, owner: bar, anchor: '0 0.5', justify: '0.5 0.5', size: [sz[1], sz[1] + 12], color: OPTIONS_HEADER_COLOR * 0.8, alpha: 1);
	bar.partner.partner = spawn(uitext_c, owner: bar.partner, origin: '0 -2', anchor: '0.5 0', justify: '0.5 1', size: '10 10', text: strzone("1.0"), color: OPTIONS_HEADER_TEXT_COLOR);

	return bar;
}

typedef struct keybind_t {
	string name;
	string cmd;
	float key;
};
.keybind_t key_bind;
.string glyph_code;

uipicture_c controller_diagram;
float controllerdiagram_reset;
string controller_presetnames[] = {
	_("UI_CONTROLLER_PRESET0"),
	_("UI_CONTROLLER_PRESET1"),
	_("UI_CONTROLLER_PRESET2"),
};

void MenuInit_Options_Controller(void)
{
	void(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
			return FALSE;
		
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_options;

		return FALSE;
	};

	void(uielement_c this, __inout vector position) option_preloop = {
		if (controllerdiagram_reset && cltime > controllerdiagram_reset)
		{
			Run_Reinit_List(controller_diagram);
			controllerdiagram_reset = 0;
		}
	};
	
	ui_scale = '1 1';
	menu_options_controller = spawn(uielement_c, flags: UIFLAG::STRETCH);
	menu_options_controller.active_condition = menu_conditional;
	menu_options_controller.input = option_input;
	menu_options_controller.preloop = option_preloop;

	uilist_c menu_buttons_left = spawn(uilist_c, owner: menu_options_controller, origin: '-140 52', anchor: '0.5 0.5', justify: '0.5 0', size: '192 380', separation: '0 36');
	uilist_c menu_buttons_right = spawn(uilist_c, owner: menu_options_controller, origin: '140 52', anchor: '0.5 0.5', justify: '0.5 0', size: '192 380', separation: '0 36');
	
	uielement_c frame = spawn(uielement_c, owner: menu_options_controller, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380');
	uitext_c txt = spawn(uitext_c, owner: frame, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_CONTROLLER"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Diagram
	vector controllerdiagram_textpos[] = {
		// dpad
		'-135 -30',
		'-135 60',
		'-135 0',
		'-135 30',

		// start/select
		//'165 100',
		//'-165 100',
		'20 100',
		'-20 100',

		// leftstick/rightstick
		//'-20 100',
		//'20 100',
		'-20 80',
		'20 80',

		// leftbumper/rightbumper
		'-80 -56',
		'80 -56',

		// a/b/x/y
		'135 60',
		'135 30',
		'135 0',
		'135 -30',

		// lefttrigger/righttrigger
		'-63 -78',
		'63 -78',

		// leftstick/rightstick movement
		//'-20 75',
		//'20 75',
	};

	string controllerdiagram_glpyh[] = {
		"816",
		"817",
		"818",
		"819",
		
		"820",
		"821",

		"822",
		"823",
		
		"824",
		"825",
		
		"826",
		"827",
		"828",
		"829",
		
		"830",
		"831",
		
		//"ls",
		//"rs",
	};

	void(uipicture_c this, __inout string img_to_render) glyph_prerender = {
		img_to_render = Controller_GetGlyph_Fallback(this.glyph_code, CONTROLLER::STEAM);
	};

	void(uielement_c this) glyph_reinit = {
		keybind_t controllerdiagram_validcontrols[] = {
			{_("UI_CONTROL_MOVEFORWARD"), "+forward", 0},
			{_("UI_CONTROL_MOVEBACK"), "+back", 0},
			{_("UI_CONTROL_MOVELEFT"), "+moveleft", 0},
			{_("UI_CONTROL_MOVERIGHT"), "+moveright", 0},
			{_("UI_CONTROL_JUMP"), "+jump", 0},
			{_("UI_CONTROL_CROUCH"), "+button4", 0},
			{_("UI_CONTROL_FIRE"), "+attack", 0},
			{_("UI_CONTROL_ALTFIRE"), "+button3", 0},
			{_("UI_CONTROL_USE"), "+button5", 0},
			{_("UI_CONTROL_ZOOM"), "+zoom", 0},
			{_("UI_CONTROL_ZOOM_TOGGLE"), "togglezoom", 0},
			{_("NOTIFY_WEP_BLADE"), "impulse 1", 0},
			{_("NOTIFY_WEP_REVOLVER"), "impulse 2", 0},
			{_("NOTIFY_WEP_SHOTGUN"), "impulse 3", 0},
			{_("NOTIFY_WEP_SPITTER"), "impulse 4", 0},
			{_("NOTIFY_WEP_RETCHER"), "impulse 5", 0},
			{_("NOTIFY_WEP_SLAGCANNON"), "impulse 6", 0},
			{_("NOTIFY_WEP_LANCE"), "impulse 7", 0},
			{_("NOTIFY_WEP_BOILER"), "impulse 8", 0},
			{_("NOTIFY_WEP_MACE"), "impulse 9", 0},
			{_("UI_CONTROL_JOURNAL"), "impulse 35", 0},
			{_("UI_CONTROL_WALK"), "+button7", 0},
			{_("UI_CONTROL_SWIMUP"), "+moveup", 0},
			{_("UI_CONTROL_SWIMDOWN"), "+movedown", 0},
			{_("UI_CONTROL_LASTWEAPON"), "impulse 57", 0},
			{_("UI_CONTROL_NEXTWEAPON"), "impulse 55", 0},
			{_("UI_CONTROL_PREVWEAPON"), "impulse 56", 0},
			{_("UI_CONTROL_ARTIFACT_NEXT"), "impulse 17", 0},
			{_("UI_CONTROL_ARTIFACT_PREV"), "impulse 16", 0},
			{_("UI_CONTROL_INVENTORY"), "+button6", 0},
			{_("UI_CONTROL_ARTIFACT_USE"), "impulse 15", 0},
			{_("UI_CONTROL_SOULTETHER"), "impulse 81", 0},
			{_("UI_CONTROL_LOADMENU"), "impulse 89", 0},
			{_("UI_CONTROL_PAUSE"), "togglemenu", 0},
		};
		
		uitext_c hint = (uitext_c)this.partner;
		float keynum = stof(this.glyph_code);
		if (keynum <= 0)
			return;
		string cmd = getkeybind_bindmap(keynum, 0);
		string cmd_name = __NULL__;

		for(float i = 0; i < controllerdiagram_validcontrols.length; i++)
		{
			if (controllerdiagram_validcontrols[i].cmd != cmd)
				continue;
			cmd_name = controllerdiagram_validcontrols[i].name;
		}

		if (hint.text)
			strunzone(hint.text);

		hint.text = cmd;
		if (cmd_name)
			hint.text = cmd_name;

		hint.text = strzone(hint.text);
	};

	uipicture_c diagram = spawn(uipicture_c, owner: frame, origin: '0 34', anchor :'0.5 0', justify: '0.5 0', size: '200 130', glyph_code: "diagram", image: "gfx/glyphs/steam/diagram.tga");
		diagram.prerender = glyph_prerender;
		menu_options_controller.partner = diagram;
	Add_To_Reinit_List(menu_options_controller, diagram);
	controller_diagram = diagram;

	spawn(uifill_c, owner: diagram, anchor: '0.5 1', justify: '0.5 0', origin: '0 50', size: '340 2', color: OPTIONS_HEADER_COLOR, alpha: 0.3);



	uielement_c box = spawn(uielement_c, owner: diagram, anchor: '0.5 0.5', justify: '0.5 0.5', size: '400 160');

	for(float i = 0; i < controllerdiagram_glpyh.length; i++)
	{
		vector pos = controllerdiagram_textpos[i];
		uipicture_c glyph = spawn(uipicture_c, owner: box, justify: '0.5 0.5', anchor: '0.5 0.5', size: '20 20',
			origin: pos, glyph_code: controllerdiagram_glpyh[i]
		);	glyph.prerender = glyph_prerender;
			glyph.reinit = glyph_reinit;
			Add_To_Reinit_List(diagram, glyph);

		uitext_c hint = spawn(uitext_c, owner: glyph, size: '9 9', text: strzone(" "));
			glyph.partner = hint;
		if (pos[0] < 0)
		{
			hint.justify = '1 0.5';
			hint.anchor = '0 0.5';
			hint.origin += '-2 0';
		}
		else
		{
			hint.justify = '0 0.5';
			hint.anchor = '1 0.5';
			hint.origin += '2 0';
		}
	}

	//uipicture_c lines = spawn(uipicture_c, owner: diagram, anchor :'0.5 0.5', justify: '0.5 0.5', size: '400 260', image: "gfx/diagram_lines.tga");
	//vector pos = controllerdiagram_textpos[17];
	//spawn(uitext_c, owner: lines, origin: pos, size: '8 8', justify: '0 1', text: _("UI_AIM"));
	/*
	for(float i = 0; i < controllerdiagram_steam_pos.length; i++)
	{
		vector diagrampos = controllerdiagram_steam_pos[i];
		diagrampos[0] *= diagram.size[0];
		diagrampos[1] *= diagram.size[1];
		
		spawn(uifill_c, owner: diagram, origin: diagrampos, justify: '0.5 0.5', size: '4 4', color: '1 0.2 0.2');
	}
	*/

	// controller presets
	#define SLIDER_MIN 0
	#define SLIDER_MAX (controller_presetnames.length - 1)
	#define CHUNKS (SLIDER_MAX)
	#define OPT_CVAR "joy_x360_preset"
	static float preset_val;
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		value = bound(SLIDER_MIN, value, SLIDER_MAX);
			
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%s", controller_presetnames[value]));
		//cmd("set ", OPT_CVAR, " ", ftos(-value), "\n");
		if (preset_val != value)
		{
			preset_val = value;
			cmd("set joy_x360_preset ", ftos(value), "\n");
			cmd(sprintf("exec gamebuttons_controller_preset%.0f.cfg\n", value));
			controllerdiagram_reset = cltime + 0.05;
		}
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		preset_val = value;
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);
		value = bound(0, value, controller_presetnames.length - 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%s", controller_presetnames[value]));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CONTROLLER_CONTROLS"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '100 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_controller, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// 
	#define OPT_CVAR "joy_x360_rumble"
	void(uielement_c this) option_click = {
		float val = !cvar(OPT_CVAR);
		cmd("seta ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR))
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CONTROLLER_RUMBLE"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c boxsel = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		boxsel.partner = spawn(uifill_c, owner: boxsel, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		boxsel.m_click = option_click;
		boxsel.preloop = option_preloop;
	#undef OPT_CVAR
	//

	// yaw sensitivity
	#define SLIDER_MIN -5
	#define SLIDER_MAX 5
	#define CHUNKS 100
	#define OPT_CVAR "joy_x360_sensitivityyaw"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
			
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("seta ", OPT_CVAR, " ", ftos(-value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = -cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CONTROLLER_YAW"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '100 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_controller, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// pitch sensitivity
	#define SLIDER_MIN -5
	#define SLIDER_MAX 5
	#define CHUNKS 100
	#define OPT_CVAR "joy_x360_sensitivitypitch"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
			
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("seta ", OPT_CVAR, " ", ftos(-value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = -cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CONTROLLER_PITCH"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '100 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_controller, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// aim acceleration
	#define SLIDER_MIN 0
	#define SLIDER_MAX 1
	#define CHUNKS 20
	#define OPT_CVAR "joy_x360_acceleration"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
			
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("seta ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_MOUSE_ACCEL"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '100 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_controller, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//


	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_controller, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//
}

void MenuInit_Options_Mouse(void)
{
	void(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
			return FALSE;
		
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_options;

		return FALSE;
	};
	
	ui_scale = '1 1';
	menu_options_mouse = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_options_mouse.active_condition = menu_conditional;
		menu_options_mouse.input = option_input;

	uilist_c menu_buttons = spawn(uilist_c, owner: menu_options_mouse, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380', separation: '0 52');
	
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_MOUSE"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_mouse, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//

	// mouse sensitivity
	#define SLIDER_MAX 10
	#define OPT_CVAR "sensitivity"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * (SLIDER_MAX * 10)) / (SLIDER_MAX * 10);
		float msens = frac * SLIDER_MAX;
		
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.1f", msens));
		cmd("set ", OPT_CVAR, " ", ftos(msens), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float msens = cvar(OPT_CVAR);
		this.bar_frac = msens / SLIDER_MAX;
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.1f", msens));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_MOUSE_SENSITIVITY"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '256 4');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = 1/(SLIDER_MAX * 5);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_mouse, slider);
	#undef SLIDER_MAX
	#undef OPT_CVAR
	//

	// mouse acceleration
	#define SLIDER_MAX 2
	#define OPT_CVAR "m_accelerate"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * (SLIDER_MAX * 100)) / (SLIDER_MAX * 100);
		float msens = frac * SLIDER_MAX;
		
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", msens));
		cmd("set ", OPT_CVAR, " ", ftos(msens), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float msens = cvar(OPT_CVAR);
		this.bar_frac = msens / SLIDER_MAX;
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", msens));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_MOUSE_ACCEL"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '256 4');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = 1/(SLIDER_MAX * 20);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_mouse, slider);
	#undef SLIDER_MAX
	#undef OPT_CVAR
	//

	// mouse smoothing
	#define OPT_CVAR "m_filter"
	void(uielement_c this) option_click = {
		float val = !cvar(OPT_CVAR);
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR))
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_MOUSE_SMOOTH"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '24 24', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '16 16', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	//

	// mouse invert
	#if 0
	#define OPT_CVAR "m_yaw"
	void(uielement_c this) option_click = {
		float val;
		if (cvar(OPT_CVAR) == 0.022)
			val = -0.022;
		else
			val = 0.022;
		
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == -0.022)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_MOUSE_INVERTX"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '24 24', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '16 16', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#endif
	//

	// mouse invert
	#define OPT_CVAR "m_pitch"
	void(uielement_c this) option_click = {
		float val;
		if (cvar(OPT_CVAR) == 0.022)
			val = -0.022;
		else
			val = 0.022;
		
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == -0.022)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_MOUSE_INVERTY"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '24 24', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '16 16', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	//
}

uielement_c currentbind_button;
float key_waitingforinput;
uielement_c fill_waitforinput;

void(uielement_c this) bind_fixtext = {
	keybind_t bind = this.key_bind;
	string key_str;
	if (bind.key >= 0)
		key_str = keynumtostring(bind.key);
	else
		key_str = "";

	uitext_c txt = (uitext_c)this.partner;
	if (!txt)
		return;
	if (txt.text)
		strunzone(txt.text);
	txt.text = strzone(key_str);

	vector o_uiscale = ui_scale;
	ui_scale = '1 1';
	this.size[0] = txt.totalsize()[0] + 4;
	this.size[0] = max(this.size[1], this.size[0]);
	ui_scale = o_uiscale;
}

void MenuInit_Options_Binds(void)
{
	void(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
			return FALSE;
		
		if (nkey != K_ESCAPE || key_waitingforinput)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_options;

		return FALSE;
	};

	void(uielement_c this, __inout vector pos) option_preloop = {
		if (!ui_renderframe)
			return;
		
		if (key_waitingforinput == 2)
		{
			Run_Reinit_List(menu_options_keybinds);
			key_waitingforinput = FALSE;
		}
	}
	
	ui_scale = '1 1';
	menu_options_keybinds = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_options_keybinds.active_condition = menu_conditional;
		menu_options_keybinds.input = option_input;
		menu_options_keybinds.preloop = option_preloop;

	uielement_c menu_buttons = spawn(uielement_c, owner: menu_options_keybinds, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380');
	
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_BINDS"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_keybinds, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//

	keybind_t binds_lane1[] = {
		{_("UI_CONTROL_MOVEFORWARD"), "+forward", 0},
		{_("UI_CONTROL_MOVEBACK"), "+back", 0},
		{_("UI_CONTROL_MOVELEFT"), "+moveleft", 0},
		{_("UI_CONTROL_MOVERIGHT"), "+moveright", 0},
		{_("UI_CONTROL_JUMP"), "+jump", 0},
		{_("UI_CONTROL_CROUCH"), "+button4", 0},
		{_("UI_CONTROL_FIRE"), "+attack", 0},
		{_("UI_CONTROL_ALTFIRE"), "+button3", 0},
		{_("UI_CONTROL_USE"), "+button5", 0},
		{_("UI_CONTROL_ZOOM"), "+zoom", 0},
		{_("UI_CONTROL_ZOOM_TOGGLE"), "togglezoom", 0},
	};

	keybind_t binds_lane2[] = {
		{_("NOTIFY_WEP_BLADE"), "impulse 1", 0},
		{_("NOTIFY_WEP_REVOLVER"), "impulse 2", 0},
		{_("NOTIFY_WEP_SHOTGUN"), "impulse 3", 0},
		{_("NOTIFY_WEP_SPITTER"), "impulse 4", 0},
		{_("NOTIFY_WEP_RETCHER"), "impulse 5", 0},
		{_("NOTIFY_WEP_SLAGCANNON"), "impulse 6", 0},
		{_("NOTIFY_WEP_LANCE"), "impulse 7", 0},
		{_("NOTIFY_WEP_BOILER"), "impulse 8", 0},
		{_("NOTIFY_WEP_MACE"), "impulse 9", 0},
		{_("UI_CONTROL_JOURNAL"), "impulse 35", 0},
	};

	keybind_t binds_lane3[] = {
		{_("UI_CONTROL_WALK"), "+button7", 0},
		{_("UI_CONTROL_SWIMUP"), "+moveup", 0},
		{_("UI_CONTROL_SWIMDOWN"), "+movedown", 0},
		{_("UI_CONTROL_LASTWEAPON"), "impulse 57", 0},
		{_("UI_CONTROL_NEXTWEAPON"), "impulse 55", 0},
		{_("UI_CONTROL_PREVWEAPON"), "impulse 56", 0},
		{_("UI_CONTROL_ARTIFACT_NEXT"), "impulse 17", 0},
		{_("UI_CONTROL_ARTIFACT_PREV"), "impulse 16", 0},
		{_("UI_CONTROL_INVENTORY"), "+button6", 0},
		{_("UI_CONTROL_ARTIFACT_USE"), "impulse 15", 0},
		{_("UI_CONTROL_SOULTETHER"), "impulse 81", 0},
		{_("UI_CONTROL_LOADMENU"), "impulse 89", 0},
	};

	void(uielement_c this) bind_reinit = {
		tokenize(findkeysforcommand(this.key_bind.cmd, 0));
		float keycode = 0;
		for(float i = 0; i < 16; i++) // make sure we get a KB+M bind and not a controller
		{
			float val = stof(argv(i));
			if (!val)
				continue;
			if (!IS_KBM_KEY(bind_gettype(val)))
				continue;
				
			keycode = val;
			break;
		}

		this.key_bind.key = keycode;
		bind_fixtext(this);
	};
	void(uielement_c this) bind_click = {
		if (key_waitingforinput)
			return;

		if (input_mode != IN_MODE_KEYBOARD && input_mode != IN_MODE_MOUSE)
			return;
		
		key_waitingforinput = TRUE;
		currentbind_button = this;
	};
	void(uitext_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) bind_text_prerender = {
		if (key_waitingforinput)
		{
			if (this.partner.key_bind.cmd == currentbind_button.key_bind.cmd)
				color_to_render = HIGHLIGHT_TEXT_COLOR;
			return;
		}
		
		if (ui_oldhover == this.partner)
			color_to_render = HIGHLIGHT_TEXT_COLOR;
	};
	
	vector shift = '0 56';
	vector offs_list = '-192 0' + shift;
	for(float i = 0; i < binds_lane1.length; i++)
	{
		keybind_t bind = binds_lane1[i];
		uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-48 0' + offs_list, justify: '0.8 0.5', size: '10 10', text: bind.name, font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
		uifill_c box = spawn(uifill_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0' + offs_list, justify: '0.2 0.5', size: '16 16', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
			box.partner = spawn(uitext_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '10 10', color: '1 1 1', alpha: 0.9, text: strzone("t"));
			box.partner2 = txt;
			box.key_bind = bind;
			box.reinit = bind_reinit;
			box.m_click = bind_click;
		txt.partner = box;
		txt.prerender = bind_text_prerender;
		Add_To_Reinit_List(menu_options_keybinds, box);
		offs_list += '0 26';
	}

	vector offs_list = '64 0' + shift;
	for(float i = 0; i < binds_lane2.length; i++)
	{
		keybind_t bind = binds_lane2[i];
		uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-48 0' + offs_list, justify: '0.8 0.5', size: '10 10', text: bind.name, font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
		uifill_c box = spawn(uifill_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0' + offs_list, justify: '0.2 0.5', size: '16 16', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
			box.partner = spawn(uitext_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '10 10', color: '1 1 1', alpha: 0.9, text: strzone("t"));
			box.partner2 = txt;
			box.key_bind = bind;
			box.reinit = bind_reinit;
			box.m_click = bind_click;
		txt.partner = box;
		txt.prerender = bind_text_prerender;
		Add_To_Reinit_List(menu_options_keybinds, box);
		offs_list += '0 26';
	}

	vector offs_list = '320 0' + shift;
	for(float i = 0; i < binds_lane3.length; i++)
	{
		keybind_t bind = binds_lane3[i];
		uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-48 0' + offs_list, justify: '0.8 0.5', size: '10 10', text: bind.name, font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
		uifill_c box = spawn(uifill_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 0' + offs_list, justify: '0.2 0.5', size: '16 16', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
			box.partner = spawn(uitext_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '10 10', color: '1 1 1', alpha: 0.9, text: strzone("t"));
			box.partner2 = txt;
			box.key_bind = bind;
			box.reinit = bind_reinit;
			box.m_click = bind_click;
		txt.partner = box;
		txt.prerender = bind_text_prerender;
		Add_To_Reinit_List(menu_options_keybinds, box);
		offs_list += '0 26';
	}


	float(uielement_c this) waitforinput_conditional = {
		if (key_waitingforinput == TRUE)
			return TRUE;
		return FALSE;
	};
	void(uielement_c this, __inout vector position) waitforinput_preloop = {
		uitext_c bind_prompt = (uitext_c)this.partner;
		bind_prompt.text = sprintf(_("UI_BINDPROMPT"), currentbind_button.key_bind.name);
	};
	float(uielement_c this, float nkey, float ascii, float released) waitforinput_input = {
		if (released)
			return FALSE;
		
		if (!nkey)
			return FALSE;
		
		if (!currentbind_button)
			return FALSE;
		
		if (nkey == K_ESCAPE)
		{
			key_waitingforinput = FALSE;
			return FALSE;
		}

		if (!IS_KBM_KEY(bind_gettype(nkey))) // we only want KB+M binds here
			return FALSE;
		
		float argc = tokenize(findkeysforcommand(currentbind_button.key_bind.cmd, 0));
		for(float i = 0; i < argc; i++)
		{
			if !(argv(i))
				continue;

			float keynum = stof(argv(i));
			if (keynum <= 1)
				continue;

			float keynumtype = bind_gettype(keynum);
			if (!IS_KBM_KEY(keynumtype))
				continue;
			
			cmd("in_unbind 0 ", keynumtostring(keynum), "\n");
		}
		
		if (nkey == K_DEL || nkey == K_BACKSPACE)
		{
			currentbind_button.key_bind.key = 0;
		}
		else
		{
			cmd("in_unbind 0 ", keynumtostring(nkey), "\n");
			cmd("in_bind 0 ", keynumtostring(nkey), " \"", currentbind_button.key_bind.cmd, "\"\n");
			setkeybind_bindmap(nkey, currentbind_button.key_bind.cmd, 0);
			currentbind_button.key_bind.key = nkey;
		}

		key_waitingforinput = 2;
		Run_Reinit_List(menu_options_keybinds);

		// ugh, I was trying to avoid this but it seems like some race condition makes
		// the input map not respond instantly, damn cmd()
		///*
		string key_str;
		key_str = keynumtostring(nkey);
		uitext_c txt = (uitext_c)currentbind_button.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(key_str);

		vector o_uiscale = ui_scale;
		ui_scale = '1 1';
		currentbind_button.size[0] = txt.totalsize()[0] + 4;
		currentbind_button.size[0] = max(currentbind_button.size[1], currentbind_button.size[0]);
		ui_scale = o_uiscale;
		//*/
		//

		return FALSE;
	};
	fill_waitforinput = spawn(uifill_c, owner: menu_options_keybinds, flags: UIFLAG::STRETCH, color: '-1 -1 -1', alpha: 0.9);
		fill_waitforinput.active_condition = waitforinput_conditional;
		fill_waitforinput.preloop = waitforinput_preloop;
		fill_waitforinput.input = waitforinput_input;
	
	uitext_c txt = spawn(uitext_c, owner: fill_waitforinput, anchor: '0.5 0.5', origin: '0 0', justify: '0.5 0.5', size: '14 14', font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	fill_waitforinput.partner = txt;

	uitext_c txt = spawn(uitext_c, owner: fill_waitforinput, anchor: '0.5 0.5', origin: '0 16', justify: '0.5 0.5', size: '14 14', text: _("UI_PRESSANYKEY"), font: FONT_MENU, color: HIGHLIGHT_TEXT_COLOR);
}

void MenuInit_Options_Video(void)
{
	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
			return FALSE;
		
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_options;

		return FALSE;
	};
	
	ui_scale = '1 1';
	menu_options_graphics = spawn(uielement_c, flags: UIFLAG::STRETCH);
	menu_options_graphics.active_condition = menu_conditional;
	menu_options_graphics.input = option_input;

	uilist_c menu_buttons = spawn(uilist_c, owner: menu_options_graphics, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380', separation: '0 38');
	uilist_c menu_buttons_left = spawn(uilist_c, owner: menu_options_graphics, origin: '48 52', anchor: '0.5 0.5', justify: '1 0.5', size: '400 380', separation: '0 38');
	uilist_c menu_buttons_right = spawn(uilist_c, owner: menu_options_graphics, origin: '48 52', anchor: '0.5 0.5', justify: '0 0.5', size: '400 380', separation: '0 38');
	
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_GRAPHICS"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_graphics, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//

	// brightness
	#define SLIDER_MIN 0
	#define SLIDER_MAX 2
	#define CHUNKS 40
	#define OPT_CVAR "r_hdr_scenebrightness"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_BRIGHTNESS"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// gamma
	#define SLIDER_MIN 0
	#define SLIDER_MAX 2
	#define CHUNKS 40
	#define OPT_CVAR "v_gamma"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_GAMMA"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// contrast
	#define SLIDER_MIN 0
	#define SLIDER_MAX 2
	#define CHUNKS 40
	#define OPT_CVAR "v_contrast"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CONTRAST"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// saturation
	#define SLIDER_MIN 0.5
	#define SLIDER_MAX 1.5
	#define CHUNKS 20
	#define OPT_CVAR "r_glsl_saturation"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_SATURATION"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// empty slot
	spawn(uielement_c, owner: menu_buttons_left);
	//

	// dynamic lights
	#define OPT_CVAR "r_dynamic"
	void(uielement_c this) option_click = {
		float val = !cvar(OPT_CVAR);
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR))
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_DYNAMICLIGHTS"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	//

	// anisotropic filtering
	static string aniso_str[] = {
		"None",
		"2x",
		"4x",
		"8x",
		"16x",
	};
	static float aniso_val[] = {
		0,
		2,
		4,
		8,
		16,
	};
	#define CHUNKS (aniso_val.length - 1)
	#define OPT_CVAR "gl_texture_anisotropy"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float index = bound(0, round(CHUNKS * frac), CHUNKS);
		float value = aniso_val[index];
		
		uitext_c txt = (uitext_c)slider.partner;
		txt.text = aniso_str[index];
		cmd("set ", OPT_CVAR, " ", ftos(aniso_val[index]), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		uitext_c txt = (uitext_c)this.partner.partner;

		for(float i = 0; i < aniso_val.length; i++)
		{
			if (value == aniso_val[i])
			{
				txt.text = aniso_str[i];
				this.bar_frac = (i / CHUNKS);
				this.bar_frac = bound(0, this.bar_frac, 1);
				return;
			}
		}

		this.bar_frac = 1;
		txt.text = "CUSTOM";
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_ANISOTROPICFILTERING"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// msaa
	static string msaa_str[] = {
		"None",
		"2x",
		"4x",
		"8x",
	};
	static float msaa_val[] = {
		0,
		2,
		4,
		8
	};
	#define CHUNKS (msaa_val.length - 1)
	#define OPT_CVAR "vid_samples"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float index = bound(0, round(CHUNKS * frac), CHUNKS);
		float value = msaa_val[index];
		
		uitext_c txt = (uitext_c)slider.partner;
		txt.text = msaa_str[index];
		cmd("set ", OPT_CVAR, " ", ftos(msaa_val[index]), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		uitext_c txt = (uitext_c)this.partner.partner;

		for(float i = 0; i < msaa_val.length; i++)
		{
			if (value == msaa_val[i])
			{
				txt.text = msaa_str[i];
				this.bar_frac = (i / CHUNKS);
				this.bar_frac = bound(0, this.bar_frac, 1);
				return;
			}
		}

		this.bar_frac = 1;
		txt.text = "CUSTOM";
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_MSAA"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef OPT_CVAR
	#undef CHUNKS
	//




	// max fps
	static string maxfps_str[] = {
		"60",
		"120",
		"144",
		"170",
		"240",
		"360",
		"500",
		"720",
		"Unlimited",
	};
	static float maxfps_val[] = {
		60,
		120,
		144,
		170,
		240,
		360,
		500,
		720,
		1000,
	};
	#define CHUNKS (maxfps_val.length - 1)
	#define OPT_CVAR "cl_maxfps"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float index = bound(0, round(CHUNKS * frac), CHUNKS);
		float value = maxfps_val[index];
		
		uitext_c txt = (uitext_c)slider.partner;
		txt.text = maxfps_str[index];
		cmd("set ", OPT_CVAR, " ", ftos(maxfps_val[index]), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		uitext_c txt = (uitext_c)this.partner.partner;

		for(float i = 0; i < maxfps_val.length; i++)
		{
			if (value == maxfps_val[i])
			{
				txt.text = maxfps_str[i];
				this.bar_frac = (i / CHUNKS);
				this.bar_frac = bound(0, this.bar_frac, 1);
				return;
			}
		}

		this.bar_frac = 1;
		txt.text = "CUSTOM";
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_MAXFPS"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// fov
	#define SLIDER_MIN 80
	#define SLIDER_MAX 120
	#define CHUNKS 40
	#define OPT_CVAR "fov"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.0f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.0f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_FOV"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// pixel scaling
	static string pixelscale_str[] = {
		"1:1",
		"2:1",
		"3:1",
		"4:1",
		"8:1",
	};
	static float pixelscale_val[] = {
		1,
		1/2,
		1/3,
		1/4,
		1/8,
	};
	#define CHUNKS (pixelscale_val.length - 1)
	#define OPT_CVAR "r_viewscale"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float index = bound(0, round(CHUNKS * frac), CHUNKS);
		float value = pixelscale_val[index];
		
		uitext_c txt = (uitext_c)slider.partner;
		txt.text = pixelscale_str[index];
		cmd("set ", OPT_CVAR, " ", ftos(pixelscale_val[index]), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		uitext_c txt = (uitext_c)this.partner.partner;
		//this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		for(float i = 0; i < pixelscale_val.length; i++)
		{
			if (fabs(value - pixelscale_val[i]) < 0.05)
			{
				txt.text = pixelscale_str[i];
				this.bar_frac = (i / CHUNKS);
				this.bar_frac = bound(0, this.bar_frac, 1);
				return;
			}
		}

		this.bar_frac = 0;
		txt.text = "CUSTOM";
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_PIXELSCALING"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// animation interpolation
	#define OPT_CVAR "r_lerpmodels"
	void(uielement_c this) option_click = {
		float val = !cvar(OPT_CVAR);
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR))
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_INTERPOLATION"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	//

	// empty slot
	spawn(uielement_c, owner: menu_buttons_right);
	//

	
	// software palletization
	#define OPT_CVAR "saved9"
	void(uielement_c this) option_click = {
		float val = !cvar(OPT_CVAR);
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		float displacement_effect = cvar("cvar_otherdimension");
		if (!val)
		{
			if(displacement_effect != 1)
				cmd("r_glsl_postprocess_color_lut gfx/lookup_default.png \n");
		}
		else
		{
			if(displacement_effect != 1)
				cmd("r_glsl_postprocess_color_lut gfx/lookup_palettized.png\n");
		}
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR))
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_SOFTWARE"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	//

	// texture filtering
	static string texfilter_str[] = {
		"None",
		"Mipmaps",
		"Linear",
	};
	static float texfilter_val[] = {
		0,
		1,
		2,
	};
	#define CHUNKS (texfilter_val.length - 1)
	#define OPT_CVAR "saved2"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float index = bound(0, round(CHUNKS * frac), CHUNKS);
		float value = texfilter_val[index];
		
		uitext_c txt = (uitext_c)slider.partner;
		txt.text = texfilter_str[index];
		cmd(OPT_CVAR, " ", ftos(texfilter_val[index]), "\n");

		switch(texfilter_val[index])
		{
			case 0: cmd("gl_texturemode gl_nearest\n"); break;
			case 1: cmd("gl_texturemode gl_nearest_mipmap_linear\n"); break;
			case 2: cmd("gl_texturemode gl_linear_mipmap_linear\n"); break;
		}
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		uitext_c txt = (uitext_c)this.partner.partner;

		for(float i = 0; i < texfilter_val.length; i++)
		{
			if (value == texfilter_val[i])
			{
				txt.text = texfilter_str[i];
				this.bar_frac = (i / CHUNKS);
				this.bar_frac = bound(0, this.bar_frac, 1);
				return;
			}
		}

		this.bar_frac = 0;
		txt.text = texfilter_str[0];
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_TEXTUREFILTER"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '120 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_graphics, slider);
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// fxaa
	#define OPT_CVAR "r_fxaa"
	void(uielement_c this) option_click = {
		float val = !cvar(OPT_CVAR);
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR))
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_FXAA"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	//
}

// Resolution handling
class resolution_t;
resolution_t resolutionlist;
float resolutions_amount;
class resolution_t {
	vector size;
	resolution_t _next;

	nonvirtual void resolution_t() {
		// insert into resolution list
		resolutions_amount++;

		if (resolutionlist == 0)
		{
			resolutionlist = this;
			return;
		}
		
		resolution_t hld;
		for(resolution_t lst = resolutionlist; lst; hld = lst, lst = lst->_next)
		{
			if (lst.size[0] == this.size[0] && lst.size[1] == this.size[1])
			{
				resolutions_amount--;
				remove(this);
				return;
			}
		}

		if(hld)
			hld._next = this;
	};
};

void MenuInit_Options_Resolution(void)
{
	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
		{
			if (nkey == K_MOUSE1 && slider_selected)
			{
				localsound("sounds/menu.wav");
			}
			return FALSE;
		}
		
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_options;

		return FALSE;
	};
	
	ui_scale = '1 1';
	menu_options_resolution = spawn(uielement_c, flags: UIFLAG::STRETCH);
	menu_options_resolution.active_condition = menu_conditional;
	menu_options_resolution.input = option_input;


	uilist_c menu_buttons = spawn(uilist_c, owner: menu_options_resolution, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380', separation: '0 52');
	
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_RESOLUTION"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_resolution, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//


	// resolution slider
	static vector resolution_to_apply;
	static float fullscreen_to_apply;
	static float flags_to_apply;
	static float vsync_to_apply;
	static string language_to_apply;

	void(uielement_c slider, __inout float frac) slider_change = {
		float value = round(frac * resolutions_amount);
		frac = round(frac * resolutions_amount) / resolutions_amount;
		//float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));

		resolution_t res;
		for(float i = 0, res = resolutionlist; i < value && res; i++, res = res._next);
		resolution_to_apply = res.size;

		flags_to_apply &= ~1;

		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		if (value == resolutions_amount)
		{
			if (!cvar("vid_desktopfullscreen") || !cvar("vid_fullscreen"))
				flags_to_apply |= 1;

			resolution_to_apply = '0 0';
			txt.text = strzone(_("UI_BORDERLESS"));
			return;
		}

		if (cvar("vid_width") != resolution_to_apply[0] || cvar("vid_height") != resolution_to_apply[1] || cvar("vid_desktopfullscreen"))
			flags_to_apply |= 1;

		txt.text = strzone(sprintf("%gx%g", resolution_to_apply[0], resolution_to_apply[1]));
	};
	void(uielement_c this) slider_reinit = {
		
		resolution_to_apply = [cvar("vid_width"), cvar("vid_height")];
		float value = 0;

		for(resolution_t hld, resolution_t lst = resolutionlist; lst; hld = lst, lst = lst._next, remove(hld))
		resolutionlist = __NULL__;
		resolutions_amount = 0;
		flags_to_apply = 0;

		for(float i = 0; TRUE; i++)
		{
			vector res = getresolution(i);
			if (res[0] < 1)
				break;
			spawn(resolution_t, size: res);
		}

		value = resolutions_amount;
		if (!cvar("vid_desktopfullscreen"))
		{
			for(float i = 0, resolution_t res = resolutionlist; i < resolutions_amount && res; i++, res = res._next)
			{
				if (vlen(res.size-resolution_to_apply) < 5)
				{
					value = i;
					break;
				}
			}
		}
		
		//float value = cvar(OPT_CVAR);
		//this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		//this.bar_frac = bound(0, this.bar_frac, 1);

		this.bar_frac = value / resolutions_amount;
		this.bar_scrollamt = (1 / resolutions_amount);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		
		if (value == resolutions_amount)
		{
			resolution_to_apply = '0 0';
			txt.text = strzone(_("UI_BORDERLESS"));
			return;
		}
		txt.text = strzone(sprintf("%gx%g", resolution_to_apply[0], resolution_to_apply[1]));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_RESOLUTION"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '230 4');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / max(1, resolutions_amount));
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_resolution, slider);
	//


	// fullscreen
	void(uielement_c this) option_click = {
		localsound("sounds/menu.wav");
		if (resolution_to_apply[0] == 0) // desktop resolution mode forces fullscreen
			return;
		
		fullscreen_to_apply = !fullscreen_to_apply;

		flags_to_apply &= ~2;
		if (cvar("vid_fullscreen") != fullscreen_to_apply)
			flags_to_apply |= 2;
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (fullscreen_to_apply)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}

		if (resolution_to_apply[0] == 0)
		{
			this.partner.flags &= ~UIFLAG::HIDE;
		}
	}
	void(uielement_c this) option_reinit = {
		fullscreen_to_apply = cvar("vid_fullscreen");
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_FULLSCREEN"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
		box.reinit = option_reinit;
	Add_To_Reinit_List(menu_options_resolution, box);
	//

	// vsync
	void(uielement_c this) option_click = {
		localsound("sounds/menu.wav");
		vsync_to_apply = !vsync_to_apply;

		flags_to_apply &= ~4;
		if (cvar("vid_vsync") != vsync_to_apply)
			flags_to_apply |= 4;
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (vsync_to_apply)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	void(uielement_c this) option_reinit = {
		vsync_to_apply = cvar("vid_vsync");
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 -16', justify: '1 0', size: '14 14', text: _("UI_VSYNC"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
		box.reinit = option_reinit;
	Add_To_Reinit_List(menu_options_resolution, box);
	//

	// Language Selection
	static uielement_c langbutton;
	void(uielement_c this) option_reinit = {

		if (language_to_apply)
			strunzone(language_to_apply);
		language_to_apply = strzone(cvar_string("prvm_language"));
		language_current = LanguageDef_Find(language_to_apply);
		Run_Reinit_List(this.partner);
		Run_Reinit_List(this.partner2);
		
		this.partner.flags &= ~UIFLAG::HIDE;
		this.partner2.flags |= UIFLAG::HIDE;
	}

	static void(uitext_c langtxt_viewer, uitext_c langtxt_native, language_c langdef) lang_initname = {
		if (langtxt_viewer.text)
			strunzone(langtxt_viewer.text);
		if (langtxt_native.text)
			strunzone(langtxt_native.text);

		langtxt_viewer.flags &= ~UIFLAG::HIDE;
		langtxt_native.flags &= ~UIFLAG::HIDE;

		if (langdef) // if our language is actually registered
		{
			string viewertxt = LanguageDef_FindName(langdef, cvar_string("prvm_language"));
			string nativetxt = langdef.nativename;

			if (!viewertxt) // try to use fallback if our native doesn't have a translation
				viewertxt = LanguageDef_FindName(langdef, cvar_string("prvm_language_fallback"));
			
			if (viewertxt)
			{
				//print(sprintf("\"%s\"\n", viewertxt));
				langtxt_viewer.text = strzone(viewertxt);
				if (nativetxt != " ")
					langtxt_native.text = strzone(sprintf("%s", nativetxt));
				else
				{
					langtxt_native.text = strzone(" ");
					langtxt_native.flags |= UIFLAG::HIDE;
				}
			}
			else
			{
				if (nativetxt != " ")
					langtxt_viewer.text = strzone(nativetxt);
				else
					langtxt_viewer.text = strzone(langdef.lang);

				langtxt_native.text = strzone(" ");
				langtxt_native.flags |= UIFLAG::HIDE;
			}
		}
		else
		{
			langtxt_viewer.text = strzone(langdef.lang);
			langtxt_native.text = strzone(" ");
			langtxt_native.flags |= UIFLAG::HIDE;
		}
	}

	void(uielement_c this) box_reinit = {
		uitext_c langtxt_viewer = this.partner;
		uitext_c langtxt_native = this.partner2;
		language_c langdef = LanguageDef_Find(language_to_apply);
		
		lang_initname(langtxt_viewer, langtxt_native, langdef);

		langtxt_viewer.font = FONT_MENU;
		langtxt_native.font = FONT_MENU;

		if (langdef.fontcode)
			langtxt_native.font = langdef.fontcode;
	}

	void(uielement_c this) box_click = {
		uielement_c header = langbutton.partner;
		uismoothlist_c list = langbutton.partner2;

		header.flags |= UIFLAG::HIDE;
		list.flags &= ~UIFLAG::HIDE;
		list.scroll = 0;
		list.scroll_smooth = 0;
	}

	float(uielement_c this) lang_activecondition = {
		return (clientstate() == CS_DISCONNECTED);
	}

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 -16', justify: '1 0', size: '14 14', text: _("UI_LANGUAGE"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
		txt.reinit = option_reinit;
		txt.active_condition = lang_activecondition;
		langbutton = txt;
	
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '256 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.reinit = box_reinit;
		box.m_click = box_click;
	
	langbutton.partner = box;
	Add_To_Reinit_List(menu_options_resolution, txt);

	uitext_c box_text1 = spawn(uitext_c, owner: box, origin: '4 0', anchor: '0 0.5', justify: '0 0.5', size: '12 12', text: strzone(" "), font: FONT_MENU);
	uitext_c box_text2 = spawn(uitext_c, owner: box_text1, origin: '24 0', anchor: '1 0', justify: '0 0', size: '12 12', text: strzone(" "), font: FONT_MENU);
		box.partner = box_text1;
		box.partner2 = box_text2;
	
	spawn(uitext_c, owner: box_text2, anchor: '0 0', justify: '1 0', size: '12 12', text: "(");
	spawn(uitext_c, owner: box_text2, anchor: '1 0', justify: '0 0', size: '12 12', text: ")");
	//

	// Apply
	float(uielement_c this) apply_conditional = {
		if (flags_to_apply)
			return TRUE;
		return FALSE;
	};
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;

		cmd(sprintf("vid_vsync %g\n", vsync_to_apply));
		if (resolution_to_apply[0] > 0)
		{
			cmd(sprintf("set vid_width %g\n", resolution_to_apply[0]));
			cmd(sprintf("set vid_height %g\n", resolution_to_apply[1]));
			cmd(sprintf("set vid_fullscreen %g\n", fullscreen_to_apply));
			cmd("set vid_desktopfullscreen 0\n");
			cmd("vid_restart\n");

			cmd(sprintf("set vid_conwidth %g\n", resolution_to_apply[0]/2));
			cmd(sprintf("set vid_conheight %g\n", resolution_to_apply[1]/2));
		}
		else
		{
			vector res = getresolution(resolutions_amount-1);
			cmd(sprintf("set vid_width %g\n", res[0]));
			cmd(sprintf("set vid_height %g\n", res[1]));
			cmd(sprintf("set vid_fullscreen %g\n", 1));
			cmd("set vid_desktopfullscreen 1\n");
			cmd("vid_restart\n");

			cmd(sprintf("set vid_conwidth %g\n", res[0]/2));
			cmd(sprintf("set vid_conheight %g\n", res[1]/2));
		}

		if (flags_to_apply & 8)
		{
			cmd(sprintf("set prvm_language %s\n", language_to_apply));
			cmd("menu_restart\ntogglemenu\n");
		}

		flags_to_apply = 0;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_resolution, anchor: '0.5 0.5', origin: '0 120', justify: '0.5 0', size: '16 16', text: _("UI_APPLY"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.active_condition = apply_conditional;
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//


	// language dropdown
	#if 1
	float(uielement_c this) lang_activecondition = {
		return strcmp(this.langset.lang, language_to_apply);
	}

	static void(uielement_c this) lang_reinit = {
		uitext_c langtxt_viewer = this.partner;
		uitext_c langtxt_native = this.partner2;
		language_c langdef = this.langset;

		//this.color = OPTIONS_TEXT_COLOR;
		//this.flags &= ~UIFLAG::HIDE;
		//if (this.langset.lang == language_to_apply)
		//	this.flags |= UIFLAG::HIDE;
		
		lang_initname(langtxt_viewer, langtxt_native, langdef);

		langtxt_viewer.font = FONT_MENU;
		langtxt_native.font = FONT_MENU;

		if (langdef.fontcode)
			langtxt_native.font = langdef.fontcode;
	};

	float(uielement_c this, float nkey, float ascii, float released) list_input = {
		uilist_c list = (uilist_c)this;
		float move = 0;

		if (released)
			return FALSE;

		if (nkey == K_UPARROW || nkey == K_MWHEELUP)
			move = -1;
		else if (nkey == K_DOWNARROW || nkey == K_MWHEELDOWN)
			move = 1;

		list.scroll += move;
		//list.scroll = bound(0, list.scroll, list.bar_scrollamt);

		return FALSE;
	};

	static uilist_c langboxlist;
	uilist_c boxlist = spawn(uismoothlist_c, owner: langbutton, origin: '24 -9', anchor: '1 0.5', justify: '0 0', size: '256 128', separation: '0 20', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLIP);
		boxlist.input = list_input;
		boxlist.bar_scrollamt = 0; // number of languages
	langbutton.partner2 = boxlist;
	Add_To_Reinit_List(langbutton, boxlist);
	langboxlist = boxlist;
	// 

	// currently selected lang
	void(uielement_c this) abtn_click = {
		uielement_c header = langbutton.partner;
		uielement_c list = langbutton.partner2;

		strunzone(language_to_apply);
		language_to_apply = strzone(this.langset.lang);

		header.flags &= ~UIFLAG::HIDE;
		list.flags |= UIFLAG::HIDE;
	};

	static void(uielement_c this) lang_reinit_current = {
		this.langset = LanguageDef_Find(language_to_apply);

		if !(this.langset)
			return;
		
		lang_reinit(this);
		this.flags &= ~UIFLAG::HIDE;
	};

	#if 1
	uifill_c button = spawn(uifill_c, owner: boxlist, langset: language_current, size: [boxlist.size[0], boxlist.separation[1]], color: OPTIONS_TEXT_COLOR + '0.04 0.045 0', flags: UIFLAG::CLICKABLE);
		button.reinit = lang_reinit_current;
		button.m_click = abtn_click;

	uitext_c box_text1 = spawn(uitext_c, owner: button, origin: '4 0', anchor: '0 0.5', justify: '0 0.5', size: '12 12', text: strzone(" "), font: FONT_MENU);
	uitext_c box_text2 = spawn(uitext_c, owner: box_text1, origin: '24 0', anchor: '1 0', justify: '0 0', size: '12 12', text: strzone(" "), font: FONT_MENU);
		button.partner = box_text1;
		button.partner2 = box_text2;

	spawn(uitext_c, owner: box_text2, anchor: '0 0', justify: '1 0', size: '12 12', text: "(");
	spawn(uitext_c, owner: box_text2, anchor: '1 0', justify: '0 0', size: '12 12', text: ")");

	langboxlist.partner = button;
	Add_To_Reinit_List(boxlist, button);
	boxlist.bar_scrollamt++;
	#endif
	//

	for(language_c lang = language_list; lang; lang = lang._next)
	{
		void(uielement_c this) btn_click = {
			uielement_c header = langbutton.partner;
			uielement_c list = langbutton.partner2;
			
			strunzone(language_to_apply);
			language_to_apply = strzone(this.langset.lang);

			flags_to_apply &= ~8;
			if (language_current != this.langset)
			{
				flags_to_apply |= 8;
			}

			langboxlist.partner.langset = this.langset;
			lang_reinit_current(langboxlist.partner);

			//Run_Reinit_List(langboxlist);
			//lang_reinit(langbutton);
			Run_Reinit_List(header);

			header.flags &= ~UIFLAG::HIDE;
			list.flags |= UIFLAG::HIDE;
		};

		uifill_c button = spawn(uifill_c, owner: boxlist, langset: lang, size: [boxlist.size[0], boxlist.separation[1]], color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
			button.reinit = lang_reinit;
			button.m_click = btn_click;
			button.active_condition = lang_activecondition;

		uitext_c box_text1 = spawn(uitext_c, owner: button, origin: '4 0', anchor: '0 0.5', justify: '0 0.5', size: '12 12', text: strzone(" "), font: FONT_MENU);
		uitext_c box_text2 = spawn(uitext_c, owner: box_text1, origin: '24 0', anchor: '1 0', justify: '0 0', size: '12 12', text: strzone(" "), font: FONT_MENU);
			button.partner = box_text1;
			button.partner2 = box_text2;

		spawn(uitext_c, owner: box_text2, anchor: '0 0', justify: '1 0', size: '12 12', text: "(");
		spawn(uitext_c, owner: box_text2, anchor: '1 0', justify: '0 0', size: '12 12', text: ")");

		boxlist.bar_scrollamt++;
		Add_To_Reinit_List(boxlist, button);
	}
	#endif
	//

}

void MenuInit_Options_Audio(void)
{
	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
		{
			if (nkey == K_MOUSE1 && slider_selected)
			{
				localsound("sounds/menu.wav");
			}
			return FALSE;
		}
		
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_options;

		return FALSE;
	};
	
	ui_scale = '1 1';
	menu_options_audio = spawn(uielement_c, flags: UIFLAG::STRETCH);
	menu_options_audio.active_condition = menu_conditional;
	menu_options_audio.input = option_input;

	uilist_c menu_buttons = spawn(uilist_c, owner: menu_options_audio, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380', separation: '0 52');
	
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_AUDIO"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_audio, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//

	// master volume
	#define SLIDER_MIN 0
	#define SLIDER_MAX 1
	#define CHUNKS 100
	#define OPT_CVAR "mastervolume"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_MASTERVOLUME"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '230 4');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_audio, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// effects volume
	#define SLIDER_MIN 0
	#define SLIDER_MAX 1
	#define CHUNKS 100
	#define OPT_CVAR "volume"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_EFFECTSVOLUME"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '230 4');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_audio, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// music volume
	#define SLIDER_MIN 0
	#define SLIDER_MAX 1
	#define CHUNKS 100
	#define OPT_CVAR "bgmvolume"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.2f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '14 14', text: _("UI_MUSICVOLUME"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '230 4');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (2 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_audio, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//
}

void MenuInit_Options_Gameplay(void)
{
	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
		{
			if (nkey == K_MOUSE1 && slider_selected)
			{
				localsound("sounds/menu.wav");
			}
			return FALSE;
		}
		
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_options;

		return FALSE;
	};
	
	ui_scale = '1 1';
	menu_options_gameplay = spawn(uielement_c, flags: UIFLAG::STRETCH);
	menu_options_gameplay.active_condition = menu_conditional;
	menu_options_gameplay.input = option_input;

	uilist_c menu_buttons = spawn(uilist_c, owner: menu_options_gameplay, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 380', separation: '0 24');
	uilist_c menu_buttons_left = spawn(uilist_c, owner: menu_options_gameplay, origin: '48 52', anchor: '0.5 0.5', justify: '1 0.5', size: '280 380', separation: '0 24');
	uilist_c menu_buttons_right = spawn(uilist_c, owner: menu_options_gameplay, origin: '48 52', anchor: '0.5 0.5', justify: '0 0.5', size: '280 380', separation: '0 24');
	
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_OPTION_GAMEPLAY"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_options;
	};
	uitext_c txt = spawn(uitext_c, owner: menu_options_gameplay, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//

	// strafe tilting
	#define OPT_VAL	2
	#define OPT_CVAR "saved7"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		if (val)
			cmd("set cl_rollangle 5\n");
		else
			cmd("set cl_rollangle 0\n");
		cmd("set cl_rollspeed 1200");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_STRAFETILT"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// view bob
	#define OPT_VAL	0.005
	#define OPT_CVAR "cl_bob"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("seta ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_VIEWBOB"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// crosshair
	#define OPT_VAL	1
	#define OPT_CVAR "saved1"
	void(uielement_c this) option_click = {
		float val = !cvar(OPT_CVAR);
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (!cvar(OPT_CVAR))
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CROSSHAIR"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// centered weapons
	#define OPT_VAL	1
	#define OPT_CVAR "saved3"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
		cmd("cmd check_custom_cvars\n");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CENTERWEAPON"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// switch empty weapon
	#define OPT_VAL	1
	#define OPT_CVAR "saved4"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_SWITCHEMPTY"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// blood decals
	#define OPT_VAL	1
	#define OPT_CVAR "cl_decals"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_DECALS"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// flash on pickup
	#define OPT_VAL	1
	#define OPT_CVAR "saved6"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_SCREENFLASH"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// always run
	#define OPT_VAL	1
	#define OPT_CVAR "cl_alwaysrun"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
		cmd("cmd check_custom_cvars\n");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_ALWAYSRUN"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// toggle run
	#define OPT_VAL	1
	#define OPT_CVAR "cl_togglerun"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
		cmd("cmd check_custom_cvars\n");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_TOGGLERUN"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// view punch
	#define OPT_VAL	1
	#define OPT_CVAR "cl_punch"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_VIEWPUNCH"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// show timestamps
	#define OPT_VAL	1
	#define OPT_CVAR "show_dates"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_left, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_TIMESTAMPS"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//




	// crosshairscale
	#define SLIDER_MIN 1
	#define SLIDER_MAX 3
	#define CHUNKS 4
	#define OPT_CVAR "saved8"
	void(uielement_c slider, __inout float frac) slider_change = {
		frac = round(frac * CHUNKS) / CHUNKS;
		float value = SLIDER_MIN + (frac * (SLIDER_MAX - SLIDER_MIN));
		 
		uitext_c txt = (uitext_c)slider.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.1f", value));
		cmd("set ", OPT_CVAR, " ", ftos(value), "\n");
	};
	void(uielement_c this) slider_reinit = {
		float value = cvar(OPT_CVAR);
		this.bar_frac = (value - SLIDER_MIN) / (SLIDER_MAX - SLIDER_MIN);
		this.bar_frac = bound(0, this.bar_frac, 1);

		uitext_c txt = (uitext_c)this.partner.partner;
		if (txt.text)
			strunzone(txt.text);
		txt.text = strzone(sprintf("%.1f", value));
	};
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_CROSSHAIRSCALE"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uielement_c slider = UI_Sliderbar(txt, '36 0', '1 0.5', '0 0.5', '90 3');
		slider.bar_change = slider_change;
		slider.bar_scrollamt = (1 / CHUNKS);
		slider.reinit = slider_reinit;
	Add_To_Reinit_List(menu_options_audio, slider);
	#undef SLIDER_MIN
	#undef SLIDER_MAX
	#undef OPT_CVAR
	#undef CHUNKS
	//

	// infinite saves
	#define OPT_VAL	1
	#define OPT_CVAR "infinite_saves"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
		cmd("cmd check_infinite_saves\n");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_INFINITESAVES"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

	// auto artifact switch
	#define OPT_VAL	1
	#define OPT_CVAR "scratch2"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 0 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_AUTOARTIFACTSWITCH"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//

		// auto artifact switch
	#define OPT_VAL	0
	#define OPT_CVAR "cl_straightbeam"
	void(uielement_c this) option_click = {
		float val = cvar(OPT_CVAR) == OPT_VAL ? 1 : OPT_VAL;
		cmd("set ", OPT_CVAR, " ", ftos(val), "\n");
		localsound("sounds/menu.wav");
	}
	void(uielement_c this, __inout vector position) option_preloop = {
		this.partner.flags |= UIFLAG::HIDE;
		if (cvar(OPT_CVAR) == OPT_VAL)
			this.partner.flags &= ~UIFLAG::HIDE;
		
		// hightlight title
		if (this.owner.type == UITYPE::TEXT)
		{
			if (ui_hover == this)
				this.owner.color = HIGHLIGHT_TEXT_COLOR;
			else
				this.owner.color = OPTIONS_TEXT_COLOR;
		}
	}
	uitext_c txt = spawn(uitext_c, owner: menu_buttons_right, anchor: '0.5 0', origin: '-64 0', justify: '1 0', size: '10 10', text: _("UI_STRAIGHTBEAM"), font: FONT_MENU, color: OPTIONS_TEXT_COLOR);
	uifill_c box = spawn(uifill_c, owner: txt, origin: '24 0', anchor: '1 0.5', justify: '0 0.5', size: '18 18', color: OPTIONS_TEXT_COLOR, flags: UIFLAG::CLICKABLE | UIFLAG::HIGHLIGHT);
		box.partner = spawn(uifill_c, owner: box, anchor: '0.5 0.5', justify: '0.5 0.5', size: '12 12', color: OPTIONS_HEADER_COLOR, alpha: 0.7);
		box.m_click = option_click;
		box.preloop = option_preloop;
	#undef OPT_CVAR
	#undef OPT_VAL
	//
}

float profile_selected;
float save_selected;
uielement_c menu_loadprofile_slots[12];
uilist_c menu_loadprofile_warning;

string saveslot_str[] = {
	_("UI_SAVE_AUTOSAVE"),
	_("UI_SAVE_TETHER"),
	_("UI_SAVE_SHRINE"),
};
uitext_c profile_loadbutton[saveslot_str.length];
uipicture_c profile_loadimage[saveslot_str.length];

void MenuInit_LoadProfile(void)
{
	static uitext_c profile_button_selected;
	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
			return FALSE;
		
		if (nkey != K_ESCAPE)
			return FALSE;

		localsound("sounds/menu.wav");
		menu_current = menu_main;
		Run_Reinit_List(menu_current);

		return FALSE;
	};

	void(uielement_c this) profile_reinit = {
		#if 1
		read_currentprofileslot();

		// hide everything until further notice
		for(float i = 0; i < menu_loadprofile_slots.length; i++)
		{
			uitext_c slot = menu_loadprofile_slots[i];
			slot.flags |= UIFLAG::HIDE;
		}

		for(float i = 0; i < profile_loadimage.length; i++)
		{
			uitext_c slot = profile_loadbutton[i];
			uipicture_c page = profile_loadimage[i];
			slot.flags |= UIFLAG::HIDE;
			page.flags |= UIFLAG::HIDE;
		}

		menu_loadprofile_warning.flags |= UIFLAG::HIDE;
		//

		float search_length = 0;
		float sb = search_begin("data/profiles/*/menu.version", TRUE, TRUE);
		if (sb >= 0)
		{
			search_length = search_getsize(sb);
		}
		
		profile_selected = -1;
		float force_profile_select = FALSE;
		uitext_c force_profile_slot = __NULL__;
		for(float i = 0; i < min(menu_loadprofile_slots.length, search_length); i++)
		{
			uitext_c slot = menu_loadprofile_slots[i];
			slot.flags |= UIFLAG::HIDE;

			tokenizebyseparator(search_getfilename(sb, i), "/");
			string prof_name = argv(2);
			if (prof_name == __NULL__) // eof
			{
				prof_name = " ";
			}
			
			if (slot.text)
				strunzone(slot.text);
			slot.text = strzone(prof_name);
			if (prof_name && prof_name != " ")
			{
				slot.flags &= ~UIFLAG::HIDE;
				if (!force_profile_select)
				{
					force_profile_select = i | 0x80;
					force_profile_slot = slot;
				}

				if (prof_name == profilename)
				{
					force_profile_select = i | 0x40;
					force_profile_slot = slot;
				}
			}
		}

		if (force_profile_select & 0xC0)
		{
			profile_selected = force_profile_select & 0x3F;
			force_profile_slot.m_click(force_profile_slot);
		}

		search_end(sb);
		#endif
	};
	
	ui_scale = '1 1';
	menu_loadprofile = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_loadprofile.active_condition = menu_conditional;
		menu_loadprofile.input = option_input;
		menu_loadprofile.reinit = profile_reinit;
	
	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_main;
		Run_Reinit_List(menu_current);
	};
	uitext_c txt = spawn(uitext_c, owner: menu_loadprofile, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//

	uipicture_c menu_journal = spawn(uipicture_c, owner: menu_loadprofile, anchor: '0.5 0.5', justify: '0.5 0.5', size: '512 360', image: menu_assets[MENU_IMG::LOAD_MENU]);
	
	// 2nd page

	float(uielement_c this) profilepage_conditional = {
		if (save_selected == this.button_index)
			return TRUE;
		return FALSE;
	};
	void(uitext_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) saveslot_prerender = {
		if (save_selected == this.button_index)
			color_to_render = JOURNAL_COLOR_SELECTED;
		else if (ui_hover == this)
			color_to_render = JOURNAL_COLOR_HIGHLIGHT;
	};
	void(uielement_c this) saveslot_click = {
		save_selected = this.button_index;
		Journal_Sound();
	};
	uielement_c profile_page2 = spawn(uielement_c, owner:menu_journal, flags: UIFLAG::STRETCH);
	uilist_c profile_loadlist = spawn(uilist_c, owner: menu_journal, origin: '360 84', justify:'0.5 0', size: '200 300', separation: '0 24');
	for(float i = 0; i < saveslot_str.length; i++)
	{
		profile_loadimage[i] = spawn(uipicture_c, button_index: i, owner: profile_page2, flags: UIFLAG::STRETCH, image: strzone("gfx/menu/load_menu_e1m1.tga"));
			profile_loadimage[i].active_condition = profilepage_conditional;
		profile_loadimage[i].partner = spawn(uitext_c, owner: profile_loadimage[i], origin: '361 283', justify:'0.5 1', size: '12 12', color: '-0.5 -0.5 -0.5', alpha: JOURNAL_TEXTALPHA, text: strzone("Time not found"));
		profile_loadimage[i].partner2 = spawn(uitext_c, owner: profile_loadimage[i], origin: '361 175', justify:'0.5 1', size: '12 12', color: '-0.5 -0.5 -0.5', alpha: JOURNAL_TEXTALPHA, text: strzone("Date not found"));
		/* skill */ profile_loadimage[i].partner3 = spawn(uitext_c, owner: profile_loadimage[i], origin: '361 180', justify:'0.5 0', size: '12 12', color: '-0.5 -0.5 -0.5', alpha: JOURNAL_TEXTALPHA, text: " ");
		/* loc label */ profile_loadimage[i].partner4 = spawn(uitext_c, owner: profile_loadimage[i], origin: '361 243', justify:'0.5 0', size: '16 16', color: CONVERT_TO_DP_SHITTY_COLOR('0 0 0'), alpha: JOURNAL_TEXTALPHA, font: FONT_USER7, text: " ");

		profile_loadbutton[i] = spawn(uitext_c, button_index: i, owner: profile_loadlist, anchor: '0.5 0', justify:'0.5 0', size: '22 22', flags: UIFLAG::CLICKABLE, color: JOURNAL_COLOR_NOTE, font: FONT_USER7, alpha: JOURNAL_TEXTALPHA, text: saveslot_str[i]);
			profile_loadbutton[i].prerender = saveslot_prerender;
			profile_loadbutton[i].m_click = saveslot_click;
	}

	// incompatibility warning
	void(uitext_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) warning_prerender = {
		float swave = sin(cltime * 4);
		float s_round = round(swave * 2) / 2;

		alpha_to_render = (0.9 + (swave * 0.05));
		color_to_render = [(0.6 + 0.8 * s_round), -1, -1];
	}

	menu_loadprofile_warning = spawn(uilist_c, owner: profile_page2, origin: '360 128', justify:'0.5 0', size: '200 300', separation: '0 20');
	
	uitext_c wtxt;
	wtxt = spawn(uitext_c, owner: menu_loadprofile_warning, size: '10 12', justify: '0.5 0', anchor: '0.5 0', text: _("UI_WARNING_INCOMPAT_L1")); wtxt.prerender = warning_prerender;
	wtxt = spawn(uitext_c, owner: menu_loadprofile_warning, size: '10 12', justify: '0.5 0', anchor: '0.5 0', text: _("UI_WARNING_INCOMPAT_L2")); wtxt.prerender = warning_prerender;
	wtxt = spawn(uitext_c, owner: menu_loadprofile_warning, size: '10 12', justify: '0.5 0', anchor: '0.5 0', text: _("UI_WARNING_INCOMPAT_L3")); wtxt.prerender = warning_prerender;
	wtxt = spawn(uitext_c, owner: menu_loadprofile_warning, size: '10 12', justify: '0.5 0', anchor: '0.5 0', text: _("UI_WARNING_INCOMPAT_L4")); wtxt.prerender = warning_prerender;
	//

	float(uielement_c this) load_conditional = {
		if (save_selected < 0)
			return FALSE;
		if (profile_loadbutton[save_selected].flags & UIFLAG::HIDE)
			return FALSE;
		return TRUE;
	};
	void(uipicture_c this, __inout string img_to_render) loadbutton_prerender = {
		if (ui_hover == this)
			img_to_render = this.image2;
	};
	void(uielement_c this) load_click = {
		if (!profile_button_selected)
			return;

		profileslot = profile_button_selected.button_index + 1;
		write_currentprofileslot_byname(profile_button_selected.text, profileslot);

		if (save_selected == 1) {
			load_tether();
		}
		else if (save_selected == 2) {
			load_shrine();
		}
		else
		{
			load_autosave();
		}
	};
	uipicture_c loadbutton = spawn(uipicture_c, owner: menu_journal, origin: '360 285', justify:'0.5 0', size: '152 40', image: menu_assets[MENU_IMG::LOAD_GAME_ACTIVE], image2: menu_assets[MENU_IMG::LOAD_GAME_ACTIVE2], flags: UIFLAG::CLICKABLE);
		loadbutton.active_condition = load_conditional;
		loadbutton.prerender = loadbutton_prerender;
		loadbutton.m_click = load_click;
	//

	// handler function to shunt list around if it has enough elements to scroll
	void(uielement_c this, __inout vector position) profile_list_preloop = {
		uilist_c list = (uilist_c)this.partner;
		if (list.elements <= list.scroll_count)
			position[1] -= (32 * ui_scale[1]);
	};
	uielement_c profile_list_handler = spawn(uielement_c, owner: menu_journal, flags: UIFLAG::STRETCH);
		profile_list_handler.preloop = profile_list_preloop;
		
	uismoothlist_c profile_list = spawn(uismoothlist_c, owner: profile_list_handler, size: '256 130', origin: '22 120', separation: '0 26', flags: UIFLAG::CLIP);
	profile_list_handler.partner = profile_list;

	void(uipicture_c this, __inout string img_to_render) scroll_prerender = { if (ui_hover == this) img_to_render = this.image2; };
	float(uielement_c this) scroll_conditional = {
		uilist_c list = (uilist_c)this.partner;

		// check if this scroll arrow should even show
		if (this.button_index > 0)
		{
			if (list.scroll >= (list.elements - list.scroll_count))
				return FALSE;
		}
		else if (list.scroll <= 0)
		{
			return FALSE;
		}
		//

		if (list.elements > list.scroll_count)
			return TRUE;
		return FALSE;
	}
	void(uielement_c this) scroll_click = {
		uilist_c list = (uilist_c)this.partner;
		list.scroll += this.button_index;
		Journal_Sound();
	};

	// scroll up
	uipicture_c scroll = spawn(uipicture_c, owner: menu_journal, origin: '132 76', anchor: '0 0', justify: '0 0', size: '32 40',
		flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/menu/arrow_up", image2: "gfx/menu/arrow_up_active", partner: profile_list, button_index: -1);
		scroll.active_condition = scroll_conditional;
		scroll.prerender = scroll_prerender;
		scroll.m_click = scroll_click;
	// scroll down
	uipicture_c scroll = spawn(uipicture_c, owner: menu_journal, origin: '132 250', anchor: '0 0', justify: '0 0', size: '32 40',
		flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/menu/arrow_down", image2: "gfx/menu/arrow_down_active", partner: profile_list, button_index: 1);
		scroll.active_condition = scroll_conditional;
		scroll.prerender = scroll_prerender;
		scroll.m_click = scroll_click;

	void(uitext_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) profile_prerender = {
		if (profile_selected == this.button_index)
			color_to_render = JOURNAL_COLOR_SELECTED;
		else if (ui_hover == this)
			color_to_render = JOURNAL_COLOR_HIGHLIGHT;
	};
	void(uitext_c this) profile_click = {
		Journal_Sound();

		if (!this.text || !strcmp(this.text, " "))
			return;
		
		//profileslot = this.button_index + 1;
		//write_currentprofileslot_byname(this.text, profileslot);
		profilename = this.text;
		check_profilemenuversion_byname(this.text);
		profile_selected = this.button_index;
		profile_button_selected = this;
		
		save_selected = -1;
		if (profilemenuversion != menuversion)
		{
			for(float i = 0; i < profile_loadimage.length; i++)
			{
				uitext_c slot = profile_loadbutton[i];
				uipicture_c page = profile_loadimage[i];
				slot.flags |= UIFLAG::HIDE;
				page.flags |= UIFLAG::HIDE;
			}

			menu_loadprofile_warning.flags &= ~UIFLAG::HIDE;
			return;
		}
		menu_loadprofile_warning.flags |= UIFLAG::HIDE;
			
		checkdates(this.text);
		get_timestamp_map(this.text);
		check_profile_saves(this.text);

		string save_filename[] = {
			sprintf("data/profiles/%s/autosave.sav", this.text),
			sprintf("data/profiles/%s/tether.sav", this.text),
			sprintf("data/profiles/%s/shrine.sav", this.text)
		}

		float save_slots = (
			((fexists(save_filename[0]) > 0) << 0) |
			((fexists(save_filename[1]) > 0) << 1) |
			((fexists(save_filename[2]) > 0) << 2)
		);
		
		string timestamp_str[] = {
			timestamp_map1,
			timestamp_map2,
			timestamp_map3,
		};
		string date_str[] = {
			autosave_date,
			tether_date,
			shrine_date,
		};
		string skill_str[] = {
			"",
			"",
			""
		};
		string skill_names[] = {
			_("UI_DIFFICULTY_EASY"),
			_("UI_DIFFICULTY_MEDIUM"),
			_("UI_DIFFICULTY_HARD"),
			_("UI_DIFFICULTY_OUTLANDER")
		}
		
		for(float i = 0; i < 3; i++) // parse save files
		{
			skill_str[i] = "";
			if !(save_slots & (1 << i))
				continue;

			saveinfo_t mapinfo;
			parse_savefile(save_filename[i], mapinfo);
			timestamp_str[i] = mapinfo.mapname;
			skill_str[i] = skill_names[bound(0, stof(mapinfo.skill), 3)];
		}

		for(float i = 0; i < profile_loadimage.length; i++)
		{
			uitext_c slot = profile_loadbutton[i];
			uipicture_c page = profile_loadimage[i];
			uitext_c loc_label = page.partner4;
			uitext_c skill = page.partner3;
			uitext_c date = page.partner2;
			uitext_c time = page.partner;

			// cleanup zoned strings
			if (page.image)
			{
				strunzone(page.image);
				page.image = __NULL__;
			}
			if (date.text)
			{
				strunzone(date.text);
				date.text = __NULL__;
			}
			if (time.text)
			{
				strunzone(time.text);
				time.text = __NULL__;
			}
			//

			if !(save_slots & (1 << i))
			{
				slot.flags |= UIFLAG::HIDE;
				page.flags |= UIFLAG::HIDE;
				continue;
			}

			if (save_selected < 0)
				save_selected = i;

			slot.flags &= ~UIFLAG::HIDE;
			page.flags &= ~UIFLAG::HIDE;
			loc_label.flags |= UIFLAG::HIDE;

			string img = timestamp_str[i];
			//float lm_ofs = strstrofs(img, "load_menu_", 0);
			//string loc_img = strcat(substring(img, 0, lm_ofs), "%s/", substring(img, lm_ofs, strlen(img)));
			string loc_img = sprintf("gfx/menu/%%s/load_menu_%s.tga", img);

			if (fexists_pak(sprintf(loc_img, cvar_string("prvm_language"))))
				img = sprintf(loc_img, cvar_string("prvm_language"));
			else
			{
				// Reki (February 6 2024): Do we have a blank version? If so then we probably want to
				// fall back on a localization string. Better than nothing I suppose.
				string blank_img = sprintf("gfx/menu/load_menu_%s.tga", img);
				if (fexists_pak(blank_img)) // blank version exists?
				{
					for(float j = 0; j < loadscreen_list.length; j++)
					{
						loadscreendef_t ls = loadscreen_list[j];
						if (img != strtolower(ls.mapfile))
							continue;
						if (strcmp(ls.locname, sprintf("UI_JOURNAL_LABEL_%s", ls.mapfile))) // and make sure we have a journal label
						{
							loc_label.text = ls.locname;
							loc_label.flags &= ~UIFLAG::HIDE;

							float o_font = drawfont; drawfont = loc_label.font;
							float str_width = stringwidth(loc_label.text, TRUE, '16 16');
							if (str_width > 156)
							{
								loc_label.size = '16 16';
								loc_label.size[0] *= 156 / str_width;
							}
							drawfont = o_font;
						}
						break;
					}

					img = blank_img;
				}
				else if (fexists_pak(sprintf(loc_img, cvar_string("prvm_language_fallback"))))
				{
					img = sprintf(loc_img, cvar_string("prvm_language_fallback"));
				}
				else
				{
					img = "gfx/empty.tga"; // sigh
				}
				//page.flags |= UIFLAG::HIDE;
			}
			page.image = strzone(img);
			
			string selected_date_a = substring(date_str[i],0,11);
			string selected_date_b = substring(date_str[i],11,10);
			if !(cvar("show_dates"))
			{
				selected_date_a = "";
				selected_date_b = "";
			}
			
			skill.text = skill_str[i];
			date.text = strzone(selected_date_a);
			time.text = strzone(selected_date_b);
		}
	};

	float(uielement_c this) dprof_conditional = {
		if (this.partner.flags & UIFLAG::HIDE)
			return FALSE;
		if (profile_selected == this.partner.button_index)
			return TRUE;
		return FALSE;
	};

	void(uielement_c this) dprof_click = {
		menu_current = menu_deleteconfirm;
		Run_Reinit_List(menu_deleteconfirm.reinit_list);

		uitext_c msg = (uitext_c)menu_deleteconfirm.partner;
		if (msg.text)
			strunzone(msg.text);
			msg.text = strzone(sprintf(_("UI_PROFILE"), profilename));
	};


	for(float i = 0; i < menu_loadprofile_slots.length; i++)
	{
		uitext_c slot;
		
		// delete profile
		uipicture_c delete_profile = spawn(uipicture_c, owner: menu_journal, origin: '160 285', justify:'0.5 0', size: '152 40', image: menu_assets[MENU_IMG::DELETE_PROFILE], image2: menu_assets[MENU_IMG::DELETE_PROFILE_ACTIVE], flags: UIFLAG::CLICKABLE);
			delete_profile.active_condition = dprof_conditional;
			delete_profile.prerender = loadbutton_prerender;
			delete_profile.m_click = dprof_click;
		// profile name
		menu_loadprofile_slots[i] = slot = spawn(uitext_c, owner: profile_list, button_index: i, size: '20 20',  justify: '0.5 0', anchor: '0.5 0', flags: UIFLAG::CLICKABLE, padding: '24 4',
			font: FONT_USER7, text: strzone(" "), color: JOURNAL_COLOR_NOTE, alpha: JOURNAL_TEXTALPHA);
			slot.prerender = profile_prerender;
			slot.m_click = profile_click;
		
		delete_profile.partner = slot;
		slot.partner = delete_profile;
	}

	MenuInit_DeleteConfirm();
}

void MenuInit_DeleteConfirm()
{
	// exit button
	// DELETE CONFIRM MENU
	menu_deleteconfirm = spawn(uielement_c, flags: UIFLAG::STRETCH);
		menu_deleteconfirm.active_condition = menu_conditional;
	
	float(uielement_c this, float nkey, float ascii, float released) quit_input = {
		if (released)
			return FALSE;
		if (ascii == 'n' || nkey == K_ESCAPE)
		{
			localsound("sounds/menu.wav");
			menu_current = menu_main;
			Run_Reinit_List(menu_current);
		}
		else if (ascii == 'y')
		{
			deleteprofile_byname(profilename);

			localsound("sounds/menu.wav");
			menu_current = menu_loadprofile;
			Run_Reinit_List(menu_loadprofile.reinit_list);
		}

		return FALSE;
	};
	
	uielement_c delconfirm_buttons = spawn(uielement_c, owner: menu_deleteconfirm, anchor: '0.5 0.5', justify: '0.5 0', size: '192 32');
		delconfirm_buttons.input = quit_input;

	spawn(uifill_c, owner: delconfirm_buttons, anchor: '0.5 0', justify: '0.5 0', origin: '0 -64', size: '394 104', color: '0.05 0.05 0.05', alpha: 0.65);
	uitext_c txt = spawn(uitext_c, owner: delconfirm_buttons, anchor: '0.5 0', origin: '0 -56', justify: '0.5 0', size: '24 24', text: strzone("  "), font: FONT_USER7);
		menu_deleteconfirm.partner = txt; // partner is for profile name
	uitext_c txt = spawn(uitext_c, owner: delconfirm_buttons, anchor: '0.5 0', origin: '0 -32', justify: '0.5 0', size: '14 14', text: _("UI_DELETECONFIRM"), font: FONT_USER7);
	
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_loadprofile;
	}
	uitext_c txtbutton = spawn(uitext_c, owner: delconfirm_buttons, anchor: '0.5 0.5', justify: '0 0.5', origin: '-184 0', padding: '24 8',
		size: '32 32', text: _("UI_NO"), font: FONT_USER7, flags: UIFLAG::CLICKABLE);
		txtbutton.prerender = text_highlight;
		txtbutton.m_click = button_click;
	
	void(uielement_c this) button_click = {
		deleteprofile_byname(profilename);

		localsound("sounds/menu.wav");
		menu_current = menu_main;
		Run_Reinit_List(menu_current);
		Run_Reinit_List(menu_loadprofile.reinit_list);
	}
	uitext_c txtbutton = spawn(uitext_c, owner: delconfirm_buttons, anchor: '0.5 0.5', justify: '1 0.5', origin: '184 0', padding: '24 8',
		size: '32 32', text: _("UI_YES"), font: FONT_USER7, flags: UIFLAG::CLICKABLE);
		txtbutton.prerender = text_highlight;
		txtbutton.m_click = button_click;
	//
}

void MenuInit_CreateProfile()
{
	static void() profile_steam_openkeyboard = {
		if (cvar_string("steam_id") != "")
		{
			cmd(sprintf("steam_openkeyboard 0 %.0f %.0f %.0f %.0f\n", 1, 1, 400, 200));
		}
	};

	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		uifill_c box = (uifill_c)this.partner;
		uitext_c txt = (uitext_c)box.partner;
		if (nkey == K_ESCAPE)
		{
			localsound("sounds/menu.wav");
			menu_current = menu_main;
			Run_Reinit_List(menu_current);
			return;
		}

		if (!released)
		{
			if (ui_hover == this.partner && ui_selected == this.partner)
			{
				if (nkey == K_MOUSE1)
				{
					profile_steam_openkeyboard();
				}
			}

			if (ui_selected == this.partner)
			{
				if (nkey == K_BACKSPACE)
				{
					string str = strcat(txt.text);
					if (strlen(str) <= 0)
						return;
					
					strunzone(txt.text);
					txt.text = substring(str, 0, strlen(str) - 1);
					txt.text = strzone(txt.text);
					goto validatesave;
				}

				if ((ascii >= 48) && (ascii <= 57) || (ascii >= 65) && (ascii <= 90) || (ascii >= 97) && (ascii <= 122))
				{
					if (strlen(txt.text) < 16)
					{
						string str = strcat(txt.text);

						strunzone(txt.text);
						str = strcat(str, chr2str(ascii));
						txt.text = strzone(str);
					}
					goto validatesave;
				}

				return;
				validatesave:
				uifill_c box = (uifill_c)this.partner;
				uitext_c txt = (uitext_c)box.partner;
				uitext_c accept = (uitext_c)box.partner2;
				uitext_c warningdup = (uitext_c)box.partner3;
				uitext_c warningamt = (uitext_c)box.partner4;

				// check for empty
				if (!txt.text)
				{
					warningdup.flags |= UIFLAG::HIDE;
					warningamt.flags |= UIFLAG::HIDE;
					accept.flags |= UIFLAG::HIDE;
					return;
				}

				// check for duplicates
				warningdup.flags |= UIFLAG::HIDE;
				warningamt.flags |= UIFLAG::HIDE;
				accept.flags &= ~UIFLAG::HIDE;
				
				if (strtolower(txt.text) == "default")
				{
					warningdup.flags &= ~UIFLAG::HIDE;
					accept.flags |= UIFLAG::HIDE;
					return;
				}
				
				// Reki (February 2 2024): fgsfds...
				#if 0
				float f = fopen("profiles/profilenames.txt", FILE_READ);
				if (f < 0)
					return;
				
				float lnnum;
				string ln;
				do {
					ln = fgets(f);
					if (strtolower(ln) == strtolower(txt.text))
					{
						warningdup.flags &= ~UIFLAG::HIDE;
						accept.flags |= UIFLAG::HIDE;
						fclose(f);
						return;
					}
					if (ln != "")
						lnnum++;
				} while(ln);

				if (lnnum >= menu_loadprofile_slots.length)
				{
					warningamt.flags &= ~UIFLAG::HIDE;
					accept.flags |= UIFLAG::HIDE;
				}

				fclose(f);
				#else
				float sb = search_begin("data/profiles/*/menu.version", TRUE, TRUE);
				if (sb >= 0)
				{
					float numprof = search_getsize(sb);
					for(float i = 0; i < numprof; i++)
					{
						string fullpath = search_getfilename(sb, i);
						float argc = tokenizebyseparator(fullpath, "/");
						string profname = argv(2);
						if (strtolower(profname) == strtolower(txt.text))
						{
							warningdup.flags &= ~UIFLAG::HIDE;
							accept.flags |= UIFLAG::HIDE;
						}
					}

					search_end(sb);
				}
				#endif
				//
			}
		}

		return FALSE;
	};
	void(uilist_c this) option_reinit = {
		uifill_c box = (uifill_c)this.partner;
		uitext_c txt = (uitext_c)box.partner;
		uitext_c accept = (uitext_c)box.partner2;
		uitext_c warningdup = (uitext_c)box.partner3;
		uitext_c warningamt = (uitext_c)box.partner4;

		strunzone(txt.text);
		txt.text = strzone("");

		accept.flags |= UIFLAG::HIDE;
		warningdup.flags |= UIFLAG::HIDE;
		warningamt.flags |= UIFLAG::HIDE;
		
		ui_selected = this.partner;
	};
	
	ui_scale = '1 1';
	menu_createprofile = spawn(uielement_c, flags: UIFLAG::STRETCH);
	menu_createprofile.active_condition = menu_conditional;
	menu_createprofile.input = option_input;
	menu_createprofile.reinit = option_reinit;

	uilist_c menu_buttons = spawn(uilist_c, owner: menu_createprofile, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 240', separation: '0 24');

	static vector profile_box_pos;
	void(uifill_c this, __inout vector color_to_render, __inout float alpha_to_render) box_prerender = {
		profile_box_pos = ui_position;
		if (ui_selected == this)
		{
			color_to_render *= 1.1;
			alpha_to_render = 0.6;
		}
	}
	void(uielement_c this) box_click = {
		profile_steam_openkeyboard();
	}
	uifill_c box = spawn(uifill_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0.5', size: '360 32', color: '0.2 0.2 0.23', alpha: 0.4,
		flags: UIFLAG::CLICKABLE | UIFLAG::SELECTABLE | UIFLAG::HIGHLIGHT);
		box.prerender = box_prerender;
		box.m_click = box_click;
	menu_createprofile.partner = box;

	spawn(uitext_c, owner: box, justify: '0 1', origin: '0 -2', size: '12 12', color: OPTIONS_TEXT_COLOR, text: _("UI_CREATEPROFILE"));
	box.partner = spawn(uitext_c, owner: box, justify: '0 0.5', anchor: '0 0.5', origin: '4 0', size: '12 12', color: OPTIONS_TEXT_COLOR, text: _("UI_CREATEPROFILE"));
		((uitext_c)box.partner).text = strzone("");

	
	float(uielement_c this) blink_active = {
		if (ui_selected != this.owner.owner)
			return FALSE;
		if ((cltime * 2) % 2 >= 1)
			return TRUE;
		return FALSE;
	}
	uitext_c blinking = spawn(uitext_c, owner: box.partner, justify: '0 0.5', anchor: '1 0.5', size: box.partner.size, color: '1 1 1', text: "_");
		blinking.active_condition = blink_active;


	// Accept
	MenuInit_CreateProfile_Difficulty();
	void(uielement_c this) button_click = {
		uifill_c box = (uifill_c)menu_createprofile.partner;
		uitext_c txt = (uitext_c)box.partner;
		
		profilename = strzone(strcat(txt.text));
		float f = fopen(sprintf("profiles/%s.frk", profilename), FILE_WRITE);	//open what file to use in write mode
		if (f < 0)
			return;
		
		fputs(f, "0\n");	//and again
		fclose(f);
		
		write_currentprofileslot_byname(profilename, 0);
		cmd("set infinite_saves 0\n");
		menu_current = menu_createprofile_difficulty;
		Run_Reinit_List(menu_createprofile_difficulty);
		//write_currentprofileslotfirsttime();
		//write_menuversion();
	};

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '16 16', text: _("UI_ACCEPT"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE | UIFLAG::HIDE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	box.partner2 = txt;

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '16 16', text: _("UI_DUPLICATESAVE"), font: FONT_MENU, color: HIGHLIGHT_TEXT_COLOR, flags: UIFLAG::HIDE, padding: '48 32');
	box.partner3 = txt;

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '16 16', text: _("UI_TOOMANYSAVES"), font: FONT_MENU, color: HIGHLIGHT_TEXT_COLOR, flags: UIFLAG::HIDE, padding: '48 32');
	box.partner4 = txt;
	//

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_main;
		Run_Reinit_List(menu_current);
	};
	uitext_c txt = spawn(uitext_c, owner: menu_createprofile, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//
}

float skill_outlander_unlocked;
void MenuInit_CreateProfile_Difficulty()
{
	float(uielement_c this, float nkey, float ascii, float released) option_input = {
		if (released)
			return;
		
		if (nkey == K_ESCAPE)
		{
			localsound("sounds/menu.wav");
			menu_current = menu_main;
			Run_Reinit_List(menu_current);
			return;
		};

		return FALSE;
	};
	
	ui_scale = '1 1';
	menu_createprofile_difficulty = spawn(uielement_c, flags: UIFLAG::STRETCH);
	menu_createprofile_difficulty.active_condition = menu_conditional;
	menu_createprofile_difficulty.input = option_input;

	uilist_c menu_buttons = spawn(uilist_c, owner: menu_createprofile_difficulty, anchor: '0.5 0.5', justify: '0.5 0.5', size: '192 360', separation: '0 56');

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', origin: '0 -16', justify: '0.5 0', size: '16 16', text: _("UI_DIFFICULTY"), color: OPTIONS_HEADER_TEXT_COLOR, font: FONT_MENU);
	spawn(uifill_c, owner: txt, anchor: '0.5 1', justify: '0.5 0', origin: '0 2', size: [txt.totalsize()[0], 2], color: OPTIONS_HEADER_COLOR, alpha: 0.3);

	// Difficulty buttons
	void(uielement_c this) button_click = {
		read_currentprofileslot();
		createprofile_byname(profilename);
		write_menuversion_byname(profilename);
		
		cmd("togglemenu\n");
		cmd(sprintf("set skill %g\n", this.button_index));
		cmd("map intro\n");
		localsound("sounds/menu.wav");
		menu_current = menu_main;
		Run_Reinit_List(menu_current);
	};

	void(uielement_c this) outlander_active = {
		return skill_outlander_unlocked;
	};

	void(uielement_c this) outlander_reinit = {
		float f;
		skill_outlander_unlocked = 0;
		
		f = fopen("statistics/gamecomplete", FILE_READ);
		if (f >= 0)
		{
			string str;
			while(str = fgets(f))
			{
				float argc = tokenizebyseparator(str, ",");
				if (argc >= 2)
				{
					string campaign = argv(0);
					float value = stof(argv(1));
					if (campaign == "mainstory")
					{
						skill_outlander_unlocked = value;
					}
				}
			}
		}
	};

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '16 16', text: _("UI_DIFFICULTY_EASY"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32', button_index: 0);
		txt.prerender = text_highlight;
		txt.m_click = button_click;
	
	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '16 16', text: _("UI_DIFFICULTY_MEDIUM"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32', button_index: 1);
		txt.prerender = text_highlight;
		txt.m_click = button_click;

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '16 16', text: _("UI_DIFFICULTY_HARD"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32', button_index: 2);
		txt.prerender = text_highlight;
		txt.m_click = button_click;

	uitext_c txt = spawn(uitext_c, owner: menu_buttons, anchor: '0.5 0', justify: '0.5 0', size: '16 16', text: _("UI_DIFFICULTY_OUTLANDER"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR + '0.3 -0.32 -0.34', padding: '48 32', button_index: 3);
		txt.prerender = text_highlight;
		txt.m_click = button_click;
		txt.active_condition = outlander_active;
		txt.reinit = outlander_reinit;
		Add_To_Reinit_List(menu_createprofile_difficulty, txt);
	//

	// Back
	void(uielement_c this) button_click = {
		localsound("sounds/menu.wav");
		menu_current = menu_main;
		Run_Reinit_List(menu_current);
	};
	uitext_c txt = spawn(uitext_c, owner: menu_createprofile, anchor: '0.5 0.5', origin: '0 180', justify: '0.5 0', size: '16 16', text: _("UI_BACK"), font: FONT_MENU,
		flags: UIFLAG::CLICKABLE, color: OPTIONS_TEXT_COLOR, padding: '48 32');
		txt.prerender  = text_highlight;
		txt.m_click = button_click;
	//
}
#endif

void Menu_RendererRestarted()
{
	cmd(sprintf("set vid_conwidth %g\n", cvar("vid_width")/2));
	cmd(sprintf("set vid_conheight %g\n", cvar("vid_height")/2));
}

float oldtime;
void menu_anydraw(void)
{
	time = gettime();
	static float oldtime;
	oldtime = cltime;
 	cltime = gettime();
 	clframetime = oldtime ? cltime - oldtime : 0.1;
	input_frame(); // input handler

	//
	if (ui_usemouse && !ui_oldusemouse)
	{
		thumbstick_mouse = [cvar("vid_conwidth") / 2, cvar("vid_conheight") / 2];
	}
	ui_oldusemouse = ui_usemouse;
	//

	// Reki (November 20 2023): Steam init for first time setup
	if (steam_init_check)
	{
		if (cvar_string("steam_id") != "")
		{
			steam_init_check = FALSE;
			cmd("set steam_firsttime 1\n");

			if (cvar_string("steam_name") != "") // if a valid steam name was fetched, set it
				cmd("name \"", cvar_string("steam_name"), "\"\n");

			string lang = cvar_string("steam_language");
			if (lang && lang != cvar_string("prvm_language"))
			{
				cmd(sprintf("set prvm_language %s\n", cvar_string("steam_language")));
				cmd("menu_restart\ntogglemenu\n");
			}
		}
	}
	//

	if (cltime > statistics_FileOpTime)
	{
		statistics_FileOpTime = cltime + 1;
		Achievements_RunFileOperations();
		Stats_RunFileOperations();
	}

	if (oldtime <= steam_initTime && cltime > steam_initTime) // HACK: wait a bit then init steam
	{
		Steam_InitStats();
	}

	vid_x = cvar("vid_conwidth");
	vid_y = cvar("vid_conheight");
	float rvid_x = cvar("vid_width");
	float rvid_y = cvar("vid_height");
	vid_width = vid_x;
	vid_height = vid_y;
	vid_rwidth = rvid_x;
	vid_rheight = rvid_y;

	#if NEW_MENU
	// Reki: Hud Scaling
	#define HUD_W	820
	#define HUD_H	500
	float hud_scaling = 1;
	vector hud_ratio = [vid_width / HUD_W, vid_height / HUD_H];
	if (vid_height < HUD_H || vid_width < HUD_W)
	{
		hud_scaling = min(vid_width / HUD_W, vid_height / HUD_H);
		if (hud_scaling < 0.75 && hud_scaling > 0.5) // snap to 50% scaling if possible
			hud_scaling = 0.5;
	}
	else
	{
		hud_scaling = max(1, min(floor(vid_height / HUD_H), floor(vid_width / HUD_W)));
	}
	ui_scale = [hud_scaling, hud_scaling];
	//
	#endif
}

void m_drawloading(vector screensize, float opaque)
{
	in_loadingscreen = TRUE;
	menu_anydraw();

	if (opaque)
		drawfill('0 0', screensize, '-1 -1 -1', 1, DRAWFLAG_NORMAL);
	
	#if NEW_MENU // render game overlay
	ui_usemouse = FALSE;
	ui_renderframe = TRUE;
	ui_alpha = 1;
	for(uielement_c ui_chain = menu_loading; ui_chain; ui_chain = ui_chain._next)
	{
		UI_RenderElements(ui_chain);
	}
	drawresetcliparea();
	ui_clipsize = '0 0';
	ui_renderframe = FALSE;
	#endif
}

void m_draw(float a, float b)
{
	in_loadingscreen = FALSE;
	menu_anydraw();
	
	check_vectorcolors();
 	if (slayerstate != 1)
 	{
 		if (slayeralpha > 1)
 			slayerstate = 1;

 		slayeralpha += clframetime *1.5;
 	}
 	else
 	{
 		slayeralpha -= clframetime *1.5;
 		if (slayeralpha < 0.1)
 			slayerstate = 0;
 	}

	#if NEW_MENU
	in_game = (isserver() || (clientstate() == CS_CONNECTED));
	#endif

 	float deadmenu;
 	deadmenu = cvar("scratch3");

 	/*	if(vid_x / vid_y == 16/9)
 		{*/
 		vid_rx = cvar("vid_width");
 		vid_ry = cvar("vid_height");

 		if (((vid_rx == 2560) && (vid_ry == 1440))||((vid_rx == 2560) && (vid_ry == 1080))||((vid_rx == 3440) && (vid_ry == 1440))||((vid_rx == 5120) && (vid_ry == 2160)))
		{	
	 	vx_rel = ((vid_x / 1134));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 0;
		}
 		else if ((vid_rx == 4096) && (vid_ry == 2160))
		{	
	 	vx_rel = ((vid_x / 1134));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 0;
		}
 		else if ((vid_rx == 3840) && (vid_ry == 1600))
		{	
	 	vx_rel = ((vid_x / 1134));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 0;
		}

		else
		{
		vx_rel = ((vid_x / 960));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 1;
		}
		/*	}

 		if(vid_x / vid_y == 4/3)
 		{
 		vx_rel = (vid_x / 960);
 		vy_rel = (vid_y / 640);
 		}

 		if(vid_x / vid_y == 5/3)
 		{
 		vx_rel = (vid_x / 640);
 		vy_rel = (vid_y / 384);
 		}

 		if(vid_x / vid_y == 5/4)
 		{
 		vx_rel = (vid_x / 640);
 		vy_rel = (vid_y / 512);
 		}

 		if(vid_x / vid_y == 16/10)
 		{
 		vx_rel = (vid_x / 640);
 		vy_rel = (vid_y / 400);
 		}

 	*/
 	menuingame = 0;

 	float imgsizex, imgsizey, img2sizex, img2sizey, img3sizex, img3sizey;

 	imgsizex = 256 * vx_rel;
 	imgsizey = 32 * vy_rel;
 	img2sizex = 128 * vx_rel;
 	img2sizey = 32 * vy_rel;
 	img3sizex = 32 * vx_rel;
 	img3sizey = 32 * vy_rel;

 	BTT_FONT_SIZE = fixed_vector('16 16 0');
 	BTT_IMG_SIZE_x = imgsizex;
 	BTT_IMG_SIZE_y = imgsizey;
 	BTT_IMG_SIZE2_x = img2sizex;
 	BTT_IMG_SIZE2_y = img2sizey;
 	BTT_IMG_SIZE3_x = img3sizex;
 	BTT_IMG_SIZE3_y = img3sizey;
	
	#if !NEW_MENU
 	updateMouse();
	#endif

 	local float w;
 	if (Menu_Active)
 	{
 		if (getmousetarget() != MT_MENU || getkeydest() != KEY_MENU)
 			m_hide();
 	}

 	if (!Menu_Active)
 	{
		#if NEW_MENU // render game overlay
		ui_usemouse = FALSE;
		ui_renderframe = TRUE;
		ui_alpha = 1;
		for(uielement_c ui_chain = menu_gameoverlay; ui_chain; ui_chain = ui_chain._next)
		{
			UI_RenderElements(ui_chain);
		}
		drawresetcliparea();
		ui_clipsize = '0 0';
		ui_renderframe = FALSE;
		#endif
		return;
	}

	if (deadmenu)
	{
		m_hide();
		return;
	}

	#if NEW_MENU
	// render UI elements
	vector mouse_move = getpointerpos();
	//mouse_move = [mouse_move[0] * ui_scale[0], mouse_move[1] * ui_scale[1]];

	ui_clipsize = '0 0';
	ui_oldhover = ui_hover;
	float old_usemouse = ui_usemouse;
	ui_hover = __NULL__;
	
	#define HW_CURSOR 1
	#if HW_CURSOR == 0
	if (getmousetarget() == MT_MENU)
	{
		ui_mouseposition[0] = bound(0, ui_mouseposition[0] + mouse_move[0], vid_width);
		ui_mouseposition[1] = bound(0, ui_mouseposition[1] + mouse_move[1], vid_height);
	}
	#else
	if (getmousetarget() == MT_MENU)
	{
		ui_mouseposition = mouse_move;
	}
	#endif

	ui_usemouse = FALSE;
	ui_renderframe = TRUE;
	ui_alpha = 1.0;
	for(uielement_c ui_chain = ui_screen_queue; ui_chain; ui_chain = ui_chain._next)
	{
		UI_RenderElements(ui_chain);
	}
	if (!ui_usemouse)
		ui_hover = __NULL__;
	if (ui_hover != ui_oldhover)
	{
		if (ui_oldhover.m_leave)
			ui_oldhover.m_leave(ui_oldhover);
	}
	if (ui_hover && ui_hover.m_over)
		ui_hover.m_over(ui_hover);
	drawresetcliparea();
	ui_clipsize = '0 0';
	ui_renderframe = FALSE;
	//

	drawpic(ui_mouseposition + '-1 -1', "gfx/cursor", [24 * ui_scale[0], 24 * ui_scale[1]], ' 1 1 1', 1, DRAWFLAG_NORMAL);
	#else
 	local vector size, buttions_locs;
 	size_x = vid_x;
 	size_y = vid_y;
 	buttions_locs_x = ((vid_x / 2) - 128) *vx_rel;
 	buttions_locs_y = 196 * vy_rel;

 	if (clientstate() != CS_CONNECTED)
 	{
 		// Draw the background
 		drawpic('0 0 0', "gfx/conback", size, ' 1 1 1', 1, 0);
 		local vector txt_pos;
 		if (menutype == M_TYPE_SKILL) {}
 		else if (menutype == M_YNQ)
 		{
 			drawfill('0 0 0', vid_x *'1 0 0' + vid_y *'0 1 0', '0 0 0', 0.65, 0);
 			drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '1 1 1', 1, 0);
 			drawpic(fixed_vector('228 64 0'), "gfx/menu/logo.tga", fixed_vector('504 136 0'), '1 1 1', 1, 0);
 			w = stringwidth("Are you sure you want to quit?", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0' - 8 *'0 1 0', "Are you sure you want to quit?", '8 8 0', 1, 0);
 			w = stringwidth("Press ^1Y^7 to quit, ^1N^7!", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0', "Press ^1Y^7 to quit, ^1N^7!", '8 8 0', 1, 0);
 		}
 		else if (menutype == M_TYPE_CREDITS) {}
 		else if (menutype == M_TYPE_HELP) {}
 		else if (menutype == M_TYPE_OPTIONS)
 			menu_type_options();

 		else if (menutype == M_TYPE_SELECT_DIFFICULT)
 			menu_type_difficult();

 		else if (menutype == M_TYPE_AUDIO)
 			menu_type_options_audio();
 		else if (menutype == M_TYPE_CONTROLS)
 			menu_type_options_controls();
 		else if (menutype == M_TYPE_CONTROLBINDS)
 			menu_type_options_controlbinds();
 		else if (menutype == M_TYPE_GAMEPLAY)
 			menu_type_options_gameplay();
 		else if (menutype == M_TYPE_VIDEO)
 			menu_type_options_video();
 		else if (menutype == M_TYPE_RESOLUTION)
 			menu_type_options_resolution();
 		else if (menutype == M_TYPE_CONFIRMRESOLUTION)
 			menu_type_confirmresolution();
 		else if (menutype == M_TYPE_CONFIRMBIND)
 			menu_type_confirmbind(0);
 		else if (menutype == M_TYPE_CONFIRMANTIALIAS)
 			menu_type_confirmantialias();
 		else if (menutype == M_TYPE_CONFIRMFULLSCREEN)
 			menu_type_confirmfullscreen();
		else if (menutype == M_TYPE_DELETEPROFILE)
		menu_type_deleteprofile();
		else if (menutype == M_TYPE_CONTROLRESTART)
		menu_type_confirmresettodefaults();
 		else if (menutype == M_TYPE_RESUME)
 			menu_type_resume();

 		else if (menutype == M_TYPE_PROFILE)
 			menu_type_profile(txt_pos);
 		else
 			menu_type_main(txt_pos);
 	}
 	else
 	{
 		if (menutype == M_TYPE_NONE)
 			zmenuingame = 1;
 		else
 			zmenuingame = 0;

 		if (menutype == M_TYPE_NONE)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			if (!pausesound)
 				cmd("pausesound 1\n");
 			pausesound = 1;

 			menu_type_ingame();
 		}
 		else if (menutype == M_TYPE_DNONE)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			w = stringwidth("Are you sure you returnt to main menu? Not saved progress will be lost", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0' - 8 *'0 1 0', "Are you sure you want to quit2? Not saved progress will be lost", '8 8 0', 1, 0);
 			w = stringwidth("Press ^1Y^7 to quit, ^1N^7!", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0', "Press ^1Y^7 to quit, ^1N^7!", '8 8 0', 1, 0);
 		}
 		else if (menutype == M_TYPE_OPTIONS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options();
 		}
 		else if (menutype == M_TYPE_AUDIO)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_audio();
 		}

		else if (menutype == M_TYPE_CONTROLS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_controls();
 		}
		else if (menutype == M_TYPE_CONTROLRESTART)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
			menu_type_confirmresettodefaults();
 		}
 		else if (menutype == M_TYPE_CONTROLBINDS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_controlbinds();
 		}
 		else if (menutype == M_TYPE_GAMEPLAY)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_gameplay();
 		}
 		else if (menutype == M_TYPE_VIDEO)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_video();
 		}
 		else if (menutype == M_TYPE_RESOLUTION)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_resolution();
 		}
 		else if (menutype == M_TYPE_CONFIRMRESOLUTION)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmresolution();
 		}
 		else if (menutype == M_TYPE_CONFIRMBIND)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmbind(0);
 		}
 		else if (menutype == M_TYPE_CONFIRMANTIALIAS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmantialias();
 		}
 		else if (menutype == M_TYPE_CONFIRMFULLSCREEN)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmfullscreen();
 		}
 		else if (menutype == M_YND)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			w = stringwidth("Are you sure you want to return to main menu? Not saved progress will be lost", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0' - 8 *'0 1 0', "Are you sure you want to quit3? Not saved progress will be lost", '8 8 0', 1, 0);
 			w = stringwidth("Press ^1Y^7 to quit, ^1N^7!", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0', "Press ^1Y^7 to quit, ^1N^7!", '8 8 0', 1, 0);
 		}
		else		
		{
		cmd("menu_restart\n");
		menutype = M_TYPE_NONE;
		}
 	}

 	drawpic(mouse_pos + fixed_vector('16 20 0'), "gfx/cursor", fixed_vector ('24 24 0'), ' 1 1 1', 1, 0);
	#endif
 };

 void() m_display = {
	vid_x = cvar("vid_conwidth");
 	vid_y = cvar("vid_conheight");
 	Menu_Active = true;
 	setkeydest(KEY_MENU);
 	setmousetarget(MT_MENU);
	#if NEW_MENU
	if (in_game)
 		menu_current = menu_main_game;
	else
		menu_current = menu_main;
	#endif
	Run_Reinit_List(menu_current);
 };

 void() m_hide = {
	if (pausesound)
 	{
 		cmd("pausesound 0\n");
		cmd("impulse 82\n");
 		pausesound = 0;
 	}
 	menutype = M_TYPE_NONE;
 	zmenuingame = 0;
 	menuingame = 1;
 	Menu_Active = false;
 	setkeydest(KEY_GAME);
 	setmousetarget(MT_CLIENT);
#if NEW_MENU
	menu_current = __NULL__;
 #endif
 };

 void(float n) m_toggle = { menutype = M_TYPE_NONE;
 	Menu_Active = n;
 	if (Menu_Active)
 		m_display();
 	else
 		m_hide();
 };

 void() m_shutdown = {};
	///