/*
==============================================================================
brute CODE
==============================================================================
*/

$frame brt_pose0

$frame brt_idle1 brt_idle2 brt_idle3 brt_idle4 brt_idle5 brt_idle6 brt_idle7 brt_idle8 brt_idle9 brt_idle10

$frame brt_walk1 brt_walk2 brt_walk3 brt_walk4 brt_walk5 brt_walk6 brt_walk7 brt_walk8 brt_walk9 brt_walk10 brt_walk11 brt_walk12 brt_walk13 brt_walk14

$frame brt_rumble1 brt_rumble2 brt_rumble3 brt_rumble4 brt_rumble5 brt_rumble6 brt_rumble7 brt_rumble8

$frame brt_run1 brt_run2 brt_run3 brt_run4 brt_run5 brt_run6 brt_run7 brt_run8

$frame brt_shoot1 brt_shoot2 brt_shoot3 brt_shoot4 brt_shoot5 brt_shoot6 brt_shoot7 brt_shoot8 brt_shoot9 brt_shoot10 brt_shoot11 brt_shoot12 brt_shoot13 brt_shoot14 brt_shoot15 brt_shoot16 brt_shoot17


$frame brt_meleea1 brt_meleea2 brt_meleea3 brt_meleea4 brt_meleea5 brt_meleea6 brt_meleea7

$frame brt_meleeb1 brt_meleeb2 brt_meleeb3 brt_meleeb4 brt_meleeb5 brt_meleeb6 brt_meleeb7

$frame brt_slamb1 brt_slamb2 brt_slamb3 brt_slamb4 brt_slamb5 brt_slamb6 brt_slamb7 brt_slamb8 brt_slamb9 brt_slamb10 brt_slamb11 brt_slamb12 brt_slamb13 brt_slamb14 brt_slamb15 brt_slamb16 brt_slamb17 brt_slamb18 brt_slamb19 brt_slamb20 

$frame brt_slama1 brt_slama2 brt_slama3 brt_slama4 brt_slama5 brt_slama6 brt_slama7 brt_slama8 brt_slama9 brt_slama10 brt_slama11 brt_slama12 brt_slama13 brt_slama14 brt_slama15 brt_slama16 brt_slama17 brt_slama18 brt_slama19 brt_slama20 


$frame brt_meleec1 brt_meleec2 brt_meleec3 brt_meleec4 brt_meleec5 brt_meleec6 brt_meleec7 brt_meleec8 brt_meleec9 brt_meleec10 brt_meleec11 brt_meleec12 brt_meleec13 brt_meleec14 brt_meleec15 brt_meleec16 brt_meleec17 brt_meleec18 brt_meleec19 brt_meleec20 


$frame brt_paina1 brt_paina2 brt_paina3 brt_paina4 brt_paina5 brt_paina6 brt_paina7 brt_paina8 brt_paina9 brt_paina10

$frame brt_paind1 brt_paind2 brt_paind3 brt_paind4 brt_paind5 brt_paind6 brt_paind7 brt_paind8 brt_paind9 brt_paind10

$frame brt_painb1 brt_painb2 brt_painb3 brt_painb4 brt_painb5 brt_painb6 brt_painb7 brt_painb8 brt_painb9 brt_painb10 brt_painb11 brt_painb12 brt_painb13 brt_painb14 brt_painb15 brt_painb16 brt_painb17 brt_painb18 brt_painb19 brt_painb20

$frame brt_painc1 brt_painc2 brt_painc3 brt_painc4 brt_painc5 brt_painc6 brt_painc7 brt_painc8 brt_painc9 brt_painc10 brt_painc11 brt_painc12 brt_painc13 brt_painc14

$frame brt_deatha1 brt_deatha2 brt_deatha3 brt_deatha4 brt_deatha5 brt_deatha6 brt_deatha7 brt_deatha8 brt_deatha9 brt_deatha10 brt_deatha11 brt_deatha12 brt_deatha13 brt_deatha14 brt_deatha15 brt_deatha16 brt_deatha17 brt_deatha18 brt_deatha19 brt_deatha20 brt_deatha21 brt_deatha22 brt_deatha23 brt_deatha24 brt_deatha25

$frame brt_deathb1 brt_deathb2 brt_deathb3 brt_deathb4 brt_deathb5 brt_deathb6 brt_deathb7 brt_deathb8 brt_deathb9 brt_deathb10 brt_deathb11 brt_deathb12 brt_deathb13 brt_deathb14 brt_deathb15 brt_deathb16 brt_deathb17 brt_deathb18 brt_deathb19 brt_deathb20 brt_deathb21 brt_deathb22 brt_deathb23 brt_deathb24 brt_deathb25

void()brute_rumble1;
void()brute_run1;
void()brute_atkr;

void(float exdmg, float range) brute_melee = 
{ 
	local vector delta;
	local float dist;
	if (self.enemy.crouch == 1)
		range += 32;
	float r = random();
	string snd;
	if (r < 1)
		snd = "enemies/brute/attack_punch1.ogg";
	if (r < 0.75)
		snd = "enemies/brute/attack_punch2.ogg";
	if (r < 0.5)
		snd = "enemies/brute/attack_punch3.ogg";
	if (r < 0.25)
		snd = "enemies/brute/attack_punch4.ogg";
	if(exdmg < 50)
	sound7(self, CHAN_AUTO, snd, 1, 0.25,random(100,100) ,0);



	if (!(visibleinfront(self.enemy, 96)))
		return;
	if (!self.enemy)
		return;
	delta = (self.enemy.origin) - rorigin(self);
	dist = vlen(delta);
	


	if (dist < range)
	{
		makevectors(self.v_angle);
		local vector source, org;
		source = rorigin(self);
		traceline(source, self.enemy.origin, FALSE, self);
		if (trace_fraction != 1.0)
		{
			org = trace_endpos - v_forward * 4;
			if ((trace_ent.takedamage))
			{
				if(exdmg == 25)
					trace_ent.punchangle_x = 7;
				if(exdmg == 50)
					trace_ent.punchangle_x = 15;
				//snd2 = "enemies/brute/wound.ogg";

				T_Damage(trace_ent, self, self, exdmg);
				SpawnBlood(org, '0 0 0', 32, 1, 0);
				r = random(); if (r < 0.75)
				SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));
				self.ammo_shotgun = 1;
				self.lance_time = time + 1.1;
				//sound7(self, CHAN_AUTO, snd2, 1, 0.25,random(90,110) ,0);
			}
		}
	}

};


