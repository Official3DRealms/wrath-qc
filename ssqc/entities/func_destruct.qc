 .float gibcount;
.vector oldorigin2;
.float tre;
.string typegib;
.float min_damage;

void() air_touch = {};

void() becomesolid = 
{ 
	self.tre += 1;
	if (self.solid != SOLID_CORPSE)
		self.solid = SOLID_CORPSE;
	self.movetype = MOVETYPE_BOUNCE;
	self.avelocity = '0 0 0';
	if (!(self.wrathflags &FL_TOSS))
		self.wrathflags = self.wrathflags + FL_TOSS;
	if ((self.flags &FL_ONGROUND) && (!self.cnt))
	{
		if (self.angles_x < 45)
			self.angles_x = 0;
		if ((self.angles_x >= 65) && (self.angles_x < 115))
		{
			self.angles_x = 90;
			self.origin_z += 7;
		}

		if ((self.angles_x >= 115) && (self.angles_x < 245))
			self.angles_x = 180;
		if ((self.angles_x >= 245) && (self.angles_x < 295))
		{
			self.angles_x = 270;
			self.origin_z += 7;
		}

		if (self.angles_x >= 315)
			self.angles_x = 0;

		if (self.angles_z < 45)
			self.angles_z = 0;
		if ((self.angles_z >= 65) && (self.angles_z < 115))
		{
			self.angles_z = 90;
			self.origin_z += 7;
		}

		if ((self.angles_z >= 115) && (self.angles_z < 245))
			self.angles_z = 180;
		if ((self.angles_z >= 245) && (self.angles_z < 295))
		{
			self.angles_z = 270;
			self.origin_z += 7;
		}

		if (self.angles_z >= 315)
			self.angles_z = 0;
		self.cnt = 1;

	}

	//	if((!(self.flags &FL_ONGROUND)) && (self.velocity == '0 0 0')) 
	move_gibs();
	local float ctre;
	ctre = 100 *self.scale + 20;
	if ((self.tre > ctre))
		self.think = alphafade;
	else
		self.think = becomesolid;

	self.oldgroundentity = self.groundentity;
	self.nextthink = time + 0.05;
};

.float fakelight_count;

.vector fvelocity;
.string particlename;
.string namegib;
.string gibmodel1;
.string gibmodel2;
.string gibmodel3;
.string gibmodel4;
.string gibmodel5;
.string gibsound;
.vector enemyangle;
.float rfactor;
.float mass;

void()info_nogib_touch =
{
	if(!(other.wrathflags & FL_GIB))
		return;
	else
	{
		vector dir = (self.origin - '0 0 8')  - other.origin;
		dir = normalize(dir);
		other.velocity += dir * (128,256);
		other.movetype = MOVETYPE_NOCLIP;
		other.think = becomesolid;
		other.nextthink = time + random(0.2,0.5);
	}
};

void() trigger_nogib =
{
	setmodel(self,self.model);
	self.solid = SOLID_TRIGGER;
	self.effects = EF_NODRAW;
	self.touch = info_nogib_touch;
};

void() prebecomesolid = 
{ 

	if (!(self.flags &FL_ONGROUND))
	{
		self.think = prebecomesolid;

		if(!self.lifetime)
			self.lifetime = time + random(7,15);
		if(!self.oldvelocity)
			self.oldvelocity = randomvector('-128 -128 -16','128 128 256');

		if(self.origin == self.oldorigin2)
		{
			self.velocity = self.oldvelocity * 1.5;
			self.velocity_x = self.oldvelocity_x * random(1.5,3);
			self.velocity_y = self.oldvelocity_y * random(1.5,3);
			self.movetype = MOVETYPE_NOCLIP;
			self.think = becomesolid;
			self.nextthink = time + random(0.2,1);			
		}
	}
	else
	{
		if (!self.cnt)
		{
			if (self.mass >= 3)
			{
				if (self.angles_x < 45)
					self.angles_x = 0;
				if ((self.angles_x >= 65) && (self.angles_x < 115))
				{
					self.angles_x = 90;
					self.origin_z += 7;
				}

				if ((self.angles_x >= 115) && (self.angles_x < 245))
					self.angles_x = 180;
				if ((self.angles_x >= 245) && (self.angles_x < 295))
				{
					self.angles_x = 270;
					self.origin_z += 7;
				}

				if (self.angles_x >= 315)
					self.angles_x = 0;

				if (self.angles_z < 45)
					self.angles_z = 0;
				if ((self.angles_z >= 65) && (self.angles_z < 115))
				{
					self.angles_z = 90;
					self.origin_z += 7;
				}

				if ((self.angles_z >= 115) && (self.angles_z < 245))
					self.angles_z = 180;
				if ((self.angles_z >= 245) && (self.angles_z < 295))
				{
					self.angles_z = 270;
					self.origin_z += 7;
				}

				if (self.angles_z >= 315)
					self.angles_z = 0;
			}
			else
			{
				if (self.angles_x < 90)
					self.angles_x = 0;
				if ((self.angles_x >= 90) && (self.angles_x < 270))
					self.angles_x = 180;
				if (self.angles_x >= 270)
					self.angles_x = 0;

				if (self.angles_z < 90)
					self.angles_z = 0;
				if ((self.angles_z >= 90) && (self.angles_z < 270))
					self.angles_z = 180;
				if (self.angles_z >= 270)
					self.angles_z = 0;
			}

			self.cnt = 1;
		}

		self.movetype = MOVETYPE_BOUNCE;
		self.fakelight_count += 1;
		if (self.fakelight_count > 5)
			self.think = becomesolid;
		else
			self.think = prebecomesolid;
	}

	self.oldorigin2 = self.origin;
	if(self.lifetime < time)
		self.think = alphafade;
	self.nextthink = time + 0.05;
};

.float spread_vel;
.entity autotrigger;
void(string gibname, float dm, entity ouner, float bf, float bs) LanzarGib = 
{ 
	local entity new;

	new = spawn();
	new.owner = ouner;

	local vector org;
	org_x = (self.absmin_x) + (random() *self.size_x *0.75);
	org_y = (self.absmin_y) + (random() *self.size_y *0.75);
	org_z = (self.absmin_z) + (random() *self.size_z *0.75);


	if(self.classname == "func_destruct_rotate")
	{
		self.movetype = MOVETYPE_FLY;
		self.solid = SOLID_TRIGGER;
		org_x = random(self.autotrigger.absmin_x,self.autotrigger.absmax_x);
		org_y = random(self.autotrigger.absmin_y,self.autotrigger.absmax_y);
		org_z = random(self.autotrigger.absmin_z,self.autotrigger.absmax_z);

	}

	if ((pointcontents(org) == CONTENT_SOLID))
	{
		remove(new);
		return;
	}
	new.nofloating = ouner.nofloating;
	new.type = ouner.type;
	new.mass = ouner.mass;
	new.origin = org;

	if (!(ouner.spawnflags &2))
	{
		if (ouner.particlename)
			pointparticles(particleeffectnum(ouner.particlename), org, '0 0 0', 1);
	}

	setmodel(new, gibname);
	vector realsize;
	realsize_x = new.absmax_x - new.absmin_x; 
	realsize_y = new.absmax_y - new.absmin_y;
	realsize_z = new.absmax_z - new.absmin_z;

	new.model_ammount = floor((realsize_x * realsize_y * realsize_z)/100);
	setsize(new, '0 0 0', '0 0 0');

	new.gravity = random(0.75,1);
	if(new.model_ammount > 300)
	new.gravity += random(0.1,0.5);
	new.velocity = self.oldvelocity;
	new.oldvelocity = self.oldvelocity;

	//new.velocity = /*VelocityForDamage (dm *0.5) +  */ouner.fvelocity;
	new.movetype = MOVETYPE_BOUNCE;
	new.bouncefactor = bf;
	new.bouncestop = bs;
	new.angles_y = random() *360;
	new.alpha = 1;
	local float massfloat;

	massfloat = 1 / new.mass;

	new.avelocity_x = random() *massfloat *180;
	if (new.mass > 3)
		new.avelocity_y = random() *massfloat *720;
	else
		new.avelocity_y = random() *massfloat *180;
	new.avelocity_z = random() *massfloat *180;

	new.wrathflags += FL_GARBAGE;
	if(!(new.wrathflags & FL_GIB))
	new.wrathflags += FL_GIB;
	new.scale = ouner.base_scale *(0.25 + random() *1);
	if (ouner.base_scale <= 0)
		new.scale = 1;
	new.solid = SOLID_TRIGGER;
	new.lifetime = time + random(7,15);
	new.think = prebecomesolid;
	new.nextthink = time + 0.25;
	new.touch = air_touch;
};


