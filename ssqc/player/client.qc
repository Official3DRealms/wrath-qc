	#include "localization.h"

.float deadwaiting;
.float oldwatertype;
.float melee_jump_time;
.float melee_released;
.float timefly;
.float watertype_time;
.float dmgtime;
.float underwaterdamaged;
.float location;
string fog_value;
void()soundbox_visible_toggle;
.float use_finished2;
.float restoredgame;
void() W_SetWeapon;
void() Think_Vweapon;
void() item_donor_forcethink;
void() item_donor_mapforcethink;
void()sigils_initializeambients;
void()enemy_spawner_warp_use;
void() info_player_start = {	//if(!self.location)
	//self.effects = 1024 + 128;
};
void() item_weapon_fixer;
void() info_player_deathmatch = {	//if(!self.location)
	//self.effects = 1024 + 128;
};
.float walking;
void() Player_Die;
void() ClientKill = { /*Player_Die();*/ };
void() ClientConnect = {
	self.hudsync = spawn();
	self.hudsync.owner = self;
	self.hudsync.SendEntity = SendEntity_HudSync;
	self.hudsync.effects = EF_NODEPTHTEST;			// stupid
	setmodel(self.hudsync, "models/misc/null.md3");	// DP shite

	Localization_ResendFileList(self);
};
void() ClientDisconnect = {
	if (self.hudsync)
	{
		remove(self.hudsync);
		self.hudsync = world;
	}
};
void() WeaponFrames;
void() raise_weapon;

.float hardstoptime;
void(string locsound, float rnd, float nchannel) playerwsound = 
{ 
	float r;
	float wvol = cvar ("weapons_fire_volume");
	string monstersound, rsound;
	r = floor(random() *rnd) + 1;
	if (r == self.chattersnd)
		r += 1;
	if (r > rnd)
		r = 1;
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	sound(self, nchannel, monstersound, wvol, 0.125);
};

void(string locsound, float rnd) playersound = 
{ 
    local float r;
	local string monstersound, rsound;
	r = floor(random() *rnd) + 1;
	if (r == self.chattersnd)
		r += 1;
	if (r > rnd)
		r = 1;
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	sound(self, CHAN_AUTO, monstersound, 1, 0.125);
};
void() check_infinite_saves = 
{
	float infinitesaves = cvar("infinite_saves");
	if (infinitesaves == 1)
	{	
		if(!(self.playerflags & FL_INFINITESAVES)) 
			self.playerflags += FL_INFINITESAVES;			
	}
	else
	{	
		if(self.playerflags & FL_INFINITESAVES) 
			self.playerflags -= FL_INFINITESAVES;			
	}
};
void(string locsound, float rnd,float pitch) playersound7 = { local float r;
	local string monstersound, rsound;
	r = floor(random() *rnd) + 1;
	if (r == self.chattersnd)
		r += 1;
	if (r > rnd)
		r = 1;
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	sound7(self, CHAN_AUTO, monstersound, 1, 0.125,pitch,0);
};
.float psound_cnt;

void(string locsound, float rnd, float nchannel) playersound2 = { local float r;
	local string monstersound, rsound;

	r = floor(random() *rnd) + 1;
	if (r == self.psound_cnt)
		r += 1;
	if (r > rnd)
		r = 1;

	self.psound_cnt = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	sound(self, nchannel, monstersound, 1, ATTN_NORM);
};

void() delete_shrine = 
{ 
	local float writeparms;
	local string writethis;
	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/shrine.txt");
	writeparms = fopen(campaignloc, FILE_WRITE);	//open what file to use in write mode
	writethis = ftos(0);	//prepare the next thing to write
	fputs(writeparms, writethis);	//line 1
	fputs(writeparms, "\n");	//and again
	fclose(writeparms);
};

.float playerdeadtime;
void() PlayerDeathThink;
void(entity ownr) client_garbage_collector;
void() Player_Die = { 
	delete_shrine();
	if (self.health >= 0)
		self.health = -1;
	remove(self.vweapon);
	self.use = SUB_Null;
	self.solid = SOLID_CORPSE;
	self.takedamage = 0;
	self.movetype = MOVETYPE_TOSS;
	self.gravity = 0.3;
	self.think = PlayerDeathThink;
	self.nextthink = time;
	self.playerdeadtime = time + 100000000;
	self.deadflag = DEAD_DEAD;
	self.deadwaiting = time + 0.2;
	self.r_healthhaze = 0.4;
	self.journal = 0;
	self.rmenu = 0;

	if (self.waterlevel >= 3)
		playersound("player/die_underwater", 2);
	else
		playersound("player/die", 5);
};

//void(string snd, float r, float vol) playersound;

void(entity attacker, float dmg) Player_Pain = 
{

	if(self.Aegis_time > time)
		return;
	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 0.25;
	if (self.waterlevel >= 3)
	{
		self.underwaterdamaged = 1;
		playersound("player/hurt_underwater", 3);
		makevectors(self.v_angle);
		pointparticles(particleeffectnum("bubbles"), self.origin + self.view_ofs + v_forward * 12,v_forward * 24, 1);
	}
	else
		playersound("player/hurt", 5);
	achievement_takendamage = TRUE; // we took damage, aw :( achievement over
};

