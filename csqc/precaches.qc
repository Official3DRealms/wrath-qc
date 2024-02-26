#include "localized_assets.h"


void(float ind, string asset) init_deathmenuasset
{
	string path = sprintf("gfx/deathmenu/%%s/deathmenu_%s.tga", strtolower(asset));
	string filepath = "";
	
	if (fexists_pak(sprintf(path, cvar_string("prvm_language"))))
		filepath = sprintf(path, cvar_string("prvm_language"));
	else if (fexists_pak(sprintf(path, cvar_string("prvm_language_fallback"))))
	{
		if !(IS_DEATHMENUASSET_STR_LOC(deathmenu_assets_string, ind, asset)) // if the string was not localized properly, then we have to use the fallback img (which will be in the wrong language) :c
			filepath = sprintf(path, cvar_string("prvm_language_fallback"));
	}
	
	if (filepath == "")
	{
		deathmenu_assets[ind] = __NULL__;
		return;
	}

	precache_pic(filepath);
	deathmenu_assets[ind] = strzone(filepath);
}

void(float ind, string asset) init_journalasset
{
	string path_fallback = sprintf("gfx/journal/%s.tga", strtolower(asset));
	string path = sprintf("gfx/journal/%%s/%s.tga", strtolower(asset));
	string filepath = "";
	
	if (fexists_pak(sprintf(path, cvar_string("prvm_language"))))
		filepath = sprintf(path, cvar_string("prvm_language"));
	else // default back to english assets
		filepath = path_fallback;
	
	if (filepath == "")
	{
		journal_assets[ind] = __NULL__;
		return;
	}

	precache_pic(filepath);
	journal_assets[ind] = strzone(filepath);
}

void(float ind, string asset) init_journal_pageasset
{
	string path_fallback = sprintf("gfx/journal/pages/page_%s.tga", strtolower(asset));
	string path = sprintf("gfx/journal/pages/%%s/page_%s.tga", strtolower(asset));
	string filepath = "";
	
	if (fexists_pak(sprintf(path, cvar_string("prvm_language"))))
	{
		filepath = sprintf(path, cvar_string("prvm_language"));
		journal_page_blank[ind] = FALSE;
	}
	else
	{
		filepath = path_fallback;
		journal_page_blank[ind] = TRUE;
	}
	
	if (filepath == "")
	{
		journal_page_assets[ind] = __NULL__;
		journal_page_blank[ind] = TRUE;
		return;
	}

	precache_pic(filepath);
	journal_page_assets[ind] = strzone(filepath);
}

void(float ind, string asset) init_journal_labelasset
{
	string path_fallback = sprintf("gfx/journal/labels/label_%s.tga", strtolower(asset));
	string path = sprintf("gfx/journal/labels/%%s/label_%s.tga", strtolower(asset));
	string filepath = "";
	
	if (fexists_pak(sprintf(path, cvar_string("prvm_language"))))
		filepath = sprintf(path, cvar_string("prvm_language"));
	else if !(IS_JOURNAL_LABEL_ASSET_STR_LOC(journal_label_assets_string, ind, asset))
		filepath = path_fallback;
	
	if (filepath == "")
	{
		journal_label_assets[ind] = __NULL__;
		return;
	}

	precache_pic(filepath);
	journal_label_assets[ind] = strzone(filepath);
}

void() localization_precaches =
{	
	#define X(s) init_deathmenuasset(DEATHMENU_IMG::s, #s);
	LIST_DEATHMENU_ASSETS
	#undef X
	#define X(s) init_journalasset(JOURNAL_IMG::s, #s);
	LIST_JOURNAL_ASSETS
	#undef X
	#define X(s) init_journal_pageasset(JOURNAL_PAGE_IMG::s, #s);
	LIST_JOURNAL_PAGE_ASSETS
	#undef X
	#define X(s) init_journal_pageasset(JOURNAL_PAGE_IMG::s + JOURNAL_PAGE_IMG::RELIC_START, #s "_RELIC");
	LIST_JOURNAL_PAGE_ASSETS
	#undef X
	#define X(s) init_journal_labelasset(JOURNAL_LABEL_IMG::s, #s); init_journal_labelasset(JOURNAL_LABEL_IMG::s##_ACTIVE, #s "_ACTIVE");
	LIST_JOURNAL_LABEL_ASSETS
	#undef X
}

