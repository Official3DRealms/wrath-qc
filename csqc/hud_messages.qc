#include "uielement.h"

float hud_messages;
float oldhud_messages;
.vector imagepos;
.float msgalpha;
.float removing;
.float iflag;
.vector icolor;
float msgtime;
float removingmessages;
void() SUB_Remove = {remove(self);};
float savingtether;
void() check_tether2 = { read_currentprofileslot();

	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tetherclient.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	savingtether = stof(readtext);
	fclose(readparms);

	if (profilename)
		strunzone(profilename);

};

void() check_shrine = { read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/shrine.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	savingtether = stof(readtext);
	fclose(readparms);
	if (profilename)
		strunzone(profilename);

};

#define HUD_NOTIFY_LINES	10
#define HUD_NOTIFY_OVERFLOW	7
#define HUD_NOTIFY_TIME		4
#define HUD_NOTIFY_FADETIME	0.3
#define HUD_NOTIFY_FADEIN	0.1
uielement_c ui_notify_lines[HUD_NOTIFY_LINES];
void HUD_ShuffleNotificationsUp(void);
void HUD_InitializeNotifications(void)
{
	void(uielement_c this, __inout vector position) notify_preloop = {
		uielement_c line = ui_notify_lines[0];

		if (line.skin && time >= line.skin)
			HUD_ShuffleNotificationsUp();
		
		// do positioning and alpha fadeout
		uielement_c line;
		uipicture_c icon;
		uitext_c msg;
		uipicture_c msgimg;
		uitext_c cnt;
		uispritesheet_c cntimg;
		float i;
		for(i = 0; i < HUD_NOTIFY_LINES; i++)
		{
			line = ui_notify_lines[i];
			icon = (uipicture_c)line.partner;
			msg = (uitext_c)line.partner2;
			msgimg = (uipicture_c)line.partner3;
			cnt = (uitext_c)line.partner4;
			cntimg = (uispritesheet_c)line.partner5;
			
			if (!line.skin)
				break;

			float tfrom = time - line.colormap;
			float tleft = line.skin - time;
			if (tleft <= 0)
			{
				line.flags |= UIFLAG::HIDE;
				continue;
			}
			
			line.flags &= ~UIFLAG::HIDE;
			icon.alpha = 1;
			msg.alpha = 1;
			msgimg.alpha = 1;
			cnt.alpha = 1;
			cntimg.alpha = 1;
			if (tleft < HUD_NOTIFY_FADETIME)
			{
				float frac = tleft/HUD_NOTIFY_FADETIME;

				float alph = slerp(0, 1, frac);
				icon.alpha = alph;
				msg.alpha = alph;
				msgimg.alpha = alph;
				cnt.alpha = alph;
				cntimg.alpha = alph;

				vector moveup = ((uilist_c)this).separation * (1 - frac);
				moveup = [moveup[0] * ui_scale[0], moveup[1] * ui_scale[1]];
				position -= moveup;
			}
			else if (tfrom < HUD_NOTIFY_FADEIN)
			{
				float frac = (tfrom / HUD_NOTIFY_FADEIN);
				float alph = slerp(0, 1, frac);
				icon.alpha = alph;
				msg.alpha = alph;
				msgimg.alpha = alph;
				cnt.alpha = alph;
				cntimg.alpha = alph;
			}
		}

		if (i > HUD_NOTIFY_OVERFLOW) // if we're over the overflow, hurry it up slowpoke
			ui_notify_lines[0].skin = min(ui_notify_lines[0].skin, time + HUD_NOTIFY_FADETIME);
		//
	}
	float(uielement_c this) notify_active = {
		uipicture_c icon = (uipicture_c)this.partner;
		uitext_c msg = (uitext_c)this.partner2;
		uipicture_c msgimg = (uipicture_c)this.partner3;
		
		if (!this.skin)
			return FALSE;
		
		if (!icon.image && !msg.text && !msgimg.image)
			return FALSE;

		return TRUE;
	} 

	uilist_c notifybox = spawn(uilist_c, owner: ui_hud, origin: '8 8', separation: '0 40');
	notifybox.preloop = notify_preloop;
	for(float i = 0; i < HUD_NOTIFY_LINES; i++)
	{
		uielement_c line = ui_notify_lines[i] = spawn(uielement_c, owner: notifybox, size: '256 32');
		line.active_condition = notify_active;

		uipicture_c icon = spawn(uipicture_c, owner: line, anchor: '0 0.5', size: '32 32', justify: '0 0.5', image: __NULL__);
		uitext_c text = spawn(uitext_c, owner: line, origin: '38 0', anchor: '0 0.5', justify: '0 0.5', size: '24 24', color: '0.42 0.41 0.45', font: FONT_USER7);
		uipicture_c textimg = spawn(uipicture_c, owner: line, origin: '38 0', anchor: '0 0.5', justify: '0 0.5', size: '32 32', color: '1 1 1', image: __NULL__);
		text.text = __NULL__;
		
		uitext_c cnt = spawn(uitext_c, owner: line, origin: '38 0', anchor: '0 0.85', justify: '0 1', size: '24 24', color: '0.42 0.41 0.45', font: FONT_USER7);
		uispritesheet_c cntimg = spawn(uispritesheet_c, owner: line, origin: '38 0', anchor: '0 0', justify: '0 0', size: '32 32', color: '1 1 1', image: __NULL__);
		cnt.text = __NULL__;

		line.partner = icon;
		line.partner2 = text;
		line.partner3 = textimg;
		line.partner4 = cnt;
		line.partner5 = cntimg;
	}
};

