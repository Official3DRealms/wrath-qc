void(vector org, float class) blood_decal;
.vector corpse_angles;

vector(vector rvel, entity ent) relvel = 
{ 
	local vector revel;
	makevectors(ent.angles + ent.corpse_angles);
	revel = v_forward *rvel_x + v_right *rvel_y + v_up * rvel_z;

	if(self.classentity == "deadurn")
	{
		float dhm = (self.health / 250) * -1;
		if(dhm >= 20) 
			dhm = 20;
		vector extravel = revel * dhm;
		extravel_z += (dhm * 75) ; 
	}

	return revel + extravel;
};

vector(vector rvel, entity ent, float multiplier) relvel2 = 
{ 
	local vector revel;
	makevectors(ent.angles + ent.corpse_angles);
	revel = v_forward *rvel_x + v_right *rvel_y + v_up * rvel_z;
	revel_x = revel_x * multiplier;
	revel_y = revel_y * multiplier;
	revel_z = revel_z * multiplier;
	return revel;
};


vector(float svel) VelocityForDamage2 = { local float r;
	local vector v;
	r = random();

	if (r > 0.5)
	{
		v_x = svel* crandom2();
		v_y = svel* crandom();
	}
	else
	{
		v_x = svel* crandom();
		v_y = svel* crandom2();
	}
	v_z = svel *0.75* random();
	return v;
};
vector(float dm) VelocityForDamage = { local vector v;
	v_x = 100* crandom();
	v_y = 100* crandom();
	v_z = 200 + 100* random();
	if (dm > -50)
		v = v *0.7;
	else if (dm > -200)
		v = v * 2;
	else
		v = v * 10;
	return v;
};
void() galphafade2 = { if (self.wrathflags &FL_TOSS)
		move_gibs();

	self.think = SUB_Remove;
	self.nextthink = time;
};

void() galphafade = { self.alpha = self.alpha - 0.1;
	if (self.wrathflags &FL_TOSS)
		move_gibs();

	if (self.alpha < 0)
		self.think = SUB_Remove;
	else
		self.think = galphafade;
	self.nextthink = time + 0.1;
};


void() gibalphafade = { self.solid = SOLID_NOT;
	self.traileffectnum = 0;
	local float nparticles;
	nparticles = particleeffectnum("wraith_gib2");
	pointparticles(nparticles, self.origin, '0 0 0', 1);
	self.nextthink = time + 0.01;
	if (self.movetype != MOVETYPE_NOCLIP)
		self.movetype = MOVETYPE_NOCLIP;
	if (self.wrathflags &FL_TOSS)
		move_gibs();
	if (self.velocity_z <= 0)
		self.velocity_z = -5;
	self.think = galphafade;
};

void() gibalphafade2 = { if (self.movetype != MOVETYPE_NOCLIP)
		self.movetype = MOVETYPE_NOCLIP;
	if (self.wrathflags &FL_TOSS)
		move_gibs();
	if (self.velocity_z >= 0)
		self.velocity_z = -5;
	self.nextthink = time + 2;
	self.think = SUB_Remove;
};

void() gibalphafade3 = { self.glowmod_x -= 0.075;
	self.glowmod_y -= 0.075;
	self.glowmod_z -= 0.075;

	if ((self.glowmod_x < 0.5) && (self.flags &FL_ONGROUND))
	{

		if ((self.glowmod_x < -2.5) && (self.velocity_z >= 0))

			self.velocity_z = -5;
		if (self.movetype != MOVETYPE_NOCLIP)
			self.movetype = MOVETYPE_NOCLIP;
	}
	if (self.wrathflags &FL_TOSS)
		move_gibs();
	if (self.glowmod_x < -5)
		self.think = SUB_Remove;
	else
		self.think = gibalphafade3;
	self.nextthink = time + 0.05;
};

void() gibalphafade4 = 
{ 
	self.movetype = MOVETYPE_NOCLIP;
	if(!self.alphatime)
	self.alphatime = 1;
	if (!self.alpha)
		self.alpha = 1;
	self.avelocity = '0 0 0';
	self.velocity ='0 0 -5';
	self.nextthink = time + 0.01;
	self.think = alphafade2;
};
.float gibbing;

.float timing_toalpha;
.float time_toalpha;
.float aboveworld;
.float glowmod_decrease;

void() gib_glowmod_controller_think =
{
	if ((self.owner.glowmod_x < 0.01) || (!(self.owner.wrathflags & FL_GIB)))
	{
		if(self.owner.wrathflags & FL_GIB)
		self.owner.glowmod = '-1 -1 -1';
		remove(self);
		return;
	}
	else
	{
		if(self.owner.wrathflags & FL_GIB)
		{
			self.owner.glowmod_x -= 0.0375;
			self.owner.glowmod_y -= 0.0375;
			self.owner.glowmod_z -= 0.0375;
		}
	}
	self.think = gib_glowmod_controller_think;
	self.nextthink = time + 0.05;
};

void(entity e) gib_glowmod_controller =
{
	entity gmcontroller = spawn();
	gmcontroller.owner = e;
	gmcontroller.think = gib_glowmod_controller_think;
	gmcontroller.nextthink = time;
};
.float gibsize;
.float added_extra_lifetime;



