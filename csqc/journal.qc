
#include "journal.h"
#include "localized_assets.h"
uipicture_c journal_ui;

void Journal_ScrollToCurrentMap(void)
{
	float elements = 0;
	float currentmap = 0;
	uielement_c chain;
	for(chain = journal_world_list._list; chain; chain = chain._next)
	{
		if (chain.active_condition)
			if (!chain.active_condition(chain))
				continue;
		
		if (chain == journal_world_scrollto)
			currentmap = elements;
		elements++;
	}
	
	journal_world_list.elements_temp = elements;
	journal_world_list.scroll = currentmap;
	ui_selected = journal_world_currentmap;
	((uismoothlist_c)journal_world_list).scroll_smooth = journal_world_list.scroll;
}

void read_frik_stats(string mapname, __out string enemies, __out string secrets, __out string relics, __out string time)
{
	enemies = "0/0";
	secrets = "0/0";
	relics = "0/0";
	time = "0:00";

	float filehandle;
	read_currentprofileslot();
	filehandle = fopen((strcat("profiles/", profilename, "/maps/", mapname, ".stats")), FILE_READ);
	if (filehandle < 0)
		return;

	enemies = fgets(filehandle);	//read the text
	secrets = fgets(filehandle);
	relics = fgets(filehandle);
	time = fgets(filehandle);
	fclose(filehandle);
}

