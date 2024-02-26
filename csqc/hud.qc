#include "localized_assets.h"

/////// PULSES
float phicon;
float arphicon;
float drphicon;

///////

/////// DAMAGE BARS
float dml;	// damage bar left
float dmr;	// damage bar right
float dmu;	// damage bar up
float dmd;	// damage bar down
///////

float mm;
string shd;
string shd2;
float bbar;
float rndm;
float shrinepresent;
float theter_alreadychecked;

void() write_tether = { read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tetherclient.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen(campaignloc, FILE_WRITE);	//open what file to use in write mode
	writethis = ftos(0);	//prepare the next thing to write
	fputs(writeparms, writethis);	//line 1
	fputs(writeparms, "\n");	//and again
	fclose(writeparms);
	if (profilename)
		strunzone(profilename);
};


 
void() check_tether = { read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tether.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	tether = stof(readtext);
	fclose(readparms);
	//float tetherp;
	//tetherp = floor(getstatf(STAT_TETHER));
	//if (tetherp <= 0)
	//	tether = 0;
	if (profilename)
		strunzone(profilename);
};
float shrine_user;
void() check_shrine_user = { read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/shrine_user.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	shrine_user = stof(readtext);
	fclose(readparms);
	if (profilename)
		strunzone(profilename);
};
float mm2;
void() Death_Menu = { vector omp;

	if (mm2 == 0)
	{
		setcursormode(1);
		mm2 = 1;
	}

	omp = getpointerpos();	//;
	vector relomp;
	relomp_y = omp_y;

	drawfill('0 0 0', vid_width *'1 0 0' + vid_height *'0 1 0', '0 0 0', 0.65 *dmenualpha, 0);

	local vector dmsgpos2;
	dmsgpos2_x = dmsgpos_x + ((vid_width - 960) / 2);
	dmsgpos2_y = dmsgpos_y * vy_rel;

	if (!DMselected)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuA.tga", dmenualpha, 1, '1 0 0', '256 144 0');
	if (DMselected == 1)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuA.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	if (DMselected == 2)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuB.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	if (DMselected == 3)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuC.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	if (DMselected == 4)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuD.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	//drawstring(relomp, "X", '8 8 0', '3 3 3', 1);     	// Draw the "cursor"
	vector ompr;
	ompr = getpointerpos();	//;
	drawpic(ompr, "gfx/cursor.tga", '20 20 0', '1 1 1', 1, 0);
};

float crosshairalpha;
float crosshairalpha2;
float crosshair_scale;
void() Crosshair = {
	vector pos, chcolor;
	float wch, sca, alphd;
	string image;
	crosshair_scale = cvar("saved8");

	wch = floor(getstatf(STAT_CROSSHAIR));

	if (crosshairalpha > 0)
	{
		image = "gfx/hud/crosshair1_use.tga";
		sca = crosshairalpha;
	}

	if (crosshairalpha2 > 0)
	{
		image = "gfx/hud/crosshair1_active.tga";
		sca = crosshairalpha2;
	}

	if ((crosshairalpha2 <= 0) && (crosshairalpha <= 0))
		sca = 0;

	alphd = 1 - sca;

	chcolor = '1 1 1';

	pos_x = (vid_width / 2) - (16 * vx_rel * crosshair_scale);
	pos_y = (vid_height / 2) - (16 * vx_rel * crosshair_scale);

	drawpic(pos, "gfx/hud/crosshair1.tga", '32 32 0' * vx_rel * crosshair_scale, chcolor, alphd, 0);


	if ((crosshairalpha2 > 0) || (crosshairalpha > 0))
		drawpic(pos, image, '32 32 0' * vx_rel* crosshair_scale, chcolor, sca, 0);
};


vector dammo_pos;


float pulseammo_icon;
float ammphicon;
void() pulse_ammo = 
{
	ammphicon = 0;
	pulseammo_icon = 1;
};


void() Ammo_Hud = { float c_w, c_a, digits, cws;
	string c_ammo;
	c_w = floor(getstatf(STAT_LASTWEAPON));
	if (c_w == IT_REVOLVER)
		c_a = getstatf(STAT_AMMO_REVOLVER);
	else if (c_w == IT_RETCHER)
		c_a = getstatf(STAT_AMMO_BOMBS);
	else if (c_w == IT_CANNON)
		c_a = getstatf(STAT_AMMO_CANNON);
	else if (c_w == IT_SPITTER)
		c_a = getstatf(STAT_AMMO_FLAMETHROWER);
	else if (c_w == IT_SHOTGUN)
		c_a = getstatf(STAT_AMMO_SHOTGUN);
	else if (c_w == IT_LANCE)
		c_a = getstatf(STAT_AMMO_LANCE);
	else if (c_w == IT_CRYSTAL)
		c_a = getstatf(STAT_AMMO_CRYSTAL);
	else if (c_w == IT_MACE)
		c_a = getstatf(STAT_AMMO_MACE);

	c_ammo = ftos(c_a);
	if (c_a < 0)
		c_a = 0;

	if (c_a <= 0)
		digits = 0;
	if (c_a > 0)
		digits = 1;
	if (c_a >= 10)
		digits = 2;
	if (c_a >= 100)
		digits = 3;
	if (c_a >= 1000)
		digits = 4;


	cws = getstatf(STAT_VWEAPONSTATE);

	dammo_pos_y = ammo_pos_y;
	dammo_pos_z = ammo_pos_z;

	string picofnammo;
	float fphicon;
	picofnammo = "gfx/hud/ammo";
	picofnammo = "gfx/hud/lances_sheet.tga";

	if (c_w == IT_SHOTGUN)
		picofnammo = "gfx/hud/shells_sheet.tga";

	if (c_w == IT_REVOLVER)
		picofnammo = "gfx/hud/slugs_sheet.tga";

	if (c_w == IT_SPITTER)
		picofnammo = "gfx/hud/fangs_sheet.tga";

	if (c_w == IT_RETCHER)
		picofnammo = "gfx/hud/cysts_sheet.tga";

	if (c_w == IT_CANNON)
		picofnammo = "gfx/hud/ore_sheet.tga";

	if (c_w == IT_LANCE)
		picofnammo = "gfx/hud/lances_sheet.tga";

	if (c_w == IT_MACE)
		picofnammo = "gfx/hud/mace_sheet.tga";

	if (c_w == IT_CRYSTAL)
		picofnammo = "gfx/hud/crystal_sheet.tga";

	float pulse_y ;

	float fclframetime = gettime(2);
	if(!fclframetime)
		fclframetime = 0.002;
	
	float vfpsmultiplier;
	vfpsmultiplier = (1 + ((300 - (1 / fclframetime)) / 220));
	float vfps = 60 + 30 * vfpsmultiplier;
	if (1 / fclframetime > 100)
		vfps = 60;

	float v_sfps = vfps / ((rint(1 / (fclframetime + 0.1))));

	float rammo_pos_x;
	rammo_pos_x = ammo_pos_x - (960 - vid_width);

	if (cws == 1)
	{
		dammo_pos_x -= (fclframetime / 1) *(7500 / v_sfps);
		if (dammo_pos_x < rammo_pos_x)
			dammo_pos_x = rammo_pos_x;
	}
	else if (cws == 2)
	{
		dammo_pos_x += (fclframetime) *(10000 / v_sfps);	//(frametime) *200;

		if (dammo_pos_x >= rammo_pos_x + 180)
			dammo_pos_x = rammo_pos_x + 180;	//(frametime) *200;

	}
	else if (cws == 3)
	{
		dammo_pos_x = rammo_pos_x + 180;	//(frametime) *200;
	}
	else
		dammo_pos_x = rammo_pos_x;


	if ((pulseammo_icon == 1) &&  (!cws ))
	{
		fphicon = floor(ammphicon);
		if (fphicon <= 1) pulse_y = 10;
		if (fphicon == 2) pulse_y = 20;
		if (fphicon == 3)pulse_y = 30;
		if (fphicon == 4) pulse_y =40;
		if (fphicon == 5) pulse_y = 50;
		if (fphicon == 6) pulse_y = 60;
		if (fphicon == 7) pulse_y = 70;
		if (fphicon == 8) pulse_y = 80;
		if (fphicon == 9) pulse_y = 90;
		if (fphicon >= 10)
		{
			pulseammo_icon = 0;
			ammphicon = 0;
		}
	}





	float fdigit3  = (c_a % 10) ;
	float fdigit2 = (((c_a - fdigit3) * 0.1) %10); 

	
	float fdigit1 = (c_a - (c_a % 100)) / 100;
	
	
	fdigit3 += pulse_y; 
	fdigit2 += pulse_y;
	fdigit1 += pulse_y;


	if ((cws != 3) &&(c_w) && (c_w != IT_MELEE))
	{
		if (digits == 0)
		{
			DrawSheet(dammo_pos + ammo_pos2 + ammo_pos2, picofnammo,'280 360 0', '28 36 0',fdigit3,'1 1 1');
		}
		if (digits == 1)
		{
			DrawSheet(dammo_pos + ammo_pos2 + ammo_pos2, picofnammo,'280 360 0', '28 36 0',fdigit3,'1 1 1');
		}
		else if (digits == 2)
		{
			DrawSheet(dammo_pos + ammo_pos2, picofnammo,'280 360 0', '28 36 0',fdigit3,'1 1 1');
			DrawSheet(dammo_pos + ammo_pos2 + ammo_pos2, picofnammo,'280 360 0', '28 36 0',fdigit2,'1 1 1');
		}
		else if (digits == 3)
		{
			DrawSheet(dammo_pos, picofnammo,'280 360 0', '28 36 0',fdigit3,'1 1 1');
			DrawSheet(dammo_pos + ammo_pos2, picofnammo,'280 360 0', '28 36 0',fdigit2,'1 1 1');
			DrawSheet(dammo_pos + ammo_pos2 + ammo_pos2, picofnammo,'280 360 0', '28 36 0',fdigit1,'1 1 1');
		}
	}

	/*
	float timef;
	timef = getstatf (STAT_TIMEFLY) *-1;
	string timefl;
	timefl = ftos (timef); 
	if (timef > 0)
		DString (ammo_pos + ammo_pos2 + ammo_pos2 + ammo_pos2 +  ammo_pos2, timefl, 1, ammo_scale, '1 3 2', '18 18 0');
	float timels;
	timels = getstatf (STAT_TIMELS) *-1;
	string stimels;
	stimels = ftos (timels); 
	if (timels > 0)
		DString (ammo_pos + ammo_pos2+ ammo_pos2+ ammo_pos2 + ammo_pos2 + ammo_pos2 + ammo_pos2 + ammo_pos2, stimels, 1, ammo_scale, '7 1 1', '18 18 0');
	*/
};
float blalphaflag;
float blalpha;
float stalphaflag;
float stalpha;
float bbar;
float old_artifact_count;



float pulseammo_icon;
float pulsedarmor_icon;

float pulsearmor_icon;

void() pulse_armor = 
{
	arphicon = 0;
	pulsearmor_icon = 1;
};

void() pulse_darmor = 
{
	drphicon = 0;
	pulsedarmor_icon = 1;
};


void() Hud_Armor =
{
	local float digits, fphicona, fphicond;
	float c_armr = floor(getstatf(STAT_RARM));
	float c_drmr = floor(getstatf(STAT_DARM));
	if (c_armr > 0)
	{
		float pulse_y ;

		if (pulsearmor_icon == 1)
		{
			fphicona = floor(arphicon);
			if (fphicona <= 1) pulse_y = 10;
			if (fphicona == 2) pulse_y = 20;
			if (fphicona == 3)pulse_y = 30;
			if (fphicona == 4) pulse_y =40;
			if (fphicona == 5) pulse_y = 50;
			if (fphicona == 6) pulse_y = 60;
			if (fphicona == 7) pulse_y = 70;
			if (fphicona == 8) pulse_y = 80;
			if (fphicona == 9) pulse_y = 90;
			if (fphicona >= 10)
			{
				pulsearmor_icon = 0;
				arphicon = 0;
			}
		}

		vector armr_realpos;
		armr_realpos = armr_pos;

		if (c_armr >= 100)
			c_armr = 100;
		if (c_armr >= 1)
			digits = 1;
		if (c_armr >= 10)
			digits = 2;
		if (c_armr >= 100)
			digits = 3;

		float fdigit3  = (c_armr % 10) ;
		float fdigit2 = (((c_armr - fdigit3) * 0.1) %10); 
		float fdigit1 = 1;
			
			
		fdigit3 += pulse_y; 
		fdigit2 += pulse_y;
		fdigit1 += pulse_y;


		if (digits == 1)
		{
			DrawSheet(armr_realpos + armr_pos2 + armr_pos2, "gfx/hud/armor_sheet.tga",'140 180 0', '14 18 0',fdigit3,'1 1 1');
		}
		else if (digits == 2)
		{
			DrawSheet(armr_realpos + armr_pos2, "gfx/hud/armor_sheet.tga",'140 180 0', '14 18 0',fdigit3,'1 1 1');
			DrawSheet(armr_realpos + armr_pos2 + armr_pos2, "gfx/hud/armor_sheet.tga",'140 180 0', '14 18 0',fdigit2,'1 1 1');
		}
		else if (digits == 3)
		{
			DrawSheet(armr_realpos, "gfx/hud/armor_sheet.tga",'140 180 0', '14 18 0',fdigit3,'1 1 1');
			DrawSheet(armr_realpos + armr_pos2, "gfx/hud/armor_sheet.tga",'140 180 0', '14 18 0',fdigit2,'1 1 1');
			DrawSheet(armr_realpos + armr_pos2 + armr_pos2, "gfx/hud/armor_sheet.tga",'140 180 0', '14 18 0',fdigit1,'1 1 1');
		}
	}

	if (c_drmr > 0)
	{
		if (pulsedarmor_icon == 1)
		{
			fphicond = floor(drphicon);
			if (fphicond <= 1) pulse_y = 10;
			if (fphicond == 2) pulse_y = 20;
			if (fphicond == 3)pulse_y = 30;
			if (fphicond == 4) pulse_y =40;
			if (fphicond == 5) pulse_y = 50;
			if (fphicond == 6) pulse_y = 60;
			if (fphicond == 7) pulse_y = 70;
			if (fphicond == 8) pulse_y = 80;
			if (fphicond == 9) pulse_y = 90;
			if (fphicond >= 10)
			{
				pulsedarmor_icon = 0;
				drphicon = 0;
			}
		}

		vector drmr_realpos = drmr_pos;

		if (c_drmr >= 1)
			digits = 1;
		if (c_drmr >= 10)
			digits = 2;
		if (c_drmr >= 100)
			digits = 3;

		fdigit3  = (c_drmr % 10) ;
		fdigit2 = (((c_drmr - fdigit3) * 0.1) %10); 
		fdigit1 = 1;
			
			
		fdigit3 += pulse_y; 
		fdigit2 += pulse_y;
		fdigit1 += pulse_y;


		if (digits == 1)
		{
			DrawSheet(drmr_realpos + armr_pos2 + armr_pos2, "gfx/hud/darmor_sheet.tga",'140 180 0', '14 18 0',fdigit3,'1 1 1');
		}
		else if (digits == 2)
		{
			DrawSheet(drmr_realpos + armr_pos2, "gfx/hud/darmor_sheet.tga",'140 180 0', '14 18 0',fdigit3,'1 1 1');
			DrawSheet(drmr_realpos + armr_pos2 + armr_pos2, "gfx/hud/darmor_sheet.tga",'140 180 0', '14 18 0',fdigit2,'1 1 1');
		}
		else if (digits == 3)
		{
			DrawSheet(drmr_realpos, "gfx/hud/darmor_sheet.tga",'140 180 0', '14 18 0',fdigit3,'1 1 1');
			DrawSheet(drmr_realpos + armr_pos2, "gfx/hud/darmor_sheet.tga",'140 180 0', '14 18 0',fdigit2,'1 1 1');
			DrawSheet(drmr_realpos + armr_pos2 + armr_pos2, "gfx/hud/darmor_sheet.tga",'140 180 0', '14 18 0',fdigit1,'1 1 1');
		}
	}
 };