void() PlayerDeathThink = { local float forward;

	if (self.deadflag == DEAD_DEAD)
	{
		client_garbage_collector(self);
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

	if ((self.flags &FL_ONGROUND))
	{
		forward = vlen(self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else
			self.velocity = forward* normalize(self.velocity);
	}

	self.health = -100;
	if (self.waterlevel >= 3)
	{
		self.gravity = 0;
		self.velocity = '0 0 0';
	}

	// wait for all buttons released

	// wait for any button down

	if (self.deadwaiting > time)
		self.deadmenuflag = 0;
	else
		self.deadmenuflag = 1;

	//if (deathmatch != 1)
	//	localcmd("slowmo 0.1\n");
	//localcmd("r_glsl_saturation 0\n");
	localcmd("v_cshift\n");



	self.think = SUB_Null;
	self.nextthink = time;
	if (deathmatch == 1)
	{
		self.deadmenuflag = 0;

		if (self.deadwaiting > time)
			return;
		if (!self.button2 && !self.button1 && !self.button0)
			return;
		self.button0 = 0;
		self.button1 = 0;
		self.button2 = 0;
		self.button3 = 0;
		self.button4 = 0;
		self.button5 = 0;
		PutClientInServer();
	}
};
.float extraongroundtime;
.float onground_time;
.float jumptime;
void() PlayerJump = { if (self.flags &FL_WATERJUMP)
		return;

	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 100;
		// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			//if (random() < 0.5)
			//	sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			//else
			//	sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags &FL_ONGROUND))
		return;
	self.melee_released = 0;
	if (!(self.flags &FL_JUMPRELEASED))
		return;	// don't pogo stick
	self.flags = self.flags - (self.flags &FL_JUMPRELEASED);
	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	self.button2 = 0;
	local float fsnd;
	fsnd = (floor(random() *3) + 1);
	if (fsnd == self.jmpsound)
		fsnd = self.jmpsound + 1;
	if (fsnd > 3)
		fsnd = 1;
	self.jmpsound = fsnd;
	playerjumpsound();
	//	local string snd;
	//	snd = strcat ("player/jump", ftos (fsnd),".ogg");
	//	sound (self, CHAN_VOICE, snd, 1, ATTN_NORM);
	self.jumptime = time + 0.2;


	if((self.view_ofs_z < player_zviewofs) && (self.view_ofs_z > 6))
	self.velocity_z = 92;
	else
	self.velocity_z += 270;

/*	if(!(self.walking))
	{	
	makevectors2 (self.angles);
	self.velocity += v_forward * 12;
	}*/

	self.onground_time = 0;
};
.float total_time_underwater;
.float total_time_inlava;
.float underwater_time;
.float jumpinwater;
.float jumpinwatertime;
.float fakewatertype;
.float drownerbreathtime;
.float glpolyblend;


void() WaterMove = { if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;
	if ((self.waterlevel < 3) && (self.underwater_time > time))
	{
		if (self.underwaterdamaged == 1)
			playersound2("player/cough", 5, CHAN_VOICE2);
		else
			playersound2("player/breathe", 3, CHAN_VOICE2);


		playersound2("player/water_surfacing", 3, CHAN_AUTO);
		self.surfacing_sound_time = time + random(0.5,1);
		self.underwaterdamaged = 0;
		self.underwater_time = 0;
	}

	if (self.DrownerApp_time > time)
	self.air_finished = time + 12;

	if (self.waterlevel != 3) 
	{
		if (self.air_finished < time)
		{
			playersound("player/hurt_underwater", 3);
			makevectors(self.v_angle);
			pointparticles(particleeffectnum("bubbles"), self.origin + self.view_ofs + v_forward * 12,v_forward * 24, 1);
		}
		self.air_finished = time + 12;
		self.total_time_underwater = time;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{
		// drown!
		if ((self.pain_finished < time) && (self.DrownerApp_time < time))
		{

			makevectors(self.v_angle);
			pointparticles(particleeffectnum("bubbles"), self.origin + self.view_ofs + v_forward * 12,v_forward * 24, 1);

			self.dmg = self.dmg + 2 ;
			if (self.dmg > 15)
				self.dmg = 10;
			local entity badwater;
			badwater = spawn();
			setmodel(badwater, "");
			badwater.classname = "badwater";
			T_Damage(self, badwater, badwater, self.dmg+ self.extradmg);
			remove(badwater);
			self.pain_finished = time + 1;
		}
	}

	if (time - self.total_time_underwater >= 80)
	{
		Steam_AchievementUnlock(self, ST_ACHIEVEMENTS::AL_TIME_DROWN);
	}

	if (!self.waterlevel)
	{
		self.total_time_inlava = time;
		if (self.flags &FL_INWATER)
		{
			// play leave water sound
			playersound2("player/water_exit", 3, CHAN_VOICE);
			self.jumpinwater = 0;
			self.jumpinwatertime = time + 1;
			self.flags = self.flags - FL_INWATER;
			pointparticles(particleeffectnum("bubbles"), self.origin - '0 0 64',self.velocity, 1);
			if(world.model == "maps/boss3.bsp")
			{	
				self.fakewatertype = CONTENT_BLOOD;
				self.oldwatertype = CONTENT_BLOOD;
			}

			if(self.oldwatertype == CONTENT_BLOOD)	
				pointparticles(particleeffectnum("blood_splash"), self.origin - '0 0 16','0 0 0', 1);
			else if(self.oldwatertype == CONTENT_SLIME)
				pointparticles(particleeffectnum("slime_splash"), self.origin - '0 0 16','0 0 0', 1);
			else
				pointparticles(particleeffectnum("water_splash"), self.origin - '0 0 16','0 0 0', 1);
			self.oldwatertype = 0;
		}

		return;
	}

	if ((self.watertype == CONTENT_LAVA) || (self.fakewatertype == CONTENT_LAVA))
	{
		// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + lava_damage_time * 5;
			else
				self.dmgtime = time + lava_damage_time;
			T_Damage(self, world, world, lava_damage + self.extradmg);
		}

		// Reki (July 17 2023): time in lava achievement
		if (time - self.total_time_inlava >= 15)
		{
			Steam_AchievementUnlock(self, ST_ACHIEVEMENTS::AL_TIME_LAVA);
		}
	}
	else if ((self.watertype == CONTENT_SLIME)|| (self.fakewatertype == CONTENT_SLIME))
	{
		// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage(self, world, world, 4 *self.waterlevel + self.extradmg);
		}
	}

	if (!(self.flags &FL_INWATER))
	{
		// player enter water sound
		/*if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_VOICE, "player/water_enter1.ogg", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_VOICE, "player/water_enter1.ogg", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_VOICE, "player/water_enter1.ogg", 1, ATTN_NORM);
		*/
		playersound2("player/water_surfacing", 3, CHAN_AUTO);
		self.jumpinwater = 1;
		self.jumpinwatertime = time + 1;
		self.flags = self.flags + FL_INWATER;
		self.underwater_time = 0;
		self.dmgtime = 0;
	}

	if (self.waterlevel >= 3)
	{
		if (self.underwater_time < time)
		{
			sound(self, CHAN_VOICE2, "player/underwater_loop.wav", 1, ATTN_NORM);
			self.underwater_time = time + soundlength("player/underwater_loop.wav");
		}
		if ((self.DrownerApp_time > time) && (self.drownerbreathtime < time))
		{
			makevectors (self.v_angle);
			vector vel = self.velocity;
			vel_z = 0;
			float hspeed = vlen (vel);
			pointparticles(particleeffectnum("drowner_bubble"), self.origin + self.view_ofs - '0 0 8' + v_forward * hspeed * 0.2, v_forward * hspeed * 0.47, 1);
			self.drownerbreathtime = time + random(1.75,2);
			sound7 (self, CHAN_VOICE2, "player/breathe_apparatus.ogg", 0.75, 0.5,random(80,120),0);
		}	

	}


	if (!(self.flags &FL_WATERJUMP))
		self.velocity = self.velocity - 0.8 *self.waterlevel *frametime *self.velocity;
};

void() CheckWaterJump = { local vector start, end;
	// check for a jump-out-of-water
	makevectors(self.angles);
	start = self.origin;
	start_z = start_z + 8;
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward * 24;
	traceline(start, end, TRUE, self);
	if (trace_fraction < 1)
	{
		// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal *-50;
		traceline(start, end, TRUE, self);
		if (trace_fraction == 1)
		{
			// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags &FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};


float(entity targ) crouchcheck = { makevectors(self.v_angle);
	tracebox(self.origin, VEC_HULL_MIN, '16 16 0', self.origin + '0 0 48', FALSE, self);
	if (trace_fraction == 1)	//hits nothing go ahead
		{
		self.origin_z += 16; setorigin(self,self.origin);
		return TRUE;
		}
	if (!trace_ent.takedamage)	//hits world or nondamagable object
		return FALSE;
	return FALSE;
};
.float crouchingtime;
void() Crouch_Off = { if (self.crouch && (crouchcheck(self)))	//get up
	{
		
		if((self.groundentity.solid == SOLID_BBOX) &&  (self.flags &FL_ONGROUND))
		self.velocity_z  = 90;

		if(!(self.flags & FL_JUMPRELEASED))
		self.flags += FL_JUMPRELEASED;
		setsize(self, '-16 -16 -32', '16 16 32');	//changes the size of the player to the normal size
		self.crouch = 0;
		self.attemptcrouch = 0;
		if (self.lspeedtime < time)
			self.maxspeed = 1;	// multiplier of the velocity of the player
		return;
	}

	self.attemptcrouch = 1;
};

void() Crouch_On = { if ((!self.crouch) /*&& (!self.velocity_z)*/)	//crouch down
	{
		setsize(self, '-16 -16 -16', '16 16 8');	//changes the size of the player !!! 

		self.crouchingtime = time + 0.25;

		self.crouch = 1;
		self.attemptcrouch = 1;
		if (self.flags &FL_ONGROUND)
		{
			if (time < self.lspeedtime)
				self.maxspeed = 0.5;
			else
				self.maxspeed = 0.65;	// multiplier of the velocity of the player
		}

		return;
	}

	self.attemptcrouch = 0;
};
.float crushingtime;

void() UpdateViewOfs = { if (self.crouch)
	{
		if(self.crushingtime > time)
		float minviewofsz = -4;
		else
		minviewofsz = 6;


		if (self.view_ofs_z == minviewofsz)
			return;
		if (self.view_ofs_z > minviewofsz)
		{
			self.view_ofs_z = self.view_ofs_z - 1;
		}
		else
			self.view_ofs_z = minviewofsz;
	}
	else
	{
		if (self.view_ofs_z == player_zviewofs)
			return;
		if (self.view_ofs_z < player_zviewofs)
		{
			self.view_ofs_z = self.view_ofs_z + 1;
		}
		else
			self.view_ofs_z = player_zviewofs;
	}
};
.float nowatershift;
//float autocvar_invertmouse;// = 0; 
.float slowmouse;
.float noshake;

void() slowmovement = { self.slowmouse = 1;
	local float invrtms;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtms = 1;
	else
		invrtms = 0;

	/*	
		if (invrtms == 1)
		{
		stuffcmd(self, "m_pitch -0.005\n");
		stuffcmd(self, "m_yaw 0.005\n");
		}
		else
		{
		stuffcmd(self, "m_pitch 0.005\n");
		stuffcmd(self, "m_yaw 0.005\n");
		}

*/
	self.maxspeed = 0.5;
};
void() quickmovement
{
	self.slowmouse = -1;
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;

	/*
			if (invrtmsb == 1)
			{
			stuffcmd(self, "m_pitch -0.022\n");
			stuffcmd(self, "m_yaw 0.022\n");
			}
			else
			{
			stuffcmd(self, "m_pitch 0.022\n");
			stuffcmd(self, "m_yaw 0.022\n");
			}

	*/
	if (self.crouch)
		self.maxspeed = 0.65;
	else
		self.maxspeed = 1;
};

//void(entity e, entity world)find_nearest_waypoint;
.float releasebutton5;

.float changing_level;
.float heretic_sloweffect;
.float heretic_sloweffectime;

.float usingnonsolidswitch;
.entity nonsolidswitch;
.float splashtime;

.float autosavetime;
.float autosaved;
.float menuactive;

void() autosave = { read_currentprofileslot();
	self.autosaved = 1;
	string saveloc;
	saveloc = strcat("save data/profiles/", profilename, "/autosave\n");
	update_latest_saveslot(3);
	copy_save_maps(2);
	stuffcmd(self, "scratch1 1\n");
	stuffcmd(self, saveloc);
	stuffcmd(self, "scratch1 0\n");
	if (profilename)
		strunzone(profilename);
	save_screenshot(1, 1.5);
	writedates(1);
};

.float strafetime;
.float melee_lunge;
void() wraith_side1;

.float realmaxspeed;
.float maxspeedtime;
.float stoptime;
.float stopflag;
.float onmonsterjumptime;
.float alwaysrun;
.float togglerun;
.float walkingbutton;
.float toggle_finished;
void() check_custom_cvars;
void() refresh_custom_cvars;
.float buttonrelease7;
.float lift_touch_time;
.float on_lift;
.float gameplayfix_stepdown;
.float timeviewzoom;
.float walktime;
.vector ice_velocity;
.float frictiontime;
.float flightflag;
void()Apply_Lut;
void(float type) toggle_displacement;
void(float forceit,entity e) symbolrmovement


void()v_cshift_changes;
void(entity e)UpdateCameras;
void()UpdateChannelsVolume;
float(entity ent) boss3_crosshairhighlight;
.float artifact_model_client;
.float beam_time;
.float charge_time;
.float meaxhealth_finished;
.float aegisflag;
.float rocketjumpcnt;
.vector shadowangle;
void() PlayerPreThink = 
{
	self.shadowangle = normalize('1 0 0'); 
	// Reki (May 9 2023): Fixed this anti-rj logic because it was bugged and a bit inflexible
	if (self.flags & FL_ONGROUND && self.velocity_z < 200)
		self.rocketjumpcnt = 0;
	else
		self.rocketjumpcnt = max(0, self.rocketjumpcnt - (frametime * 0.2));

	if((self.aegisflag == 1) && (self.Aegis_time < time))
	{
		//stuffcmd (self, "r_glsl_saturation 1\n");
		self.aegisflag = 0;
	}	
	if(self.vhud == 3)
	{
		UpdateCameras(self.active_camera);
		self.velocity = '0 0 0';
	}

	UpdateChannelsVolume();

	if ((self.DrownerApp_time > time) && (self.glpolyblend != 1))
	{
		stuffcmd (self,"gl_polyblend 0.33\n");
		self.glpolyblend = 1;
	}	

	if ((self.DrownerApp_time < time) && (self.glpolyblend == 1))
	{
		stuffcmd (self,"gl_polyblend 1\n");
		self.glpolyblend = 0;
	}	

	if(self.beam_time > time)
	{
		self.beam_state = 1;
	}
	else
		self.beam_state = 0;
	/*
	if (time > self.timeviewzoom)
	{
		if(self.lance_viewzoom_time > time)
		{	
			if (self.viewzoom > self.lance_viewzoom)
				self.viewzoom -= self.lance_viewzoom_rate / 100;
		}
		if((self.lance_viewzoom_time < time) && (self.viewzoom != 1))
		{
			if (self.viewzoom < 1)
				self.viewzoom += self.lance_viewzoom_rate  / 50;
		}
		self.timeviewzoom = time +0.01;
	}
	
	if (self.viewzoom < self.lance_viewzoom)
		self.viewzoom = self.lance_viewzoom;
	if (self.viewzoom > 1)
	self.viewzoom = 1;
	*/


	if((self.stoptime < time) && (self.flags & FL_IGNOREINPUT) &&(self.hardstoptime < time))
	{
		self.flags -= FL_IGNOREINPUT;
	}

	if((self.flags & FL_IGNOREINPUT)&& (self.flags & FL_ONGROUND) &&(self.hardstoptime < time))
	self.flags -= FL_IGNOREINPUT;

	if((self.hardstoptime < time) && (self.flags & FL_IGNOREINPUT))
	{
		self.flags -= FL_IGNOREINPUT;
	}

	if((time > self.autosavetime) && (self.restoredgame == 1))
		self.restoredgame = 0;

	if ((self.autosavetime > time) && (self.impulse))
		self.impulse = 0;

	if ((self.autosavetime < time) && (!(self.menuactive)))
	{
		stuffcmd(self, "scratch3 0\n");
		if (!self.autosaved)
			autosave();
		self.menuactive = 1;
	}

	if (self.splashtime > time)
	{
		self.vhud = 2;
	}
	else
	{
		if (self.vhud == 2)
			self.vhud = 0;
	}

	if ((self.health < 1) && (!self.deadflag))
	{
		self.think = Player_Die;
		self.nextthink = time;
		self.attack_finished = time + 5;
		return;
	}
	float maxhfaderate = cvar ("maxhealthfade");

	if ((floor(self.health) > 100) && (self.meaxhealth_finished < time))
	{
		self.health --;
		self.meaxhealth_finished = time + (100 / (self.health * maxhfaderate));
		//stuffcmd (self,"pulsehealth\n");
	}
	if (self.deadflag >= DEAD_DEAD)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
		return;
	}

	if (self.deadflag == DEAD_DYING)
	{
		CheckFuncWaterDeath();	
		return;
	}

	if (self.playerdeadtime > time)
		return;

	if ((self.time_hudmessage < time) && (self.stat_time_hudmessage == 1))
		self.stat_time_hudmessage = 0;

	if (self.changing_level == 1)
		return;
	if (self.message_flag == 1)
	{
		if (!self.button5)
			self.message_brelease = 0;

		if ((self.button5) && (self.message_brelease == 0) || (self.message_time < time))
		{
			self.message_flag = 0;
			//stuffcmd(self, "slowmo 1\n");
			self.message_number = 0;
			self.use_finished = time + 0.5;
			self.journal = 0;
		}
	}
	if((self.wrath_active == 2) && (time > (self.wrath_time - 0.5)))
	{
		self.wrath_active = 3;
		stuffcmd (self, "bf 1 0 0 1 1\n");
		//stuffcmd(self, "v_idlescale 0 \n");	
		sound7(self, CHAN_SIGIL, "items/sigils/sigil_wrath_end.ogg", 1, 1, 100, 0);
		if(time > self.flasrageflashtime)
		{
			//sound7 (self, CHAN_AUTO, "items/sigils/sigil_flight_start.ogg",0.35 ,1,80,0);
			te_customflash(self.origin, 128, 1, '1 0 0');
			string flash_command_a = strcat ("bf ",ftos(1)," ",ftos(0)," ");
			string flash_command_b = strcat (ftos(0)," ",ftos(0.5)," ",ftos(0.5),"\n");
			string flash_command =  strcat (flash_command_a,flash_command_b);
			stuffcmd (self, flash_command);
			self.flasrageflashtime = time + 3;
			local entity destructwrath;
			destructwrath = nextent(world);
			while (destructwrath)	
			{
				entity holder = nextent(destructwrath);
				if((destructwrath.classname == "func_destruct") && (destructwrath.wrath_active == 2))
				{
					destructwrath.takedamage = 0;
					//destructwrath.glowmod = '-1 -1 -1';
					destructwrath.wrath_active = 1;
					destructwrath.pipes.think = item_glowmodcontroller_flicker_fade_think;
					destructwrath.pipes.nextthink = time;
				}
				destructwrath = holder;	
			}

		}
	}
	
	if(self.wrath_active == 1)
	{
		self.wrath_active = 2;
		//self.radialactive = 22;
		stuffcmd(self, "v_cshift 255 0 0 16\n");
		//stuffcmd(self, "v_idlescale 15 \n"); // Reki (August 28 2023): Moved this to STAT_WRATHACTIVE logic in hud.qc
		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 1\n");
		stuffcmd (self, strcat(("r_glsl_postprocess_uservec3 "),("\""),ftos(0.0025 * self.wrath_kills + 0.01),(" 3.5 1.25 0\"\n")));
	}
	
	if(self.wrath_active == 3) 
	{

		self.radialactive = 0;
		self.wrath_kills = 0;
		self.wrath_time = 0;
		self.wrath_active = 0; 
		self.artifact_model_client = 0;
		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 0\n");
		stuffcmd(self, "v_cshift \n");
		self.r_cshift = 0;
		self.g_cshift = 0;
		self.b_cshift = 0;
		self.i_cshift = 0;
	}

	if((self.displacement_active == 1) || (self.wrath_active >= 2)|| (self.flaskrage_active >= 1))
	{
		v_cshift_changes();
	}
	
	if((self.flaskrage_active == 3) && (self.flaskrage_time < time))
	{
		self.pflags = 0;
		self.color = '0 0 0';
		self.style = 0;
		self.light_lev = 0;
		stuffcmd(self, "v_cshift \n");
		self.flaskrage_active = 0;
		self.r_cshift = 0;
		self.g_cshift = 0;
		self.b_cshift = 0;
		self.i_cshift = 0;

	}
	
	if(self.flaskrage_active == 1)
	{
		self.r_cshift = 0;
		self.b_cshift = 0;
		self.g_cshift = 0;
		self.pflags = 129;
		self.color = FLASKRAGECOLOR;
		self.style = 1;
		self.light_lev = 128;
		self.flaskrage_active = 2;
	}

	if((self.displacement_active == 1)  && (time > (self.displacement_time- 0.5)))
	{
		toggle_displacement(0);
		Apply_Lut();
        stuffcmd (self, "bf 0.7 0.7 1 1.05 1\n");
		stuffcmd(self, "v_cshift \n");
		self.r_cshift = 0;
		self.g_cshift = 0;
		self.b_cshift = 0;
		self.i_cshift = 0;
		//stuffcmd(self, "r_trippy 0\n");
		//stuffcmd(self, "r_glsl_saturation 1\n");
		stuffcmd(self, "v_flipped 0\n");
		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 0\n");
		stuffcmd (self, "r_glsl_postprocess_uservec3 \"0 0 0 0\"\n");
		self.displacement_active = 0;
		self.radialactive = 0;

	}
	if(self.displacement_active == 2)
	{	
		self.displacement_active = 1;
		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 1\n");
		stuffcmd (self, "r_glsl_postprocess_uservec3 \"0.01 2 15 0\"\n");
		//stuffcmd(self, "r_trippy 1\n");
		//stuffcmd(self, "v_flipped 1\n");
		toggle_displacement(1);
		Apply_Lut();

	}
	if (!self.crouch)
	{
	
		float button7pressed;
		{
			if(self.togglerun != 1)
			{
				if(self.button7)
					button7pressed = 1;	
				else
					button7pressed = 0;		
			}
			else
			{	
				if(!self.button7)
					self.buttonrelease7 = 1;
				if ((self.button7) && (self.buttonrelease7 == 1))
				{
					if(self.walkingbutton != 1)
						self.walkingbutton= 1;
					else
						self.walkingbutton= 0;
					self.buttonrelease7 = 0;
				}
			button7pressed = self.walkingbutton;
			}
		}
	
		if (self.alwaysrun == 1)
		{
			 if (button7pressed == 1)
				self.walking = 1;
			else
				self.walking = 0;
		}
		else
		{
			 if (button7pressed == 1) 
				self.walking = 0;
			else
				self.walking = 1;
		}

		if ((self.walking == 1))
		{
			if (!(self.effects &256))
			{
				self.effects += 256;
				stuffcmd(self, "cl_bobmodel 0\n");
				stuffcmd(self, "cl_leanmodel 0\n");
				stuffcmd(self, "cl_followmodel 0\n");
				stuffcmd(self, "cl_smoothviewheight 0\n");
			}

			self.maxspeed = 0.75;
		}
		else
		{
			if((self.flags & FL_ONGROUND) && (self.maxspeed != 1))
			{
			if (self.heretic_sloweffectime > time)
				self.maxspeed = 0.75;
			else
				self.maxspeed = 1;
			}

			if (self.effects &256)
			{
				stuffcmd(self, "cl_bobmodel 1\n");
				stuffcmd(self, "cl_leanmodel 1\n");
				stuffcmd(self, "cl_followmodel 1\n");
				stuffcmd(self, "cl_smoothviewheight 0\n");
				self.effects -= 256;
			}
		}
	}

	if ((self.lspeedtime > time) && (self.slowmouse != 1) && (self.heretic_sloweffectime < time))
		slowmovement();

	if ((time > self.lspeedtime) && (self.slowmouse == 1) && (self.heretic_sloweffectime < time))
		quickmovement();
	if(self.flags & FL_ONGROUND)
	self.onground_time = time + 0.2;

	makevectors(self.v_angle);	// is this still used
	if ((self.fwatershifttime > time) && (self.nowatershift != 0))
	{
		self.nowatershift = 0;
	}

	if ((time >self.fwatershifttime )&& (time > self.wrath_time)&& (time > self.wrath_time))
	{
		if (self.fwatershift)
		{
			self.dphitcontentsmask = 0;
			stuffcmd(self, "v_cshift\n");
			self.fwatershift = FALSE;
		}

		if (self.nowatershift == 0)
		{
			if (self.fwatershift == FALSE)
				stuffcmd(self, "v_cshift\n");
			self.nowatershift = 1;
		}
	}

	if (self.zerogtime < time)
		self.gravity = self.oldgravity;	// reset normal gravity
	else
		self.gravity = 0.0001;	// zero G (0 OR 1 is normal)
	if (!self.modeeditor)
	{
		if (self.timefly > time)
		{
			if (self.movetype != MOVETYPE_FLY)
			{
				self.movetype = MOVETYPE_FLY;
				stuffcmd (self, "alias +button4  \"+movedown\" \n");
				stuffcmd (self, "alias -button4  \"-movedown\" \n");
				stuffcmd (self, "alias +jump  \"+moveup\" \n");
				stuffcmd (self, "alias -jump  \"-moveup\" \n");
				self.timeflyc = rint(time - self.timefly);
			}
		}
		else
		{
			if (self.movetype != MOVETYPE_WALK)
			{
				if ((self.movetype != MOVETYPE_NOCLIP) && (self.flightflag == 2))
				{
					self.radialactive = 0;
					self.timefly = 0;
					self.timeflyc = 0;
					self.movetype = MOVETYPE_WALK;
					self.flightflag = 0.1;
					stuffcmd (self, "alias +button4  \"\" \n");
					stuffcmd (self, "alias -button4  \"\" \n");
					stuffcmd (self, "alias +jump  \"\" \n");
					stuffcmd (self, "alias -jump  \"\" \n");
					stuffcmd (self, "-jump \n");
					stuffcmd (self, "-jump \n");
					stuffcmd (self, "-moveup \n");
					stuffcmd (self, "-movedown \n");
				}
			}
		}
	}

	if((self.flightflag == 1))
		self.flightflag = 2;

	if (self.LifeSiphon_time > time)
		self.timels = rint(time - self.LifeSiphon_time);
	else
		self.timels = 0;
	WaterMove();
	if (self.waterlevel == 2)
		CheckWaterJump();

	if ((self.button2) && (!self.crouch)&& (self.vhud != 3))
	{
	
		PlayerJump();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

	if ((self.watertype == CONTENT_LAVA) || (self.fakewatertype == CONTENT_LAVA))
	{
		self.velocity_x = self.velocity_x *self.realmaxspeed * lava_speed;
		self.velocity_y = self.velocity_y *self.realmaxspeed * lava_speed;
	}
	else
	{
		if ((time > self.melee_jump_time) && (time > self.jumptime) && (self.flags & FL_ONGROUND) ) 
		{
			self.velocity_x = self.velocity_x *self.realmaxspeed;
			self.velocity_y = self.velocity_y *self.realmaxspeed;
		}
	}





	
	if (((!(self.button4)) && (self.crouch))   && (self.crushingtime <= time)  && (self.crouchingtime <= time) )
	{
	if (self.rmenu == 1)
		return;
		Crouch_Off();
	}

	if (((self.button4) && (!self.crouch)) || ((self.crushingtime > time)&& (!self.crouch)))
	{
	if (self.rmenu == 1)
		return;
		Crouch_On();	
	}



	if((self.flags & FL_ONGROUND) && ((self.groundentity.classname == "boss_guardian1")|| (self.groundentity.flags & FL_MONSTER)||(self.groundentity.wrathflags & FL_NOONTOP)) && (self.onmonsterjumptime < time) &&(self.groundentity != world) )
	{
		self.onmonsterjumptime = time  + 0.3;
		self.velocity = v_forward * -92 + v_right * random(-32, 32);
		self.velocity_z  += random(50,70);
		self.velocity_x  += random(90, 120) * crandom2() ;
		self.velocity_y  += random(90, 120) * crandom2();
		if(self.groundentity.classname == "boss_guardian1")
		{
			self.velocity_z  += 192;
			self.onmonsterjumptime = time  + 0.1;
		}
		if(self.groundentity.classname == "monster_afflicted")
		{
			Killed(self.groundentity, world, 1);
		}
		if((self.groundentity.classname == "object_torch1"))
		{

			vector hangles = self.angles;
			hangles_x = 0;
			hangles_y = 0;

			makevectors (hangles);
			traceline (self.origin,self.origin + v_forward * -128,MOVE_WORLDONLY,self);	
			if (trace_fraction == 1.0)
				self.velocity = v_forward * -92 + v_right * random(-32, 32);
			else
				self.velocity = v_forward * 92 + v_right * random(-32, 32);

			self.velocity_z  = random(16,32);
			if(self.flags & FL_ONGROUND)
				self.flags -= FL_ONGROUND;	
			if(!(self.flags & FL_IGNOREINPUT))
			{
				self.flags += FL_IGNOREINPUT;
				self.hardstoptime = time + 0.3;
			}
			self.onmonsterjumptime = time  + 0.1;

			if(self.groundentity.attack_finished < time)
			{
				pointparticles(particleeffectnum("EF_FLAME"), self.groundentity.origin + '0 0 12' , '0 0 0',1);
				T_Damage(self, self.groundentity, self.groundentity, 5);
				self.groundentity.attack_finished = (time + 0.2);
			}

		}
		
	}
	if ((self.heretic_sloweffectime > time))
	{
		if ((self.crouch == 1) && (self.flags &FL_ONGROUND) && (self.maxspeed != 0.5))
			self.maxspeed = 0.5;	// multiplier of the velocity of the player	
	}
	else
	{
		if ((self.crouch == 1) && (self.flags &FL_ONGROUND) && (self.maxspeed != 0.65))
			self.maxspeed = 0.65;	// multiplier of the velocity of the player
	}

	if (self.noshake == 2)
	{
		stuffcmd(self, "v_kickroll 0.7\n");
		stuffcmd(self, "v_kickpitch 0.7\n");
		self.noshake = 0;
	}

	
	UpdateViewOfs();

	if ((self.radial_time < time) && (self.radialruning == 1))
	{
		//self.radialactive = 0;
		self.radialruning = 0;
	}
	
	// Reki (April 20 2023): Refactored use traces to use traceline and not prydon cursor
	makevectors(self.v_angle);
	vector usable_trace_start = self.origin + self.view_ofs;
	vector usable_trace_endpos = usable_trace_start + (v_forward * 4096);
	float usable_trace_fraction;
	entity usable_trace_ent;
	float o_dphitcontents = self.dphitcontentsmask;
	self.dphitcontentsmask = DPCONTENTS_OPAQUE | DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_CORPSE | DPCONTENTS_INTERACTCLIP;
	traceline(usable_trace_start, usable_trace_endpos, MOVE_NORMAL, self);
	self.dphitcontentsmask = o_dphitcontents;
	if (trace_ent.effects & EF_NODRAW) // to mimick prydon cursor, we can't hit things we can't see
		trace_ent = world;
	if (!(trace_ent && trace_ent.usable) && (self.cursor_trace_ent && self.cursor_trace_ent.usable) && !(trace_dphitcontents & DPCONTENTS_INTERACTCLIP)) // hack in prydon cursor for some edge cases (like solid_trigger :\)
	{
		trace_ent = self.cursor_trace_ent;
		trace_fraction = vlen(usable_trace_start - self.cursor_trace_endpos) / 4096;
		trace_endpos = self.cursor_trace_endpos;
	}
	usable_trace_ent = trace_ent; usable_trace_fraction = trace_fraction; usable_trace_endpos = trace_endpos;

	float use_range = 72;
	if ((usable_trace_ent.usable >= 1) && vlen(usable_trace_endpos - usable_trace_start) < use_range)
	{
		if (!(self.crosshairflag &1))
			self.crosshairflag += 1;

		if ((usable_trace_ent.classname == "readable") && (self.message_flag != 1))
			usable_trace_ent.effects = EF_SELECTABLE;

		if((usable_trace_ent.classname == "ssoundbox")&&(self.use_finished2 > time))
		{

			usable_trace_ent.think = soundbox_visible_toggle;
			usable_trace_ent.nextthink = time + 0.01;
			self.use_finished = time + 0.75;
		}

		if (usable_trace_ent.classname == "nonsolidswitch")
		{
			self.usingnonsolidswitch = TRUE;
			self.nonsolidswitch = usable_trace_ent;
		}
		if (usable_trace_ent.classname == "switchmodel")
		{
			self.usingnonsolidswitch = TRUE;
			self.nonsolidswitch = usable_trace_ent.owner;
		}
	}
	else
	{
		if (self.crosshairflag &1)
			self.crosshairflag -= 1;
		if (((usable_trace_ent.classname == "readable") && (usable_trace_ent.effects == EF_SELECTABLE)))
			usable_trace_ent.effects = FALSE;
		if (self.usingnonsolidswitch)
		{
			self.usingnonsolidswitch = FALSE;
			self.nonsolidswitch = world;
		}
	}

	if ((usable_trace_ent.classname == "monster_martyffr") && (usable_trace_ent.walktime < time))
	{
		usable_trace_ent.strafetime = time + random(0.25,0.75);
		usable_trace_ent.walktime =  time + random(0.75,1);
		self.strafetime = 0;
	}

	if ((usable_trace_ent.flags & FL_MONSTER) && (usable_trace_ent.health > 0) && (vlen(usable_trace_endpos - usable_trace_start) < 4096))
	{
		if (!(self.crosshairflag &2))
			self.crosshairflag += 2;

		if((usable_trace_ent.classname == "monster_symbol") && (usable_trace_ent.movetype == MOVETYPE_STEP))
		{
			/*
			symbolrmovement(1,usable_trace_ent);
			*/
		}

		/*if (skill >= 1)
		{
			if ((self.cursor_trace_ent.classname == "monster_wraith") && (self.cursor_trace_ent.enemy == self) && (self.cursor_trace_ent.strafetime < time))
			{
				self.cursor_trace_ent.strafetime = time + 1;
				self.cursor_trace_ent.think = wraith_side1;
			}
		}*/
	}
	else
	{
		if (self.crosshairflag &2)
			self.crosshairflag -= 2;
	}

	if (boss3_crosshairhighlight(usable_trace_ent))
	{
		self.crosshairflag |= 2;
	}

	if (time > self.maxspeedtime)
	{
		if(self.maxspeed < self.realmaxspeed)
		{
			self.realmaxspeed -= sliding_ammount_d;
		}	
		if(self.maxspeed > self.realmaxspeed)
		{
			self.realmaxspeed += sliding_ammount_i;
		}	
		self.maxspeedtime =  time + 1/sliding_fps;
	}


	if((self.shake_camera_time > time) && (self.charge_time < time) && (self.shake2_camera_time < time))
	{
		if(self.shake_camera_delay > time)
		return;
		if(self.shaked == 1)
		{
		
		if((self.shake_camera_time - time) > 1)
		float fade_multiplier = 1;
		else
		fade_multiplier = self.shake_camera_time - time;

		self.punchangle_x =random(self.shake_camera_ammountx * -1, self.shake_camera_ammountx * -0.5) * fade_multiplier;
		self.punchangle_y =random(self.shake_camera_ammounty * -1, self.shake_camera_ammounty * -0.5) * fade_multiplier;
		self.shaked = 2;
		}
		else
		{
		self.punchangle_x =random(self.shake_camera_ammountx * 0.5, self.shake_camera_ammountx) * fade_multiplier;
		self.punchangle_y =random(self.shake_camera_ammounty * 0.5,self.shake_camera_ammounty) * fade_multiplier;
		self.shaked = 1;
		}
		self.shake_camera_delay = time + self.shake_camera_refresh_rate;
	}



	if((self.shake2_camera_time > time) && (self.charge_time < time))
	{
		if(self.shake2_camera_delay > time)
			return;
		vector shakecamera;
		shakecamera_x = self.shake2_camera_ammountx + self.shake_camera_ammountx;
		shakecamera_y = self.shake2_camera_ammounty + self.shake_camera_ammounty;
		if(self.shaked == 1)
		{		
			if((self.shake2_camera_time - time) > 1)
				fade_multiplier = 1;
			else
				fade_multiplier = self.shake2_camera_time - time;
			self.punchangle_x =random(shakecamera_x * -1, shakecamera_x * -0.5) * fade_multiplier;
			self.punchangle_y =random(shakecamera_y * -1, shakecamera_y * -0.5) * fade_multiplier;
			self.shaked = 2;
		}
		else
		{
			self.punchangle_x =random(shakecamera_x * 0.5, shakecamera_x) * fade_multiplier;
			self.punchangle_y =random(shakecamera_y * 0.5,shakecamera_y) * fade_multiplier;
			self.shaked = 1;
		}
		self.shake2_camera_delay = time + self.shake2_camera_refresh_rate;
	}
	if(self.shake_camera_time < time)
	{
		self.shake_camera_ammountx = 0;
		self.shake_camera_ammounty = 0;
	}
	
	if((self.macesoultime > time) && (self.macesoultimer < time))
	{
		float tagindex = gettagindex(self.vweapon, "tag_mace_fx");
		self.maceorigin = gettaginfo(self.vweapon, tagindex);
		self.macesoultimer = time + 0.05;
	}


};

.float jump_flag;	// player jump flag

.float nomelee;
.float checkweaponflag;
void() nowater_type =
{
self.waterlevel = 0;
self.fakewatertype = 0;
self.zerogtime = 0;
self.fwatershifttime = 0;
self.fwatershift = 0;
}

void() check_weapons = { self.checkweaponflag = 1;
};

.float tether_model_client;
.float shrine_model_client;

.float sigil_model_client;
.float v_nextthink;
.entity artifact_client2;

void() artifact_client_remove2 = { if (self.owner.shrine_model_client == 1)
	{
		self.alpha -= 0.1;
		self.frame++;
	}

	if (self.alpha <= 0.1)
	{
		self.think = SUB_Remove;
		self.owner.shrine_model_client = 0;
	}
	else
		self.think = artifact_client_remove2;

	if (self.lifetime < time)
		self.think = SUB_Remove;
	self.nextthink = time + 0.05;
}

void() artifact_client_remove3 = { if (self.owner.tether_model_client == 1)
	{
		self.alpha -= 0.1;
		self.frame++;
	}

	if (self.alpha <= 0.1)
	{
		self.think = SUB_Remove;
		self.owner.tether_model_client = 0;
	}
	else
		self.think = artifact_client_remove3;

	if (self.lifetime < time)
		self.think = SUB_Remove;
	self.nextthink = time + 0.05;
}
void() artifact_client_remove = 
{ 
	if ((self.owner.radial_time > time) && (self.owner.artifact_model_client == 2))
	{
		if (self.owner.healthpulsetime > time)
			self.alpha += 0.2;

		if ((self.owner.healthpulsetime < time) && (self.alpha > 0.5))
			self.alpha -= 0.05;
	}



	if ((self.owner.radial_time < time) && ((self.owner.artifact_model_client == 1) || (self.owner.artifact_model_client == 2) || (self.owner.artifact_model_client == 4)|| 	(self.owner.artifact_model_client == 5)))
		self.alpha -= 0.1;



	if ((self.owner.artifact_model_client == 3))
	{
		self.alpha -= 0.1;
		self.frame++;
	}

	if (self.alpha <= 0.1)
	{
		self.owner.radial_time = 0;
		self.owner.artifact_model_client = 0;
		self.think = SUB_Remove;
		self.owner.artifact_model_client = 0;
	}
	else
		self.think = artifact_client_remove;

	if (self.lifetime < time)
		self.think = SUB_Remove;


	//string viewxanglesfactor = strcat ((ftos (self.owner.radial_time)), (" radialtime"),ftos(time),"\n");
	//bprint (viewxanglesfactor);

	self.nextthink = time + 0.05;
}

void() artifact_client_think = { self.alpha += 0.1;

	local float maxalpha;
	maxalpha = 1;
	if (self.owner.artifact_model_client == 2)
	{
		maxalpha = 0.5;
	}
	if (self.owner.artifact_model_client == 5)
	{
		self.effects += 32;
		maxalpha = 0.15;
	}

	if (self.alpha < maxalpha)
		self.think = artifact_client_think;
	else
	{
		self.alpha = maxalpha;
		self.think = artifact_client_remove;
	}
	self.nextthink = time + 0.05;

};

.float sigil_time;

void() sigil_client_remove = 
{ 	
	if (self.owner.sigil_time < time)
	{
		self.alpha -= 0.1;
	}
	else
	{
		local float maxalpha;
		maxalpha = 1;


		if ((self.owner.wrath_active >= 1)  && (self.owner.wrath_time > time) ) 
		{
				if (self.alpha < maxalpha)
				self.alpha = (self.owner.wrath_kills * 0.0075)+ 0.125;

		}
		else
		{
			if (self.alpha < maxalpha)
				self.alpha += 0.1;
		}

	}




	if (self.alpha <= 0.1)
	{
		self.think = SUB_Remove;
		self.owner.sigil_model_client = 0;
	}
	else
		self.think = sigil_client_remove;

	self.nextthink = time + 0.05;
};


void() sigil_client_think = 
{ 
	local float maxalpha;

	if ((self.owner.wrath_active >= 1)  && (self.owner.wrath_time > time) ) 
	{	
		maxalpha = 0.125;
		self.alpha = 0.125;
	}
	else
	{
		if(self.colormod == '1 0 0.25')
			maxalpha = 0.5;
		else
			maxalpha = 1;
	}

	if (self.alpha < maxalpha)
		self.alpha += 0.1;


	if (self.alpha < maxalpha)
		self.think = sigil_client_think;
	else
		self.think = sigil_client_remove;
	self.nextthink = time + 0.05;

};

.float Shrine_time;

void() ArtifactClientModel =	//ArtifactClientModel
	{
		local entity artifact_client2;

		if ((self.Shrine_time > time) && (self.shrine_model_client == 0))
		{
			artifact_client2 = spawn();
			artifact_client2.lifetime = time + 2;
			artifact_client2.owner = self;
			artifact_client2.effects = 256;
			artifact_client2.viewmodelforclient = self;
			setorigin(artifact_client2, '0 0 0');
			artifact_client2.oldangles = self.angles;
			artifact_client2.frame = 0;
			self.shrine_model_client = 1;
			artifact_client2.alpha = 1;
			setmodel(artifact_client2, "models/artifacts/active/soul_tether_active.md3");
			artifact_client2.think = artifact_client_remove2;
			artifact_client2.nextthink = time;
		}


		local entity sigil_client;
		if((self.timefly > time) && (self.sigil_model_client == 0))
		{
			sigil_client = spawn();
			sigil_client.owner = self;
			sigil_client.effects = 256;
			sigil_client.viewmodelforclient = self;
			setorigin(sigil_client, '0 0 0');
			sigil_client.oldangles = self.angles;
			sigil_client.frame = 0;
			sigil_client.alpha = 0.01;
			self.sigil_model_client = 1;
			setmodel(sigil_client, "models/artifacts/active/sigil_flight_active.md3");
			sigil_client.think = sigil_client_think;
			sigil_client.nextthink = time;
		}

		if((self.wrath_time > time) && (self.sigil_model_client == 0))
		{
			sigil_client = spawn();
			sigil_client.owner = self;
			sigil_client.effects = 256;
			sigil_client.viewmodelforclient = self;
			setorigin(sigil_client, '0 0 0');
			sigil_client.oldangles = self.angles;
			sigil_client.frame = 0;
			sigil_client.colormod = '1 0 0.2';
			sigil_client.alpha = 0.1;
			self.sigil_model_client = 1;
			setmodel(sigil_client, "models/artifacts/active/sigil_wrath_active.md3");
			sigil_client.think = sigil_client_think;
			sigil_client.nextthink = time;
		}

		if((self.displacement_time > time) && (self.sigil_model_client == 0))
		{
			sigil_client = spawn();
			sigil_client.owner = self;
			sigil_client.effects = 256;
			sigil_client.viewmodelforclient = self;
			setorigin(sigil_client, '0 0 0');
			sigil_client.oldangles = self.angles;
			sigil_client.frame = 0;
			sigil_client.colormod = randomvec() + '0.5 0.5 0.5';
			sigil_client.alpha = 0.01;
			self.sigil_model_client = 1;
			setmodel(sigil_client, "models/artifacts/active/sigil_flight_active.md3");
			sigil_client.think = sigil_client_think;
			sigil_client.nextthink = time;
		}
		local entity artifact_client;
		if (self.radial_time > time)
		{
			if ((self.artifact_model_client == 0) && ((self.Aegis_time > time) || (self.LifeSiphon_time > time) ||(self.flaskrage_time > time) || (self.DrownerApp_time > time) || (self.Tether_time > time)))
			{
				artifact_client = spawn();
				artifact_client.owner = self;
				artifact_client.effects = 256;
				artifact_client.viewmodelforclient = self;
				setorigin(artifact_client, '0 0 0');
				artifact_client.oldangles = self.angles;
				artifact_client.frame = 0;
				artifact_client.alpha = 0.01;

				if (self.Aegis_time > time)
				{
					self.artifact_model_client = 1;
					setmodel(artifact_client, "models/artifacts/active/cruel_aegis_active.md3");
				}

				if (self.LifeSiphon_time > time)
				{
					self.artifact_model_client = 2;
					setmodel(artifact_client, "models/artifacts/active/life_siphon_active.md3");
				}

				if (self.DrownerApp_time > time)
				{
					self.artifact_model_client = 4;
					setmodel(artifact_client, "models/misc/null.md3");
				}
				if (self.flaskrage_time > time)
				{
					self.artifact_model_client = 5;
					setmodel(artifact_client, "models/artifacts/active/flask_active.md3");
				}
				artifact_client.lifetime = time + 30;
				artifact_client.think = artifact_client_think;
				artifact_client.nextthink = time;
			}
		}
	};
.float fakewatertype;
.float check_centered;
.float lungefree;

.float time_sea_particles;
void() PlayerPostThink = { 

	if ((world.model == "maps/sea.bsp") && (time > self.time_sea_particles))
	{
		vector p_pos = self.origin;
		p_pos_x += random(-128, 128);
		p_pos_y += random(-128, 128);
		p_pos_z += 24; 
		makevectors (self.angles);
		p_pos += v_forward * random (64, 128);
			pointparticles(particleeffectnum("sea_particles"), p_pos , '0 0 0',1);
		self.time_sea_particles = time + random (1, 2);
	}

	// Reki: March 28, 2023
	// replaced stuffcmds with .r_saturation stat
	// added r_healthhaze for low hp
	float saturation_wanted = 1;
	float saturation_speed = 0.5;
	float healthhaze_wanted = 0;
	float healthhaze_speed = 0.2;
	if (self.deadflag != DEAD_NO)
	{
		saturation_wanted = 0.05;
		saturation_speed = 1;
	}
	else
	{
		if (self.displacement_active)
		{
			saturation_wanted = min(saturation_wanted, 0.7);
		}
		
		if (time < self.Aegis_time)
		{
			saturation_wanted = min(saturation_wanted, 0.5);
		}
		else
		{
			const float danger_health = 15;
			const float low_health = 40;

			if (self.health <= danger_health)
			{
				float sinwave = sin(time * 4);

				saturation_wanted = min(saturation_wanted, 0.7 + (sinwave * 0.07));
				healthhaze_wanted = max(healthhaze_wanted, 0.12 + (-sinwave * 0.01));
			}
			else if (self.health < low_health)
			{
				sinwave = sin(time * 2.5);
				float frac = slerp(1, 0, ((self.health - danger_health) / (low_health - danger_health)));

				saturation_wanted = min(saturation_wanted, 1 - ((0.2 + (sinwave * 0.07)) * frac));
				healthhaze_wanted = max(healthhaze_wanted, 0.04 * frac);
			}
		}

		if (time < self.flaskrage_time) // flask of rage raises saturation a bit
			saturation_wanted *= 1.2;
		
		if (self.health > 100) // overhealth raises saturation a tad
		{
			frac = min(1, (self.health - 100) / 100) * 0.1;
			saturation_wanted += frac;
		}
	}
	if (self.r_saturation != saturation_wanted)
	{
		if (self.r_saturation < saturation_wanted)
			self.r_saturation = min(saturation_wanted, self.r_saturation + (frametime * saturation_speed / timescale_current));
		else
			self.r_saturation = max(saturation_wanted, self.r_saturation - (frametime * saturation_speed / timescale_current));
	}
	if (self.r_healthhaze != healthhaze_wanted)
	{
		if (self.r_healthhaze < healthhaze_wanted)
			self.r_healthhaze = min(healthhaze_wanted, self.r_healthhaze + (frametime * healthhaze_speed / timescale_current));
		else
			self.r_healthhaze = max(healthhaze_wanted, self.r_healthhaze - (frametime * healthhaze_speed / timescale_current));
	}
	// Reki: April 3, 2023
	// Added zoom button
	#define ZOOM_SPEED 11
	float zoom_wanted = 1;
	if (self.button8 && !self.deadflag)
	{
		zoom_wanted = 0;
	}
	if (self.r_zoom < zoom_wanted)
		self.r_zoom = min(zoom_wanted, self.r_zoom + (frametime * ZOOM_SPEED * 1.2));
	else
		self.r_zoom = max(zoom_wanted, self.r_zoom - (frametime * ZOOM_SPEED));

	float cv_zoom = cvar ("zoom_factor");
	if(cv_zoom >= 9)
		cv_zoom = 9;
	self.viewzoom = lerp(1 - (cv_zoom / 10), 1, self.r_zoom);
	//
	// Reki (December 3 2023): Controller rumble on hit
	if (time > self.dmg_shake_poll)
	{
		if (self.dmg_shake_saved || self.dmg_shake_taken)
		{
			float amt = 80 + (self.dmg_shake_taken * 7) + (self.dmg_shake_saved * 3.2);
			float highfreq = ((self.dmg_shake_saved / 100) * 0.8) + ((self.dmg_shake_taken / 100) * 0.2);
			float lowfreq = ((self.dmg_shake_taken / 100) * 2);

			if (self.health < 20)
				lowfreq *= 2.5;
			else if (self.health < 40)
				lowfreq *= 1.8;

			Controller_Rumble(self, min(lowfreq, 1), min(highfreq, 1), min(amt, 1300));

			self.dmg_shake_saved = 0;
			self.dmg_shake_taken = 0;
			self.dmg_shake_poll = time + 0.15;
		}
	}
	//

	if (self.deadflag)
		return;
	if (self.playerdeadtime > time)
		return;

	if (self.changing_level == 1)
		return;
	if(self.vhud == 3)
	{
		//self.movetype = 0;
		return;
	}
	///////
	if (self.dmgbscreenf < time)
	{
		if (self.damagescreen &2)
			self.damagescreen -= 2;
	}

	if (self.dmgscreenf > time)
	{
		if (!(self.damagescreen &1))
			self.damagescreen += 1;
	}
	else
	{
		if (self.damagescreen &1)
			self.damagescreen -= 1;
	}

	///////
	if (self.dmgbscreenb < time)
	{
		if (self.damagescreen &8)
			self.damagescreen -= 8;
	}

	if (self.dmgscreenb > time)
	{
		if (!(self.damagescreen &4))
			self.damagescreen += 4;
	}
	else
	{
		if (self.damagescreen &4)
			self.damagescreen -= 4;
	}

	///////
	if (self.dmgbscreenl < time)
	{
		if (self.damagescreen &32)
			self.damagescreen -= 32;
	}

	if (self.dmgscreenl > time)
	{
		if (!(self.damagescreen &16))
			self.damagescreen += 16;
	}
	else
	{
		if (self.damagescreen &16)
			self.damagescreen -= 16;
	}

	///////
	if (self.dmgbscreenr < time)
	{
		if (self.damagescreen &128)
			self.damagescreen -= 128;
	}

	if (self.dmgscreenr > time)
	{
		if (!(self.damagescreen &64))
			self.damagescreen += 64;
	}
	else
	{
		if (self.damagescreen &64)
			self.damagescreen -= 64;
	}

	///////

	//////////////////////	
	if ((self.flags &FL_ONGROUND) && (self.lungefree > time))
	self.lungefree = 0;
	if ((self.flags &FL_ONGROUND) && (self.melee_released > 0) && (!self.button3) && (time > self.melee_jump_time))
		self.melee_released = 0;
	if ((self.fakewatertype) && (self.watertype_time < time))
		self.fakewatertype = 0;

	if (self.wrath_debug_screen)
		checking_enemies();



	ArtifactClientModel();
	WeaponFrames();	// do weapon stuff



	if(self.icetime > time)
	{
		if(self.friction != 0.125)
			self.friction = 0.125;
	}
	else
	{
		if(self.friction != 1)
			self.friction = 1;
	}

	if ((self.icetime > time ) && (self.icetime - time <= 0.1)) 
	{
		traceline(self.origin, self.origin - '0 0 64', TRUE, self);
		float material = GetFootMaterial(self);
		if((trace_dphitq3surfaceflags & 2) || (material == MAT_ICE))
		self.icetime =  time + 0.5;
	}

	if ((self.maxspeed >= 0.75) && (self.movement))
	PlayerFootstep();
	// check to see if player landed and play landing sound	

	if ((self.jump_flag < -150) && (self.jumpinwatertime < time) && (self.watertype_time > time) && (self.jumpinwater == 0))
	{
		if ((self.fakewatertype == CONTENT_WATER) || (self.watertype == CONTENT_WATER) || (self.fakewatertype == CONTENT_BLOOD)||(self.fakewatertype == CONTENT_SLIME) || (self.watertype == CONTENT_SLIME)) 
		{
			self.jump_flag = 0;
			self.jumpinwater = 1;
			self.jumpinwatertime = time + 2.5;
			self.fall_state = FALSE;
			sound(self, CHAN_AUTO, "player/water_enter1.ogg", 1, ATTN_NORM);
			pointparticles(particleeffectnum("bubbles"), self.origin - '0 0 48',self.velocity, 3);
			pointparticles(particleeffectnum("bubbles"), self.origin - '0 0 16',self.velocity, 1);
			if(world.model == "maps/boss3.bsp")
			{	
				self.fakewatertype = CONTENT_BLOOD;
				self.oldwatertype = CONTENT_BLOOD;
			}
			if(self.fakewatertype == CONTENT_WATER)
			{
				pointparticles(particleeffectnum("water_splash"), self.origin - '0 0 16','0 0 0', 1);
				pointparticles(particleeffectnum("water_splash2"), self.origin - '0 0 16','0 0 0', 1);
			}
			if(self.fakewatertype == CONTENT_BLOOD)
			{
				pointparticles(particleeffectnum("blood_splash"), self.origin - '0 0 16','0 0 0', 1);
				pointparticles(particleeffectnum("blood_splash2"), self.origin - '0 0 16','0 0 0', 1);
			}
			if(self.fakewatertype == CONTENT_SLIME)
			{
				pointparticles(particleeffectnum("slime_splash"), self.origin - '0 0 16','0 0 0', 1);
				pointparticles(particleeffectnum("slime_splash2"), self.origin - '0 0 16','0 0 0', 1);
			}

		}
	}

	if ((self.jump_flag < -250) && (self.flags &FL_ONGROUND) && (self.health > 0))
	{
		if ((self.jump_flag < -250) && (self.jump_flag >= -650))
			playerlandsound(1);

		if (self.jump_flag < -650)
			playerlandsound(2);
		//T_Damage (self, world, world, 5); 

		self.jump_flag = 0;
	}

	if ((!(self.flags &FL_ONGROUND)) && (self.movetype == MOVETYPE_WALK))
	{
		if (self.flags &FL_INWATER)
			self.fall_state = FALSE;
		self.jump_flag = self.velocity_z;
		if (self.jump_flag < -1200)
			self.fall_state = TRUE;
	}
	else
	{
		if (self.fall_state == TRUE)
			self.fall_state = FALSE;
	}

	//	local string viewxanglesfactor;
	//float speed_f = vlen(self.velocity);
	//string viewxanglesfactor = strcat ((ftos (self.v_angle_x)), ("v angles x\n"));
	//bprint (viewxanglesfactor);

	//string viewxanglesfactor = strcat ((ftos (self.angles_x)), ("angles x\n"));
	//bprint (viewxanglesfactor);

	//local string lmessage;
	//lmessage =strcat ((self.nearestsurface),("\n")) ;
	//bprint (lmessage);
};
void() Check_FrikFile;

string nextmap;
void() monster_relocator = { local entity monster;

	monster = nextent(world);
	while (monster)
	{
		entity holder = nextent(monster);
		if ((monster.flags &FL_MONSTER) && (monster.health >= 0))
		{
			setorigin(monster, monster.oldorigin);
			monster.angles = monster.oldangles;
			monster.think = monster.th_stand;
			monster.nextthink = time;
			monster.enemy = 0;
		}

		monster = holder;	
	}
};
void(entity ownr) client_garbage_collector = { local entity garbage;
	garbage = nextent(world);
	while (garbage)	
	{
		entity holder = nextent(garbage);
		if ((garbage.wrathflags &FL_GARBAGE) && (garbage.owner == ownr))
		{
			remove(garbage);
		}

		garbage = holder;	
	}
	spawn_dead_model(ownr.origin, ownr.angles); // player models
};

void() garbage_collector = { local entity garbage;
	garbage = nextent(world);
	while (garbage)	
	{
		entity holder = nextent(garbage);
		if (garbage.wrathflags &FL_GARBAGE)
		{
			remove(garbage);
		}

		garbage = holder;	
	}
};
void() message_garbage_collector = { local entity garbage;
	garbage = nextent(world);
	while (garbage)	
	{
		entity holder = nextent(garbage);
		if (garbage.wrathflags &FL_MESSAGE)
		{
			remove(garbage);
		}
		garbage = holder;	
	}
};


void() fixcofferkeys = { local entity respawneable;
	respawneable = nextent(world);
	while (respawneable)	
	{
		entity holder = nextent(respawneable);
		if ((respawneable.wrathflags &FL_RESPAWN) && (respawneable.classname == "coffer_key"))
		{
			respawneable.touch = coffer_key_touch;
		}

		respawneable = holder;	
	}
};
void() respawn_entities = { local entity respawneable;
	respawneable = nextent(world);
	while (respawneable)	
	{
		entity holder = nextent(respawneable);
		if (respawneable.wrathflags &FL_RESPAWN)
		{
			respawneable.think = paste_old_data;
			respawneable.nextthink = time;
		}

		respawneable = holder;	
	}
};
void() SetChangeParms;
void(entity e) secrets_checkperfect // Reki (July 24 2023): check for map perfect, and unlock achievements accordingly
{
	for(float i = 0; i < rmap_list.length; i++)
	{
		regmap_t map = rmap_list[i];
		if (map.name != strtolower(mapname))
			continue;
		
		if (total_secrets == found_secrets)
		{
			e.perfect_maps |= map.bit;
			if (total_secrets) // we only want to give the perfect map achievement on maps that actually have 'chevos
			{
				Steam_AchievementUnlock(world, ST_ACHIEVEMENTS::SP_FEAT_SECRETS_LEVEL);
			}
		}
		break;
	}


	// multi-level perfectionist achievements
	const perfectep_t episode[] = {
		{PERFECT_EPISODE1, ST_ACHIEVEMENTS::SP_FEAT_SECRETS_E1},
		{PERFECT_EPISODE2, ST_ACHIEVEMENTS::SP_FEAT_SECRETS_E2},
		{PERFECT_EPISODE3, ST_ACHIEVEMENTS::SP_FEAT_SECRETS_E3},
		{LE_INTRO | PERFECT_EPISODE1 | PERFECT_EPISODE2 | PERFECT_EPISODE3, ST_ACHIEVEMENTS::SP_FEAT_SECRETS_ALL},
	};

	for(float i = 0; i < episode.length; i++)
	{
		perfectep_t ep = episode[i];
		if ((e.perfect_maps & ep.bits) == ep.bits) // if we have ALL the bits unlocked
		{
			Steam_AchievementUnlock(world, ep.ach);
		}
	}
}
void(entity e) coffers_checkperfect // Reki (July 24 2023): check for coffer amounts, unlock achievements accordingly
{
	if (e.opened_coffers >= 25) // whoopsie :\
	{
		Steam_AchievementUnlock(world, ST_ACHIEVEMENTS::SP_FEAT_COFFER_26);
	}
	if (e.opened_coffers >= 50)
	{
		Steam_AchievementUnlock(world, ST_ACHIEVEMENTS::SP_FEAT_COFFER_ALL);
	}
}

void() loadlevel = { stuffcmd(self, "slowmo 1\n");//stuffcmd(self, "r_glsl_saturation 1\n");
	read_currentprofileslot();
	stuffcmd(self, "set cvar_restoregame 1\n");
	string cname;
	cname = strcat("load data/profiles/", profilename, "/maps/", nextmap, "\n");
	stuffcmd(self, cname);
};

void() changemap = { changelevel(nextmap);
}

void(entity e) changelevel_wait = { e.changing_level = 1;
	e.nextthink = time + 1.5;
	e.think = changemap;
};
void() ParmstoFrik;
void(entity e) loadlevel_wait = { e.changing_level = 1;
	e.nextthink = time + 1.5;
	e.think = loadlevel;
};
void(entity e) changeparms2 = 
{ 
	parm1 = e.items;
	parm2 = e.health;
	parm3 = e.weapon;
	parm4 = e.revolverclip;
	parm5 = e.ammo_shotgun;
	parm6 = e.ammo_revolver;
	parm7 = e.ammo_spitter;
	parm8 = e.ammo_retcher;
	parm9 = e.ammo_cannon;
	parm10 = e.ammo_lance;
	parm11 = e.ammo_crystal;
	parm12 = e.ammo_bfg;
	parm13 = e.shotgun_clip;
	parm14 = e.rarmorvalue;
	parm15 = e.darmorvalue;
	parm16 = e.SoulTether;
	parm17 = e.LifeSiphon;
	parm18 = e.TrinketofRespite;
	parm19 = e.Attar;
	parm20 = e.Aegis;
	parm21 = e.flaskrage;
	parm22 = e.DrownerApp;
	parm23 = e.MarkRevelation;
	parm24 = e.BlackGrenade;
	parm25 = e.ViciousIdol;
	parm26 = e.ShockWave;
	parm27 = e.location;
	parm28 = e.explored_maps;
	parm29 = e.spotted_maps;
	parm30 = e.relics;
	parm31 = e.slot_relics;
	parm32 = e.oldrelics;
	parm33 = e.journal_jmessages;
	parm34 = e.journal_jmessagesm;
	parm35 = e.foundedrelics;
	parm36 = e.centerprint_messages;
	parm37 = e.savedlist;
	parm38 = e.playerflags;
	parm39 = (numfield_fetchindex(e.s_relics, 0)) | (numfield_fetchindex(e.s_relics, 1) << 6) | (numfield_fetchindex(e.s_relics, 2) << 12) | (numfield_fetchindex(e.s_relics, 3) << 18);
	parm40 = (numfield_fetchindex(e.s_relics, 4)) | (numfield_fetchindex(e.s_relics, 5) << 6) | (numfield_fetchindex(e.s_relics, 6) << 12) | (numfield_fetchindex(e.s_relics, 7) << 18);
	parm41 = e.perfect_maps;
	parm42 = e.opened_coffers;
};
void(entity e) GotoNextMap = { stuffcmd(e, "bf 0 0 0 2 0\n");
	local float loadingmap;
	if ((e.explored_maps &LE_INTRO) && (nextmap == "intro"))
		loadingmap = 1;
	if ((e.explored_maps &LE_HUB1) && (nextmap == "hub1"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M1) && (nextmap == "e1m1"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M2) && (nextmap == "e1m2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M3) && (nextmap == "e1m3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M4) && (nextmap == "e1m4"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M5) && (nextmap == "e1m5"))
		loadingmap = 1;
	if ((e.explored_maps &LE_BOSS1) && (nextmap == "boss1"))
		loadingmap = 1;

	if ((e.explored_maps &LE_HUB2) && (nextmap == "hub2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M1) && (nextmap == "e2m1"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M2) && (nextmap == "e2m2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M3) && (nextmap == "e2m3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M4) && (nextmap == "e2m4"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M5) && (nextmap == "e2m5"))
		loadingmap = 1;
	if ((e.explored_maps &LE_BOSS2) && (nextmap == "boss2"))
		loadingmap = 1;


	if ((e.explored_maps &LE_HUB3) && (nextmap == "hub3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M1) && (nextmap == "e3m1"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M2) && (nextmap == "e3m2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M3) && (nextmap == "e3m3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M4) && (nextmap == "e3m4"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M5) && (nextmap == "e3m5"))
		loadingmap = 1;
	if ((e.explored_maps &LE_BOSS3) && (nextmap == "boss3"))
		loadingmap = 1;

	// Reki (July 24 2023): double check map perfection
	secrets_checkperfect(e);
	coffers_checkperfect(e);

	//changeparms2(e);
	if (loadingmap == 1)
		loadlevel_wait(e);
	else
		changelevel_wait(e);

};
string currentmap;
void(entity e) write_exploredmap = {read_currentprofileslot();
	local string saveloc, savestats;
	saveloc = strcat("save data/profiles/", profilename, "/maps/", currentmap, "\n");

	stuffcmd(e, "scratch1 1\n");
	stuffcmd(e, saveloc);
	stuffcmd(e, "scratch1 0\n");
	savestats = strcat("profiles/", profilename, "/maps/", currentmap, ".stats");
	float save_stats;
	string writethis;
	save_stats = fopen_wrath(savestats, FILE_WRITE);
	writethis = strcat(ftos(killed_monsters), "/", ftos(total_monsters));
	fputs(save_stats, writethis);fputs(save_stats, "\n");
	writethis = strcat(ftos(found_secrets), "/", ftos(total_secrets));
	fputs(save_stats, writethis);fputs(save_stats, "\n");

	// Reki (February 6 2024): ... what
	// I'm at least making these else ifs

	string hasrelic;
	if (world.model == "maps/intro.bsp")
	{
		if (e.foundedrelics &RL_INTR)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e1m1.bsp")
	{
		if (e.foundedrelics &RL_E1M1)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e1m2.bsp")
	{
		if (e.foundedrelics &RL_E1M2)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e1m3.bsp")
	{
		if (e.foundedrelics &RL_E1M3)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e1m4.bsp")
	{
		if (e.foundedrelics &RL_E1M4)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e1m5.bsp")
	{
		if (e.foundedrelics &RL_E1M5)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e2m1.bsp")
	{
		if (e.foundedrelics &RL_E2M1)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e2m2.bsp")
	{
		if (e.foundedrelics &RL_E2M2)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e2m3.bsp")
	{
		if (e.foundedrelics &RL_E2M3)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e2m4.bsp")
	{
		if (e.foundedrelics &RL_E2M4)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e2m5.bsp")
	{
		if (e.foundedrelics &RL_E2M5)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e3m1.bsp")
	{
		if (e.foundedrelics &RL_E3M1)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e3m2.bsp")
	{
		if (e.foundedrelics &RL_E3M2)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e3m3.bsp")
	{
		if (e.foundedrelics &RL_E3M3)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e3m4.bsp")
	{
		if (e.foundedrelics &RL_E3M4)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	else if (world.model == "maps/e3m5.bsp")
	{
		if (e.foundedrelics &RL_E3M5)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	writethis = strcat(hasrelic, "/1");
	fputs(save_stats, writethis);fputs(save_stats, "\n");
	local string strTime;
	strTime = SG_GetFormattedTimeStringUnZoned(time);
	writethis = (strTime);
	fputs(save_stats, writethis);fputs(save_stats, "\n");
	fclose_wrath(save_stats);

	GotoNextMap(e);
	//	e.effects += 1024;
	//	stuffcmd (e, "bf 0 0 0 1 0.5\n");

	///////
};
void() changelevel_touch = { if (self.wait > time)
		return;
	if (other.classname != "player")
		return;
	message_garbage_collector ();
	nowater_type();
	if (time < other.totallungetime)
		return;
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;
	garbage_collector();
	local entity secret_entity;
	secret_entity = nextent(world);
	while (secret_entity)	
	{
		entity holder = nextent(secret_entity);
		if(secret_entity.wrathflags &FL_SECRET)
		{
			secret_entity.ammo_revolver = 0;
		}
		secret_entity = holder;	
	}
	other.Aegis_time = 0;
	other.LifeSiphon_time = 0;
	other.DrownerApp_time = 0;
	other.flaskrage_time = 0;
	other.displacement_time = 0;
	other.wrath_time = 0;
	other.timefly = 0;


	if (other.journal > 0)
	{
		sound(self, CHAN_AUTO, "ui/journal/journal_close.ogg", 1, 0);
		stuffcmd(self, "scratch3 0\n");
		other.journal = 0;
	}

	if(self.spawnflags & 2)
		other.oldrelics = 0;

	if(other.meleeskin == 1)
	{
		if(!(other.playerflags & FL_BLADEBLOOD)) 
			other.playerflags += FL_BLADEBLOOD;	
	}
	else
	{
		if(other.playerflags & FL_BLADEBLOOD) 
			other.playerflags -= FL_BLADEBLOOD;	
	}	

/*	if(invrtmsb)
	stuffcmd(other, "m_pitch -0.001\n");
	else
	stuffcmd(other, "m_pitch 0\n");
	
	stuffcmd(other, "m_yaw 0\n");
*/	
	if (!self.location)
		other.location = 0;
	else
		other.location = self.location;
	bprint(other.netname);
	bprint(" exited the level\n");
	nextmap = self.map;

	local float nLength;
	local string namewbsp, namecomplete, currentmaplocal;
	currentmaplocal = world.model;
	namecomplete = substring(currentmaplocal, 5, 100);
	nLength = strlen(namecomplete);
	namewbsp = substring(namecomplete, 0, nLength - 4);
	currentmap = namewbsp;

	other.items = other.items - (other.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
	other.slot_keys = 0;
	SUB_UseTargets();

	local float loadingmap;
	if (world.model == "maps/intro.bsp")
	{
		if (!(other.explored_maps &LE_INTRO))
			other.explored_maps += LE_INTRO;
		loadingmap = 1;
	}
	
	if (world.model == "maps/hub1.bsp")
	{
		if (!(other.explored_maps &LE_HUB1))
			other.explored_maps += LE_HUB1;
		loadingmap = 1;
	}
	if (world.model == "maps/e1m1.bsp")
	{
		if (!(other.explored_maps &LE_E1M1))
			other.explored_maps += LE_E1M1;
		loadingmap = 1;
	}
	if (world.model == "maps/e1m2.bsp")
	{
		if (!(other.explored_maps &LE_E1M2))
			other.explored_maps += LE_E1M2;
		loadingmap = 1;
	}

	if (world.model == "maps/e1m3.bsp")
	{
		if (!(other.explored_maps &LE_E1M3))
			other.explored_maps += LE_E1M3;
		loadingmap = 1;
	}
	if (world.model == "maps/e1m4.bsp")
	{
		if (!(other.explored_maps &LE_E1M4))
			other.explored_maps += LE_E1M4;
		loadingmap = 1;
	}

	if (world.model == "maps/e1m5.bsp")
	{
		if (!(other.explored_maps &LE_E1M5))
			other.explored_maps += LE_E1M5;
		loadingmap = 1;
	}
	if (world.model == "maps/boss1.bsp")
	{
		if (!(other.explored_maps &LE_BOSS1))
			other.explored_maps += LE_BOSS1;
		loadingmap = 1;
	}

	if (world.model == "maps/hub2.bsp")
	{
		if (!(other.explored_maps &LE_HUB2))
			other.explored_maps += LE_HUB2;
		loadingmap = 1;
	}
	if (world.model == "maps/e2m1.bsp")
	{
		if (!(other.explored_maps &LE_E2M1))
			other.explored_maps += LE_E2M1;
		loadingmap = 1;
	}
	if (world.model == "maps/e2m2.bsp")
	{
		if (!(other.explored_maps &LE_E2M2))
			other.explored_maps += LE_E2M2;
		loadingmap = 1;
	}
	if (world.model == "maps/e2m3.bsp")
	{
		if (!(other.explored_maps &LE_E2M3))
			other.explored_maps += LE_E2M3;
		loadingmap = 1;
	}
	if (world.model == "maps/e2m4.bsp")
	{
		if (!(other.explored_maps &LE_E2M4))
			other.explored_maps += LE_E2M4;
		loadingmap = 1;
	}
	if (world.model == "maps/e2m5.bsp")
	{
		if (!(other.explored_maps &LE_E2M5))
			other.explored_maps += LE_E2M5;
		loadingmap = 1;
	}
	if (world.model == "maps/boss2.bsp")
	{
		if (!(other.explored_maps &LE_BOSS2))
			other.explored_maps += LE_BOSS2;
		loadingmap = 1;
	}

	if (world.model == "maps/hub3.bsp")
	{
		if (!(other.explored_maps &LE_HUB3))
			other.explored_maps += LE_HUB3;
		loadingmap = 1;
	}
	if (world.model == "maps/e3m1.bsp")
	{
		if (!(other.explored_maps &LE_E3M1))
			other.explored_maps += LE_E3M1;
		loadingmap = 1;
	}
	if (world.model == "maps/e3m2.bsp")
	{
		if (!(other.explored_maps &LE_E3M2))
			other.explored_maps += LE_E3M2;
		loadingmap = 1;
	}
	if (world.model == "maps/e3m3.bsp")
	{
		if (!(other.explored_maps &LE_E3M3))
			other.explored_maps += LE_E3M3;
		loadingmap = 1;
	}
	if (world.model == "maps/e3m4.bsp")
	{
		if (!(other.explored_maps &LE_E3M4))
			other.explored_maps += LE_E3M4;
		loadingmap = 1;
	}
	if (world.model == "maps/e3m5.bsp")
	{
		if (!(other.explored_maps &LE_E3M5))
			other.explored_maps += LE_E3M5;
		loadingmap = 1;
	}
	if (world.model == "maps/boss3.bsp")
	{
		if (!(other.explored_maps &LE_BOSS3))
			other.explored_maps += LE_BOSS3;
		loadingmap = 1;
	}

	other.solid = 0;
	other.movetype = 0;
	other.speed = 0;
	self.wait = time + 5;

	changeparms2(other);
	ParmstoFrik();
	if (loadingmap == 1)
		write_exploredmap(other);
	else
		changelevel_wait(other);
	//GotoNextMap(other);

};

void() trigger_changelevel = { if (!self.map)
		objerror("changelevel trigger doesn't have map");
	InitTrigger();
	self.wait = 0;
	self.touch = changelevel_touch;
};

void() portal_level_active = { self.touch = changelevel_touch;
};

void() portal_level_to_hub_active = { self.frame = 1;
	self.effects = 0;
	self.think = portal_level_active;
	self.nextthink = time + 1;

	local float bparticle;
	bparticle = particleeffectnum("portalparticle");
	pointparticles(bparticle, self.origin, '0 0 0', 8);

	sound7(self, CHAN_AUTO, "items/artifacts/artifactE_use.ogg", 1, 0.15,70,0);
};

void() portal_level_to_hub_active_wait = { self.think = portal_level_to_hub_active;
	self.nextthink = time + self.wait;
};

/*
ENTITY NAME:     portal_level_to_hub         
MODEL:            models/portals/portal_level_to_hub.md3
BBOX SIZE:        '-32 -32 -64'
KEYS:
   [MAP]            <mapname to go to>
   [LOCATION]       <N>
   [CUBEMAP]       <N>
   [TARGET NAME]   <used to activate portal upon Relic pickup>
BEHAVIOR:
portal is inactive (frame 0) until triggered by Relic pickup, then plays a 1 sec animation (framegroup, 20fps, frame 0-19) then is active (frame 19) for the rest of the game
*/
void() portal_level_to_hub = { precache_model("models/portals/portal_level_to_hub.md3");
	setmodel(self, "models/portals/portal_level_to_hub.md3");
	self.solid = SOLID_TRIGGER;
	self.effects = EF_NODRAW;
	if (!self.wait)
		self.wait = 1;
	setsize(self, '-32 -32 -64', '32 32 64');

	if (self.targetname)
		self.use = portal_level_to_hub_active_wait;
	else
	{
		self.think = portal_level_to_hub_active;
		self.nextthink = time;
	}
};
.float angle2;
void() place_shepherd_filter;
entity() SelectSpawnPoint = { local entity spot;

	// testinfo_player_start is only found in regioned levels
	spot = find(world, classname, "testplayerstart");
	if (spot)
		return spot;

	// choose a info_player_deathmatch point
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find(lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
		lastspawn = find(lastspawn, classname, "info_player_deathmatch");
		if (lastspawn == world)
			lastspawn = find(lastspawn, classname, "info_player_deathmatch");
		if (lastspawn != world)
			return lastspawn;
	}




	local entity bot;
	bot = find(world, classname, "info_player_start");
	while (bot)
	{
		if (bot.location == self.location)
		{
			spot = bot;
		}

		bot = find(bot, classname, "info_player_start");
	}

	if ((self.location) && (!spot))
		spot = find(world, classname, "info_player_start");

	if (!spot)
	{
		bot = find(world, classname, "info_player_deathmatch");
		while (bot != world)
		{
			if (bot.location == self.location)
			{
				spot = bot;
			}

			bot = find(bot, classname, "info_player_deathmatch");
		}

		if ((self.location) && (!spot))
			spot = find(world, classname, "info_player_deathmatch");
	}

	if (!spot)
		error("PutClientInServer: no info_player_start on level");
		
	return spot;
};
void() DecodeLevelParms;
void() FriktoParms = { local float readparms;
	local string readtext, saveloc;
	DecodeLevelParms();
	read_currentprofileslot();
	saveloc = strcat("profiles/", profilename, "/frikparms.kp1");
	readparms = fopen(saveloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);parm1 = stof(readtext);
	readtext = fgets(readparms);parm2 = stof(readtext);
	readtext = fgets(readparms);parm3 = stof(readtext);
	readtext = fgets(readparms);parm4 = stof(readtext);
	readtext = fgets(readparms);parm5 = stof(readtext);
	readtext = fgets(readparms);parm6 = stof(readtext);
	readtext = fgets(readparms);parm7 = stof(readtext);
	readtext = fgets(readparms);parm8 = stof(readtext);
	readtext = fgets(readparms);parm9 = stof(readtext);
	readtext = fgets(readparms);parm10 = stof(readtext);
	readtext = fgets(readparms);parm11 = stof(readtext);
	readtext = fgets(readparms);parm12 = stof(readtext);
	readtext = fgets(readparms);parm13 = stof(readtext);
	readtext = fgets(readparms);parm14 = stof(readtext);
	readtext = fgets(readparms);parm15 = stof(readtext);
	readtext = fgets(readparms);parm16 = stof(readtext);
	readtext = fgets(readparms);parm17 = stof(readtext);
	readtext = fgets(readparms);parm18 = stof(readtext);
	readtext = fgets(readparms);parm19 = stof(readtext);
	readtext = fgets(readparms);parm20 = stof(readtext);
	readtext = fgets(readparms);parm21 = stof(readtext);
	readtext = fgets(readparms);parm22 = stof(readtext);
	readtext = fgets(readparms);parm23 = stof(readtext);
	readtext = fgets(readparms);parm24 = stof(readtext);
	readtext = fgets(readparms);parm25 = stof(readtext);
	readtext = fgets(readparms);parm26 = stof(readtext);
	readtext = fgets(readparms);parm27 = stof(readtext);
	readtext = fgets(readparms);parm28 = stof(readtext);
	readtext = fgets(readparms);parm29 = stof(readtext);
	readtext = fgets(readparms);parm30 = stof(readtext);
	readtext = fgets(readparms);parm31 = stof(readtext);
	readtext = fgets(readparms);parm32 = stof(readtext);
	readtext = fgets(readparms);parm33 = stof(readtext);
	readtext = fgets(readparms);parm34 = stof(readtext);
	readtext = fgets(readparms);parm35 = stof(readtext);
	readtext = fgets(readparms);parm36 = stof(readtext);
	readtext = fgets(readparms);parm37 = stof(readtext);
	readtext = fgets(readparms);parm38 = stof(readtext);
	readtext = fgets(readparms);parm39 = stof(readtext);
	readtext = fgets(readparms);parm40 = stof(readtext);
	readtext = fgets(readparms);parm41 = stof(readtext);
	readtext = fgets(readparms);parm42 = stof(readtext);
	readtext = fgets(readparms);parm43 = stof(readtext);
	fclose(readparms);

};
void() ParmstoFrik = { local float writeparms;
	local string writethis, saveloc;
	read_currentprofileslot();
	self.slot_keys = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
	saveloc = strcat("profiles/", profilename, "/frikparms.kp1");
	writeparms = fopen(saveloc, FILE_WRITE);	//open what file to use in write mode
	writethis = ftos(parm1);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm2);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm3);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm4);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm5);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm6);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm7);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm8);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm9);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm10);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm11);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm12);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm13);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm14);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm15);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm16);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm17);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm18);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm19);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm20);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm21);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm22);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm23);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm24);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm25);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm26);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm27);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm28);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm29);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm30);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm31);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm32);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm33);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm34);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm35);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm36);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm37);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm38);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm39);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm40);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm41);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm42);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm43);fputs(writeparms, writethis);fputs(writeparms, "\n");
	fclose(writeparms);
};

