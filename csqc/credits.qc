
#ifdef CREDITS
// Reki (November 9 2023): Parse credits file
void Credits_LoadfromFile(string fp, uielement_c credits)
{
	float f = fopen(fp, FILE_READ);
	if (f < 0)
		return;

	
	vector pos = '16 0';
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
			float argc = tokenizebyseparator(fullcmd, "=");
			string cmd = argv(0);

			//print("command = ", cmd, "\n");
			switch (cmd)
			{
				case "h1": fsz = 64; break;
				case "h2": fsz = 40; break;
				case "h3": fsz = 32; break;
				case "h4": fsz = 24; break;
				case "txt": break;
				case "img": {
					s = __NULL__;
					
					string pic = argv(1);
					vector isz = '128 128';
					vector image_size = drawgetimagesize(pic);
					isz[0] = image_size[0] * (isz[1] / image_size[1]);

					block = spawn(uipicture_c, owner: credits, origin: pos, size: isz, image: strzone(pic));
					pos[1] += isz[1] + 16;
					} break;
				case "br": {
					pos[1] += fsz + 16;
					} break;
			}

			if (s) // if we still are using the string, bypass the command
			{
				s = substring(s, o + 1, strlen(s)); 
			}
		}
		
		if (s && s != "")
		{
			block = spawn(uitext_c, owner: credits, origin: pos, font: FONT_USER6, size: [fsz, fsz], text: strzone(s));
			pos[1] += fsz - 2;
			//print("adding string = ", s, "\n");
		}

	}
	credits.health = pos[1];

	fclose(f);
}




float endscreen_startfade;
const float endscreen_fadelength = 15;
const float endscreen_creditstart;
const float endscreen_creditspeed = 40;
const float endscreen_creditfade = 0.2;
const float endscreen_creditwait = 768;
const float endscreen_creditfadeduration = endscreen_creditspeed * 4;

void HUD_InitializeEndscreen(void)
{
	float(uifill_c this) endscreen_conditional = {
		endscreen_startfade = getstatf(STAT_ENDSCREENSTART);
		endscreen_creditstart = endscreen_startfade + (endscreen_fadelength * 0.33);
		if (endscreen_startfade && time > endscreen_startfade)
			return TRUE;
		return FALSE;
	};

	void(uifill_c this, __inout vector position) endscreen_preloop = {
		float stime = endscreen_startfade;
		float etime = stime + endscreen_fadelength;
		float ctime = etime - time;
		uielement_c splash = this.partner;
		uifill_c backdrop = (uifill_c)this.partner2;

		if (ctime >= 0)
		{
			splash.alpha = 0;
			backdrop.alpha = bound(0, (1 - (ctime / endscreen_fadelength)) * endscreen_creditfade, endscreen_creditfade);
		}
		else
		{
			backdrop.alpha = endscreen_creditfade;
		}

		splash.alpha = 1;
		splash.origin[1] = -endscreen_creditspeed * (time - endscreen_creditstart);

		float splash_fade = ((fabs(splash.origin[1]) - splash.health) - endscreen_creditfadeduration) / (endscreen_creditwait);
		if (splash_fade >= 1)
		{
			backdrop.alpha = 1;
			localcmd("disconnect\nmenu_restart\ntogglemenu\n");
		}
		else if (splash_fade > 0)
		{
			backdrop.alpha = (endscreen_creditfade + (splash_fade * (1 - endscreen_creditfade)));
			splash.alpha = 1 - splash_fade;
		}
	};
	

	uielement_c endscreen = spawn(uielement_c, flags: UIFLAG::STRETCH);
		endscreen.active_condition = endscreen_conditional;
		endscreen.preloop = endscreen_preloop;
	uifill_c backsplash = spawn(uifill_c, flags: UIFLAG::STRETCH, owner: endscreen); backsplash.color = '0 0 0'; backsplash.alpha = 0;
	uielement_c splash = spawn(uielement_c, owner: endscreen, size: '960 540', anchor: '0 1', flags: UIFLAG::MULTALPHA); splash.alpha = 0;


	endscreen.partner = splash;
	endscreen.partner2 = backsplash;

	Credits_LoadfromFile("cutscenes/wrath.credits", splash);
}
#endif