void() gib_world_touch =
{

		return;
	
};
void() checking_ground = 
{ 
	if(!(self.wrathflags & FL_GIB))
		self.wrathflags += FL_GIB;

	if(!(self.wrathflags & FL_GARBAGE))
		self.wrathflags += FL_GARBAGE;
	if (self.flags &FL_ONGROUND) 
		self.traileffectnum = 0;

	if(self.added_extra_lifetime != 1)
	{
		self.added_extra_lifetime = 1;
		if((self.lifetime < time) || (!(self.lifetime)))
		{
			float gibextraduration = cvar("gib_extratime");
			self.lifetime = time + random(10,25) + gibextraduration;
		}
	}
	self.frame = 1;
	if ((self.flags &FL_ONGROUND) && (self.groundentity == world))
	{
		self.aboveworld = 1;
	}
	if (!self.aboveworld)
		move_gibs();

	if((self.movetype == MOVETYPE_FLY) && (self.wrathflags & FL_PUSHEDGIB))
	{
		self.velocity_z = random()*-10 -5 ; //splat slowly slides down walls, changing speed
		//if(!(self.flags &FL_ONGROUND))
		if(self.oldorigin == self.origin)
		{
			self.movetype = MOVETYPE_BOUNCE;
			self.velocity_z += random(64,92); 
			if(self.wrathflags & FL_PUSHEDGIB)
				self.wrathflags -= FL_PUSHEDGIB;
		}
		else
		{

			float r = random();
			if(r < 0.1)
				pointparticles(particleeffectnum("bloodtrailwall"),self.origin, '0 0 0', 1);
			float touchingwolrd = 0;
			vector dir ='0 0 0';
			vector decalorg;

			traceline(self.origin, self.origin + '8 0 0', 3, self);
			if (trace_fraction != 1.0)
				{touchingwolrd ++; dir = normalize(trace_plane_normal) * random(32,72); decalorg = trace_endpos;}

			traceline(self.origin, self.origin + '-8 0 0', 3, self);
			if (trace_fraction != 1.0)
				{touchingwolrd ++; dir = normalize(trace_plane_normal) * random(32,72); decalorg = trace_endpos;}

			traceline(self.origin, self.origin + '0 8 0', 3, self);
			if (trace_fraction != 1.0)
				{touchingwolrd ++; dir = normalize(trace_plane_normal) * random(32,72); decalorg = trace_endpos;}

			traceline(self.origin, self.origin + '0 -8 0', 3, self);
			if (trace_fraction != 1.0)
				{touchingwolrd ++; dir = normalize(trace_plane_normal) * random(32,72); decalorg = trace_endpos;}

			if(touchingwolrd != 0)
				 self.lvweapon = dir;

			if(touchingwolrd == 0)
			{
				self.movetype = MOVETYPE_BOUNCE;
				self.velocity = self.lvweapon;
				self.velocity_z += random(64,92); 
				if(self.wrathflags & FL_PUSHEDGIB)
					self.wrathflags -= FL_PUSHEDGIB;
			}	
			else
			{
				if(time > self.attack_finished)
				{blood_decal(decalorg, 10);self.attack_finished = time + random(2,3);}
			}
		
		}

	}

	if ((self.velocity == '0 0 0') && (self.flags &FL_ONGROUND) && (self.gibbing == 1))
	{

		if(self.fakewatertype == CONTENT_LAVA)
			pointparticles(particleeffectnum("oppressor_small_gib"), self.origin, '0 0 0', 1);		
		else
			blood_decal(self.origin, 9);

		self.gibbing = 2;
	}
	if ((self.glowmod_x < 0.01))
	{
		self.glowmod_decrease = 1;
		self.glowmod = '-1 -1 -1';
		if (!(self.timing_toalpha))
		{
			self.time_toalpha = time + 10 + (random() *10);
			self.timing_toalpha = 1;
		}
	}
	if (((time > self.time_toalpha) && (self.glowmod_decrease == 1)) || (self.lifetime < time))
		self.think = gibalphafade;
	else
		self.think = checking_ground;
	self.oldgroundentity = self.groundentity;

	self.oldorigin = self.origin;
	self.nextthink = time + 0.05;
};