void() brutegrenadetouch = 
{ 
	if (other == self.owner)
		return;
	if(other.solid == SOLID_TRIGGER)
		return;
	if(other.wrathflags & FL_PROJECTILE)
		return;
	

	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	//makevectors (self.angles);
	//te_customflash (self.origin,128,0.55,'0.75 0.2 0.75');
	self.traileffectnum = particleeffectnum("null");


	float brute_rad = cvar("brute_rad");
	entity playerhead = findradius(self.origin, brute_rad);
	while (playerhead)
	{
		if (playerhead.classname == "player")
		{
			// Reki (November 24 2023): I'm not even sure what this was doing exactly before
			// but I think it was just adding velocity to the hit target for every player in
			// the radius, that's definitely not right
			T_RocketJump(self, playerhead, slagrocketjump * 1, self.origin + '0 0 -3', brute_rad);
		}
		playerhead = playerhead.chain;  // cycle to next head (entity)
	}
		

	/*entity visible_explosion = spawn();
	visible_explosion.origin = self.origin;
	visible_explosion.alpha = 0.25;
	visible_explosion.scale = 0.125;
	setmodel(visible_explosion,"models/dev/sphere.md3");
	visible_explosion.solid = SOLID_TRIGGER;
	setsize (visible_explosion,'-64 -64 -64', '64 64 64');
	visible_explosion.effects = 512 + EF_ADDITIVE +  EF_DOUBLESIDED;
	visible_explosion.think = SUB_Remove;
	visible_explosion.nextthink = time + 2;*/

	spawn_shaker (self,18,0.5,368);
	pointparticles(particleeffectnum("bruteproj"), self.origin, '0 0 0', 3);
	setmodel(self, "models/projectiles/proj_slag1_explo.md3");
	//setorigin (self,self.origin +  v_forward ); 
	sound7(self, CHAN_BODY, "misc/null.wav", 0, 0,100,0);
	float r = random();

	if(r < 1)
		sound7(self, CHAN_AUTO, "enemies/brute/proj_impact1.ogg", 1, 0.25, random(95,105), 0);
	if(r < 0.67)
		sound7(self, CHAN_AUTO, "enemies/brute/proj_impact2.ogg", 1, 0.25, random(95,105), 0);
	if(r < 0.34)
		sound7(self, CHAN_AUTO, "enemies/brute/proj_impact3.ogg", 1, 0.25, random(95,105), 0);


	string snd = strcat("impact/projectiles/slag2_explo", ftos(floor(random() * 4) + 1), ".ogg");
	sound7(self, CHAN_AUTO, snd, 0.75, 0.25, 75,0);


	self.touch = SUB_Null;
	self.movetype = 0; 


	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	makevectors(self.angles);
	self.angles = '0 0 0';
	self.frame = 0;
	self.scale = 2;
	setmodel(self, "models/projectiles/proj_slag1_explo.md3");
	self.skin = 1;
	self.alpha = 1;
	self.think = cannon_proj_touch_fade;
	self.nextthink  =  time + 0.05;

	float brute_dmg = cvar("brute_dmg");
	entity ignoreentity;
	if ((other.health) && (other.takedamage))
	{
		ignoreentity = other;
		T_Damage(other, self, self.owner, brute_dmg);
		self.lifetime = -1;
	}
	else
		ignoreentity = world;


	float brute_dmgrad = cvar("brute_dmgrad");

	T_SplashDamage(self,self.owner, brute_dmgrad, ignoreentity,brute_rad);

};

void() brutegrenadethink =
{

	float speed = vlen (self.velocity);
    self.angles = vectoangles(self.velocity);
	//pointparticles(particleeffectnum("bruteproj"), self.origin, '0 0 0', 1);


	if(self.frame < 2)
	self.frame ++;
	vector delta = (self.enemy.origin) - rorigin(self);
	float dist = vlen(delta);

	float brute_magnetism = cvar("brute_mag");

	if ((dist < 420) && (brute_magnetism == 10))
	{
		vector newangles = normalize(self.enemy.origin - self.origin);
		vector newvelocity = speed * newangles;	
		self.velocity_x = self.velocity_x * 0.7 + newvelocity_x * 0.3;  
		self.velocity_y = self.velocity_y * 0.7 + newvelocity_y * 0.3;
		self.cnt = 1;
	}


	if((self.lifetime < time ) || (self.origin == self.oldorigin))
	{	
		self.movetype = 0; 
		setmodel(self, "models/projectiles/proj_slag1_explo.md3");
		self.skin = 1;
		self.scale = 2;
		self.alpha = 1;
		self.think = cannon_proj_touch_fade;
		self.nextthink  =  time + 0.05;
		//sound7(self, CHAN_BODY, "misc/null.wav", 0, 0);
		//sound7(self, CHAN_ITEM, "misc/null.wav", 0, 0);
		sound7(self, CHAN_BODY, "enemies/symbol/impact.ogg", 1, 0.25, random(80,120), 0);

		string snd = strcat("impact/projectiles/slag2_explo", ftos(floor(random() * 4) + 1), ".ogg");
		sound7(self, CHAN_AUTO, snd, 0.75, 0.25, 75,0);
	}
	else
		self.think = brutegrenadethink;

	self.oldorigin = self.origin;
	self.nextthink = time + 0.05;

};

void(vector destination) brutefiregrenade =
{
    local entity missile;
    local vector ang;

    self.effects = self.effects;
	monstersound2("enemies/brute/shoot", 3, CHAN_AUTO);
	monstersound2("weapons/cannon/fire2_", 5, CHAN_AUTO);
    missile = spawn ();
    missile.owner = self;
    missile.movetype = MOVETYPE_BOUNCE;
    missile.solid = SOLID_TRIGGER;
	if(missile.owner.friendly_monster >= 0)
		missile.solid = SOLID_BBOX;
	missile.wrathflags += FL_PROJECTILE;
	float brute_projvel = 800;

	float dist = vlen (self.enemy.origin - self.origin);


	//string viewxanglesfactor = strcat ((ftos (dist)), ("distance\n"));
	//bprint (viewxanglesfactor);

	if(dist > 1200)
	brute_projvel = 800 + ((dist - 800) * 0.2);

	if(brute_projvel > 1300)
		brute_projvel = 1300;

	vector wish_enemyorigin = destination;
	float disttime = vlen (destination - self.origin);
	disttime = disttime / brute_projvel; //aprox time

		wish_enemyorigin_x += self.enemy.velocity_x * disttime * 0.35;// * disttime * 0.25;
		wish_enemyorigin_y += self.enemy.velocity_y * disttime * 0.35;// * disttime * 0.25;
		wish_enemyorigin_z += self.enemy.velocity_z * disttime * 0.15;// * disttime * 0.05;
	vector xofs = wish_enemyorigin - (self.origin + '0 0 32');
	float z = xofs_z;
	xofs_z = 0;
	float y = vlen(xofs);

	float a = 0.5 * 600 * y * y / (brute_projvel * brute_projvel);
	float b = -y;
	float c = a + z;


	

	if(b*b < 4*a*c)
	{
		float gravity_modifier =  (4*a*c)/(b*b); 
		float degree_proj =  42.5;
	}
	else
	{
		float tanx = (-b - (sqrt(b * b - (4*a*c )))) / (2*a);
		degree_proj =  atan(tanx) * RAD2DEG;
	}

	vector vec = normalize(wish_enemyorigin - self.origin);
	ang = vectoangles(vec);
	ang_x = -degree_proj;
	makevectors (ang);
	

	missile.velocity = v_forward * brute_projvel;
	//missile.velocity_z = missile.velocity_z * (1 - gravity_modifier);
	missile.gravity = 0.75;
	missile.enemy = self.enemy;
	missile.traileffectnum = particleeffectnum("bruteprojparticle");
    missile.angles = vectoangles(missile.velocity);
    missile.touch = brutegrenadetouch;
    missile.lifetime = time + 15;
	missile.nextthink = time + 0.1;
	missile.color = '0.75 0.5 0.2';
	missile.pflags = 192;
	missile.style = 3;
	missile.light_lev = 64;
    missile.think = brutegrenadethink;
	setmodel(missile, "models/projectiles/proj_brute.md3");
    setsize (missile, '-5 -5 -5', '5 5 5');

	local vector tagorg;
	local float tagindex;
	if(self.classname == "boss_guardian3")
		tagindex = gettagindex(self, "tag_mouth");
	else
		tagindex = gettagindex(self, "tag_howitzer");
	tagorg = gettaginfo(self, tagindex);
	pointparticles(particleeffectnum("brutemuzzle"), tagorg, '0 0 0', 3);
	te_customflash (tagorg,92,0.55,'0.75 0.6 0.2');

	entity slag_explo = spawn();

	if(self.classname == "boss_guardian3")
		setattachment(slag_explo, self, "tag_mouth");
	else
		setattachment(slag_explo, self, "tag_howitzer");
	float skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	slag_explo.scale =  0.75;
	slag_explo.alpha = 0.75;
	slag_explo.colormod = '0.75 0.75 0.2';
	slag_explo.skin = skinn * 10;
	setmodel(slag_explo, "particles/explo/explo_slag2.md3");
	slag_explo.think = slag2_explode1;
	slag_explo.nextthink = time + 0.05;	
	//sound7(missile, CHAN_BODY, "enemies/brute/proj_loop.ogg", 0.25, 0.25, random(300,400),0);
	sound7(missile, CHAN_BODY, "enemies/symbol/proj_loop.ogg", 1, 0.25, random(250,300),0);
    setorigin (missile, tagorg);
};