void() csqc_precaches =
{
	precache_model("progs/flame.mdl");
	precache_pic("gfx/artifactmenu/artifactA_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactA_icon.tga");
	precache_pic("gfx/artifactmenu/artifactA_info.tga");
	precache_pic("gfx/artifactmenu/artifactB_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactB_icon.tga");
	precache_pic("gfx/artifactmenu/artifactB_info.tga");
	precache_pic("gfx/artifactmenu/artifactC_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactC_icon.tga");
	precache_pic("gfx/artifactmenu/artifactC_info.tga");
	precache_pic("gfx/artifactmenu/artifactD_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactD_icon.tga");
	precache_pic("gfx/artifactmenu/artifactD_info.tga");
	precache_pic("gfx/artifactmenu/artifactE_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactE_icon.tga");
	precache_pic("gfx/artifactmenu/artifactE_info.tga");
	precache_pic("gfx/artifactmenu/artifactF_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactF_icon.tga");
	precache_pic("gfx/artifactmenu/artifactF_info.tga");
	precache_pic("gfx/artifactmenu/artifactG_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactG_icon.tga");
	precache_pic("gfx/artifactmenu/artifactG_info.tga");
	precache_pic("gfx/artifactmenu/artifactH_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactH_icon.tga");
	precache_pic("gfx/artifactmenu/artifactH_info.tga");
	precache_pic("gfx/artifactmenu/artifactI_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactI_icon.tga");
	precache_pic("gfx/artifactmenu/artifactI_info.tga");
	precache_pic("gfx/artifactmenu/artifactJ_icon_large.tga");
	precache_pic("gfx/artifactmenu/artifactJ_icon.tga");
	precache_pic("gfx/artifactmenu/artifactJ_info.tga");
	precache_pic("gfx/artifactmenu/artifact_marker.tga");
	precache_pic("gfx/artifactmenu/artifact_menu.tga");
	precache_pic("gfx/artifactmenu/artifact_num0.tga");
	precache_pic("gfx/artifactmenu/artifact_num1.tga");
	precache_pic("gfx/artifactmenu/artifact_num2.tga");
	precache_pic("gfx/artifactmenu/artifact_num3.tga");
	precache_pic("gfx/artifactmenu/artifact_num4.tga");
	precache_pic("gfx/artifactmenu/artifact_num5.tga");
	precache_pic("gfx/artifactmenu/artifact_num6.tga");
	precache_pic("gfx/artifactmenu/artifact_num7.tga");
	precache_pic("gfx/artifactmenu/artifact_num8.tga");
	precache_pic("gfx/artifactmenu/artifact_num9.tga");
	//precache_pic("gfx/deathmenu/deathmenuA.tga");
	//precache_pic("gfx/deathmenu/deathmenuB.tga");
	//precache_pic("gfx/deathmenu/deathmenuC.tga");
	//precache_pic("gfx/deathmenu/deathmenuD.tga");

	precache_pic("gfx/hud/coffer_key.tga");
	precache_pic("gfx/hud/crosshair1_active.tga");
	precache_pic("gfx/hud/crosshair1.tga");
	precache_pic("gfx/hud/crosshair1_use.tga");
	precache_pic("gfx/hud/relic_e1m1.tga");
	precache_pic("gfx/hud/relic_e1m2.tga");
	precache_pic("gfx/hud/relic_e1m3.tga");
	precache_pic("gfx/hud/relic_e1m4.tga");
	precache_pic("gfx/hud/relic_e1m5.tga");

	precache_pic("gfx/hud/armor_sheet.tga");
	precache_pic("gfx/hud/darmor_sheet.tga");
	precache_pic("gfx/hud/cyst_sheet.tga");
	precache_pic("gfx/hud/shellls_sheet.tga");
	precache_pic("gfx/hud/slugs_sheet.tga");
	precache_pic("gfx/hud/ore_sheet.tga");
	precache_pic("gfx/hud/lances_sheet.tga");
	precache_pic("gfx/hud/fangs_sheet.tga");

	precache_pic("gfx/hud/cooldown/artifactA_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactA_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactA_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactB_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactB_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactB_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactC_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactC_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactC_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactD_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactD_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactD_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactE_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactE_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactE_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactF_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactF_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactF_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactG_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactG_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactG_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactH_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactH_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactH_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactI_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactI_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactI_pulseB.tga");
	precache_pic("gfx/hud/cooldown/artifactJ_hud.tga");
	precache_pic("gfx/hud/cooldown/artifactJ_pulseA.tga");
	precache_pic("gfx/hud/cooldown/artifactJ_pulseB.tga");
	precache_pic("gfx/hud/cooldown/cd_sheet.tga");
	precache_pic("gfx/hud/cooldown/cd_pulse.tga");
	precache_pic("gfx/hud/cooldown/sigil_flight_hud.tga");
	precache_pic("gfx/hud/cooldown/sigil_flight_pulseA.tga");
	precache_pic("gfx/hud/cooldown/sigil_flight_pulseB.tga");
	precache_pic("gfx/hud/cooldown/soul_tether_hud.tga");
	precache_pic("gfx/hud/cooldown/soul_tether_pulseA.tga");
	precache_pic("gfx/hud/cooldown/soul_tether_pulseB.tga");



	precache_pic("gfx/journal/arrow_down_active.tga");
	precache_pic("gfx/journal/arrow_down.tga");
	precache_pic("gfx/journal/arrow_up_active.tga");
	precache_pic("gfx/journal/arrow_up.tga");
	precache_pic("gfx/journal/journal.tga");
	precache_pic("gfx/journal/stats_hub.tga");
	precache_pic("gfx/journal/stats_level.tga");
	precache_pic("gfx/journal/taba_active.tga");
	precache_pic("gfx/journal/tabb_active.tga");
	precache_pic("gfx/journal/tabc_active.tga");
	precache_pic("gfx/journal/tabd_active.tga");



	string language_selected = 	cvar_string("prvm_language");

	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_armor.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactA.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactB.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactC.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactD.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactE.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactF.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactG.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactH.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactI.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_artifactJ.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_revolver.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_coffer_key.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_cysts.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_dark_armor.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_dark_helm.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_dark_shard.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_fangs.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_full.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_key_blue.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_key_red.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_key_yellow.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_helm.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_journal_update.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_lances.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_lifeblood_beaker.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_lifeblood_vial.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_load.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_locked_blue.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_locked_coffer.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_locked_red.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_locked_yellow.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_ore.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_primary_attack.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_primary_fire.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m1.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m2.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m3.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m4.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m5.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_retcher.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_saved.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_secret.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_shard.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_shells.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_shotgun.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_shrine.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_sigil_flight.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_slagcannon.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_slugs.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_soul_tether.tga"));
	precache_pic(strcat("gfx/hud/messages/",language_selected,"/msg_spitter.tga"));

	// Reki (October 6 2023): Moved count over to a sprite sheet instead of individual images
	precache_pic("gfx/hud/messages/icons/count_sheet.tga");

	precache_pic("textures/skies/e1m5/e1m5_sky_bk.tga");
	precache_pic("textures/skies/e1m5/e1m5_sky_dn.tga");
	precache_pic("textures/skies/e1m5/e1m5_sky_ft.tga");
	precache_pic("textures/skies/e1m5/e1m5_sky_lf.tga");
	precache_pic("textures/skies/e1m5/e1m5_sky_rt.tga");
	precache_pic("textures/skies/e1m5/e1m5_sky_up.tga");
	precache_pic("textures/skies/e1m5/e1m5_sky_bk.tga");
};
