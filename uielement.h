//========================================================================
//
//  RK-HUD/RK-UI framework
//  specific wrath version, but can be easily adapted to any DP/FTE project
//
//  Copyright (C) 2023 - 2024  Samuel "Reki" Piper
//
//  This code is free software; you can redistribute it and/or modify
//  it under the terms of the GNU GPL (General Public License); either
//  version 2 of the License, or (at your option) any later version.
//
//========================================================================

#pragma once
enum UITYPE:float {
	EMPTY,
	LIST,
	TEXT,
	PICTURE,
};

enumflags UIFLAG:float {
	STRETCH,
	HIDE,
	CLICKABLE,
	SELECTABLE,
	KEEPSELECT,
	HIGHLIGHT,
	FORCECURSOR,
	CLIP,
	INIT,
	SETALPHA,
	MULTALPHA,
};

class uielement_c;

#define CONVERT_TO_DP_SHITTY_COLOR(color)	((color - '0.5 0.5 0.5') * 2)
#define CONVERT_FROM_DP_SHITTY_COLOR(color)	((color / 2) + '0.5 0.5 0.5')
#define INBOUNDS(point, mins, maxs)		((point[0] >= mins[0] && point[0] <= maxs[0]) && (point[1] >= mins[1] && point[1] <= maxs[1]))
vector ui_clipstart;
vector ui_clipsize;
vector ui_mouseposition;
vector ui_position;
vector ui_scale;
float ui_alpha;
uielement_c ui_selected;
uielement_c ui_hover;
uielement_c ui_oldhover;
uielement_c ui_screen_queue; // ui elements without an owner, aka parented to the screen overall
float ui_usemouse;
float ui_oldusemouse;
float ui_renderframe;

#ifdef CSQC
uielement_c ui_hud;
vector autocvar_scr_hudborder;
float autocvar_scr_hudscale;
#endif

#ifdef CSQC
#define frametime clframetime
#elif defined(MENU)
#define frametime clframetime
#endif

//////// UI Element classes //////////////////////////////////
// this replaces the original hardcoded ui system.          //
// each element is an entity, and should be initialized     //
// at load time as this system is not optimized for adding  //
// or removing elements on the fly                          //
//////////////////////////////////////////////////////////////

class uielement_c
{
	float type;
	UIFLAG flags;
	float drawflags;

	vector origin;
	vector anchor;
	vector justify;
	vector size;

	vector color;
	float alpha;
	float mod_col;
	float mod_alp;

	uielement_c _list; // elements that I "own"
	uielement_c owner; // element that owns me, if any
	uielement_c _next; // the element after me in my owner's list

	uielement_c partner; // elements that I want to reference
	uielement_c partner2;
	uielement_c partner3;
	uielement_c partner4;
	uielement_c partner5;
	uielement_c partner6;
	uielement_c partner7;
	uielement_c partner8;
	uielement_c partner9;

	// generic linked list
	nonvirtual void() link_to_owner {
		if (!owner) // link to screen render queue
		{
			if (!ui_screen_queue)
			{
				ui_screen_queue = this;
				return;
			}
			
			uielement_c h, e;
			for(e = ui_screen_queue; e; h = e, e = e._next); // find end of list
			h._next = this; // link into list at end
			this._next = __NULL__;
			return;
		}

		if (!owner._list) // if owner list is __NULL__, we're the head of the list
		{
			owner._list = this;
			return;
		}
		
		uielement_c h, e;
		for(e = owner._list; e; h = e, e = e._next); // find end of list
		h._next = this; // link into list at end
		this._next = __NULL__;
	};

	// constructor
	nonvirtual void() uielement_c {
		if (flags & UIFLAG::INIT)
			return;
		
		flags |= UIFLAG::INIT;
		if (!color)
			color = '1 1 1';
		if (!alpha)
			alpha = 1.0;
		mod_col = 1;
		mod_alp = 1;
		link_to_owner();
	};

	// totalsize
	virtual vector() totalsize {
		return [size[0] * ui_scale[0], size[1] * ui_scale[1]];
	};

	var virtual void(uielement_c this, __inout vector position) preloop; // called before looping
	var virtual void(uielement_c this, __inout vector position) loopthrough; // called when looping through children for rendering

	// if present, returns true if we should draw
	var virtual float(uielement_c this) active_condition;

	// mouse is over button
	var virtual void(uielement_c this) m_over {
		if !(flags & UIFLAG::CLICKABLE)
			return;
		
		if (flags & UIFLAG::HIGHLIGHT)
		{
			mod_col = 1.2;
			mod_alp = 1.1;
		}
	};