void() SetChangeParms = {
	if (self.health <= 0)
	{
		self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
		self.slot_keys = 0;
		SetNewParms();
		return;
	}

	// remove items
	self.slot_keys = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
	// cap super health
	if (self.health > 100)
		self.health = 100;

	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.weapon;
	parm4 = self.revolverclip;
	parm5 = self.ammo_shotgun;
	parm6 = self.ammo_revolver;
	parm7 = self.ammo_spitter;
	parm8 = self.ammo_retcher;
	parm9 = self.ammo_cannon;
	parm10 = self.ammo_lance;
	parm11 = self.ammo_crystal;
	parm12 = self.ammo_bfg;
	parm13 = self.shotgun_clip;
	parm14 = self.rarmorvalue;
	parm15 = self.darmorvalue;
	parm16 = self.SoulTether;
	parm17 = self.LifeSiphon;
	parm18 = self.TrinketofRespite;
	parm19 = self.Attar;
	parm20 = self.Aegis;
	parm21 = self.flaskrage;
	parm22 = self.DrownerApp;
	parm23 = self.MarkRevelation;
	parm24 = self.BlackGrenade;
	parm25 = self.ViciousIdol;
	parm26 = self.ShockWave;
	parm27 = self.location;
	parm28 = self.explored_maps;
	parm29 = self.spotted_maps;
	parm30 = self.relics;
	parm31 = self.slot_relics;
	parm32 = self.oldrelics;
	parm33 = self.journal_jmessages;
	parm34 = self.journal_jmessagesm;
	parm35 = self.foundedrelics;
	parm36 = self.centerprint_messages;
	parm37 = self.savedlist;
	parm38 = self.playerflags;
	parm39 = (numfield_fetchindex(self.s_relics, 0)) | (numfield_fetchindex(self.s_relics, 1) << 6) | (numfield_fetchindex(self.s_relics, 2) << 12) | (numfield_fetchindex(self.s_relics, 3) << 18);
	parm40 = (numfield_fetchindex(self.s_relics, 4)) | (numfield_fetchindex(self.s_relics, 5) << 6) | (numfield_fetchindex(self.s_relics, 6) << 12) | (numfield_fetchindex(self.s_relics, 7) << 18);
	parm41 = self.perfect_maps;
	parm42 = self.opened_coffers;
	parm43 = 1;
};