.float autotrigger_flag;
void() destruct_gibs = 
{ 
	local float ngibs;
	local string gibmodel, numbergib;

	local entity pl;
	pl = self.enemy;

	if (pl.classname == "executioner")
		self.mass += 0.5;

	while (self.gibcount > 0)
	{
		ngibs = floor((random() *self.rfactor) + 1);
		if (ngibs > self.rfactor)
			ngibs = 1;

		numbergib = ftos(ngibs);
		gibmodel = strcat("models/destruct/gibs/gib_", self.namegib, numbergib, ".bsp");
		//gibmodel = "maps/hacha.bsp";

		if (!self.type)
		{
			if (ngibs == 1)
				gibmodel = self.gibmodel1;
			if (ngibs == 2)
				gibmodel = self.gibmodel2;
			if (ngibs == 3)
				gibmodel = self.gibmodel3;
			if (ngibs == 4)
				gibmodel = self.gibmodel4;
			if (ngibs == 5)
				gibmodel = self.gibmodel5;

		}

		if (pl.classname == "player")
			makevectors(pl.v_angle);
		else
			makevectors(pl.angles);

		local float massfloat;
		massfloat = 1.25 / (self.mass + 1);
			self.enemyangle = v_forward;
			float speedchanger = 	(self.spread_vel * -0.5) - 1;

		if ((pl != world) && (self.spread_vel <= 0))
		{

			self.oldvelocity = (v_forward *(192 *massfloat *(1 + (random() *0.5)))) * -speedchanger;
			//self.oldvelocity += (VelocityForDamage2(self.spread_vel * -1)) * 0.25;
			self.oldvelocity_z = (50 *massfloat) + (random() *50);
		}
		else
		{
			self.oldvelocity = VelocityForDamage2(self.spread_vel);
			if((self.spread_vel == 64.5) && (self.mass == 4))
			{	
				self.oldvelocity_z = (50 *massfloat) + (random() *50);
				self.oldvelocity += (v_forward *(192 *massfloat *(1 + (random() *0.5)))) * (self.health / -150);
			}
		}
		LanzarGib(gibmodel, self.health, self, self.bouncefactor, self.bouncestop);
		self.gibcount -= 1;
	}

	if((self.autotrigger_flag == 1))
	{	
		if(self.autotrigger.solid == SOLID_TRIGGER)	
		{	
			remove(self.autotrigger);
			self.autotrigger_flag = 0;
		}
	}
	self.think = SUB_Remove;
	self.nextthink = time;
};

void() extrafield_touch =
{


	if(!(other.classentity == "wrathbreakable") || (other.health <=  0)|| (other.classentity == "corpse"))
		return;

	entity corpse = other;
	vector basetop = corpse.origin;
	basetop_z += corpse.absmin_z;
	basetop_z -= 2;

	traceline (corpse.origin,basetop,FALSE, self);

	if ((trace_fraction == 1) && (corpse.movetype = MOVETYPE_TOSS) && (corpse.pushed_time < time))
	{
		if(corpse.flags &FL_ONGROUND)
			corpse.flags -= FL_ONGROUND;
		corpse.velocity_x = random() *5 + 2;
		corpse.velocity_y = random() *5 + 2;
		corpse.velocity_z = random() *5 + 2;
		corpse.pushed_time = time + 3.3;
	}
};


void() destruct_die = 
{ 
	float nsnd, rnsnd;


	if(self.wrath_active == 2)
		remove(self.pipes);
	
	if (!self.type)
	{
		if (!self.bouncefactor)
			self.bouncefactor = 0.25;
		self.namegib = "custom";
		if((!self.spread_vel) && (!self.mass))
			self.spread_vel = 64.5;
		if (!self.mass)
			self.mass = 4;


	}
	else if (self.type == 1)
	{
		if (!self.bouncefactor)
		self.bouncefactor = 0.75;
		self.namegib = "stone";
		self.typegib = "stone0";
		self.rfactor = 4;
		self.mass = 0.75;
	}
	else if (self.type == 2)
	{
		if (!self.bouncefactor)
		self.bouncefactor = 0.25;
		self.namegib = "wood";
		self.typegib = "smash_woodbreak0";
		self.rfactor = 4;
		self.mass = 0.85;
	}
	else if (self.type == 3)
	{
		if (!self.bouncefactor)
		self.bouncefactor = 0.3;
		self.namegib = "tomb";
		self.typegib = "tomb";
		self.rfactor = 2;
		self.mass = 0.75;
	}
	else if (self.type == 4)
	{
		if (!self.bouncefactor)
		self.bouncefactor = 0.1;
		self.namegib = "glass";
		self.typegib = "glass0";
		self.rfactor = 2;
		self.mass = 0.1;
	}
	else if (self.type == 5)
	{
		if (!self.bouncefactor)
		self.bouncefactor = 0.5;
		self.namegib = "ice";
		self.typegib = "ice0";
		self.rfactor = 2;
		self.mass = 0.75;
	}

	local float attn;
	if (self.rad_sound == 0)
		attn = 0;
	else if (self.rad_sound == -1)
		attn = -1;
	else
		attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!

	if (self.noise)
	{
		if (self.noise)
			nsnd = 1;
		if (self.noise2)
			nsnd = 2;
		if (self.noise3)
			nsnd = 3;
		rnsnd = floor(random() *nsnd) + 1;

		if (rnsnd == 2)
			self.noise = self.noise2;
		if (rnsnd == 3)
			self.noise = self.noise3;

		local vector orgsound;
		orgsound = 0.5 *(self.absmax + self.absmin);
		if(self.classname == "func_destruct_rotate")
			orgsound = 0.5 *(self.autotrigger.absmax + self.autotrigger.absmin);
		if(self.classname == "func_rotate")
			orgsound = self.origin;
		pointsound(orgsound, self.noise, self.volume, attn);
	}

	if (self.spawnflags &2)
	{
		local vector org;
		org = 0.5 *(self.absmax + self.absmin);
		if (self.particlename)
			pointparticles(particleeffectnum(self.particlename), org, '0 0 0', 1);
	}

	entity extrafield = spawn();
	setmodel(extrafield,self.model);
	setsize (extrafield,self.absmin - '8 8 8',self.absmax +'8 8 8');
	extrafield.solid = SOLID_TRIGGER;
	extrafield.effects = EF_NODRAW;
	extrafield.touch = extrafield_touch;
	extrafield.think = SUB_Remove;
	extrafield.nextthink = time + 3;

	SUB_UseTargets();
	self.solid = SOLID_NOT;
	self.takedamage = 0;
	self.use = SUB_Null;
	self.alpha = -1;
	self.effects = EF_NODRAW;
	self.think = destruct_gibs;
	self.nextthink = time;	// + 55;
};


.float touch_smash;
.float touch_smash_delay;

void() func_destruct_touch =
{
	if(other.classname != "player")
		return;
	self.touch_smash = 0;
	self.think = destruct_die;
	self.nextthink = time + self.touch_smash_delay;
};

void() auto_triggerhurt_touch_think =
{
		self.owner.autotrigger_flag = 0;
		T_Damage(self.owner, other, other, 120);	// its damage
		remove(self);
}


