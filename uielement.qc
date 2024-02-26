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

#include "uielement.h"

vector ui_position;
vector ui_mouseposition;
vector ui_scale;

// letterbox hud on super wide resolutions
void UI_Letterbox(__inout vector hud_start, __inout vector hud_size)
{
	float master_ratio = 16 / 9;
	float ratio = max(vid_width, 1) / max(vid_height, 1);

	if (ratio > master_ratio)
	{
		hud_size[0] = vid_height * (master_ratio);
		hud_start[0] += (vid_width - hud_size[0]) / 2;
	}

	#ifdef CSQC
	if (autocvar_scr_hudborder)
	{
		hud_start += (autocvar_scr_hudborder / 2);
		hud_size -= (autocvar_scr_hudborder);
	}
	#endif
}

void UI_RenderElements(uielement_c chain) // recursive render function
{
	if (!chain) // uhh... we can't render something that doesn't exist
		return;
	
	vector master_position = ui_position;
	vector clip_start = ui_clipstart;
	vector clip_size = ui_clipsize;
	if (!chain.owner) // null parent, so we use the screen
	{
		vector hud_start = '0 0';
		vector hud_size = [vid_width, vid_height];
		
		if !(chain.flags & UIFLAG::STRETCH && chain.type == UITYPE::PICTURE)
			UI_Letterbox(hud_start, hud_size);

		master_position = hud_start;

		if (chain.flags & UIFLAG::STRETCH)
		{
			master_position = hud_start;
			chain.size[0] = hud_size[0] / ui_scale[0];
			chain.size[1] = hud_size[1] / ui_scale[1];
		}
		else if (chain.anchor)
		{
			master_position[0] += chain.anchor[0] * hud_size[0];
			master_position[1] += chain.anchor[1] * hud_size[1];
		}

		if (chain.flags & UIFLAG::HIDE)
			return;
		
		if (chain.active_condition)
			if (!chain.active_condition(chain))
				return;
	}
	else
	{
		if (chain.flags & UIFLAG::STRETCH)
		{
			master_position = ui_position;
			chain.size = chain.owner.totalsize();
			chain.size[0] /= ui_scale[0]; // Reki (May 26 2023): Gotta compensate for ui_scale
			chain.size[1] /= ui_scale[1]; // here otherwise the size isn't accurate :(
		}
		else if (chain.anchor)
		{
			vector vecofs = chain.owner.totalsize();
			master_position += [chain.anchor[0] * vecofs[0], chain.anchor[1] * vecofs[1]];
		}
	}

	float o_alpha = ui_alpha;
	if (chain.flags & UIFLAG::SETALPHA || chain.flags & UIFLAG::MULTALPHA)
	{
		if (chain.flags & UIFLAG::SETALPHA)
			ui_alpha = chain.alpha;
		else
			ui_alpha *= chain.alpha;
	}
	float master_alpha = ui_alpha;

	master_position[0] += chain.origin[0] * ui_scale[0];
	master_position[1] += chain.origin[1] * ui_scale[1];
	vector tsize = chain.totalsize();
	master_position[0] -= tsize[0] * chain.justify[0];
	master_position[1] -= tsize[1] * chain.justify[1];

	ui_position = master_position;
	if (chain.flags & UIFLAG::CLIP)
	{
		clip_start = ui_clipstart = master_position;
		clip_size = ui_clipsize = tsize;
		drawsetcliparea(ui_clipstart[0], ui_clipstart[1], ui_clipsize[0], ui_clipsize[1]);
	}
	if ((chain.flags & UIFLAG::CLICKABLE) || (chain.flags & UIFLAG::SELECTABLE) || (chain.flags & UIFLAG::FORCECURSOR) || (chain.flags & UIFLAG::HIGHLIGHT))
	{
		if (INBOUNDS(ui_mouseposition, master_position, (master_position + tsize)) && (!ui_clipsize || INBOUNDS(ui_mouseposition, ui_clipstart, (ui_clipstart + ui_clipsize))))
			ui_hover = chain;
	}
	if ((chain.flags & UIFLAG::CLICKABLE) || (chain.flags & UIFLAG::SELECTABLE) || (chain.flags & UIFLAG::FORCECURSOR))
		ui_usemouse = TRUE;
	chain.render(); // render the top

	if (chain.preloop)
		chain.preloop(chain, master_position);

	for(chain = chain._list; chain; chain = chain._next)
	{
		if (chain.flags & UIFLAG::HIDE)
			continue;
		
		if (chain.active_condition)
			if (!chain.active_condition(chain))
				continue;
		
		if (ui_clipsize != clip_size || ui_clipstart != clip_start)
		{
			if (clip_size[0] == 0 && clip_size[1] == 0)
				drawresetcliparea();
			else
				drawsetcliparea(ui_clipstart[0], ui_clipstart[1], ui_clipsize[0], ui_clipsize[1]);
			ui_clipstart = clip_start;
			ui_clipsize = clip_size;
		}
		ui_alpha = master_alpha;
		
		ui_position = master_position;
		UI_RenderElements(chain);

		if (chain.owner.loopthrough)
			chain.owner.loopthrough(chain.owner, master_position);
	}

	if (clip_size)
	{
		ui_clipstart = clip_start;
		ui_clipsize = clip_size;
		if (ui_clipsize[0] == 0 || ui_clipsize[1] == 0)
			drawresetcliparea();
		else
			drawsetcliparea(ui_clipstart[0], ui_clipstart[1], ui_clipsize[0], ui_clipsize[1]);
	}

	ui_alpha = o_alpha;
}