.float gib_jumping;
.float oldtraileffectnum;
.float liquidtouch_timing;
float magnetic_time;

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void() gib_touch = { local vector v;
	self.gravity = 1;

	if(self.effects & EF_FLAME)
		self.effects -= EF_FLAME;
	if((magnetic_time > time) && (other.solid == SOLID_BSP))
	{
		float rm = random();
		if(rm < 0.3)	
		{
			if(self.fakewatertype == CONTENT_LAVA)
				pointparticles(particleeffectnum("oppressor_small_gib"), self.origin, '0 0 0', 1);		
			else
				pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);		
		}		
		remove(self);
	}
	if (other.flags &FL_MONSTER)
		return;
	if (time < self.touchtime)
		return;

	if((other == world) && (!(other.flags & FL_ONGROUND)) &&(self.wrathflags & FL_PUSHEDGIB) && (self.count != 3))
	{
        self.velocity = '0 0 0';
        self.avelocity = '0 0 0';
        self.movetype = MOVETYPE_FLY;
		self.touch = gib_world_touch;
		//self.traileffectnum = particleeffectnum("bloodtrailwall");
	}
	if (other.classname == "player")
	{
		if ((self.count == 3))
		{

			//self.traileffectnum = self.oldtraileffectnum;
			v_x = (other.velocity_x *1.75 + 30* random());
			v_y = (other.velocity_y *1.75 + 30* random());

			if(self.liquidtouch_timing < time)
			v_z = 95 + 90* random() + (other.velocity_y + other.velocity_x) *0.30;
			else
			self.gravity = 0;

			self.traileffectnum = self.traileffectnum2;

			if(self.flags &FL_ONGROUND)
				self.flags -= FL_ONGROUND;

			self.angles_y = random() *360;
			if(self.liquidtouch_timing < time)
				self.avelocity_y = v_y * 2;
			else
				self.avelocity_y = v_y * random() * 0.25;

			if(self.liquidtouch_timing < time)
			self.velocity = v;
			else
			{
				self.velocity_x = v_x * random() * 3;
				self.velocity_x = v_x* random() * 3;
			}

			self.gib_jumping = 1;
			local string gsound, r;
			r = ftos(floor(random() *2) + 1);
			gsound = strcat("impact/gibs/gib_splat", r, ".ogg");
			pointsound(self.origin, gsound, 1, ATTN_NORM);
			self.touchtime = time + 0.5 + random();
			
			// Reki (July 17 2023): achievement logic
			Steam_StatIncrement(other, ST_STATS::heads_kicked, 1);
		}

		
		
		return;
	}
	if (self.gibbing < 1)
	{
		self.gibbing = 1;
		if(self.fakewatertype == CONTENT_LAVA)
			pointparticles(particleeffectnum("oppressor_small_gib"), self.origin, '0 0 0', 1);		
		else
			blood_decal(self.origin, 9);
	}
};

void()wrethc_explode_head;
void() gib_touch2 = { 

local vector v;

	if((magnetic_time > time) && (other.solid == SOLID_BSP))
		remove(self);

	self.gravity = wretch_shg;
	if (other.flags &FL_MONSTER)
	{
	self.think = wrethc_explode_head;	
	self.nextthink = time;
	return;
	}
	if (time < self.touchtime)
		return;
		
		
	if (other.classname == "player")
	{
			//self.traileffectnum = self.oldtraileffectnum;
			self.touchtime = time + 0.25;
			if(self.flags &FL_ONGROUND)
			self.flags -= FL_ONGROUND;
			v_x = (other.velocity_x *1.5 +wretch_shkv_x + 50* random());
			v_y = (other.velocity_y *1.5 +wretch_shkv_y  + 50* random());
			v_z = wretch_shkv_z + wretch_shkv_z* random() + (other.velocity_y + other.velocity_x) *0.5;
			self.velocity = v;
			self.movetype = MOVETYPE_BOUNCE;
			self.gib_jumping = 1;
			local string gsound, r;
			r = ftos(floor(random() *2) + 1);
			gsound = strcat("impact/gibs/gib_splat", r, ".ogg");
			pointsound(self.origin, gsound, 1, ATTN_NORM);
	}
};
.entity gibowner;
void(string gibname, float dm, float gravitygib, float bstop, float scalegib) ThrowGib = { local entity new;
	new = spawn();
	new.origin = self.origin;
	new.angles = self.angles;
    new.gibowner = self;
	new.lavatime = self.firetime;
	setmodel(new, gibname);
	setsize(new, '0 0 0', '0 0 0');
	new.wrathflags += FL_GIB;

	new.velocity = VelocityForDamage(dm);

	if(magnetic_time > time)
	new.movetype = MOVETYPE_TOSS;

	if (bstop == 0)
		new.movetype = MOVETYPE_TOSS;
	else
		new.movetype = MOVETYPE_BOUNCE;
	new.bouncefactor = 0.5;
	new.bouncestop = bstop;
	new.solid = SOLID_TRIGGER;
	new.touch = gib_touch;
	new.gravity = gravitygib;
	new.scale = scalegib;
	float gibextraduration = cvar("gib_extratime");
	new.lifetime = time + random(10,25) + gibextraduration;
	new.wrathflags = new.wrathflags + FL_TOSS;
	new.think = checking_ground;
	new.ltime = time;
	new.wrathflags += FL_GARBAGE;
	new.nextthink = time + 1;
	new.frame = 0;
	new.flags = 0;
};

void() gib_water_touch =
{
	if(other.classname !=  "player")
		return;
	self.velocity_x = other.velocity_x * random(1,3); 
	self.velocity_y = other.velocity_y * random(1,3); 
};
void() checking_water = 
{
	if(self.lifetime < time)
		self.think = gibalphafade;
	if(self.liquidtouch_timing > time)
	{
		self.gravity = 0.25;

		self.velocity_x = self.velocity_x * 0.95;
		self.velocity_y = self.velocity_y * 0.95;
		self.velocity_z = self.velocity_z * 0.7;
		
		self.avelocity_x = self.avelocity_x * 0.95;
		self.avelocity_y = self.avelocity_y * 0.95;
		self.avelocity_z = self.avelocity_z * 0.95;
		if(self.movetype != MOVETYPE_FLY)
			self.movetype = MOVETYPE_FLY;
		
	}
	else
	{
		if(self.movetype != MOVETYPE_TOSS)
		{
			self.movetype = MOVETYPE_TOSS;
			self.gravity = 1;
			self.velocity_z = -120;	

		}
	}
	self.touch = gib_water_touch;

	self.nextthink = time + 0.05;	
	self.think = checking_water;
};