	// mouse was over button, but now has moved
	var virtual void(uielement_c this) m_leave { 
		if (flags & UIFLAG::HIGHLIGHT)
		{
			mod_col = 1;
			mod_alp = 1;
		}
	};

	// mouse clicked on the button
	var virtual void(uielement_c this) m_click;
	var virtual void(uielement_c this) m_unclick;

	// general input entrypoint
	var virtual float(uielement_c this, float nkey, float ascii, float released) input;

	// render our element
	virtual void() render {
		return; // stub
	};
};

////////////////
//  List Element
////////////////
class uilist_c : uielement_c
{
	vector separation;
	float scroll;
	float scroll_count;
	float elements;
	float elements_temp;
	
	// preloop
	nonvirtual void(uielement_c this, __inout vector position) list_preloop {
		elements = elements_temp;
		elements_temp = 0;
		vector scaled_sep = [separation[0] * ui_scale[0], separation[1] * ui_scale[1]];

		if (separation[0])
			scroll_count = floor(size[0] / separation[0]);
		else if (separation[1])
			scroll_count = floor(size[1] / separation[1]);

		if (elements > scroll_count)
		{
			scroll = bound(0, scroll, elements - scroll_count);
			position += scaled_sep * -scroll;
		}
		else
		{
			scroll = 0;
		}
	};

	// loopthrough
	nonvirtual void(uielement_c this, __inout vector position) list_loopthrough {
		vector scaled_sep = [separation[0] * ui_scale[0], separation[1] * ui_scale[1]];
		position += scaled_sep;
		elements_temp++;
	};

	// constructor
	nonvirtual void() uilist_c {
		type = UITYPE::LIST;
		if (preloop == __NULL__)
			preloop = list_preloop;
		if (loopthrough == __NULL__)
			loopthrough = list_loopthrough;
	};
};

class uismoothlist_c : uilist_c
{
	float scroll_smooth;
	float smoothspeed;

	// preloop
	nonvirtual void(uielement_c this, __inout vector position) list_preloop_smooth {
		elements = elements_temp;
		elements_temp = 0;
		vector scaled_sep = [separation[0] * ui_scale[0], separation[1] * ui_scale[1]];
		
		if (separation[0])
			scroll_count = floor(size[0] / separation[0]);
		else if (separation[1])
			scroll_count = floor(size[1] / separation[1]);

		if (elements > scroll_count)
		{
			scroll = bound(0, scroll, elements - scroll_count);
		}
		else
		{
			scroll = 0;
		}

		position += scaled_sep * -scroll_smooth;
	};

	virtual void() render {
		if (scroll_smooth > scroll)
			scroll_smooth = max(scroll, scroll_smooth - (smoothspeed * frametime));
		else if (scroll_smooth < scroll)
			scroll_smooth = min(scroll, scroll_smooth + (smoothspeed * frametime));
	};

	// constructor
	nonvirtual void() uismoothlist_c {
		type = UITYPE::LIST;
		if (!smoothspeed)
			smoothspeed = 20;
		preloop = list_preloop_smooth;
	};
};

////////////////
// Image Element
////////////////
class uipicture_c : uielement_c
{
	string image;
	string image2;
	#ifdef CSQC
	float angle;
	#endif

	// constructor
	nonvirtual void() uipicture_c {
		type = UITYPE::PICTURE;
		if (image)
			precache_pic(image);
		if (image2)
			precache_pic(image2);
	};

	var virtual void(uipicture_c this, __inout string img_to_render) prerender;

	// rendering for fill or pictures
	virtual void() render {
		vector final_color = color * mod_col; 				// 
		float final_alpha = alpha * mod_alp * ui_alpha; 	// handle hightlighting
		vector final_origin = ui_position;
		vector final_size = [size[0] * ui_scale[0], size[1] * ui_scale[1]];
		
		string final_img = image;
		if (prerender)
			prerender(this, final_img);
		if (final_img != __NULL__ && final_alpha > 0)
		{
			#ifdef CSQC
			if (!angle)
			{
			#endif
				drawpic(final_origin, final_img, final_size, final_color, final_alpha, drawflags);
			#ifdef CSQC
			}
			else
			{
				vector slength = final_size / 2;
				vector tl = final_origin + slength;
				vector tr = final_origin + slength;
				vector br = final_origin + slength;
				vector bl = final_origin + slength;
				
				float a = (angle + 180) * DEG2RAD;
				float a2 = (angle + 270) * DEG2RAD;
				tl += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];
				
				float a = (angle) * DEG2RAD;
				float a2 = (angle + 270) * DEG2RAD;
				tr += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];

				float a = (angle + 180) * DEG2RAD;
				float a2 = (angle + 90) * DEG2RAD;
				bl += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];
				
