.float explodcount;
.float gwmd;
.float fire_time_cannon;
void() wfire_cannon;

void() idle_cannon = { if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	self.realoding = 0;
	self.vweaponframe = 0;
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.vweaponframe = 0;
	self.vweaponglowmod = '1 1 1';
	self.vweaponskin = 0;
};

void() prelease_cannon = {

	self.vweaponframe += 1;
	if (self.vweaponframe >= 20)
		self.think = idle_cannon;
	else
		self.think = prelease_cannon;
	self.nextthink = time + 0.05;
};

void() slag2_explode10 = { self.skin += 1;self.think = SUB_Remove;self.nextthink = time + 0.05;
};
void() slag2_explode9 = { self.skin += 1;self.think = slag2_explode10;self.nextthink = time + 0.05;
};
void() slag2_explode8 = { self.skin += 1;self.think = slag2_explode9;self.nextthink = time + 0.05;
};
void() slag2_explode7 = { self.skin += 1;self.think = slag2_explode8;self.nextthink = time + 0.05;
};
void() slag2_explode6 = { self.skin += 1;self.think = slag2_explode7;self.nextthink = time + 0.05;
};
void() slag2_explode5 = { self.skin += 1;self.think = slag2_explode6;self.nextthink = time + 0.05;
};
void() slag2_explode4 = { self.skin += 1;self.think = slag2_explode5;self.nextthink = time + 0.05;
};
void() slag2_explode3 = { self.skin += 1;self.think = slag2_explode4;self.nextthink = time + 0.05;
};
void() slag2_explode2 = { self.skin += 1;self.think = slag2_explode3;self.nextthink = time + 0.05;
};
void() slag2_explode1 = { self.skin += 0;self.think = slag2_explode2;self.nextthink = time + 0.05;
};
void() slag_explode5 = { self.skin += 1;self.think = SUB_Remove;self.nextthink = time + 0.05;
};
void() slag_explode4 = { self.skin += 1;self.think = slag_explode5;self.nextthink = time + 0.05;
};
void() slag_explode3 = { self.skin += 1;self.think = slag_explode4;self.nextthink = time + 0.05;
};
void() slag_explode2 = { self.skin += 1;self.think = slag_explode3;self.nextthink = time + 0.05;
};
void() slag_explode1 = { self.skin += 0;self.think = slag_explode2;self.nextthink = time + 0.05;
};
void() orenextframe = 
{
	if(self.solid == SOLID_CORPSE)
		self.solid = SOLID_BBOX;
	if(self.frame != 1)
	{	
		self.vweaponangles = self.angles;
		self.frame = 1;
		self.lifetime = time + 5;
	}

	float speed;
	speed = vlen (self.velocity);
	if(speed < (slagspeed2 * 0.9))
	{
		setorigin (self,self.originoffset);
		makevectors2 (self.vweaponangles);
		self.solid = SOLID_CORPSE;
		self.velocity =  v_forward * slagspeed2;
		self.think = orenextframe;
		self.nextthink =  time + 0.125;
		return;
	}

	self.originoffset = self.origin + normalize (self.angles) * slagspeed2;
	if(self.lifetime < time)
		self.think = SUB_Remove;
	else
		self.think = orenextframe;
	self.nextthink =  time + 0.05;

};
void()cannon_proj_touch;
void() slagdrunk = 
{ 
	if(!self.frame)
		self.frame = 1;
	
	self.explodcount += 1;
	makevectors2 (self.angles);
	self.velocity = ((self.velocity + ((v_right *20.000) *crandom())) + ((v_up *20.000) *crandom()));
	
	float speed;
	speed = vlen (self.velocity);
	if (speed < (slagspeed * 0.95))
	{	
		sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop
		self.think = cannon_proj_touch;
		self.nextthink = time;
		return;
	}
	if (self.explodcount < 50)
		self.think = slagdrunk;
	else
	{
		sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop
		self.think = SUB_Remove;
	}
	self.nextthink = time + 0.1;	// screw up fast

};

void() srelease_cannon2 = { self.vweaponframe += 1;
	if (self.vweaponframe >= 40)
		self.think = idle_cannon;
	else
		self.think = srelease_cannon2;
	self.nextthink = time + 0.05;
};