void(string gibname, float dm, float gravitygib, float bstop, float scalegib, vector orn, vector rvel, float xangonground, float kickable) ThrowGib2 = 
{ 
	local entity new;
	new = spawn();
	new.origin = orn;
    new.gibowner = self;
	new.angles = self.angles;
	new.lavatime = self.firetime;
	setmodel(new, gibname);



	setsize(new, '0 0 0', '0 0 0');
	new.wrathflags += FL_GARBAGE;
	new.avelocity_y = random() *new.velocity_y *5 + new.velocity_y* crandom();
	new.wrathflags = new.wrathflags + FL_TOSS;
	new.wrathflags += FL_GIB;

	if ((self.classname == "monster_fallen") || (self.classname == "invader"))
	{
		new.velocity_x = rvel_x * 1;
		new.velocity_y = rvel_y * 1;
		new.velocity_z = rvel_z * 1;
	}
	else
	{
		new.velocity_x = rvel_x *(0.75 + (random() *0.5));
		new.velocity_y = rvel_y *(0.75 + (random() *0.55));
		new.velocity_z = rvel_z *(0.75 + (random() *0.35));
	}

	if ((self.enemy.classname == "player") && (self.lungetime > time))
	{
		makevectors(self.enemy.v_angle);
		new.velocity_x = new.velocity_x *0.25;
		new.velocity_y = new.velocity_y *0.25;
		new.velocity_z = new.velocity_z *1.25;

		new.velocity += self.enemy.velocity *0.5;
	}
	if (self.classname == "monster_afflicted")
	{
		new.traileffectnum = particleeffectnum("retchertrail");
		new.traileffectnum2 = particleeffectnum("retchertrail2");
	}
	else if (self.classname == "monster_wraith")
	{
		new.traileffectnum = particleeffectnum("wraithtrailgib");
		new.traileffectnum2 = particleeffectnum("wraithtrailgib2");
	}
	else
	{
		new.traileffectnum = particleeffectnum("generictrailgib");
		new.traileffectnum2 = particleeffectnum("generictrailgib2");
	}
	if (bstop == 1)
		new.movetype = MOVETYPE_BOUNCE;
	else
		new.movetype = MOVETYPE_TOSS;


	if(magnetic_time > time)
	new.movetype = MOVETYPE_TOSS;


	new.alpha = 1;	//3 + random() *2;	
	new.bouncefactor = 0.5;
	new.glowmod = '1.5 1.5 1.5';
	if (kickable == 1)
		new.solid = SOLID_TRIGGER;
	else
		new.solid = SOLID_CORPSE;
	new.touch = gib_touch;
	new.gravity = gravitygib;
	new.cnt = xangonground;
	if (kickable >= 1) new.count = 3;
	if (new.count >= 3)
		new.touchtime = time + 0.5 + random();
	new.scale = scalegib;



	if(gravitygib > 0.25)
		new.think = checking_ground;	
	else
		new.think = checking_water;
	gib_glowmod_controller(new);
	new.ltime = time;
	float gibextraduration = cvar("gib_extratime");
	new.lifetime = time + random(10,25) + gibextraduration;
	new.nextthink = time + 0.1;
	new.frame = 0;
	new.flags = 0;
	new.oldtraileffectnum = new.traileffectnum;
};
void()wretch_spining_head;
float wretch_sht;
void(entity ownr, string gibname, float dm, float gravitygib, float bstop, float scalegib, vector orn, vector rvel, float xangonground, float kickable) ThrowGib3 = { local entity new;
	new = spawn();
	new.origin = orn;
	
	new.angles = ownr.angles + ownr.corpse_angles;
    new.gibowner = self;
	new.lavatime = self.firetime;

	setmodel(new, gibname);
	setsize(new, '0 0 0', '0 0 0');
	new.wrathflags += FL_GARBAGE;
	if (!xangonground)
		new.avelocity = crandom() *'0 350 0';
	new.wrathflags = new.wrathflags + FL_TOSS;

	if (ownr.classname == "monster_oppressor")
    {
        rvel_x = rvel_x * 1.5;
        rvel_y = rvel_y * 1.5;
        rvel_z = rvel_z * 1.5;
    }
	new.velocity_x = rvel_x *(0.75 + (random() *0.5));
	new.velocity_y = rvel_y *(0.75 + (random() *0.55));
	new.velocity_z = rvel_z *(0.75 + (random() *0.35));


	if (self.classname == "monster_afflicted")
	{
		new.traileffectnum = particleeffectnum("retchertrail");
		new.traileffectnum2 = particleeffectnum("retchertrail2");
	}
	else if (self.classname == "monster_wraith")
	{
		new.traileffectnum = particleeffectnum("wraithtrailgib");
		new.traileffectnum2 = particleeffectnum("wraithtrailgib2");
	}
	else if (ownr.classname == "monster_oppressor")
		new.traileffectnum = particleeffectnum("null");
	else
	{
		new.traileffectnum = particleeffectnum("generictrailgib");
		new.traileffectnum2 = particleeffectnum("generictrailgib2");
	}

	if (bstop == 1)
		new.movetype = MOVETYPE_BOUNCE;
	else
		new.movetype = MOVETYPE_TOSS;

	if (ownr.classname == "monster_oppressor")
	{
		new.fakewatertype = CONTENT_LAVA; // just to spawn "lava" decals instead blood decals
		float r = random();
		setsize(self, '-8 -8 -8', '8 8 8');
		if(r > 0.33)
			new.effects += EF_FLAME;
	}
	if(magnetic_time > time)
	new.movetype = MOVETYPE_TOSS;

	new.alpha = 1;	//3 + random() *2;	
	new.bouncefactor = 0.5;
	//new.bouncestop = 0.5;
	new.glowmod = '1.5 1.5 1.5';
	if ((kickable == 1)||(kickable == 4))
		new.solid = SOLID_TRIGGER;
	else
		new.solid = SOLID_CORPSE;

	new.touch = gib_touch;
	new.wrathflags += FL_GIB;

	new.gravity = gravitygib;
	if (kickable >= 1) new.count = 3;
	if (new.count >= 3)
		new.touchtime = time + 0.5 + random();
	new.scale = scalegib;
	if(gravitygib > 0.25)
	{
		new.think = checking_ground;
		gib_glowmod_controller(new);
	}
	else
	{
		new.think = checking_water;
		new.classname = "watergib";
	}
	new.ltime = time;
	float gibextraduration = cvar("gib_extratime");
	new.lifetime = time + random(10,25) + gibextraduration;
	if ((ownr.classname == "monster_wretch") && (kickable ==4))
	{
		setsize(self, '-8 -8 -8', '8 8 8');
		new.bouncefactor = 0;
		new.touch = gib_touch2;
		new.time2 = time + 1; // timing for nextthink alternative
		new.lifetime = time + wretch_sht;
		new.solid = SOLID_TRIGGER;
		new.movetype = MOVETYPE_BOUNCE;
		new.think = wretch_spining_head;
	}
	new.nextthink = time;
	new.frame = 0;
	new.flags = 0;
	new.oldtraileffectnum = new.traileffectnum;
};

