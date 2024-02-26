// CSQC_UpdateView - Called every rendered frame on the client.  Useful for HUD drawing operations.
.void(void) draw2d;
float vid_width, vid_height;
float vid_rwidth, vid_rheight;
/*float aph;
float vph;
float ay; */
//float vy;
.vector dds;
float journal_page;
float journal_page_bestiary;
float journal_page_maps;
float journal_page_notes;

float journal_page_selected;
//float journal_button_selected;

float journal_scroll;
float journal_scroll_bestiary;

float journal_page_notes;
float journal_scroll_notes;

float journal_page_armory;
float journal_scroll_armory;

float journal_chapter;
float mouse_inbutton;
float using_cursor;

void() Hud_Init = {	//	localcmd("fs_cache 1\n");
	//cvar_set("vid_conheight", ftos(cvar("vid_conwidth")*cvar("vid_height")/cvar("vid_width")));
};
float vy_rel;
float vx_rel;
float aspectratio_fix_x;
float aspectratio_fix_y;


//float(vector position, vector size, vector rgb, float alpha, float flag) drawfill = #323;
vector(vector vctr) fixed_vector = { local vector vectr;
	vectr_x = vctr_x * vy_rel;
	vectr_y = vctr_y * vy_rel;

	vectr_y = rint(vectr_y);
	vectr_x = rint(vectr_x);

	return (vectr);
};
void(vector pos, float alph, float escala, vector coloracion, vector siz, float flag) DFill = 
{ 
	pos = fixed_vector(pos);
	siz = fixed_vector(siz);
	drawfill(pos, siz, coloracion, alph, flag);
};

void(vector pos, string pic, float alph, float escala, vector coloracion, vector siz) DImage = { local vector align, pos2;float ry, r2;
	align_x = 240;
	align_y = vid_height - 27;
	pos2 = pos + align;
	ry = (vid_rwidth / vid_rheight);
	r2 = (vid_rheight / vid_rwidth);
	siz_x = siz_x * ry;
	siz_y = siz_y * ry;
	escala = escala * r2;
	siz = siz * escala;
	drawpic(pos2, pic, siz, coloracion, alph, 0);
};
float DMselected;
float shrinepresent;
float tether;
void(vector pos, string pic, float alph, float escala, vector coloracion, vector siz) DImageButton = { local vector align, pos2;float ry, r2;
	align_x = 240;
	align_y = vid_height - 27;
	pos2 = pos + align;
	ry = (vid_rwidth / vid_rheight);
	r2 = (vid_rheight / vid_rwidth);
	siz_x = siz_x * ry;
	siz_y = siz_y * ry;
	escala = escala * r2;
	siz = siz * escala;
	drawpic(pos2, pic, siz, coloracion, alph, 0);

	vector mouse_pos, mins, max;
	float mouseindeathbutton;
	mouse_pos = getpointerpos();	//;

	mins = pos2 - ('10 10 0');
	max = pos2 + siz + ('10 10 0');

	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
	{
		if (mouse_pos_y > mins_y && mouse_pos_y < max_y)
		{
			mouseindeathbutton = 1;
		}
	}
	else
	{
		mouseindeathbutton = 0;
		DMselected = 0;
	}

	if (mouseindeathbutton == 1)
	{
		if ((mouse_pos_y >= mins_y) && (mouse_pos_y < mins_y + siz_y / 4))
		{
			if (tether >= 1) DMselected = 1;
			else DMselected = 0;
		}

		if ((mouse_pos_y >= mins_y + siz_y / 4) && (mouse_pos_y < mins_y + siz_y / 2))
		{
			if (shrinepresent >= 1) DMselected = 2;
			else DMselected = 0;
		}

		if ((mouse_pos_y >= mins_y + siz_y / 2) && (mouse_pos_y < mins_y + siz_y / 1.333))
			DMselected = 3;
		if ((mouse_pos_y >= mins_y + siz_y / 1.333) && (mouse_pos_y < mins_y + siz_y))
			DMselected = 4;

	}
};

void(vector pos, string pic, float alph, float escala, vector coloracion, vector siz, float fflag) DImage2 = { local vector align, pos2;float ry, r2;
	align_x = 240;
	align_y = vid_height - 27;
	pos2 = pos + align;
	ry = (vid_rwidth / vid_rheight);
	r2 = (vid_rheight / vid_rwidth);
	siz_x = siz_x * ry;
	siz_y = siz_y * ry;
	escala = escala * r2;
	siz = siz * escala;
	drawpic(pos2, pic, siz, coloracion, alph, fflag);
};