void Journal_Init(void)
{
	float(uielement_c this) condtional = { return showjournal == 1; }
	float(uielement_c this, float nkey, float ascii, float released) journal_input = {
		if (released)
			return FALSE;
		
		if (nkey == K_XIN_BUMP_LEFT)
			journal_chapter--;
		else if (nkey == K_XIN_BUMP_RIGHT)
			journal_chapter++;
		else
			return FALSE;
		
		if (journal_chapter < 1)
			journal_chapter = 4;
		else if (journal_chapter > 4)
			journal_chapter = 1;

		return TRUE;
	}

	journal_ui = spawn(uipicture_c, image: journal_assets[JOURNAL_IMG::JOURNAL], size: '512 400', anchor: '0.5 0.5', justify: '0.5 0.5');
	journal_ui.active_condition = condtional;
	journal_ui.input = journal_input;

	void(uipicture_c this, __inout string img_to_render) tab_prerender = { if (journal_chapter != this.skin && ui_hover != this) img_to_render = __NULL__; };
	void(uielement_c this) tab_click = { journal_chapter = this.skin; Journal_Sound(); }

	void(uipicture_c this, __inout string img_to_render) scroll_prerender = { if (ui_hover == this) img_to_render = this.image2; };
	float(uielement_c this) scroll_conditional = {
		if (journal_chapter != this.colormap)
			return FALSE;
		uilist_c list = (uilist_c)this.partner;

		// check if this scroll arrow should even show
		if (this.skin > 0)
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
		list.scroll += this.skin;
		Journal_Sound();
	};


	float(uielement_c this) page_condtional = { if (journal_chapter != this.skin) return FALSE; return TRUE; }
	//uipicture_c page = spawn(uipicture_c, owner: journal_ui,
	//		flags: UIFLAG::FILL, color: '0.3 0.3 0.32', alpha: 0.9,
	//		origin: '82 24', size: '128 300');

	typedef struct journalitem_t {
		float itflag;
		float label_index;
		string pageimage;
	};

	////////////////////
	////   World Section
	////////////////////
	void(uielement_c this) tab_world_click = { journal_chapter = this.skin; Journal_Sound(); Journal_ScrollToCurrentMap(); }
	uipicture_c tab = spawn(uipicture_c, owner: journal_ui,
		origin: '51 336', anchor: '0 0', justify: '0 0',
		size: '88 48', image: journal_assets[JOURNAL_IMG::TABA_ACTIVE], skin: 1, flags: UIFLAG::CLICKABLE);
		tab.prerender = tab_prerender;
		tab.m_click = tab_world_click;
	
	uielement_c page = spawn(uismoothlist_c, owner: journal_ui, origin: '82 80', size: '128 192', separation: '0 192', skin: 1, flags: UIFLAG::CLIP, smoothspeed: 5);
		page.active_condition = page_condtional;
	uielement_c page2 = spawn(uielement_c, owner: journal_ui, origin: '256 24', size: '216 304', skin: 1);
		page2.active_condition = page_condtional;
	journal_world_list = (uilist_c)page;
	{
		typedef struct journalmap_t {
			float itflag;
			float relicflag;
			string name;
			float stattype;
			float episode;
			float label_index;
			float page_index;
		};

		void(uipicture_c this, __inout string img_to_render) map_prerender = { if (ui_selected == this || ui_hover == this) img_to_render = this.image2; };
		void(uilocpicture_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) map_prerendertext = {
				if (ui_selected == this || ui_hover == this) color_to_render = '1 1 1';
				else color_to_render = '-1 -1 -1';
			};
		float(uielement_c this) map_isselected = { if (ui_selected == this.partner) return TRUE; return FALSE; };
		void(uielement_c this) map_click = { Journal_Sound(); };
		float(uielement_c this) map_hasitem = { if ((jitems_visitedmaps & this.skin) == this.skin) return TRUE; return FALSE; };
		float(uielement_c this) map_hasrelic = { if ((jitems_relics & this.skin) == this.skin) return TRUE; return FALSE; }
		
		void(uielement_c this, __inout vector position) map_stat_current_preloop = { // preloop function to update stats for current map
			uitext_c txt;
			if (this.partner)
			{
				txt = (uitext_c)this.partner;
				if (txt.skin <= 0) // normal map
					txt.text = sprintf("%g/%g", getstati(STAT_MONSTERS), getstati(STAT_TOTALMONSTERS));
				else // boss map
					txt.text = sprintf("%g/?", getstati(STAT_MONSTERS));
			}
			if (this.partner2)
			{
				txt = (uitext_c)this.partner2;
				txt.text = sprintf("%g/%g", getstati(STAT_SECRETS), getstati(STAT_TOTALSECRETS));
			}
			if (this.partner3)
			{
				txt = (uitext_c)this.partner3;
				if (this.owner.colormap == 1) // hub maps
				{
					float total_found = 0;
					for(float j = 0; j < 5; j++)
					{
						if (jitems_relics & (txt.skin << j))
							total_found++;
					}
					txt.text = sprintf("%g/5", total_found);
				}
				else
				{
					txt.text = sprintf("%g/1", (jitems_relics & txt.skin) > 0);
				}
			}
			if (this.partner4)
			{
				txt = (uitext_c)this.partner4;
				txt.text = strzone(SG_GetFormattedTimeStringUnZoned(time));
			}
		};

		// define buttons
		journalmap_t map_list[] = {
			{LE_INTRO,RL_INTR, "intro", 0, 0, JOURNAL_LABEL_IMG::INTRO, JOURNAL_PAGE_IMG::INTRO},
			{LE_HUB1, RL_E1M1, "hub1", 1, 1, JOURNAL_LABEL_IMG::HUB1, JOURNAL_PAGE_IMG::HUB1},
			{LE_E1M1, RL_E1M1, "e1m1", 0, 1, JOURNAL_LABEL_IMG::E1M1, JOURNAL_PAGE_IMG::E1M1},
			{LE_E1M2, RL_E1M2, "e1m2", 0, 1, JOURNAL_LABEL_IMG::E1M2, JOURNAL_PAGE_IMG::E1M2},
			{LE_E1M3, RL_E1M3, "e1m3", 0, 1, JOURNAL_LABEL_IMG::E1M3, JOURNAL_PAGE_IMG::E1M3},
			{LE_E1M4, RL_E1M4, "e1m4", 0, 1, JOURNAL_LABEL_IMG::E1M4, JOURNAL_PAGE_IMG::E1M4},
			{LE_E1M5, RL_E1M5, "e1m5", 0, 1, JOURNAL_LABEL_IMG::E1M5, JOURNAL_PAGE_IMG::E1M5},
			{LE_BOSS1,RL_BOSS1,"boss1", 2, 1, JOURNAL_LABEL_IMG::BOSS1, JOURNAL_PAGE_IMG::BOSS1},
			{LE_HUB2, RL_E2M1, "hub2", 1, 2, JOURNAL_LABEL_IMG::HUB2, JOURNAL_PAGE_IMG::HUB2},
			{LE_E2M1, RL_E2M1, "e2m1", 0, 2, JOURNAL_LABEL_IMG::E2M1, JOURNAL_PAGE_IMG::E2M1},
			{LE_E2M2, RL_E2M2, "e2m2", 0, 2, JOURNAL_LABEL_IMG::E2M2, JOURNAL_PAGE_IMG::E2M2},
			{LE_E2M3, RL_E2M3, "e2m3", 0, 2, JOURNAL_LABEL_IMG::E2M3, JOURNAL_PAGE_IMG::E2M3},
			{LE_E2M4, RL_E2M4, "e2m4", 0, 2, JOURNAL_LABEL_IMG::E2M4, JOURNAL_PAGE_IMG::E2M4},
			{LE_E2M5, RL_E2M5, "e2m5", 0, 2, JOURNAL_LABEL_IMG::E2M5, JOURNAL_PAGE_IMG::E2M5},
			{LE_BOSS2,RL_BOSS2,"boss2", 2, 2, JOURNAL_LABEL_IMG::BOSS2, JOURNAL_PAGE_IMG::BOSS2},
			{LE_HUB3, RL_E3M1, "hub3", 1, 3, JOURNAL_LABEL_IMG::HUB3, JOURNAL_PAGE_IMG::HUB3},
			{LE_E3M1, RL_E3M1, "e3m1", 0, 3, JOURNAL_LABEL_IMG::E3M1, JOURNAL_PAGE_IMG::E3M1},
			{LE_E3M2, RL_E3M2, "e3m2", 0, 3, JOURNAL_LABEL_IMG::E3M2, JOURNAL_PAGE_IMG::E3M2},
			{LE_E3M3, RL_E3M3, "e3m3", 0, 3, JOURNAL_LABEL_IMG::E3M3, JOURNAL_PAGE_IMG::E3M3},
			{LE_E3M4, RL_E3M4, "e3m4", 0, 3, JOURNAL_LABEL_IMG::E3M4, JOURNAL_PAGE_IMG::E3M4},
			{LE_E3M5, RL_E3M5, "e3m5", 0, 3, JOURNAL_LABEL_IMG::E3M5, JOURNAL_PAGE_IMG::E3M5},
			{LE_BOSS3,RL_BOSS3,"boss3", 2, 3, JOURNAL_LABEL_IMG::BOSS3, JOURNAL_PAGE_IMG::BOSS3},
		};
		//
		
		float map_is_registered = FALSE;



		// check if we're on a registered map
		for(float i = 0; i < map_list.length; i++)
		{
			journalmap_t mapitem = map_list[i];
			if (mapname != sprintf("maps/%s.bsp", mapitem.name))
				continue;
			
			map_is_registered = TRUE;
			break;
		}

		if (!map_is_registered) // custom map, just show name and stats
		{
			uitext_c txt = spawn(uitext_c, owner: page, origin: '0 0', anchor: '0.5 0', justify: '0.5 0', size: '16 16');
			txt.text = strzone(substring(mapname, 5, strlen(mapname) - 9));

			uipicture_c map_page = spawn(uipicture_c, owner: page2, image: "gfx/journal/pages/page_e1m1.tga", size: '216 304', partner: txt);

			uipicture_c stat_page = spawn(uipicture_c, owner: map_page, size: '64 64', origin: '101 244', justify: '1 0',
				image: journal_assets[JOURNAL_IMG::STATS_LEVEL]);

			vector isz = draw_getimagesize(stat_page.image);
			stat_page.size[0] = isz[0] * (64 / isz[1]);

			uitext_c stats_kills = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 5', color: '-1 -1 -1', anchor: '1 0');
			uitext_c stats_secrets = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 20', color: '-1 -1 -1', anchor: '1 0');
			uitext_c stats_relics = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 35', color: '-1 -1 -1', anchor: '1 0', skin: RL_E1M1);
			uitext_c stats_time = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 50', color: '-1 -1 -1', anchor: '1 0');
			
			stat_page.partner = stats_kills;
			stat_page.partner3 = stats_relics;
			stat_page.partner2 = stats_secrets;
			stat_page.partner4 = stats_time;
			stat_page.preloop = map_stat_current_preloop;
			journal_world_scrollto = txt;
		}
		else
		{
			float(uielement_c this) episode_condtional = {
				if (jitems_visitedmaps & this.skin) return TRUE; return FALSE;
			};
			uielement_c ep_page[4];
			ep_page[0] = spawn(uismoothlist_c, owner: page, origin: '0 0', anchor:'0 0', justify: '0 0', size: '128 192', separation: '0 28', colormap: 0);
				ep_page[0].active_condition = episode_condtional;
			ep_page[1] = spawn(uismoothlist_c, owner: page, origin: '0 0', anchor:'0 0', justify: '0 0', size: '128 192', separation: '0 28', colormap: 1);
				ep_page[1].active_condition = episode_condtional;
			ep_page[2] = spawn(uismoothlist_c, owner: page, origin: '0 0', anchor:'0 0', justify: '0 0', size: '128 192', separation: '0 28', colormap: 2);
				ep_page[2].active_condition = episode_condtional;
			ep_page[3] = spawn(uismoothlist_c, owner: page, origin: '0 0', anchor:'0 0', justify: '0 0', size: '128 192', separation: '0 28', colormap: 2);
				ep_page[3].active_condition = episode_condtional;

			// spawn buttons
			for(float i = 0; i < map_list.length; i++)
			{
				journalmap_t mapitem = map_list[i];
				float epnum = mapitem.episode;
				if (epnum < 0 || epnum >= ep_page.length) // invalid episode number
					continue;
				uielement_c episode_entry = ep_page[epnum];
				episode_entry.skin |= mapitem.itflag;
				
				if (mapitem.stattype == -1)
				{
					uitext_c map_spacer = spawn(uitext_c, owner: episode_entry, size: '0 0', text: "", skin: mapitem.itflag);
						map_spacer.active_condition = map_hasitem;
					continue;
				}

				uilocpicture_c map_label = spawn(uilocpicture_c, owner: episode_entry,
					origin: '0 0', anchor: '0.5 0', justify: '0.5 0', size: '128 16', flags: UIFLAG::SELECTABLE | UIFLAG::KEEPSELECT, skin: mapitem.itflag,
					image: journal_label_assets[mapitem.label_index], image2: journal_label_assets[mapitem.label_index + 1], fallback_txt: journal_label_assets_string[mapitem.label_index],
					fallback_sz: '10 10', fallback_color: '-1 -1 -1');
					map_label.active_condition = map_hasitem;
					map_label.prerender = map_prerender;
					map_label.prerender_text = map_prerendertext;
					map_label.m_click = map_click;

				print(sprintf("%s: %s\n", __func__, journal_label_assets[mapitem.label_index + 1]));
				
				uipicture_c map_page = spawn(uipicture_c, owner: page2, size: '216 304',
					image: journal_page_assets[mapitem.page_index], skin: mapitem.itflag, colormap: mapitem.stattype, partner: map_label);
					map_page.active_condition = map_isselected;
				
				float map_is_current = (mapname == sprintf("maps/%s.bsp", mapitem.name));
				if (map_is_current)
				{
					ui_selected = tab.partner = journal_world_currentmap = map_label;
				}
				
				switch (mapitem.stattype)
				{
					case 2:
					case 0:
						//uipicture_c relic_icon = spawn(uipicture_c, owner: map_page, size: '184 184', origin: '16 56', 
						//	skin: mapitem.relicflag, image: strzone(sprintf("gfx/journal/pages/relic_%s_large.tga", mapitem.name)));
						uipicture_c relic_icon = spawn(uipicture_c, owner: map_page, flags: UIFLAG::STRETCH, skin: mapitem.relicflag, image: journal_page_assets[mapitem.page_index + JOURNAL_PAGE_IMG::RELIC_START]);
						relic_icon.active_condition = map_hasrelic;

						// Reki (February 6 2024): for when the journal page is unlocalized and therefore blank
						if (journal_page_blank[mapitem.page_index])
						{
							uitext_c loc_name = spawn(uitext_c, owner: map_page, anchor: '0.5 0', justify: '0.5 0', origin: '0 16', size: '24 24',
									alpha: 0.68, color: CONVERT_TO_DP_SHITTY_COLOR('0 0 0'), text: journal_label_assets_string[mapitem.label_index]);

							float o_font = drawfont; drawfont = loc_name.font;
							float str_width = stringwidth(loc_name.text, TRUE, loc_name.size);
							if (str_width > (map_page.size[0] * 0.9))
							{
								loc_name.size[0] *= (map_page.size[0] * 0.9) / str_width;
							}
							drawfont = o_font;
						}
						//

						uipicture_c stat_page = spawn(uipicture_c, owner: map_page, size: '64 64', origin: '101 244', justify: '1 0',
							image: journal_assets[JOURNAL_IMG::STATS_LEVEL]);

						vector isz = draw_getimagesize(stat_page.image);
						stat_page.size[0] = isz[0] * (64 / isz[1]);

						uitext_c stats_kills = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 5', color: '-1 -1 -1', anchor: '1 0');
						uitext_c stats_secrets = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 20', color: '-1 -1 -1', anchor: '1 0');
						uitext_c stats_relics = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 35', color: '-1 -1 -1', anchor: '1 0', skin: mapitem.relicflag);
						uitext_c stats_time = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 50', color: '-1 -1 -1', anchor: '1 0');
						if (map_is_current)
						{
							stats_kills.skin = (mapitem.stattype == 2);
							stat_page.partner = stats_kills;
							stat_page.partner2 = stats_secrets;
							stat_page.partner3 = stats_relics;
							stat_page.partner4 = stats_time;
							stat_page.preloop = map_stat_current_preloop;
							journal_world_scrollto = episode_entry;
						}
						else
						{
							read_frik_stats(mapitem.name, stats_kills.text, stats_secrets.text, stats_relics.text, stats_time.text);
							stats_kills.text = strzone(stats_kills.text);
							stats_secrets.text = strzone(stats_secrets.text);
							stats_relics.text = strzone(stats_relics.text);
							stats_time.text = strzone(stats_time.text);
						}
						break;
					case 1:
						uipicture_c stat_page = spawn(uipicture_c, owner: map_page, size: '56 56', origin: '93 244', justify: '1 0',
							image: journal_assets[JOURNAL_IMG::STATS_HUB]);
						
						vector isz = draw_getimagesize(stat_page.image);
						stat_page.size[0] = isz[0] * (56 / isz[1]);
						
						if (map_page.skin)
						{
							string epname = substring(mapitem.name, strlen(mapitem.name) - 1, 1);
							vector orgs[] = {'32 168', '7 97', '136 89', '111 168', '71 49'};
							for(float j = 0; j < 5; j++)
							{
								uipicture_c relic_icon = spawn(uipicture_c, owner: map_page, size: '64 64', origin: orgs[j], 
									image: strzone(sprintf("gfx/journal/pages/relic_e%sm%g.tga", epname, j + 1)),
									skin: mapitem.relicflag << j); // use some bitshift magic, our hub relic must be set to RL_ExM1
								relic_icon.active_condition = map_hasrelic;
							}
						}
						
						uitext_c stats_secrets = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 8', color: '-1 -1 -1', anchor: '1 0');
						uitext_c stats_relics = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 23', color: '-1 -1 -1', anchor: '1 0', skin: mapitem.relicflag);
						uitext_c stats_time = spawn(uitext_c, owner: stat_page, size: '12 12', origin: '20 38', color: '-1 -1 -1', anchor: '1 0');
						if (map_is_current)
						{
							stat_page.partner2 = stats_secrets;
							stat_page.partner3 = stats_relics;
							stat_page.partner4 = stats_time;
							stat_page.preloop = map_stat_current_preloop;
							journal_world_scrollto = episode_entry;
						}
						else
						{
							string empty;
							read_frik_stats(mapitem.name, empty, stats_secrets.text, stats_relics.text, stats_time.text);
							stats_secrets.text = strzone(stats_secrets.text);
							stats_time.text = strzone(stats_time.text);

							stat_page.partner3 = stats_relics;
							stat_page.preloop = map_stat_current_preloop;
						}

						// Reki (February 6 2024): for when the journal page is unlocalized and therefore blank
						if (journal_page_blank[mapitem.page_index])
						{
							uitext_c loc_name = spawn(uitext_c, owner: map_page, anchor: '0.5 0', justify: '0.5 0', origin: '0 14', size: '24 24',
									alpha: 0.68, color: CONVERT_TO_DP_SHITTY_COLOR('0 0 0'), text: journal_label_assets_string[mapitem.label_index]);

							float o_font = drawfont; drawfont = loc_name.font;
							float str_width = stringwidth(loc_name.text, TRUE, loc_name.size);
							if (str_width > (map_page.size[0] * 0.9))
							{
								loc_name.size[0] *= (map_page.size[0] * 0.9) / str_width;
							}
							drawfont = o_font;
						}
						//

						break;
				}
			}
			
			// scroll up
			uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 32', anchor: '0 0', justify: '0 0', size: '32 40',
				flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_up", image2: "gfx/journal/arrow_up_active", partner: page, skin: -1, colormap: 1);
				scroll.active_condition = scroll_conditional;
				scroll.prerender = scroll_prerender;
				scroll.m_click = scroll_click;
			// scroll down
			uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 272', anchor: '0 0', justify: '0 0', size: '32 40',
				flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_down", image2: "gfx/journal/arrow_down_active", partner: page, skin: 1, colormap: 1);
				scroll.active_condition = scroll_conditional;
				scroll.prerender = scroll_prerender;
				scroll.m_click = scroll_click;
		}
	//

	////////////////////
	//// Arsenal Section
	////////////////////
	uipicture_c tab = spawn(uipicture_c, owner: journal_ui,
		origin: '144 336', anchor: '0 0', justify: '0 0',
		size: '96 56', image: journal_assets[JOURNAL_IMG::TABB_ACTIVE], skin: 2, flags: UIFLAG::CLICKABLE);
		tab.prerender = tab_prerender;
		tab.m_click = tab_click;

	uielement_c page = spawn(uismoothlist_c, owner: journal_ui, origin: '82 80', size: '128 192', separation: '0 32', skin: 2, flags: UIFLAG::CLIP);
		page.active_condition = page_condtional;
	uielement_c page2 = spawn(uielement_c, owner: journal_ui, origin: '256 24', size: '216 304', skin: 2);
		page2.active_condition = page_condtional;
	{
		void(uipicture_c this, __inout string img_to_render) wep_prerender = { if (jarmory_selected == this.skin || ui_hover == this) img_to_render = this.image2; };
		void(uilocpicture_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) wep_prerendertxt = { if (jarmory_selected == this.skin || ui_hover == this) color_to_render = '0.8 0.8 0.8'; };
		float(uielement_c this) wep_isselected = { if (jarmory_selected == this.partner.skin) return TRUE; return FALSE; };
		void(uielement_c this) wep_click = { Journal_Sound(); jarmory_selected = this.skin; };
		float(uielement_c this) wep_hasitem = { if (jitems_armory & this.skin) return TRUE; return FALSE; };

		// define buttons
		journalitem_t wep_list[] = {
			{IT_MELEE, JOURNAL_LABEL_IMG::MELEE, "gfx/journal/pages/page_melee.tga"},
			{IT_REVOLVER, JOURNAL_LABEL_IMG::REVOLVER, "gfx/journal/pages/page_coachgun.tga"},
			{IT_SHOTGUN, JOURNAL_LABEL_IMG::SHOTGUN, "gfx/journal/pages/page_shotgun.tga"},
			{IT_SPITTER, JOURNAL_LABEL_IMG::SPITTER, "gfx/journal/pages/page_spitter.tga"},
			{IT_RETCHER, JOURNAL_LABEL_IMG::RETCHER, "gfx/journal/pages/page_retcher.tga"},
			{IT_CANNON, JOURNAL_LABEL_IMG::CANNON, "gfx/journal/pages/page_cannon.tga"},
			{IT_LANCE, JOURNAL_LABEL_IMG::LANCE, "gfx/journal/pages/page_lance.tga"},
			{IT_CRYSTAL, JOURNAL_LABEL_IMG::CRYSTALLIZER, "gfx/journal/pages/page_crystallizer.tga"},
			{IT_MACE, JOURNAL_LABEL_IMG::MACE, "gfx/journal/pages/page_mace.tga"},
		};
		//

		// spawn buttons
		for(float i = 0; i < wep_list.length; i++)
		{
			journalitem_t wep = wep_list[i];
			uilocpicture_c wep_label = spawn(uilocpicture_c, owner: page,
				origin: '0 0', anchor: '0.5 0', justify: '0.5 0', size: '128 16', flags: UIFLAG::SELECTABLE | UIFLAG::KEEPSELECT,
				image: journal_label_assets[wep.label_index], image2: journal_label_assets[wep.label_index + 1], fallback_txt: journal_label_assets_string[wep.label_index],
				fallback_sz: '10 10', fallback_color: '-1 -1 -1',
				skin: wep.itflag);
				wep_label.active_condition = wep_hasitem;
				wep_label.prerender = wep_prerender;
				wep_label.prerender_text = wep_prerendertxt;
				wep_label.m_click = wep_click;
			
			uipicture_c wep_page = spawn(uipicture_c, owner: page2, size: '216 304',
				image: wep.pageimage, skin: wep.itflag, partner: wep_label);
				wep_page.active_condition = wep_isselected;
		}
		//

		// scroll up
		uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 32', anchor: '0 0', justify: '0 0', size: '32 40',
			flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_up", image2: "gfx/journal/arrow_up_active", partner: page, skin: -1, colormap: 2);
			scroll.active_condition = scroll_conditional;
			scroll.prerender = scroll_prerender;
			scroll.m_click = scroll_click;
		// scroll down
		uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 272', anchor: '0 0', justify: '0 0', size: '32 40',
			flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_down", image2: "gfx/journal/arrow_down_active", partner: page, skin: 1, colormap: 2);
			scroll.active_condition = scroll_conditional;
			scroll.prerender = scroll_prerender;
			scroll.m_click = scroll_click;
	}
	//

	////////////////////
	////Bestiary Section
	////////////////////
	uipicture_c tab = spawn(uipicture_c, owner: journal_ui,
		origin: '264 328', anchor: '0 0', justify: '0 0',
		size: '88 64', image: journal_assets[JOURNAL_IMG::TABC_ACTIVE], skin: 3, flags: UIFLAG::CLICKABLE);
		tab.prerender = tab_prerender;
		tab.m_click = tab_click;

	uielement_c page = spawn(uismoothlist_c, owner: journal_ui, origin: '82 80', size: '128 192', separation: '0 32', skin: 3, flags: UIFLAG::CLIP);
		page.active_condition = page_condtional;
	uielement_c page2 = spawn(uielement_c, owner: journal_ui, origin: '256 24', size: '216 304', skin: 3);
		page2.active_condition = page_condtional;
	{
		void(uipicture_c this, __inout string img_to_render) monst_prerender = { if (jbeast_selected == this.skin || ui_hover == this) img_to_render = this.image2; };
		void(uilocpicture_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) monst_prerendertxt = { if (jbeast_selected == this.skin || ui_hover == this) color_to_render = '0.8 0.8 0.8'; };
		float(uielement_c this) monst_isselected = { if (jbeast_selected == this.partner.skin) return TRUE; return FALSE; };
		void(uielement_c this) monst_click = { Journal_Sound(); jbeast_selected = this.skin; };
		float(uielement_c this) monst_hasitem = { if (jitems_bestiary & this.skin) return TRUE; return FALSE; };

		// define buttons
		journalitem_t monster_list[] = {
			{JB_A, JOURNAL_LABEL_IMG::FALLEN, "gfx/journal/pages/page_fallen.tga"},
			{JB_B, JOURNAL_LABEL_IMG::WRAITH, "gfx/journal/pages/page_wraith.tga"},
			{JB_C, JOURNAL_LABEL_IMG::AFFLICTED, "gfx/journal/pages/page_afflicted.tga"},
			{JB_D, JOURNAL_LABEL_IMG::WIDOW, "gfx/journal/pages/page_widow.tga"},
			{JB_E, JOURNAL_LABEL_IMG::INVADER, "gfx/journal/pages/page_invader.tga"},
			{JB_F, JOURNAL_LABEL_IMG::HERETIC, "gfx/journal/pages/page_heretic.tga"},
			{JB_G, JOURNAL_LABEL_IMG::EXECUTIONER, "gfx/journal/pages/page_executioner.tga"},
			{JB_H, JOURNAL_LABEL_IMG::STRICKEN, "gfx/journal/pages/page_stricken.tga"},
			{JB_I, JOURNAL_LABEL_IMG::WRETCH, "gfx/journal/pages/page_wretch.tga"},
			{JB_J, JOURNAL_LABEL_IMG::OPPRESSOR, "gfx/journal/pages/page_oppressor.tga"},
			{JB_K, JOURNAL_LABEL_IMG::LURKER, "gfx/journal/pages/page_lurker.tga"},
			{JB_M, JOURNAL_LABEL_IMG::BRUTE, "gfx/journal/pages/page_brute.tga"},
			{JB_L, JOURNAL_LABEL_IMG::SYMBOL, "gfx/journal/pages/page_symbol.tga"},
			{JB_N, JOURNAL_LABEL_IMG::PROWLER, "gfx/journal/pages/page_prowler.tga"},
			{JB_O, JOURNAL_LABEL_IMG::KEEPER, "gfx/journal/pages/page_keeper.tga"},
		};
		//

		// spawn buttons
		for(float i = 0; i < monster_list.length; i++)
		{
			journalitem_t monst = monster_list[i];
			uilocpicture_c monst_label = spawn(uilocpicture_c, owner: page,
				origin: '0 0', anchor: '0.5 0', justify: '0.5 0', size: '128 16', flags: UIFLAG::SELECTABLE | UIFLAG::KEEPSELECT,
				image: journal_label_assets[monst.label_index], image2: journal_label_assets[monst.label_index + 1], fallback_txt: journal_label_assets_string[monst.label_index],
				fallback_sz: '10 10', fallback_color: '-1 -1 -1',
				skin: monst.itflag);
				monst_label.active_condition = monst_hasitem;
				monst_label.prerender = monst_prerender;
				monst_label.prerender_text = monst_prerendertxt;
				monst_label.m_click = monst_click;
			
			uipicture_c monst_page = spawn(uipicture_c, owner: page2, size: '216 304',
				image: monst.pageimage, skin: monst.itflag, partner: monst_label);
				monst_page.active_condition = monst_isselected;
		}
		
		// scroll up
		uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 32', anchor: '0 0', justify: '0 0', size: '32 40',
			flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_up", image2: "gfx/journal/arrow_up_active", partner: page, skin: -1, colormap: 3);
			scroll.active_condition = scroll_conditional;
			scroll.prerender = scroll_prerender;
			scroll.m_click = scroll_click;
		// scroll down
		uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 272', anchor: '0 0', justify: '0 0', size: '32 40',
			flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_down", image2: "gfx/journal/arrow_down_active", partner: page, skin: 1, colormap: 3);
			scroll.active_condition = scroll_conditional;
			scroll.prerender = scroll_prerender;
			scroll.m_click = scroll_click;
	}
	//

	////////////////////
	////   Notes Section
	////////////////////
	uipicture_c tab = spawn(uipicture_c, owner: journal_ui,
		origin: '368 328', anchor: '0 0', justify: '0 0',
		size: '96 64', image: journal_assets[JOURNAL_IMG::TABD_ACTIVE], skin: 4, flags: UIFLAG::CLICKABLE);
		tab.prerender = tab_prerender;
		tab.m_click = tab_click;
	}

	uielement_c page = spawn(uismoothlist_c, owner: journal_ui, origin: '82 80', size: '128 192', separation: '0 32', skin: 4, flags: UIFLAG::CLIP);
		page.active_condition = page_condtional;
	uielement_c page2 = spawn(uielement_c, owner: journal_ui, origin: '256 24', size: '216 304', skin: 4);
		page2.active_condition = page_condtional;
	{
		void(uitext_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) note_prerender = {
			if (jnote_selected == this.skin)
				color_to_render = JOURNAL_COLOR_SELECTED;
			else if (ui_hover == this)
				color_to_render = JOURNAL_COLOR_HIGHLIGHT;
		}
		float(uielement_c this) note_isselected = { if (jnote_selected == this.partner.skin) return TRUE; return FALSE; };
		void(uielement_c this) note_click = { Journal_Sound(); jnote_selected = this.skin; };
		float(uielement_c this) note_hasnote = {
			float num_bitmask = this.skin - 1;
			float field = jitems_notes;
			if (this.skin > 24)
			{
				field = jitemsb_notes;
				num_bitmask = this.skin - 25;
			}
			if (field & (1 << num_bitmask))
				return TRUE;
			return FALSE;
		};

		// spawn buttons
		for(float j = 48; j > 0; j--)
		{
			journalentry_c jentry = Journal_FindEntry(j);
			if (!jentry)
				continue;
			
			uitext_c note_label = spawn(uitext_c, owner: page,
				origin: '0 0', anchor: '0.5 0', justify: '0.5 0', size: '12 12', flags: UIFLAG::SELECTABLE | UIFLAG::KEEPSELECT, skin: j,
				text: jentry.title, color: '-1 -1 -1');
				note_label.active_condition = note_hasnote;
				note_label.prerender = note_prerender;
				note_label.m_click = note_click;
			
			float sz = stringwidth(note_label.text, TRUE, note_label.size) * 0.5;
			if (sz > note_label.owner.size[0])
			{
				note_label.size[0] *= (note_label.owner.size[0] / sz);
			}
			
			uijournalpage_c note_page = spawn(uijournalpage_c, owner: page2, size: '216 304', entry: jentry, partner: note_label, flags: UIFLAG::CLIP, entry_offset: '12 10');
			note_page.active_condition = note_isselected;
		}
		
		// scroll up
		uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 32', anchor: '0 0', justify: '0 0', size: '32 40',
			flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_up", image2: "gfx/journal/arrow_up_active", partner: page, skin: -1, colormap: 4);
			scroll.active_condition = scroll_conditional;
			scroll.prerender = scroll_prerender;
			scroll.m_click = scroll_click;
		// scroll down
		uipicture_c scroll = spawn(uipicture_c, owner: journal_ui, origin: '128 272', anchor: '0 0', justify: '0 0', size: '32 40',
			flags: UIFLAG::CLIP | UIFLAG::CLICKABLE, image: "gfx/journal/arrow_down", image2: "gfx/journal/arrow_down_active", partner: page, skin: 1, colormap: 4);
			scroll.active_condition = scroll_conditional;
			scroll.prerender = scroll_prerender;
			scroll.m_click = scroll_click;
	}
	//
}