void() brute_shoot1 =[$brt_shoot1, brute_shoot2]{ai_face();
	self.movetype = MOVETYPE_STEP;
	//self.colormod = '1 1 1';
	self.yaw_speed = 32;
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;

};
void() brute_shoot2 =[$brt_shoot2, brute_shoot3]{ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;
};
void() brute_shoot3 =[$brt_shoot3, brute_shoot4]{ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;
};
void() brute_shoot4 =[$brt_shoot4, brute_shoot5]{
	ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;
};
void() brute_shoot5 =[$brt_shoot5, brute_shoot6]{ai_face();

	ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;

};
void() brute_shoot6 =[$brt_shoot6, brute_shoot7]{ai_face();

	ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;
};
void() brute_shoot7 =[$brt_shoot7, brute_shoot8]{ai_face();
	ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;
	self.effects += EF_MUZZLEFLASH;
	brutefiregrenade(self.vlasttimespotted);
	self.shotgun_time1 = time + random(0.5,2);

};
void() brute_shoot8 =[$brt_shoot8, brute_shoot9]{ai_face();

	ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;
};
void() brute_shoot9 =[$brt_shoot9, brute_shoot10]{ai_face();

	ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;
};
void() brute_shoot10 =[$brt_shoot10, brute_shoot11]{
	

	ai_face();
	if(visible(self.enemy))
		self.vlasttimespotted = self.enemy.origin;

	float r = random();
	if(r > 0.5)
		self.think = brute_shoot11;	
	else
		self.think = self.th_missile;	


};
void() brute_shoot11 =[$brt_shoot11, brute_shoot12]{};
void() brute_shoot12 =[$brt_shoot12, brute_shoot13]{};
void() brute_shoot13 =[$brt_shoot13, brute_shoot14]{};
void() brute_shoot14 =[$brt_shoot14, brute_shoot15]{};
void() brute_shoot15 =[$brt_shoot15, brute_shoot16]{};
void() brute_shoot16 =[$brt_shoot16, brute_shoot17]{};
void() brute_shoot17 =[$brt_shoot17, brute_run1]
{

	makevectors (self.angles);
	tracebox(self.origin, '-8 -8 -8', '8 8 8', self.origin + v_forward * 64 - v_up *(32 + 16 + self.stepheight_delta), 3, self);

	if(trace_fraction == 1)
	{
		setorigin (self, self.origin + v_forward * -16);
		self.movetype = MOVETYPE_STEP;
		check_angles();
		self.walktime2 = time - 1;
	}

	if (visible(self.enemy))
	{
		float dist = vlen(self.enemy.origin - self.origin);
		if((dist <= 128))
			self.think = brute_atkr;
		else
		{
			self.think = self.th_run;	
		}

	}
	self.nextthink = time + 0.1;
};


void() twenty_fps =
{
	self.nextthink = time + 0.1;
};
void() brute_slamb1;
void() brute_slama1;
void() brute_meleeb1;
void() brute_meleec1;

void() brute_meleea1 =[$brt_meleea1, brute_meleea2]{
self.movetype = MOVETYPE_STEP;
self.yaw_speed = 32;ai_charge(22);ai_face();};
void() brute_meleea2 =[$brt_meleea2, brute_meleea3]{ai_charge(20);ai_face();};
void() brute_meleea3 =[$brt_meleea3, brute_meleea4]
{
	self.ammo_shotgun = 2;	
	ai_charge(18);ai_face();

		brute_melee(25,96);

};
void() brute_meleea4 =[$brt_meleea4, brute_meleea5]{ai_face();};
void() brute_meleea5 =[$brt_meleea5, brute_meleea6]{ai_face();};
void() brute_meleea6 =[$brt_meleea6, brute_meleea7]{ai_face();};
void() brute_meleea7 =[$brt_meleea7, brute_meleea7]
{	
	float dist = vlen(self.enemy.origin - self.origin);
	if (visible(self.enemy))
	{
		if((dist <= 128) && (self.ammo_shotgun  == 1))
		{	
			float r = random();
			if (r < 0.5)
				self.think = brute_meleeb1;
			else
				self.think = brute_slamb1;
		}
		else
			self.think = self.th_run; // self.think = brute_meleea11;
	}
	else
		self.think = self.th_run; //self.think = brute_meleea11;

	//if((self.skin == 1) && visible(self.enemy) && (dist < 256) && (self.shotgun_time1 < time))
	//	self.think = brute_meleec1;
	
};

void() brute_meleeb1 =[$brt_meleeb1, brute_meleeb2]{
self.movetype = MOVETYPE_STEP;
self.yaw_speed = 32;ai_charge(22);ai_face();};
void() brute_meleeb2 =[$brt_meleeb2, brute_meleeb3]{ai_charge(20);ai_face();};
void() brute_meleeb3 =[$brt_meleeb3, brute_meleeb4]
{
	self.ammo_shotgun = 3;	
	ai_charge(18);ai_face();

		brute_melee(25,96);

};
void() brute_meleeb4 =[$brt_meleeb4, brute_meleeb5]{ai_face();};
void() brute_meleeb5 =[$brt_meleeb5, brute_meleeb6]{ai_face();};
void() brute_meleeb6 =[$brt_meleeb6, brute_meleeb7]{ai_face();};
void() brute_meleeb7 =[$brt_meleeb7, brute_meleeb7]
{	
	float dist = vlen(self.enemy.origin - self.origin);
	if (visible(self.enemy))
	{
		if((dist <= 128) && (self.ammo_shotgun  == 1))
		{	
			float r = random();
			if (r < 0.5)
				self.think = brute_meleea1;
			else
				self.think = brute_slama1;
		}
		else
			self.think = self.th_run; // self.think = brute_meleeb11;
	}
	else
		self.think = self.th_run; //self.think = brute_meleeb11;

	//if((self.skin == 1) && visible(self.enemy) && (dist < 256) && (self.shotgun_time1 < time))
	//	self.think = brute_meleec1;
	
};