void UI_CheckClick(uielement_c chain)
{
	if (!chain) // uhh... we can't render something that doesn't exist
		return;
	
	vector master_position = ui_position;
	vector clip_start = ui_clipstart;
	vector clip_size = ui_clipsize;
	if (!chain.owner) // null parent, so we use the screen
	{
		vector hud_start = '0 0';
		vector hud_size = [vid_width, vid_height];
		if !(chain.flags & UIFLAG::STRETCH && chain.type == UITYPE::PICTURE)
			UI_Letterbox(hud_start, hud_size);

		master_position = hud_start;
		if (chain.flags & UIFLAG::STRETCH)
		{
			master_position = hud_start;
			chain.size[0] = hud_size[0] / ui_scale[0];
			chain.size[1] = hud_size[1] / ui_scale[1];
		}
		else if (chain.anchor)
		{
			master_position[0] += chain.anchor[0] * hud_size[0];
			master_position[1] += chain.anchor[1] * hud_size[1];
		}

		if (chain.flags & UIFLAG::HIDE)
			return;
		
		if (chain.active_condition)
			if (!chain.active_condition(chain))
				return;
	}
	else
	{
		if (chain.flags & UIFLAG::STRETCH)
		{
			master_position = ui_position;
			chain.size = chain.owner.totalsize();
		}
		else if (chain.anchor)
		{
			vector vecofs = chain.owner.totalsize();
			master_position += [chain.anchor[0] * vecofs[0], chain.anchor[1] * vecofs[1]];
		}
	}

	master_position[0] += chain.origin[0] * ui_scale[0];
	master_position[1] += chain.origin[1] * ui_scale[1];
	vector tsize = chain.totalsize();
	master_position[0] -= tsize[0] * chain.justify[0];
	master_position[1] -= tsize[1] * chain.justify[1];

	ui_position = master_position;
	if (chain.flags & UIFLAG::CLIP)
	{
		clip_start = ui_clipstart = master_position;
		clip_size = ui_clipsize = tsize;
	}
	if ((chain.flags & UIFLAG::SELECTABLE) || (chain.flags & UIFLAG::CLICKABLE))
	{
		if (INBOUNDS(ui_mouseposition, master_position, (master_position + tsize)) && (!ui_clipsize || INBOUNDS(ui_mouseposition, ui_clipstart, (ui_clipstart + ui_clipsize))))
			ui_selected = chain;
	}

	if (chain.preloop)
		chain.preloop(chain, master_position);

	for(chain = chain._list; chain; chain = chain._next)
	{
		if (chain.flags & UIFLAG::HIDE)
			continue;
		
		if (chain.active_condition)
			if (!chain.active_condition(chain))
				continue;
		
		if (ui_clipsize != clip_size || ui_clipstart != clip_start)
		{
			ui_clipstart = clip_start;
			ui_clipsize = clip_size;
		}

		ui_position = master_position;
		UI_CheckClick(chain);

		if (chain.owner.loopthrough)
			chain.owner.loopthrough(chain.owner, master_position);
	}


	if (clip_size)
	{
		ui_clipstart = clip_start;
		ui_clipsize = clip_size;
	}
}