float pulsehealth_low;
float pulsehealth_low_int;

float nexartifacticon_int;


float appparatus_flash;
float appparatus_using;
float pulsehealth_icon;
void() pulse_health = 
{
	phicon = 0;
	pulsehealth_icon = 1;
};

float ui_oldweaponselected;
float ui_ammoslide;
void HUD_InitializeUnderUI(void)
{
	float(uielement_c this) condtional = { if (getstatf(STAT_ARTIFACTTIME) && (getstatf(STAT_RADIALACTIVE) == 2)) {appparatus_using = 1; return TRUE; } appparatus_using = 0; return FALSE; };
	void(uifill_c this, __inout vector color_to_render, __inout float alpha_to_render) apparatus_prerender = { alpha_to_render *= appparatus_flash; };
	uifill_c apparatus_fill = spawn(uifill_c, flags: UIFLAG::STRETCH, color: '0 0 0.25', alpha: 0.25);
		apparatus_fill.active_condition = condtional;
		apparatus_fill.prerender = apparatus_prerender;
	
	uipicture_c apparatus_mask = spawn(uipicture_c, owner: ui_hud, image: "models/artifacts/active/drowners_apparatus_active.tga",
		justify: '0.5 1', anchor: '0.5 1', size: '960 540');
		apparatus_mask.active_condition = condtional;
	apparatus_mask.size = draw_getimagesize(apparatus_mask.image);
	
	// healthhaze fill
	float(uielement_c this) condtional = { if (getstatf(STAT_HEALTHHAZE) > 0) return TRUE; return FALSE; };
	void(uifill_c this, __inout vector color_to_render, __inout float alpha_to_render) healthhaze_prerender = { float a = getstatf(STAT_HEALTHHAZE); if (floor(getstatf(STAT_THWOFG))) a = 0; alpha_to_render *= a; };
	uifill_c healthhaze_fill = spawn(uifill_c, flags: UIFLAG::STRETCH, color: '0.7 -1 -1', alpha: 0.5);
		healthhaze_fill.active_condition = condtional;
		healthhaze_fill.prerender = healthhaze_prerender;
}

