void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void() SUB_CalcMoveDone;
void() SUB_CalcAngleMoveDone;
void() SUB_Null;
void() SUB_UseTargets;
void() SUB_Remove;

float(float v) mathlib_anglemod = { return v - floor(v / 360) *360;
};

void makevectors2(vector ang);

void() SUB_Null = {};

void() SUB_Remove = { remove(self);
};

void(entity e, float d) nullpain = {};

void() SetMovedir = 
{ 
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';
	else
	{
		makevectors2(self.angles);
		self.movedir = v_forward;
	}
	self.angles = '0 0 0';
};

.float disarmed;
void() toggle_disarmed = 
{
	if(self.disarmed == 1)
		self.disarmed = 0;
	else
		self.disarmed = 1;
};
void() InitTrigger = 
{
	if (self.angles != '0 0 0')
		SetMovedir();
	self.solid = SOLID_TRIGGER;
	if (!self.model)
	{
		if (!self.absmin)
			self.absmin = '-8 -8 -8';
		if (!self.absmax)
			self.absmax = '8 8 8';
		setsize(self, self.absmin, self.absmax);
	}
	else
		setmodel(self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = string_null;
	if (self.disarmed == -1)
		return;
	if (self.disarmed)
		self.using = -1;
};

void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt = { local entity stemp;
	stemp = self;
	self = ent;
	SUB_CalcMove(tdest, tspeed, func);
	self = stemp;
};
void(entity e, vector org) fake_light =
{
e.effects = EF_FULLBRIGHT;
vector vlight  = getlight(org);

e.colormod_x = (vlight_x * 1.2) - 0.05;
e.colormod_y = (vlight_y * 1.2) - 0.05;
e.colormod_z = (vlight_z * 1.2) - 0.05;

};
vector (entity bmodel) b_org =
{
vector origin = 0.5 *(bmodel.absmax + bmodel.absmin);
return origin;
}
void(vector tdest, float tspeed, void() func) SUB_CalcMove = { local vector vdestdelta;
	local float len, traveltime;
	if (!tspeed)
		objerror("No speed is defined!");
	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;
	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	// calculate length of vector
	len = vlen(vdestdelta);
	// divide by speed to get time to reach dest
	traveltime = len / tspeed;
	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;
	// scale the destdelta vector by the time spent traveling to get velocity

	self.velocity = vdestdelta *(1 / traveltime);	// qcc won't take vec/float	
};

void() SUB_CalcMoveDone = { setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};

void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt = { local entity stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove(destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove = { local vector destdelta;
	local float len, traveltime;
	if (!tspeed)
		objerror("No speed is defined!");
	// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;
	// calculate length of vector
	len = vlen(destdelta);
	// divide by speed to get time to reach dest
	traveltime = len / tspeed;
	// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;
	// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta *(1 / traveltime);
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

void() SUB_CalcAngleMoveDone = { self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};

void() DelayThink = { activator = self.enemy;
	SUB_UseTargets();
	remove(self);
};

void() SUB_UseTargets3 = { local entity t, stemp, otemp, act;

	//
	// check for a delay
	//
	if (self.delay)
	{
		// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}
	//
	// print the message
	//
	if (activator.classname == "player" && self.message != "")
	{
		centerprint(activator, self.message);
		//if (!self.noise)
		//	sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

	//
	// kill the killtagets
	//
	if (self.killtarget)
	{
		t = world;
		do { 	t = find(t, targetname, self.killtarget);
			if (!t)
				return;
			remove(t);
		} while (1);
	}

	//
	// fire targets
	//
	if (self.target)
	{
		act = activator;
		t = world;
		do { 	t = find(t, targetname, self.target);
			if (!t)
			{
				return;
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while (1);
	}
};
void() remove_light = { if (self.count == 12)
		lightstyle(self.style, "l");
	if (self.count == 11)
		lightstyle(self.style, "k");
	if (self.count == 10)
		lightstyle(self.style, "j");
	if (self.count == 9)
		lightstyle(self.style, "i");
	if (self.count == 8)
		lightstyle(self.style, "h");
	if (self.count == 7)
		lightstyle(self.style, "g");
	if (self.count == 6)
		lightstyle(self.style, "f");
	if (self.count == 5)
		lightstyle(self.style, "e");
	if (self.count == 4)
		lightstyle(self.style, "d");
	if (self.count == 3)
		lightstyle(self.style, "c");
	if (self.count == 2)
		lightstyle(self.style, "b");
	if (self.count == 1)
	{
		lightstyle(self.style, "a");
		remove(self);
	}

	self.count -= 1;
	self.think = remove_light;
	self.nextthink = time + (self.time_fade / 12);
};

void(float mtype, vector org, entity ownr) Hud_message;
.float firstmessage;

void(float ldelay,string ltarget,string lkilltarget, entity lactivator)spawn_delay_entity =
{
    
		entity t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + ldelay;
		t.think = DelayThink;
		t.enemy = lactivator;
		t.killtarget = lkilltarget;
		t.target = ltarget;
};

void() SUB_UseTargets = { local entity t, act, stemp, otemp;

	//
	// check for a delay
	//
	if(self.target2)
        spawn_delay_entity(self.delay2,self.target2,self.killtarget2,activator);
	if(self.target3)
        spawn_delay_entity(self.delay3,self.target3,self.killtarget3,activator);
	if(self.target4)
        spawn_delay_entity(self.delay4,self.target4,self.killtarget4,activator);
	if(self.target5)
        spawn_delay_entity(self.delay5,self.target5,self.killtarget5,activator);
	if(self.target6)
        spawn_delay_entity(self.delay6,self.target6,self.killtarget6,activator);
	if(self.target7)
        spawn_delay_entity(self.delay7,self.target7,self.killtarget7,activator);
	if(self.target8)
        spawn_delay_entity(self.delay8,self.target8,self.killtarget8,activator);
	if (self.delay)
	{
		// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
        return;
	}	

	//
	// print the message
	//
	if (activator.classname == "player" && self.message != string_null)
	{
		#if 0
		// Reki (May 31 2023): Deprecated in favor of strlocalize()
		if (self.message == "journal")
		{
			//Hud_message(255, activator.origin, activator);
			Hud_SendNotification_Control(activator, ("$HELP_JOURNAL_OPEN"), "impulse 35");
		}
		else if (self.message == "inventory")
		{
			activator.firstmessage = 1;
			//Hud_message(256, activator.origin, activator);
			Hud_SendNotification_Control(activator, ("$HELP_RADIAL_OPEN"), "+button6");
		}
		else if (self.message == "pit")
		{
			//Hud_message(259, activator.origin, activator);
			Hud_SendNotification_Control(activator, ("$HELP_BLADE_JUMP"), "+button3");
		}
		else
		#endif
			centerprint(activator, self.message);

		//if (!self.noise)
		//	sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

	//
	// kill the killtagets
	//
	if (self.killtarget != string_null)
	{
		t = world;

		do { 	t = find(t, targetname, self.killtarget);

			if (!t)
				return;
			if (t.classname == "light")
			{
				lightstyle(t.style, "m");
				t.count = 12;
				t.think = remove_light;
				t.nextthink = time;
			}

			else if (t.classname == "boss_martyr")
			{
				t.think = t.use;
				t.nextthink = time;
			}		
			else
				remove(t);
		} while (1);
	}

	//
	// fire targets
	//
	if (self.target != string_null)
	{
		act = activator;
		t = world;

		do { 	t = find(t, targetname, self.target);
			if (!t)
			{
				return;
			}

			stemp = self;
			otemp = other;
			self = t;
			other = stemp;

			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while (1);
	}
};

/*in nightmare mode, all attack_finished times become 0
some monsters refire twice automatically*/

void(float normal) SUB_AttackFinished = { self.cnt = 0;	// refire count for nightmare
	if (skill != 3)
		self.attack_finished = time + normal;
};

float(entity targ) visible;
void(void() thinkst) SUB_CheckRefire = { if (skill != 3)
		return;
	if (self.cnt == 1)
		return;
	if (!visible(self.enemy))
		return;
	self.cnt = 1;
	self.think = thinkst;
};
void(vector start, vector end, float noents, entity attacker, vector boxsize) wtracebox = { local float s;
	s = attacker.solid;
	if (attacker.solid == SOLID_SLIDEBOX)
	{
		attacker.solid = SOLID_BBOX;
	}
	tracebox(start, boxsize *-1, boxsize, end, noents, attacker);
	
	if (attacker.solid == SOLID_BBOX)
	attacker.solid = s;
};

void(vector start, vector end, float noents, entity attacker, vector boxsize) weapontracebox = {
	float o_dphitcontents = self.dphitcontentsmask;
	self.dphitcontentsmask = DPCONTENTSMASK_WEAPON;

	tracebox(start, boxsize *-1, boxsize, end, noents, attacker);

	self.dphitcontentsmask = o_dphitcontents;
};

void(vector start, vector end, float noents, entity attacker) wtraceline = { local float s;
	s = attacker.solid;
	if (attacker.solid == SOLID_SLIDEBOX)
	{
		attacker.solid = SOLID_BBOX;
	}
	traceline(start, end, noents, attacker);
	
	if (attacker.solid == SOLID_BBOX)
	attacker.solid = s;
};

void(vector start, vector end, float noents, entity attacker) weapontraceline = {
	float o_dphitcontents = self.dphitcontentsmask;
	self.dphitcontentsmask = DPCONTENTSMASK_WEAPON;

	traceline(start, end, noents, attacker);

	self.dphitcontentsmask = o_dphitcontents;
};

vector railbbox;
void(vector start, vector end, float noents, entity attacker) railtraceline = { local vector maxbbox, minbbox;
	maxbbox = railbbox;
	minbbox_x = maxbbox_x *-1;
	minbbox_y = maxbbox_y *-1;
	minbbox_z = maxbbox_z *-1;
	local float s;
	s = attacker.solid;
	if (attacker.solid == SOLID_SLIDEBOX)
		attacker.solid = SOLID_BBOX;

	tracebox(start, minbbox, maxbbox, end, noents, attacker);
	//	traceline(start,end, noents, attacker);
	if(attacker != world)
		attacker.solid = s;
};

vector coachbbox;
void(vector start, vector end, float noents, entity attacker) wbtraceline = { local vector maxbbox, minbbox;
	maxbbox = coachbbox;
	minbbox_x = maxbbox_x *-1;
	minbbox_y = maxbbox_y *-1;
	minbbox_z = maxbbox_z *-1;
	local float s;
	s = attacker.solid;
	if ((attacker.solid == SOLID_SLIDEBOX) && (attacker != world))
		attacker.solid = SOLID_BBOX;

	tracebox(start, minbbox, maxbbox, end, noents, attacker);
	//	traceline(start,end, noents, attacker);
	if(attacker != world)
	attacker.solid = s;
};
vector shotbbox;

void(vector start, vector end, float noents, entity attacker) wbtraceline2 = { local vector maxbbox, minbbox;
	maxbbox = shotbbox;
	minbbox_x = maxbbox_x *-1;
	minbbox_y = maxbbox_y *-1;
	minbbox_z = maxbbox_z *-1;
	/*	local float s;
		s = attacker.solid;
		if (attacker.solid == SOLID_SLIDEBOX)
		attacker.solid = SOLID_BBOX;
	*/
	//	tracebox(start,minbbox, maxbbox,end, noents, attacker);
	traceline(start, end, noents, attacker);
	//	if (s == SOLID_SLIDEBOX)
	//		attacker.solid = s;
};


void() move_entities = 
{ 

	entity corpse;
	vector basetop = corpse.origin;
	basetop_z += corpse.absmin_z;
	basetop_z -= 2;

	traceline (corpse.origin,basetop,FALSE, self);

	if (trace_fraction == 1)
	{
		if(corpse.flags &FL_ONGROUND)
			corpse.flags -= FL_ONGROUND;
		corpse.velocity_x = random() *5 + 2;
		corpse.velocity_y = random() *5 + 2;
		corpse.velocity_z = random() *5 + 2;
	}
};


void() move_gibs = { if ((self.oldgroundentity != world) && (self.flags &FL_ONGROUND))
	{

		if ((pointcontents(self.origin - ' 0 0 1') != CONTENT_SOLID))
		{
			self.flags -= FL_ONGROUND;
			self.velocity_x = random() *5 + 2;
			self.velocity_y = random() *5 + 2;
			//if(self.count !=1)
			if (self.movetype == MOVETYPE_NOCLIP)
				self.velocity_z = -200;
			else
				self.velocity_z = random() *5 + 2;
		}
	}
};
vector(vector v1,vector v2)randomvector =
{
    vector vec;
    vec_x = random(v1_x,v2_x);
    vec_y = random(v1_y,v2_y);
    vec_z = random(v1_z,v2_z);
    return vec;

};
.float alphatime;
void(vector org, vector vel) SpawnGib3;
void() alphafade3 = 
{ 
	self.alpha = self.alpha - 0.2;
	if (self.alpha <= 0)
	{
		self.alpha = -1;
		self.think = SUB_Remove;
	}
	else
		self.think = alphafade3;
	self.nextthink = time + 0.01;
};

void() alphafade2 = { if (self.wrathflags &FL_TOSS)
		move_gibs();
	self.alpha = self.alpha - ((1 / self.alphatime) / 20);
	if (self.alpha <= 0)
	{
		self.alpha = -1;
		self.think = SUB_Remove;
		if(self.burnable == 2)
		{
			vector org = self.origin + randomvector (self.mins,self.maxs);
			float gibaccount = floor(self.maxs_x - self.mins_x) / 4; 
			while(gibaccount > 0)
			{	
				SpawnGib3(org + randomvector(self.mins,self.maxs),randomvector(self.mins,self.maxs) * gibaccount * 8);
				gibaccount --;
			}			
		}
	}
	else
		self.think = alphafade2;

	self.nextthink = time + 0.05;
};

void() alphafade = { if (self.wrathflags &FL_TOSS)
		move_gibs();
	if(!self.alphatime)
	self.alphatime = 1;
	if (!self.alpha)
		self.alpha = 1;
	self.nextthink = time + 0.01;
	self.think = alphafade2;
};

void(entity l, vector col, float rad, float sty) lighted = { l.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | (rad < 128 ? PFLAGS_LODFADE : 0);
	l.color = col;
	l.light_lev = rad;
	l.style = sty;
};

void(entity e, vector sz) setsizemonster = { local vector s2;
	s2_x = sz_x *-1;
	s2_y = sz_y *-1;
	s2_z = -32;
	setsize(e, s2, sz);
};

void(entity e, vector sz) setsizeitem = { local vector s2;
	s2_x = sz_x *-1;
	s2_y = sz_y *-1;
	s2_z = sz_z *-1;
	setsize(e, s2, sz);
};

.vector size_bbox;
.vector nsize_bbox;
void(entity e, vector sz) setsizeitem2 = { local vector s2;
	s2_x = sz_x *-1;
	s2_y = sz_y *-1;
	s2_z = sz_z *-1;
//	setsize(e, s2, sz);
	e.nsize_bbox = s2;
	e.size_bbox = sz;
};
void(entity e, vector s2, vector sz) setsize2 = {
	e.nsize_bbox = s2;
	e.size_bbox = sz;
};
void() toggle_use = { if (self.using == 1)
		self.using = 0;
	else
		self.using = 1;
};
vector(entity ent) rorigin = { if (ent.crouch == 1)
		return (ent.absmin + ent.absmax) *0.5 + '0 0 24';
	else
		return (ent.absmin + ent.absmax) *0.5;
};
void(entity ent) copy_old_data = { ent.effects = ent.effects;
	ent.solid = ent.solid;
	ent.olduse = ent.use;
	ent.oldtouch = ent.touch;
	ent.oldwait = ent.wait;
	ent.oldcount = ent.count;
	ent.olddelay = ent.delay;
	ent.targetname = ent.targetname;
	ent.oldtarget = ent.target;
	ent.oldenemy = ent.enemy;
};
.float local_classmonster;
void() multi_touch;
void() key_touch;
void() coffer_key_touch;
void() start_key;
void(float type) StartItem; .float episode;
void() paste_old_data = { if (self.classname == "enemy_spawner")
	{
		local entity pl;
		pl = find(world, classname, "player");
		if (!pl.oldrelics)
			return;
		self.use = self.olduse;
		if (pl.oldrelics == 1)
			self.local_classmonster = self.classmonster1;
		if (pl.oldrelics == 2)
			self.local_classmonster = self.classmonster2;
		if (pl.oldrelics == 3)
			self.local_classmonster = self.classmonster3;
		if (pl.oldrelics == 4)
			self.local_classmonster = self.classmonster4;
		if (pl.oldrelics == 5)
			self.local_classmonster = self.classmonster5;
	}

	self.use = self.olduse;
	self.effects = self.oldeffects;
	self.solid = self.solid;

	self.enemy = self.oldenemy;
	self.wait = self.oldwait;
	self.count = self.oldcount;
	self.delay = self.olddelay;
	self.targetname = self.targetname;
	self.target = self.oldtarget;
	self.think = self.oldthink;
	self.enemy = 0;
	if (self.classname == "trigger_once")
		self.touch = multi_touch;
	if (self.classname == "coffer_key")
	{
		self.modelflags = MF_ROTATE;
		self.items = IT_COFFERKEY1;
		if(self.episode == 1)
			setmodel(self, "models/keys/key_1_coffer.md3");
		if(self.episode == 2)
			setmodel(self, "models/keys/key_2_coffer.md3");
		if(self.episode == 3)
			setmodel(self, "models/keys/key_3_coffer.md3");
		setsize(self, coffer_key_nsize, coffer_key_size);
		self.scale = 1;
		self.classname = "coffer_key";
		self.touch = coffer_key_touch;
		self.msg = 25;
		self.msg_icon = "coffer_key";
		self.msg_text = ("$NOTIFY_KEY_COFFER");
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_cofferkey)
		self.think = start_key;
		self.nextthink = time + 0.1;
	}

	if (self.classname == "key_red")
	{
		self.items = IT_KEY1;
		self.modelflags = MF_ROTATE;
		if(self.episode == 1)
			setmodel(self, "models/keys/key_1_red.md3");
		if(self.episode == 2)
			setmodel(self, "models/keys/key_2_red.md3");
		if(self.episode == 3)
			setmodel(self, "models/keys/key_3_red.md3");

		setsize(self, coffer_key_nsize, coffer_key_size);
		self.scale = 1;
		self.touch = key_touch;
		self.msg = 31;
		self.msg_icon = "key_red";
		self.msg_text = ("$NOTIFY_KEY_RED");
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_redkey)
		self.slot_keys = 1;
		self.think = start_key;
		self.nextthink = time + 0.1;
	}

	if (self.classname == "key_yellow")
	{
		self.items = IT_KEY3;
		self.modelflags = MF_ROTATE;
		if(self.episode == 1)
			setmodel(self, "models/keys/key_1_yellow.md3");
		if(self.episode == 2)
			setmodel(self, "models/keys/key_2_yellow.md3");
		if(self.episode == 3)
			setmodel(self, "models/keys/key_3_yellow.md3");
		setsize(self, coffer_key_nsize, coffer_key_size);
		self.scale = 1;
		self.touch = key_touch;
		self.msg = 32;
		self.msg_icon = "key_yellow";
		self.msg_text = ("$NOTIFY_KEY_YELLOW");
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_yellowkey)
		self.slot_keys = 3;
		self.think = start_key;
		self.nextthink = time + 0.1;
	}

	if (self.classname == "key_blue")
	{
		self.items = IT_KEY2;
		self.modelflags = MF_ROTATE;
		if(self.episode == 1)
			setmodel(self, "models/keys/key_1_blue.md3");
		if(self.episode == 2)
			setmodel(self, "models/keys/key_2_blue.md3");
		if(self.episode == 3)
			setmodel(self, "models/keys/key_3_blue.md3");
		setsize(self, coffer_key_nsize, coffer_key_size);
		self.scale = 1;
		self.touch = key_touch;
		self.msg = 28;
		self.msg_icon = "key_blue";
		self.msg_text = ("$NOTIFY_KEY_BLUE");
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_bluekey)
		self.slot_keys = 2;
		self.think = start_key;
		self.nextthink = time + 0.1;
	}
};

void() turn_solid =
{
self.solid = self.oldsolid;
};

void()SUB_RemoveScalethink =
{
	self.scale -= 0.05;
	if(self.scale < 0.1)    
		self.think = SUB_Remove;
	else
		self.think = SUB_RemoveScalethink;
	if(self.light_lev > 0)
	{
		self.light_lev = self.light_lev * 0.92;
	}

	self.nextthink = time + 0.0125;   
};

void() SUB_RemoveScale =
{
	self.solid = SOLID_NOT;
	if(!self.scale)    
		self.scale = 1;
	self.think = SUB_RemoveScalethink;
	self.nextthink = time;
};


void(float type, float delay) save_screenshot =
{
	read_currentprofileslot();

	// Reki (October 10 2023): Refactored this to not use a hardcoded list
	string timestamp_image = sprintf("gfx/menu/load_menu_%s.tga", mapname);
	if !(fexists_pak(timestamp_image))
		timestamp_image = "";

	get_timestamp_map(profilename);

	string line1 = timestamp_map1;
	string line2 = timestamp_map2;
	string line3 = timestamp_map3;


	if (type == 1)
	line1= timestamp_image;	
	if (type == 2)
	line2 = timestamp_image;	
	if (type == 3)
	line3 = timestamp_image;	

 	local float writeparms;
	writeparms = fopen_wrath(strcat("profiles/", profilename,"/timestamp.txt"),  FILE_WRITE);

	fputs(writeparms, line1);
 	fputs(writeparms, "\n");
	fputs(writeparms, line2);
 	fputs(writeparms, "\n");
	fputs(writeparms, line3);
 	fputs(writeparms, "\n");
 	fclose_wrath(writeparms);
	if (profilename)
		strunzone(profilename);

};


float() GetSkyMaterial = 
{ 
	return (trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) || (trace_dphitq3surfaceflags & Q3SURFACEFLAG_NOIMPACT);
};


void() touchtriggers_think =
{
	self.think = touchtriggers_think;
	//force_retouch = 2;
	//touchtriggers(self.owner);

	self.nextthink = time + random(2,5);
};

///////////////////////////////////end of qc filet///////////////////////////////////end of qc filet