// Called when a key is pressed, a more universal alternative to UI_CheckClick
float UI_CheckInput(uielement_c chain, float nkey, float ascii, float released) 
{
	if (!chain) // uhh... we can't render something that doesn't exist
		return FALSE;
	
	vector master_position = ui_position;
	vector clip_start = ui_clipstart;
	vector clip_size = ui_clipsize;
	if (!chain.owner) // null parent, so we use the screen
	{
		vector hud_start = '0 0 0';
		vector hud_size = [vid_width, vid_height];
		if !(chain.flags & UIFLAG::STRETCH && chain.type == UITYPE::PICTURE)
			UI_Letterbox(hud_start, hud_size);

		master_position = hud_start;
		master_position[0] += chain.anchor[0] * hud_size[0];
		master_position[1] += chain.anchor[1] * hud_size[1];
		
		if (chain.flags & UIFLAG::HIDE)
			return FALSE;
		
		if (chain.active_condition)
			if (!chain.active_condition(chain))
				return FALSE;
	}
	else if (chain.anchor)
	{
		vector vecofs = chain.owner.totalsize();
		master_position += [chain.anchor[0] * vecofs[0], chain.anchor[1] * vecofs[1]];
	}

	master_position[0] += chain.origin[0] * ui_scale[0];
	master_position[1] += chain.origin[1] * ui_scale[1];
	vector tsize = chain.totalsize();
	master_position[0] -= tsize[0] * chain.justify[0];
	master_position[1] -= tsize[1] * chain.justify[1];

	ui_position = master_position;

	float ui_handled = FALSE;
	if (chain.input)
		ui_handled = chain.input(chain, nkey, ascii, released);

	if (chain.preloop)
		chain.preloop(chain, master_position);

	for(chain = chain._list; chain; chain = chain._next)
	{
		if (chain.flags & UIFLAG::HIDE)
			continue;

		if (chain.active_condition)
			if (!chain.active_condition(chain))
				continue;

		ui_position = master_position;
		ui_handled |= UI_CheckInput(chain, nkey, ascii, released);

		if (chain.owner.loopthrough)
			chain.owner.loopthrough(chain.owner, master_position);
	}

	return ui_handled;
}

// when we want to loop through, but don't want to render or input
// this is kind of hacky and shit
void UI_DryRun(uielement_c chain) 
{
	if (!chain) // uhh... we can't render something that doesn't exist
		return;
	
	vector master_position = ui_position;
	vector clip_start = ui_clipstart;
	vector clip_size = ui_clipsize;
	if (!chain.owner) // null parent, so we use the screen
	{
		vector hud_start = '0 0 0';
		vector hud_size = [vid_width, vid_height];
		if !(chain.flags & UIFLAG::STRETCH && chain.type == UITYPE::PICTURE)
			UI_Letterbox(hud_start, hud_size);

		master_position = hud_start;
		master_position[0] += chain.anchor[0] * hud_size[0];
		master_position[1] += chain.anchor[1] * hud_size[1];
		
		if (chain.active_condition)
			chain.active_condition(chain);
	}
	else if (chain.anchor)
	{
		vector vecofs = chain.owner.totalsize();
		master_position += [chain.anchor[0] * vecofs[0], chain.anchor[1] * vecofs[1]];
	}

	master_position[0] += chain.origin[0] * ui_scale[0];
	master_position[1] += chain.origin[1] * ui_scale[1];
	vector tsize = chain.totalsize();
	master_position[0] -= tsize[0] * chain.justify[0];
	master_position[1] -= tsize[1] * chain.justify[1];

	ui_position = master_position;

	if (chain.preloop)
		chain.preloop(chain, master_position);

	for(chain = chain._list; chain; chain = chain._next)
	{
		if (chain.active_condition)
			chain.active_condition(chain);
		
		ui_position = master_position;
		UI_DryRun(chain);

		if (chain.owner.loopthrough)
			chain.owner.loopthrough(chain.owner, master_position);
	}
}