void HUD_ShuffleNotificationsUp(void)
{
	uielement_c line;
	uipicture_c icon;
	uitext_c msg;
	uipicture_c msgimg;
	uitext_c cnt;
	uispritesheet_c cntimg;

	// get string offs we're bumping
	line = ui_notify_lines[0];
	icon = (uipicture_c)line.partner;
	msg = (uitext_c)line.partner2;
	msgimg = (uipicture_c)line.partner3;
	cnt = (uitext_c)line.partner4;
	cntimg = (uispritesheet_c)line.partner5;
	string stroffs_icon = icon.image;
	string stroffs_text = msg.text;
	string stroffs_textimg = msgimg.image;
	string stroffs_cnttext = cnt.text;
	string stroffs_cntimg = cntimg.image;
	//

	for(float i = 0; i < HUD_NOTIFY_LINES - 1; i++)
	{
		// the line we're moving to
		line = ui_notify_lines[i];
		icon = (uipicture_c)line.partner;
		msg = (uitext_c)line.partner2;
		msgimg = (uipicture_c)line.partner3;
		cnt = (uitext_c)line.partner4;
		cntimg = (uispritesheet_c)line.partner5;
		// the line we're copying from
		uielement_c line2 = ui_notify_lines[i + 1];
		uipicture_c icon2 = (uipicture_c)line2.partner;
		uitext_c msg2 = (uitext_c)line2.partner2;
		uipicture_c msgimg2 = (uipicture_c)line2.partner3;
		uitext_c cnt2 = (uitext_c)line2.partner4;
		uispritesheet_c cntimg2 = (uispritesheet_c)line2.partner5;

		// copy data we want
		line.skin = line2.skin;
		line.colormap = line2.colormap;
		line.frame = line2.frame;
		icon.image = icon2.image;
		icon.size = icon2.size;
		msg.text = msg2.text;
		msg.origin = msg2.origin;
		msgimg.image = msgimg2.image;
		msgimg.origin = msgimg2.origin;
		msgimg.size = msgimg2.size;
		cnt.text = cnt2.text;
		cnt.origin = cnt2.origin;
		cntimg.image = cntimg2.image;
		cntimg.origin = cntimg2.origin;
		cntimg.sheet_size = cntimg2.sheet_size;
		cntimg.sprite = cntimg2.sprite;

		icon.flags = icon2.flags;
		msg.flags = msg2.flags;
		msgimg.flags = msgimg2.flags;
		cnt.flags = cnt2.flags;
		cntimg.flags = cntimg2.flags;
	}
	
	line = ui_notify_lines[HUD_NOTIFY_LINES - 1];
	line.skin = 0;
	line.frame = 0;

	if (stroffs_icon)
		strunzone(stroffs_icon);
	if (stroffs_text)
		strunzone(stroffs_text);
	if (stroffs_textimg)
		strunzone(stroffs_textimg);
	if (stroffs_cnttext)
		strunzone(stroffs_cnttext);
	if (stroffs_cntimg)
		strunzone(stroffs_cntimg);
}