void() SetNewParms = 
{ 
	if (!self.nomelee)
	{
		parm1 = IT_MELEE + IT_VIEWMODEL;	//items
		parm3 = IT_MELEE;	// weapon
	}
	else
	{
		parm1 = 0;	// items
		parm3 = 0;	// weapon
	}

	parm2 = 100; //self.health;
	parm4 = 0; //self.revolverclip;
	parm5 = 0; //self.ammo_shotgun;
	parm6 = 0; //self.ammo_revolver;
	parm7 = 0; //self.ammo_spitter;
	parm8 = 0; //self.ammo_retcher;
	parm9 = 0; //self.ammo_cannon;
	parm10 = 0; //self.ammo_lance;
	parm11 = 0; //self.ammo_crystal;
	parm12 = 0; //self.ammo_bfg;
	parm13 = 2; //self.shotgun_clip;
	parm14 = 0; //self.rarmorvalue;
	parm15 = 0; //self.darmorvalue;
	parm16 = 0; //self.SoulTether;
	parm17 = 0; //self.LifeSiphon;
	parm18 = 0; //self.TrinketofRespite;
	parm19 = 0; //self.Attar;
	parm20 = 0; //self.Aegis;
	parm21 = 0; //self.flaskrage;
	parm22 = 0; //self.DrownerApp;
	parm23 = 0; //self.MarkRevelation;
	parm24 = 0; //self.BlackGrenade;
	parm25 = 0; //self.ViciousIdol;
	parm26 = 0; //self.ShockWave;
	parm27 = 0; //self.location;
	parm28 = 0; //self.explored_maps;
	parm29 = 0; //self.spotted_maps;
	parm30 = 0; //self.relics;
	parm31 = 0; //self.slot_relics;
	parm32 = 0; //self.oldrelics;
	parm33 = 0; //self.journal_jmessages;
	parm34 = 0; //self.journal_jmessagesm;
	parm35 = 0; //self.foundedrelics;
	parm36 = 0; //self.centerprint_messages;
	parm37 = 0; //self.savedlist;
	parm38 = 0; //self.playerflags;
	parm39 = 0; //self.s_relics (0-3)
	parm40 = 0; //self.s_relics (4-7)
	parm41 = 0; // Reki (July 24 2023): parm41 stores "perfect_maps" using the LE_* constants
	parm42 = 0; // Reki (July 24 2023): parm42 stores total number of opened coffers
	parm43 = 0; // Reki (October 6 2023): parm43 for checking if this is a fresh save
};