void() auto_triggerhurt_touch2 =
{

};
void() auto_triggerhurt_touch =
{
	if(self.owner.spawnflags & 4)
	{
		if ((other.classname == "boss_guardian3") || (other.classname == "jbox_boss3"))
		{

			if((other.classname == "boss_guardian3")  && (other.frame >= 40))
				float destruct_happens = 1;

			if((other.classname == "jbox_boss3")  && (other.owner.frame >= 40))
				destruct_happens = 1;

			if(destruct_happens == 1)
			{
				T_Damage(self.owner, other, other, 999999);	// its damage
				remove(self);
			}		
		}
		else
			return;
	}

	if(self.touch_smash & 2)
	{
		if (other.flags & FL_MONSTER)
		{
			self.touch_smash = 0;
			self.think = auto_triggerhurt_touch_think ;
			self.nextthink = time + self.touch_smash_delay;
		}
	}
	else
	{
		if ((other.classname == "monster_stricken") || (other.classname == "executioner"))
		{
			T_Damage(self.owner, other, other, 120);	// its damage
			remove(self);
		}
	}
};

.float fakelight;

void(entity a,float b)destruct_pain =
{
	self.health = self.oldhealth;
};
void() func_destruct = 
{ 
	setmodel(self, self.model);
//return;
	precache_model("models/gibs/gib_stone1.bsp");
	precache_model("models/gibs/gib_stone2.bsp");
	precache_model("models/gibs/gib_stone3.bsp");
	precache_model("models/gibs/gib_stone4.bsp");
	precache_model("models/gibs/gib_tomb1.bsp");
	precache_model("models/gibs/gib_tomb2.bsp");
	precache_model("models/gibs/gib_tomb3.bsp");
	precache_model("models/gibs/gib_tomb4.bsp");
	precache_model("models/gibs/gib_wood1.bsp");
	precache_model("models/gibs/gib_wood2.bsp");
	precache_model("models/gibs/gib_wood3.bsp");
	precache_model("models/gibs/gib_wood4.bsp");

	if(self.crystallized == 1)
	self.wrathflags += FL_CRYSTAL;
	if(!(self.nofloating))
		self.nofloating = 1;

	if (self.noise)
		precache_sound(self.noise);
	if (self.noise2)
		precache_sound(self.noise2);
	if (self.noise3)
		precache_sound(self.noise3);

	if (self.type == 1)
	{
		precache_sound("impact/destruct/stone_break1.ogg");
		precache_sound("impact/destruct/stone_break2.ogg");
		self.noise = ("impact/destruct/stone_break1.ogg");
		self.noise2 = ("impact/destruct/stone_break2.ogg");

		// Reki (October 5 2023): There is some jank legacy code in there messing stuff up if we have
		self.type = 0; // type set to anything other than 0, so this is a hack to save time (ick).
		
		// Reki (October 5 2023): Fixing .type not setting models by default
		if !(self.gibmodel1)
			self.gibmodel1 = "models/destruct/e1m2/stone1_a.md3";
		if !(self.gibmodel2)
			self.gibmodel2 = "models/destruct/e1m2/stone1_b.md3";
		if !(self.gibmodel3)
			self.gibmodel3 = "models/destruct/e1m2/stone1_c.md3";
		if !(self.rad_sound)
			self.rad_sound = 512;
		if (!self.base_scale)
		
			self.base_scale = 2;

	}
	else if (self.type == 2)
	{
		precache_sound("impact/destruct/wood1_break1.ogg");
		precache_sound("impact/destruct/wood1_break2.ogg");
		precache_sound("impact/destruct/wood1_break3.ogg");
		self.noise = ("impact/destruct/wood1_break1.ogg");
		self.noise2 = ("impact/destruct/wood1_break2.ogg");
		self.noise3 = ("impact/destruct/wood1_break3.ogg");

		// Reki (October 5 2023)
		self.type = 0;
		if !(self.gibmodel1)
			self.gibmodel1 = "models/destruct/e1m2/wood1_a.md3";
		if !(self.gibmodel2)
			self.gibmodel2 = "models/destruct/e1m2/wood1_b.md3";
		if !(self.gibmodel3)
			self.gibmodel3 = "models/destruct/e1m2/wood1_c.md3";
	}
	else if (self.type == 4)
	{
		precache_sound("impact/destruct/glass_break1.ogg");
		precache_sound("impact/destruct/glass_break2.ogg");
		precache_sound("impact/destruct/glass_break3.ogg");
		self.noise = ("impact/destruct/glass_break1.ogg");
		self.noise2 = ("impact/destruct/glass_break2.ogg");
		self.noise3 = ("impact/destruct/glass_break3.ogg");
		
		// Reki (October 5 2023)
		self.type = 0;
		if !(self.gibmodel1)
			self.gibmodel1 = "models/destruct/windows/window_shard1.md3";
		if !(self.gibmodel2)
			self.gibmodel2 = "models/destruct/windows/window_shard2.md3";
		if !(self.gibmodel3)
			self.gibmodel3 = "models/destruct/windows/window_shard3.md3";
	}


	if (self.fakelight == 1)
	{
			vector borg = b_org(self);
			fake_light (self,borg);
	}
	if (self.gibmodel1)
	{
		precache_model(self.gibmodel1);
		self.rfactor = 1;
	}

	if (self.gibmodel2)
	{
		precache_model(self.gibmodel2);
		self.rfactor = 2;
	}

	if (self.gibmodel3)
	{
		precache_model(self.gibmodel3);
		self.rfactor = 3;
	}

	if (self.gibmodel4)
	{
		precache_model(self.gibmodel4);
		self.rfactor = 4;
	}

	if (self.gibmodel5)
	{
		precache_model(self.gibmodel5);
		self.rfactor = 5;
	}

	//self.origin = 0.5 *(self.absmax + self.absmin); 
	self.angles = '0 0 0';
	self.solid = SOLID_BSP;
	//self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	//setorigin (self, self.origin);
	if (!self.base_scale)
		self.base_scale = -1;
	if (!self.volume)
		self.volume = 1;
	if (self.volume > 1)
		self.volume = 1;
	if (!self.gibcount)
		self.gibcount = 5;
	if (self.gibcount <= 0)
		self.gibcount = 0;
	setmodel(self, self.model);
	if (!self.health)
		self.health = 5;
	self.oldhealth = self.health;

		//self.health = 50;

	if (!self.rad_sound)
		self.rad_sound = 512;
	if ((!self.targetname))
		self.takedamage = DAMAGE_YES;
	if ((self.spawnflags &1) && (self.targetname))
		self.takedamage = DAMAGE_YES;

	if(self.wrath_active == 1)
	{
		self.glowmod = '-1 -1 -1';
		self.takedamage = 0;
	}

	else
	{		
	if(self.touch_smash & 1)
		self.touch = func_destruct_touch;
	}
	self.use = destruct_die;
	self.th_die = destruct_die;

	if(self.crystallized >= 1)
	{
		self.use = death_crystal_gibs;
		self.th_die = death_crystal_gibs;
	}


    if(self.min_damage > 0)
	    self.th_pain = destruct_pain;

	self.fake_origin = (self.absmin + self.absmax) *0.5;
	 ///self.effects = 131072;


	if (self.spawnflags &4)	
	{
		local entity auto_triggerhurt;
		auto_triggerhurt = spawn();
		self.autotrigger = auto_triggerhurt;
		self.autotrigger_flag = 1;
		auto_triggerhurt.solid = SOLID_TRIGGER;
		auto_triggerhurt.owner = self;
		auto_triggerhurt.touch_smash = self.touch_smash;
		auto_triggerhurt.touch_smash_delay = self.touch_smash_delay;
		setsize(auto_triggerhurt, (self.absmin - ('128 128 2')), (self.absmax + ('128 128 2')));
		auto_triggerhurt.touch = auto_triggerhurt_touch;
		self.health = 999998;
		self.solid = SOLID_BBOX;
	}
	else
	{

		if ((((self.targetname) && (self.spawnflags &1)) || (self.touch_smash&2))  && (self.wrath_active != 1)) 
		{
			auto_triggerhurt = spawn();
			self.autotrigger = auto_triggerhurt;
			self.autotrigger_flag = 1;
			auto_triggerhurt.solid = SOLID_TRIGGER;
			auto_triggerhurt.owner = self;
			auto_triggerhurt.touch_smash = self.touch_smash;
			auto_triggerhurt.touch_smash_delay = self.touch_smash_delay;
			if(self.touch_smash & 2)
				setsize(auto_triggerhurt, (self.absmin - ('4 4 2')), (self.absmax + ('4 4 2')));
			else
				setsize(auto_triggerhurt, (self.absmin - ('20 20 2')), (self.absmax + ('20 20 2')));
			auto_triggerhurt.touch = auto_triggerhurt_touch;
		}
	}

	//if(!self.spread_vel)
	//	self.spread_vel = -1;
	if(self.startnonsolid == 1)
	{
		self.oldsolid = self.solid;
		self.wrathflags += FL_STARTNONSOLID;
		self.solid = SOLID_NOT;
		self.think = turn_solid;
		self.nextthink =  self.ltime + 1;
	}
};
void() model_destruct = 
{ 
	precache_model (self.model);
	precache_model("models/gibs/gib_stone1.bsp");
	precache_model("models/gibs/gib_stone2.bsp");
	precache_model("models/gibs/gib_stone3.bsp");
	precache_model("models/gibs/gib_stone4.bsp");
	precache_model("models/gibs/gib_tomb1.bsp");
	precache_model("models/gibs/gib_tomb2.bsp");
	precache_model("models/gibs/gib_tomb3.bsp");
	precache_model("models/gibs/gib_tomb4.bsp");
	precache_model("models/gibs/gib_wood1.bsp");
	precache_model("models/gibs/gib_wood2.bsp");
	precache_model("models/gibs/gib_wood3.bsp");
	precache_model("models/gibs/gib_wood4.bsp");

	if (self.noise)
		precache_sound(self.noise);
	if (self.noise2)
		precache_sound(self.noise2);
	if (self.noise3)
		precache_sound(self.noise3);

	if (self.type == 1)
	{
		precache_sound("impact/destruct/stone_break1.ogg");
		precache_sound("impact/destruct/stone_break2.ogg");
		self.noise = ("impact/destruct/stone_break1.ogg");
		self.noise2 = ("impact/destruct/stone_break2.ogg");
	}

	if (self.type == 2)
	{
		precache_sound("impact/destruct/wood1_break1.ogg");
		precache_sound("impact/destruct/wood1_break2.ogg");
		precache_sound("impact/destruct/wood1_break3.ogg");
		self.noise = ("impact/destruct/wood1_break1.ogg");
		self.noise2 = ("impact/destruct/wood1_break2.ogg");
		self.noise3 = ("impact/destruct/wood1_break3.ogg");
	}

	if (self.type == 4)
	{
		precache_sound("impact/destruct/glass_break1.ogg");
		precache_sound("impact/destruct/glass_break2.ogg");
		precache_sound("impact/destruct/glass_break3.ogg");
		self.noise = ("impact/destruct/glass_break1.ogg");
		self.noise2 = ("impact/destruct/glass_break2.ogg");
		self.noise3 = ("impact/destruct/glass_break3.ogg");
	}


	if (self.fakelight == 1)
	{
			vector borg = b_org(self);
			fake_light (self,borg);
	}
	if (self.gibmodel1)
	{
		precache_model(self.gibmodel1);
		self.rfactor = 1;
	}

	if (self.gibmodel2)
	{
		precache_model(self.gibmodel2);
		self.rfactor = 2;
	}

	if (self.gibmodel3)
	{
		precache_model(self.gibmodel3);
		self.rfactor = 3;
	}

	if (self.gibmodel4)
	{
		precache_model(self.gibmodel4);
		self.rfactor = 4;
	}

	if (self.gibmodel5)
	{
		precache_model(self.gibmodel5);
		self.rfactor = 5;
	}

	//self.origin = 0.5 *(self.absmax + self.absmin); 
	//self.angles = '0 0 0';
	self.solid = SOLID_BSP;
	//self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	//setorigin (self, self.origin);
	if (!self.base_scale)
		self.base_scale = -1;
	if (!self.volume)
		self.volume = 1;
	if (self.volume > 1)
		self.volume = 1;
	if (!self.gibcount)
		self.gibcount = 5;
	if (self.gibcount <= 0)
		self.gibcount = 0;
	setmodel(self, self.model);
	if (!self.health)
		self.health = 5;
		//self.health = 50;

	if (!self.rad_sound)
		self.rad_sound = 512;
	if ((!self.targetname))
		self.takedamage = DAMAGE_YES;
	if ((self.spawnflags &1) && (self.targetname))
		self.takedamage = DAMAGE_YES;
	self.use = destruct_die;
	self.th_die = destruct_die;
	if(self.touch_smash & 1)
		self.touch = func_destruct_touch;
	self.fake_origin = (self.absmin + self.absmax) *0.5;
	 
	if (((self.targetname) && (self.spawnflags &1)) || (self.touch_smash&2)) 
	{
		local entity auto_triggerhurt;
		auto_triggerhurt = spawn();
			
		self.autotrigger_flag = 1;
		self.autotrigger = auto_triggerhurt;
		auto_triggerhurt.solid = SOLID_TRIGGER;
		auto_triggerhurt.owner = self;
		auto_triggerhurt.touch_smash = self.touch_smash;
		auto_triggerhurt.touch_smash_delay = self.touch_smash_delay;
		if(self.touch_smash & 2)
			setsize(auto_triggerhurt, (self.absmin - ('4 4 2')), (self.absmax + ('4 4 2')));
		else
			setsize(auto_triggerhurt, (self.absmin - ('20 20 2')), (self.absmax + ('20 20 2')));
		auto_triggerhurt.touch = auto_triggerhurt_touch;
	}
	if(self.startnonsolid == 1)
	{
		self.oldsolid = self.solid;
		self.wrathflags += FL_STARTNONSOLID;
		self.solid = SOLID_NOT;
		self.think = turn_solid;
		self.nextthink =  time + 1;
	}
};


