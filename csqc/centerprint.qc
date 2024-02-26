


void CSQC_Parse_CenterPrint(string);
void TempEnt_Centerprint(void)
{
	string str = ReadString();
	CSQC_Parse_CenterPrint(str);
}

#define CENTERPRINT_MAXLINES 24
#define CENTERPRINT_TIMEOUT 5

uielement_c centerprint_list;
void HUD_InitializeCenterprint(void)
{
	void(uielement_c this) cprint_preloop = {
		uitext_c lst = this.partner;

		if (this.health && time > this.health)
		{
			this.health = 0;
			while(lst) // clear text
			{
				if (lst.text)
					strunzone(lst.text);
				lst.text = 0;
				lst.flags |= UIFLAG::HIDE;
				lst = lst.partner;
			}
		}
	};

	uilist_c container = spawn(uilist_c, owner: ui_hud, anchor: '0.5 0.32', separation: '0 16');
		container.preloop = cprint_preloop;
		centerprint_list = container;

	uitext_c hold = 0;
	for(float i = 0; i < CENTERPRINT_MAXLINES; i++)
	{
		uitext_c txt = spawn(uitext_c, owner: container, justify: '0.5 0', size: '8 8', text: strzone(" "), font: FONT_CENTERPRINT, flags: UIFLAG::HIDE);
		
		txt.partner2 = spawn(uipicture_c, owner: txt);
		txt.partner3 = spawn(uipicture_c, owner: txt);
		txt.partner4 = spawn(uipicture_c, owner: txt);

		// link into list
		if (hold)
			hold.partner = txt;
		else
			container.partner = txt;
		hold = txt;
	}
}

void centerprint(string s)
{
	float argc = tokenizebyseparator(s, "\n");
	
	float i;
	uitext_c txt = centerprint_list.partner;
	for(i = 0; i < min(argc, CENTERPRINT_MAXLINES); i++, txt = txt.partner)
	{
		if (txt.text)
			strunzone(txt.text);
		
		string sub_s = argv(i);

		.uielement_c glpyhlist[] = {uielement_c::partner2, uielement_c::partner3, uielement_c::partner4}
		for(float n = 0; n < glpyhlist.length; n++) // hide all glyphs
			txt.glpyhlist[n].flags |= UIFLAG::HIDE;

		float k = 3;
		while(strstrofs(sub_s, "{GLYPH_", 0) >= 0 && k > 0)
		{
			k--;
			float ofs_openbracket = strstrofs(sub_s, "{GLYPH_", 0);
			float ofs_closebracket = strstrofs(sub_s, "}", ofs_openbracket);

			float ofs_code = ofs_openbracket + strlen("{GLYPH_");
			string code = substring(sub_s, ofs_code, ofs_closebracket - ofs_code);

			string s1 = strcat(substring(sub_s, 0, ofs_openbracket), "[   ");
			string s2 = strcat("   ]", substring(sub_s, ofs_closebracket + 1, strlen(sub_s)));

			sub_s = strcat(s1, s2);
			uipicture_c glyph = (uipicture_c)(txt.glpyhlist[k]);
			if (glyph.image)
				strunzone(glyph.image);

			glyph.flags &= ~UIFLAG::HIDE;
			glyph.image = strzone(Controller_GetGlyph(code));
			glyph.size = '20 20';
			glyph.anchor = '0 0.5';
			glyph.justify = '0.5 0.5';

			float o_drawfont = drawfont;
			drawfont = txt.font;
			glyph.origin[0] = round(stringwidth(s1, TRUE, txt.size));
			drawfont = o_drawfont;

			glyph.origin[1] = -2;
		}
		
		txt.text = strzone(sub_s);
		txt.flags &= ~UIFLAG::HIDE;
	}

	// clean up any remaining lines
	for(; i < CENTERPRINT_MAXLINES; i++, txt = txt.partner)
	{
		if (txt.text)
			strunzone(txt.text);
		txt.text = 0;
		txt.flags |= UIFLAG::HIDE;
	}

	centerprint_list.health = time + CENTERPRINT_TIMEOUT;
}