uielement_c HUD_AllocateLine(void)
{
	float time_prev = 0;
	for(float i = 0; i < HUD_NOTIFY_LINES; i++)
	{
		uielement_c line = ui_notify_lines[i];
		if (line.skin)
		{
			time_prev = line.skin;
			continue;
		}
		
		line.skin = bound(time + HUD_NOTIFY_TIME, time_prev + 0.34, time + (HUD_NOTIFY_TIME * 2));
		line.colormap = time;
		line.frame = 1;
		return line;
	}

	//HUD_ShuffleNotificationsUp();
	// go into overflow line
	HUD_ShuffleNotificationsUp();

	uielement_c line = ui_notify_lines[HUD_NOTIFY_LINES - 1];
	line.skin = bound(time + HUD_NOTIFY_TIME, time_prev + 0.34, time + (HUD_NOTIFY_TIME * 2));
	line.colormap = time;
	line.frame = 1;
	return line;
}

void() Remove_Message = { self.removing = 1;

};

void() Remove_Message2 = { self.removing = 1;
};

.float deleted;
void() MessageThink2 = { if (self.removing == 1)
	{
		self.iflag = 0;
		self.msgalpha -= ap;
		self.imagepos_y -= yp;
		self.icolor_x -= 0.005;
		self.icolor_y -= 0.006;
		self.icolor_z -= 0.007;
		if (self.msgalpha < 0.5)
		{
			if (!self.deleted)
			{
				oldhud_messages -= 1;
				if (oldhud_messages <= 0)
					hud_messages = 0;
				self.deleted = 1;
			}

			remove(self);
		}
	}
	else
	{
		if (self.msgalpha < 1)
			self.msgalpha += api;
	}
};

void() Hud_Messages_Draw2 = { local string image;
	if (self.msg == 17)
		image = "gfx/hud/msg_shells.tga";
	string str;
	DImage2(self.imagepos, image, self.msgalpha, 1, self.icolor, '256 32 0', 0);
	str = strcat("X ", ftos(self.item_cnt));
	DString(self.imagepos + '130 8 0', str, self.msgalpha, 1, '1 1 1', '12 12 12');	//void(vector pos, string str, float alph, float escala, vector coloracion, vector siz) 
};

void() MessageThink = { local float alphaincreaser, alphafading, yfading;

	if (clframetime < 0.05)
		alphaincreaser = api + 0.025;
	if (clframetime < 0.033)
		alphaincreaser = api + 0.017;
	if (clframetime < 0.016)
		alphaincreaser = api + 0.015;
	if (clframetime < 0.01)
		alphaincreaser = api + 0.010;
	if (clframetime < 0.005)
		alphaincreaser = api;

	if (clframetime < 0.05)
		alphafading = ap + 0.1;
	if (clframetime < 0.033)
		alphafading = ap + 0.05;
	if (clframetime < 0.016)
		alphafading = ap + 0.025;
	if (clframetime < 0.01)
		alphafading = ap + 0.001;
	if (clframetime < 0.005)
		alphafading = ap;

	if (clframetime < 0.05)
		yfading = yp + 1.5;
	if (clframetime < 0.033)
		yfading = yp + 0.8;
	if (clframetime < 0.016)
		yfading = yp + 0.4;
	if (clframetime < 0.01)
		yfading = yp + 0.2;
	if (clframetime < 0.005)
		yfading = yp;

	if (self.removing == 1)
	{
		self.iflag = 0;
		self.msgalpha -= alphafading;
		self.imagepos_y -= yfading;
		self.icolor_x -= 0.005;
		self.icolor_y -= 0.006;
		self.icolor_z -= 0.007;
		if ((self.msgalpha < 0.75) && (!self.deleted))
		{
			oldhud_messages -= 1;
			if (oldhud_messages <= 0)
				hud_messages = 0;

			self.deleted = 1;
		}

		if (self.msgalpha <= 0)
			remove(self);
	}
	else
	{
		if (self.msgalpha < 1)
			self.msgalpha += alphaincreaser;
		else
			self.msgalpha = 1;
	}
};