void() brute_slama1 =[$brt_slama1, brute_slama2]{
self.movetype = MOVETYPE_STEP;
ai_charge(22);ai_face();
monstersound2("enemies/brute/attack_slam", 3, CHAN_AUTO);
};
void() brute_slama2 =[$brt_slama2, brute_slama3]{ai_charge(22);ai_face();};
void() brute_slama3 =[$brt_slama3, brute_slama4]{ai_charge(22);ai_face();};
void() brute_slama4 =[$brt_slama4, brute_slama5]{ai_charge(22);ai_face();};
void() brute_slama5 =[$brt_slama5, brute_slama6]{ai_charge(22);ai_face();};
void() brute_slama6 =[$brt_slama6, brute_slama7]{ai_face();};
void() brute_slama7 =[$brt_slama7, brute_slama8]{ai_face();};
void() brute_slama8 =[$brt_slama8, brute_slama9]{ai_face();};
void() brute_slama9 =[$brt_slama9, brute_slama10]{ai_face();};
void() brute_slama10 =[$brt_slama10, brute_slama11]{
	ai_face();
	self.ammo_shotgun = 0;
	if (visibleinfront(self.enemy, 128))
		brute_melee(50,192);
	
};
void() brute_slama11 =[$brt_slama11, brute_slama12]{ai_face();};
void() brute_slama12 =[$brt_slama12, brute_slama13]{};
void() brute_slama13 =[$brt_slama13, brute_slama14]{};
void() brute_slama14 =[$brt_slama14, brute_slama15]{};
void() brute_slama15 =[$brt_slama15, brute_slama16]{};
void() brute_slama16 =[$brt_slama16, brute_slama17]{};
void() brute_slama17 =[$brt_slama17, brute_slama18]{};
void() brute_slama18 =[$brt_slama18, brute_slama19]{};
void() brute_slama19 =[$brt_slama19, brute_slama20]{};
void() brute_slama20 =[$brt_slama20, brute_meleea1]
{
	if (visible(self.enemy))
	{
		float dist = vlen(self.enemy.origin - self.origin);
		if((dist <= 128) && (self.ammo_shotgun  == 1))
		{	
			float r = random();
			if (r < 0.5)
				self.think = brute_meleeb1;
			else
				self.think = brute_slamb1;
		}
		else
			self.think = self.th_run; // self.think = brute_slama11; 
	}
	else
		self.think = self.th_run; //self.think = brute_slama11; 



	
};

void() brute_slamb1 =[$brt_slamb1, brute_slamb2]{
self.movetype = MOVETYPE_STEP;
ai_charge(22);ai_face();

monstersound2("enemies/brute/attack_slam", 3, CHAN_AUTO);
};
void() brute_slamb2 =[$brt_slamb2, brute_slamb3]{ai_charge(22);ai_face();};
void() brute_slamb3 =[$brt_slamb3, brute_slamb4]{ai_charge(22);ai_face();};
void() brute_slamb4 =[$brt_slamb4, brute_slamb5]{ai_charge(22);ai_face();};
void() brute_slamb5 =[$brt_slamb5, brute_slamb6]{ai_charge(22);ai_face();};
void() brute_slamb6 =[$brt_slamb6, brute_slamb7]{ai_face();};
void() brute_slamb7 =[$brt_slamb7, brute_slamb8]{ai_face();};
void() brute_slamb8 =[$brt_slamb8, brute_slamb9]{ai_face();};
void() brute_slamb9 =[$brt_slamb9, brute_slamb10]{ai_face();};
void() brute_slamb10 =[$brt_slamb10, brute_slamb11]{
	ai_face();
	self.ammo_shotgun = 0;
	if (visibleinfront(self.enemy, 128))
		brute_melee(50,192);
	
};
void() brute_slamb11 =[$brt_slamb11, brute_slamb12]{ai_face();};
void() brute_slamb12 =[$brt_slamb12, brute_slamb13]{};
void() brute_slamb13 =[$brt_slamb13, brute_slamb14]{};
void() brute_slamb14 =[$brt_slamb14, brute_slamb15]{};
void() brute_slamb15 =[$brt_slamb15, brute_slamb16]{};
void() brute_slamb16 =[$brt_slamb16, brute_slamb17]{};
void() brute_slamb17 =[$brt_slamb17, brute_slamb18]{};
void() brute_slamb18 =[$brt_slamb18, brute_slamb19]{};
void() brute_slamb19 =[$brt_slamb19, brute_slamb20]{};
void() brute_slamb20 =[$brt_slamb20, brute_meleea1]
{
	if (visible(self.enemy))
	{
		float dist = vlen(self.enemy.origin - self.origin);
		if((dist <= 128) && (self.ammo_shotgun  == 1))
		{	
			float r = random();
			if (r < 0.5)
				self.think = brute_meleea1;
			else
				self.think = brute_slama1;
		}
		else
			self.think = self.th_run;
	}
	else
		self.think = self.th_run;



	
};
void() brute_meleec1 = [$brt_meleec1, brute_meleec2]
{	
self.movetype = MOVETYPE_STEP;
ai_face();
//self.colormod = '2 0.75 0';
ai_charge(22);ai_face();
self.nextthink = time + 0.05;
};
void() brute_meleec2 =[$brt_meleec2, brute_meleec3]{ai_charge(22);ai_face();self.nextthink = time + 0.05;};
void() brute_meleec3 =[$brt_meleec3, brute_meleec4]{ai_charge(22);ai_face();self.nextthink = time + 0.05;};
void() brute_meleec4 =[$brt_meleec4, brute_meleec5]{ai_charge(22);ai_face();self.nextthink = time + 0.05;};
void() brute_meleec5 =[$brt_meleec5, brute_meleec6]
{

ai_charge(22);ai_face();
self.nextthink = time + 0.05;
};
void() brute_meleec6 =[$brt_meleec6, brute_meleec7]{ai_face();self.nextthink = time + 0.05;};
void() brute_meleec7 =[$brt_meleec7, brute_meleec8]{ai_face();self.nextthink = time + 0.05;
};
void() brute_meleec8 =[$brt_meleec8, brute_meleec9]{ai_face();self.nextthink = time + 0.05;
};

void() brute_meleec9 =[$brt_meleec9, brute_meleec10]{ai_face();self.nextthink = time + 0.05;};
void() brute_meleec10 =[$brt_meleec10, brute_meleec11]{ai_face();self.nextthink = time + 0.05;};
void() brute_meleec11 =[$brt_meleec11, brute_meleec12]{ai_face();};
void() brute_meleec12 =[$brt_meleec12, brute_meleec13]{ai_face();
self.ammo_crystal = 20;spawn_shaker (self,75,1,570);
pointparticles(particleeffectnum("brute_quake"), self.origin - '0 0 32', '0 0 0', 1);
sound(self, CHAN_VOICE, "enemies/brute/brute_rumble.ogg", 1, 0.25);
};
void() brute_meleec13 =[$brt_meleec13, brute_meleec14]{ai_face();};
void() brute_meleec16;
void() brute_meleec14 =[$brt_meleec14, brute_meleec15]
{
	pointparticles(particleeffectnum("brute_quake"), self.origin - '0 0 32', '0 0 0', 1);
	self.ammo_crystal --;
	T_SplashDamage(self, self, 1.75 * self.ammo_crystal, self, 512);

};
void() brute_meleec15 =[$brt_meleec15, brute_meleec16]{

	self.ammo_crystal --;
	T_SplashDamage(self, self, 1.5 * self.ammo_crystal, self, 512);

};
void() brute_meleec16 =[$brt_meleec16, brute_meleec17]{
	self.ammo_crystal --;
	T_SplashDamage(self, self, 1.75 * self.ammo_crystal, self, 512);
};
void() brute_meleec17 =[$brt_meleec17, brute_meleec18]{
	self.ammo_crystal --;
	T_SplashDamage(self, self, 1.75 * self.ammo_crystal, self, 512);
};
void() brute_meleec18 =[$brt_meleec18, brute_meleec19]{
	self.ammo_crystal --;
	T_SplashDamage(self, self, 1.75 * self.ammo_crystal, self, 512);
};