void() srelease_cannon = { self.vweaponframe = 31;
	self.think = srelease_cannon2;
	self.nextthink = time + 0.05;
};
void() cannon_proj_touch_fade= 
{
	self.alpha -= 0.1;
	self.frame += 1;
	if ((self.alpha < 0) || (self.frame >= 9))
		self.think = SUB_Remove;
	else
		self.think = cannon_proj_touch_fade;
	self.nextthink = time + 0.05;


	if(self.classname == "fallen_burning_head")
	{
		entity head = findradius(self.origin, slagsplashradius2 -32);
		while (head)
		{
			if (head.wrathflags & FL_GIB)
			{
				head.effects = EF_FLAME;
				head.traileffectnum = particleeffectnum("lavatrail");
			}
			head = head.chain;  // cycle to next head (entity)
		}
	}
};

void(float m) cannon_proj_touch_impact = { self.movetype = MOVETYPE_NONE;

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	makevectors(self.angles);
	self.angles = '0 0 0';
	//self.origin = self.origin + v_forward *-12 + v_up *-5;
	self.frame = 0;
	if (m == 1)
		setmodel(self, "models/projectiles/proj_slag1_explo.md3");
	else
		setmodel(self, "models/projectiles/proj_slag2_explo.md3");
	self.alpha = 1;
	self.think = cannon_proj_touch_fade;
	self.nextthink  =  time + 0.05;
};


void()acelerator_think =
{
	// owner = person we're knocking back
	// enemy = person who created the knockback
	self.owner.velocity = self.velocity;

	if (self.enemy.flags & FL_CLIENT)
	{
		if (self.owner.velocity_z > 430)
		{
			tracebox(self.owner.origin, self.owner.mins, self.owner.maxs, self.owner.origin + '0 0 150', MOVE_NOMONSTERS, self.owner); // make sure it's not a super low ceiling
			if (trace_fraction >= 1)
			{
				Steam_AchievementUnlock(self.owner, ST_ACHIEVEMENTS::AL_FEAT_ROCKETJUMP);
			}
		}
	}

	remove(self);
};

void(entity attacker, entity perpetrator, float value, vector exp_origin, float rocketradius) T_RocketJump =
{

	vector org = (perpetrator.absmin + perpetrator.absmax) / 2;
	exp_origin_z -= bboxslag2_z;

	if(rocketradius < vlen(org - exp_origin))
		return;	
	float aircntjmp = cvar("aircannonfactor");
	perpetrator.rocketjumpcnt += aircntjmp;
	float points = (1 - (vlen(org - exp_origin) /  rocketradius)) * value;

	if (points > 0)
	{
		vector dir = perpetrator.origin - exp_origin;
		if !(perpetrator.flags & FL_ONGROUND)
			points = points / fabs(perpetrator.rocketjumpcnt);

		dir = normalize(dir);
		if (dir[2] > 0) // Reki (May 26 2023): vertical gets a little boost
			dir[2] *= 1.75;
		
		entity acelerator = spawn();
		acelerator.movetype = MOVETYPE_NOCLIP;
		acelerator.velocity = perpetrator.velocity + dir * points * 6;
		//acelerator.velocity_z =  acelerator.velocity_z / (1 + 
		acelerator.owner = perpetrator;
		acelerator.enemy = attacker;
		acelerator.think = acelerator_think;
		acelerator.nextthink = time + 0.05;
	}
};