void() Hud_Messages_Draw = 
{ 
	string image, imageicon;
	oldhud_messages = hud_messages;

	string language_selected = 	cvar_string("prvm_language");	
	float weapn_icon = 0;
	imageicon = "null";
	if (self.msg == 1)
	{	
		image = strcat("gfx/hud/messages/",language_selected,"/msg_aegis.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_aegis.tga";
	}
	if (self.msg == 2)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_armor.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_armor.tga";
	}
	if (self.msg == 4)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_dark_armor.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_dark_armor.tga";
	}
	if (self.msg == 5)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_dark_helm.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_dark_helm.tga";
	}
	if (self.msg == 6)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_dark_shard.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_dark_shard.tga";
	}
	if (self.msg == 9)
	{	
		image = strcat("gfx/hud/messages/",language_selected,"/msg_helm.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_helm.tga";
	}
	if (self.msg == 10)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_lifeblood_beaker.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_lifeblood_beaker.tga";
	}
	if (self.msg == 11)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_lifeblood_vial.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_lifeblood_vial.tga";
	}
	if (self.msg == 12)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_lifesiphon.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_lifesiphon.tga";
	}
	if (self.msg == 13)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_shard.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_shard.tga";
	}
	if (self.msg == 15)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_soultether.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_soultether.tga";
	}
	if (self.msg == 16)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_trinketofrespite.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_trinketofrespite.tga";
	}
	if (self.msg == 25)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_coffer_key.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_coffer_key.tga";
	}
	if (self.msg == 24)
	{
		check_tether2();
		if (savingtether == 1)
		{
			image = strcat("gfx/hud/messages/",language_selected,"/msg_load.tga");
			imageicon = "gfx/hud/messages/icons/msgicon_progress.tga";
		}
		else
		{
			image = strcat("gfx/hud/messages/",language_selected,"/msg_save_tether.tga");
			imageicon = "gfx/hud/messages/icons/msgicon_soul_tether.tga";
		}
	}
	if (self.msg == 26)
	{
		check_shrine();
		if (savingtether == 1)
		{
			image = strcat("gfx/hud/messages/",language_selected,"/msg_load.tga");
			imageicon = "gfx/hud/messages/icons/msgicon_progress.tga";
		}
		else
		{
			image = strcat("gfx/hud/messages/",language_selected,"/msg_save_shrine.tga");
			imageicon = "gfx/hud/messages/icons/msgicon_shrine.tga";
		}
	}
	if (self.msg == 27)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_secret.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_secret.tga";
	}
	if (self.msg == 28)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_key_blue.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_glyph_blue.tga";
	}
	if (self.msg == 29)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_sigil_flight.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_sigil_flight.tga";
	}
	if (self.msg == 31)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_glyph_red.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_glyph_red.tga";
	}
	if (self.msg == 32)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_glyph_yellow.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_glyph_yellow.tga";
	}
	if (self.msg == 35)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_journal_update.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_journal_update.tga";
	}
	if (self.msg == 36)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_locked_blue.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_locked_blue.tga";
	}
	if (self.msg == 37)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_locked_coffer.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_locked_coffer.tga";
	}
	if (self.msg == 38)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_locked_red.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_locked_red.tga";
	}
	if (self.msg == 39)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_locked_yellow.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_locked_yellow.tga";
	}
	if (self.msg == 40)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_lifeblood_chalice.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_lifeblood_chalice.tga";
	}
	if (self.msg == 50)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m1.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_relic_e1m1.tga";
	}
	if (self.msg == 51)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m2.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_relic_e1m2.tga";
	}
	if (self.msg == 52)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m3.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_relic_e1m3.tga";
	}
	if (self.msg == 53)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m4.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_relic_e1m4.tga";
	}
	if (self.msg == 54)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_relic_e1m5.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_relic_e1m5.tga";
	}
	if (self.msg == 90)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_revolver.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_revolver.tga";
	}
	if (self.msg == 91)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_shotgun.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_shotgun.tga";
	}
	if (self.msg == 92)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_spitter.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_spitter.tga";
	}
	if (self.msg == 93)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_retcher.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_retcher.tga";
	}
	if (self.msg == 94)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_slagcannon.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_slagcannon.tga";
	}
	if (self.msg == 95)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_lance.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_lance.tga";
	}
	if (self.msg == 96)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_boiler.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_boiler.tga";
	}
	if (self.msg == 97)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_mace.tga");
		weapn_icon = 1;
		imageicon = "gfx/hud/messages/icons/msgicon_mace.tga";
	}
	if (self.msg == 100)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_soul_tether.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_soul_tether.tga";
	}
	if (self.msg == 101)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactA.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactA.tga";
	}
	if (self.msg == 102)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactB.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactB.tga";
	}
	if (self.msg == 103)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactC.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactC.tga";
	}
	if (self.msg == 104)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactD.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactD.tga";
	}
	if (self.msg == 105)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactE.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactE.tga";
	}
	if (self.msg == 106)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactF.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactF.tga";
	}
	if (self.msg == 107)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactG.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactG.tga";
	}
	if (self.msg == 108)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactH.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactH.tga";
	}
	if (self.msg == 109)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactI.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactI.tga";
	}
	if (self.msg == 110)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_artifactJ.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_artifactJ.tga";
	}
	if (self.msg == 111)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_full.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_full.tga";
	}
	if (self.msg == 120)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_slugs.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_slugs.tga";
	}
	if (self.msg == 121)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_shells.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_shells.tga";
	}
	if (self.msg == 122)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_fangs.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_fangs.tga";
	}
	if (self.msg == 123)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_cysts.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_cysts.tga";
	}
	if (self.msg == 124)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_ore.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_ore.tga";
	}
	if (self.msg == 125)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_lances.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_lances.tga";
	}
	if (self.msg == 126)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_boilers.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_boilers.tga";
	}
	if (self.msg == 127)
	{
		image = strcat("gfx/hud/messages/",language_selected,"/msg_soul.tga");
		imageicon = "gfx/hud/messages/icons/msgicon_soul.tga";
	}
	float hidehud;
	hidehud = getstatf(STAT_THWOFG);
	local vector msgsize;
	msgsize = '512 32 0';
	if(weapn_icon == 1)
		DImage2(self.imagepos + '54 0 0 ', image, self.msgalpha, 1, self.icolor, msgsize, 0);
	else
		DImage2(self.imagepos + '32 0 0 ', image, self.msgalpha, 1, self.icolor, msgsize, 0);
	if(weapn_icon == 1)
		msgsize = '54 32 0';
	else
		msgsize = '32 32 0';
	if(imageicon != "null")
		DImage2(self.imagepos, imageicon, self.msgalpha, 1, self.icolor, msgsize, 0);



};