// Reki: New Journal Notes stuff, mostly modular
journalentry_c journal_entries; // I think the .h file actually declares this in quakec, because header files are kinda hacky here
journalentry_c journal_currentnote;

journalentry_c Journal_FindEntry(float number)
{
	for(journalentry_c ent = journal_entries; ent; ent = ent._next)
	{
		if (number == ent.index)
			return ent;
	}
	
	return 0;
}

void Journal_RenderNote(journalentry_c note, vector drawoffset, vector drawscale)
{
	float old_drawfont = drawfont;
	for(journalelement_c el = note._elements; el; el = el._next) // loop through and render elements
	{
		vector org = drawoffset + [el.pos[0] * ui_scale[0], el.pos[1] * ui_scale[1]];
		switch (el.type)
		{
			// RENDER JOURNAL TEXT
			case JOURNAL_ETYPE::TEXT:
				journaltext_c txt = (journaltext_c)el;
				vector sz = [txt.fontsize[0] * drawscale[0], txt.fontsize[1] * drawscale[1]];;
				drawfont = txt.font;
				
				vector fixed_color = CONVERT_TO_DP_SHITTY_COLOR(txt.fontcolor); // dp... WTF is this??
				drawstring(org, txt.text, sz, fixed_color, JOURNAL_TEXTALPHA, DRAWFLAG_NORMAL);
				break;
			
			// RENDER JOURNAL PICTURES
			case JOURNAL_ETYPE::PIC:
				journalpic_c pic = (journalpic_c)el;
				vector sz = [pic.pos[0] * drawscale[0], pic.pos[1] * drawscale[1]];
				
				drawpic(org, pic.image, sz, '1 1 1', JOURNAL_TEXTALPHA, DRAWFLAG_NORMAL);
				break;
		}
	}
	drawfont = old_drawfont;
}