void() func_brekeable  =
{
self.think = func_destruct;
self.nextthink = self.ltime;
};

void() rotate_stop = 
{ 
	if (self.noise2)
		sound(self, CHAN_VOICE, self.noise2, self.volume, self.rad_sound);
	self.avelocity = '0 0 0';
	SUB_UseTargets();
};

.vector rot_ang;
.vector rot_ang2;
.vector rot_ang3;
.vector rot_ang4;
.vector rot_ang5;

.float wait2;
.float wait3;
.float wait4;
.float wait5;

void() rotdoor_use = 
{ 
	local float angvmul;
	angvmul = 1 / self.wait;
	float attn = 512 / self.rad_sound;
	if (self.noise)
		sound(self, CHAN_VOICE, self.noise, self.volume, attn);

	self.avelocity_x = self.rot_ang_x * angvmul;
	self.avelocity_y = self.rot_ang_y * angvmul;
	self.avelocity_z = self.rot_ang_z * angvmul;

	self.nextthink = self.ltime + self.wait;
	self.think = rotate_stop;
};

void() func_rotate = 
{ 


	if(!(self.noise))
		self.noise = "misc/null.wav";
	if(!(self.noise2)) 
		self.noise2 = "misc/null.wav";

	precache_sound(self.noise);
	precache_sound(self.noise2);


	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.use = rotdoor_use;
	if (!self.wait)
		self.wait = 1;
};

void() func_fan_on;

void() func_fan_off = { self.avelocity = '0 0 0';
	self.use = func_fan_on;
};

void() func_fan_on = { self.avelocity = self.rot_ang;
	self.use = func_fan_off;
	self.nextthink = 999999999999999999999999;
};

void() func_fan = { self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.use = func_fan_on;
	if (self.spawnflags != 1)
	{
		self.think = func_fan_on;
		self.nextthink = self.ltime + 0.1;
	}
};

.vector nextglowmod;
.vector oldglowmod;
void() func_wall_use_glowmod =
{
	
	float glowsteps = self.wait / 0.05;

	float xdif = (self.oldglowmod_x - self.nextglowmod_x) / glowsteps * -1;
	float ydif = (self.oldglowmod_y - self.nextglowmod_y)/ glowsteps * -1;
	float zdif = (self.oldglowmod_z - self.nextglowmod_z)/ glowsteps * -1;

	self.cnt ++;

	if(self.cnt <= glowsteps)
	{
		self.glowmod_x += xdif;
		self.glowmod_y += ydif;
		self.glowmod_z += zdif;
		self.think = func_wall_use_glowmod;

	}
	else
	{
		self.think = SUB_Null;
	}

	if(self.glowmod_x <= 0)
		self.glowmod_x = -1;
	if(self.glowmod_y <= 0)
		self.glowmod_y = -1;
	if(self.glowmod_z <= 0)
		self.glowmod_z = -1;


	self.nextthink = self.ltime + 0.05;
};