void() projectile_touch_str2;
void()CheckCysStricken;
void(entity ownr, float dm, vector orn, vector rvel) ThrowGibCyst = 
{ 
	local entity new;
	new = spawn();
	new.origin = orn;
	new.owner = ownr;
	new.lavatime = self.firetime;
	new.angles = ownr.angles;
	setmodel(new, "models/projectiles/proj_cyst.md3");
	setsize(new, '0 0 0', '0 0 0');
	new.wrathflags += FL_GARBAGE + FL_GIB + FL_PROJECTILE;
	new.avelocity = crandom() *'0 350 0';
	new.wrathflags = new.wrathflags + FL_TOSS;

	new.velocity_x = rvel_x *(0.75 + (random() *0.5));
	new.velocity_y = rvel_y *(0.75 + (random() *0.55));
	new.velocity_z = rvel_z *(0.75 + (random() *0.35));

	new.traileffectnum = particleeffectnum("stricken_cyst_trail");
	new.movetype = MOVETYPE_BOUNCE;

	if(magnetic_time > time)
		new.movetype = MOVETYPE_TOSS;


	new.alpha = 1;
	new.bouncefactor = 0.5;
	new.glowmod = '1.5 1.5 1.5';
	new.solid = SOLID_CORPSE;
	new.touch = projectile_touch_str2;
	new.gravity = 0.75;
	new.count = 3;
	new.touchtime = time + 0.5 + random();
	new.lifetime = time + 5;
	new.ltime = time;
	new.oldtraileffectnum = new.traileffectnum;
	new.think = SUB_Null;
	new.nextthink = time;
};

void(string gibname, float dm) ThrowHead = { setmodel(self, gibname);
	self.frame = 0;
	self.wrathflags = self.wrathflags + FL_TOSS;
	self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE;
	if(magnetic_time > time)
	self.movetype = MOVETYPE_TOSS;

	self.wrathflags += FL_GARBAGE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER;
	self.touch = gib_touch;
	self.view_ofs = '0 0 8';
	setsize(self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage(dm);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags &FL_ONGROUND);
	self.avelocity = crandom() *'0 600 0';
};

void(entity monster) remove_monster = { monster.effects = EF_NODRAW;
	monster.solid = SOLID_NOT;
	monster.velocity = 0;
	monster.wrathflags += FL_GARBAGE;
	monster.movetype = 0;
	monster.think = SUB_Remove;
	monster.nextthink = time + 5;

};
void() bleedthink2 = { local entity e;
	e = self.owner;
	if (self.owner.health < 0)
	{
		remove(self);
		return;
	}
	local float nparticles;
	nparticles = particleeffectnum(self.particleffect);

	local vector tagorg, dir;
	local float tagindex;
	local string tagname;

	tagname = self.tagorg2;
	tagindex = gettagindex(self.owner, tagname);
	tagorg = gettaginfo(self.owner, tagindex);

	pointparticles(nparticles, tagorg, dir, 1);
	self.nextthink = time + 0.05;
	self.think = bleedthink2;
}

void(entity ownr, string nameffect, string tagname) bleeding_point = { local entity bleed;
	bleed = spawn();
	bleed.wrathflags += FL_GARBAGE;
	bleed.owner = self;
	bleed.particleffect = nameffect;
	setmodel(bleed, "models/misc/null.md3");
	bleed.effects = EF_NODRAW;
	bleed.tagorg2 = tagname;
	setattachment(bleed, ownr, tagname);
	bleed.think = bleedthink2;
	bleed.nextthink = time;
};