void journaltext_c :: journaltext_c() // constructor for text element
{
	this.type = JOURNAL_ETYPE::TEXT;
	
	// link into entry list
	if (this.owner)
	{
		if (this.owner._elements) // go to end of list
		{
			journalelement_c hold, el;
			for(el = this.owner._elements; el; hold = el, el = el._next);
			hold._next = this;
		}
		else
		{
			this.owner._elements = this;
		}
	}
}

void journalpic_c :: journalpic_c() // constructor for pic element
{
	this.type = JOURNAL_ETYPE::PIC;
	
	// link into entry list (at the end so draw order is proper)
	if (this.owner)
	{
		if (this.owner._elements) // go to end of list
		{
			journalelement_c hold, el;
			for(el = this.owner._elements; el; hold = el, el = el._next);
			hold._next = this;
		}
		else
		{
			this.owner._elements = this;
		}
	}
}

void journalentry_c :: journalentry_c() // constructor for entry
{
	// link into entries linked list
	this._next = journal_entries;
	journal_entries = this;
}

void journalentry_c :: destructor() // destructor for entry
{	
	if (this == journal_entries)
	{
		journal_entries = this._next;
		remove(this);
		return;
	}

	for(journalentry_c hld, journalentry_c lst = journal_entries; lst; hld = lst, lst = lst._next)
	{
		if (lst != this)
			continue;

		hld._next = lst._next;
		remove(this);
		return;
	}

	remove(this);
}

