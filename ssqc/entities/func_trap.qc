.float trapstate;
.float notouch;
.float speed2;
.float wait2;
.float loop;
.float damagerate;
.float forcecrouch;



void() blade_fire = 
{
vector dir =  (self.pos1 - self.pos2);
//self.velocity = normalize(dir) * self.speed;
self.velocity_z = 128;
};


void() trap_fire;
void() trap_return;
.vector partoffset;

void() func_trap_particlespawner =
{

	//vector dir = normalize (
	vector pos3;
	if(self.spawnflags & 1)
		pos3 = (((self.absmin + self.absmax) * 0.5)) + (self.pos2 * 0.5)+ (self.pos1 * -0.5);
	else
		pos3 = (((self.absmin + self.absmax) * 0.5)) + (self.pos2 * 0.5)+ (self.pos1 * -1);

	//if(self.partoffset)
		pos3 += self.partoffset;

	vector partorg = pos3;
	float partcounnt = self.count;
	while (partcounnt > 0)
	{

		if(self.movedir_x == 0)
			partorg_x = pos3_x + (random(-self.size_x* 0.5,self.size_x* 0.5));
		if(self.movedir_y == 0)
			partorg_y = pos3_y +  (random(-self.size_y * 0.5,self.size_y* 0.5));
		if(self.movedir_z == 0)
			partorg_z = pos3_z +  (random(-self.size_z* 0.5,self.size_z* 0.5));
	
		pointparticles(particleeffectnum(self.particlename), partorg, '0 0 0', 1);
		
		/*		
		entity diamond = spawn();
		setmodel(diamond,"sdfsd");
		diamond.origin = partorg;
		diamond.effects = EF_NODEPTHTEST;*/
		partcounnt -= 1;
	}

};

void() trap_wait = 
{ 
	self.state = STATE_TOP;
	self.touch = self.oldtouch;
	activator = self.enemy;
	self.usable = 0;
	self.nextthink = self.ltime + self.wait;
	if(self.classname != "damage_bbox")
		sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);

	if ((self.particlename) )
		func_trap_particlespawner();

	self.think = trap_return;
};
void() trap_wait2 = 
{ 
	self.state = STATE_BOTTOM;
	self.touch = self.oldtouch;
	activator = self.enemy;
	self.usable = 0;
	self.nextthink = self.ltime + self.wait2;
	if(self.classname != "damage_bbox")
		sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);


	self.think = trap_fire;
};
void() trap_fire;
void() trap_blocked = 
{ 
	if(other.classname == "spleetcyst")
	other.lifetime = 0;

	if (other.classname == "monster_fallen")
		other.solid = SOLID_CORPSE;
	if((other.classname == "player") && (self.forcecrouch == 1))
		other.crushingtime = time + 0.1;
	
	if(other.damagerate < time)
	{
		T_Damage(other, self, self, self.dmg);
		other.damagerate = time + self.damagerate;
	}
};


.float kill_player;
void() trap_damageblocked = 
{ 

	if(other.classname == "spleetcyst")
	other.lifetime = 0;

	if((other.classname == "player") && (self.forcecrouch == 1) && (self.damagerate > 0))
		other.crushingtime = time + 0.1;
	if(other.damagerate < time)
	{
	
		if((self.kill_player == 1)&& (other.health >0) )
		{
			other.health = -100;
			Killed(other, self, 1);
			return;
		}
		T_Damage(other, self, self, self.dmg);
		
		if(self.damagerate > 0)
			other.damagerate = time + self.damagerate;
	}
	if((other.health > 0 ) && (self.damagerate <= 0))
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			trap_return();
			return;
		}
		else
			trap_fire();
	}
};
.float alwaysdamage;
float MOVETYPE_FOLLOW = 12;
void() trap_damagetouch = 
{ 

	if(other.classname == "spleetcyst")
		other.lifetime = 0;

	if(self.alwaysdamage != 1)
		return;

	if(other.damagerate < time)
	{
	
		if((self.kill_player == 1)&& (other.health >0) )
		{
			other.health = -100;
			Killed(other, self, 1);
			return;
		}
		T_Damage(other, self, self, self.dmg);


		if(self.damagerate <= 0)
			other.damagerate = time + 0.5;

		if(self.damagerate > 0)
			other.damagerate = time + self.damagerate;
	}
	if((other.health > 0 ) && (self.damagerate <= 0))
	{		
		self.oldtouch = self.touch;
		self.touch = null;
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			trap_return();
			return;
		}
		else
			trap_fire();
	}
};