void() func_wall_use =
{
	if(self.spawnflags & 1)
	{
		self.effects = 0;
		self.solid = SOLID_BSP;
	}

	self.use = SUB_Null;

};

void() func_wall = 
{ 
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	if(self.spawnflags & 1)
	{
		self.effects += EF_NODRAW;
		self.solid = 0;
		self.use = func_wall_use;
	}
	if(self.spawnflags & 2)
	{
		if(!self.glowmod)
			self.glowmod = '1 1 1';
		if(!self.nextglowmod)
			self.nextglowmod = '0 0 0';
		if(!self.wait);
			self.wait = 1;	
		self.oldglowmod = self.glowmod;

		self.use = func_wall_use_glowmod;
		self.displacement = 0;
	}

	if(self.displacement == 1)
	{
		self.movetype = 0;
		self.wrathflags += FL_INVISIBLE;
		self.effects = EF_NODRAW;
		self.solid = 0;
	}	
	if(self.displacement == -1)
	{
		self.wrathflags += FL_INVISIBLE;
		self.oldeffects = EF_NODRAW;
	}
	setmodel(self, self.model);

};

.vector valpha; //<min_alpha> <max_alpha> <fade_rate> (phade starts when lifetime is 0)
void() ray_colormodcontroller_pulse_think =
{

	float maxcolormod;
	float mincolormod;

	if(self.owner.spawnflags & 1)
	{maxcolormod = 1.5; mincolormod = 0.5;}
	if(self.owner.spawnflags & 2)
	{maxcolormod = 2; mincolormod = 1;}


	if(self.owner.effects == 512)
	{
		if(self.cnt == 1)
		{
			if(self.owner.colormod_x >= maxcolormod)
				self.cnt = 0;
			else  
				self.owner.colormod_x += random(0.025,0.05);
		}
		else
		{
			if(self.owner.colormod_x <= mincolormod)
				self.cnt = 1;
			else  
				self.owner.colormod_x -= random(0.025,0.05);
		}
		self.owner.colormod_y = self.owner.colormod_x;
		self.owner.colormod_z = self.owner.colormod_x;
		self.owner.glowmod_x = 2 - self.owner.colormod_x;
		self.owner.glowmod_y = 2 - self.owner.colormod_x;
		self.owner.glowmod_z = 2 - self.owner.colormod_x;

	}
    self.think = ray_colormodcontroller_pulse_think;
    self.nextthink = time + 0.05; 
};

void(entity e) ray_colormodcontroller_pulse_spawn =
{
    entity colormod_controller = spawn();
    colormod_controller.owner = e;
	e.wrathflags += FL_MISCCONTROLLER;
	colormod_controller.owner.colormod = '1 1 1';
	e.pipes = colormod_controller;
    colormod_controller.think = ray_colormodcontroller_pulse_think;
    colormod_controller.nextthink = time;
};
void() func_ray_toggle_on;

void() func_ray_thinkoff =
{
	if(self.alpha > self.valpha_x)
		self.alpha -= (self.valpha_z / 20); 	
	else
	{
		self.use = func_ray_toggle_on;
		self.effects = EF_NODRAW;
		self.think = SUB_Null;
		self.nextthink = time + 0.05;
		return;
	}
	self.think = func_ray_thinkoff;
	self.nextthink = time + 0.05;
};

void() func_ray_toggle_off =
{
	self.think = func_ray_thinkoff;
	self.nextthink = time + 0.05;
};

void() func_ray_think =
{

	if(self.alpha < self.valpha_y)
		self.alpha += (self.valpha_z / 20); 	
	else
	{
		self.alpha = self.valpha_y;
		self.use = func_ray_toggle_off;
		self.think = SUB_Null;
		self.nextthink = time + 0.05;
		return;
	}
	self.think = func_ray_think;
	self.nextthink = time + 0.05;
};

void() func_ray_toggle_on =
{
	self.effects = EF_FULLBRIGHT;
	self.alpha = self.valpha_x;
	self.think = func_ray_think;
	self.nextthink = time + 0.05;
};

void() func_ray = 
{ 
	self.solid = 0;

	if(!(self.valpha))
		self.valpha = '0.01 0.75 1';
	if(self.valpha_x <= 0)
		self.valpha_x = 0.01; 


	if(self.spawnflags & 1)
	{
		self.effects = EF_NODRAW;
		self.use = func_ray_toggle_on;
		self.alpha = self.valpha_x;
	}
	else
	{
		self.effects = EF_FULLBRIGHT;
		self.use = func_ray_toggle_off;
		self.alpha = self.valpha_y;
	}

		if(self.spawnflags & 2)
		self.effects = 0;

	ray_colormodcontroller_pulse_spawn(self);
	setmodel(self, self.model);
};



void() func_brush = 
{ 
	setmodel(self, self.model);
};

void() func_clip = { setmodel(self, self.model);
	self.effects = EF_NODRAW;
	self.solid = SOLID_BBOX;
};

void() func_illusionary_use =
{

	if (self.effects & EF_NODRAW)
	{
		if(self.velocity)
			self.movetype = MOVETYPE_NOCLIP;
		self.effects -= EF_NODRAW;
		if(self.wait > 0)
		{
			self.think  =  alphafade;
			self.nextthink = time + self.wait; 
		}
	}
	else
	{
		self.effects += EF_NODRAW;
		self.alpha = -1;
	}
};
void() func_illusionary = 
{ 
	setmodel(self, self.model);
	if (self.type == 2)
		makestatic(self);

	if (self.type == 1)
		self.effects += EF_DOUBLESIDED;
	if(self.spawnflags & 1)
	self.effects += EF_NODRAW;
	if(self.spawnflags & 2)
	self.effects += EF_DYNAMICMODELLIGHT;
//	if(!(self.wait))
//	self.wait = 5;
//	self.trace_dphitq3surfaceflags = Q3SURFACEFLAG_NOMARKS;
	self.use = func_illusionary_use;
};

.float move1_time;
.float move2_time;
.float move3_time;

.vector move1_dist;
.vector move2_dist;
.vector move3_dist;

.vector move1_speed;
.vector move2_speed;
.vector move3_speed;

.float invertfade;
.float move_state;
.vector vel_var;
.vector rot_ang_end;

.float scale_var;
.float change_vel;

void() fadewall_use = 
{ 
	if (self.invertfade)
		self.alpha += self.cnt;
	else
		self.alpha -= self.cnt;

	if (self.invertfade)
	{
		if (self.alpha < 1)
			self.think = fadewall_use;
		else
		{
			self.alpha = 1;
			self.move1_time = 0;
			self.velocity = '0 0 0';
			self.movetype = 0;
			self.think = null;
			if (self.rot_ang)
			{
				self.movetype = MOVETYPE_NOCLIP;
				self.nextthink = time + 999999999999999999999999;
			}
		}
	}
	else
	{
		if (self.alpha > 0)
			self.think = fadewall_use;
		else
			self.think = SUB_Remove;
	}

	if (self.move1_time > time)
		self.velocity = self.move1_speed;
	else
	{
		if (self.move2_time > time)
			self.velocity = self.move2_speed;
		else
		{
			if (self.move3_time > time)
				self.velocity = self.move3_speed;
		}
	}

	if (self.change_vel == 1)
		self.rot_ang -= self.vel_var;
	self.avelocity = self.rot_ang;
	self.scale += self.scale_var;

	self.nextthink = time + 0.05;
};

void() fadewall_preuse = 
{ 
	self.move3_time = time + self.move1_time + self.move2_time + self.move3_time;
	self.move2_time = time + self.move1_time + self.move2_time;
	self.move1_time = time + self.move1_time;
	if (self.invertfade == 1)
	{
		self.effects = 0;
		self.alpha = 0.01;
	}
	self.think = fadewall_use;
	self.nextthink = time;
};