void() cannon_proj_touch = 
{ 
	if (GetSkyMaterial())
	{
		remove(self);
		sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound
		return;
	}

	local vector org;
	org = self.origin;
	local string snd;
	if(other == self.owner)
	return;


	if((other.wrathflags &FL_PROJECTILE) &&  (self.cnt == 2))
	{
		self.originoffset = self.origin;
		self.velocity = '0 0 0';
		remove(other);
		return;
	}

	if(other.classentity == "projectiles")
		return;
	if (other.solid == SOLID_TRIGGER)
		return;
	if (other.solid == SOLID_CORPSE)
	{
		self.originoffset = self.origin;
		self.velocity = '0 0 0';
		return;
	}

    vector partvel =normalize(trace_plane_normal) * 92;
    float material = GetTraceMaterial();
	material_impacts(material,self.origin,partvel,1,0);


	vector old_impact = trace_endpos;
	traceline(self.origin, self.origin + v_forward *1024, MOVE_HITMODEL, self);
	if (trace_ent != other)
		trace_endpos = old_impact;
    if(other.bloody == 2)
    {
		makevectors2 (self.angles);
		if ((bossvulnerable == 1))
		{
			if(other == trace_ent)
			{

				float r = random(); 
					if(other.classname == "boss_guardian2")
						explo_blood_sprite(2, trace_endpos);
					else
						explo_blood_sprite(5, trace_endpos);
			}
			
		}
	    SpawnBlood(org, '0 0 0', 12, 6, 0);
    }
	if (other.bloodimpact)
		explo_blood_sprite(other.bloodimpact, trace_endpos);


	if (self.cnt != 1)
        spawn_shaker (self,12,0.5,256);
    
	if (self.cnt == 1)
	{
	self.classname = "explosion_ore";
	
		if((deathmatch == 1) || (other.classname == "player"))
		{
			T_Damage(other, self, self.owner,slagcannon_damage1_mp);
			T_SplashDamage(self, self.owner,slagsplashdamage_mp, other, slagsplashradius);
		}
		else
		{
			T_Damage(other, self, self.owner,slagcannon_damage1);
			T_SplashDamage(self, self.owner,slagsplashdamage, other, slagsplashradius);
		}
		cannon_proj_touch_impact(1);
		snd = strcat("impact/projectiles/slag1_explo", ftos(floor(random() * 4) + 1), ".ogg");
		pointparticles(particleeffectnum("slag"), org, v_forward *(-550), 1);
		sound(self, CHAN_AUTO, snd, 1, 0.25);
	    entity head = findradius(self.origin, slagsplashradius - 64);
	    while (head)
	    {
		    if (head.wrathflags & FL_GIB)
		    {
			    explo_physics_gibs (self,head,50,3); 	
		    }
		    head = head.chain;  // cycle to next head (entity)
	    }

	}
	else
	{
		self.classname = "explosion_oreb";
		if((deathmatch == 1) || (other.classname == "player"))
		{
			T_Damage(other, self, self.owner,slagcannon_damage2_mp);
			T_SplashDamage(self, self.owner, slagsplashdamage2_mp, other, slagsplashradius2);
		}
		else
		{
			if(other.classname == "monster_oppressor")
				other.monster_long_pain = 1;
			if((other.classname == "monster_brute"))
				other.monster_long_pain = 1;
			T_Damage(other, self, self.owner,slagcannon_damage2);

			T_SplashDamage(self, self.owner, slagsplashdamage2, other, slagsplashradius2);
		}
		float rocketradius = 128;
		T_RocketJump(self.owner, self.owner, slagrocketjump, self.origin, rocketradius);
		cannon_proj_touch_impact(2);
		snd = strcat("impact/projectiles/slag2_explo", ftos(floor(random() * 4) + 1), ".ogg");
		pointparticles(particleeffectnum("slag2"), org, v_forward *(-550), 1);
		sound(self, CHAN_AUTO, snd, 1, 0.125);
		head = findradius(self.origin, slagsplashradius2 - 64);
		while (head)
		{
			if (head.wrathflags & FL_GIB)
			{
				explo_physics_gibs (self,head,150,3); 	
			}
			head = head.chain;  // cycle to next head (entity)
		}
	}
};
void(float type, float forg) W_FireCannon = { local vector dir, rorg, tagorg;
	local float sv, tagindex;

	// Reki (December 1 2023): Fixed this not having punch angle
	if(cvar("cl_punch"))
	{
		if (type == 2)	
		{
			self.punchangle_x += -4;

			// Reki (December 3 2023): Added controller rumble
			Controller_Rumble(self, 0.6, 0.1, 150);
			Controller_RumbleTriggers(self, 0.3, 0, 50);
		}
		else
		{
			self.punchangle_x += -1;

			// Reki (December 3 2023): Added controller rumble
			Controller_Rumble(self, 0.2, 0.5, 60);
			Controller_RumbleTriggers(self, 0.3, 0, 50);
		}
	}

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.dphitcontentsmask = DPCONTENTSMASK_WEAPON;
	newmis.solid = SOLID_BBOX;
	newmis.classentity = "projectiles";
	dir = aim(self, 1000);
	rorg = self.view_ofs - '0 0 19';
	newmis.wrathflags += FL_PROJECTILE;
	if (type == 1)
	{
		flask_v_fx(0.5);
		local string tagname;
		tagname = strcat("muzzle_", ftos(forg));
		tagindex = gettagindex(self.vweapon, tagname);
		newmis.classname = "ore";
		tagorg = gettaginfo(self.vweapon, tagindex);
		sv += 0.0075 *self.slagcannonspread;
		setorigin(newmis, tagorg);
		setmodel(newmis, "models/projectiles/proj_slag1.md3");
		self.fire_time_cannon = time + 0.1;
		newmis.cnt = 1;
		newmis.think = slagdrunk;
		newmis.nextthink = time + 0.1;
		newmis.traileffectnum = particleeffectnum("slagtrail");
		newmis.velocity = normalize(cursor_trace_endpos_fixed (self) - newmis.origin) *slagspeed;
		setsizeitem(newmis, bboxslag);
		self.ammo_cannon -= 1;
	}
	else
	{
		flask_v_fx(1);
		newmis.classname = "ore2";
		tagindex = gettagindex(self.vweapon, "muzzle_4");
		tagorg = gettaginfo(self.vweapon, tagindex);
		newmis.scale = 1;
		self.fire_time_cannon = time + 0.5;
		setorigin(newmis, tagorg);
		setmodel(newmis, "models/projectiles/proj_slag2.md3");
		newmis.think = orenextframe; 
		newmis.nextthink = time + 0.1;
		newmis.traileffectnum = particleeffectnum("slagtrail2");
		//newmis.velocity = normalize(self.cursor_trace_endpos - newmis.origin) *slagspeed2;
		newmis.velocity = normalize(cursor_trace_endpos_fixed (self) - newmis.origin) *slagspeed2;
		setsizeitem(newmis, bboxslag2);
		self.ammo_cannon -= 5;
	}

	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = cannon_proj_touch;
	newmis.effects = EF_NOSHADOW;
	//self.punchangle_x = -2;
	self.vweaponframe = 3;
};