void() DecodeLevelParms = 
{ 
	self.items= parm1;
	self.health= parm2;
	self.weapon= parm3;
	self.revolverclip= parm4;
	self.ammo_shotgun= parm5;
	self.ammo_revolver= parm6;
	self.ammo_spitter= parm7;
	self.ammo_retcher= parm8;
	self.ammo_cannon= parm9;
	self.ammo_lance= parm10;
	self.ammo_crystal= parm11;
	self.ammo_bfg= parm12;
	self.shotgun_clip= parm13;
	self.rarmorvalue= parm14;
	self.darmorvalue= parm15;
	self.SoulTether= parm16;
	self.LifeSiphon= parm17;
	self.TrinketofRespite= parm18;
	self.Attar= parm19;
	self.Aegis= parm20;
	self.flaskrage= parm21;
	self.DrownerApp= parm22;
	self.MarkRevelation= parm23;
	self.BlackGrenade= parm24;
	self.ViciousIdol= parm25;
	self.ShockWave= parm26;
	self.location= parm27;
	self.explored_maps= parm28;
	self.spotted_maps= parm29;
	self.relics= parm30;
	self.slot_relics= parm31;
	self.oldrelics= parm32;
	self.journal_jmessages= parm33;
	self.journal_jmessagesm= parm34;
	self.foundedrelics= parm35;
	self.centerprint_messages= parm36;
	self.savedlist= parm37;
	self.playerflags= parm38;
	
	// Reki (April 18 2023): new relic slot system
	// parm 39 and 40, restore relic slots
	if (self.s_relics)
		strunzone(self.s_relics);
	self.s_relics = __NULL__;
	float rel;
	rel = (parm39 >> 0) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	rel = (parm39 >> 6) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	rel = (parm39 >> 12) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	rel = (parm39 >> 18) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	rel = (parm40 >> 0) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	rel = (parm40 >> 6) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	rel = (parm40 >> 12) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	rel = (parm40 >> 18) & 0x3F; if (rel) numfield_addtostring(self.s_relics, rel);
	//

	// Reki (July 24 2023): parm41 stores "perfect_maps" for achievement hunting, using the LE_* constants
	self.perfect_maps = parm41;
	// parm42 stores total number of opened coffers
	self.opened_coffers = parm42;
	//

	// Reki (October 6 2023): parm43 fix item_donor_map
	if !(parm43)
		item_donor_mapforcethink();
};
void() door_puse;
void()door_preuse =
{
	if(other.classname != "player")
		return;
	self.duser = self;
	self.think = door_puse;
	self.touch = SUB_Null;
	self.nextthink = self.ltime + 0.01;
};
.float oldrelics_start;
.float notouch;