void() brute_meleec19 =[$brt_meleec19, brute_meleec20]{
	self.ammo_crystal --;
	T_SplashDamage(self, self, 1.75 * self.ammo_crystal, self, 512);

};
void() brute_meleec20 =
{
	self.frame = $brt_meleec20;
	if (visible(self.enemy))
	{
		float dist = vlen(self.enemy.origin - self.origin);
		if((dist <= 128))
			self.think = brute_atkr;
		else
			self.think = self.th_run;
	}
	else
	{	
		float r;
		if(r > 0.5)
			self.think = self.th_run;
		else
			self.think = self.th_missile;
	}

	self.shotgun_time1 = time + random(1.5,3.5);
	self.nextthink = time + 0.1;
};

void()brute_atkr = 
{

	//self.colormod = '1 0 0';
	float r = random();
	if (r < 0.5)
		self.think = brute_meleea1;
	else
		self.think = brute_meleeb1;
	self.nextthink = time;
};

void() brute_stand1 =[$brt_idle1, brute_stand2]
{
	self.movetype = MOVETYPE_STEP;
	ai_stand();
	if ((self.idle_time < time) && !(self.spawnflags &1))
	{
		chattersound("enemies/brute/idle", 3, 0.5);
		self.idle_time = time + 4;
	}
};
void() brute_stand2 =[$brt_idle2, brute_stand3]{ai_stand();};
void() brute_stand3 =[$brt_idle3, brute_stand4]{ai_stand();};
void() brute_stand4 =[$brt_idle4, brute_stand5]{ai_stand();};
void() brute_stand5 =[$brt_idle5, brute_stand6]{ai_stand();};
void() brute_stand6 =[$brt_idle6, brute_stand7]{ai_stand();};
void() brute_stand7 =[$brt_idle7, brute_stand8]{ai_stand();};
void() brute_stand8 =[$brt_idle8, brute_stand9]{ai_stand();};
void() brute_stand9 =[$brt_idle9, brute_stand10]{ai_stand();};
void() brute_stand10 =[$brt_idle10, brute_stand1]{ai_stand();};

void() brute_walk1 =[$brt_walk1, brute_walk2]
{
	self.yaw_speed = 10;
	ai_walk(8);
	if ((self.idle_time < time) && !(self.spawnflags &1))
	{
		chattersound("enemies/brute/idle", 3, 0.5);
		self.idle_time = time + 4;
	}
	monstersounda("enemies/brute/step_walk_claw", 3, CHAN_AUTO,0.53);
};
void() brute_walk2 =[$brt_walk2, brute_walk3]{ai_walk(8);};
void() brute_walk3 =[$brt_walk3, brute_walk4]{ai_walk(8);};
void() brute_walk4 =[$brt_walk4, brute_walk5]{ai_walk(8);};
void() brute_walk5 =[$brt_walk5, brute_walk6]{ai_walk(8);};
void() brute_walk6 =[$brt_walk6, brute_walk7]{ai_walk(8);
	monstersounda("enemies/brute/step_walk_claw", 3, CHAN_AUTO,0.53);
};
void() brute_walk7 =[$brt_walk7, brute_walk8]{ai_walk(8);};
void() brute_walk8 =[$brt_walk8, brute_walk9]{ai_walk(8);};
void() brute_walk9 =[$brt_walk9, brute_walk10]{ai_walk(8);};
void() brute_walk10 =[$brt_walk10, brute_walk11]{ai_walk(8);};
void() brute_walk11 =[$brt_walk11, brute_walk12]{ai_walk(8);
	monstersounda("enemies/brute/step_walk_claw", 3, CHAN_AUTO,0.53);
};
void() brute_walk12 =[$brt_walk12, brute_walk13]{ai_walk(8);};
void() brute_walk13 =[$brt_walk13, brute_walk14]{ai_walk(8);};
void() brute_walk14 =[$brt_walk14, brute_walk1]{ai_walk(8);};

void() brute_rumble1 =[$brt_rumble1, brute_rumble2]{ai_runwalk(22);

monstersounda("enemies/brute/step_walk_claw", 3, CHAN_AUTO,0.53);
};
void() brute_rumble2 =[$brt_rumble2, brute_rumble3]{ai_runwalk(22);};
void() brute_rumble3 =[$brt_rumble3, brute_rumble4]{ai_runwalk(22);};
void() brute_rumble4 =[$brt_rumble4, brute_rumble5]{ai_runwalk(22);};
void() brute_rumble5 =[$brt_rumble5, brute_rumble6]{ai_runwalk(22);
monstersounda("enemies/brute/step_walk_claw", 3, CHAN_AUTO,0.53);
	if (visible(self.enemy))
	{
		float dist = vlen(self.enemy.origin - self.origin);
		if((dist > 302) && (self.shotgun_time1 < time))
			self.think = self.th_missile;
		if((dist > 128) && (dist <= 302))
			self.think = brute_run1;
		if((dist <= 128))
			self.think = brute_atkr;

		//if((self.skin == 1) && visible(self.enemy) && (dist < 178)&& (self.shotgun_time1 < time))
		//	self.think = brute_meleec1;
	}




};
void() brute_rumble6 =[$brt_rumble6, brute_rumble7]{ai_runwalk(22);};
void() brute_rumble7 =[$brt_rumble7, brute_rumble8]{ai_runwalk(22);};
void() brute_rumble8 =[$brt_rumble8, brute_rumble1]{ai_runwalk(22);
	if (visible(self.enemy))
	{
		self.movetype = MOVETYPE_STEP;
		float dist = vlen(self.enemy.origin - self.origin);

		if((dist > 302) && (self.shotgun_time1 < time))
			self.think = self.th_missile;
		if((dist > 128) && (dist <= 302))
			self.think = brute_run1;
		if((dist <= 128))
			self.think = brute_atkr;
		//if((self.skin == 1) && visible(self.enemy) && (dist < 178)&& (self.shotgun_time1 < time))
		///	self.think = brute_meleec1;
	}
};