vector(vector vctr) nofixed_vector = { return (vctr);
};
vector(vector vctr) fixed_vector_siz = { local vector vectr;
	vectr_x = vctr_x * vx_rel;
	vectr_y = vctr_y * vx_rel;

	//drawstring(' 0 0 0', ftos (ceil ((vid_rwidth / vid_rheight) *100)), '20 20 0', '1 1 1', 1, 0);

	float modifier;
	modifier = 1;
	if (ceil((vid_rwidth / vid_rheight) *100) == (125))
		modifier = 1.777;

	if (ceil((vid_rwidth / vid_rheight) *100) == (160))
		modifier = 1.3;

	if (ceil((vid_rwidth / vid_rheight) *100) == (134))
		modifier = 1.66666;
	if (ceil((vid_rwidth / vid_rheight) *100) == (167))
		modifier = 1.5;

	vectr_y = rint(vectr_y) *modifier;
	vectr_x = rint(vectr_x) *modifier;
	return (vectr);
};
void(vector pos, string pic, float alph, vector coloracion, vector siz) DImage3 = { pos_x -= aspectratio_fix_x *(vid_rwidth / vid_rheight);

	pos = fixed_vector(pos);

	siz = fixed_vector(siz);

	drawpic(pos, pic, siz, coloracion, alph, 0);
};

void(vector pos, string pic, float alph, vector coloracion, vector siz) DImage3b = { if (pos_y < 150)
		return;
	if (pos_y >= 342)
		return;

	pos_x -= aspectratio_fix_x *(vid_rwidth / vid_rheight);

	pos = fixed_vector(pos);

	siz = fixed_vector(siz);

	drawpic(pos, pic, siz, coloracion, alph, 0);
};

float check_mouse(vector pos, float sizebuttonfactor)
{
	vector mouse_pos;
	mouse_pos = getpointerpos();	//;

	local vector mins, max;

	if (sizebuttonfactor == 0)
		mins = pos - fixed_vector('0 18 0');
	if (sizebuttonfactor == 1)
		mins = pos - fixed_vector('0 4 0');
	if (sizebuttonfactor == 2)
		mins = pos - fixed_vector('10 12 0');
	if (sizebuttonfactor == 3)
		mins = pos - fixed_vector('0 0 0');

	if (sizebuttonfactor == 0)
		max = pos + fixed_vector('60 18 0');
	if (sizebuttonfactor == 1)
		max = pos + fixed_vector('60 4 0');
	if (sizebuttonfactor == 2)
		max = pos + fixed_vector('80 56 0');
	if (sizebuttonfactor == 3)
		max = pos + fixed_vector('130 32 0');

	//max = fixed_vector (max);
	//mins = fixed_vector (mins);
	//pos = fixed_vector(pos);

	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
	{
		if (mouse_pos_y > mins_y && mouse_pos_y < max_y)
		{
			return 1;
		}
	}

	return 0;
};

void(vector pos, string pic, float alph, vector coloracion, vector siz, float index) DImage4 = { pos_x -= aspectratio_fix_x *(vid_rwidth / vid_rheight);
	if ((pos_y < 150) && (index > 300))
	{
		firstscroll = 1;
		return;
	}

	if ((pos_y >= 342) && (index > 300))
	{
		lastscroll = 1;
		return;
	}

	local vector pos2;
	pos2 = fixed_vector(pos);

	if (index < 200)
	{
		if (check_mouse(pos2, 2))
		{
			if (journal_page_selected == 0)
				journal_page_selected = index;
			coloracion = '1 1 1';
			mouse_inbutton = 1;
			alph = 1;
		}
		else
		{
			if (journal_page_selected == index)
				journal_page_selected = 0;
			alph = 0;
		}
	}
	else
	{
		if (index > 300)
		{
			if (check_mouse(pos2, 3))
			{
				if (journal_page_selected == 0)
				{
					if (index < 330)
						journal_page_selected = index - 300;
					else
						journal_page_selected = index - 330;
				}

				coloracion = '1 1 1';
				mouse_inbutton = 1;
				alph = 1;
			}
			else
			{
				if (index < 330)
				{
					if (journal_page_selected == index - 300)
						journal_page_selected = 0;
				}
				else
				{
					if (journal_page_selected == index - 330)
						journal_page_selected = 0;
				}

				alph = 0;
			}
		}
		else
		{
			if (check_mouse(pos2, 2))
			{
				if (journal_page_selected == 0)
					journal_page_selected = index;
				coloracion = '1 1 1';
				mouse_inbutton = 2;
				alph = 1;
			}
			else
			{
				if (journal_page_selected == index)
					journal_page_selected = 0;
				alph = 0;
			}
		}
	}

	if (journal_chapter == 1)
	{
		if ((journal_page_maps >= 1) && (journal_page_maps <= 5))
		{
			float journalpagefloat = journal_page_maps + 300;
			if (journalpagefloat == index)
			{
				alph = 1;
				coloracion = '1 1 1';

			}
		}
	}

	if (journal_chapter == 2)
	{
		//	if(journal_page_armory== 1)
		//		drawstring('0 0 0', strcat (ftos(journal_page_armory), "   ",ftos(journal_chapter)), '12 12 0' ,'1 1 1', 1, 0);


		if ((journal_page_armory >= 1) && (journal_page_armory <= 9))
		{
			journalpagefloat = journal_page_armory + 330;
			if (journalpagefloat == index)
			{
				alph = 1;
				coloracion = '1 1 1';
			}
		}
	}

	if (journal_chapter == 3)
	{
		//if(journal_page_bestiary== 1)
		//drawstring('0 0 0', strcat (ftos(journal_page_bestiary), "   ",ftos(index)), '12 12 0' ,'1 1 1', 1, 0);
		if ((journal_page_bestiary >= 1) && (journal_page_bestiary <= 10))
		{
			journalpagefloat = journal_page_bestiary + 300;
			if (journalpagefloat == index)
			{
				alph = 1;
				coloracion = '1 1 1';
			}
		}
	}

	siz = fixed_vector(siz);
	drawpic(pos2, pic, siz, coloracion, alph, 0);
};