void() blood_explode10 = { self.skin += 1;self.think = SUB_Remove;self.nextthink = time + 0.05;
};
void() blood_explode9 = { self.skin += 1;self.think = blood_explode10;self.nextthink = time + 0.05;
};
void() blood_explode8 = { self.skin += 1;self.think = blood_explode9;self.nextthink = time + 0.05;
};
void() blood_explode7 = { self.skin += 1;self.think = blood_explode8;self.nextthink = time + 0.05;
};
void() blood_explode6 = { self.skin += 1;self.think = blood_explode7;self.nextthink = time + 0.05;
};
void() blood_explode5 = { self.skin += 1;self.think = blood_explode6;self.nextthink = time + 0.05;
};
void() blood_explode4 = { self.skin += 1;self.think = blood_explode5;self.nextthink = time + 0.05;
};
void() blood_explode3 = { self.skin += 1;self.think = blood_explode4;self.nextthink = time + 0.05;
};
void() blood_explode2 = { self.skin += 1;self.think = blood_explode3;self.nextthink = time + 0.05;
};
void() blood_explode1 = { self.skin += 0;self.think = blood_explode2;self.nextthink = time + 0.05;
};

void() explo_model = { self.frame += 1;
	self.alpha -= 0.1;

	if (self.frame < 10)
		self.think = explo_model;
	else
		self.think = SUB_Remove;

	self.nextthink = time + 0.05;
};
float magnetic_time;
void(float type, vector org) explo_blood = { 


	if(magnetic_time > time)
	return;
	local entity giblood;
	local float skinn;
	giblood = spawn();
	giblood.origin = org;
	giblood.cnt = type;
	skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	giblood.skin = skinn * 10;
	if (type == 1)
		setmodel(giblood, "particles/explo/explo_blood1.md3");
	else if (type == 2)
		setmodel(giblood, "particles/explo/explo_blood2.md3");
	else if (type == 3)
		setmodel(giblood, "particles/explo/explo_blood2.md3");
	else if (type == 4)
	{
		setmodel(giblood, "particles/explo/explo_blood3.md3");
		giblood.scale = 2;
	}
	else if (type == 5)
	{
		setmodel(giblood, "particles/explo/explo_blood2.md3");
		giblood.scale = 2;
	}
	else if (type == 6)
	{
		setmodel(giblood, "particles/explo/explo_stricken.md3");
		giblood.scale = 1;
		giblood.alpha = 1;
		giblood.skin = 0;
	}
	else if (type == 7)
	{
		setmodel(giblood, "particles/explo/explo_heretic.md3");
		giblood.scale = 1;
		giblood.alpha = 1;
		giblood.skin = 0;
	}
	else if (type == 8)
	{
		setmodel(giblood, "particles/explo/explo_afflicted.md3");
		giblood.scale = 1;
		giblood.alpha = 1;
		giblood.skin = 0;
	}
	else if (type == 9)
	{
		setmodel(giblood, "particles/explo/explo_invader.md3");
		giblood.scale = 1;
		giblood.alpha = 1;
		giblood.skin = 0;
	}
	else if (type == 10)
	{
		setmodel(giblood, "particles/explo/explo_wretch.md3");
		giblood.scale = 1;
		giblood.alpha = 1;
		giblood.frame = -1;// hack
		giblood.skin = 0;
	}	
	else if (type == 11)
	{
		setmodel(giblood, "particles/explo/explo_wretch_head.md3");
		giblood.scale = 1;
		giblood.alpha = 1;
		giblood.frame = -1;// hack
		giblood.skin = 0;
	}	
	else if (type == 20)
	{
		setmodel(giblood, "particles/explo/explo_blood2.md3");
		giblood.scale = 0.5;
	}
	else
		setmodel(giblood, "particles/explo/explo_blood3.md3");
	//if(self.classname == "monster_invader")		
	if ((giblood.cnt == 6) || (giblood.cnt == 7) || (giblood.cnt == 8) || (giblood.cnt == 9) || (giblood.cnt == 10) || (giblood.cnt == 11))
		giblood.think = explo_model;
	else
		giblood.think = blood_explode1;
	giblood.nextthink = time;
}
void(vector org,string locsound, float rnd, float vol, float sspeed) randompointsound7;
void(float type, vector org) explo_blood_sprite = 
{ 
	if(magnetic_time > time)
	    return;

	if (type == 8) // particles instead, for shield deflection
	{
		static float shield_dlight_time;
		pointparticles(particleeffectnum("forcefieldboss2"), org, '0 0 0', 1);

		if (time > shield_dlight_time)
		{
			shield_dlight_time = time + 0.05;
			te_customflash(org, 92, 1, '0.9 0 0.75');
		}

		string string_sound = "impact/projectiles/trinket_med.ogg";
		local entity locsound = spawn();
		locsound.origin = org;
		sound7 (locsound, CHAN_AUTO, string_sound, 1, 0.25,random(100,120),0);
		randompointsound7(org,"impact/projectiles/rico", 15, random(1,1),random(90,120));
		remove(locsound);
		return;
	}

	local entity giblood;
	local float skinn;
	if (!type)
		return;
	giblood = spawn();
	giblood.scale = 0.125;
	giblood.origin = org;
	skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	giblood.skin = skinn * 10;

	if (type == 1)
		setmodel(giblood, "particles/explo/explo_blood1.md3");
	else if (type == 2)
		setmodel(giblood, "particles/explo/explo_blood2.md3");
	else if (type == 3)
		setmodel(giblood, "particles/explo/explo_blood3.md3");
	else if (type == 4)
		setmodel(giblood, "particles/explo/explo_blood4.md3");
	else if (type == 5)
	{
		giblood.colormod = '1 1 1';
		giblood.scale = 0.35;
		setmodel(giblood, "particles/explo/explo_blood4.md3");
	}
	else if (type == 6)
	{
		giblood.colormod = '1 1 1';
		giblood.scale = 0.8;
		setmodel(giblood, "particles/explo/explo_blood1.md3");
	}
	else if (type == 7)
	{
		giblood.colormod = '1 1 1';
		giblood.scale = 0.8;
		setmodel(giblood, "particles/explo/explo_blood4.md3");
	}
	else if (type == 9)
	{
		giblood.scale = 0.8;
		setmodel(giblood, "particles/explo/explo_blood2.md3");
	}
	giblood.think = blood_explode1;
	giblood.nextthink = time;
};