/*
func_figment

move1_time how much long takes the first movement
move2_time how much long takes the second movement
move3_time how much long takes the third movement

invertfade  starts invisible?

alpha alpha intensity

delay

move1_dist first movement distance vector
move2_dist second movement distance vector
move3_dist third movement distance vector

rot_ang vector angles at start
rot_ang_end vector angles at end
*/
void() func_figment = 
{ 
	self.movetype = MOVETYPE_NOCLIP;
	if (!self.move1_time)
		self.move1_time = 0.35;
	if (!self.move2_time)
		self.move2_time = 0.35;
	if (!self.move3_time)
		self.move3_time = 0.35;
	if (self.invertfade == 1)
	{
		self.alpha = 0;
		self.effects = EF_NODRAW;
	}
	else
	{
		if (!self.alpha)
			self.alpha = 1;
	}

	if (!self.delay)
		self.delay = 1.05;

	self.move1_speed_x = self.move1_dist_x *(self.delay / self.move1_time);
	self.move1_speed_y = self.move1_dist_y *(self.delay / self.move1_time);
	self.move1_speed_z = self.move1_dist_z *(self.delay / self.move1_time);

	self.move2_speed_x = self.move2_dist_x *(self.delay / self.move2_time);
	self.move2_speed_y = self.move2_dist_y *(self.delay / self.move2_time);
	self.move2_speed_z = self.move2_dist_z *(self.delay / self.move2_time);

	self.move3_speed_x = self.move3_dist_x *(self.delay / self.move3_time);
	self.move3_speed_y = self.move3_dist_y *(self.delay / self.move3_time);
	self.move3_speed_z = self.move3_dist_z *(self.delay / self.move3_time);
	self.scale = 1;
	self.count = 1;
	self.cnt = 1 / (self.delay / 0.05);
	setmodel(self, self.model);
	local float nf;
	nf = 1;
	self.vel_var_x = ((self.rot_ang_x - self.rot_ang_end_x) / (20 *self.delay)) *nf;
	self.vel_var_y = ((self.rot_ang_y - self.rot_ang_end_y) / (20 *self.delay)) *nf;
	self.vel_var_z = ((self.rot_ang_z - self.rot_ang_end_z) / (20 *self.delay)) *nf;

	self.use = fadewall_preuse;
};

void() func_fakeshadowthink = 
{ 
	if (self.count == 1)
	{
		self.alpha += 0.0025;
		if (self.alpha >= 0.75)
			self.count = 0;
	}
	else
	{
		self.alpha -= 0.0025;
		if (self.alpha <= 0.1)
			self.count = 1;
	}

	self.nextthink = time + 0.01;
};
void() func_fakeshadow = 
{ 
	if (self.alpha == 0.1)
		self.count = 1;
	else
		self.count = 0;

	setmodel(self, self.model);
	self.think = func_fakeshadowthink;
	self.nextthink = time;
};

.float max_angle_y;
.float min_angle_y;
.float virtualangles_y;

float(entity bloke, entity rotate) backtouch2 = 
{ 
	local float result;
	local vector veca, vecb;

	makevectors(bloke.v_angle);

	veca = v_right;

	makevectors(rotate.angles);
	vecb = v_forward;

	result = ((veca_x *vecb_y) - (vecb_x *veca_y));

	if (result < 0)
		result = result *-1;

	return result;

};
float(entity targ, entity eself) backtouch = 
{ 
	local vector vec;
	local float dot;

	makevectors2(eself.angles);
	vec = normalize(rorigin(targ) - rorigin(eself));
	dot = vec * v_forward;

	if (dot > 0)
		return FALSE;
	else
		return TRUE;
};

.float rotate_flags;
.entity anglecalculator;
float ROTATE_STOP = 0;
float ROTATE_FORWARD = 1;
float ROTATE_REVERSE = 2;
void() rotate_fance_stop = 
{ 
	self.cnt = 0;
	self.avelocity = '0 0 0';
};
void() func_rotate_fence_rotates = 
{ 
	if (((self.skin <= -90) && (self.rotate_flags == ROTATE_REVERSE)) || ((self.skin >= 90) && (self.rotate_flags == ROTATE_FORWARD)))
	{
		self.avelocity_y = 0;
		self.think = rotate_fance_stop;
		self.rotate_flags = ROTATE_STOP;
		self.cnt = 0;
		self.nextthink = self.ltime;
		return;
	}

	if ((self.cnt > 0))
	{
		self.cnt--;
		local float avel;
		avel = self.rot_ang_y *(self.cnt / 20);
		self.virtualangles_y += avel;
		self.skin = self.virtualangles_y / 20;

		self.avelocity_y = avel;
	}
	else
	{
		self.avelocity_y = 0;
		self.think = rotate_fance_stop;
		self.rotate_flags = ROTATE_STOP;
	}

	self.think = func_rotate_fence_rotates;
	self.nextthink = self.ltime + 0.05;
};

float(entity plyr) horizontalvel = 
{ 
	float hor_vel;
	float x_vel = other.velocity_x;
	float y_vel = other.velocity_y;
	if (x_vel < 0)
		x_vel = x_vel *-1;
	if (y_vel < 0)
		y_vel = y_vel *-1;
	hor_vel = ((x_vel + y_vel) *0.2) + 10;
	bprint(ftos(hor_vel), "\n");
	return hor_vel;
};
void() func_rotate_fence_touch = 
{ 
	if (other.classname != "player")
		return;
	if (backtouch(other, self))
	{
		self.rot_ang_y = -45;
		self.rotate_flags = ROTATE_REVERSE;
	}
	else
	{
		self.rot_ang_y = 45;
		self.rotate_flags = ROTATE_FORWARD;
	}

	float anglemultiplier = (backtouch2(other, self));

	float touchervel;
	touchervel = horizontalvel(other);
	if (self.cnt <= 20)
		self.cnt = touchervel *anglemultiplier *0.5;
	else
		return;

	self.think = func_rotate_fence_rotates;
	self.nextthink = self.ltime + 0.05;
};

void() func_rotate_fence = 
{ 
	self.movetype = MOVETYPE_PUSH;
	self.rotate_flags = ROTATE_STOP;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.touch = func_rotate_fence_touch;
	self.virtualangles_y = 0;
	if (!self.wait)
		self.wait = 1;
};

void() func_monsterclip = 
{ 
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.dphitcontentsmask = DPCONTENTS_SOLID;
};

void(vector inflictor_origin, entity targ, float damage, float pushfactor) explo_physics_bmodels = 
{ 
	vector dir, z_vel;
	vector borg = b_org(targ);
	dir = borg - inflictor_origin;
	dir = normalize(dir);
	targ.movetype = MOVETYPE_BOUNCE;
	if (targ.flags &FL_ONGROUND)
		targ.flags -= FL_ONGROUND;
	z_vel_z =pushfactor * 12;
	targ.velocity = targ.velocity + dir *damage * pushfactor +z_vel;
	targ.avelocity_x = random(90, 180);
	targ.avelocity_y = random(90, 180);
	targ.avelocity_z = random(90, 180);
};


void()debris_think;
void() use_debris =
{
	self.solid = SOLID_CORPSE;	
	self.wrathflags += FL_GIB;
	self.effects = EF_DYNAMICMODELLIGHT;
	if(!(self.spawnflags & 1))
		explo_physics_bmodels(self.oldorigin, self, 130, 1);
	else
	{
		self.movetype = MOVETYPE_BOUNCE;
		if (self.flags &FL_ONGROUND)
			self.flags -= FL_ONGROUND;
		
		self.avelocity_x = random(90, 180);
		self.avelocity_y = random(90, 180);
		self.avelocity_z = random(90, 180);

	}
	self.think = debris_think;
	self.nextthink = time + 0.05;
};