void(float newent) Hud_Messages = { self.msg = ReadShort();
	if (newent)
	{
		local vector ar;
		ar_x = hmsgpos_x;
		vid_height = cvar("vid_conheight");
		ar_y = hmsgpos_y + (hud_messages *hms) + (540 - vid_height);
		self.imagepos = ar;
		if (self.msg < 255)
		hud_messages += 1;
		self.msgalpha = 0;
		self.iflag = 0;
		self.icolor = '1 1 1';
		if (self.msg == 255)
		{
			///////////// Key "Journal");
			tokenize(findkeysforcommand("impulse 35", 0));
			if (argv(0) != "-1")
				string fw_key21 = keynumtostring(stof(argv(0)));
			else
				fw_key21 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key21), " to open Journal"));
			return;
		}

		if (self.msg == 256)
		{
			///////////// Key "Inventory");
			tokenize(findkeysforcommand("+button6", 0));
			if (argv(0) != "-1")
				string fw_key7 = keynumtostring(stof(argv(0)));
			else
				fw_key7 = " ";
			centerprint(strcat("Press and hold ", case_fixed(fw_key7), " to open Artifact Inventory"));
			return;
		}

		if (self.msg == 257)
		{
			///////////// Key "Artifact");
			tokenize(findkeysforcommand("impulse 15", 0));
			if (argv(0) != "-1")
				string fw_key22 = keynumtostring(stof(argv(0)));
			else
				fw_key22 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key22), " to Use Artifact"));
			return;
		}

		if ((self.msg == 258) || (self.msg == 259))
		{
			tokenize(findkeysforcommand("+button3", 0));
			if (argv(0) != "-1")
				string fw_key6 = keynumtostring(stof(argv(0)));
			else
				fw_key6 = " ";
		}

		if (self.msg == 258)
		{
			///////////// Key "Artifact");
			tokenize(findkeysforcommand("+attack", 0));
			if (argv(0) != "-1")
				string fw_key5 = keynumtostring(stof(argv(0)));
			else
				fw_key5 = " ";
			centerprint(strcat(case_fixed(fw_key5), " Primary Attack \n\n\n",
				case_fixed(fw_key6), " Secondary Attack"));
			return;
		}
		if (self.msg == 259)
		{
			centerprint(strcat("Hold ", case_fixed(fw_key6), " then release at the top of your jump"));
			return;
		}
		if (self.msg == 260)
		{
			tokenize(findkeysforcommand("impulse 81", 0));
			if (argv(0) != "-1")
				string fw_key28 = keynumtostring(stof(argv(0)));
			else
				fw_key28 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key28), " to Use Soul Tether (save game) "));
			return;
		}
		
		if (self.msg == 261)
		{
			tokenize(findkeysforcommand("impulse 89", 0));
			if (argv(0) != "-1")
				string fw_key29 = keynumtostring(stof(argv(0)));
			else
				fw_key29 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key29), " to Return to Soul Tether (load game)"));
			return;
		}



		else
		{
			self.draw2d = Hud_Messages_Draw;
			self.predraw = MessageThink;
		}


	}
};