void HUD_InitializeUI(void)
{
	// Crosshair
	void(uielement_c this, __inout vector position) xhair_preloop = {
		uipicture_c base = (uipicture_c)this.partner;
		uipicture_c interact = (uipicture_c)this.partner2;
		uipicture_c enemy = (uipicture_c)this.partner3;

		float crosshair_show = floor(getstatf(STAT_CROSSHAIR));
		float crosshair_scale = cvar("saved8");
		this.size = '32 32' * crosshair_scale;

		base.alpha = 1;
		if (ui_renderframe)
		{
			if (crosshair_show & 1)
				enemy.alpha = min(1, enemy.alpha + (clframetime * 10));
			else
				enemy.alpha = max(0, enemy.alpha - (clframetime * 5));

			if (crosshair_show & 2)
				interact.alpha = min(1, interact.alpha + (clframetime * 10));
			else
				interact.alpha = max(0, interact.alpha - (clframetime * 5));
		}
	}

	float(uielement_c this) xhair_active = {
		float hidehud;
		hidehud = getstatf(STAT_THWOFG);
		if (hidehud > 0)
			return FALSE;
		if (cvar("saved1"))
			return FALSE;
		return TRUE;
	}

	uielement_c xhair = spawn(uielement_c, anchor: '0.5 0.5', justify: '0.5 0.5');
		xhair.preloop = xhair_preloop;
		xhair.active_condition = xhair_active;
	
	xhair.partner = spawn(uipicture_c, owner: xhair, flags: UIFLAG::STRETCH, image: "gfx/hud/crosshair1.tga");
	xhair.partner2 = spawn(uipicture_c, owner: xhair, flags: UIFLAG::STRETCH, image: "gfx/hud/crosshair1_active.tga");
	xhair.partner3 = spawn(uipicture_c, owner: xhair, flags: UIFLAG::STRETCH, image: "gfx/hud/crosshair1_use.tga");

	// Health Numbers
	void(uielement_c this, __inout vector position) hp_preloop = {
		float health = getstati(STAT_HEALTH);
		if (pulsehealth_icon == 1)
		{
			if (floor(phicon) >= 10)
			{
				pulsehealth_icon = 0;
			}
		}

		// low health blink
		float pulseicon = phicon;
		vector colorhealth = '1 1 1';
		if (health < 30)
		{
			// round phase to nearest 1/5 so we get a nice chunky low fps look
			float phase = pulsehealth_low;//round(pulsehealth_low * 0.2) / 0.2;
			if (health <= 10)
				colorhealth_x = 0.6 + 0.07 * phase;
			else if (health <= 20)
				colorhealth_x = 0.7 + 0.05 * phase;
			else
				colorhealth_x = 0.8 + 0.02 * phase;
			
			// if we're overbright, clamp it but use the end of the spritesheet instead
			if (colorhealth_x > 1.0) 
			{
				if (!pulseicon || pulseicon > 8)
					pulseicon = bound(0, 10 - ((colorhealth_x - 1.0) * 10), 9);
				colorhealth_x = 1.0;
			}
			
			colorhealth_y = colorhealth_z = colorhealth_x;
		}
		this.partner.color = colorhealth;
		this.partner2.color = colorhealth;
		this.partner3.color = colorhealth;
		//

		((uispritesheet_c)this.partner).sprite[1] = pulseicon;
		((uispritesheet_c)this.partner2).sprite[1] = pulseicon;
		((uispritesheet_c)this.partner3).sprite[1] = pulseicon;

		this.partner.flags &= ~UIFLAG::HIDE;
		this.partner2.flags &= ~UIFLAG::HIDE;
		this.partner3.flags &= ~UIFLAG::HIDE;
		if (health < 100)
		{
			this.partner3.flags |= UIFLAG::HIDE;
			if (health < 10)
			{
				this.partner2.flags |= UIFLAG::HIDE;
				if (health <= 0)
				{
					this.partner.flags |= UIFLAG::HIDE;
				}
				else
				{
					((uispritesheet_c)this.partner).sprite[0] = health % 10;
				}
			}
			else
			{
				((uispritesheet_c)this.partner).sprite[0] = floor((health % 100) / 10);
				((uispritesheet_c)this.partner2).sprite[0] = health % 10;
			}
		}
		else
		{
			((uispritesheet_c)this.partner).sprite[0] = floor(health / 100);
			((uispritesheet_c)this.partner2).sprite[0] = floor((health % 100) / 10);
			((uispritesheet_c)this.partner3).sprite[0] = health % 10;
		}
	}
	uielement_c hpbox = spawn(uielement_c, owner: ui_hud,  origin: '24 -18', size: '84 36', anchor: '0 1', justify: '0 1');
		hpbox.preloop = hp_preloop;
	hpbox.partner = spawn(uispritesheet_c, owner: hpbox, origin: '0 0', size: '28 36', image: "gfx/hud/health_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	hpbox.partner2 = spawn(uispritesheet_c, owner: hpbox, origin: '30 0', size: '28 36', image: "gfx/hud/health_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	hpbox.partner3 = spawn(uispritesheet_c, owner: hpbox, origin: '60 0', size: '28 36', image: "gfx/hud/health_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	//
	// Armor Numbers
	void(uielement_c this, __inout vector position) ap_preloop = {
		float armorv = getstatf(STAT_RARM);
		if (pulsearmor_icon == 1)
		{
			if (floor(arphicon) >= 10)
			{
				pulsearmor_icon = 0;
			}
		}

		((uispritesheet_c)this.partner).sprite[1] = arphicon;
		((uispritesheet_c)this.partner2).sprite[1] = arphicon; 
		((uispritesheet_c)this.partner3).sprite[1] = arphicon;

		this.partner.flags &= ~UIFLAG::HIDE;
		this.partner2.flags &= ~UIFLAG::HIDE;
		this.partner3.flags &= ~UIFLAG::HIDE;
		if (armorv < 100)
		{
			this.partner3.flags |= UIFLAG::HIDE;
			if (armorv < 10)
			{
				this.partner2.flags |= UIFLAG::HIDE;
				if (armorv <= 0)
				{
					this.partner.flags |= UIFLAG::HIDE;
				}
				else
				{
					((uispritesheet_c)this.partner).sprite[0] = armorv % 10;
				}
			}
			else
			{
				((uispritesheet_c)this.partner).sprite[0] = floor((armorv % 100) / 10);
				((uispritesheet_c)this.partner2).sprite[0] = armorv % 10;
			}
		}
		else
		{
			((uispritesheet_c)this.partner).sprite[0] = floor(armorv / 100);
			((uispritesheet_c)this.partner2).sprite[0] = floor((armorv % 100) / 10);
			((uispritesheet_c)this.partner3).sprite[0] = armorv % 10;
		}
	}
	uielement_c apbox = spawn(uielement_c, owner: ui_hud, origin: '120 -18', size: '48 18', anchor: '0 1', justify: '0 1');
	apbox.preloop = ap_preloop;
	apbox.partner = spawn(uispritesheet_c, owner: apbox, origin: '0 0', size: '14 18', image: "gfx/hud/armor_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	apbox.partner2 = spawn(uispritesheet_c, owner: apbox, origin: '14 0', size: '14 18', image: "gfx/hud/armor_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	apbox.partner3 = spawn(uispritesheet_c, owner: apbox, origin: '28 0', size: '14 18', image: "gfx/hud/armor_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	//
	// Dark Armor Numbers
	void(uielement_c this, __inout vector position) dap_preloop = {
		float armorv = getstatf(STAT_DARM);
		if (pulsedarmor_icon == 1)
		{
			if (floor(drphicon) >= 10)
			{
				pulsedarmor_icon = 0;
			}
		}

		((uispritesheet_c)this.partner).sprite[1] = drphicon;
		((uispritesheet_c)this.partner2).sprite[1] = drphicon; 
		((uispritesheet_c)this.partner3).sprite[1] = drphicon;

		this.partner.flags &= ~UIFLAG::HIDE;
		this.partner2.flags &= ~UIFLAG::HIDE;
		this.partner3.flags &= ~UIFLAG::HIDE;
		if (armorv < 100)
		{
			this.partner3.flags |= UIFLAG::HIDE;
			if (armorv < 10)
			{
				this.partner2.flags |= UIFLAG::HIDE;
				if (armorv <= 0)
				{
					this.partner.flags |= UIFLAG::HIDE;
				}
				else
				{
					((uispritesheet_c)this.partner).sprite[0] = armorv % 10;
				}
			}
			else
			{
				((uispritesheet_c)this.partner).sprite[0] = floor((armorv % 100) / 10);
				((uispritesheet_c)this.partner2).sprite[0] = armorv % 10;
			}
		}
		else
		{
			((uispritesheet_c)this.partner).sprite[0] = floor(armorv / 100);
			((uispritesheet_c)this.partner2).sprite[0] = floor((armorv % 100) / 10);
			((uispritesheet_c)this.partner3).sprite[0] = armorv % 10;
		}
	}
	uielement_c apbox = spawn(uielement_c, owner: ui_hud, origin: '120 -36', size: '48 18', anchor: '0 1', justify: '0 1');
	apbox.preloop = dap_preloop;
	apbox.partner = spawn(uispritesheet_c, owner: apbox, origin: '0 0', size: '14 18', image: "gfx/hud/darmor_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	apbox.partner2 = spawn(uispritesheet_c, owner: apbox, origin: '14 0', size: '14 18', image: "gfx/hud/darmor_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	apbox.partner3 = spawn(uispritesheet_c, owner: apbox, origin: '28 0', size: '14 18', image: "gfx/hud/darmor_sheet.tga", sheet_size: '10 10', sprite: '0 0');
	//
	//Soul Tether
	void(uielement_c this, __inout vector position) tether_preloop = {
		float tethers = floor(getstatf(STAT_RD_ST));
		float tether_time = getstatf(STAT_TETHERTIME);
		this.partner.flags &= ~UIFLAG::HIDE;
		this.partner2.flags &= ~UIFLAG::HIDE;

		uipicture_c tether_hightlightA = (uipicture_c)this.partner3;
		uipicture_c tether_hightlightB = (uipicture_c)this.partner4;

		float hla_alpha = 0;
		float hlb_alpha = 0;
		if (tether_time >= 137)
		{
			float diff = fabs(138 - tether_time) / 3;
			if ((tether_time >= 137) && (tether_time <= 138))
				hla_alpha = 1 - diff;
			if (tether_time >= 139)
				hlb_alpha = 1 - diff;
		}
		tether_hightlightA.alpha = hla_alpha;
		tether_hightlightB.alpha = hlb_alpha;

		if (tethers < 10)
		{
			this.partner2.flags |= UIFLAG::HIDE;
			this.partner.skin = tethers % 10;
		}
		else
		{
			this.partner.skin = floor((tethers % 100) / 10);
			this.partner2.skin = tethers % 10;
		}

		((uipicture_c)this.partner).image = sprintf("gfx/artifactmenu/artifact_num%g.tga", this.partner.skin);
		((uipicture_c)this.partner2).image = sprintf("gfx/artifactmenu/artifact_num%g.tga", this.partner2.skin);
	}

	uipicture_c tether = spawn(uipicture_c, owner: ui_hud, origin: '170 -4', size: '64 64', anchor: '0 1', justify: '0 1',
		image: "gfx/hud/cooldown/soul_tether_hud");
		tether.preloop = tether_preloop;

	float tether_glyphactive(uielement_c this) = { return ((floor(getstatf(STAT_RD_ST)) > 0) && gamepadglyph_active()); };
	uipicture_c glyph = spawn(uiglyph_c, owner: tether, size: '20 20', anchor: '0 1', justify: '0 1', origin: '3 -3', bind_cmd: "impulse 81");
		glyph.active_condition = tether_glyphactive;

	// highlight images
	tether.partner3 = spawn(uipicture_c, owner: tether, origin: '0 0', size: '64 64', image: "gfx/hud/cooldown/soul_tether_pulseA.tga");
	tether.partner4 = spawn(uipicture_c, owner: tether, origin: '0 0', size: '64 64', image: "gfx/hud/cooldown/soul_tether_pulseB.tga");
	
	// number
	tether.partner = spawn(uipicture_c, owner: tether, anchor: '1 1', origin: '-16 -8', size: '8 8', justify: '0 1');
	tether.partner2 = spawn(uipicture_c, owner: tether, anchor: '1 1', origin: '-8 -8', size: '8 8', justify: '0 1');
	//
	//Artifact
	void(uielement_c this, __inout vector position) artifact_preloop = {
		float artifact_active = getstatf(STAT_RADIALACTIVE);
		float artifact_time = getstatf(STAT_ARTIFACTTIME);
		float artifact_amount = 0;

		uispritesheet_c ring_sprite = (uispritesheet_c)this.partner5;
		//uipicture_c ring_pulse = (uipicture_c)this.partner7;
		uispritesheet_c artifact_icon = (uipicture_c)this.partner6;
		//uipicture_c artifact_hightlightA = (uipicture_c)this.partner3;
		//uipicture_c artifact_hightlightB = (uipicture_c)this.partner4;

		// we don't zone the numbers, so hide them unless told otherwise
		this.partner.flags |= UIFLAG::HIDE;
		this.partner2.flags |= UIFLAG::HIDE;
		//

		if (artifact_active > 0 && artifact_active <= 10)
		{
			artifact_amount = getstatf(STAT_RD_MR + (artifact_active - 1));
		}

		string artifact_names[] = {
				"",
				"gfx/hud/cooldown/artifactA", 	// 1
				"gfx/hud/cooldown/artifactB", 	// 2 
				"gfx/hud/cooldown/artifactC", 	// 3
				"gfx/hud/cooldown/artifactD", 	// 4
				"gfx/hud/cooldown/artifactE", 	// 5
				"gfx/hud/cooldown/artifactF", 	// 6
				"gfx/hud/cooldown/artifactG", 	// 7
				"gfx/hud/cooldown/artifactH", 	// 8
				"gfx/hud/cooldown/artifactI", 	// 9
				"gfx/hud/cooldown/artifactJ", 	// 10
				"",								// 11
				"",								// 12
				"",								// 13
				"",								// 14
				"",								// 15
				"",								// 16
				"",								// 17
				"",								// 18
				"",								// 19
				"gfx/hud/cooldown/sigil_flight", // 20
				"gfx/hud/cooldown/sigil_displacement", // 21
				"gfx/hud/cooldown/sigil_wrath" // 22
		};

		artifact_time = floor(artifact_time);
		if (artifact_time > 0)
		{
			ring_sprite.flags &= ~UIFLAG::HIDE;

			float ring_time = min(artifact_time, 135);
			ring_sprite.sprite = [ring_time % 12, ring_time / 12];
			
			switch (artifact_active)
			{
				case (20): // why don't these have constants defined??
					ring_sprite.image = "gfx/hud/cooldown/cd_sheet_flight.tga";
					break;
				case (21):
					ring_sprite.image = "gfx/hud/cooldown/cd_sheet_displacement.tga";
					break;
				case (22):
					ring_sprite.image = "gfx/hud/cooldown/cd_sheet_wrath.tga";
					break;
				case (0): // don't swap, if we just ended one
					break;
				default:
					ring_sprite.image = "gfx/hud/cooldown/cd_sheet.tga";
					break;
			}

			ring_sprite.alpha = 1;
			/*
			if (artifact_time >= 138)
			{
				float diff = ((140 - artifact_time) / 3);
				ring_sprite.alpha = diff;
			}
			*/
		}
		else
		{
			ring_sprite.flags |= UIFLAG::HIDE;
		}

		vector pulseicon = [nexartifacticon * 0.1, nexartifacticon * 0.1, nexartifacticon * 0.1];

		//ring_pulse.flags |= UIFLAG::HIDE;
		artifact_icon.flags |= UIFLAG::HIDE;
		//artifact_hightlightA.flags |= UIFLAG::HIDE;
		//artifact_hightlightB.flags |= UIFLAG::HIDE;
		if (artifact_active > 0 && artifact_active < artifact_names.length)
		{
			artifact_icon.image = sprintf("%s_hud.tga", artifact_names[artifact_active]);
			//artifact_hightlightA.image = sprintf("%s_pulseA.tga", artifact_names[artifact_active]);
			//artifact_hightlightB.image = sprintf("%s_pulseB.tga", artifact_names[artifact_active]);

			artifact_icon.sprite[0] = 0;
			if (artifact_time > 137) // Reki (October 6 2023): do cooldown fade animation
			{
				float frm = artifact_time - 137;
				artifact_icon.sprite[0] = frm;
				ring_sprite.sprite[0] += frm;
				if (frm > 4)
					return;
			}

			if (artifact_active <= 10)
				artifact_icon.color = pulseicon;
			else
				artifact_icon.color = '1 1 1';

			//artifact_icon.alpha = art_alpha;
			//artifact_hightlightA.alpha = hla_alpha;
			//artifact_hightlightB.alpha = hlb_alpha;

			artifact_icon.flags &= ~UIFLAG::HIDE;
			//artifact_hightlightA.flags &= ~UIFLAG::HIDE;
			//artifact_hightlightB.flags &= ~UIFLAG::HIDE;

			if (artifact_time > 0)
			{
				//this.partner.flags |= UIFLAG::HIDE;
				//this.partner2.flags |= UIFLAG::HIDE;
				//return;
			}

			this.partner.flags &= ~UIFLAG::HIDE;
			this.partner2.flags &= ~UIFLAG::HIDE;
			if (artifact_amount < 10)
			{
				this.partner2.flags |= UIFLAG::HIDE;
				if (artifact_amount <= 0)
					this.partner.flags |= UIFLAG::HIDE;
				else
					this.partner.skin = artifact_amount % 10;
			}
			else
			{
				this.partner.skin = floor((artifact_amount % 100) / 10);
				this.partner2.skin = artifact_amount % 10;
			}
	
			((uipicture_c)this.partner).image = sprintf("gfx/artifactmenu/artifact_num%g.tga", this.partner.skin);
			if !(this.partner2.flags & UIFLAG::HIDE)
				((uipicture_c)this.partner2).image = sprintf("gfx/artifactmenu/artifact_num%g.tga", this.partner2.skin);
		}
	}

	uielement_c artifact = spawn(uielement_c, owner: ui_hud, origin: '236 -4', size: '64 64', anchor: '0 1', justify: '0 1');
		artifact.preloop = artifact_preloop;

	// cooldown ring
	artifact.partner5 = spawn(uispritesheet_c, owner: artifact, origin: '0 0', size: '64 64', image: "gfx/hud/cooldown/cd_sheet.tga", sheet_size: '12 12');
	//artifact.partner7 = spawn(uipicture_c, owner: artifact, origin: '0 0', size: '64 64', image: "gfx/hud/cooldown/cd_pulse.tga");

	// image itself
	artifact.partner6 = spawn(uispritesheet_c, owner: artifact, origin: '0 0', size: '64 64', sheet_size: '5 1');

	// highlight images
	//artifact.partner3 = spawn(uipicture_c, owner: artifact, origin: '0 0', size: '64 64');
	//artifact.partner4 = spawn(uipicture_c, owner: artifact, origin: '0 0', size: '64 64');

	// number
	artifact.partner = spawn(uipicture_c, owner: artifact, anchor: '1 1', origin: '-16 -8', size: '8 8', justify: '0 1');
	artifact.partner2 = spawn(uipicture_c, owner: artifact, anchor: '1 1', origin: '-8 -8', size: '8 8', justify: '0 1');

	float glyphactive(uielement_c this) = { return ((getstatf(STAT_RADIALACTIVE) == 0) && gamepadglyph_active()); };
	uipicture_c glyph = spawn(uiglyph_c, owner: artifact, size: '20 20', anchor: '0 1', justify: '0 1', origin: '3 -3', bind_cmd: "+button6");
		glyph.active_condition = glyphactive;

	float glyphactive(uielement_c this) = { return ((getstatf(STAT_RADIALACTIVE) != 0 && !getstatf(STAT_ARTIFACTTIME)) && gamepadglyph_active()); };
	uipicture_c glyph = spawn(uiglyph_c, owner: artifact, size: '20 20', anchor: '0 1', justify: '0 1', origin: '3 -3', bind_cmd: "impulse 15");
		glyph.active_condition = glyphactive;
	//
	
	//Ammo Counter
	void(uielement_c this, __inout vector position) ammo_preloop = {
		float ammov;
		if (pulseammo_icon == 1)
		{
			if (floor(ammphicon) >= 10)
			{
				pulseammo_icon = 0;
			}
		}

		((uispritesheet_c)this.partner).sprite[1] = ammphicon;
		((uispritesheet_c)this.partner2).sprite[1] = ammphicon; 
		((uispritesheet_c)this.partner3).sprite[1] = ammphicon;

		ammov = -1;
		string picofnammo = "gfx/hud/slugs_sheet.tga";
		float c_w = floor(getstatf(STAT_LASTWEAPON));
		if (c_w == IT_REVOLVER)
		{
			picofnammo = "gfx/hud/slugs_sheet.tga";
			ammov = getstatf(STAT_AMMO_REVOLVER);
		}
		if (c_w == IT_SHOTGUN)
		{
			picofnammo = "gfx/hud/shells_sheet.tga";
			ammov = getstatf(STAT_AMMO_SHOTGUN);
		}
		else if (c_w == IT_SPITTER)
		{
			picofnammo = "gfx/hud/fangs_sheet.tga";
			ammov = getstatf(STAT_AMMO_FLAMETHROWER);
		}
		else if (c_w == IT_RETCHER)
		{
			picofnammo = "gfx/hud/cysts_sheet.tga";
			ammov = getstatf(STAT_AMMO_BOMBS);
		}
		else if (c_w == IT_CANNON)
		{
			picofnammo = "gfx/hud/ore_sheet.tga";
			ammov = getstatf(STAT_AMMO_CANNON);
		}
		else if (c_w == IT_LANCE)
		{
			picofnammo = "gfx/hud/lances_sheet.tga";
			ammov = getstatf(STAT_AMMO_LANCE);
		}
		else if (c_w == IT_MACE)
		{
			picofnammo = "gfx/hud/mace_sheet.tga";
			ammov = getstatf(STAT_AMMO_MACE);
		}
		else if (c_w == IT_CRYSTAL)
		{
			picofnammo = "gfx/hud/crystal_sheet.tga";
			ammov = getstatf(STAT_AMMO_CRYSTAL);
		}

		float vw_state = getstatf(STAT_VWEAPONSTATE);
		float slide_max = 128;
		if (ui_renderframe) // hack so we animate only on render frames
		{
			if (vw_state == 2)
			{
				ui_ammoslide = min(slide_max, ui_ammoslide + (1200 * clframetime));
			}
			else if (ui_ammoslide > 0)
			{
				ui_ammoslide = max(0, ui_ammoslide - (1200 * clframetime));
			}
		}
		
		float alph = 1 - (ui_ammoslide / slide_max);
		this.partner.alpha = this.partner2.alpha = this.partner3.alpha = alph;
		position[0] += ui_ammoslide * ui_scale[0];

		((uispritesheet_c)this.partner).image = picofnammo;
		((uispritesheet_c)this.partner2).image = picofnammo; 
		((uispritesheet_c)this.partner3).image = picofnammo;

		this.partner.flags &= ~UIFLAG::HIDE;
		this.partner2.flags &= ~UIFLAG::HIDE;
		this.partner3.flags &= ~UIFLAG::HIDE;
		if (ammov < 100)
		{
			this.partner3.flags |= UIFLAG::HIDE;
			if (ammov < 10)
			{
				this.partner2.flags |= UIFLAG::HIDE;
				if (ammov < 0)
				this.partner.flags |= UIFLAG::HIDE;
				else
					((uispritesheet_c)this.partner).sprite[0] = ammov % 10;
			}
			else
			{
				((uispritesheet_c)this.partner).sprite[0] = floor((ammov % 100) / 10);
				((uispritesheet_c)this.partner2).sprite[0] = ammov % 10;
			}
		}
		else
		{
			((uispritesheet_c)this.partner).sprite[0] = floor(ammov / 100);
			((uispritesheet_c)this.partner2).sprite[0] = floor((ammov % 100) / 10);
			((uispritesheet_c)this.partner3).sprite[0] = ammov % 10;
		}
	}

	uielement_c ammobox = spawn(uielement_c, owner: ui_hud, origin: '-28 -18', size: '84 36', anchor: '1 1', justify: '1 1');
	ammobox.preloop = ammo_preloop;
	ammobox.partner = spawn(uispritesheet_c, owner: ammobox, origin: '0 0', size: '28 36', sheet_size: '10 10', sprite: '0 0');
	ammobox.partner2 = spawn(uispritesheet_c, owner: ammobox, origin: '30 0', size: '28 36', sheet_size: '10 10', sprite: '0 0');
	ammobox.partner3 = spawn(uispritesheet_c, owner: ammobox, origin: '60 0', size: '28 36', sheet_size: '10 10', sprite: '0 0');
	//
	//Relics
	void(uielement_c this, __inout vector position) relic_preloop = {		
		string relic_images[] = {
			"",
			"gfx/hud/messages/icons/msgicon_relic_e1m1",
			"gfx/hud/messages/icons/msgicon_relic_e1m2",
			"gfx/hud/messages/icons/msgicon_relic_e1m3",
			"gfx/hud/messages/icons/msgicon_relic_e1m4",
			"gfx/hud/messages/icons/msgicon_relic_e1m5",
			"gfx/hud/messages/icons/msgicon_relic_e2m1",
			"gfx/hud/messages/icons/msgicon_relic_e2m2",
			"gfx/hud/messages/icons/msgicon_relic_e2m3",
			"gfx/hud/messages/icons/msgicon_relic_e2m4",
			"gfx/hud/messages/icons/msgicon_relic_e2m5",
			"gfx/hud/messages/icons/msgicon_relic_e3m1",
			"gfx/hud/messages/icons/msgicon_relic_e3m2",
			"gfx/hud/messages/icons/msgicon_relic_e3m3",
			"gfx/hud/messages/icons/msgicon_relic_e3m4",
			"gfx/hud/messages/icons/msgicon_relic_e3m5",
			"gfx/hud/messages/icons/msgicon_relic_intro",
		};

		//string relics = getstats(STAT_SLOT_RELICS);
		float relic_p1 = bound(0, numfield_fetchindex(huds_relics, 0), relic_images.length);
		float relic_p2 = bound(0, numfield_fetchindex(huds_relics, 1), relic_images.length);
		float relic_p3 = bound(0, numfield_fetchindex(huds_relics, 2), relic_images.length);
		float relic_p4 = bound(0, numfield_fetchindex(huds_relics, 3), relic_images.length);
		float relic_p5 = bound(0, numfield_fetchindex(huds_relics, 4), relic_images.length);
		
		uipicture_c relic1 = (uipicture_c)this.partner;
		uipicture_c relic2 = (uipicture_c)this.partner2;
		uipicture_c relic3 = (uipicture_c)this.partner3;
		uipicture_c relic4 = (uipicture_c)this.partner4;
		uipicture_c relic5 = (uipicture_c)this.partner5;

		relic1.flags |= UIFLAG::HIDE;
		relic2.flags |= UIFLAG::HIDE;
		relic3.flags |= UIFLAG::HIDE;
		relic4.flags |= UIFLAG::HIDE;
		relic5.flags |= UIFLAG::HIDE;

		if (relic_p1)
		{
			relic1.image = relic_images[relic_p1];
			relic1.flags &= ~UIFLAG::HIDE;
		}
		if (relic_p2)
		{
			relic2.image = relic_images[relic_p2];
			relic2.flags &= ~UIFLAG::HIDE;
		}
		if (relic_p3)
		{
			relic3.image = relic_images[relic_p3];
			relic3.flags &= ~UIFLAG::HIDE;
		}
		if (relic_p4)
		{
			relic4.image = relic_images[relic_p4];
			relic4.flags &= ~UIFLAG::HIDE;
		}
		if (relic_p5)
		{
			relic5.image = relic_images[relic_p5];
			relic5.flags &= ~UIFLAG::HIDE;
		}
	}

	uielement_c relicbox = spawn(uielement_c, owner: ui_hud, origin: '-8 40', size: '200 80', anchor: '1 0', justify: '1 0');
		relicbox.preloop = relic_preloop;
	
	relicbox.partner = spawn(uipicture_c, owner: relicbox, anchor: '1 0', origin: '0 0', size: '32 32', justify: '1 1');
	relicbox.partner2 = spawn(uipicture_c, owner: relicbox, anchor: '1 0', origin: '-50 0', size: '32 32', justify: '1 1');
	relicbox.partner3 = spawn(uipicture_c, owner: relicbox, anchor: '1 0', origin: '-100 0', size: '32 32', justify: '1 1');
	relicbox.partner4 = spawn(uipicture_c, owner: relicbox, anchor: '1 0', origin: '-150 0', size: '32 32', justify: '1 1');
	relicbox.partner5 = spawn(uipicture_c, owner: relicbox, anchor: '1 0', origin: '-200 0', size: '32 32', justify: '1 1');
	//
	//Glyphs
	void(uielement_c this, __inout vector position) glyph_preloop = {
		float keys = getstatf(STAT_SLOT_KEYS);
		float key_p1 = bound(0, floor((keys % 1000) / 100), 9);
		float key_p2 = bound(0, floor((keys % 100) / 10), 9);
		float key_p3 = bound(0, floor((keys % 10)), 9);

		string keys_images[] = {"",
			"gfx/hud/messages/icons/msgicon_key_red",
			"gfx/hud/messages/icons/msgicon_key_blue",
			"gfx/hud/messages/icons/msgicon_key_yellow",
			"","","","","",""
		};
		
		uipicture_c key1 = (uipicture_c)this.partner;
		uipicture_c key2 = (uipicture_c)this.partner2;
		uipicture_c key3 = (uipicture_c)this.partner3;

		key1.flags |= UIFLAG::HIDE;
		key2.flags |= UIFLAG::HIDE;
		key3.flags |= UIFLAG::HIDE;


		if (key_p1)
		{
			key1.image = keys_images[key_p1];
			key1.flags &= ~UIFLAG::HIDE;
		}
		if (key_p2)
		{
			key2.image = keys_images[key_p2];
			key2.flags &= ~UIFLAG::HIDE;
		}
		if (key_p3)
		{
			key3.image = keys_images[key_p3];
			key3.flags &= ~UIFLAG::HIDE;
		}
	}

	uielement_c glyphbox = spawn(uielement_c, owner: ui_hud, origin: '-8 88', size: '100 80', anchor: '1 0', justify: '1 0');
		glyphbox.preloop = glyph_preloop;
	
	glyphbox.partner = spawn(uipicture_c, owner: glyphbox, anchor: '1 0', origin: '0 0', size: '32 32', justify: '1 1');
	glyphbox.partner2 = spawn(uipicture_c, owner: glyphbox, anchor: '1 0', origin: '-50 0', size: '32 32', justify: '1 1');
	glyphbox.partner3 = spawn(uipicture_c, owner: glyphbox, anchor: '1 0', origin: '-100 0', size: '32 32', justify: '1 1');

	//Keys
	float(uielement_c this) cofferkey_condition = {
		if (getstati(STAT_ITEMS) & this.skin) return TRUE; return FALSE;
	}
	uipicture_c cofferkey;
	cofferkey = spawn(uipicture_c, owner: glyphbox, anchor: '1 0', origin: '0 48', size: '32 32', justify: '1 1', image: "gfx/hud/messages/icons/msgicon_coffer_key.tga", skin: IT_COFFERKEY1);
		cofferkey.active_condition = cofferkey_condition;

	cofferkey = spawn(uipicture_c, owner: glyphbox, anchor: '1 0', origin: '-50 48', size: '32 32', justify: '1 1', image: "gfx/hud/messages/icons/msgicon_coffer_key.tga", skin: IT_COFFERKEY2);
		cofferkey.active_condition = cofferkey_condition;
	
	cofferkey = spawn(uipicture_c, owner: glyphbox, anchor: '1 0', origin: '-100 48', size: '32 32', justify: '1 1', image: "gfx/hud/messages/icons/msgicon_coffer_key.tga", skin: IT_COFFERKEY3);
		cofferkey.active_condition = cofferkey_condition;
	//
}

void HUD_InitializeBackfill(void)
{
	void(uielement_c this, __inout vector position) backfill_preloop = {
		if (ui_renderframe)
		{
			if (ui_oldusemouse)
				this.alpha = min(this.skin, this.alpha + (clframetime * 4));
			else
				this.alpha = max(0, this.alpha - (clframetime * 6));
		}
	}
	uifill_c backfill = spawn(uifill_c, flags: UIFLAG::STRETCH, color: '-1 -1 -1', skin: 0.65);
		backfill.preloop = backfill_preloop;
}

vector thumbstick_right;
vector radial_thumbstick;
vector radial_pos;
float radial_selected;
float radial_artifact_order[] = {
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
};

void HUD_InitializeArtifactRadial(void)
{
	static string ring_images[] = {
		"gfx/artifactmenu/radial/artifactslot_0.tga", 	// 1
		"gfx/artifactmenu/radial/artifactslot_1.tga", 	// 2 
		"gfx/artifactmenu/radial/artifactslot_2.tga", 	// 3
		"gfx/artifactmenu/radial/artifactslot_3.tga", 	// 4
		"gfx/artifactmenu/radial/artifactslot_4.tga", 	// 5
		"gfx/artifactmenu/radial/artifactslot_5.tga", 	// 6
		"gfx/artifactmenu/radial/artifactslot_6.tga", 	// 7
		"gfx/artifactmenu/radial/artifactslot_7.tga", 	// 8
		"gfx/artifactmenu/radial/artifactslot_8.tga", 	// 9
		"gfx/artifactmenu/radial/artifactslot_9.tga", 	// 10
	};

	static string ring_selected_images[] = {
		"gfx/artifactmenu/radial/artifactslot_selected_0.tga", 	// 1
		"gfx/artifactmenu/radial/artifactslot_selected_1.tga", 	// 2 
		"gfx/artifactmenu/radial/artifactslot_selected_2.tga", 	// 3
		"gfx/artifactmenu/radial/artifactslot_selected_3.tga", 	// 4
		"gfx/artifactmenu/radial/artifactslot_selected_4.tga", 	// 5
		"gfx/artifactmenu/radial/artifactslot_selected_5.tga", 	// 6
		"gfx/artifactmenu/radial/artifactslot_selected_6.tga", 	// 7
		"gfx/artifactmenu/radial/artifactslot_selected_7.tga", 	// 8
		"gfx/artifactmenu/radial/artifactslot_selected_8.tga", 	// 9
		"gfx/artifactmenu/radial/artifactslot_selected_9.tga", 	// 10
	};

	static string artifact_icons[] = {
		"gfx/artifactmenu/artifactA_icon.tga", 	// 1
		"gfx/artifactmenu/artifactB_icon.tga", 	// 2 
		"gfx/artifactmenu/artifactC_icon.tga", 	// 3
		"gfx/artifactmenu/artifactD_icon.tga", 	// 4
		"gfx/artifactmenu/artifactE_icon.tga", 	// 5
		"gfx/artifactmenu/artifactF_icon.tga", 	// 6
		"gfx/artifactmenu/artifactG_icon.tga", 	// 7
		"gfx/artifactmenu/artifactH_icon.tga", 	// 8
		"gfx/artifactmenu/artifactI_icon.tga", 	// 9
		"gfx/artifactmenu/artifactJ_icon.tga", 	// 10
	};

	static string artifact_icons_large[] = {
		"gfx/artifactmenu/artifactA_icon_large.tga", 	// 1
		"gfx/artifactmenu/artifactB_icon_large.tga", 	// 2 
		"gfx/artifactmenu/artifactC_icon_large.tga", 	// 3
		"gfx/artifactmenu/artifactD_icon_large.tga", 	// 4
		"gfx/artifactmenu/artifactE_icon_large.tga", 	// 5
		"gfx/artifactmenu/artifactF_icon_large.tga", 	// 6
		"gfx/artifactmenu/artifactG_icon_large.tga", 	// 7
		"gfx/artifactmenu/artifactH_icon_large.tga", 	// 8
		"gfx/artifactmenu/artifactI_icon_large.tga", 	// 9
		"gfx/artifactmenu/artifactJ_icon_large.tga", 	// 10
	};

	// Reki (September 22 2023): This has to be dynamic, because of localization
	static string artifact_info[10];
	artifact_info[0] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactA_info.tga"));
	artifact_info[1] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactB_info.tga"));
	artifact_info[2] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactC_info.tga"));
	artifact_info[3] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactD_info.tga"));
	artifact_info[4] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactE_info.tga"));
	artifact_info[5] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactF_info.tga"));
	artifact_info[6] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactG_info.tga"));
	artifact_info[7] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactH_info.tga"));
	artifact_info[8] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactI_info.tga"));
	artifact_info[9] = strzone(Localization_FindFile("gfx/artifactmenu/%s/artifactJ_info.tga"));

	static vector num_positions[] = { // Reki (September 22 2023): Radial number positions
		'41 11',
		'61 17',
		'73 34',
		'73 54',
		'61 71',
		'41 77',
		'21 71',
		'9 54',
		'9 34',
		'21 17',
	};

	float(uielement_c this) condtional = { if (rmenualpha > 0) return TRUE; return FALSE; };
	void(uifill_c this, __inout vector color_to_render, __inout float alpha_to_render) radial_prerender = {
		
		// Reki (December 3 2023)
		// HACK: do radial thumbstick stuff here, better than a hardcode elsewhere I guess...
		if (input_mode == IN_MODE_GAMEPAD)
		{
			if (rmenu) // only update the radial wanted pos if we are currently wanting to be in the artifact menu
				radial_thumbstick = thumbstick_look;

			#define RADIAL_THUMBSTICK_DRIFTSPEED 45
			vector thumbstick_pos = normalize(radial_thumbstick) * 20 * bound(0, vlen(radial_thumbstick), 1);
			vector diffv = thumbstick_pos - radial_pos;
			float diff = vlen(diffv);
			float delta = bound(0.5, diff, 25) * (RADIAL_THUMBSTICK_DRIFTSPEED * clframetime);

			if (delta < diff)
				radial_pos += normalize(diffv) * delta;
			else
				radial_pos = thumbstick_pos;
		}

		alpha_to_render *= rmenualpha;
	};
	void(uielement_c this, __inout vector position) radial_preloop = {
		uipicture_c cursor = (uipicture_c)this.partner;
		uipicture_c large_icon = (uipicture_c)this.partner2;
		uipicture_c large_text = (uipicture_c)this.partner3;
		uipicture_c center_ring = (uipicture_c)this.partner4;

		float o_selected = radial_selected;
		float radial_dist = vlen(radial_pos);
		float frac = radial_dist / 20;
		cursor.origin = normalize(radial_pos) * 108 * frac;
		cursor.origin[0] = floor(cursor.origin[0]);
		cursor.origin[1] = floor(cursor.origin[1]);

		large_icon.flags |= UIFLAG::HIDE;
		large_text.flags |= UIFLAG::HIDE;
		center_ring.flags |= UIFLAG::HIDE;

		#define RADIAL_SELECT_THRESHOLD 16
		if (input_mode != IN_MODE_GAMEPAD) // gamepads get special treatment
		{
			if (radial_dist < RADIAL_SELECT_THRESHOLD)
			{
				radial_selected = 0;
				return;
			}
		}
		
		float ang_sep = (360) / 10;
		float ang_curr = 270 - (ang_sep / 2);
		float dir = vectoangles(normalize(radial_pos))[1] - (270 - (ang_sep / 2));
		if (dir < 0)
			dir += 360;
		//dir /= ang_sep;
		//print(sprintf("%g, %g\n", dir, dir / ang_sep));

		if (radial_dist >= RADIAL_SELECT_THRESHOLD)
			radial_selected = ceil(dir / ang_sep);

		if (radial_selected > 0 && radial_selected <= artifact_icons.length)
		{
			radial_selected = radial_artifact_order[radial_selected - 1] + 1;
			if (getstatf(STAT_RD_MR + (radial_selected - 1)))
			{
				large_icon.image = artifact_icons_large[radial_selected - 1];
				large_text.image = artifact_info[radial_selected - 1];

				// resize, because some localization stuff is too wide
				vector isz = draw_getimagesize(large_text.image);
				large_text.size[0] = isz[0] * (80 / isz[1]);

				large_icon.flags &= ~UIFLAG::HIDE;
				large_text.flags &= ~UIFLAG::HIDE;
				center_ring.flags &= ~UIFLAG::HIDE;
			}
		}

		if (radial_selected != o_selected)
		{
			localcmd(sprintf("impulse %g\n", 20 + radial_selected));
		}
	};
	void(uielement_c this, __inout vector position) radialselection_preloop = {
		uipicture_c highlight = (uipicture_c)this.partner;
		uipicture_c icon = (uipicture_c)this.partner2;
		uielement_c numcontainer = this.partner3;
		uielement_c num1 = numcontainer.partner;
		uielement_c num2 = numcontainer.partner2;
		float index = radial_artifact_order[bound(0, this.colormap, 9)];

		num1.flags |= UIFLAG::HIDE;
		num2.flags |= UIFLAG::HIDE;

		icon.flags |= UIFLAG::HIDE;
		highlight.flags |= UIFLAG::HIDE;
		if (!getstatf(STAT_RD_MR + (index)))
			return;

		icon.flags &= ~UIFLAG::HIDE;
		if (radial_selected == index + 1)
			highlight.flags &= ~UIFLAG::HIDE;
		
		float amount = getstatf(STAT_RD_MR + (index));
		if (amount >= 10)
		{
			num1.flags &= ~UIFLAG::HIDE;
			num1.skin = floor((amount % 100) / 10);

			num1.origin = '0 0';
			num2.origin = '6 0';
			
			num2.flags &= ~UIFLAG::HIDE;
			num2.skin = amount % 10;
		}
		else if (amount >= 1)
		{
			num1.origin = '3 0';

			num1.skin = amount % 10;
			num1.flags &= ~UIFLAG::HIDE;
		}	
		
		((uipicture_c)num1).image = sprintf("gfx/artifactmenu/artifact_num%g.tga", num1.skin);
		((uipicture_c)num2).image = sprintf("gfx/artifactmenu/artifact_num%g.tga", num2.skin);
	};


	uifill_c radial_fill = spawn(uifill_c, flags: UIFLAG::STRETCH, color: '-1 -1 -1', alpha: 0.65);
		radial_fill.active_condition = condtional;
		radial_fill.prerender = radial_prerender;
		radial_fill.preloop = radial_preloop;
	
	// outlander logo
	void(uielement_c this, __inout vector position) outlander_preloop = {
		this.alpha = 0.4 + (sin(cltime * 1.5) * 0.1);
	};
	uipicture_c outlander_bg = spawn(uipicture_c, owner: radial_fill, anchor: '0.5 0.5', size: '848 352', justify: '0.5 0.5', drawflags: DRAWFLAG_ADDITIVE, image: "gfx/artifactmenu/radial/artifactmenubg_outlanderlogo.tga");
		outlander_bg.preloop = outlander_preloop;

	// center select ring
	uipicture_c center_ring = spawn(uipicture_c, owner: radial_fill, anchor: '0.5 0.5', size: '128 128', justify: '0.5 0.5', origin: '0 -62', image: "gfx/artifactmenu/radial/artifactslot_large.tga");
		radial_fill.partner4 = center_ring;

	uipicture_c large_icon = spawn(uipicture_c, owner: center_ring, anchor: '0.5 0.5', size: '84 84', justify: '0.5 0.5');
		radial_fill.partner2 = large_icon;
	
	uipicture_c large_text = spawn(uipicture_c, owner: radial_fill, anchor: '0.5 0.5', size: '240 80', justify: '0.5 0.5', origin: '0 30');
		radial_fill.partner3 = large_text;

	uipicture_c cursor = spawn(uipicture_c, owner: radial_fill, anchor: '0.5 0.5', size: '31 31', justify: '0.5 0.5',
		image: "gfx/artifactmenu/radial/artifact_cursor.tga");
		radial_fill.partner = cursor;
	
	float dist = 148;
	float ang_sep = (360 * DEG2RAD) / 10;
	float ang_curr = 270 * DEG2RAD;
	for(float i = 0; i < 10; i++, ang_curr += ang_sep)
	{
		vector pos = [floor(cos(ang_curr) * dist), floor(sin(ang_curr) * dist)];
		uipicture_c ring = spawn(uipicture_c, owner: radial_fill, anchor: '0.5 0.5', origin: pos, size: '96 96', justify: '0.5 0.5',
			image: ring_images[i],
			skin: 1 << i, colormap: i);
		ring.preloop = radialselection_preloop;
		
		uipicture_c artifact_icon = spawn(uipicture_c, owner: ring, anchor: '0.5 0.5', size: '40 40', justify: '0.5 0.5',
			image: artifact_icons[radial_artifact_order[i]]);
		
		uipicture_c selected = spawn(uipicture_c, owner: ring, anchor: '0.5 0.5', size: '96 96', justify: '0.5 0.5', drawflags: DRAWFLAG_ADDITIVE,
			image: ring_selected_images[i]);
		
		ring.partner = selected;
		ring.partner2 = artifact_icon;
		
		uielement_c number_container = ring.partner3 = spawn(uielement_c, owner: ring, origin: num_positions[i]);
		number_container.partner = spawn(uipicture_c, owner: number_container, anchor: '0 0', origin: '-16 -8', size: '8 8', justify: '0 0');
		number_container.partner2 = spawn(uipicture_c, owner: number_container, anchor: '0 0', origin: '-6 -8', size: '8 8', justify: '0 0');
	}
}

void HUD_InitializeDeathMenu(void)
{
	float(uielement_c this) dmenu_active = {
		if (floor(getstatf(STAT_DEADMENU)))
		{
			if (theter_alreadychecked != 1)
			{
				write_tether();
				check_tether();
				check_shrine_user();
				parse_last_saveslot();
				
				if((shrinepresent <= 0) && (shrine_user >  0))
					shrinepresent = 1;
				localcmd("crosshair 0\n");
				localcmd("scratch3 1\n");
				theter_alreadychecked = 1;
			}

			return TRUE;
		}
		localcmd("scratch3 0\n");
		theter_alreadychecked = 0;
		return FALSE;
	};
	float(uielement_c this, float nkey, float char, float released) dmenu_input = {
		
	};
	uilist_c deathmenu = spawn(uilist_c, anchor: '0.5 0.5', size: '256 96', justify: '0.5 0.5', separation: '0 -33');
		deathmenu.active_condition = dmenu_active;

	void(uipicture_c this, __inout string img_to_render) button_highlight = {
		this.partner.color = '0.533 0.106 0';
		if (ui_selected == this || ui_hover == this)
		{
			img_to_render = this.image2;
			this.partner.color = '0.514 0.514 0.514';
		}
		this.partner.size[0] = this.size[0];
	};
	void(uilocpicture_c this, __inout string txt_to_render, __inout vector color_to_render, __inout float alpha_to_render) buttontxt_highlight = {
		this.partner.color = '0.533 0.106 0';
		if (ui_selected == this || ui_hover == this)
			this.partner.color = '0.514 0.514 0.514';
		this.partner.size[0] = this.frame + 2;

		color_to_render = CONVERT_TO_DP_SHITTY_COLOR(this.partner.color);
	};
	float(uielement_c this) fillbar_active = {
		return last_saveslot_used == this.frame;
	}


	// quit
	void(uielement_c this) button_click = {
		localcmd("wmenu\n");
		localcmd("stopsound\n");
		localcmd("menu_cmd backtomainmenu\n");
		localcmd("scratch3 0\n");
	};

	uilocpicture_c button = spawn(uilocpicture_c, owner: deathmenu, anchor: '0.5 1', size: '300 32', justify: '0.5 0.5', flags: UIFLAG::CLICKABLE, fallback_sz: '18 18',
		image: deathmenu_assets[DEATHMENU_IMG::DEPART], image2: deathmenu_assets[DEATHMENU_IMG::DEPART_ACTIVE], fallback_txt: deathmenu_assets_string[DEATHMENU_IMG::DEPART]);
		button.prerender = button_highlight;
		button.prerender_text = buttontxt_highlight;
		button.m_click = button_click;

	if (!button.fallback && button.image)
	{
		vector isz
		isz = drawgetimagesize(button.image); // Resize based on image
		isz *= (button.size[1] / isz[1]);
		button.size[0] = isz[0];
	}
	else
	{
		float o_drawfont = drawfont;
		drawfont = button.fallback_font;
		float txt_width = stringwidth(button.fallback_txt, TRUE, [button.fallback_sz[0], button.fallback_sz[1]]);
		drawfont = o_drawfont;
		button.frame = txt_width;
	}
	
	uifill_c fillbar = spawn(uifill_c, owner: button, anchor: '0.5 1', justify: '0.5 0', color: '0.533 0.106 0', size: '64 1', origin: '0 -5', frame: -1);
		button.partner = fillbar;
		fillbar.active_condition = fillbar_active;
	//

	// restart
	void(uielement_c this) button_click = {
		localcmd("stopsound\n");
		//localcmd("r_glsl_saturation 1\n");
		load_autosave();
		localcmd("scratch3 0\n");
	};

	uilocpicture_c button = spawn(uilocpicture_c, owner: deathmenu, anchor: '0.5 1', size: '300 32', justify: '0.5 0.5', flags: UIFLAG::CLICKABLE, fallback_sz: '18 18',
		image: deathmenu_assets[DEATHMENU_IMG::RESTART], image2: deathmenu_assets[DEATHMENU_IMG::RESTART_ACTIVE], fallback_txt: deathmenu_assets_string[DEATHMENU_IMG::RESTART]);
		button.prerender = button_highlight;
		button.prerender_text = buttontxt_highlight;
		button.m_click = button_click;

	if (!button.fallback && button.image)
	{
		vector isz
		isz = drawgetimagesize(button.image); // Resize based on image
		isz *= (button.size[1] / isz[1]);
		button.size[0] = isz[0];
	}
	else
	{
		float o_drawfont = drawfont;
		drawfont = button.fallback_font;
		float txt_width = stringwidth(button.fallback_txt, TRUE, [button.fallback_sz[0], button.fallback_sz[1]]);
		drawfont = o_drawfont;
		button.frame = txt_width;
	}

	uifill_c fillbar = spawn(uifill_c, owner: button, anchor: '0.5 1', justify: '0.5 0', color: '0.533 0.106 0', size: '64 1', origin: '0 -5', frame: 3);
		button.partner = fillbar;
		fillbar.active_condition = fillbar_active;
	//
	
	// shrine
	float(uielement_c this) condtional = {
		return shrinepresent >= 1;
	};

	void(uielement_c this) button_click = {
		write_shrine(1);
		localcmd("stopsound\n");
		//localcmd("r_glsl_saturation 1\n");
		load_shrine();
		localcmd("scratch3 0\n");
	};

	uilocpicture_c button = spawn(uilocpicture_c, owner: deathmenu, anchor: '0.5 1', size: '300 32', justify: '0.5 0.5', flags: UIFLAG::CLICKABLE, fallback_sz: '18 18',
		image: deathmenu_assets[DEATHMENU_IMG::SHRINE], image2: deathmenu_assets[DEATHMENU_IMG::SHRINE_ACTIVE], fallback_txt: deathmenu_assets_string[DEATHMENU_IMG::SHRINE]);
		button.prerender = button_highlight;
		button.prerender_text = buttontxt_highlight;
		button.m_click = button_click;
		button.active_condition = condtional;

	if (!button.fallback && button.image)
	{
		vector isz
		isz = drawgetimagesize(button.image); // Resize based on image
		isz *= (button.size[1] / isz[1]);
		button.size[0] = isz[0];
	}
	else
	{
		float o_drawfont = drawfont;
		drawfont = button.fallback_font;
		float txt_width = stringwidth(button.fallback_txt, TRUE, [button.fallback_sz[0], button.fallback_sz[1]]);
		drawfont = o_drawfont;
		button.frame = txt_width;
	}
	
	uifill_c fillbar = spawn(uifill_c, owner: button, anchor: '0.5 1', justify: '0.5 0', color: '0.533 0.106 0', size: '64 1', origin: '0 -5', frame: 2);
		button.partner = fillbar;
		fillbar.active_condition = fillbar_active;
	//

	// soul tether
	float(uielement_c this) condtional = {
		if (tether >= 1)
			return TRUE;
		return FALSE;
	};

	void(uielement_c this) button_click = {
		write_tether2(1);
		localcmd("stopsound\n");
		//localcmd("r_glsl_saturation 1\n");
		load_tether();
		localcmd("scratch3 0\n");
	};
	uilocpicture_c button = spawn(uilocpicture_c, owner: deathmenu, anchor: '0.5 1', size: '300 32', justify: '0.5 0.5', flags: UIFLAG::CLICKABLE, fallback_sz: '18 18',
		image: deathmenu_assets[DEATHMENU_IMG::SOULTETHER], image2: deathmenu_assets[DEATHMENU_IMG::SOULTETHER_ACTIVE], fallback_txt: deathmenu_assets_string[DEATHMENU_IMG::SOULTETHER]);
		button.prerender = button_highlight;
		button.prerender_text = buttontxt_highlight;
		button.m_click = button_click;
		button.active_condition = condtional;

	if (!button.fallback && button.image)
	{
		vector isz
		isz = drawgetimagesize(button.image); // Resize based on image
		isz *= (button.size[1] / isz[1]);
		button.size[0] = isz[0];
	}
	else
	{
		float o_drawfont = drawfont;
		drawfont = button.fallback_font;
		float txt_width = stringwidth(button.fallback_txt, TRUE, [button.fallback_sz[0], button.fallback_sz[1]]);
		drawfont = o_drawfont;
		button.frame = txt_width;
	}
	
	uifill_c fillbar = spawn(uifill_c, owner: button, anchor: '0.5 1', justify: '0.5 0', color: '0.533 0.106 0', size: '64 1', origin: '0 -5', frame: 1);
		button.partner = fillbar;
		fillbar.active_condition = fillbar_active;
	//
}

#ifndef CREDITS
float endscreen_startfade;
const float endscreen_fadelength = 5;
const float endscreen_splashfadelength = 3;
const float endscreen_splashlength = 4;
const float endscreen_splashoutlength = 2;

void HUD_InitializeEndscreen(void)
{
	float(uifill_c this) endscreen_conditional = {
		endscreen_startfade = getstatf(STAT_ENDSCREENSTART);
		if (endscreen_startfade && time > endscreen_startfade)
			return TRUE;
		return FALSE;
	};

	void(uifill_c this, __inout vector position) endscreen_preloop = {
		float stime = endscreen_startfade;
		float etime = stime + endscreen_fadelength;
		float ctime = etime - time;
		uipicture_c splash = this.partner;

		if (ctime < 0)
		{
			this.alpha = 1;
			etime = etime + endscreen_splashfadelength;
			ctime = etime - time;
			if (ctime < 0)
			{
				etime = etime + endscreen_splashlength;
				ctime = etime - time;
				if (ctime < 0)
				{
					etime = etime + endscreen_splashoutlength;
					ctime = etime - time;
					if (ctime < 0)
					{
						if (ctime < -0.2)
							localcmd("disconnect\nmenu_restart\ntogglemenu\n");
					}
					else
					{
						splash.alpha = (ctime / endscreen_splashoutlength);
					}
				}
				else
				{
					splash.alpha = 1;
				}
			}
			else
			{
				splash.alpha = 1 - (ctime / endscreen_splashfadelength);
			}
		}
		else
		{
			splash.alpha = 0;
			this.alpha = 1 - (ctime / endscreen_fadelength);
		}
	};
	
	precache_pic("gfx/splashes/endgame.tga");
	uifill_c endscreen = spawn(uifill_c, flags: UIFLAG::STRETCH); endscreen.color = '0 0 0'; endscreen.alpha = 0;
		endscreen.active_condition = endscreen_conditional;
		endscreen.preloop = endscreen_preloop;
	uipicture_c splash = spawn(uipicture_c, owner: endscreen, size: '960 540', anchor: '0.5 0.5', justify: '0.5 0.5', image: "gfx/splashes/endgame.tga"); splash.alpha = 0;
	endscreen.partner = splash;
}
#endif

void() Hud = { vector postimage;
	string time0, time1, time2, time3, time4;
	postimage = '240 -480 0';

	float gettime2;
	gettime2 = gettime(2);
	if(!gettime2)
	gettime2 = 0.002;
	
	time0 = ftos(1 + ((500 - (1 / gettime2)) / 220));
	time1 = ftos(gettime(1));
	time2 = ftos(1 / gettime2);
	time3 = ftos(gettime(3));
	time4 = ftos(frametime);
	//DString (postimage,(time0), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time1), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time2), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time3), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time4), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	local float health, kitems, digits, fphicon;
	health = getstati(STAT_HEALTH);

	string picofnammo;

	string health_n;



	if (health > 0)
	{
		#if 0
		health_n = ftos(floor(health));

		float pulse_y ;

		if (pulsehealth_icon == 1)
		{
			fphicon = floor(phicon);
			if (fphicon <= 1) pulse_y = 10;
			if (fphicon == 2) pulse_y = 20;
			if (fphicon == 3)pulse_y = 30;
			if (fphicon == 4) pulse_y =40;
			if (fphicon == 5) pulse_y = 50;
			if (fphicon == 6) pulse_y = 60;
			if (fphicon == 7) pulse_y = 70;
			if (fphicon == 8) pulse_y = 80;
			if (fphicon == 9) pulse_y = 90;
			if (fphicon >= 10)
			{
				picofnammo = 0;
				localcmd("impulse 200\n");
				pulsehealth_icon = 0;
				phicon = 0;
			}
		}
		else
				picofnammo = 0;


		vector healthrelsep, health_relpos;

		health_relpos = health_pos;
		healthrelsep = healthsep;

		if (health >= 999)
			health = 999;
		if (health >= 1)
			digits = 1;
		if (health >= 10)
			digits = 2;
		if (health >= 100)
			digits = 3;



		float fdigit3  = (health % 10) ;
		float fdigit2 = (((health - fdigit3) * 0.1) %10); 
		float fdigit1 = (health - (health % 100)) / 100;;
		
		
		fdigit3 += pulse_y; 
		fdigit2 += pulse_y;
		fdigit1 += pulse_y;

		if ((health > 30) || (pulsehealth_icon == 1))
			vector colorhealth = '1 1 1'; 
		else
		{
				colorhealth_x = 0.75 + 0.025 * pulsehealth_low;
			if (health <= 20)
				colorhealth_x = 0.5 + 0.05 * pulsehealth_low;
			if (health <= 10)
				colorhealth_x = 0.3 + 0.07 * pulsehealth_low;

			colorhealth_y = colorhealth_x;
			colorhealth_z = colorhealth_x;
		}
		if (digits == 1)
		{
			DrawSheet(health_relpos + healthrelsep + healthrelsep, "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',fdigit3,colorhealth);

		}
		else if (digits == 2)
		{
			DrawSheet(health_relpos + healthrelsep, "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',fdigit3,colorhealth);
			DrawSheet(health_relpos + healthrelsep + healthrelsep, "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',fdigit2,colorhealth);

		}
		else if (digits == 3)
		{
			DrawSheet(health_relpos, "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',fdigit3,'1 1 1');
			DrawSheet(health_relpos + healthrelsep, "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',fdigit2,'1 1 1');
			DrawSheet(health_relpos + healthrelsep + healthrelsep, "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',fdigit1,'1 1 1');
		}
		#endif
	}
	else
	{
		if(deathmatch == 1)
			showscores = 1;
	}
	//	c_drmr =rint(c_drmr);
	kitems = getstati(STAT_ITEMS);
	vector vkeysep, realkeypos;
	vkeysep_x = keysep;

	realkeypos = keypos;
	realkeypos_y += (540 - vid_height);
	realkeypos_x -= (960 - vid_width);

	float sl_slotkeys;
	sl_slotkeys = rint(getstatf(STAT_SLOT_KEYS));
	realkeypos_y += 48;
	local string slotdigits, slotdigitsthous, slotdigitscent, slotdigitsdozen, slotdigitsunit;
	local float slotthous,slotcents, slotdozens, slotunits;
	if (sl_slotkeys)
	{
		vector slot_realkeypos, slot_realkeypos2, slot_realkeypos3;

		slotdigits = ftos(sl_slotkeys);
		slotdigitsdozen = substring(slotdigits, 1, 2);
		slotdigitsunit = substring(slotdigits, 2, 3);
		slotdozens = stof(slotdigitsdozen);
		slotunits = stof(slotdigitsunit);

		slot_realkeypos = realkeypos;
		if ((slotdozens) && (!slotunits))
		{
			slot_realkeypos = realkeypos;
			slot_realkeypos2 = realkeypos + vkeysep;
		}

		if ((slotdozens) && (slotunits))
		{
			slot_realkeypos = realkeypos;
			slot_realkeypos2 = realkeypos + vkeysep;
			slot_realkeypos3 = realkeypos + vkeysep + vkeysep;
		}

		if ((sl_slotkeys >= 100) && (sl_slotkeys < 200))
			DImage2(slot_realkeypos, "gfx/hud/messages/icons/msgicon_glyph_red.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotkeys >= 200) && (sl_slotkeys < 300))
			DImage2(slot_realkeypos, "gfx/hud/messages/icons/msgicon_glyph_blue.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (sl_slotkeys >= 300)
			DImage2(slot_realkeypos, "gfx/hud/messages/icons/msgicon_glyph_yellow.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotdozens >= 10) && (slotdozens < 20))
			DImage2(slot_realkeypos2, "gfx/hud/messages/icons/msgicon_glyph_red.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 20) && (slotdozens < 30))
			DImage2(slot_realkeypos2, "gfx/hud/messages/icons/msgicon_glyph_blue.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotdozens >= 30)
			DImage2(slot_realkeypos2, "gfx/hud/messages/icons/msgicon_glyph_yellow.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotunits >= 1) && (slotunits < 2))
			DImage2(slot_realkeypos3, "gfx/hud/messages/icons/msgicon_glyph_red.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 2) && (slotunits < 3))
			DImage2(slot_realkeypos3, "gfx/hud/messages/icons/msgicon_glyph_blue.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotunits >= 3)
			DImage2(slot_realkeypos3, "gfx/hud/messages/icons/msgicon_glyph_yellow.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

	}

	//drawstring('0 0 0', ftos(sl_slotkeys), '8 8 0', '3 3 3', 1);     	// Draw the "slotkeyused"

	realkeypos_y += 48;
	if (kitems & IT_COFFERKEY1)
		DImage2(realkeypos, "gfx/hud/messages/icons/msgicon_coffer_key.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
	if (kitems & IT_COFFERKEY2)
		DImage2(realkeypos + vkeysep, "gfx/hud/messages/icons/msgicon_coffer_key.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
	if (kitems & IT_COFFERKEY3)
		DImage2(realkeypos + vkeysep + vkeysep, "gfx/hud/messages/icons/msgicon_coffer_key.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

	realkeypos_y -= 96;

	float sl_slotrelics;
	sl_slotrelics = rint(getstatf(STAT_SLOT_RELICS));

	if (sl_slotrelics)
	{
		vector slot_realrelicpos, slot_realrelicpos2, slot_realrelicpos3, slot_realrelicpos4,slot_realrelicpos5;

		slotdigits = ftos(sl_slotrelics);
		slotdigitsthous = substring(slotdigits, 1, 4);
		slotdigitscent = substring(slotdigits, 2, 3);
		slotdigitsdozen = substring(slotdigits, 3, 2);
		slotdigitsunit = substring(slotdigits, 4, 1);
		slotthous = stof(slotdigitsthous);
		slotcents = stof(slotdigitscent);
		slotdozens = stof(slotdigitsdozen);
		slotunits = stof(slotdigitsunit);

		slot_realrelicpos = realkeypos;
/*		if ((slotthous) && (!slotcents) && (!slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
		}*/
		if ((slotthous) && (!slotcents) && (!slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
		}

		if ((slotthous) && (slotcents) && (!slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
			slot_realrelicpos3 = realkeypos + (vkeysep *2);
		}

		if ((slotthous) && (slotcents) && (slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
			slot_realrelicpos3 = realkeypos + (vkeysep *2);
			slot_realrelicpos4 = realkeypos + (vkeysep *3);
		}

		if ((slotthous) &&(slotcents) && (slotdozens) && (slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
			slot_realrelicpos3 = realkeypos + (vkeysep *2);
			slot_realrelicpos4 = realkeypos + (vkeysep *3);
			slot_realrelicpos5 = realkeypos + (vkeysep *4);
		}
		//drawstring('30 0 0', strcat (slotdigits," ",ftos (slotthous)," ",ftos (slotcents)," ",ftos (slotdozens)," ",ftos (slotunits)), '8 8 0', '12 12 0', 1, 0);     	// Draw the "cursor"
	

		if ((sl_slotrelics >= 10000) && (sl_slotrelics < 20000))
			DImage2(slot_realrelicpos, "gfx/hud/messages/icons/msgicon_relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotrelics >= 20000) && (sl_slotrelics < 30000))
			DImage2(slot_realrelicpos, "gfx/hud/messages/icons/msgicon_relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotrelics >= 30000) && (sl_slotrelics < 40000))
			DImage2(slot_realrelicpos, "gfx/hud/messages/icons/msgicon_relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotrelics >= 40000) && (sl_slotrelics < 50000))
			DImage2(slot_realrelicpos, "gfx/hud/messages/icons/msgicon_relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (sl_slotrelics >= 50000)
			DImage2(slot_realrelicpos, "gfx/hud/messages/icons/msgicon_relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotthous >= 1000) && (slotthous < 2000))
			DImage2(slot_realrelicpos2, "gfx/hud/messages/icons/msgicon_relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotthous >= 2000) && (slotthous < 3000))
			DImage2(slot_realrelicpos2, "gfx/hud/messages/icons/msgicon_relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotthous >= 3000) && (slotthous < 4000))
			DImage2(slot_realrelicpos2, "gfx/hud/messages/icons/msgicon_relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotthous >= 4000) && (slotthous < 5000))
			DImage2(slot_realrelicpos2, "gfx/hud/messages/icons/msgicon_relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotthous >= 5000)
			DImage2(slot_realrelicpos2, "gfx/hud/messages/icons/msgicon_relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotcents >= 100) && (slotcents < 200))
			DImage2(slot_realrelicpos3, "gfx/hud/messages/icons/msgicon_relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotcents >= 200) && (slotcents < 300))
			DImage2(slot_realrelicpos3, "gfx/hud/messages/icons/msgicon_relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotcents >= 300) && (slotcents < 400))
			DImage2(slot_realrelicpos3, "gfx/hud/messages/icons/msgicon_relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotcents >= 400) && (slotcents < 500))
			DImage2(slot_realrelicpos3, "gfx/hud/messages/icons/msgicon_relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotcents >= 500)
			DImage2(slot_realrelicpos3, "gfx/hud/messages/icons/msgicon_relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotdozens >= 10) && (slotdozens < 20))
			DImage2(slot_realrelicpos4, "gfx/hud/messages/icons/msgicon_relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 20) && (slotdozens < 30))
			DImage2(slot_realrelicpos4, "gfx/hud/messages/icons/msgicon_relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 30) && (slotdozens < 40))
			DImage2(slot_realrelicpos4, "gfx/hud/messages/icons/msgicon_relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 40) && (slotdozens < 50))
			DImage2(slot_realrelicpos4, "gfx/hud/messages/icons/msgicon_relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotdozens >= 50)
			DImage2(slot_realrelicpos4, "gfx/hud/messages/icons/msgicon_relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotunits >= 1) && (slotunits < 2))
			DImage2(slot_realrelicpos5, "gfx/hud/messages/icons/msgicon_relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 2) && (slotunits < 3))
			DImage2(slot_realrelicpos5, "gfx/hud/messages/icons/msgicon_relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 3) && (slotunits < 4))
			DImage2(slot_realrelicpos5, "gfx/hud/messages/icons/msgicon_relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 4) && (slotunits < 5))
			DImage2(slot_realrelicpos5, "gfx/hud/messages/icons/msgicon_relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotunits >= 5)
			DImage2(slot_realrelicpos5, "gfx/hud/messages/icons/msgicon_relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

	}

	string ring_artifact, ring_artifact2, ring_artifact3, timer_artifact;
	string ring_tether, ring_tether2, ring_tether3;
	//DImage(artr1,"gfx/hud/rings.tga",1,artr2,'1 1 1','160 60 0');
	local float radialactive, radialtime, tether_time,tetheractive;
	radialactive = getstatf(STAT_RADIALACTIVE);
	tetheractive = getstatf(STAT_RD_ST);
	
	radialtime = getstatf(STAT_ARTIFACTTIME);
	tether_time = getstatf(STAT_TETHERTIME);
	vector spos;
	spos_x = artr1_x + 9 + artic_x;
	spos_y = artr1_y + 5 + artic_y;
	
	ring_tether = "gfx/hud/cooldown/soul_tether_hud.tga";
	ring_tether2 = "gfx/hud/cooldown/soul_tether_pulseA.tga";
	ring_tether3 = "gfx/hud/cooldown/soul_tether_pulseB.tga";
	DImage(spos, ring_tether, 1, artns, '1 1 1', '64 64 0');


	float infinitesaves = cvar("infinite_saves");
	if (infinitesaves != 1)
	{
		if(tetheractive < 10)
		{		
			string ns1 = strcat("gfx/artifactmenu/artifact_num", ftos(tetheractive), ".tga");
			DImage2(spos + artn, ns1, 1, artrns, '1 1 1', '8 8 0', radialflag);
		}
		else
		{
			string ns2 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(tetheractive), 1, 1), ".tga");
			string ns3 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(tetheractive), 0, 1), ".tga");

			spos -= '4 0 0';
			DImage2(spos + artn, ns3, 1, artrns, '1 1 1', '8 8 0', radialflag);
			DImage2(spos + artn + '6 0 0', ns2, 1, artrns, '1 1 1', '8 8 0', radialflag);
			spos += '4 0 0';
		}
	}
	if(tether_time > 0)
	{
		local float stntimer, st_ralpha;
		stntimer = tether_time;
		if (stntimer == 136)
			stalphaflag = 1;
		if (stntimer >= 137)
		{
			if (stntimer == 137)
			{
				stalphaflag = 1;
				st_ralpha = 1;
			}
			if (stntimer == 138)
				st_ralpha = 1;
			if (stntimer == 139)
			{
				stalphaflag = -1;
				st_ralpha = 0;
			}
			if (stntimer == 140)
				st_ralpha = 0;
			if (stntimer == 141)
				st_ralpha = 0;
			if (stntimer == 142)
			{
				st_ralpha = 0;
				stalphaflag = 0;
			}
			DImage(spos, ring_tether, st_ralpha, artns, '1 1 1', '64 64 0');
			if ((stntimer >= 137) && (stntimer <= 138))
				DImage(spos, ring_tether2, stalpha, artns, '1 1 1', '64 64 0');
			if (stntimer >= 139)
				DImage(spos, ring_tether3, stalpha, artns, '1 1 1', '64 64 0');
			//drawstring ('0 0 0', ftos(stntimer),'12 12 0', '1 1 1', 1, 0);
		}
		else
		{
			st_ralpha = 1;
			DImage(spos, ring_tether, st_ralpha, artns, '1 1 1', '64 64 0');
		}
	}

	if ((radialactive  == 2)&& (radialtime > 0))
	{
		appparatus_using = 1;	
			drawfill('0 0 0', vid_width *'1 0 0' + vid_height *'0 1 0', '0 0 0.25', 0.25 * appparatus_flash, 0);
	}
	else
		appparatus_using = 0;
	if (radialactive >= 1)
	{

		if (radialactive == 1) ring_artifact = "gfx/hud/cooldown/artifactA_hud.tga";
		if (radialactive == 2) ring_artifact = "gfx/hud/cooldown/artifactB_hud.tga";
		if (radialactive == 3) ring_artifact = "gfx/hud/cooldown/artifactC_hud.tga";
		if (radialactive == 4) ring_artifact = "gfx/hud/cooldown/artifactD_hud.tga";
		if (radialactive == 5) ring_artifact = "gfx/hud/cooldown/artifactE_hud.tga";
		if (radialactive == 6) ring_artifact = "gfx/hud/cooldown/artifactF_hud.tga";
		if (radialactive == 7) ring_artifact = "gfx/hud/cooldown/artifactG_hud.tga";
		if (radialactive == 8) ring_artifact = "gfx/hud/cooldown/artifactH_hud.tga";
		if (radialactive == 9) ring_artifact = "gfx/hud/cooldown/artifactI_hud.tga";
		if (radialactive == 10) ring_artifact = "gfx/hud/cooldown/artifactJ_hud.tga";
		if (radialactive == 1) ring_artifact2 = "gfx/hud/cooldown/artifactA_pulseA.tga";
		if (radialactive == 2) ring_artifact2 = "gfx/hud/cooldown/artifactB_pulseA.tga";
		if (radialactive == 3) ring_artifact2 = "gfx/hud/cooldown/artifactC_pulseA.tga";
		if (radialactive == 4) ring_artifact2 = "gfx/hud/cooldown/artifactD_pulseA.tga";
		if (radialactive == 5) ring_artifact2 = "gfx/hud/cooldown/artifactE_pulseA.tga";
		if (radialactive == 6) ring_artifact2 = "gfx/hud/cooldown/artifactF_pulseA.tga";
		if (radialactive == 7) ring_artifact2 = "gfx/hud/cooldown/artifactG_pulseA.tga";
		if (radialactive == 8) ring_artifact2 = "gfx/hud/cooldown/artifactH_pulseA.tga";
		if (radialactive == 9) ring_artifact2 = "gfx/hud/cooldown/artifactI_pulseA.tga";
		if (radialactive == 10) ring_artifact2 = "gfx/hud/cooldown/artifactJ_pulseA.tga";
		if (radialactive == 1) ring_artifact3 = "gfx/hud/cooldown/artifactA_pulseB.tga";
		if (radialactive == 2) ring_artifact3 = "gfx/hud/cooldown/artifactB_pulseB.tga";
		if (radialactive == 3) ring_artifact3 = "gfx/hud/cooldown/artifactC_pulseB.tga";
		if (radialactive == 4) ring_artifact3 = "gfx/hud/cooldown/artifactD_pulseB.tga";
		if (radialactive == 5) ring_artifact3 = "gfx/hud/cooldown/artifactE_pulseB.tga";
		if (radialactive == 6) ring_artifact3 = "gfx/hud/cooldown/artifactF_pulseB.tga";
		if (radialactive == 7) ring_artifact3 = "gfx/hud/cooldown/artifactG_pulseB.tga";
		if (radialactive == 8) ring_artifact3 = "gfx/hud/cooldown/artifactH_pulseB.tga";
		if (radialactive == 9) ring_artifact3 = "gfx/hud/cooldown/artifactI_pulseB.tga";
		if (radialactive == 10) ring_artifact3 = "gfx/hud/cooldown/artifactJ_pulseB.tga";

		if (radialactive == 20) ring_artifact = "gfx/hud/cooldown/sigil_flight_hud.tga";
		if (radialactive == 20) ring_artifact2 = "gfx/hud/cooldown/sigil_flight_pulseA.tga";
		if (radialactive == 20) ring_artifact3 = "gfx/hud/cooldown/sigil_flight_pulseB.tga";
		if (radialactive == 21) ring_artifact = "gfx/hud/cooldown/sigil_displacement_hud.tga";
		if (radialactive == 21) ring_artifact2 = "gfx/hud/cooldown/sigil_displacement_pulseA.tga";
		if (radialactive == 21) ring_artifact3 = "gfx/hud/cooldown/sigil_displacement_pulseB.tga";
		if (radialactive == 22) ring_artifact = "gfx/hud/cooldown/sigil_wrath_hud.tga";
		if (radialactive == 22) ring_artifact2 = "gfx/hud/cooldown/sigil_wrath_pulseA.tga";
		if (radialactive == 22) ring_artifact3 = "gfx/hud/cooldown/sigil_wrath_pulseB.tga";

		//spos_x = spos_x;
		spos_x = arti_pos_x + 9 + artic_x;
		spos_y = arti_pos_y + 5 + artic_y;
		float artifact_count;

		if (radialactive == 1)artifact_count  =  getstatf(STAT_RD_MR);
		if (radialactive == 2)artifact_count = getstatf(STAT_RD_DA);
		if (radialactive == 3)artifact_count = getstatf(STAT_RD_BE);
		if (radialactive == 4)artifact_count = getstatf(STAT_RD_CA);
		if (radialactive == 5)artifact_count = getstatf(STAT_RD_VG);
		if (radialactive == 6)artifact_count = getstatf(STAT_RD_LS);
		if (radialactive == 7)artifact_count = getstatf(STAT_RD_TR);
		if (radialactive == 8)artifact_count = getstatf(STAT_RD_AE);
		if (radialactive == 9)artifact_count = getstatf(STAT_RD_VI);
		if (radialactive == 10)artifact_count = getstatf(STAT_RD_RF);

		if (radialtime > 0)
		{


			local float ntimer, artalpha;
			ntimer = radialtime;
			local string nametimer;
			nametimer = ftos(ntimer);
			timer_artifact = strcat("gfx/hud/cooldown/cd", nametimer, ".tga");
			local float da_alpha;
			if (ntimer <= 134)
				da_alpha = 1;
			if (ntimer == 134)
				da_alpha = 0.9;
			if (ntimer == 135)
				da_alpha = 0.8;
			if (ntimer == 136)
			{	
				blalphaflag = 1;
					da_alpha = 0.7;
			 }
			if (ntimer >= 137)
			{
				timer_artifact = "gfx/hud/cooldown/cd136.tga";
				if (ntimer == 137)
				{
					blalphaflag = 1;
					da_alpha = 0.6;
					artalpha = 1;
				}

				if (ntimer == 138)
				{
					artalpha = 0.5;
					da_alpha = 0.5;
					//blalpha = 1;
				}
				if ((ntimer >= 139)&& (artifact_count > 0))	
					DImage(spos, ring_artifact, 1, artics, '1 1 1', '64 64 0');

				if (ntimer == 139)
				{
					da_alpha = 0.4;
					blalphaflag = -1;
					artalpha = 0;
				}

				if (ntimer == 140)
				{
					da_alpha = 0.3;
					artalpha = 0;
				}

				if (ntimer == 141)
				{
					da_alpha = 0.2;
					artalpha = 0;
				}

				if (ntimer == 142)
				{
					da_alpha = 0.1;
					artalpha = 0;
					blalphaflag = 0;
				}

				DImage2(spos, timer_artifact, artalpha, artics, '1 1 1', '64 64 0', 0);
				DImage(spos, ring_artifact, artalpha, artics, '1 1 1', '64 64 0');

				if ((ntimer >= 137) && (ntimer <= 138))
				{
					DImage(spos, ring_artifact2, blalpha, artics, '1 1 1', '64 64 0');
				}

				if (ntimer >= 139)
				{
					DImage(spos, ring_artifact3, blalpha, artics, '1 1 1', '64 64 0');
					if (radialactive != 5)
					{
						DImage(spos, "gfx/hud/cooldown/cd_pulse.tga", blalpha, artics, '1 1 1', '64 64 0');
					}
				}
			}
			else
			{
				artalpha = 1;
				if (radialactive != 5)
				{
					DImage2(spos, timer_artifact, artalpha, artics, '1 1 1', '64 64 0', 0);
				}

				DImage(spos, ring_artifact, artalpha, artics, '1 1 1', '64 64 0');
			}
			if (radialactive == 2)
			drawpic('0 0 0', "models/artifacts/active/drowners_apparatus_active.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', da_alpha, 0);
		}
		else
		{
			if ((radialactive >= 1) && (radialactive <= 10))
			{
				vector pulseicon;
				pulseicon_x = nexartifacticon * 0.1;
				pulseicon_y = nexartifacticon * 0.1;
				pulseicon_z = nexartifacticon * 0.1;

				DImage(spos, ring_artifact, 1, artics, pulseicon, '64 64 0');
			}
			else
				DImage(spos, ring_artifact, 1, artics, '1 1 1', '64 64 0');
			old_artifact_count = artifact_count;
		}
		if ((radialactive  >= 1))
		{	

			if(artifact_count <= 0)
			return;
			if(artifact_count < 10)
			{		
				string rns1 = strcat("gfx/artifactmenu/artifact_num", ftos(artifact_count), ".tga");
				DImage2(spos + artin, rns1, 1, artrns, '1 1 1', '8 8 0', radialflag);
			}
			else
			{
				string rns2 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(artifact_count), 1, 1), ".tga");
				string rns3 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(artifact_count), 0, 1), ".tga");

				spos -= '4 0 0';
				DImage2(spos + artin, rns3, 1, artrns, '1 1 1', '8 8 0', radialflag);
				DImage2(spos + artin + '6 0 0', rns2, 1, artrns, '1 1 1', '8 8 0', radialflag);
			}
		}	

	}

};
//vector view_origin;

//	view_origin = pmove_org + '0 0 1' * getstati(STAT_VIEWHEIGHT);

float dmues;

//string v_sfps;
float vshift_alreadychecked;
vector locked_viewangle;
vector view_origin;

float aspectratiomode;
void CSQC_UpdateView(float b, float c)
{
	static float oldtime;
	cltime = gettime(GETTIME_FRAMESTART);
	clframetime = oldtime ? cltime - oldtime : 0.1;
	oldtime = cltime;
	float wdscreen, vwframe, ennframe, ennhealth;
	string vframe, enemyhealth, enemyclass;
	local entity e;
	vid_width = cvar("vid_conwidth");
	vid_height = cvar("vid_conheight");
	vid_rwidth = cvar("vid_width");
	vid_rheight = cvar("vid_height");
	view_angles = getpropertyvec(VF_ANGLES);
	view_origin = getpropertyvec(VF_ORIGIN);
	viewmodel_angles = '0 0 0'; // no viewmodel offset angles for now
	viewmodel_origin = '0 0 0'; // no viewmodel offset origin for now

	input_frame(); // input handler

	float vid_ratio;
	vid_ratio = vid_rwidth / vid_rheight;
	aspectratio_fix_x = (1.7777777777777777 - (vid_rwidth / vid_rheight)) *202.5;
	aspectratio_fix_y = (0.5265 - (vid_rheight / vid_rwidth)) *202.5;

	// Reki: Hud Scaling
	#define HUD_W	720
	#define HUD_H	450
	float hud_scaling = 1;
	vector hud_ratio = [vid_width / HUD_W, vid_height / HUD_H];
	if (hud_ratio[0] > hud_ratio[1]) // we do these hacky functions to preserve integer scaling, there's undoubtedly a better way
	{	// 16:9
		if (vid_height < HUD_H) // ultrawide but small
			hud_scaling = 0.5;
		else if (vid_width <= HUD_W * 0.4) // teeny tiny screen
			hud_scaling = vid_width / HUD_W;
		else if (vid_width < 640) // we want < 1280p because of steamdeck support
			hud_scaling = 0.5;
		else
			hud_scaling = max(1, min(floor((vid_width / HUD_W) * 2) / 2, floor((vid_height / HUD_H) * 2) / 2));
	}
	else
	{	// 4:3, 5:4, or similar
		if (vid_height <= HUD_H * 0.4) // teeny tiny screen
			hud_scaling = vid_height / HUD_H;
		else if (vid_height < 400) // we want < 800p because of steamdeck support
			hud_scaling = 0.5;
		else
			hud_scaling = max(1, min(floor((vid_height / HUD_H) * 2) / 2, floor((vid_width / HUD_W) * 2) / 2));
	}
	if (autocvar_scr_hudscale > 0)
		hud_scaling = autocvar_scr_hudscale;
	ui_scale = [hud_scaling, hud_scaling];
	//

	// ALWAYS Clear Current Scene First
	// Assign Standard Viewflags
	// Setup Entities to be Rendered (include all base types; normal, engine and viewmodels)

	vx_rel = ((vid_width / 960));
	vy_rel = ((vid_height / 540));

	float hidehud;
	hidehud = floor(getstatf(STAT_THWOFG));



local vector angulos, origen;

	static vector radial_viewmodel_ang;
	static float radial_viewmodel_frac;

	rmenu = getstatf(STAT_RMENU);
	showjournal = getstatf(STAT_JOURNAL);
	if (rmenu && rmenualpha >= 0.5)
	{
		vector force_ang = locked_viewangle;
		force_ang[0] += radial_pos[1] * 0.15;
		force_ang[1] += radial_pos[0] * -0.15;
		radial_viewmodel_ang = (force_ang - locked_viewangle);
		radial_viewmodel_frac = 1;

		setproperty(VF_CL_VIEWANGLES, force_ang);
		view_angles = force_ang;
		view_angles[2] = getproperty(VF_ANGLES_Z);
	}
	else
	{
		if (radial_viewmodel_frac > 0)
			radial_viewmodel_frac = max(0, radial_viewmodel_frac - (frametime * 17));

		locked_viewangle = getpropertyvec(VF_CL_VIEWANGLES);
		if (rmenualpha <= 0)
		{
			radial_pos = 0;
			if (radial_selected)
			{
				localcmd(sprintf("impulse %g\n", 20 + radial_selected));
				radial_selected = 0;
			}
		}
	}

	// Reki (August 28 2023): Radial menu viewmodel angles
	if (radial_viewmodel_frac > 0)
	{
		viewmodel_angles -= radial_viewmodel_ang * slerp(0, 1, radial_viewmodel_frac);
	}

	// Reki (August 28 2023): Replace v_idlescale stuffcmd with something a bit less nauseating and not stuffcmd-y
	static float sigilofwrath_effect_intensity;
	if (getstatf(STAT_WRATHACTIVE))
	{
		if (sigilofwrath_effect_intensity < 1)
			sigilofwrath_effect_intensity = min(1, sigilofwrath_effect_intensity + (clframetime * 8));
	}
	else if (sigilofwrath_effect_intensity > 0)
	{
		sigilofwrath_effect_intensity = max(0, sigilofwrath_effect_intensity - (clframetime * 5));
	}

	if (sigilofwrath_effect_intensity > 0)
	{
		float intensity = slerp(0, 1, sigilofwrath_effect_intensity);
		vector start_viewang = view_angles;
		vector start_vieworg = view_origin;

		view_angles[2] += cos(time * 0.5) * 2 * intensity;
		view_origin[0] += sin((time + 0.3) * 1) * 1.1 * intensity;
		view_origin[1] += sin(-(time + 0.6) * 1) * 1.1 * intensity;
		view_origin[2] += sin(time * 0.5) * 0.8 * intensity;

		viewmodel_origin -= (view_origin - start_vieworg) * 0.1;
		viewmodel_angles -= (view_angles - start_viewang);
	}
	//

	clearscene();
	// Draw the World (and sky)
	setproperty(VF_DRAWWORLD, 1);
	// Draw the Crosshair
	setproperty(VF_DRAWCROSSHAIR, 0);
	// Draw the Engine Status Bar (the default Quake HUD)
	setproperty(VF_DRAWENGINESBAR, 0);
	// set angles to our possibly modified angles
	setproperty(VF_ANGLES, view_angles);
	// set origin to our possibly modified position
	setproperty(VF_ORIGIN, view_origin);
	// set saturation from SSQC
	if (hidehud <= 0)
		setproperty(VF_SATURATION, getstatf(STAT_SATURATION));
	// run viewmodel bob logic
	Viewmodel_CalculateMovement();

	addentities(MASK_NORMAL | MASK_ENGINE);

	if (hidehud == 3)
	{

		float stat_angles_x = getstatf(CAM_ANG_X);
		float stat_angles_y = getstatf(CAM_ANG_Y);
		float stat_angles_z = getstatf(CAM_ANG_Z);
		float stat_origin_x = getstatf(CAM_ORG_X);
		float stat_origin_y = getstatf(CAM_ORG_Y);
		float stat_origin_z = getstatf(CAM_ORG_Z);
		setproperty(VF_ORIGIN_X, stat_origin_x);
		setproperty(VF_ORIGIN_Y, stat_origin_y);
		setproperty(VF_ORIGIN_Z, stat_origin_z);
		setproperty(VF_ANGLES_X, stat_angles_x);
		setproperty(VF_ANGLES_Y, stat_angles_y);
		setproperty(VF_ANGLES_Z, stat_angles_z);
		vector angulos, origen;
		angulos_x = stat_angles_x;
		angulos_y = stat_angles_y;
		angulos_z = stat_angles_z;
		origen_x = stat_origin_x;
		origen_y = stat_origin_y;
		origen_z = stat_origin_z;
		makevectors(angulos);
		SetListener(origen, v_forward, v_right, v_up);

		// Reki (January 8 2024): consistent camera fov (yoinked from DOOMBRINGER, originally added by andrew apted)
		const float h_fov = 90;
		local float frustumy = tan(h_fov * M_PI / 360.0) * 0.75;
		local float frustumx = frustumy * vid_width / vid_height / cvar("vid_pixelheight");
	
		local float fovx = atan(frustumx) * 360.0 / M_PI;
		local float fovy = atan(frustumy) * 360.0 / M_PI;
	
		setproperty(VF_FOVX, fovx);
		setproperty(VF_FOVY, fovy);
	}
	
	renderscene();


	if (vid_height == 540)
		aspectratiomode = 1;
	if (vid_height == 720)
		aspectratiomode = 2;
	if (vid_height == 768)
		aspectratiomode = 3;

	bbar += (frametime) *10;
	if (bbar > 19)
		bbar = 0;
	bbar = bbar + frametime * 12;
	if ((bbar >= 0) && (bbar < 1))
		shd = ("gfx/ray");
	else if ((bbar >= 1) && (bbar < 2))
		shd = ("gfx/ray2");
	else if ((bbar >= 2) && (bbar < 3))
		shd = ("gfx/ray3");
	else if ((bbar >= 3) && (bbar < 4))
		shd = ("gfx/ray4");

	shd2 = ("gfx/light.tga");
	if (bbar >= 4)
	{
		bbar = 0;
		rndm = random() *0.5 + 1.5;
	}

/*	float wlightning;

	wlightning = rint(getstatf(STAT_WLIGHTNING));
	vector lorg, ldest, ldorg;

	vector lb, lbd;

	vector spos, sposd, align;
	spos_x = 300;
	spos_y = 100;
	spos_z = -60;
	sposd_x = 370;
	sposd_y = 100;
	sposd_z = -60;
	align_x = 240;
	align_y = vid_height - 27;
	spos_x = spos_x + align_x;
	spos_y = spos_y + align_y;
	spos_z = spos_z + align_z;
	sposd_x = sposd_x + align_x;
	sposd_y = sposd_y + align_y;
	sposd_z = sposd_z + align_z;

	lorg = cs_unproject(spos);

	ldorg = cs_unproject(sposd);

	ldest_x = getstatf(STAT_LDX);
	ldest_y = getstatf(STAT_LDY);
	ldest_z = getstatf(STAT_LDZ);

	lb_x = getstatf(STAT_LOX);
	lb_y = getstatf(STAT_LOY);
	lb_z = getstatf(STAT_LOZ);

	lbd_x = getstatf(STAT_LODX);
	lbd_y = getstatf(STAT_LODY);
	lbd_z = getstatf(STAT_LODZ);

	lorg = (lb + lorg) *0.5;
	ldorg = (lbd + ldorg) *0.5;

	if (wlightning == 1)
	{
		lbeam(lorg_x, lorg_y, lorg_z, ldest_x, ldest_y, ldest_z, '1 1 1', ldorg_x, ldorg_y, ldorg_z);
	}

	if (wlightning == 2)
	{
		railbeam(lorg_x, lorg_y, lorg_z, ldest_x, ldest_y, ldest_z, '1 1 1', ldorg_x, ldorg_y, ldorg_z);
		arailb = (arailb - frametime) *0.8;
	}
	else
	{
		if (arailb != 2)
			arailb = 2;
	}
*/
	//////////////////	
	//float sorete = getproperty(VF_FOG_DENSITY);
	//drawstring('0 0 0', ftos(sorete), '20 20 0', '1 1 1', 1, 0);
	inventory_active = rmenu;
	wdscreen = getstatf(STAT_WRATHDEBUGSCREEN);
	if (wdscreen == 1)
	{
		vwframe = getstatf(STAT_VWEAPONFRAME);
		ennhealth = getstatf(STAT_ENHEALTH);
		ennframe = getstatf(STAT_ENFRAME);
		vframe = strcat("weapon frame: ", ftos(vwframe));
		enemyhealth = strcat("enemy health: ", ftos(ennhealth));
		enemyclass = strcat("enemy frame: ", ftos(ennframe));
		DString('-150 -50 0', vframe, 1, 2, '3 1 1', '10 10 0');
		DString('-150 -90 0', enemyclass, 1, 2, '3 1 1', '10 10 0');
		DString('-150 -70 0', enemyhealth, 1, 2, '3 1 1', '10 10 0');

		/*
		vector player_org;
		player_org_x =  getstatf(STAT_X);
		player_org_y =  getstatf(STAT_Y);
		player_org_z =  getstatf(STAT_Z);
		*/
		DString('-150 10 0', vtos(pmove_org), 1, 2, '1 1 3', '10 10 0');

//		DrawSheet('-150 -130 0', "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',20);
		//DrawSheet('-150 -0 0', "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',4);
		//DrawSheet('-150 30 0', "gfx/hud/health_sheet.tga",'280 360 0', '28 36 0',36);

//void( vector pos,string pic, vector imgsize, vector slotsize, float slotnumber) DrawSheet = 

	}

	float fclframetime = gettime(2);
	if(!fclframetime)
	fclframetime = 0.002;

	float vfpsmultiplier;
	if(fclframetime > 0)
	vfpsmultiplier = (1 + ((300 - (1 / fclframetime)) / 220));
	else
	vfpsmultiplier = 1;
	float vfps = 60 + 30 * vfpsmultiplier;
	
	if(fclframetime > 0)
	{
	if (1 / fclframetime > 100)
		vfps = 60;
	}
	//	drawstring('0 0 0', ftos (fclframetime), '8 8 0', '12 12 0', 1, 0);     	// Draw the "cursor"

	float v_sfps = vfps / ((rint(1 / (fclframetime + 0.1))));

	local float shrinew;
	shrinew = floor(getstatf(STAT_SHRINE));
	




	local float f, dm;
	f = getstati(STAT_HEALTH);
	dm = floor(getstatf(STAT_DEADMENU));
	if (/*(f <= 0) && */(dm == 1) && FALSE)
	{
		if (theter_alreadychecked != 1)
		{
			write_tether();
			check_tether();
			check_shrine_user();
			
			if((shrinepresent <= 0) && (shrine_user >  0))
			shrinepresent = 1;
			mm2 = 0;
			setcursormode(1);
			localcmd("crosshair 0\n");
			localcmd("scratch3 1\n");
			if (tether >= 1)
				DMselected = 1;
			else if (shrinepresent >= 1)
				DMselected = 2;
			else
				DMselected = 3;
			theter_alreadychecked = 1;
		}

		if(f < 0)
		{
		if (dmenualpha < 1)
			dmenualpha += v_sfps / 1200;
		else
			dmenualpha = 1;
		}
		else
			dmenualpha = 1;
		if (vshift_alreadychecked != 1) 
		{
			if ((dmenualpha == 1) && (f < 0))
				localcmd("v_cshift\n");
			vshift_alreadychecked = 1;
		}

		//Death_Menu();
	}
	else
	{
	
		if (dmenualpha > 0)
			dmenualpha = 0;
			
		if (vshift_alreadychecked == 1)
		vshift_alreadychecked = 0;
		/*
		if (theter_alreadychecked == 1)
		{
			theter_alreadychecked = 0;
			setcursormode(0);
			localcmd("crosshair 1\n");
			localcmd("scratch3 0\n");
		}
		*/

		//float showjournal;
		if (showjournal == 2)
		{
			if (mrmenualpha < 1)
				mrmenualpha += clframetime * 5;
		}
		else
		{
			if (mrmenualpha > 0)
				mrmenualpha -= clframetime * 5;
			else
				mrmenualpha = 0;
		}

		if ((rmenu == 1))
		{
		
			if(slot_timer > 0)
			slot_timer -= clframetime * 5;
			if (rmenualpha < 1)
				rmenualpha += clframetime * 5;
		}
		else
		{
			if (rmenualpha > 0)
				rmenualpha -= clframetime * 5;
			else
				rmenualpha = 0;
		}

		float wch;
		wch = floor(getstatf(STAT_CROSSHAIR));

		if (wch & 1)
		{
			if (crosshairalpha < 1.1)
				crosshairalpha += clframetime * 10;
		}
		else
		{
			if (crosshairalpha > -0.1)
				crosshairalpha -= clframetime * 5;
		}

		if (wch & 2)
		{
			if (crosshairalpha2 < 1.1)
				crosshairalpha2 += clframetime * 10;
		}
		else
		{
			if (crosshairalpha2 > -0.1)
				crosshairalpha2 -= clframetime * 5;
		}

		if (blalphaflag == 0)
			blalpha = 0;
		if (blalphaflag == 1)
			blalpha += clframetime * 5;
		if (blalphaflag == -1)
			blalpha -= clframetime *7.5;

		if (stalphaflag == 0)
			stalpha = 0;
		if (stalphaflag == 1)
			stalpha += clframetime * 5;
		if (stalphaflag == -1)
			stalpha -= clframetime *7.5;


		if(pulsehealth_icon == 1)
			phicon += clframetime * 27;
		else
			phicon = 0;

		float fhealth = getstati(STAT_HEALTH);
		if(fhealth <= 30)
		{
			float frametime_cnt = 20;
			if(fhealth < 20)
				frametime_cnt = 27;
			if(fhealth < 10)
				frametime_cnt = 34;
		
			if(pulsehealth_low_int == 0)
			{
				if(pulsehealth_low > 10)
					pulsehealth_low_int = 1;	
				pulsehealth_low += clframetime * frametime_cnt;
			}
			else
			{
				if(pulsehealth_low <= 0)
					pulsehealth_low_int = 0;	
				pulsehealth_low -= clframetime * frametime_cnt;
			}
		}
	

		if(nexartifacticon_int == 2)
		{
			float frametime_cnt = 50;
			if(nexartifacticon > 10)
				nexartifacticon -= clframetime * frametime_cnt;
				
			if(nexartifacticon <= 10)
			{
				nexartifacticon = 10;
				nexartifacticon_int = 1;
			}
		}

		else
		{
			if ((rmenualpha >= 1) && (inventory_active))
			{
				float frametime_cnt = 10;

				if(nexartifacticon_int == 0)
				{
					if(nexartifacticon > 10)
						nexartifacticon_int = 1;	
					nexartifacticon += clframetime * frametime_cnt;
				}
				else
				{
					if(nexartifacticon <= 5)
						nexartifacticon_int = 0;	
					nexartifacticon -= clframetime * frametime_cnt;
				}
			}
			else
			{

				if(nexartifacticon <= 10)
					nexartifacticon = 10;
			}
		}
		if(appparatus_using == 1)
		{
			if(appparatus_flash >= 1)
				appparatus_flash = 1;
			else
				appparatus_flash += clframetime;
		}
		else
			appparatus_flash = 0;
		
		if(pulseammo_icon == 1)
			ammphicon += clframetime * 27;
		else
			ammphicon = 0;

		if(pulsearmor_icon == 1)
			arphicon += clframetime * 27;
		else
			arphicon = 0;

		if(pulsedarmor_icon == 1)
			drphicon += clframetime * 27;
		else
			drphicon = 0;


		float dmg_indicator;
		dmg_indicator = floor(getstatf(STAT_DAMAGESCREEN));

		if (dmg_indicator & 2)
			dmu = 1;
		if (dmg_indicator & 1)
		//		{dmu -= clframetime;drawpic('240 0 0',"gfx/hud/di_top.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dmu, 0);}

		{
			dmu -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_top.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmu, 0);
		}
		else
			dmu = 1;

		if (dmg_indicator & 8)
			dmd = 1;
		if (dmg_indicator & 4)
		//	{dmd -= clframetime;drawpic('240 270 0',"gfx/hud/di_bottom.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dmd, 0);}

		{
			dmd -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_bottom.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmd, 0);
		}
		else
			dmd = 1;

		if (dmg_indicator & 32)
			dml = 1;
		if (dmg_indicator & 16)
		//	{dml -= clframetime;drawpic('0 135 0',"gfx/hud/di_left.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dml, 0);}

		{
			dml -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_left.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dml, 0);
		}
		else
			dml = 1;

		if (dmg_indicator & 128)
			dmr = 1;
		if (dmg_indicator & 64)
		//	{dmr -= clframetime ;drawpic('480 135 0',"gfx/hud/di_right.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dmr, 0);}

		{
			dmr -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_right.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmr, 0);
		}
		else
			dmr = 1;

		if (removingmessages > 0)
			removingmessages -= v_sfps / 100;
		else
			removingmessages = 0;

		#if 0 // Reki (October 6 2023): Moved this to the new hud system to fix aspect ratio issues
		float checked5;
		checked5 = cvar("saved1");
		if (checked5 != 1)
			Crosshair();
		#endif
		
		if (showjournal == 1)
		{
			if(deathmatch == 1)
			showscores = 1;
			else
			{
				/*
				using_cursor = 1;
				setcursormode(1);
				show_journal_ui();
				*/
				if (!journal_chapter)
					journal_chapter = 1;
				if (!journal_firstopen)
				{
					journal_firstopen = TRUE;
					Journal_ScrollToCurrentMap();
				}
			}
		}
		else if (showjournal == 2)
		{
			//if(deathmatch == 1)
			//	showscores = 0;
			//else
			{
				show_messages_ui();
				journal_page_maps = 0;
			}
		}
		else
		{
			float health = getstati(STAT_HEALTH);
			if((deathmatch == 1))
				showscores = 0;		
			else
			{
				journal_firstopen = FALSE;
			}
			/*	
			if (using_cursor == 1)
			{
				if (journal_chapter)
					journal_chapter = 0;
				if (journal_page)
					journal_page = 0;
				if (journal_page_maps)
					journal_page_maps = 0;
				using_cursor = 0;
				setcursormode(0);
			}
			*/
		}

		//{
		float showingmessageshud;
		showingmessageshud = getstati(STAT_TIME_HUDMESSAGE);

		if ((showingmessageshud <= 0) && (hud_messages > 0))
			hud_messages = 0;




		if (showscores == 1)
		{
			if (mpalpha < 1)
				mpalpha += clframetime * 5;
		}
		else
		{
			if (mpalpha > 0)
				mpalpha -= clframetime * 5;
			else
				mpalpha = 0;
		}


		if((showscores == 1) && (deathmatch == 1))
		{

			draw_multiplayer_scoreboard();
		}

		//
		if (ui_usemouse && !ui_oldusemouse)
		{
			setcursormode(1);
			thumbstick_mouse = [cvar("vid_conwidth") / 2, cvar("vid_conheight") / 2];
		}
		else if (!ui_usemouse && ui_oldusemouse)
			setcursormode(0);
		ui_oldusemouse = ui_usemouse;
		//

		//if (hidehud == 0)
		{
			//ArtifactMenu();
			//Ammo_Hud();
			//Hud_Armor();
			//Hud();
			e = self;
			for (self = world;
				(self = nextent(self));)
				if (self.draw2d)
					self.draw2d();
			self = e;
			
			// Reki: Update journal stats
			jitems_armory = getstati(STAT_ITEMS);
			jitems_bestiary = getstatf(STAT_JOURNAL_MESSAGESM);
			jitems_visitedmaps = getstatf(STAT_SPOTTED_MAPS);
			jitems_relics = getstatf(STAT_FOUND_RELICS);
			jitems_notes = getstatf(STAT_JOURNAL_MESSAGES);
			jitemsb_notes = getstatf(STAT_JOURNAL_MESSAGESB);
			//jitems_notes = jitemsb_notes = jitems_relics = jitems_visitedmaps = jitems_armory = jitems_bestiary = 0xFFFFFF;
			// Reki: Draw UI elements
			//if (ui_usemouse)
			//	drawfill('0 0 0', [vid_width, vid_height], '0 0 0', 0.65, 0);
			
			// Reki: Zoom hud fadeout
			#define HUDALPHA_SPEED 2.5
			#define HUDALPHA_STEPS 4
			static float hud_alpha;
			float hud_alpha_wanted = 1;
			hud_alpha_wanted *= getstatf(STAT_ZOOM); // zoom
			if (getstati(STAT_HEALTH) <= 0) // health
				hud_alpha_wanted = 0;
			else if (getstatf(STAT_JOURNAL))
				hud_alpha_wanted = 0;

			hud_alpha_wanted = bound(0, hud_alpha_wanted, 1);
			if (hud_alpha < hud_alpha_wanted)
				hud_alpha = min(hud_alpha_wanted, hud_alpha + (clframetime * HUDALPHA_SPEED * 1.1));
			else
				hud_alpha = max(hud_alpha_wanted, hud_alpha - (clframetime * HUDALPHA_SPEED));
			
			if (hidehud > 0) // if we should hide the hud, do it!
				hud_alpha = 0;
			
			ui_hud.alpha = slerp(0, 1, hud_alpha);
			ui_hud.alpha = round(ui_hud.alpha * HUDALPHA_STEPS) / HUDALPHA_STEPS;
			//

			ui_clipsize = '0 0';
			uielement_c old_hover = ui_hover;
			float old_usemouse = ui_usemouse;
			ui_hover = __NULL__;
			ui_mouseposition = getpointerpos();
			ui_usemouse = FALSE;
			ui_renderframe = TRUE;
			ui_alpha = 1;
			for(uielement_c ui_chain = ui_screen_queue; ui_chain; ui_chain = ui_chain._next)
			{
				UI_RenderElements(ui_chain);
			}
			if (!ui_usemouse)
				ui_hover = __NULL__;
			if (ui_hover != old_hover)
			{
				if (old_hover.m_leave)
					old_hover.m_leave(old_hover);
			}
			if (ui_hover && ui_hover.m_over)
				ui_hover.m_over(ui_hover);
			drawresetcliparea();
			ui_clipsize = '0 0';
			ui_renderframe = FALSE;
			//

			if (hud_messages >= 12)
				hud_messages = 0;
			
			if (dmues > 0)
			{
				dmues -= clframetime;
				drawpic('0 0 0', "gfx/splashes/endgame.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmues, 0);
			}
			
			if (ui_usemouse && getkeydest() == KEY_GAME)
				drawpic(ui_mouseposition, "gfx/cursor.tga", '20 20 0', '1 1 1', 1, 0);
		}

		//}
	}

	//drawpic([vid_width * 0.5, vid_height * 0.5] + radial_pos, "gfx/cursor.tga", '20 20 0', '1 1 1', 1, 0);

	float crt_active = cvar ("crt");
	if(crt_active > 0)
	{
		vector res;
		drawpic('0 0 0', "gfx/crt.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', crt_active, 0);
		res_x =  vid_width *0.5;
		drawpic('0 0 0' + res, "gfx/crt.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', crt_active, 0);
		res_y =  vid_height *0.5;
		drawpic('0 0 0'+ res, "gfx/crt.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', crt_active, 0);
		res = '0 0 0';
		res_y =  vid_height *0.5;
		drawpic('0 0 0'+ res, "gfx/crt.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', crt_active, 0);
	}
};

////////////////end of qc file
////////////////end of qc file
