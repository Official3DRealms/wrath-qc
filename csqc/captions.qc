


class caption_text_c;
caption_text_c caption_list;
caption_text_c caption_list_tail;
#define NEWLINE_TAB ""

class caption_text_c {
	string text;
	float endtime;
	float alpha;
	float simple;
	caption_text_c _prev;
	caption_text_c _next;

	nonvirtual void() caption_text_c {
		
		if (!text)
		{
			remove(this);
			return;
		}

		if (!endtime) // caption time
			endtime = time + 5;
		if (!alpha)
			alpha = 0.001;

		// if list has elements already, make sure we're linked in
		if (caption_list)
			caption_list._prev = this;
		else
			caption_list_tail = this;
		
		// make head of list
		this._next = caption_list;
		caption_list = this;

		// split off other lines
		if (strstrofs(text, "\n", 0) >= 0 && !simple)
		{
			string str_list[32];
			float argc = min(str_list.length, tokenizebyseparator(text, "\n"));
			for(float i = 0; i < argc; i++)
				str_list[i] = argv(i);

			text = strzone(str_list[0]);
			for(float i = 1; i < argc; i++)
				spawn(caption_text_c, text: str_list[i], simple: 1);
		}
		else
		{
			text = strzone(text);
		}
	};

	nonvirtual void() destructor {
		if (caption_list == this)
			caption_list = this._next;
		else
			this._prev._next = this._next;
		
		if (this._next)
			this._next._prev = this._prev;
		else if (caption_list_tail == this)
			caption_list_tail = this._prev;

		remove(this);
	};
};

void HUD_InitializeCaptions(void)
{
	static uitext_c caption_lines[8];

	void(uielement_c this, __inout vector position) fillbox_preloop = {
		this.size[0] = min(vid_width * 0.8, 500);// * ui_scale[0];
		this.size[1] = 120;// / ui_scale[1];

		// clear all lines
		for(float i = 0; i < caption_lines.length; i++)
		{
			uitext_c line = caption_lines[i];
			uifill_c backdrop = (uifill_c)line.partner;
			if (line.text)
				strunzone(line.text);
			line.text = 0;
			backdrop.flags |= UIFLAG::HIDE;
		}
		//

		// check caption states
		caption_text_c entry = caption_list;
		while(entry)
		{
			caption_text_c next = entry._next;

			if (time > entry.endtime)
				entry.destructor();
			else if (time < (entry.endtime - 1))
			{
				entry.alpha = min(entry.alpha + (frametime * 2), 1);
			}
			else
			{
				entry.alpha = max(entry.alpha - (frametime * 1), 0);
			}

			entry = next;
		}

		// generate new lines
		void fix_backdrop_for_line(uitext_c line, caption_text_c caption, __inout float offs)
		{
			float depth = 16;

			#if 0
			if (time < caption.endtime - 1) // new line, we haven't started fading yet
				offs += depth;
			else
				offs += depth * bound(0, (line.alpha * 2), 1);
			#else
			offs += depth;
			#endif

			vector o = [0, -10 + offs];
			vector o_uiscale = ui_scale;
			ui_scale = '1 1';

			uifill_c backdrop = (uifill_c)line.partner;
			
			line.origin = o;
			backdrop.origin = line.origin + '0 -1';
			backdrop.alpha = line.alpha * 0.4;

			backdrop.size = line.totalsize();
			backdrop.size[0] /= ui_scale[0];
			backdrop.size[1] /= ui_scale[1];
			backdrop.size += '4 2';
			backdrop.flags &= ~UIFLAG::HIDE;
			ui_scale = o_uiscale;
		}

		float maxwidth = this.size[0] - 8;
		caption_text_c dialogue;
		float o_font = drawfont;
		float linecount = 0;
		float linewidth = 0;
		float offs = 0;
		#if 1
		for(dialogue = caption_list_tail; dialogue; dialogue = dialogue._prev)
		{
			float i = 0;
			float argc = tokenizebyseparator(dialogue.text, " ");
			string text = argv(i);
			while(linecount < caption_lines.length)
			{
				if (i > argc)
					break;

				uitext_c line = caption_lines[linecount];
				line.alpha = dialogue.alpha;

				float textwidth = stringwidth(text, TRUE, line.size);
				drawfont = line.font;

				//print(sprintf("%3.0f vs %3.0f (%s)\n", linewidth, maxwidth, text));

				if ((linewidth + textwidth) < maxwidth) // if this text will fit, add it to the line!
				{
					linewidth += textwidth;
					line.text = strcat(line.text, text);

					i++;
					text = argv(i);
					if (i > 0)
						text = strcat(" ", text);

					continue;
				}
				
				if (textwidth >= (maxwidth * 0.5)) // we need to split this line sadly
				{
					float length = strlen(text);
					for(float j = 0; j <= length; j++)
					{
						string sub = substring(text, 0, j);
						float width = stringwidth(sub, TRUE, line.size);

						//if (width >= maxwidth || TRUE) // this is confusing and jank
						{
							sub = substring(text, 0, j - 4);
							sub = strcat(sub, "-");

							line.text = strcat(line.text, sub);
							text = substring(text, j - 3, -1);
							text = strcat(NEWLINE_TAB, text);
							//i++;

							fix_backdrop_for_line(line, dialogue, offs);
							linewidth = 0;
							linecount++;
							break;
						}
					}
					continue;
				}
				
				//line.text = strzone(line.text);
				text = strcat(NEWLINE_TAB, text);
				fix_backdrop_for_line(line, dialogue, offs);
				linewidth = 0;
				linecount++;
				continue;
			}

			fix_backdrop_for_line(line, dialogue, offs);
			linewidth = 0;
			linecount++;
			if (linecount >= caption_lines.length)
				break;
		}
		//
		#endif

		// zone all remaining lines
		for(float i = 0; i < caption_lines.length; i++)
		{
			uitext_c line = caption_lines[i];
			line.text = strzone(line.text);
		}
		//

		drawfont = o_font;
	};

	float(uielement_c this) captionbox_active = {
		return (caption_list != 0);
	};

	uielement_c captionbox = spawn(uielement_c, owner: ui_hud, flags: UIFLAG::STRETCH | UIFLAG::SETALPHA, alpha: 1);
		captionbox.active_condition = captionbox_active;

	uifill_c fillbox = spawn(uifill_c, owner: captionbox, origin: '0 -68', anchor: '0.5 1', justify: '0.5 1', size: '400 120', color: '-1 -1 -1', alpha: 0.001);
		fillbox.preloop = fillbox_preloop;
	
	for(float i = caption_lines.length - 1; i >= 0; i--) // inverted loop so we draw sort front to back
	{
		uifill_c backdrop = spawn(uifill_c, owner:fillbox, anchor: '0.5 0', justify: '0.5 0', color: CONVERT_TO_DP_SHITTY_COLOR('0 0 0'), alpha: 0.4);
		caption_lines[i] = spawn(uitext_c, owner: fillbox, anchor: '0.5 0', justify:'0.5 0', font: FONT_USER7, size: '14 14');
		caption_lines[i].text = 0;
		caption_lines[i].partner = backdrop;
	}

	//spawn(caption_text_c, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sit amet sem varius, blandit quam luctus, condimentum lacus.");
	//spawn(caption_text_c, text: "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890uvwxyz");
}