void(vector pos, string str, float alph, float escala, vector coloracion, vector siz) DString = { local vector align, pos2;float ry, r2;
	align_x = 240;
	align_y = vid_height - 27;
	pos2 = pos + align;
	ry = (vid_rwidth / vid_rheight);
	r2 = (vid_rheight / vid_rwidth);
	siz_x = siz_x * ry;
	siz_y = siz_y * ry;
	escala = escala * r2;
	siz = siz * escala;
	siz_z = 0;


//	drawstring(pos2+'1 -1 0', str, siz, '-0.25 -0.25 -0.25', alph, 0);
//	drawstring(pos2+'-1 1 0', str, siz, '-0.25 -0.25 -0.25', alph, 0);
	drawfont = FONT_USER1;

	drawstring(pos2-'-0.5 0 0', str, siz, '-0.1922 -0.1922 -0.1922', alph, 0);
	drawstring(pos2-'-0.5 -0.5 0', str, siz, '-0.1922 -0.1922 -0.1922', alph, 0);
	drawstring(pos2-'0 -0.5 0', str, siz, '-0.1922 -0.1922 -0.1922', alph, 0);

	drawstring(pos2, str, siz, coloracion, alph, 0);
};

void(vector pos, string str, float alph, float escala, vector coloracion, vector siz) DstringJournal = { pos_x -= aspectratio_fix_x *(vid_rwidth / vid_rheight);

	drawfont = FONT_USER7;
	pos = fixed_vector(pos);
	siz = fixed_vector_siz(siz);
	//drawstring(pos - '0.5 0.5 0.5', str, siz, coloracion, alph * 0.5, 0);
	drawstring(pos, str, siz, coloracion, alph, 0);

};

void(vector pos, string str, float alph, float escala, vector coloracion, vector siz, float label) DStringC = { pos_x -= aspectratio_fix_x *(vid_rwidth / vid_rheight);

	drawfont = FONT_USER7;
	pos = fixed_vector(pos);
	siz = fixed_vector_siz(siz);
	if (journal_page == label)
		coloracion = '1 1 1';

	drawstring(pos, str, siz, coloracion, alph, 0);
};