//.float pushedgib;


void(entity inflictor, entity targ, float damage, float pushfactor) explo_physics_gibs;
void()gibpusher_think =
{
	return;
	float gib_power = cvar ("gibpushexp");
	entity head = findradius(self.origin, self.count);
	float pushfactor = 5 + self.cnt * 2.5;
	while (head)
	{
		if (head.wrathflags & FL_GIB)
		{
			head.velocity_z += 24;  
			explo_physics_gibs (self,head,pushfactor, (self.cnt * 1.7 * gib_power)); 	

			float r = random();	
			if(r < 0.3)
			{
				if(!(head.wrathflags & FL_PUSHEDGIB))
					head.wrathflags += FL_PUSHEDGIB;
			}
			head.movetype = MOVETYPE_TOSS;
		}
		head = head.chain;  // cycle to next head (entity)
	}	
	remove(self);	
};

void() gibtrailcontroller_think =
{
	self.owner.traileffectnum = self.owner.traileffectnum2;
	remove(self);
};
void()gibpusher_think2 =
{

	float gib_power = cvar ("gibpush");
	entity head = findradius(self.origin, self.count);


	while (head)
	{
		if ((head.wrathflags & FL_GIB) && (head.movetype != 4) && (head.classname != "func_door"))
		{
			float gibdist = vlen(self.origin - head.origin);
			float pushfactor = (self.count - gibdist) / self.count ;
			vector gibpush = normalize (self.lorigin - self.origin);
			head.velocity += gibpush *  (self.cnt * pushfactor) * gib_power; 

			float r = random();	
			if(r < 0.3)
			{
				if(!(head.wrathflags & FL_PUSHEDGIB))
					head.wrathflags += FL_PUSHEDGIB;
			}

			//head.velocity_z = 12 * pushfactor;
			if((head.traileffectnum2 > 0) && (gibdist < 256))
			{
				entity 	gibtrailcontroller = spawn();
				gibtrailcontroller.owner = head;
				gibtrailcontroller.think = gibtrailcontroller_think;
				gibtrailcontroller.nextthink = time + 0.25;

			}
			//head.movetype = MOVETYPE_BOUNCE;
		}
		head = head.chain;  // cycle to next head (entity)
	}	
	remove(self);	
};