void() brute_run1 =[$brt_run1, brute_run2]{ai_runwalk(21);self.nextthink = time + 0.05;
self.yaw_speed = 15;
	monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.53);
};
void() brute_run2 =[$brt_run1, brute_run3]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run3 =[$brt_run2, brute_run4]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run4 =[$brt_run2, brute_run5]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run5 =[$brt_run3, brute_run6]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run6 =[$brt_run3, brute_run7]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run7 =[$brt_run4, brute_run8]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run9;
void() brute_run8 =
{
	ai_runwalk(21);
	self.frame= $brt_run4;
	float r = random();
	if(r < 0.3)
		chattersound("enemies/brute/chatter", 3, 1);
	if (visible(self.enemy))
	{
		float dist = vlen(self.enemy.origin - self.origin);
		self.think= brute_run9;
		float v_dist =  vlen(self.origin_z - self.enemy.origin_z);
		if((dist > 128) && (v_dist > 128))
			self.think = self.th_missile;
		if((dist > 302) && (self.shotgun_time1 < time) &&(self.skin != 1))
			self.think = self.th_missile;
		if((dist <= 128))
			self.think = brute_atkr;
	}
	else
		self.think= brute_run9;
	self.nextthink = time + 0.05;
};
void() brute_run9 =[$brt_run5, brute_run10]{ai_runwalk(21);self.nextthink = time + 0.05;monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.53);};
void() brute_run10 =[$brt_run5, brute_run11]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run11 =[$brt_run6, brute_run12]{ai_runwalk(21);self.nextthink = time + 0.05;

	
};
void() brute_run12 =[$brt_run6, brute_run13]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run13 =[$brt_run7, brute_run14]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run14 =[$brt_run7, brute_run15]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run15 =[$brt_run8, brute_run16]{ai_runwalk(21);self.nextthink = time + 0.05;};
void() brute_run16 =[$brt_run8, brute_run1]
{


	ai_runwalk(21);
	if (visible(self.enemy))
	{
		self.think = brute_run1;
		float dist = vlen(self.enemy.origin - self.origin);
		float v_dist =  vlen(self.origin_z - self.enemy.origin_z);
		if((dist > 128) && (v_dist > 128))
			self.think = self.th_missile;
		if((dist > 302) && (self.shotgun_time1 < time)&&(self.skin != 1))
			self.think = self.th_missile;
		if((dist <= 128))
			self.think = brute_atkr;


	}
	self.nextthink = time + 0.05;
};
void() brute_start =
{

	if(((self.enemy == single_player) || (self.enemy.flags & FL_MONSTER)) && (self.enemy.health > 0)) 
	{
		float dist = vlen(self.enemy.origin - self.origin);

		if(dist > 302)
			self.think = self.th_missile;
		if((dist > 128) && (dist <= 302))
			self.think = brute_rumble1;
		if((dist <= 128))
			self.think = brute_atkr;
	}
	else 
	{
		self.think = brute_stand1;
	}
	self.nextthink = time;	
};

void() brute_paina1 =[$brt_paina1, brute_paina2]{self.shotgun_time1 = 0;    self.movetype = MOVETYPE_STEP;	self.velocity = '0 0 0';
};
void() brute_paina2 =[$brt_paina2, brute_paina3]{};
void() brute_paina3 =[$brt_paina3, brute_paina4]{};
void() brute_paina4 =[$brt_paina4, brute_paina5]{};
void() brute_paina5 =[$brt_paina5, brute_paina6]{};
void() brute_paina6 =[$brt_paina6, brute_paina7]{};
void() brute_paina7 =[$brt_paina7, brute_paina8]{};
void() brute_paina8 =[$brt_paina8, brute_paina9]{};
void() brute_paina9 =[$brt_paina9, brute_paina10]{};
void() brute_paina10= 
{
	self.sustained_damage = 0;
	self.frame = $brt_paina10;
	self.think = brute_start;
	self.nextthink = time + 0.1;
};

void() brute_paind1 =[$brt_paind1, brute_paind2]{self.shotgun_time1 = 0;    self.movetype = MOVETYPE_STEP;	self.velocity = '0 0 0';
};
void() brute_paind2 =[$brt_paind2, brute_paind3]{};
void() brute_paind3 =[$brt_paind3, brute_paind4]{};
void() brute_paind4 =[$brt_paind4, brute_paind5]{};
void() brute_paind5 =[$brt_paind5, brute_paind6]{};
void() brute_paind6 =[$brt_paind6, brute_paind7]{};
void() brute_paind7 =[$brt_paind7, brute_paind8]{};
void() brute_paind8 =[$brt_paind8, brute_paind9]{};
void() brute_paind9 =[$brt_paind9, brute_paind10]{};
void() brute_paind10= 
{
	self.sustained_damage = 0;
	self.frame = $brt_paind10;
	self.think = brute_start;
	self.nextthink = time + 0.1;
};

void() brute_painb1 =[$brt_painb1, brute_painb2]{
	self.shotgun_time1 = 0;
    self.movetype = MOVETYPE_STEP;	self.velocity = '0 0 0';

	self.pain_finished =  time + 2 + random(5,7);
};
void() brute_painb2 =[$brt_painb2, brute_painb3]{};
void() brute_painb3 =[$brt_painb3, brute_painb4]{};
void() brute_painb4 =[$brt_painb4, brute_painb5]{};
void() brute_painb5 =[$brt_painb5, brute_painb6]{};
void() brute_painb6 =[$brt_painb6, brute_painb7]{};
void() brute_painb7 =[$brt_painb7, brute_painb8]{};
void() brute_painb8 =[$brt_painb8, brute_painb9]{};
void() brute_painb9 =[$brt_painb9, brute_painb10]{};
void() brute_painb10 =[$brt_painb10, brute_painb11]{self.sustained_damage = 0;};
void() brute_painb11 =[$brt_painb11, brute_painb12]{};
void() brute_painb12 =[$brt_painb12, brute_painb13]{};
void() brute_painb13 =[$brt_painb13, brute_painb14]{};
void() brute_painb14 =[$brt_painb14, brute_painb15]{};
void() brute_painb15 =[$brt_painb15, brute_painb16]{};
void() brute_painb16 =[$brt_painb16, brute_painb17]{};
void() brute_painb17 =[$brt_painb17, brute_painb18]{};
void() brute_painb18 =[$brt_painb18, brute_painb19]{};
void() brute_painb19 =[$brt_painb19, brute_painb20]{};
void() brute_painb20 =
{
    self.frame = $brt_painb20;
    self.think = brute_start;
	self.nextthink = time + 0.1;
};

void() brutearmtouch =
{
	
	if(other.solid == SOLID_BSP)
	{	
		string snd2 = "enemies/brute/cannonground.ogg";
		sound7(self, CHAN_AUTO, snd2, 1, 0.25,random(90,110) ,0);
		self.think = alphafade;
		self.nextthink = time + random(10,15);
	}
};


void() brutearmframe =
{
	self.frame = 1;
	self.think = alphafade;
	self.nextthink = time + random(20,25);
};
void() brute_painc1 =[$brt_painc1, brute_painc2]
{
    self.movetype = MOVETYPE_STEP;	self.velocity = '0 0 0';

	self.pain_finished =  time + 1.5 + random(5,7);
	self.shotgun_time1 = 0;
	local entity arm;
	arm = spawn();
	arm.model = "models/enemies/brute/howitzer/gib_howitser.md3";
	setmodel(arm, arm.model);
	arm.origin = self.origin;
	arm.angles = self.angles;
	arm.velocity = '20 20 200';
	setsize(arm, '0 0 0', '0 0 0');
	arm.movetype = MOVETYPE_BOUNCE;
	arm.solid = SOLID_TRIGGER;
	arm.touch = brutearmtouch;
	arm.think = brutearmframe;
	arm.nextthink = time + 1;

	self.armcount = 1;
	string snd2 = "enemies/brute/wound.ogg";
	sound7(self, CHAN_AUTO, snd2, 1, 0.25,random(100,100) ,0);

	chattersound("impact/gibs/gib_hit", 5, 1);
	self.sustained_damage = 0;
	self.skin = 1;	
	self.th_missile = brute_rumble1;
};
void() brute_painc2 =[$brt_painc2, brute_painc3]{};
void() brute_painc3 =[$brt_painc3, brute_painc4]{};
void() brute_painc4 =[$brt_painc4, brute_painc5]{};
void() brute_painc5 =[$brt_painc5, brute_painc6]{};
void() brute_painc6 =[$brt_painc6, brute_painc7]{};
void() brute_painc7 =[$brt_painc7, brute_painc8]{};
void() brute_painc8 =[$brt_painc8, brute_painc9]{};
void() brute_painc9 =[$brt_painc9, brute_painc10]{};
void() brute_painc10 =[$brt_painc10, brute_painc11]{};
void() brute_painc11 =[$brt_painc11, brute_painc12]{};
void() brute_painc12 =[$brt_painc12, brute_painc13]{};
void() brute_painc13 =[$brt_painc13, brute_painc14]{};
void() brute_painc14 =[$brt_painc14, brute_run1]{self.th_run = brute_start;};
void() brute_painc15 =[$brt_painc14, brute_run1]
{
	self.th_run = brute_start;
};