// actual parsing
journalentry_c Journal_ParseEntry(string path)
{
	float file = fopen(path, FILE_READ);
	if (file < 0)
	{
		print(sprintf("%s: File not found %s\n", __func__, path));
		return 0;
	}
	
	float old_drawfont = drawfont;
	string strbody;
	string strtemp;
	do {
		strtemp = fgets(file);
		strbody = strcat(strbody, strtemp);
	} while (strtemp);
	
	// define inital state
	float 	txt_font = 7;
	// Ben added pixel indentation, increased txt_size
	vector	txt_pos = '16 0';
	vector	txt_size = '12 12';
	vector	txt_color = '0 0 0';
	float	line_currentheight;
	journalentry_c jentry = spawn(journalentry_c);
	
	// loop through our text and 
	while (strbody)
	{
		// search for tags or line breaks
		float ofs_lb = strstrofs(strbody, "\\n", 0);
		float ofs_tag = strstrofs(strbody, "$", 0);
		
		if (ofs_lb < 0 && ofs_tag < 0) // we have a very simple note, no lines or tags
		{
			journaltext_c txtelement = spawn(journaltext_c, owner: jentry);
			txtelement.font = FONT_USER0 + txt_font;
			txtelement.fontsize = txt_size;
			txtelement.text = strzone(strbody); // zone string
			txtelement.pos = txt_pos;
			txtelement.fontcolor = txt_color;
			
			line_currentheight = max(line_currentheight, txtelement.fontsize[1]);
			strbody = __NULL__;
			break;
		}
		if (ofs_lb >= 0 && (ofs_lb < ofs_tag || ofs_tag < 0)) // next element is a linebreak, so lets section off any remaining text and add it
		{
			journaltext_c txtelement = spawn(journaltext_c, owner: jentry);
			txtelement.font = FONT_USER0 + txt_font;
			txtelement.fontsize = txt_size;
			txtelement.text = strzone(substring(strbody, 0, ofs_lb)); // zone string
			txtelement.pos = txt_pos;
			txtelement.fontcolor = txt_color;
			
			line_currentheight = max(line_currentheight, txtelement.fontsize[1]);
			strbody = substring(strbody, ofs_lb + 2, strlen(strbody) - (ofs_lb + 2)); // chop parsed part off of strbody
			
			// Ben changed indentation
			txt_pos[0] = 12;
			txt_pos[1] += line_currentheight + (2);
			continue;
		}
		
		///// parse any tags /////
		// first we have to add any preceeding text
		journaltext_c txtelement = spawn(journaltext_c, owner: jentry);
		txtelement.font = FONT_USER0 + txt_font;
		txtelement.fontsize = txt_size;
		txtelement.text = strzone(substring(strbody, 0, ofs_tag)); // zone string
		txtelement.pos = txt_pos;
		txtelement.fontcolor = txt_color;
		
		drawfont = txtelement.font;
		txt_pos[0] += stringwidth(txtelement.text, TRUE, txtelement.fontsize); // add to our line position
		
		line_currentheight = max(line_currentheight, txtelement.fontsize[1]);
		strbody = substring(strbody, ofs_tag + 1, strlen(strbody) - (ofs_tag + 1)); // chop parsed part off of strbody
		ofs_lb = strstrofs(strbody, "\\n", 0); // update line break pos
		
		// now get our tag
		float ofs_openbracket = strstrofs(strbody, "{", 0);
		float ofs_closebracket = strstrofs(strbody, "}", 0);
		if ((ofs_lb >= 0) && (ofs_openbracket > ofs_lb || ofs_closebracket > ofs_lb)) // uhh wtf?
		{
			print(sprintf("^1%s: SYNTAX ERROR IN TEXT FILE \"%s\" AT TAG %s\nERROR: %g %g %g\n", __func__, path, strbody, ofs_lb, ofs_openbracket, ofs_closebracket));
			break;
		}
		
		string tag = substring(strbody, 0, ofs_openbracket);
		string value = substring(strbody, ofs_openbracket + 1, (ofs_closebracket - ofs_openbracket) - 1);
		strbody = substring(strbody, strlen(tag) + strlen(value) + 2, strlen(strbody) - (ofs_closebracket + 1)); 
		
		dprint(sprintf("%s: TAG=%s, VALUE=%s\n", __func__, tag, value));
		if (tag == "TITLE")
		{
			if (jentry.title) strunzone(jentry.title);
			jentry.title = strzone(value);
		}
		if (tag == "MSGIMG")
		{
			if (jentry.titleimg) strunzone(jentry.msgimg);
			jentry.msgimg = strzone(value);
		}
		else if (tag == "NOTEINDEX") // index (bit flag that corresponds to this note)
		{
			jentry.index = stof(value);
			if (!jentry.title)
				jentry.title = strzone(sprintf("Note %g", jentry.index));
		}
		else if (tag == "FONT")
		{
			txt_font = stof(value);
		}
		else if (tag == "SIZE")
		{
			float argc = tokenizebyseparator(value, ",");
			if (argc > 1) // we have x and y value
			{
				txt_size[0] = stof(argv(0));
				txt_size[1] = stof(argv(1));
			}
			else if (argc > 0) // we just have 1 value, so use it for both
			{
				txt_size[0] = txt_size[1] = stof(argv(0));
			}
		}
		else if (tag == "COLOR" || tag == "COLOUR")
		{
			float argc = tokenizebyseparator(value, ",");
			if (argc == 1)
			{
				txt_color[0] = txt_color[1] = txt_color[2] = stof(argv(0)); // greyscale
			}
			else if (argc == 3)
			{
				txt_color[0] = stof(argv(0));
				txt_color[1] = stof(argv(1));
				txt_color[2] = stof(argv(2));
			}
		}
		else if (tag == "PIC") // inline picture
		{
			float argc = tokenizebyseparator(value, ",");
			journalpic_c pic = spawn(journalpic_c, owner: jentry);
			pic.pos = txt_pos;
			
			pic.image = strzone(argv(0));
			pic.size[0] = stof(argv(1));
			pic.size[1] = stof(argv(2));
			precache_pic(pic.image);
			
			txt_pos[0] += pic.size[0];
			line_currentheight = max(line_currentheight, pic.size[1]);
		}
		else if (tag == "ABSPIC") // absolute value picture
		{
			float argc = tokenizebyseparator(value, ",");
			journalpic_c pic = spawn(journalpic_c, owner: jentry);
			pic.pos = txt_pos;
			
			pic.image = strzone(argv(0));
			pic.pos[0] = stof(argv(1));
			pic.pos[1] = stof(argv(2));
			pic.size[0] = stof(argv(3));
			pic.size[1] = stof(argv(4));
			precache_pic(pic.image);
		}
		
		if (!strbody || strbody == "")
			strbody = __NULL__; // weird hack, thanks DP
	}
	
	// Print debug info to console for `developer 1`
	//dprint("\n=== JOURNAL NOTE ENTRY ===\n\n");
	for(journalelement_c el = jentry._elements; el; el = el._next)
	{
		switch (el.type)
		{
			case JOURNAL_ETYPE::TEXT:
				journaltext_c txt = (journaltext_c)el;
				//dprint(sprintf("TXT (%g %g %g): %s\n", txt.font, txt.fontsize[0], txt.fontsize[1], txt.text));
				break;
			case JOURNAL_ETYPE::PIC:
				journalpic_c pic = (journalpic_c)el;
				//dprint(sprintf("PIC (%g %g): %s\n", pic.size[0], pic.size[1], pic.image));
				break;
		}
	}
	//dprint("\n======= END ENTRY ========\n\n");
	//
	
	fclose(file);
	drawfont = old_drawfont;
	
	for(journalentry_c lst = journal_entries; lst; lst = lst._next)
	{
		if (jentry == lst)
			continue;

		if (lst.index == jentry.index) // if we found a duplicate, remove it!
		{
			lst.destructor();
			break;
		}
	}
	
	return jentry;
}