void()debris_think = 
{

	if(!self.model_ammount) 
	{	
		vector realsize;
		realsize_x = self.absmax_x - self.absmin_x; 
		realsize_y = self.absmax_y - self.absmin_y;
		realsize_z = self.absmax_z - self.absmin_z;

		self.model_ammount = floor((realsize_x * realsize_y * realsize_z)/100);
	}
	if(!self.oldorigin) 
	{
		entity t = find(world, target, self.targetname2);
		self.oldorigin = b_org(t);
	}
	if(self.flags & FL_ONGROUND)
	{
		self.avelocity = '0 0 0';
		self.velocity = '0 0 0';
		self.think =  alphafade;
		self.nextthink = time +random(10, 20) ;
	}
	else 
	{
		self.think = debris_think;
		self.nextthink = time + 0.05;
	}
}
void() preuse_debris =
{
	self.think = use_debris;
	self.nextthink = time + self.delay;
}
void() func_debris  = 
{
	setmodel(self, self.model);
	if(!self.gravity)
		self.gravity = random(0.75,1);
	if(!(self.spawnflags & 2))
	self.effects = EF_NODRAW;
	self.solid = SOLID_NOT;

	if(!self.delay)
		self.delay = random(0,0.25);
	self.use = preuse_debris;
	self.think = debris_think;
	self.nextthink = time + 0.1;
};

void()trigger_shake_use = 
{
	if(self.sradius)
	{
		float distancetoplayer = vlen (self.origin - single_player.origin);
		if (distancetoplayer >= self.sradius)
		{
			remove(self); 
			return;
		}
		else
		{	
			if(self.sattenuation == 1)
				float modifier = 1 / (self.sradius / (self.sradius - distancetoplayer ));
			else
				modifier = 1;
			self.intensity_x = self.intensity_x * modifier;  
			self.intensity_y = self.intensity_y * modifier;
		}
	}
	single_player.shaked = 1;

	// Reki (December 3 2023): Added controller rumble
	/*
	float total_intensity = vlen(self.intensity);
	if (total_intensity > 12)
	{
		Controller_Rumble(single_player, bound(0, total_intensity / 160, 1), bound(0, total_intensity / 240, 1), max(20, self.wait * 800));
	}
	*/

	if(self.classname != "spawnedshaker")
	{
		single_player.shake_camera_time = time + self.wait;
		single_player.shake_camera_ammountx = self.intensity_x * 0.1;
		float r = random();
		if (r > 0.5)
			single_player.shake_camera_ammounty = self.intensity_y * 0.1;
		else
			single_player.shake_camera_ammounty = self.intensity_y *-1 * 0.1;
		single_player.shake_camera_refresh_rate = self.shake_camera_refresh_rate;
	}
	else
	{
		single_player.shake2_camera_time = time + self.wait;
		single_player.shake2_camera_ammountx = self.intensity_x * 0.1;
		r = random();
		if (r > 0.5)
			single_player.shake2_camera_ammounty = self.intensity_y * 0.1;
		else
			single_player.shake2_camera_ammounty = self.intensity_y *-1 * 0.1;
		single_player.shake2_camera_refresh_rate = self.shake_camera_refresh_rate;
	}
	if(!(self.spawnflags & 1))
		remove(self);
};

void() trigger_shake = 
{
	if(!self.wait)
		self.wait = 1;
	if(!self.intensity_x)
		self.intensity_x = 10;
	if(!self.intensity_y)
		self.intensity_y = 10;
	if(!self.shake_camera_refresh_rate)
		self.shake_camera_refresh_rate = 0.05;
/*
	single_player.shaked = 1;
	single_player.shake_camera_time = time + 1;
	single_player.shake_camera_ammountx = 1;
	single_player.shake_camera_ammounty = 1;
	single_player.shake_camera_refresh_rate = 0.05;

*/
	self.use = trigger_shake_use;
};
.float stepheighttime;
.float stepheight;

.float oldstepheight_delta;

void() restore_oldstepheight =
{
	self.owner.stepheight_delta = self.owner.oldstepheight_delta;
	self.owner.colormod = '1 1 1';
	remove(self);
}
void() trigger_stepheight_touch =
{

	if((other.flags & FL_MONSTER) && (other.stepheighttime < time))
	{
		local float dev = cvar ("developer");
		if(dev == 1)
			other.colormod = '1 1 0';
		other.stepheight_delta = self.stepheight + 1;
		other.stepheighttime = time + self.wait;
		entity stepheight_restorer = spawn();
		stepheight_restorer.owner = other;
		stepheight_restorer.think = restore_oldstepheight;
		stepheight_restorer.nextthink = time + self.wait;
	}
};
void() trigger_stepheight =
{
	setmodel (self, self.model);
	self.effects = EF_NODRAW;
	self.solid = SOLID_TRIGGER;
	if(!self.wait)
		self.wait = 3;
	if(!self.stepheight)
		self.stepheight = 16;
	self.touch = trigger_stepheight_touch;
}

.vector rot_angles;
.vector rot_angles1;
.vector rot_angles2;

void() trigger_gib_zone_touch =
{
	if(other.classname != "func_destruct_rotate_think") 
	{

	}
};
void() trigger_gib_zone =
{
	InitTrigger ();

};
void()func_destruct_rotate_think;
void() destruct_rotate_blocked =
{
	if(self.cnt < 3)
	{
		self.movetype = MOVETYPE_NOCLIP;
		if (other.takedamage)
			T_Damage(other, self, self, 10000000);

		if(other == world)
		self.wait2 = 0;

		self.think = func_destruct_rotate_think;
		self.nextthink = time;
	}
};
.float oldwait1;
.float oldwait2;
void()func_destruct_rotate_think =
{

	if(!self.count)
	{
		self.wait2 = time + self.wait + self.wait1+ self.wait2;
		self.wait1 = time + self.wait + self.wait1;
		self.wait = time + self.wait;
		self.count = 1;

		if(!self.rot_angles)
			self.rot_angles = self.avelocity;
		if(!self.rot_angles1)
			self.rot_angles1 = self.avelocity1;
		if(!self.rot_angles2)
			self.rot_angles2 = self.avelocity2;
		self.cnt ++;
	}

	if(time > self.wait2)
	{
		self.solid =SOLID_NOT;
		self.movetype = MOVETYPE_NOCLIP;
		self.think = destruct_die;
		remove(self.pipes);
		self.nextthink = time;
		return;
	}

	if (self.spawnflags & 1)
		self.effects = EF_DYNAMICMODELLIGHT;
	
	if((self.movetype == MOVETYPE_NOCLIP) && (self.cnt < 3))
		self.movetype = MOVETYPE_PUSH;

	if(!self.autotrigger)
	{
		entity t = find(world, targetname, self.target2);
		if(t.classname == "trigger_gib_zone")
		{
			self.autotrigger_flag = 1;
			self.autotrigger =  t;
		}
	}	


	self.blocked = destruct_rotate_blocked;
	if(self.cnt == 1)
	{

		if ((self.noise) && (self.count ==  1))
		{
			self.count = 2;
			local float attn;
			if (self.rad_sound == 0)
				attn = 0;
			else if (self.rad_sound == -1)
				attn = -1;
			else
				attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!
			local vector orgsound;
			orgsound =self.origin;
			pointsound(orgsound, self.noise, self.volume, attn);
			if (world.model == "maps/boss1.bsp")
				sound7(self, CHAN_AUTO, self.noise, 1, attn,100,32);
			self.noise = self.noise2;
		}

		if((self.movetype != MOVETYPE_NOCLIP) && (time > self.wait)) 
			self.cnt ++;
		self.movetype = MOVETYPE_PUSH;

		self.avelocity_x = self.rot_angles_x * (1 / self.oldwait);
		self.avelocity_y = self.rot_angles_y * (1 / self.oldwait);
		self.avelocity_z = self.rot_angles_z * (1 / self.oldwait);
		
		self.think = func_destruct_rotate_think;		
		self.nextthink = self.ltime + 0.05;
	}
	if(self.cnt == 2)
	{
		self.velocity = self.velocity1;

		self.avelocity_x = self.rot_angles1_x * (1 / self.oldwait1);
		self.avelocity_y = self.rot_angles1_y * (1 / self.oldwait1);
		self.avelocity_z = self.rot_angles1_z * (1 / self.oldwait1);

		if((self.movetype != MOVETYPE_NOCLIP) && (time > self.wait1)) 
		{
			self.cnt ++;
		}

		self.think = func_destruct_rotate_think;
		self.nextthink = self.ltime + 0.05;
	}
	if(self.cnt == 3)
	{
		self.velocity = self.velocity2;
		self.avelocity_x = self.rot_angles2_x * (1 / self.oldwait2);
		self.avelocity_y = self.rot_angles2_y * (1 / self.oldwait2);
		self.avelocity_z = self.rot_angles2_z * (1 / self.oldwait2);

		self.think = func_destruct_rotate_think;

		pointsound(orgsound, self.noise3, self.volume, attn);
		if (world.model == "maps/boss1.bsp")
			sound7(self, CHAN_AUTO, self.noise3, 1, attn,100,32);

		self.nextthink = self.ltime + 0.05;
	}	
};
void() destruct_volume_think = 
{
	self.avelocity = self.owner.avelocity;
	self.think = destruct_volume_think;
	self.nextthink = time;
};