				float a = (angle) * DEG2RAD;
				float a2 = (angle + 90) * DEG2RAD;
				br += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];



				R_BeginPolygon(final_img, drawflags, 1);
				R_PolygonVertex(tl, '0 0', final_color, final_alpha);
				R_PolygonVertex(tr, '1 0', final_color, final_alpha);
				R_PolygonVertex(br, '1 1', final_color, final_alpha);
				R_PolygonVertex(bl, '0 1', final_color, final_alpha);
				R_EndPolygon();
			}
			#endif
		}
	};
};

class uilocpicture_c : uipicture_c
{
	string fallback_txt;
	vector fallback_sz;
	vector fallback_ofs;
	vector fallback_color;
	float fallback;
	float fallback_font;

	nonvirtual void() uilocpicture_c {
		fallback = (this.image == __NULL__);
		
		if (!fallback_font)
			fallback_font = FONT_MENU;

		if (!fallback_color)
			fallback_color = this.color;

		if (fallback)
		{
			float o_font = drawfont;
			drawfont = this.fallback_font;

			if (!fallback_sz)
			{
				float max_width = this.size[0];
				float fsize = bound(6, min(this.size[0] * 0.4, this.size[1] * 0.7), 48);
				this.fallback_sz = [fsize, fsize];
			}

			float strwidth = stringwidth(fallback_txt, TRUE, this.fallback_sz);
			strwidth = max(strwidth, 16);
			if (strwidth > this.size[0])
			{
				float scaler = (this.size[0] / strwidth);
				this.fallback_sz[0] *= scaler;
				strwidth *= scaler;
			}

			this.fallback_ofs[0] += (this.size[0] - stringwidth(fallback_txt, TRUE, this.fallback_sz)) * 0.5;
			this.fallback_ofs[1] += (this.size[1] - this.fallback_sz[1]) * 0.5;
			drawfont = o_font;
		}
	};

	// totalsize
	virtual vector() totalsize {
		if (fallback && 0)
		{
			float o_drawfont = drawfont;
			drawfont = fallback_font;
			if (!fallback_txt)
				return '0 0';
			float txt_width = stringwidth(fallback_txt, TRUE, [fallback_sz[0] * ui_scale[0], fallback_sz[1] * ui_scale[1]]);
			drawfont = o_drawfont;

			vector sz = [txt_width, fallback_sz[1] * ui_scale[1]];
			return sz;
		}
		else
		{
			return [size[0] * ui_scale[0], size[1] * ui_scale[1]];
		}
	};

	var virtual void(uilocpicture_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) prerender_text;
	virtual void() render {

		if (fallback)
		{
			float o_drawfont = drawfont;
			drawfont = fallback_font;

			vector final_color = fallback_color * mod_col; 		// 
			float final_alpha = alpha * mod_alp * ui_alpha; 	// handle hightlighting
			vector final_origin = ui_position;
			final_origin += [fallback_ofs[0] * ui_scale[0], fallback_ofs[1] * ui_scale[1]];
			//final_origin += [padding[0] * ui_scale[0], padding[1] * ui_scale[1]] * 0.5;

			vector final_size = [fallback_sz[0] * ui_scale[0], fallback_sz[1] * ui_scale[1]];
			string final_text = fallback_txt;

			if (prerender_text)
				prerender_text(this, final_text, final_color, final_alpha);

			if (final_size[0] <= 0 || final_size[1] <= 0 || final_alpha <= 0 || !final_text || !strcmp(final_text, ""))
				return;
			
			drawstring(final_origin, final_text, final_size, final_color, final_alpha, drawflags);

			drawfont = o_drawfont;
		}
		else
		{
			vector final_color = color * mod_col; 				// 
			float final_alpha = alpha * mod_alp * ui_alpha; 	// handle hightlighting
			vector final_origin = ui_position;
			vector final_size = [size[0] * ui_scale[0], size[1] * ui_scale[1]];
			
			string final_img = image;
			if (prerender)
				prerender(this, final_img);
			if (final_img != __NULL__ && final_alpha > 0)
			{
				#ifdef CSQC
				if (!angle)
				{
				#endif
					drawpic(final_origin, final_img, final_size, final_color, final_alpha, drawflags);
				#ifdef CSQC
				}
				else
				{
					vector slength = final_size / 2;
					vector tl = final_origin + slength;
					vector tr = final_origin + slength;
					vector br = final_origin + slength;
					vector bl = final_origin + slength;
					
					float a = (angle + 180) * DEG2RAD;
					float a2 = (angle + 270) * DEG2RAD;
					tl += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];
					
					float a = (angle) * DEG2RAD;
					float a2 = (angle + 270) * DEG2RAD;
					tr += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];

					float a = (angle + 180) * DEG2RAD;
					float a2 = (angle + 90) * DEG2RAD;
					bl += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];
					
					float a = (angle) * DEG2RAD;
					float a2 = (angle + 90) * DEG2RAD;
					br += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];