float totaldecals;
void() decal_SUB_Remove
{
	totaldecals--;
	remove(self);
}
void() blood_decal_touch = { float max_totaldecals;
	max_totaldecals = stof(cvar_string("cl_decals_max"));
	if (totaldecals > max_totaldecals)
	{
		remove(self);
		return;
	}
	if ((self.watertype == -3) || (self.watertype == -4) || (self.watertype == -5))
	{
		remove(self);
		return;
	}
	local entity decal, near;
	local float dist, dist2, low;
	low = 999;
	decal = find(decal, classname, "decal");
	while (decal)
	{
		if (decal != self)
		{
			dist = vlen(decal.origin - self.origin);
			if (dist < low)
			{
				low = dist;
				near = decal;
			}
		}
		decal = find(decal, classname, "decal");
	}

	local float surfnum;
	local vector decalpos;
	surfnum = getsurfacenearpoint(world, self.origin);
	decalpos = getsurfacenormal(world, surfnum);

	self.colormod = decalpos;
	if ((decalpos_x == 1) || (decalpos_x == -1))
	{
		self.origin_y = rint(self.origin_y);
		self.origin_z = rint(self.origin_z);
	}
	if ((decalpos_z == 1) || (decalpos_z == -1))
	{
		self.origin_x = rint(self.origin_x);
		self.origin_y = rint(self.origin_y);
	}
	if ((decalpos_y == 1) || (decalpos_y == -1))
	{
		self.origin_x = rint(self.origin_x);
		self.origin_z = rint(self.origin_z);
	}

	if (!near)
	{
		if (self.cnt == 1)
			pointparticles(particleeffectnum("blooddecal"), self.origin, '0 0 0', 1);
		if (self.cnt == 2)
			pointparticles(particleeffectnum("blooddecalmedium"), self.origin, '0 0 0', 1);
		if (self.cnt == 3)
			pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);
		if (self.cnt == 4)
			pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);
		if (self.cnt == 5)
			pointparticles(particleeffectnum("blooddecal"), self.origin, '0 0 0', 1);
		if (self.cnt == 6)
			pointparticles(particleeffectnum("whiteblooddecal"), self.origin, '0 0 0', 1);
		if (self.cnt == 9)
			pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);
	}
	else
	{
		dist2 = vlen(near.origin - self.origin);

		if (self.cnt == 1)
		{
			if (dist2 >= sqrt((pow(64, 2)) *2))
				pointparticles(particleeffectnum("blooddecal"), self.origin, '0 0 0', 1);
			if ((dist2 <= sqrt((pow(64, 2)) *2)) && (dist2 >= sqrt((pow(32, 2)) *2)))
				pointparticles(particleeffectnum("blooddecalmedium"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(32, 2)) *2))
				remove(self);
		}
		if (self.cnt == 2)
		{
			if (dist2 >= sqrt((pow(32, 2)) *2))
				pointparticles(particleeffectnum("blooddecalmedium"), self.origin, '0 0 0', 1);
			if ((dist2 <= sqrt((pow(32, 2)) *2)) && (dist2 >= sqrt((pow(16, 2)) *2)))
				pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(16, 2)) *2))
				remove(self);
		}
		if (self.cnt == 3)
		{
			if (dist2 >= sqrt((pow(16, 2)) *2))
				pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(16, 2)) *2))
				remove(self);
		}
		if (self.cnt == 4)
		{
			if (dist2 >= sqrt((pow(8, 2)) *2))
				pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(8, 2)) *2))
				remove(self);
		}
		if (self.cnt == 5)
		{
			if (dist2 >= sqrt((pow(8, 2)) *2))
				pointparticles(particleeffectnum("blooddecal"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(8, 2)) *2))
				remove(self);
		}
		if (self.cnt == 6)
		{
			if (dist2 >= sqrt((pow(8, 2)) *2))
				pointparticles(particleeffectnum("whiteblooddecal"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(8, 2)) *2))
				remove(self);
		}

		if (self.cnt == 9)
		{
			if (dist2 >= sqrt((pow(16, 2)) *2))
				pointparticles(particleeffectnum("blooddecalsmall"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(16, 2)) *2))
				remove(self);
		}
		if (self.cnt == 10)
		{
			if (dist2 >= sqrt((pow(8, 2)) *2))
				pointparticles(particleeffectnum("blooddecaltiny"), self.origin, '0 0 0', 1);
			if (dist2 < sqrt((pow(8, 2)) *2))
				remove(self);
		}
	}
	totaldecals++;
	self.think = decal_SUB_Remove;

	float time_totaldecals;
	time_totaldecals = stof(cvar_string("cl_decals_time"));

	self.nextthink = time + time_totaldecals;
};
void(vector org, float class) blood_decal = { local entity decal;
	decal = spawn();
	//decal.origin = org;
	setorigin(decal, org);
	setmodel(decal, "models/misc/null.md3");
	decal.cnt = class;
	/*
	decal.movetype = MOVETYPE_TOSS;
	decal.velocity_x = crandom() *10; 
	decal.velocity_y = crandom() *10;
	decal.velocity_z = random() *10;
	*/
	setsize(decal, '0 0 0', '0 0 0');
	decal.solid = SOLID_NOT;
	decal.classname = "decal";
	decal.wrathflags = FL_GARBAGE;
	decal.think = blood_decal_touch;
	decal.nextthink = time;
};

void(vector org, vector enemyangles) decal_monster_pain = { makevectors(enemyangles);
	traceline(org, org + v_forward *192, TRUE, self);
	local vector org2;
	if (trace_fraction != 1)
	{
		org2 = trace_endpos + '0 0 12';
		blood_decal(org2, 2);
	}
};

void(vector org, vector enemyangles) decal_monster_pain2 = { makevectors(enemyangles);
	traceline(org, org + v_forward *256, TRUE, self);
	local vector org2;
	if (trace_fraction != 1)
	{
		org2 = trace_endpos + '0 0 12';
		blood_decal(org2, 5);
	}
};

void(vector org) decal_monster = {
	local vector org2;
	traceline(org, org - '0 0 64', TRUE, self);
	if (trace_fraction != 1)
	{
		org2 = trace_endpos;
		blood_decal(org2, 5);
	}
};

void(vector org) decal_monster_gib = { decal_monster_pain2(rorigin(self), self.enemy.angles);
	local vector org2;
	traceline(org, org - '0 0 64', TRUE, self);
	if (trace_fraction != 1)
	{
		org2 = trace_endpos;
		blood_decal(org2, 5);
	}
};

void(vector org) decal_monster2 = { local vector org2;
	traceline(org, org - '0 0 64', TRUE, self);
	if (trace_fraction != 1)
	{
		org2 = trace_endpos;
		blood_decal(org2, 2);
	}
};

vector(string tagname, entity e) tag_origin = { local float tagindex;local vector tagorg;
	tagindex = gettagindex(e, tagname);
	tagorg = gettaginfo(e, tagindex);
	return tagorg;
};

///////////////////////////////////end of qc file
///////////////////////////////////end of qc file