void() brute_deatha1 =[$brt_deatha1, brute_deatha2]{};
void() brute_deatha2 =[$brt_deatha2, brute_deatha3]{monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.53);};
void() brute_deatha3 =[$brt_deatha3, brute_deatha4]{};
void() brute_deatha4 =[$brt_deatha4, brute_deatha5]{};
void() brute_deatha5 =[$brt_deatha5, brute_deatha6]{};
void() brute_deatha6 =[$brt_deatha6, brute_deatha7]{};
void() brute_deatha7 =[$brt_deatha7, brute_deatha8]{monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.753);};
void() brute_deatha8 =[$brt_deatha8, brute_deatha9]{};
void() brute_deatha9 =[$brt_deatha9, brute_deatha10]{};
void() brute_deatha10 =[$brt_deatha10, brute_deatha11]{};
void() brute_deatha11 =[$brt_deatha11, brute_deatha12]{};
void() brute_deatha12 =[$brt_deatha12, brute_deatha13]{};
void() brute_deatha13 =[$brt_deatha13, brute_deatha14]{};
void() brute_deatha14 =[$brt_deatha14, brute_deatha15]{};
void() brute_deatha15 =[$brt_deatha15, brute_deatha16]{};
void() brute_deatha16 =[$brt_deatha16, brute_deatha17]{};
void() brute_deatha17 =[$brt_deatha17, brute_deatha18]{

monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.75);
};
void() brute_deatha18 =[$brt_deatha18, brute_deatha19]{
monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.75);
};
void() brute_deatha19 =[$brt_deatha19, brute_deatha20]{};
void() brute_deatha20 =[$brt_deatha20, brute_deatha21]{};
void() brute_deatha21 =[$brt_deatha21, brute_deatha22]{};
void() brute_deatha22 =[$brt_deatha22, brute_deatha23]{
	string snd2 = "enemies/brute/wound.ogg";
soundwrath(self, CHAN_AUTO, snd2, 1, 0.25,random(75,75) ,32,0.5);

	string snd2 = "enemies/brute/brute_rumble.ogg";
soundwrath(self, CHAN_AUTO, snd2, 1, 0.25,random(75,75) ,0,0.5);

};
void() brute_deatha23 =[$brt_deatha23, brute_deatha24]{
};
void() brute_deatha24 =[$brt_deatha24, brute_deatha25]{};
void() brute_deatha25 =[$brt_deatha25, brute_deatha25]{checkburnable(self);};

void() brute_deathb1 =[$brt_deathb1, brute_deathb2]{};
void() brute_deathb2 =[$brt_deathb2, brute_deathb3]{};
void() brute_deathb3 =[$brt_deathb3, brute_deathb4]{



monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.75);
monstersounda("enemies/brute/step_run_claw", 3, CHAN_AUTO,0.75);
string snd2 = "weapons/mace/mace_impact1.ogg";
soundwrath(self, CHAN_AUTO, snd2, 1, 0.25,random(75,75) ,32,0.5);

};
void() brute_deathb4 =[$brt_deathb4, brute_deathb5]{

	makevectors (self.angles);
	vector org = self.origin - '0 0 16' + v_forward * 24;
	explo_blood(3, org);
	explo_blood(7, org);

	SpawnBlood(org, '0 0 0', 32, 1, 0);
	SpawnBlood(org + randomvector('-5 -5 0','5 5 5'), '0 0 0', 32, 1, 0);
	SpawnBlood(org + randomvector('-5 -5 0','5 5 5'), '0 0 0', 32, 1, 0);
	SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));
	SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));
	SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));

};
void() brute_deathb5 =[$brt_deathb5, brute_deathb6]{};
void() brute_deathb6 =[$brt_deathb6, brute_deathb7]{};
void() brute_deathb7 =[$brt_deathb7, brute_deathb8]{};
void() brute_deathb8 =[$brt_deathb8, brute_deathb9]{};
void() brute_deathb9 =[$brt_deathb9, brute_deathb10]{};
void() brute_deathb10 =[$brt_deathb10, brute_deathb11]{};
void() brute_deathb11 =[$brt_deathb11, brute_deathb12]{};
void() brute_deathb12 =[$brt_deathb12, brute_deathb13]{};
void() brute_deathb13 =[$brt_deathb13, brute_deathb14]{};
void() brute_deathb14 =[$brt_deathb14, brute_deathb15]{


};
void() brute_deathb15 =[$brt_deathb15, brute_deathb16]{};
void() brute_deathb16 =[$brt_deathb16, brute_deathb17]{};
void() brute_deathb17 =[$brt_deathb17, brute_deathb18]{

};
void() brute_deathb18 =[$brt_deathb18, brute_deathb19]{




	string snd2 = "weapons/mace/mace_impact1.ogg";
soundwrath(self, CHAN_AUTO, snd2, 1, 0.25,random(75,75) ,0,0.5);

	string snd2 = "enemies/brute/wound.ogg";
soundwrath(self, CHAN_AUTO, snd2, 1, 0.25,random(75,75) ,32,0.5);

	string snd2 = "enemies/brute/brute_rumble.ogg";
soundwrath(self, CHAN_AUTO, snd2, 1, 0.25,random(75,75) ,0,0.5);


};
void() brute_deathb19 =[$brt_deathb19, brute_deathb20]{
	makevectors (self.angles);
	vector org = self.origin - '0 0 16' + v_forward * 24;
	explo_blood(3, org);
	explo_blood(7, org);
	SpawnBlood(org + randomvector('-5 -5 0','5 5 5'), '0 0 0', 32, 1, 0);
	SpawnBlood(org + randomvector('-5 -5 0','5 5 5'), '0 0 0', 32, 1, 0);
	SpawnBlood(org, '0 0 0', 32, 1, 0);
	SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));
	SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));
	SpawnGib(org + randomvector('-5 -5 8','5 5 16'),randomvector('-48 -48 32','48 48 192'));

};
void() brute_deathb20 =[$brt_deathb20, brute_deathb21]{};
void() brute_deathb21 =[$brt_deathb21, brute_deathb22]{};
void() brute_deathb22 =[$brt_deathb22, brute_deathb23]{};
void() brute_deathb23 =[$brt_deathb23, brute_deathb24]{};
void() brute_deathb24 =[$brt_deathb24, brute_deathb25]{};
void() brute_deathb25 =[$brt_deathb25, brute_deathb25]{

checkburnable(self);
};