void() wfire_cannon14 = { self.vweaponframe = 15;
	if ((self.button0) && (self.ammo_cannon >= 1))
	{
		self.think = wfire_cannon;
		self.attack_finished = time + 0.25;
		self.time_fire_cannon = time + 0.25;
	}
	else
	{
		self.think = prelease_cannon;
	}
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}
	self.nextthink = time + 0.05;
};

void() wfire_cannon13 = { self.vweaponframe = 14;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon14;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon12 = {

	playerwsound("weapons/cannon/fire1_", 5, CHAN_AUTO);
	W_FireCannon(1, 3);
	self.vweaponframe = 13;
	self.think = wfire_cannon13;
	if (!self.ammo_cannon)
	{
	self.vweaponframe = 16;
	self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon11 = { self.vweaponframe = 12;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon12;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon10 = { 
	//snd = strcat("weapons/cannon/fire1_", ftos(floor(random() *5) + 1), ".ogg");
	//sound(self, CHAN_AUTO, snd, 1, ATTN_NORM);
	playerwsound("weapons/cannon/fire1_", 5, CHAN_AUTO);

	W_FireCannon(1, 2);
	self.vweaponframe = 11;
	self.think = wfire_cannon11;
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon9 = { self.vweaponframe = 10;
	if ((self.button0) && (self.ammo_cannon >= 1))
	{
		self.think = wfire_cannon10;
		self.attack_finished = time + 0.25;
		self.time_fire_cannon = time + 0.25;
	}
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}


	self.nextthink = time + 0.05;
};

void() wfire_cannon8 = { self.vweaponframe = 9;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon9;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon7 = { 

	playerwsound("weapons/cannon/fire1_", 5, CHAN_AUTO);
	W_FireCannon(1, 1);
	self.vweaponframe = 8;
	self.think = wfire_cannon8;
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon6 = { self.vweaponframe = 7;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon7;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon5 = { 

	playerwsound("weapons/cannon/fire1_", 5, CHAN_AUTO);	W_FireCannon(1, 3);
	self.vweaponframe = 6;
	self.think = wfire_cannon6;
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon4 = { self.vweaponframe = 5;
	if ((self.button0) && (self.ammo_cannon >= 1))
	{
		self.think = wfire_cannon5;
		self.attack_finished = time + 0.25;
		self.time_fire_cannon = time + 0.25;
	}
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}


	self.nextthink = time + 0.05;
};

void() wfire_cannon3 = { self.vweaponframe = 4;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon4;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon2 = { 
	playerwsound("weapons/cannon/fire1_", 5, CHAN_AUTO);
	W_FireCannon(1, 2);
	self.vweaponframe = 3;
	self.think = wfire_cannon3;

	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}


	self.nextthink = time + 0.05;
};

void() wfire_cannon1 = { self.vweaponframe = 2;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon2;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon = { if (self.ammo_cannon < 1)
		return;

	playerwsound("weapons/cannon/fire1_", 5, CHAN_AUTO);
	W_FireCannon(1, 1);
	self.vweaponframe = 1;
	self.think = wfire_cannon1;
	if (!self.ammo_cannon)
	self.think = prelease_cannon;
	self.attack_finished = time + 0.25;
	self.time_fire_cannon = time + 0.25;
	self.nextthink = time + 0.05;
};

void() wsfire_cannon1 = { self.vweaponframe += 1;
	if (self.vweaponframe >= 30)
	{
		if ((self.button3) && (self.ammo_cannon >= 5))
			self.think = wsfire_cannon;
		else
			self.think = srelease_cannon;
	}
	else
		self.think = wsfire_cannon1;
	self.nextthink = time + 0.05;
};

void() wsfire_cannon = { if (self.ammo_cannon < 5)
		return;

	playerwsound("weapons/cannon/fire2_", 5, CHAN_AUTO);
	W_FireCannon(2, 1);
	//self.ammo_cannon -= 50;
	self.vweaponframe = 21;
	self.think = wsfire_cannon1;
	self.nextthink = time + 0.05;
	self.attack_finished = time + 0.5;
	self.time_fire_cannon = time + 0.5;
};


void() pipes_think =
{

	if(self.owner.weapon != IT_CANNON)
	{
		remove(self);
		return;
	}
	if(self.owner.fire_time_cannon > time)
	{
		if(self.glowmod_x < 1) 
		{
			self.glowmod_x += 0.0125; 
			self.glowmod_z = self.glowmod_x; 
			self.glowmod_y = self.glowmod_x; 
		}
	}
	else
	{
		if(self.glowmod_x > 0.0125) 
		{
			self.glowmod_x -= 0.0125; 
			self.glowmod_z = self.glowmod_x; 
			self.glowmod_y = self.glowmod_x; 
		}
	}
	self.nextthink = time + 0.025;
};

void(entity e, entity vweapn) spawn_pipes = 
{
	if((!(wasfreed(e.pipes))) && (e.pipes.wrathflags & FL_SUBWEAPONMODEL))
	{
		remove(e.pipes);
	}


	entity epipes = spawn();
	e.pipes = epipes;
	epipes.glowmod = '0.025 0.025 0.025';
	epipes.owner = e;
	epipes.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
	setmodel(epipes, "models/weapons/cannon/v_pipes.md3");
	setattachment(epipes, vweapn, "tag_pipes");
	epipes.nextthink = time;
	epipes.think = pipes_think;

};

void() pick_up_cannon2 = 
{
 	if (time > self.attack_finished)
	{
		self.pick_up_time = time + 0.5;
		self.vweaponstate = 1;
		self.think = idle_cannon;
		self.vweaponglowmod = '1 1 1';
	}
	else
		self.think = pick_up_cannon2;
	self.nextthink = time + 0.05;
};

void() pick_up_cannon = { self.weapon = IT_CANNON;
	self.lastweapon = IT_CANNON;
	W_SetWeapon();

	sound(self, CHAN_WEAPON, "weapons/cannon/inspect.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponstate = 2;
	self.vweaponframe = 61;
	self.vweaponglowmod = '1 1 1';
	if (self.noltime < time)
		self.lspeedtime = time + 2;



	spawn_pipes (self, self.vweapon);
	self.attack_finished = time + 0.05;
	self.think = pick_up_cannon2;
	self.nextthink = time + 2.95;
};

void() raise_cannon2 = { if (self.vweaponframe == 42)
		W_SetWeapon();

	self.vweaponframe += 1;
	if (self.vweaponframe >= 50)
		self.think = idle_cannon;
	else
		self.think = raise_cannon2;
	self.nextthink = time + 0.0125;
};


void() raise_cannon = 
{ 
	self.vweaponglowmod = '1 1 1';
    self.weapon = IT_CANNON;
	W_SetWeapon();
	//sound(self, CHAN_WEAPON, "weapons/cannon/raise.ogg", 1, ATTN_NORM);
	self.vweaponglowmod = '1 1 1';
	sound(self, CHAN_AUTO, "weapons/cannon/raise.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponframe = 41;
	self.vweaponstate = 1;


	if(!(self.playerflags & FL_RESTARWEAPON))
		spawn_pipes (self, self.vweapon);

	self.attack_finished = time +  0.0125; //0.25;
	self.think = raise_cannon2;
	self.nextthink = time + 0.0125;
};

void() lower_cannon2 = { 
	self.vweaponframe += 1;
	if (self.vweaponframe == 55)
	{
		if((!(wasfreed(self.pipes))) && (self.vgear.wrathflags & FL_SUBWEAPONMODEL))
			remove(self.pipes);
	}
	if (self.vweaponframe >= 60)
		self.think = raise_weapon;
	else
		self.think = lower_cannon2;
	self.nextthink = time + 0.0125;
};

void() lower_cannon = { 
	sound(self, CHAN_AUTO, "weapons/cannon/lower.ogg", 1, ATTN_NORM);
	self.vweaponframe = 51;
	self.attack_finished = time + 0.375;
	self.think = lower_cannon2;
	self.vweaponstate = 2;
	self.nextthink = time + 0.0125;
};

///////////////////////////////////end of qc file