.float fake_lighted;




void() trap_done = 
{ 
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);
	//if (self.particlename)
		//func_trap_particlespawner();
	self.touch = self.oldtouch;
	self.state = STATE_BOTTOM;
	self.solid = SOLID_BSP;
};

void() trap_return = 
{
	self.state = STATE_DOWN;
	self.usable = 0;
	if(self.classname != "damage_bbox")
		sound(self, CHAN_VOICE, self.noise, self.volume, self.atten);

	if((self.using == 1) || (self.loop == 2))
		SUB_CalcMove(self.pos1, self.speed, trap_wait2);
	else
	{
		SUB_CalcMove(self.pos1, self.speed, trap_done);
		self.using = 0;
	}

};
.vector blade_offset;
.float metaltrap;

.vector fake_origin;
.string attached_model;

void() trap_fire = 
{ 

    if((self.target))
    {
        local entity t;
        t = find(world,targetname,self.target);
        if(t)
        self.pos2 = t.origin;    
    }

	if (self.state == STATE_UP || self.state == STATE_TOP)
	{
		trap_return();
		return;
	}

	if(self.classname != "damage_bbox")
	sound(self, CHAN_VOICE, self.noise, 1, self.atten);
	self.state = STATE_UP;
	self.usable = 0;
	if(self.loop != 0)
		SUB_CalcMove(self.pos2, self.speed2, trap_wait);
	else
	{	
		if(self.wait == -1)
		SUB_CalcMove(self.pos2, self.speed2, trap_done);
		else
		{
		SUB_CalcMove(self.pos2, self.speed2, trap_return);
		self.using = -1;
		}
	}
};

void() trap_postuse = 
{ 
	if(self.using == 0)
	{
		self.enemy = activator;
		trap_fire();
		self.using = 1;
	}
	if(self.using == 1)
		self.using = 0;

};


void() trap_use = 
{ 
	self.think = trap_postuse;
	self.nextthink = self.ltime + self.delay;
};

void() trap_puse = { SUB_UseTargets();
	//SUB_UseTargets2();	//targetname2 for double traps
	trap_fire();
};

void() trigger_bbox_think = 
{
	self.velocity = self.owner.velocity;
	self.think = trigger_bbox_think;
	self.nextthink = time + 0.01;

}