void()brute_death =
{
	decal_monster_gib(self.origin + '0 0 12');
	self.solid = SOLID_TRIGGER;
	self.velocity = '0 0 0';
	chattersound("enemies/brute/die", 3, 1);
	self.colormod = '1 1 1';
	//self.alpha = 0.15;
	self.takedamage = 0;

	self.flags = 0;
	self.movetype = MOVETYPE_TOSS;
	self.th_stand = null;
	self.th_walk = null;
	self.th_run = null;
	self.th_missile = null;
	self.th_melee = null;
	self.th_pain = nullpain;
	self.th_die = null;
	//setsize(self, '0 0 0', '0 0 0');

	float r = random();

	//if (self.skin == 1)
	if (r < 0.5)
		self.think = brute_deatha1;
	else
		self.think = brute_deathb1;
	self.nextthink = time;
};
void(entity enemy, float dmg) brute_pain =
{
	self.movetype = MOVETYPE_STEP;
	self.sustained_damage = 0;
	float r = random();
	if(r < 0.5)
		self.think = brute_paina1;
	else
		self.think = brute_paind1;	

	self.velocity = '0 0 0';
	self.pain_finished =  time + 3.5;
	chattersound("enemies/brute/pain", 3, 1);
	self.nextthink = time;	
};
void() precache_monster_brute = 
{ 

    precache_sound("enemies/brute/attack_punch1.ogg");
    precache_sound("enemies/brute/attack_punch2.ogg");
    precache_sound("enemies/brute/attack_punch3.ogg");
    precache_sound("enemies/brute/attack_punch4.ogg");
    precache_sound("enemies/brute/attack_slam1.ogg");
    precache_sound("enemies/brute/attack_slam2.ogg");
    precache_sound("enemies/brute/attack_slam3.ogg");
    precache_sound("enemies/brute/brute_rumble.ogg");
    precache_sound("enemies/brute/chatter1.ogg");
    precache_sound("enemies/brute/chatter2.ogg");
    precache_sound("enemies/brute/chatter3.ogg");
    precache_sound("enemies/brute/die1.ogg");
    precache_sound("enemies/brute/die2.ogg");
    precache_sound("enemies/brute/die3.ogg");
    precache_sound("enemies/brute/idle1.ogg");
    precache_sound("enemies/brute/idle2.ogg");
    precache_sound("enemies/brute/idle3.ogg");
    precache_sound("enemies/brute/pain1.ogg");
    precache_sound("enemies/brute/pain2.ogg");
    precache_sound("enemies/brute/pain3.ogg");
    precache_sound("enemies/brute/proj_impact1.ogg");
    precache_sound("enemies/brute/proj_impact2.ogg");
    precache_sound("enemies/brute/proj_impact3.ogg");
    precache_sound("enemies/brute/proj_loop.ogg");
    precache_sound("enemies/brute/shoot1.ogg");
    precache_sound("enemies/brute/shoot2.ogg");
    precache_sound("enemies/brute/shoot3.ogg");
    precache_sound("enemies/brute/sight1.ogg");
    precache_sound("enemies/brute/sight2.ogg");
    precache_sound("enemies/brute/sight3.ogg");
    precache_sound("enemies/brute/step1_run_claw.ogg");
    precache_sound("enemies/brute/step1_walk_claw.ogg");
    precache_sound("enemies/brute/step2_run_claw.ogg");
    precache_sound("enemies/brute/step2_walk_claw.ogg");
    precache_sound("enemies/brute/step3_run_claw.ogg");
    precache_sound("enemies/brute/step3_walk_claw.ogg");
    precache_sound("enemies/brute/wound.ogg");
    precache_sound("enemies/brute/cannonground.ogg");
	precache_model("models/enemies/brute/brute.md3");
	precache_model("models/enemies/brute/arm_right.md3");
	precache_model("models/enemies/brute/arm_left.md3");
	precache_model("models/projectiles/proj_brute.md3");

};

void() monster_brute = 
{ 

    precache_sound("enemies/brute/attack_punch1.ogg");
    precache_sound("enemies/brute/attack_punch2.ogg");
    precache_sound("enemies/brute/attack_punch3.ogg");
    precache_sound("enemies/brute/attack_punch4.ogg");
    precache_sound("enemies/brute/attack_slam1.ogg");
    precache_sound("enemies/brute/attack_slam2.ogg");
    precache_sound("enemies/brute/attack_slam3.ogg");
    precache_sound("enemies/brute/brute_rumble.ogg");
    precache_sound("enemies/brute/chatter1.ogg");
    precache_sound("enemies/brute/chatter2.ogg");
    precache_sound("enemies/brute/chatter3.ogg");
    precache_sound("enemies/brute/die1.ogg");
    precache_sound("enemies/brute/die2.ogg");
    precache_sound("enemies/brute/die3.ogg");
    precache_sound("enemies/brute/idle1.ogg");
    precache_sound("enemies/brute/idle2.ogg");
    precache_sound("enemies/brute/idle3.ogg");
    precache_sound("enemies/brute/pain1.ogg");
    precache_sound("enemies/brute/pain2.ogg");
    precache_sound("enemies/brute/pain3.ogg");
    precache_sound("enemies/brute/proj_impact1.ogg");
    precache_sound("enemies/brute/proj_impact2.ogg");
    precache_sound("enemies/brute/proj_impact3.ogg");
    precache_sound("enemies/brute/proj_loop.ogg");
    precache_sound("enemies/brute/shoot1.ogg");
    precache_sound("enemies/brute/shoot2.ogg");
    precache_sound("enemies/brute/shoot3.ogg");
    precache_sound("enemies/brute/sight1.ogg");
    precache_sound("enemies/brute/sight2.ogg");
    precache_sound("enemies/brute/sight3.ogg");
    precache_sound("enemies/brute/step1_run_claw.ogg");
    precache_sound("enemies/brute/step2_run_claw.ogg");
    precache_sound("enemies/brute/step3_run_claw.ogg");
    precache_sound("enemies/brute/step1_walk_claw.ogg");
    precache_sound("enemies/brute/step2_walk_claw.ogg");
    precache_sound("enemies/brute/step3_walk_claw.ogg");
    precache_sound("enemies/brute/wound.ogg");
    precache_sound("enemies/brute/cannonground.ogg");
	precache_model("models/enemies/brute/brute.md3");
	precache_model("models/enemies/brute/arm_right.md3");
	precache_model("models/enemies/brute/arm_left.md3");
	precache_model("models/enemies/brute/howitzer/gib_howitser.md3");
	precache_model("models/projectiles/proj_brute.md3");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.flags = self.flags | FL_MONSTER;
	setmodel(self, "models/enemies/brute/brute.md3");
	self.classname = "monster_brute";
	self.heavymonster = 1;
	self.yaw_speed = 32;
	self.damagetopain = 850;
	self.stepheight_delta = 12;
	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/brute/sight3.ogg";	
	if (r < 2)
		self.noise = "enemies/brute/sight2.ogg";	
	if (r < 1)
		self.noise = "enemies/brute/sight1.ogg";	

	setsize(self, '-32 -32 -32', '32 32 48');
	//	setsize (self, '-12 -12 -0', '12 12 64');
	self.health = 3000;
	self.max_health = self.health;
	self.view_ofs_z = 72;
	self.th_stand = brute_stand1;
	self.th_walk = brute_walk1;
	self.skin = 0;
	self.th_run = brute_rumble1;
	self.th_pain = brute_pain;
	self.th_die = brute_death;
	self.th_melee = brute_atkr;
	self.th_missile = brute_shoot1;
	self.pain_finished =  time + random(3,5);
	self.think = self.th_stand;
	self.nextthink = time;
	walkmonster_start();

};

////////////////end of qc file :D 