void()recount_monsters;




void() Apply_Lut =
{


	if((time > (self.autosavetime+ 0.5) ) && (self.restoredgame !=  1))
	{

		te_customflash(self.origin, 256, 1, '0.3 0.7 1');
		string flash_command_a = strcat ("bf ",ftos(flash_color_x)," ",ftos(flash_color_y)," ");
		string flash_command_b = strcat (ftos(flash_color_z)," ",ftos(flash_alpha)," ",ftos(flash_fade),"\n");
		string flash_command =  strcat (flash_command_a,flash_command_b);
		stuffcmd (self, flash_command);
	}


	if(self.displacement_time > time + 0.5)
	{
		localcmd("set cvar_otherdimension 1\n");
		//stuffcmd(self, "v_flipped 1\n");
		stuffcmd(self,"r_glsl_postprocess_color_lut gfx/lookup_artifact.png \n");
			sound (self, CHAN_AUTO, "items/sigils/sigil_flight_start.ogg",1 ,1);
		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 1\n");
		stuffcmd (self, "r_glsl_postprocess_uservec3 \"0.01 2 15 0\"\n");
	}
	else
	{
		localcmd("set cvar_otherdimension 0\n");
		localcmd("set cvar_otherdimension 0\n");

		stuffcmd(self, "v_flipped 0\n");
		local float check_lut = cvar ("saved9");
		if(check_lut == 1)
			stuffcmd (self, "r_glsl_postprocess_color_lut gfx/lookup_palettized.png\n");
		else
			stuffcmd(self,"r_glsl_postprocess_color_lut gfx/lookup_default.png \n");
		sound (self, CHAN_AUTO, "items/sigils/sigil_flight_end.ogg",1 ,1);
	}
};
.float sound7flags;
.float interior;
.float interior_time;
void()trigger_autofog_use;
void()soundbox_think;
void() play_ambient_sound;
void(entity ownr) client_shot_collector;