void(float newent) Hud_Messages2 = { self.msg = ReadShort();
	self.item_cnt = ReadShort();
	if (newent)
	{
		local vector ar;
		ar_x = hmsgpos_x;
		ar_y = hmsgpos_y + (hud_messages *hms) + (540 - vid_height);
		self.imagepos = ar;
		hud_messages += 1;
		oldhud_messages += 1;
		self.msgalpha = 0;
		self.iflag = 0;
		self.icolor = '1 1 1';
		self.draw2d = Hud_Messages_Draw2;
		self.predraw = MessageThink2;
		//self.nextthink = time + 0.03;
	}
};

.vector rorg;
.float cnt;

void() Health_Messages_Draw = { float menudbg;
	menudbg = getstatf(STAT_WRATHDEBUGSCREEN);
	if (menudbg == 1)
	{
		string thetext = ftos(self.cnt);
		vector charsize = '10 10';
		vector screenpos = cs_project(self.origin);
		if (screenpos_z >= 0)
		{
			screenpos_x -= stringwidth(thetext, TRUE, charsize) *0.5;	//align horizontally to centre
			screenpos_y -= charsize_y *0.5;	//align vertically again
			screenpos_z = 0;	//shut up dp.
			drawstring(screenpos, thetext, charsize, '3 3 3', 1, 0);
		}
	}
};

void(float newent) Health_Indicator = { self.origin_x = ReadCoord();
	self.origin_y = ReadCoord();
	self.origin_z = ReadCoord();
	self.cnt = ReadShort();
	if (newent)
	{
		self.classname = "missile";
		//self.drawmask = MASK_NORMAL;	// makes the entity visible
		//setmodel(self, "models/dev/gizmo.md3");
		self.draw2d = Health_Messages_Draw;
	}
};
/*
.float alpha;
void() Artifact_Think =
{
if(self.frame == 1)
self.alpha = 0.1;
if(self.frame == 2)
self.alpha = 0.2;
if(self.frame == 3)
self.alpha = 0.4;
if(self.frame == 4)
self.alpha = 0.6;
if(self.frame == 5)
self.alpha = 0.8;
if(self.frame == 6)
self.alpha = 1;

setorigin (self,VF_ORIGIN);

};

void(float newent)artifact_spawn =
{
	self.origin_x = ReadCoord();
	self.origin_y = ReadCoord();
	self.origin_z = ReadCoord();
	self.frame = ReadShort();
	if (newent)
	{
		self.classname = "artifact";
		self.drawmask = MASK_NORMAL;	// makes the entity visible
		setmodel(self, "models/artifacts/active/cruel_aegis_active.md3");
		self.think = Artifact_Think;
		self.nextthink = time;
		}
};
*/

float mrmenualpha;

void() show_messages_ui = 
{
	vector posimage, posimage2;
	string ui_image = "gfx/journal/journal.tga";
	posimage = '224 70 0';
	drawfill('0 0 0', vid_width *'1 0 0' + vid_height *'0 1 0', '0 0 0', 0.65, 0);
	DImage3((posimage), ui_image, 1, '1 1 1', ('512 400 0'));


	vector colorimg;
	colorimg = '0.82 0.82 0.82';
	posimage2 = fixed_vector('-40 -480 0');
	posimage2 += fixed_vector( '0 40 0');


	float message_number = getstatf(STAT_NORMAL_MESSAGES);

	#if 0
	if(message_number == 1)
	{
	DString(posimage2, _("Message Text1line 1"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 2"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 3"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 4"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 5"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 6"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 7"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 8"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 9"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 10"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 11"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 12"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 13"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 14"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 15"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 16"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 17"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text1line 18"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	}
	if(message_number == 2)
	{
	DString(posimage2, _("Message Text2line 1"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 2"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 3"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 4"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 5"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 6"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 7"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 8"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 9"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 10"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 11"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 12"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 13"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 14"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 15"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 16"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 17"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	DString(posimage2, _("Message Text2line 18"), 1, 1, colorimg, ' 14 14 0');posimage2 += fixed_vector('0 20 0');
	}
	#endif
};

////////////////end of qc file