					R_BeginPolygon(final_img, drawflags, 1);
					R_PolygonVertex(tl, '0 0', final_color, final_alpha);
					R_PolygonVertex(tr, '1 0', final_color, final_alpha);
					R_PolygonVertex(br, '1 1', final_color, final_alpha);
					R_PolygonVertex(bl, '0 1', final_color, final_alpha);
					R_EndPolygon();
				}
				#endif
			}
		}
	};
};

float autocvar_joy_x360_preset;
class uiglyph_c : uipicture_c
{
	string bind_cmd;
	CONTROLLER last_controllerType;
	float last_joyPreset;

	virtual void() render {
		
		if (input_mode != IN_MODE_GAMEPAD)
			return;

		if (last_controllerType != controllerType || last_joyPreset != autocvar_joy_x360_preset)
		{
			string code = bind_cmd;
			
			if (code != "rs" && code != "ls")
			{
				float argc = tokenize(findkeysforcommand(bind_cmd, 0));
				float keynum = -1;
				for(float j = 0; j < argc; j++)
				{
					float num = stof(argv(j));
					float btype = bind_gettype(num);
					if (btype == INPUT_TYPE::XBOX)
					{
						keynum = num;
						break;
					}
				}

				if (keynum < 0)
					return;

				code = ftos(keynum);
			}

			if (image)
				strunzone(image);

			image = strzone(Controller_GetGlyph(code));
			last_controllerType = controllerType;
			last_joyPreset = autocvar_joy_x360_preset;
		}

		string final_img = image;
		vector final_color = color * mod_col; 				// 
		float final_alpha = alpha * mod_alp * ui_alpha; 	// handle hightlighting
		vector final_origin = ui_position;
		vector final_size = [size[0] * ui_scale[0], size[1] * ui_scale[1]];
		
		if (prerender)
			prerender(this, final_img);
		if (final_img != __NULL__ && final_alpha > 0)
		{
			#ifdef CSQC
			if (!angle)
			{
			#endif
				drawpic(final_origin, final_img, final_size, final_color, final_alpha, drawflags);
			#ifdef CSQC
			}
			else
			{
				vector slength = final_size / 2;
				vector tl = final_origin + slength;
				vector tr = final_origin + slength;
				vector br = final_origin + slength;
				vector bl = final_origin + slength;
				
				float a = (angle + 180) * DEG2RAD;
				float a2 = (angle + 270) * DEG2RAD;
				tl += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];
				
				float a = (angle) * DEG2RAD;
				float a2 = (angle + 270) * DEG2RAD;
				tr += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];

				float a = (angle + 180) * DEG2RAD;
				float a2 = (angle + 90) * DEG2RAD;
				bl += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];
				
				float a = (angle) * DEG2RAD;
				float a2 = (angle + 90) * DEG2RAD;
				br += [(cos(a) * slength[0]) + (cos(a2) * slength[1]), (sin(a) * slength[0]) + (sin(a2) * slength[1])];



				R_BeginPolygon(final_img, drawflags, 1);
				R_PolygonVertex(tl, '0 0', final_color, final_alpha);
				R_PolygonVertex(tr, '1 0', final_color, final_alpha);
				R_PolygonVertex(br, '1 1', final_color, final_alpha);
				R_PolygonVertex(bl, '0 1', final_color, final_alpha);
				R_EndPolygon();
			}
			#endif
		}
	};
};

class uispritesheet_c : uielement_c
{
	string image;
	string image2;
	vector sprite;
	vector sheet_size;

	// constructor
	nonvirtual void() uispritesheet_c {
		type = UITYPE::PICTURE;
		if (image)
			precache_pic(image);
		if (image2)
			precache_pic(image2);
	};

	var virtual void(uispritesheet_c this, __inout string img_to_render, __inout vector sprite_to_render) prerender;

