// Reki: Added this .h file since journal.qc is added after main.qc in progs.src and I wanted to avoid copy pasta
#pragma once
enum JOURNAL_ETYPE:float {
	TEXT,
	PIC,
};

#define JOURNAL_COLOR_NOTE 			'-1 -1 -1'
#define JOURNAL_COLOR_HIGHLIGHT 	'0.5 0.5 1'
#define JOURNAL_COLOR_SELECTED 		'1 1 1'
#define JOURNAL_TEXTALPHA 			0.8

#ifdef CSQC
#include "uielement.h" 	// this is a bit yuck, but oh well.
						// we need it to init journal_ui

class journalentry_c; // prototype
class journalelement_c
{
	journalentry_c owner;
	float	type;
	vector	pos;
	
	journalelement_c	_next;
};

class journaltext_c : journalelement_c
{
	float	font;
	vector	fontsize;
	vector	fontcolor;
	string	text;
	
	void() journaltext_c;
};

class journalpic_c : journalelement_c
{
	vector	size;
	string	image;
	
	void() journalpic_c;
};

class journalentry_c
{
	float				index;
	string				title;
	string				titleimg;
	string				msgimg;
	journalelement_c 	_elements;
	journalentry_c		_next;
	
	void() journalentry_c;
	void() destructor;
};

journalentry_c journal_entries;
journalentry_c journal_currentnote;

journalentry_c Journal_FindEntry(float number);
journalentry_c Journal_ParseEntry(string name);
void Journal_RenderNote(journalentry_c note, vector drawoffset, vector drawscale);
void Journal_Init(void);
void Journal_Sound(void);
void Journal_ScrollToCurrentMap(void);

uipicture_c journal_ui;
uilist_c journal_world_list;
uielement_c journal_world_currentmap;
uielement_c journal_world_scrollto;

float showjournal;
float journal_firstopen;
float jarmory_selected;
float jbeast_selected;
float jnote_selected;
float jitems_armory;
float jitems_bestiary;
float jitems_visitedmaps;
float jitems_relics;
float jitems_notes;
float jitemsb_notes;

////////////////
//  Journal Note
////////////////
class uijournalpage_c : uielement_c
{
	journalentry_c entry;
	vector entry_offset;

	virtual void() render {
		if (!entry)
			return;

		Journal_RenderNote(entry, ui_position + [entry_offset[0] * ui_scale[0], entry_offset[1] * ui_scale[1]], ui_scale);
	};
};
////////////////
#endif