void() func_rotate_destruct_field_touch
{
	if (other.takedamage)
		T_Damage(other, self, self, 10000000);
};
void()func_rotate_destruct_field_think =
{
	setorigin (self,self.owner.origin);
	self.think = func_rotate_destruct_field_think;
	self.nextthink = time + 0.05;
}
void()func_destruct_rotate =
{
	if (self.noise)
		precache_sound(self.noise);
	if (self.noise2)
		precache_sound(self.noise2);
	if (self.noise3)
		precache_sound(self.noise3);
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 4096;
	if(!self.rot_angles)
		self.rot_angles = self.avelocity;
	if(!self.rot_angles1)
		self.rot_angles1 = self.avelocity1;
	if(!self.rot_angles2)
		self.rot_angles2 = self.avelocity2;
	setmodel (self, self.model);

	self.oldwait =self.wait;
	self.oldwait1 =self.wait1;
	self.oldwait2 =self.wait2;

	self.solid = SOLID_BSP;
	self.blocked = destruct_rotate_blocked;
	self.use =func_destruct_rotate_think;
	if(self.dmg)
	{
		entity field = spawn();
		field.owner = self;
		field.origin = self.origin;
		self.pipes = field;
		vector r_size = self.absmax - self.absmin; 
		setsize (field, r_size * -0.5 ,r_size * 0.5 );
		field.solid = SOLID_TRIGGER;
		field.movetype = MOVETYPE_FLY;
		field.touch = func_rotate_destruct_field_touch;
		field.think = func_rotate_destruct_field_think;
		field.nextthink = time + 0.05;
	}
};
void() func_nodestruct_ready =
{
	centerprint(single_player, "ready to get damage again\n");
	self.takedamage = DAMAGE_YES;
	self.colormod = '1 1 1';
};

void() func_nodestruct_showdmg
{
	self.takedamage = DAMAGE_NO;
	self.colormod = '0 1 0';
	float currentdamage = self.maxhealth - self.health;
	centerprint(single_player, strcat("Damage Caused ", ftos (currentdamage),"   HITS: ", ftos (self.cnt),"\n"));

	self.cnt = 0;

	self.health = self.maxhealth;
	self.nextthink = time + cvar("scr_centertime");
	self.think = func_nodestruct_ready;
};
void() func_nodestruct_pain =
{
	self.colormod = '1 0 0';

	self.think = func_nodestruct_showdmg;
	self.nextthink = time + 1;
};

void() func_nodestruct =
{
	setmodel (self, self.model);
	self.solid = SOLID_BSP;
	self.takedamage = DAMAGE_YES;
	self.th_die = func_nodestruct_pain;
	self.th_pain = th_paintodeath;
	self.maxhealth = 100000;
	self.flags += FL_MONSTER;
	self.health = self.maxhealth;
};

void() func_pendulum_touch =
{

	if (other.takedamage)
	{
		if(self.attack_finished < time)
		{
			T_Damage (other, self, self, random(160,320));

			vector fixed_vel;

			fixed_vel_x = self.owner.avelocity_x * -1;
			fixed_vel_y = self.owner.avelocity_z;

			other.velocity = fixed_vel * 1.25;
			other.velocity_z += random(192,256);
			self.attack_finished = time + 0.1;

			vector org = other.origin + '0 0 20';	
			SpawnBlood(org, '0 0 0', 32, 1, 0);
			SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));


			vector vsize =  self.owner.absmax - self.owner.absmin;
			vector vorg;
			vorg_z =  vsize_z * 0.35;
			setorigin (self,self.origin - vorg);

		}
	}	
};

void() func_pendulum_blocked =
{
	vector vsize =  self.absmax - self.absmin;
	vector vorg;
	vorg_z =  vsize_z * 0.35;
	setorigin (self.pipes,self.origin - vorg);	

};
void() func_pendulum_think=
{

		
	self.count ++;

	if(self.cnt == 1)
	{
		float avelinc = 1 - (self.count / (self.oldwait / 4));
		if(avelinc <= 0)
		{	
			self.count = 0;
			self.cnt = 2;
		}
	}
	if(self.cnt == 2)
	{
		avelinc = 0 + (self.count / (self.oldwait / 4)) * -1;
		if(avelinc <= -1)
		{	
			self.count = 0;
			self.cnt = 3;
			vector vsize =  self.absmax - self.absmin;
			vector vorg;
			vorg_z =  vsize_z * 0.35;
			setorigin (self.pipes,self.origin - vorg);

		}
	}
	if(self.cnt == 3)
	{
		avelinc =  (1 - (self.count / (self.oldwait / 4))) * -1;
		if(avelinc >= 0)
		{	
			self.count = 0;
			self.cnt = 4;
		}
	}
	if(self.cnt == 4)
	{
		avelinc = 0 + (self.count / (self.oldwait / 4));
		if(avelinc >= 1)
		{	
			self.count = 0;
			self.cnt = 1;
			vsize =  self.absmax - self.absmin;
			vorg_z =  vsize_z * 0.35;
			setorigin (self.pipes,self.origin - vorg);

		}
	}

	self.avelocity_x = self.rot_angles_x * avelinc * (2 * (1 / self.wait));
	self.avelocity_y = self.rot_angles_y * avelinc * (2 * (1 / self.wait));
	self.avelocity_z = self.rot_angles_z * avelinc * (2 * (1 / self.wait));


	self.think = func_pendulum_think;
	self.nextthink = self.ltime + 0.05;	
	//self.nextthink = time + 0.05;
};

void() func_prependulum_think =
{
	self.angles_x = self.rot_angles_x / (20 / (1 / self.wait));
	self.angles_y = self.rot_angles_y / (20 / (1 / self.wait));
	self.angles_z = self.rot_angles_z / (20 / (1 / self.wait));
	self.think = func_pendulum_think;
	self.nextthink = self.ltime + 0.1;
	//self.nextthink = time + 0.1;
};

void() field_pendulum_think =
{
	
	vector fixed_vel;

	float vel_x_size = self.owner.absmax_x - self.owner.absmin_x * 0.0015;
	float vel_y_size = self.owner.absmax_y - self.owner.absmin_y * 0.0015;

	fixed_vel_x = self.owner.avelocity_x * -1* 1.25;
	fixed_vel_y = self.owner.avelocity_z * 1.25;


	self.velocity = fixed_vel;
	self.think = field_pendulum_think;
	self.nextthink = time + 0.05;
	
};

void() func_pendulum =
{    
	setmodel (self, self.model);
	if(!self.rot_angles)
		self.rot_angles = '90 0 0';
	if(!self.wait)
		self.wait = 0.5;
	self.blocked =  func_pendulum_blocked;
	self.count = 0;
	self.cnt = 1;
	self.oldwait = (self.wait / 0.05) * 4;

	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
    self.think = func_prependulum_think;
    self.nextthink = self.ltime + 0.1;
	entity field = spawn();
	field.touch = func_pendulum_touch;

	vector vsize =  self.absmax - self.absmin;

	vector vorg;
	vorg_z =  vsize_z * 0.35;
	setorigin (field,self.origin - vorg);
	setsize (field,vsize *  -0.5,vsize * 0.5 );
	field.solid = SOLID_TRIGGER;
	field.movetype = MOVETYPE_NOCLIP;
	self.pipes = field;
	field.owner = self;
	field.think = field_pendulum_think;
	field.nextthink = time + 0.1;
};

//////////////////////////////////end of qc file/t 