	virtual void() render {
		vector final_color = color * mod_col; 				// 
		float final_alpha = alpha * mod_alp * ui_alpha; 	// handle hightlighting
		vector final_origin = ui_position;
		vector final_size = [size[0] * ui_scale[0], size[1] * ui_scale[1]];

		string final_img = image;
		vector final_sprite = sprite;
		if (prerender)
			prerender(this, final_img, final_sprite);
		if (final_img && final_alpha > 0)
		{
			#ifdef CSQC
			final_sprite[0] = floor(final_sprite[0]);
			final_sprite[1] = floor(final_sprite[1]);

			vector tc_u = '0 0';
			vector tc_v = '1 1';
			tc_v[0] /= sheet_size[0];
			tc_v[1] /= sheet_size[1];

			tc_u[0] += tc_v[0] * final_sprite[0];
			tc_u[1] += tc_v[1] * final_sprite[1];

			tc_v[0] += tc_v[0] * final_sprite[0];
			tc_v[1] += tc_v[1] * final_sprite[1];

			R_BeginPolygon(final_img, drawflags, 1);
			R_PolygonVertex(final_origin, 						[tc_u[0], tc_u[1]], final_color, final_alpha);
			R_PolygonVertex(final_origin + [final_size[0], 0], 	[tc_v[0], tc_u[1]], final_color, final_alpha);
			R_PolygonVertex(final_origin + final_size, 			[tc_v[0], tc_v[1]], final_color, final_alpha);
			R_PolygonVertex(final_origin + [0, final_size[1]], 	[tc_u[0], tc_v[1]], final_color, final_alpha);
			R_EndPolygon();
			#endif
		}
	};
};

class uifill_c : uielement_c
{
	var virtual void(uifill_c this, __inout vector color_to_render, __inout float alpha_to_render) prerender;

	nonvirtual void() uifill_c {
		type = UITYPE::PICTURE;
	};

	// rendering for fill or pictures
	virtual void() render {
		vector final_color = color * mod_col; 				// 
		float final_alpha = alpha * mod_alp * ui_alpha; 	// handle hightlighting
		vector final_origin = ui_position;
		vector final_size = [size[0] * ui_scale[0], size[1] * ui_scale[1]];

		if (prerender)
			prerender(this, final_color, final_alpha);
		if (final_alpha > 0)
		{
			drawfill(final_origin, final_size, final_color, final_alpha, drawflags);
		}
	};
};

////////////////
//  Text Element
////////////////
class uitext_c : uielement_c
{
	string text;
	float font;
	vector padding;

	// constructor
	nonvirtual void() uitext_c {
		if (!text)
			text = "NULL TEXT";
		if (!font)
		#ifdef MENU
			font = FONT_MENU;
		#else
			font = FONT_USER7;
		#endif
		type = UITYPE::TEXT;
	};

	// totalsize
	virtual vector() totalsize {
		float o_drawfont = drawfont;
		drawfont = font;
		if (!text)
			return '0 0';
		float txt_width = stringwidth(text, TRUE, [size[0] * ui_scale[0], size[1] * ui_scale[1]]);
		drawfont = o_drawfont;

		vector sz = [txt_width, size[1] * ui_scale[1]];
		sz += [padding[0] * ui_scale[0], padding[1] * ui_scale[1]];
		return sz;
	};

	var virtual void(uitext_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) prerender;

	// rendering our text
	virtual void() render {
		float o_drawfont = drawfont;
		drawfont = font;

		vector final_color = color * mod_col; 				// 
		float final_alpha = alpha * mod_alp * ui_alpha; 	// handle hightlighting
		vector final_origin = ui_position;
		final_origin += [padding[0] * ui_scale[0], padding[1] * ui_scale[1]] * 0.5;

		vector final_size = [size[0] * ui_scale[0], size[1] * ui_scale[1]];
		string final_text = text;

		if (prerender)
			prerender(this, final_text, final_color, final_alpha);

		if (final_size[0] <= 0 || final_size[1] <= 0 || final_alpha <= 0 || !text || !strcmp(text, ""))
			return;
		
		drawstring(final_origin, final_text, final_size, final_color, final_alpha, drawflags);

		drawfont = o_drawfont;
	};
};

void UI_RenderElements(uielement_c chain);
void UI_CheckClick(uielement_c chain);
float UI_CheckInput(uielement_c chain, float nkey, float ascii, float released);

float lastsoundjournal;
void Journal_Sound(void)
{
	float r = floor(random() *7) + 1;
	if (r == lastsoundjournal)
		r += 1;
	if (r > 7)
		r = 1;
	lastsoundjournal = r;
	string rsound = ftos(r);
	#ifdef MENU
	localsound(strcat("sound/ui/journal/journal_page", rsound, ".ogg"));
	#else
	localcmd(strcat("play2 sound/ui/journal/journal_page", rsound, ".ogg\n"));
	#endif
}

#undef frametime