void() volumecontrollerthink =
{
	float finished_set;

	if(self.count < 1)
		self.count += 0.05; 
	else
		finished_set +=1 ;
	string chanzerovolume= ftos (self.count);

	if(self.count <= 1)
	stuffcmd(single_player,"snd_channel0volume ",chanzerovolume,"\n");

	if(self.cnt < 0.39)
		self.cnt += 0.0195; 
	else
		finished_set +=1 ;
	string staticvolume= ftos (self.cnt);

	if(self.cnt <= 0.39)
	stuffcmd(single_player,"snd_staticvolume ",staticvolume,"\n");


	if(finished_set > 1)
	{
		stuffcmd(single_player,"snd_staticvolume 0.39\n");
		stuffcmd(single_player,"snd_channel0volume 1\n");
		self.think = SUB_Remove;
	}
	else
		self.think = volumecontrollerthink;

	self.nextthink = time + 0.05;
};

void() loopedsoundsymbol_think =
{
	//if((self.owner.classname == "monster_symbol") && (self.owner.health > 0))
	//sound(self.owner, CHAN_VOICE2, "enemies/symbol/idle_loop.ogg", 0.5, 0.2);
	remove(self);
};
void() fixitems;
void soundbox_initializeambients(void);
void() RestoreGame = 
{
	FLASKRAGECOLOR_x = 1;
	FLASKRAGECOLOR_y = 0.7;
	FLASKRAGECOLOR_z = 0;
	self.check_centered = 1;
	single_player = self;
	localcmd("v_cshift\n");
	timescale(1.0);
	//stuffcmd(self, "r_glsl_saturation 1\n");
	stuffcmd (self,"gl_polyblend 1\n");

	stuffcmd(self, "scratch3 a\n");
	stuffcmd(self, "freelook 1\n");
	stuffcmd(self, "m_yaw 0.022\n");

	// Reki (February 14 2024)
	Check_SaveCompatibility();

	// Reki (October 6 2023): Relink all entities
	// this prevents an annoying engine bug where ents don't get linked on load
	fixitems();
	entity lst = world;
	while(lst = nextent(lst))
	{
		setorigin(lst, lst.origin);
	}
	//

	// Reki (April 11 2023): enforce cl_movement 0 to prevent collision issues
	self.disableclientprediction = TRUE;

	// Reki (May 31 2023): Resend localization files upon reload (since CSQC is flushed)
	Localization_ResendFileList(self);

	float autofog = cvar ("autofog");

	if((self.fogtrigger != world))
	{
		entity fog_restorer =  spawn();
		copyentity (self.fogtrigger, fog_restorer);
		fog_restorer.origin = self.origin;
		fog_restorer.owner = self;
		fog_restorer.wait =  0.1;
		fog_restorer.count = 0;
		fog_restorer.cnt = 0;
		fog_restorer.classname = "fog_restorer";
		fog_restorer.think = trigger_autofog_use;
		fog_restorer.nextthink = time + 0.25;
	}
	stuffcmd(self,"set autofog 1\n");
	stuffcmd(self,"snd_staticvolume 0 \n");
	stuffcmd(self,"snd_channel0volume 0 \n");

	entity volumecontroller = spawn();
	volumecontroller.think = volumecontrollerthink;
	volumecontroller.nextthink = time + 0.55;

	soundbox_initializeambients();
	sigils_initializeambients();
	entity loopedsoundsymbol = nextent(world);
	while (loopedsoundsymbol)	
	{
		entity holder = nextent(loopedsoundsymbol);
		if ((loopedsoundsymbol.classname == "monster_symbol") && (loopedsoundsymbol.health > 0))
		{
			entity looper_sound = spawn();
			looper_sound.owner = loopedsoundsymbol;
			looper_sound.think = loopedsoundsymbol_think;
			looper_sound.nextthink = time + 0.25;
		}

		loopedsoundsymbol = holder;	
	}

	entity warpedeffect = nextent(world);
	while (warpedeffect)	
	{
		entity holder = nextent(warpedeffect);
		if ((warpedeffect.classname == "enemy_spawner_warp") && (warpedeffect.cnt >= 1) &&(warpedeffect.frame >= 1))
		{
			warpedeffect.think = enemy_spawner_warp_use;
			warpedeffect.nextthink = time + 0.05;
		}
		warpedeffect = holder;	
	}

	self.interior_time =  time;
	self.journal = 0;
	local float invrtmsb;

	stuffcmd (self,"snd_identicalsoundrandomization_time 0.1\n");
	stuffcmd (self,"cl_decals_models 0\n");
	if (world.model == "maps/boss1.bsp")
	{
		stuffcmd (self,"snd_identicalsoundrandomization_time 0\n");
	}
	fixcofferkeys();
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;
	if (invrtmsb == 1)
		stuffcmd(self, "m_pitch -0.022\n");
	else
		stuffcmd(self, "m_pitch 0.022\n");


	if(self.Aegis_time > time)
	{
		self.aegisflag = 1;
	}

	if (self.DrownerApp_time > time)
	{
		stuffcmd (self,"gl_polyblend 0.33\n");
		self.glpolyblend = 1;
	}	
	else
	{
		stuffcmd (self,"gl_polyblend 1\n");
		self.glpolyblend = 0;
	}

	self.restoredgame = 1;
	Apply_Lut();
	local entity fixes;
	fixes = findradius(self.origin, 1000000);
	while (fixes)
	{
		entity hold = fixes.chain; // Reki (October 6 2023): accessing an entity's fields after a remove is undefined behavior, so let's not do that
		if ((fixes.classname == "coffer_trap")||(fixes.classname == "dancingfallen"))
		{
			remove(fixes);
		}

		fixes = hold;
	}

	if((skill == 0) && (world.model == "maps/e1m4.bsp"))
	{
		local entity fixed_door = find (world, targetname, "finalbars");
		if (fixed_door)
		{
			fixed_door.usable = 1;
			fixed_door.notouch = 0;
			fixed_door.targetname = "";
			fixed_door.touch = door_preuse;
		}
	}
	//stuffcmd(self, "bf 0 0 0 1.25 0.5\n");
	if (cvar("cvar_restoregame") == 2)
	{
	//message_garbage_collector ();
	//Hud_message(24, self.origin, self);
	localcmd("set cvar_restoregame 0\n");
		return;
	}
	if (cvar("cvar_restoregame") == 3)
	{
	//message_garbage_collector ();
	//Hud_message(26, self.origin, self);
	localcmd("set cvar_restoregame 0\n");
	return;
	}
	stuffcmd(self, "cl_movement_maxspeed 416 \n");
	stuffcmd(self, "sv_maxspeed 416 \n");
	stuffcmd(self, "cl_forwardspeed 416\n");
	stuffcmd(self, "cl_backspeed 416\n");
	stuffcmd(self, "cl_sidespeed 416\n");
	//stuffcmd(self, "v_idlescale 0 \n");

	if(self.wrath_active >= 1)
	{
		self.wrath_active = 1;
	}

	if(self.displacement_active >= 1)
	{	
		self.displacement_active = 1;
		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 1\n");
		stuffcmd (self, "r_glsl_postprocess_uservec3 \"0.01 2 15 0\"\n");
	}
				
	if (cvar("cvar_restoregame") != 1)
	{
		return;
	}

	self.flaskrage_active = 3;
	self.flaskrage_time = time;
	self.displacement_time = time;
	self.wrath_time = time;
	self.wrath_active = 3;
	//	SetChangeParms();
	monster_relocator();
	FriktoParms();
	DecodeLevelParms();
	respawn_entities();
	recount_monsters();
	//	ParmstoFrik();
	local entity spawn_spot;	// This holds where we want to spawn
	spawn_spot = SelectSpawnPoint();
	place_shepherd_filter(); // Reki (October 11 2023): Filter shepherd by .location

	self.changing_level = 0;
	if (self.health < 1)
		self.health = 1;
	self.max_health = 100;	// My health (and my max) is 100
	self.takedamage = DAMAGE_AIM;	// I can be fired at
	self.solid = SOLID_SLIDEBOX;	// Things sort of 'slide' past me
	if (self.timefly <= time)
	{
		self.radialactive = 0;
		self.movetype = MOVETYPE_WALK;	// Yep, I want to walk.
		stuffcmd (self, "alias +button4  \"\" \n");
		stuffcmd (self, "alias -button4  \"\" \n");
		stuffcmd (self, "alias +jump  \"\" \n");
		stuffcmd (self, "alias -jump  \"\" \n");
		stuffcmd (self, "-jump \n");
		stuffcmd (self, "-jump \n");
		stuffcmd (self, "-moveup \n");
		stuffcmd (self, "-movedown \n");
	}
	else
	{
		self.timeflyc = rint(time - self.timefly);
		if (self.movetype != MOVETYPE_FLY)
			self.movetype = MOVETYPE_FLY;
		stuffcmd (self, "alias +button4  \"+movedown\" \n");
		stuffcmd (self, "alias -button4  \"-movedown\" \n");
		stuffcmd (self, "alias +jump  \"+moveup\" \n");
		stuffcmd (self, "alias -jump  \"-moveup\" \n");
	}


	self.flags = FL_CLIENT;	// Yes, I'm a client.
	self.origin = spawn_spot.origin;	// + '0 0 10';	// Move to the spawnspot location
	self.angles = spawn_spot.angles;	// Face the angle the spawnspot indicates
	self.fixangle = TRUE;	// Turn this way immediately
	setmodel(self, "models/misc/null.md3");	// Set my player to the player model
	//setmodel(self, "models/enemies/fallen/fallen1.md3");
	setsize(self, '-16 -16 -32', '16 16 32');
	self.view_ofs_z = player_zviewofs;	// Center my view
	self.velocity = '0 0 0';	// Stop any old movement
	self.revolverclip = 0;
	//	self.ammo_revolver = 0;

	self.air_finished = time + 12;
	self.attack_finished = time;
	self.th_pain = Player_Pain;
	self.th_die = Player_Die;
	self.maxspeed = 1;
	self.realmaxspeed = 1;
	self.fwatershift = TRUE;	// catch runaway cshifts (changlevel/respawn while in func_water)
	self.oldgravity = 0;	// use unmodified sv_gravity
	Check_FrikFile();
	fixes = findradius(self.origin, 1000000);
	while (fixes)
	{
		entity hold = fixes.chain;
		if ((fixes.classname == "player_weaponmodel"))
			remove(fixes);
		fixes = hold;
	}

	self.vweapon = spawn();
	self.vweapon.classname = "player_weaponmodel";
	self.vweapon.owner = self;
	self.vweapon.wrathflags += FL_GARBAGE;
	self.vweapon.viewmodelforclient = self;
	self.vweapon.think = Think_Vweapon;
	self.vweapon.angles_y = 0;
	self.vweapon.angles_x = 0;
	self.vweapon.angles_z = 0;
	self.vweapon.nextthink = time;
	raise_weapon();
	self.effects = self.effects + EF_NOSHADOW;
	stuffcmd(self, "-attack\n");	// 
	self.vweapon.origin_z = self.dvweapon_z;
	self.holdcannon = 0.1;
	self.holdcannontime = 0.1;
	PlayerValuesEditor();
	check_retcher();
	self.nomelee = spawn_spot.nomelee;
	////lbeams
	self.charge_shotgun = 1;

	check_tether_inmap();
	self.deadflag = 0;
	self.artifact_model_client = 0;
	stuffcmd(self, "sv_freezenonclients 0\n");

	if (cvar_string("cvar_restoregame") == "")
		localcmd("set cvar_restoregame 0\n");
	self.location = 0;
	self.viewzoom = 1;
	self.oldrelics_start = self.oldrelics;

	self.autosaved = 0;
	self.menuactive = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
	self.slot_keys = 0;
	if (self.playerflags & FL_INFINITESAVES) 
		localcmd("seta infinite_saves 1\n");
	else	
		localcmd("seta infinite_saves 0\n");
	client_shot_collector(self);

	if(self.playerflags & FL_BLADEBLOOD) 
		self.meleeskin = 1;
	else
		self.meleeskin = 0;

	if(self.playerflags & FL_MACEBLOOD) 
		self.macemeleeskin = 1;
	else
		self.macemeleeskin = 0;

	stuffcmd(self, "seta snd_channel32volume 0\n");
    self.jason = cvar ("jason");
	stuffcmd (self,"get_fog\n");


	self.sigil_time = time;
	self.radial_time = time;
	stuffcmd (self,"gl_polyblend 1\n");
	//stuffcmd (self, "r_glsl_saturation 1\n");



		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 0\n");
		stuffcmd (self, "r_glsl_postprocess_uservec3 \"0 0 0 0\"\n");
	item_weapon_fixer();
};