void() func_blade = 
{ 
	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	self.atten = attn;
	//if(self.alwaysdamage)

	precache_sound(self.noise);
	precache_sound(self.noise2);
	SetMovedir();
	self.classname = "func_trap";
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	if (!self.speed)
		self.speed = 60;
	if (!self.speed2)
		self.speed2 = 120;
	if(!self.damagerate)
	self.damagerate = 0.1;

	self.use = trap_postuse;
	if (!self.dmg)
		self.dmg = 1;
	if (!self.wait2)
		self.wait2 = 1;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 0;

	self.state = STATE_BOTTOM;
	self.trapstate = 0;
	self.pos1 = self.origin;

	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);


	if ((self.spawnflags &1) && (!self.target))
	{
		setorigin(self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	vector voffset;
	voffset_z= (self.absmax_z - self.absmin_z) / 2; 
	

	if((self.loop == 1) || ((!self.targetname)))
	{
		self.using = 1;
		self.nextthink = self.ltime + self.wait2 + self.delay;
		self.think = trap_fire;
	}	

	
	entity damagebbox = spawn();
	copyentity (self, damagebbox);
	damagebbox.solid =  SOLID_TRIGGER;
	setmodel (damagebbox,"");
	damagebbox.effects = EF_NODRAW;

	setsize(damagebbox, (self.mins + self.blade_offset), (self.maxs - self.blade_offset));
	damagebbox.classname = "damage_bbox";
	damagebbox.blocked = null;
	damagebbox.owner = self;
	damagebbox.touch = trap_damagetouch;	
	damagebbox.oldtouch = damagebbox.touch;
	damagebbox.blocked = trap_damageblocked;


};
.string atmodel;
.float density;

void() func_trap = 
{ 

	self.touch = trap_damagetouch;	
	self.oldtouch = self.touch;
	self.blocked = trap_damageblocked;

	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	
	//partoffset

	self.atten = attn;
	//if(self.alwaysdamage)

	precache_sound(self.noise);
	precache_sound(self.noise2);
	SetMovedir();
	self.classname = "func_trap";
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	if (!self.speed)
		self.speed = 60;
	if (!self.speed2)
		self.speed2 = 120;
	if(!self.damagerate)
		self.damagerate = 0.1;

	if(!self.delay)
		self.use = trap_postuse;
	else
		self.use = trap_use;
	if (!self.dmg)
		self.dmg = 1;
	if (!self.wait2)
		self.wait2 = 1;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 0;

	self.state = STATE_BOTTOM;
	self.trapstate = 0;
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);
	
	//self.partoffset = '0 0 -32';
	//self.particlename = "e3m4trap";

	if(!self.count)
		self.count = 24; 

	if (self.spawnflags &1)
	{
		setorigin(self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	if (self.keyrequired)
		self.usable = 1;
	vector voffset;
	voffset_z= (self.absmax_z - self.absmin_z) / 2; 
	if(self.fake_lighted == 1)
	{
	self.fake_origin = 0.5 *(self.absmax + self.absmin);
	self.fake_origin_z = self.absmax_z;

	spawn_lighter(self);
	}
	


	//self.minlight = 75;

	if(!(self.vminlight))
	{
		self.fake_origin = 0.5 *(self.absmax + self.absmin);
		self.fake_origin_z = self.absmax_z + 8;


		vector vlight  = getlight(self.fake_origin);	
		self.vminlight = vlight;
	}
	if(self.minlight > 0)
	{
		self.effects = EF_FULLBRIGHT;
		self.colormod_x = self.vminlight_x * (self.minlight / 100);
		self.colormod_y = self.vminlight_y * (self.minlight / 100);
		self.colormod_z = self.vminlight_z * (self.minlight / 100);
		//self.fake_lighted = 0;
	}



	if((self.loop == 1) || ((!self.targetname)))
	{
		self.using = 1;
		self.nextthink = self.ltime + self.wait2 + self.delay;
		self.think = trap_fire;
	}	
    if(self.atmodel)
    {
        precache_model(self.atmodel);
        entity attached = spawn();
        setmodel(attached, self.atmodel);
        attached.origin = self.origin;
		attached.movetype = MOVETYPE_FOLLOW; // make the hole follow
		attached.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
		attached.aiment = self; // make the hole follow bmodel
		attached.punchangle = self.angles; // the original angles of bmodel
		attached.view_ofs = attached.origin - self.origin; // relative origin
		attached.v_angle = attached.angles - self.angles; // relative angles
        
    }
};

/*- open speed
- close speed
- open delay
- close delay
- damage
- damage rate
- loop flag
- loop when triggered flag*/


void() misc_cyst_die =
{
	T_SplashDamage(self, self, self.dmg, world, self.sradius);
	aoe_spawn(self);
	pointparticles(particleeffectnum("retcher"), self.origin, '0 0 0', 1);
	CyExplosionBody();
};

void() misc_cyst_wait_die =
{
	self.takedamage = 0;
	self.think  = misc_cyst_die;

	float delaytodie;

	if(self.enemy.classname != "player")
		delaytodie = 0.5 +random() * 0.5;

	self.think = misc_cyst_die;
	self.nextthink = time + delaytodie;
};

void() misc_cyst = 
{
	if(!self.type)
		self.type = 1;
	if(!self.scale)
		self.scale = 2;
	if(!self.dmg)
		self.dmg = 16;
	if(!self.sradius)
		self.sradius = 64;

	if (self.type == 1)
		setmodel(self, "models/enemies/afflicted/cyst_a.md3");
	else if (self.type == 2)
		setmodel(self, "models/enemies/afflicted/cyst_b.md3");
	else if (self.type == 3)
		setmodel(self, "models/enemies/afflicted/cyst_c.md3");
	else if (self.type == 4)
		setmodel(self, "models/enemies/afflicted/cyst_d.md3");
	else
		setmodel(self, "models/enemies/afflicted/cyst_a.md3");



	self.solid = SOLID_BBOX;	

	if(self.health > 0)
		self.takedamage = DAMAGE_AIM;

	self.use = misc_cyst_die;

	vector sizenegative, sizepositive;
	sizepositive = '8 8 8' * self.scale;
	sizenegative = '-8 -8 -8' * self.scale;
	setsize (self,sizenegative,sizepositive);

	self.th_die = misc_cyst_wait_die;
};

void(float damage, vector dir,vector dest) TraceAttackBeam = 
{	
	local vector vel, org;
	vel = normalize(dir + v_up* crandom() + v_right* crandom());
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos;
	local float rlooplimit, dam;
	local vector dorg, orgen;
	local entity tempen;
    rlooplimit = 21;
	dorg = org - dir * 4;
	if (trace_ent.takedamage) 
	{
		while (rlooplimit > 0)
		{
			if (trace_ent.takedamage && trace_ent != world)
			{
				orgen = org + dir * 4;
				dorg = org - dir * 4;
				dam = 1;
				trace_ent.multi_damage = trace_ent.multi_damage + damage * dam;
				if (trace_ent.solid == SOLID_BSP)
					rlooplimit = 0;
			}
			else
			{
				dorg = org - dir * 4;
				rlooplimit = 0;
			}
			tempen = self;
			self = trace_ent;
			traceline(orgen, dest, FALSE, self);
			self = tempen;
			rlooplimit = rlooplimit - 1;
		}
	}
};

void() trigger_beam_active = 
{
	if((self.using == 1)&& (self.lifetime < time))
	{
		entity muzzle = spawn();
		setmodel(muzzle, "models/projectiles/proj_crystal.md3");
		muzzle.origin =  self.origin;
		muzzle.alpha = random(0.5,1);
		muzzle.colormod = '2.25 0.5 1.5';
		muzzle.scale = random (1,1.5);


		if(!(self.wait == -1))
		{
			muzzle.think = crystal_muzzle_think;
			muzzle.nextthink = time + self.duration + 0.1;
		}
		muzzle.attack_finished = time + self.duration;
		te_crystal2(self.origin,self.oldorigin, 12 * self.scale,self.duration,0.3,self.scale,world, self.oldorigin);
		self.lifetime =  time + self.wait;
		self.attack_finished = time + self.duration;

		if(self.wait == -1)
		{
			self.think = SUB_Remove;
			self.nextthink = time + self.duration;
			return;
		}

	}

	if((self.dmg > 0) && (self.using == 1) && (self.attack_finished > time))
	{
		vector direction = normalize (self.origin - self.oldorigin);
		wtraceline(self.origin, self.oldorigin, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttackBeam(self.dmg, direction,self.oldorigin );
		ApplyMultiDamage();
	}

	self.think = trigger_beam_active;
	self.nextthink = time + 0.1;
};
void() trigger_beam_ready =
{
	entity t = find(world, targetname, self.target);
	self.oldorigin = t.origin;
	self.think = trigger_beam_active;
	self.nextthink = time + 0.05;
};

void() toggle_beam_use = 
{ 
	if (self.using == 1)
		self.using = 0;
	else
		self.using = 1;

	self.think = trigger_beam_ready;
	self.nextthink = time + 0.05;

	entity t = find(world, targetname, self.target);

	if(t.classname == "info_beam")
	{
		float tdelay = self.delay;
		entity oself = self;
		self = t;
		self.think = toggle_beam_use;
		self.nextthink = time + tdelay;
		self = oself;
	}
};


void() info_beam =
{
	self.classname = "info_beam";
	if(!self.wait)
		self.wait = 1;
	if(!self.duration)
		self.duration = 0.5;
	if(!self.dmg)
		self.dmg = 10;
	if(!self.scale)
		self.scale = 1;

	if(self.using == 1)
	{
		self.think = trigger_beam_ready;
		self.nextthink = time + 0.1;
	}
	self.use = toggle_beam_use;
};

void() trigger_beam =
{
	info_beam();
};
void(entity e, float ltime, float damage) lava_aoe_spawn;
void()lava_ball_touch_small;
void() lava_ball_think =
{
	if((self.cnt != 1) && (self.velocity_z < 0)&&(self.owner.count > 1))
	{
		self.gravity = self.scale;
		float wnr_rspeed = self.owner.speed * 0.125;
		if(self.scale <= 1)
		{
			float lava_count = 3;
			while(lava_count > 0)
			{
				entity lava_ball = spawn();
				lava_ball.owner = self;
				setmodel(lava_ball, "models/projectiles/proj_slag2.md3");
				lava_ball.origin_x = self.origin_x + random (-7,7);
				lava_ball.origin_y = self.origin_y + random (-7,7);
				lava_ball.origin_z = self.origin_z + random (-7,7);
				lava_ball.solid = SOLID_TRIGGER;
				lava_ball.movetype = MOVETYPE_TOSS;
				lava_ball.owner = self.owner;
				setsize(lava_ball, '-1 -1 -1', '1 1 1');
				lava_ball.scale = random(0.1,0.25);
				lava_ball.angles = self.angles;
				lava_ball.gravity = self.gravity * random(0.85,1);	
    			lava_ball.velocity_x = self.velocity_x* random(0.85,1.15);	
				lava_ball.velocity_y = self.velocity_y * random(0.85,1.15);	
				lava_ball.velocity_z = self.velocity_z;
				lava_ball.traileffectnum = particleeffectnum("lavatrail2");
				lava_ball.touch = lava_ball_touch_small;
				lava_count --;

			}
		}

		if(self.scale == 1.25)
			self.scale = 1;
        self.velocity_x +=  random (-wnr_rspeed,wnr_rspeed);
        self.velocity_y +=  random (-wnr_rspeed,wnr_rspeed);
		self.cnt = 1;
	}
	
	//self.angles = vectoangles(self.velocity);
	vector wishangles = vectoangles(self.velocity);

	//self.angles = (self.angles  + wishangles ) * 0.5;
	self.angles = vectoangles(self.velocity);

	self.think = lava_ball_think;
	self.nextthink = time + 0.01;
};

void()lava_ball_touch= 
{
	if(other.solid ==SOLID_TRIGGER) 
		return;
	if((other.solid ==SOLID_BSP)||(other.solid == SOLID_BBOX) || (other.solid == SOLID_SLIDEBOX))
	{	
		setorigin (self,self.origin + '0 0 38');
		T_SplashDamage(self, self, 96, world, 96);
		pointparticles(particleeffectnum("oppressor_gib"), self.origin, '0 0 0', 1);		
		lava_aoe_spawn(self, max(0.1, self.owner.lifetime), self.dmg);
		self.touch = SUB_Null;
		self.effects = EF_NODRAW;
		sound7(self,CHAN_AUTO,"impact/projectiles/slag2_explo2.ogg",0.5,0.25,random(200,270),0);
		self.think = SUB_Remove;
		self.nextthink = time + 5;
	}
};
void()lava_ball_touch_small =
{
	if(other.solid ==SOLID_TRIGGER) 
		return;
	if((other.solid ==SOLID_BSP)||(other.solid == SOLID_BBOX) || (other.solid == SOLID_SLIDEBOX))
	{	
		self.touch = SUB_Null;
		sound7(self,CHAN_AUTO,"impact/projectiles/slag2_explo2.ogg",0.25,0.25,random(370,500),0);
		pointparticles(particleeffectnum("oppressor_small_gib"), self.origin, '0 0 0', 1);
		float r = random();
		self.velocity  = '0 0 0';
		self.solid = 0;
		self.movetype = 0;
		if(r < 0.25)
		{
			setmodel(self,"");
			self.effects = EF_FLAME;
			float ball_duration = self.owner.lifetime * 0.85;
			self.nextthink = time + random(ball_duration * 0.5,ball_duration);
		}
		else
			self.nextthink = time;

		T_SplashDamage(self, self, 32, world, 64);
		self.think = SUB_Remove;
	}

};

entity(vector org) spawn_lava_ball = // Reki (October 12 2023): Repurposed this unused function for boss3 and general purpose lava ball spawning
{
	entity lava_ball = spawn();
	setmodel(lava_ball, "models/projectiles/proj_slag2.md3");
	
	lava_ball.origin = org;
	lava_ball.solid = SOLID_TRIGGER;
	lava_ball.movetype = MOVETYPE_TOSS;
	lava_ball.scale = random(0.75,1);
	lava_ball.gravity = 0.75;

	lava_ball.touch = lava_ball_touch;
	lava_ball.velocity = '0 0 510';
	lava_ball.velocity += [random(-70, 70), random(-70, 70), random(-30, 120)];

	setsize(lava_ball, '-2 -2 -2', '2 2 2');
	lava_ball.angles = vectoangles(lava_ball.velocity);
	lava_ball.traileffectnum = particleeffectnum("lavatrail");
	lava_ball.effects = 1024;

	lava_ball.cnt = 1;
	lava_ball.oldcnt = 1;

	lava_ball.think = lava_ball_think;
	lava_ball.nextthink = time;

	return lava_ball;
};

void() lava_trap_think =
{
	if(self.using == 1)
	{
		float lava_count = self.count;
		while(lava_count > 0)
		{
			vector anglesyrandom;
			anglesyrandom_y = self.angles_y;
			makevectors (anglesyrandom);
			self.velocity = v_forward * self.speed;
			self.velocity_z += self.height;

			entity lava_ball = spawn();
			lava_ball.owner = self;
			setmodel(lava_ball, "models/projectiles/proj_slag2.md3");
			
			lava_ball.origin = self.origin + '0 0 32';	
			lava_ball.origin_x += random(self.originjitter_x *-1, self.originjitter_x);
			lava_ball.origin_y += random(self.originjitter_y *-1, self.originjitter_y);
			lava_ball.origin_z += random(self.originjitter_z *-1, self.originjitter_z);
			lava_ball.solid = SOLID_TRIGGER;
			lava_ball.movetype = MOVETYPE_TOSS;
			if(lava_count == self.count)
				lava_ball.scale = 1.25;
			else
				lava_ball.scale = random(0.75,1);
			lava_ball.gravity = 0.75;	

			if(lava_count == self.count)
				lava_ball.touch = lava_ball_touch;
			else
				lava_ball.touch = lava_ball_touch_small;
			lava_ball.velocity_x = self.velocity_x;	
			lava_ball.velocity_y = self.velocity_y;	
			lava_ball.velocity_z = self.velocity_z;
			lava_ball.velocity_x += random(self.velocityjitter_x * -1,self.velocityjitter_x);
			lava_ball.velocity_y += random(self.velocityjitter_y * -1,self.velocityjitter_y);
			lava_ball.velocity_z += random(self.velocityjitter_z * -1,self.velocityjitter_z);

			setsize(lava_ball, '-2 -2 -2', '2 2 2');
			lava_ball.angles = vectoangles(lava_ball.velocity);
			lava_ball.traileffectnum = particleeffectnum("lavatrail");
			lava_ball.effects = 1024;
			lava_ball.think = lava_ball_think;
			lava_ball.nextthink = time;
			lava_count --;

		}
		self.think = lava_trap_think;
		self.nextthink = time + self.wait + random() * self.delay;
	}
	else
	{
		self.think = lava_trap_think;
		self.nextthink = time + 0.1;
	}
};

void() lava_trap_prethink =
{

	self.think = lava_trap_think;
	self.nextthink = time;
}
void() lava_trap =
{
	if(!self.using)
		self.using = 1;
	if(!self.wait)
		self.wait = 3;
	if(!self.count)
		self.count = 3;
	if(!self.cnt)
		self.cnt = 3;
	if(!self.lifetime)
		self.lifetime = 4;

		self.lifetime = self.lifetime / 2;
	if(!self.dmg)
		self.dmg = 25;

	if(!self.delay)
		self.delay = 2;
	if(!self.speed)
		self.speed = 256;
	if(!self.height)
		self.height = 512;

	self.angles_x = 0;
	self.angles_z = 0;

	self.use = toggle_use;
	self.think = lava_trap_prethink;
	self.nextthink = time;
};


void() trap_lava =
{
	lava_trap();
};
///////////////////////////////////end of qc file