void(vector pos, string str, float alph, float escala, vector coloracion, vector siz, float index) DStringB = { pos_x -= aspectratio_fix_x *(vid_rwidth / vid_rheight);
	drawfont = FONT_USER7;

	if ((pos_y < 150) && (index < 100))
	{
		firstscroll = 1;
		return;
	}

	if ((pos_y >= 342) && (index < 100))
	{
		lastscroll = 1;
		return;
	}
	if ((pos_y < 150) && (index > 500))
	{
		firstscroll = 1;
		return;
	}

	if ((pos_y >= 342) && (index > 500))
	{
		lastscroll = 1;
		return;
	}

	pos = fixed_vector(pos);
	siz = fixed_vector_siz(siz);

	if (index < 200)
	{
		if (check_mouse(pos, 0))
		{
			if (journal_page_selected == 0)
				journal_page_selected = index;
			coloracion = '1 1 0';
			mouse_inbutton = 1;
		}
		else
		{
			if (journal_page_selected == index)
				journal_page_selected = 0;
		}
	}
	else
	{	
		if (index > 500) // notes pages
		{
			if (check_mouse(pos, 3))
			{
				if (journal_page_selected == 0)
				{
					journal_page_selected = index - 500;
				}

				coloracion = '1 1 1';
				mouse_inbutton = 1;
				alph = 1;
			}
			else
			{
				{
					if (journal_page_selected == index - 500)
						journal_page_selected = 0;
				}

				alph = 0;
			}
		}
		else
		{
			if (check_mouse(pos, 1))
			{
				if (journal_page_selected == 0)
					journal_page_selected = index;
				coloracion = '1 1 0';
				mouse_inbutton = 2;
			}
			else
			{
				if (journal_page_selected == index)
					journal_page_selected = 0;
			}
		}
	}

	if (((journal_chapter == 1) && (journal_page_maps == index)) || ((journal_chapter == 2) && (journal_page == index)) || ((journal_chapter == 3) && (journal_page_bestiary == index))|| ((journal_chapter == 4) && (journal_page_notes == index)))
	{
		drawstring(pos, str, siz, '0.5 0.5 1', alph, 1);
	}
	else
		drawstring(pos, str, siz, coloracion, alph, 0);
};

void(string pic, vector pos1, vector pos2, vector pos3, vector pos4, float alph, vector coloracion, vector sizeimg, vector pol_offset) DPolygon = { local vector aliggn;
	DImage('-150 -25 0', "gfx/hud/artifact_ring", 0, 0, '1 1 1', '50 50 0');
	//aliggn_x = (vid_width - (vid_width /2))/2;
	aliggn_x = 240;
	aliggn_y = vid_height - 27;
	pos1 = pos1 + aliggn;
	pos2 = pos2 + aliggn;
	pos3 = pos3 + aliggn;
	pos4 = pos4 + aliggn;


	vector img1, img2, img3, img4;
	img1 = pol_offset;
	img2_x = sizeimg_x;
	img2 +=pol_offset;

	img3_x = sizeimg_x;
	img3_y = sizeimg_y;
	img3 +=pol_offset;

	img4_y = sizeimg_y;
	img4 +=pol_offset;

	/*pos1=  fixed_vector (pos1);
	pos2=  fixed_vector (pos2);
	pos3=  fixed_vector (pos3);
	pos4=  fixed_vector (pos4);

	img1=  fixed_vector (img1);
	img2=  fixed_vector (img2);
	img3=  fixed_vector (img3);
	img4=  fixed_vector (img4);*/

	R_BeginPolygon(pic, 0);
	R_PolygonVertex(pos1, img1, coloracion, alph);
	R_PolygonVertex(pos2, img2, coloracion, alph);
	R_PolygonVertex(pos3, img3, coloracion, alph);
	R_PolygonVertex(pos4, img4, coloracion, alph);
	R_EndPolygon();
};


void( vector pos, string pic, vector imgsize, vector slotsize, float slotnumber, vector vcolor) DrawSheet = 
{
	//void(string pic, vector pos1, vector pos2, vector pos3, vector pos4, float alph, vector coloracion, vector sizeimg) DPolygon

	
	imgsize  = ( fixed_vector(imgsize));
	float slotammount_x = 10;
	float slotammount_y = 10;

	float totalslots = 100;
	slotsize_x  = imgsize_x / 10;
	slotsize_y  = imgsize_y / 10;


	vector coordinates;
	coordinates_x = slotnumber % slotammount_x;
	coordinates_y =(slotnumber - coordinates_x) / slotammount_x;

	if(coordinates_y <0)
		coordinates_y = 0;


	vector pos1 = pos; 
	vector pos2 = pos; 
	pos2_x += slotsize_x; 
	vector pos3 = pos; 
	pos3_x += slotsize_x; 
	pos3_y += slotsize_y; 
	vector pos4 = pos; 
	pos4_y += slotsize_y; 


	vector img_coor;
	img_coor_x = 1 / slotammount_x;
	img_coor_y = 1 / slotammount_y;

	vector pol_offset;
	pol_offset_x =  img_coor_x * coordinates_x;
	pol_offset_y = coordinates_y * img_coor_y;


	DPolygon(pic,pos1,pos2,pos3,pos4,1 ,vcolor,img_coor, pol_offset);
	//DString('-150 -130 0', vtos(coordinates), 1, 2, '1 1 3', '10 10 0');
};





////////////////end