void() check_spotted_maps = 
{ 


	if (world.model == "maps/intro.bsp")
	{
		if (!(self.spotted_maps &LE_INTRO))
			self.spotted_maps += LE_INTRO;
	}

	if (world.model == "maps/hub1.bsp")
	{
		if (!(self.spotted_maps &LE_HUB1))
			self.spotted_maps += LE_HUB1;
	}

	if (world.model == "maps/e1m1.bsp")
	{
		if (!(self.spotted_maps &LE_E1M1))
			self.spotted_maps += LE_E1M1;
	}

	if (world.model == "maps/e1m2.bsp")
	{
		if (!(self.spotted_maps &LE_E1M2))
			self.spotted_maps += LE_E1M2;
	}

	if (world.model == "maps/e1m3.bsp")
	{
		if (!(self.spotted_maps &LE_E1M3))
			self.spotted_maps += LE_E1M3;
	}

	if (world.model == "maps/e1m4.bsp")
	{
		if (!(self.spotted_maps &LE_E1M4))
			self.spotted_maps += LE_E1M4;
	}

	if (world.model == "maps/e1m5.bsp")
	{
		if (!(self.spotted_maps &LE_E1M5))
			self.spotted_maps += LE_E1M5;
	}

	if (world.model == "maps/boss1.bsp")
	{
		if (!(self.spotted_maps &LE_BOSS1))
			self.spotted_maps += LE_BOSS1;
	}

	if (world.model == "maps/hub2.bsp")
	{
		if (!(self.spotted_maps &LE_HUB2))
			self.spotted_maps += LE_HUB2;
	}

	if (world.model == "maps/e2m1.bsp")
	{
		if (!(self.spotted_maps &LE_E2M1))
			self.spotted_maps += LE_E2M1;
	}

	if (world.model == "maps/e2m2.bsp")
	{
		if (!(self.spotted_maps &LE_E2M2))
			self.spotted_maps += LE_E2M2;
	}

	if (world.model == "maps/e2m3.bsp")
	{
		if (!(self.spotted_maps &LE_E2M3))
			self.spotted_maps += LE_E2M3;
	}

	if (world.model == "maps/e2m4.bsp")
	{
		if (!(self.spotted_maps &LE_E2M4))
			self.spotted_maps += LE_E2M4;
	}

	if (world.model == "maps/e2m5.bsp")
	{
		if (!(self.spotted_maps &LE_E2M5))
			self.spotted_maps += LE_E2M5;
	}

	if (world.model == "maps/boss2.bsp")
	{
		if (!(self.spotted_maps &LE_BOSS2))
			self.spotted_maps += LE_BOSS2;
	}

	if (world.model == "maps/hub3.bsp")
	{
		if (!(self.spotted_maps &LE_HUB3))
			self.spotted_maps += LE_HUB3;
	}

	if (world.model == "maps/e3m1.bsp")
	{
		if (!(self.spotted_maps &LE_E3M1))
			self.spotted_maps += LE_E3M1;
	}

	if (world.model == "maps/e3m2.bsp")
	{
		if (!(self.spotted_maps &LE_E3M2))
			self.spotted_maps += LE_E3M2;
	}

	if (world.model == "maps/e3m3.bsp")
	{
		if (!(self.spotted_maps &LE_E3M3))
			self.spotted_maps += LE_E3M3;
	}

	if (world.model == "maps/e3m4.bsp")
	{
		if (!(self.spotted_maps &LE_E3M4))
			self.spotted_maps += LE_E3M4;
	}

	if (world.model == "maps/e3m5.bsp")
	{
		if (!(self.spotted_maps &LE_E3M5))
			self.spotted_maps += LE_E3M5;
	}

	if (world.model == "maps/boss3.bsp")
	{
		if (!(self.spotted_maps &LE_BOSS3))
			self.spotted_maps += LE_BOSS3;
	}

};
.float interior;
.float chan8_vol;
.float chan9_vol;
.float interior_time;





void() object_fakecoffer;
void() PutClientInServer = {
	 local entity spawn_spot;	// This holds where we want to spawn
	self.location = parm27;
	spawn_spot = SelectSpawnPoint();
	self.nomelee = spawn_spot.nomelee;
	place_shepherd_filter(); // Reki (October 11 2023): Filter shepherd by .location


	if (deathmatch)
	{
		read_currentprofileslot();
		string playername;
		if(profilename == "")
			playername = "player";
		else
		playername = profilename;
		stuffcmd(self, strcat("name ", playername,"\n"));
		if (profilename)
			strunzone(profilename);
		self.health =  100;	
	}
	DecodeLevelParms();
	self.classname = "player";	// I'm a player!
	single_player = self;
	if (spawn_spot.health)
		self.health = spawn_spot.health;
	if (self.health < 1)
		self.health = 1;
	recount_monsters();	
	self.disableclientprediction = TRUE; // Reki (April 11 2023) enforce cl_movement 0 to prevent collision issues
	self.max_health = 100;	// My health (and my max) is 100
	self.takedamage = DAMAGE_AIM;	// I can be fired at
	self.solid = SOLID_SLIDEBOX;	// Things sort of 'slide' past me
	self.movetype = MOVETYPE_WALK;	// Yep, I want to walk.
	self.flags = FL_CLIENT;	// Yes, I'm a client.
	self.origin = spawn_spot.origin;	// + '0 0 10';	// Move to the spawnspot location
	self.angles = spawn_spot.angles;	// Face the angle the spawnspot indicates
	if(spawn_spot.angle2)
	{
		float r = random();
		if (r > 0.5)
			self.angles_y = spawn_spot.angle2;
	}
	self.fixangle = TRUE;	// Turn this way immediately
	setmodel(self, "models/misc/null.md3");	// Set my player to the player model
	//setmodel(self, "models/enemies/fallen/fallen1.md3");
	self.view_ofs_z = player_zviewofs;	// Center my view
	self.velocity = '0 0 0';	// Stop any old movement
	self.air_finished = time + 12;
	self.attack_finished = time;
	self.th_pain = Player_Pain;
	self.th_die = Player_Die;
	self.maxspeed = 1;
	self.realmaxspeed = 1;
	self.fwatershift = TRUE;	// catch runaway cshifts (changlevel/respawn while in func_water)
	self.oldgravity = 0;	// use unmodified sv_gravity
	Check_FrikFile();
	self.vweapon = spawn();
	self.vweapon.owner = self;
	self.vweapon.wrathflags += FL_GARBAGE;
	self.vweapon.viewmodelforclient = self;
	self.vweapon.classname = "player_weaponmodel";
	self.vweapon.think = Think_Vweapon;
	self.vweapon.angles_y = 0;
	self.vweapon.angles_x = 0;
	self.vweapon.angles_z = 0;
	self.vweapon.nextthink = time;
	self.effects = self.effects + EF_NOSHADOW;
	stuffcmd(self, "-attack\n");	// 
	self.vweapon.origin_z = self.dvweapon_z;
	self.holdcannon = 0.1;
	self.holdcannontime = 0.1;
	PlayerValuesEditor();
	check_retcher();
	if (!self.nomelee)
		raise_weapon();
	else
	{
		self.items -= IT_MELEE;
		self.weapon = 0;
	}
	stuffcmd (self, "alias +button4  \"\" \n");
	stuffcmd (self, "alias -button4  \"\" \n");
	stuffcmd (self, "alias +jump  \"\" \n");
	stuffcmd (self, "alias -jump  \"\" \n");
	////lbeams
	self.charge_shotgun = 1;
	stuffcmd(self, "cl_movement_maxspeed 416 \n");
	stuffcmd(self, "sv_maxspeed 416 \n");
	stuffcmd(self, "cl_forwardspeed 416\n");
	stuffcmd(self, "cl_backspeed 416\n");
	stuffcmd(self, "cl_sidespeed 416\n");
	stuffcmd(self, "scratch3 1\n");
	stuffcmd(self, "v_idlescale 0 \n");
	stuffcmd(self, "freelook 1\n");
	stuffcmd(self, "m_yaw 0.022\n");
	//stuffcmd(self, "r_glsl_saturation 1\n");
	self.r_saturation = 1;
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;
	if (invrtmsb == 1)
		stuffcmd(self, "m_pitch -0.022\n");
	else
		stuffcmd(self, "m_pitch 0.022\n");
	//Kill_Tether ();
	self.deadflag = 0;
	self.artifact_model_client = 0;
	stuffcmd(self, "sv_freezenonclients 0\n");
	stuffcmd(self, "bf 0 0 0 1 0.5\n");
	if (cvar_string("cvar_restoregame") == "")
		localcmd("set cvar_restoregame 0\n");
	self.location = 0;
	check_spotted_maps();
	self.oldrelics_start = self.oldrelics;
	self.autosavetime = time + 0.5;
	self.menuactive = 0;
	self.playerdeadtime = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
	self.slot_keys = 0;
	if (deathmatch == 1)
	self.health =  100;	
	self.viewzoom = 1;
	spawn_player_model(self); // player_model
	setsize(self, '-16 -16 -32', '16 16 32');
	check_custom_cvars();
	localcmd("set cvar_nodegraph 0\n");
    self.jason = cvar ("jason");
	float forcedencounter = cvar("cl_forcedencounter");	
	float noqcprecaches = cvar("cl_noqcprecache");	

	if(forcedencounter >= 1)
	{

	if(noqcprecaches >= 1)
	string noprecaches= "playing a noqcprecached game";

	self.oldrelics = forcedencounter - 1;
	centerprint(self, strcat("Using forced encounter ", ftos (forcedencounter)," \n",noprecaches," \n"));
	}
	else
	{
	if(noqcprecaches >= 1)
	centerprint(self, ("playing a noqcprecached game\n"));
	}	
	/*
	r = random();
	if(r <= 0.01)
	{
		makevectors (self.angles);
		entity fake_coffer = spawn();
		fake_coffer.angles = self.angles;
		fake_coffer.angles_y += 180;
		fake_coffer.origin = self.origin + v_forward * 128;
		fake_coffer.think = object_fakecoffer;
		fake_coffer.nextthink = time; 
	}
	*/
    self.clipgroup = 1;    
	Apply_Lut();
	stuffcmd(self, "v_flipped 0\n");

	self.interior_time = time + 1;
	stuffcmd(self, "seta snd_channel32volume 0\n");
	stuffcmd(self, "seta snd_channel9volume 0.1\n");
	stuffcmd(self, "seta snd_channel8volume 1\n");
	stuffcmd(self, "seta marker_color \"0 0 1\"\n");
	stuffcmd(self, "seta symbol_angles 1\n");
	//stuffcmd (self, "r_glsl_saturation 1\n");
	stuffcmd (self,"gl_polyblend 1\n");
	self.glpolyblend = 0;

	self.interior_time =  time;
	stuffcmd (self,"snd_identicalsoundrandomization_time 0.1\n");
	stuffcmd (self,"cl_decals_models 0\n");
	if (world.model == "maps/boss1.bsp")
	{
		stuffcmd (self,"snd_identicalsoundrandomization_time 0\n");
	}


	stuffcmd(self,"snd_staticvolume 0 \n");
	stuffcmd(self,"snd_channel0volume 0 \n");

	entity volumecontroller = spawn();
	volumecontroller.think = volumecontrollerthink;
	volumecontroller.nextthink = time + 0.1;

	FLASKRAGECOLOR_x = 1;
	FLASKRAGECOLOR_y = 0.7;
	FLASKRAGECOLOR_z = 0;
		stuffcmd (self, "r_glsl_postprocess_uservec3_enable 0\n");
		stuffcmd (self, "r_glsl_postprocess_uservec3 \"0 0 0 0\"\n");


	float dev = cvar ("developer");
	if (dev >= 1)
	{
		float writeparms = fopen (strcat ("reportmonsters/",mapname, "_killed_monsters",".txt"), FILE_WRITE); 
		fputs (writeparms,(""));
		fclose (writeparms);
	}

	// Reki (September 15 2023): initialize sounds here, so we don't cause a race condition please
	soundbox_initializeambients();
	sigils_initializeambients();
	item_donor_forcethink();



};

void(entity targ, entity attacker) ClientObituary = { bprint(" died\n");
};

///////////////////////////////find
