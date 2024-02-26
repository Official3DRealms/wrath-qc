/*
==============================================================================
AFFLICTED CODE
==============================================================================
*/

$frame pose0
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12 walk13 walk14
$frame runa1 runa2 runa3 runa4 runa5 runa6 runa7 runa8
$frame wta1 wta2
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8 attack9 attack10
$frame attack11 attack12 attack13 attack14 attack15 attack16 attack17 attack18 attack19 attack20
$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8
$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9

float(vector end) ai_recheable; 
////////////////////////////////////////////////////////////////////////////////////
void() afflicted_run1;
void() afflicted_runb1;
void() afflicted_atk1;
void() afflicted_atk7;

.float idle_time;
void() afflicted_stand1 =[$idle1, afflicted_stand2]
{
	self.nopain = 0;
	//r = random() *15;
	//if ((r < 15) && (!(self.spawnflags &1)))
	if ((self.idle_time < time) && !(self.spawnflags &1))
	{
		chattersound("enemies/afflicted/idle", 3, 1);
		self.idle_time = time + 4;
	}

	ai_stand();
};
void() afflicted_stand2 =[$idle2, afflicted_stand3]
{
	ai_stand();
};
void() afflicted_stand3 =[$idle3, afflicted_stand4]
{
	ai_stand();
};
void() afflicted_stand4 =[$idle4, afflicted_stand5]
{
	ai_stand();
};
void() afflicted_stand5 =[$idle5, afflicted_stand6]
{
	ai_stand();
	float suicide_distance = afflicted_suicide_distance;
	if(self.likecharge == 1)
		suicide_distance = afflicted_suicide_distance * 2;
	float enreachable = ai_recheable(self.enemy.origin);

	if (visibleinfront(self.enemy, 4096))
	{
		if ((visible2(self.enemy, suicide_distance, 0.3))&&(enreachable == 1))
			self.think = afflicted_runb1;
		else
		{
			local float r;
			r = random();
			if (r > aff_dr_idle)
				self.think = afflicted_run1;
			else
				self.think = afflicted_atk1;
		}
	}
};
void() afflicted_stand6 =[$idle6, afflicted_stand7]
{
	ai_stand();
};
void() afflicted_stand7 =[$idle7, afflicted_stand8]
{
	ai_stand();
};
void() afflicted_stand8 =[$idle8, afflicted_stand9]
{
	ai_stand();
};
void() afflicted_stand9 =[$idle9, afflicted_stand10]
{
	ai_stand();
};
void() afflicted_stand10 = { ai_stand();
	local float r;
	self.frame = $idle10;

	float enreachable = ai_recheable(self.enemy.origin);
	if (visibleinfront(self.enemy, 4096))
	{
		if ((visible2(self.enemy, afflicted_suicide_distance, 0.3)) && (enreachable == 1))
			self.think = afflicted_runb1;
		else
		{
			r = random();
			if (r > aff_dr_idle)
				self.think = afflicted_run1;
			else
				self.think = afflicted_atk1;
		}
	}
	else
		self.think = afflicted_stand1;
	self.nextthink = time + 0.1;
};

void() afflicted_waiting1 =[$idle1, afflicted_waiting2]
{

	float enemy_is_visible = visible(self.enemy);
	if ((self.friendly_monster == 1) && ((self.turret) || (self.turret_time > time)))
	{
		if(!self.enemy)
		{
			next_enemy();
		}
		else
		{
			if(!enemy_is_visible)
			{	
				next_enemy();
			}
			else
			{
			if((self.enemy.classname == "player") && (self.player_temp_enemy < time)) 
				next_enemy();
			}	
		}		
	}	
		

	if (enemy_is_visible)
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting2 =[$idle2, afflicted_waiting3]
{
	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting3 =[$idle3, afflicted_waiting4]
{
	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting4 =[$idle4, afflicted_waiting5]
{
	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting5 =[$idle5, afflicted_waiting6]
{
	if((!(self.enemy)) && (self.goalentity))
		self.enemy = self.goalentity;
if((!self.enemy.health) || (!self.enemy)) next_enemy();

	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting6 =[$idle6, afflicted_waiting7]
{
	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting7 =[$idle7, afflicted_waiting8]
{
	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting8 =[$idle8, afflicted_waiting9]
{
	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting9 =[$idle9, afflicted_waiting10]
{
	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() afflicted_waiting10 =[$idle10, afflicted_waiting1]
{
	if((!(self.enemy)) && (self.goalentity))
		self.enemy = self.goalentity;

	if (visible(self.enemy))
	{
		self.think = afflicted_atk1;
		self.nextthink = time + 0.1;
	}

	ai_face();
};

float() afflicted_vertical_ai = { local float ao;
	if (rint(self.origin_z) == rint(self.enemy.origin_z - 32))
		return FALSE;
	else
	{
		if (rint(self.origin_z) > rint(self.enemy.origin_z - 32))
		{
			ao = rint(self.origin_z) - rint(self.enemy.origin_z - 32);
			if (ao < 64)
				return FALSE;
			else
				return TRUE;
		}
		else
		{
			ao = rint(self.enemy.origin_z - 32) - rint(self.origin_z);
			if (ao < 64)
				return FALSE;
			else
				return TRUE;
		}
	}
};

//===========================================================================
void() afflicted_walk1 =[$walk1, afflicted_walk2]
{
	ai_walk(affwvel1);
	self.nopain = 0;

};
void() afflicted_walk2 =[$walk2, afflicted_walk3]
{
	ai_walk(affwvel2);
};
void() afflicted_walk3 =[$walk3, afflicted_walk4]
{
	ai_walk(affwvel3);
};
void() afflicted_walk4 =[$walk4, afflicted_walk5]
{
	ai_walk(affwvel4);
	walksound("enemies/afflicted/step", 3);
};
void() afflicted_walk5 =[$walk5, afflicted_walk6]
{
	ai_walk(affwvel5);
};
void() afflicted_walk6 =[$walk6, afflicted_walk7]
{
	ai_walk(affwvel6);
};
void() afflicted_walk7 =[$walk7, afflicted_walk8]
{
	ai_walk(affwvel7);
};
void() afflicted_walk8 =[$walk8, afflicted_walk9]
{
	ai_walk(affwvel8);
};
void() afflicted_walk9 =[$walk9, afflicted_walk10]
{
	ai_walk(affwvel9);
};
void() afflicted_walk10 =[$walk10, afflicted_walk11]
{
	ai_walk(affwvel10);
};
void() afflicted_walk11 =[$walk11, afflicted_walk12]
{
	ai_walk(affwvel11);
};
void() afflicted_walk12 =[$walk12, afflicted_walk13]
{
	ai_walk(affwvel12);
	walksound("enemies/afflicted/step", 3);
};
void() afflicted_walk13 =[$walk13, afflicted_walk14]
{
	ai_walk(affwvel13);
};
void() afflicted_walk14 =[$walk14, afflicted_walk1]
{
	ai_walk(affwvel14);
};

//===========================================================================
//===========================================================================
void() afflicted_run1 =[$walk1, afflicted_run2]
{
	self.yaw_speed = 20;
	ai_runwalk(affwvel1);
	self.nopain = 0;

	if (self.sight_time < time)
		chattersound2("enemies/afflicted/chatter", 3, 1);

};
void() afflicted_run2 =[$walk2, afflicted_run3]
{
	ai_runwalk(affwvel2);
};
void() afflicted_run3 =[$walk3, afflicted_run4]
{
	ai_runwalk(affwvel3);
};
void() afflicted_run4 =[$walk4, afflicted_run5]
{
	ai_runwalk(affwvel4);
	walksound("enemies/afflicted/step", 3);
};
void() afflicted_run5 =[$walk5, afflicted_run6]
{
	ai_runwalk(affwvel5);
};
void() afflicted_run6 =[$walk6, afflicted_run7]
{
	ai_runwalk(affwvel6);
};
void() afflicted_run7 =[$walk7, afflicted_run8]
{
	ai_runwalk(affwvel7);
};
void() afflicted_run8 =[$walk8, afflicted_run9]
{
	ai_runwalk(affwvel8);
};
void() afflicted_run9 =[$walk9, afflicted_run10]
{
	ai_runwalk(affwvel9);
};
void() afflicted_run10 =[$walk10, afflicted_run11]
{
	ai_runwalk(affwvel10);
};
void() afflicted_run11 =[$walk11, afflicted_run12]
{
	ai_runwalk(affwvel11);
};
void() afflicted_run12 =[$walk12, afflicted_run13]
{
	ai_runwalk(affwvel12);
	walksound("enemies/afflicted/step", 3);
};
void() afflicted_run13 =[$walk13, afflicted_run14]
{
	ai_runwalk(affwvel13);
};
void() afflicted_run14 = { local float r;
	ai_runwalk(affwvel10);
	self.frame = $walk14;
	float dist = vlen(self.enemy.origin - self.origin);
	float enreachable = ai_recheable(self.enemy.origin);
	makevectors (self.angles);
	float nextstepreachable = ai_recheable(self.origin + v_forward * 48);

	if(nextstepreachable == -1)
		self.turret_time = time + random(2,5);

	if (self.enemy.health > 0)
	{
		if (visibleinfront(self.enemy, 1024) && (self.enemy.noattack != 1))
		{
			if (afflicted_vertical_ai())
				self.think = afflicted_atk1;
			else
			{
				if ((visible2(self.enemy, afflicted_suicide_distance, 0.3))&&(enreachable == 1))
					self.think = afflicted_runb1;
				else
				{
					r = random();
					if ((r > aff_dr_walk) && (nextstepreachable == 1))
						self.think = afflicted_run1;
					else
						self.think = afflicted_atk1;
				}
			}
		}
		else
		{
			if(visible(self.enemy) && (dist < 2048))
				self.think = afflicted_atk1;
			else
				self.think = afflicted_run1;

		}
	}
	else
	{
		ai_run(0);
		self.think = afflicted_stand1;
	}

	self.nextthink = time + 0.1;
};
//===========================================================================
.float heretic_suicide;
void() afflicted_explosion = { local vector tagorg;

	vector chestorg = rorigin(self) + '0 0 24';

	tagorg = tag_origin("tag_head", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib1, self), 0, 1);
	tagorg = tag_origin("tag_arm_r_a", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_arm_r_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib2, self), 0, 0);
	tagorg = tag_origin("tag_arm_r_b", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_arm_r_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib3, self), 0, 0);
	tagorg = tag_origin("tag_arm_l_a", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_arm_l_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib4, self), 0, 0);
	tagorg = tag_origin("tag_arm_l_b", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_arm_l_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib5, self), 0, 0);
	explo_blood(3, chestorg);
	pointparticles(particleeffectnum("gib3"), chestorg , v_forward *(-550), 1);
	tagorg = tag_origin("tag_leg_r_a", self);
	//explo_blood (3, tagorg);
	//pointparticles(particleeffectnum("gib3"), tagorg, v_forward*(-550), 1);
	ThrowGib2("models/enemies/afflicted/gibs/gib_leg_r_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib6, self), 0, 0);
	tagorg = tag_origin("tag_leg_r_b", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_leg_r_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib7, self), 0, 0);
	tagorg = tag_origin("tag_leg_l_a", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_leg_l_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib8, self), 0, 0);
	tagorg = tag_origin("tag_leg_l_b", self);
	ThrowGib2("models/enemies/afflicted/gibs/gib_leg_l_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(aff_gib9, self), 0, 0);
	//explo_blood (3, tagorg);
	//	pointparticles(particleeffectnum("gib3"), tagorg, v_forward*(-550), 1);
	explo_blood(8, chestorg);
	ThrowGib2("models/gibs/gib_small.md3", self.health *0.25, 0.75, 1, 1, rorigin(self), relvel(aff_gib10, self), 0, 0);
	ThrowGib2("models/gibs/gib_small.md3", self.health *0.25, 0.75, 1, 1, rorigin(self), relvel(aff_gib12, self), 0, 0);
	ThrowGib2("models/gibs/gib_med.md3", self.health *0.25, 0.75, 1, 1, rorigin(self), relvel(aff_gib12, self), 0, 0);
	ThrowGib2("models/gibs/gib_med.md3", self.health *0.25, 0.75, 1, 1, rorigin(self), relvel(aff_gib13, self), 0, 0);

	self.movetype = 0;
	//drop_item(rorigin(self)+ '0 0 -10', "ammo_retcher", 1, self);
	local string diesound, r;
	r = ftos(floor(random() *3) + 1);
	diesound = strcat("enemies/afflicted/die", r, ".ogg");
	msound(self, CHAN_VOICE, diesound, 1, 0.25);
	//	pointparticles(particleeffectnum("GREEN_BLOOD"), self.origin, '0 0 0', 32); 
	local float rv, rv2, gv;
	rv = (random() *6 + 17) *-1;
	rv2 = (random() *10 + 30) *-1;
	gv = 0.6 + (random() *0.1);
	//T_RadiusDamage (self, self.enemy, afflicteddamage2, world);

	//void(entity inflictor, entity attacker, float damage, entity ignore, float radius, float toplayer) T_SplashDamageMonster =
	if(self.killer.wrath_inv > time)
	self.heretic_suicide = -1;
	if(self.heretic_suicide != -1)
	{
		if(self.heretic_suicide == 1)
			T_SplashDamageMonster(self, damagedexplosionafflicted, afflicteddamage2, world, radiusdexplosionafflicted, stricken_pushfactor);
		else
			T_SplashDamageMonster(self, 100, 30 , world, radiusdexplosionafflicted, stricken_pushfactor);
	}
	self.solid = 0;
	self.scale = 2;
	self.health = -100;
	if(self.heretic_suicide == 1)
		aoe_spawn(self);
	self.origin_z += 24;

	if(self.heretic_suicide != 1)
	{
		pointparticles(particleeffectnum("afflictedaoe"), self.origin - '0 0 32', v_forward *(-550), 1);
		pointparticles(particleeffectnum("afflicted_bloodshower"), chestorg, '0 0 0', 1);
		sound(self, CHAN_AUTO, "enemies/afflicted/explode.ogg", 1, 0.125);
	}
	setmodel(self, "");

	self.alpha = -1;
	self.flags = 0;
	self.movetype = 0;
	self.th_stand = null;
	self.th_walk = null;
	self.th_run = null;
	self.th_missile = null;
	self.th_melee = null;
	self.th_pain = nullpain;
	self.th_die = null;
	setsize(self, '0 0 0', '0 0 0');

	self.think = SUB_Remove;
	self.nextthink = time + 0.5;
};
void() afflicted_die = { self.think = afflicted_explosion;
	self.nextthink = time + 0.1;
};
.float vtorg;
//===========================================================================
void() afflicted_check_explode = { if (visibleinfront(self.enemy, 64))
	{
		self.heretic_suicide = 1;
		Killed(self, world, 1);
	}
};

.float afflicted_run_sound_lenght;
.float afflicted_run_sound_number;
void() afflicted_run_sound = { if (self.afflicted_run_sound_lenght > time)
		return;
	local float rf;
	rf = (floor(random() *3) + 1);
	local string r, snd;

	if (rf == self.afflicted_run_sound_number)
		rf += 1;

	if (rf > 3)
		rf = 1;
	self.afflicted_run_sound_number = rf;

	r = ftos(rf);

	snd = strcat("enemies/afflicted/run", r, ".ogg");
	self.afflicted_run_sound_lenght = time + soundlength(snd);
	msound(self, CHAN_VOICE, snd, 1, 0.25);
};

void() afflicted_runb1 =[$run1, afflicted_runb2]
{
	ai_runwalk(22);
	afflicted_check_explode();
	self.nopain = 1;
	if (self.sight_time < time)
		afflicted_run_sound();
};
void() afflicted_runb2 =[$run2, afflicted_runb3]
{
	ai_runwalk(22);
	afflicted_check_explode();
};
void() afflicted_runb3 =[$run3, afflicted_runb4]
{
	ai_runwalk(22);
	afflicted_check_explode();
	walksound("enemies/afflicted/step", 3);
};
void() afflicted_runb4 =[$run4, afflicted_runb5]
{
	ai_runwalk(22);
	afflicted_check_explode();
	afflicted_run_sound();
};
void() afflicted_runb5 =[$run5, afflicted_runb6]
{
	ai_runwalk(22);
	afflicted_check_explode();
};
void() afflicted_runb6 =[$run6, afflicted_runb7]
{
	ai_runwalk(22);
	afflicted_check_explode();
	afflicted_run_sound();
};
void() afflicted_runb7 =[$run7, afflicted_runb8]
{
	ai_runwalk(22);
	afflicted_check_explode();
	walksound("enemies/afflicted/step", 3);
};
void() afflicted_runb8 =[$run8, afflicted_runb9]
{
	ai_runwalk(22);
	afflicted_check_explode();
	walksound("enemies/afflicted/step", 3);
};

void() afflicted_runb9 = { local float r;
	self.frame = $run9;
	afflicted_check_explode();
	ai_runwalk(22);
	float suicide_distance = afflicted_suicide_distance;
	if(self.likecharge == 1)
		suicide_distance = afflicted_suicide_distance * 2;

	float enreachable = ai_recheable(self.enemy.origin);


	if(self.likecharge != 1)
	{
		if (visibleinfront(self.enemy, 1024))
		{
			if (afflicted_vertical_ai())
				self.think = afflicted_atk1;
			else
			{
				if ((visible2(self.enemy, suicide_distance, 0.5))&&  (enreachable == 1))
					self.think = afflicted_runb1;
				else
				{
					r = random();
					if (r >= aff_dr_run)
						self.think = afflicted_run1;
					else
						self.think = afflicted_atk1;
				}
			}
		}
		else
			self.think = afflicted_run1;

	}
	else
	{
		if ((vlen (self.origin - self.enemy.origin) < suicide_distance) && (visible(self.enemy))&&  (enreachable == 1))
			self.think = afflicted_runb1;
		else
			self.think = afflicted_run1;	

	}

	self.nextthink = time + 0.1;
};
//===========================================================================

void() aoe_think2 = { local float vcnt, rdamage, radiusretcher;
	vcnt = self.cnt / self.oldcnt;
	rdamage = vcnt *10 + 10;
	radiusretcher = vcnt *64 + 10;
	self.cnt -= 1;
	T_SplashDamage(self, self.owner, rdamage, world, radiusretcher);
	self.light_lev = self.light_lev *vcnt + 10;
	if (self.cnt > 0)
		self.think = aoe_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.5;
};

void() aoep_think2 = { if (self.owner.cnt > 0)
		self.think = aoep_think;
	else
		self.think = SUB_Remove;
	self.origin = self.owner.origin;
	pointparticles(particleeffectnum("retcheraoe"), self.origin - ' 0 0 16', v_forward *(-550), (1));
	self.nextthink = time + 0.1;
};

void() CyExplosion2 = { self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel(self, "particles/explo/explo_cyst.md3");
	self.solid = SOLID_NOT;
	T_SplashDamage(self, self.owner, damageexplosionafflicted, world, damageexplosionafflicted);
	local float skinn;
	skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	self.skin = skinn * 10;
	local string snd;
	snd = strcat("impact/projectiles/cyst_explo", ftos(floor(random() *5) + 1), ".ogg");
	sound(self, CHAN_AUTO, snd, 1, 0.25);
	pointparticles(particleeffectnum("retcher"), self.origin, v_forward *(-550), 1);
	cys_explode1();
};

void() aff_proj_touch = { local float damg;
	if (other == self.owner)
		return;	// don't explode on owner
	self.movetype = MOVETYPE_TOSS;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	//self.effects = EF_MUZZLEFLASH;
	damg = afflicteddamage;
	local vector org;
	org = self.origin;
	if (other.takedamage)
	{
		if (other.flags &FL_MONSTER)
			T_Damage(other, self, self.owner, afflicted_damagetomonsters);
		else
			T_Damage(other, self, self.owner, damg);
	}
	else
	{
		local entity aoe, aoep;
		aoe = spawn();
		aoep = spawn();
		aoe.owner = self.owner;
		aoe.origin = self.origin - '0 0 12';
		aoep.origin = self.origin - '0 0 12';
		aoe.classname = "aoe";
		aoep.classname = "aoep";
		//aoe.movetype = MOVETYPE_TOSS;
		aoe.gravity = 0;	//.25;
		//aoe.pflags = 130;
		aoe.light_lev = 90;
		aoe.color = '0 3 0';
		aoe.cnt = 3.5 / 0.5;
		aoe.oldcnt = aoe.cnt;
		aoep.cnt = aoe.cnt;
		aoep.oldcnt = aoe.cnt;
		aoep.owner = aoe;
		local string snd;
		snd = strcat("impact/projectiles/cyst_aoe", ftos(floor(random() *5) + 1), ".ogg");
		sound(aoep, CHAN_WEAPON, snd, 1, 0.5);
		aoe.think = aoe_think2;
		aoep.think = aoep_think2;
		aoe.nextthink = time;
		aoep.nextthink = time;
	}

	//	msound (self, CHAN_AUTO, "oppressor/claw.wav", 1, 0.25);
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	org = self.origin;
	CyExplosion2();
	self.traileffectnum = particleeffectnum("null");
};
.float degreesattack;
void() Attack_Angles = { local float co, ca, hip;
	hip = rint(vlen(self.origin - self.enemy.origin));
	if (rint(self.enemy.origin_z - 32) > rint(self.origin_z))
		co = (self.enemy.origin_z - 32) - rint(self.origin_z);
	else
		co = rint(self.origin_z) - (self.enemy.origin_z - 32);
	ca = sqrt((hip *hip) - (co *co));
	self.degreesattack = acos(ca / hip) *RAD2DEG;
};
.entity cyst_hand;

void() cystthink = { if (self.owner.health < 0)
		remove(self);
	self.think = cystthink;
	self.nextthink = time + 0.05;

};

void() Afflicted_Fire = { if (self.health <= 0)
		return;
	local vector org;
	local float tagindex;
	monstersound1("enemies/stricken/cyst", 3, CHAN_AUTO);

	if(self.classname == "monster_fallen")
		tagindex = gettagindex(self, "tag_head");
	else	
		tagindex = gettagindex(self, "tag_hand");
	org = gettaginfo(self, tagindex);


	local vector distancedelta;
	local vector nozdistancedelta;
	local entity missile;
	missile = spawn();
	missile.classname = "afflicted_projectile";
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

	missile.wrathflags += FL_PROJECTILE;


	local vector dist_player;


	float enemydist = vlen (self.origin - self.enemy.origin);

	if(enemydist >= 1000)
	float predictionfactor = (enemydist / 768) * random(0.4,0.8);  
	else
		predictionfactor = random(0, 0.2);

	makevectors(self.angles);
	if (self.enemy.crouch == 1)
		dist_player = (self.enemy.origin - '0 0 32')+ (self.enemy.velocity * predictionfactor) + (v_forward * random(12,32));
	else
		dist_player = (self.enemy.origin - '0 0 12') + (self.enemy.velocity * predictionfactor)+ (v_forward * random(12,32));

	if(enemydist >= 1000)
	{
		float errorgap = (1024 - enemydist) * 0.2;
		float extravel = random(16,92);
		dist_player_x += random(-errorgap,errorgap); 
		dist_player_y += random(-errorgap,errorgap);
		//dist_player_z += random(-errorgap,errorgap);
		float r = random();
		if( r > 0.75)
		float missilemagnetized = 1;
		
	}

	distancedelta = dist_player - org;	
	nozdistancedelta = distancedelta;

	nozdistancedelta_z = 0;
	missile.velocity = normalize(distancedelta);

	

	missile.velocity = missile.velocity * (768 + extravel);

	local float edistance;
	edistance = vlen(org - self.enemy.origin);
	missile.velocity_z = missile.velocity_z + (64 + edistance / 16) + vlen(nozdistancedelta) *0.15 *(1 + (0.15));
	missile.avelocity = '300 300 300';
	missile.gravity = 0.64;
	if (vlen(nozdistancedelta) > 1024)
	missile.gravity = 0.64 - (vlen(nozdistancedelta) / 1024) * 0.064;
	missile.magnetized = missilemagnetized;
	missile.colormod  = '2 2 2';
	missile.enemy = missile.owner.enemy;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = aff_proj_touch;
	missile.lifetime = time + 5;
	missile.traileffectnum = particleeffectnum("retchertrail");
	setmodel(missile, "models/projectiles/proj_cyst.md3");
	missile.scale = 1;
	missile.think = CheckCys;

	missile.nextthink = time;
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, org);

};

.float preattack_time;

void() afflicted_atk1 =[$attack1, afflicted_atk1b]
{
	self.nopain = 1;
	if(self.ammo_retcher == 1)
		self.think = afflicted_atk7;
	self.nextthink = time;
};

void() afflicted_atk1b =[$attack1, afflicted_atk2]
{
	self.nopain = 1;
	if ((self.sight_time < time) && (self.preattack_time < time))
		{
		self.preattack_time = time + 2;
		attacksound2("enemies/afflicted/preattack");
		}
	
};
void() afflicted_atk2 =[$attack2, afflicted_atk3]
{
	walksound("enemies/afflicted/step", 3);
};
void() afflicted_atk3 =[$attack3, afflicted_atk4]
{
	msound(self, CHAN_WEAPON, "enemies/afflicted/cystpluck.ogg", 1, 0.25);
};
void() afflicted_atk4 =[$attack4, afflicted_atk5]
{
	ai_face();

	local entity cysth;
	cysth = spawn();
	cysth.scale = 1;
	self.ammo_retcher = 1;
	setmodel(cysth, "models/projectiles/proj_cyst.md3");
	setattachment(cysth, self, "tag_hand");
	cysth.owner = self;
	self.cyst_hand = cysth;
	self.cyst_hand.think = cystthink;
	self.cyst_hand.nextthink = time;

};
void() afflicted_atk5 =[$attack5, afflicted_atk6]
{
	ai_face();
};
void() afflicted_atk6 =[$attack6, afflicted_atk7]
{
	ai_face();
};
void() afflicted_atk7 =[$attack7, afflicted_atk8]
{
	ai_face();
};
void() afflicted_atk8 =[$attack8, afflicted_atk9]
{
	ai_face();
};
void() afflicted_atk9 =[$attack9, afflicted_atk10]
{
	ai_face();
};
void() afflicted_atk10 =[$attack10, afflicted_atk11]
{
	ai_face();
	attacksound("enemies/afflicted/attack");
};
void() afflicted_atk11 =[$attack11, afflicted_atk12]
{
	ai_face();
};
void() afflicted_atk12 =[$attack12, afflicted_atk13]
{
	ai_face();
};
void() afflicted_atk13 =[$attack13, afflicted_atk14]
{
	ai_face();
};
void() afflicted_atk14 =[$attack14, afflicted_atk15]
{
	ai_face();
};
void() afflicted_atk15 =[$attack15, afflicted_atk16]
{
	ai_face();
	remove(self.cyst_hand);
	self.ammo_retcher = 0;
	Afflicted_Fire();
};
void() afflicted_atk16 =[$attack16, afflicted_atk17]
{
	ai_face();
};
void() afflicted_atk17 =[$attack17, afflicted_atk18]
{
	ai_face();
};
void() afflicted_atk18 =[$attack18, afflicted_atk19]
{
	ai_face();
};
void() afflicted_atk19 =[$attack19, afflicted_atk20]
{
	ai_face();
};
void() afflicted_atk20 = { local float r;
	self.frame = $attack20;
	ai_face();


	if ((self.turret) || (self.turret_time > time))
	{
		if (visibleinfront(self.enemy, 4096))
			self.think = afflicted_atk1;
		else
			self.think = afflicted_waiting1;
	}
	else
	{
		if (visibleinfront(self.enemy, 4096))
		{
			if (afflicted_vertical_ai())
				self.think = afflicted_atk1;
			else
			{
				makevectors (self.angles);

				float enreachable = ai_recheable(self.enemy.origin);

				if ((visible2(self.enemy, afflicted_suicide_distance *random(1,1.5), 0.5)) &&  (enreachable == 1))
					self.think = afflicted_runb1;
				else
				{
					float nextstepreachable = ai_recheable(self.origin + v_forward * 48);

					r = random();
					if ((r < aff_dr_attack) &&(nextstepreachable == 1))
						self.think = afflicted_run1;
					else
						self.think = afflicted_atk1;
				}
			}
		}
		else
			self.think = afflicted_run1;
	}


	self.nextthink = time + 0.1;
};
//===========================================================================

void() afflicted_paina1 =[$paina1, afflicted_paina2] {};
void() afflicted_paina2 =[$paina2, afflicted_paina3] {};
void() afflicted_paina3 =[$paina3, afflicted_paina4] {};
void() afflicted_paina4 =[$paina4, afflicted_paina5] {};
void() afflicted_paina5 =[$paina5, afflicted_paina6] {};
void() afflicted_paina6 =[$paina6, afflicted_paina7] {};
void() afflicted_paina7 =[$paina7, afflicted_paina8] {};
void() afflicted_paina8 =[$paina8, afflicted_run1]
{
	if ((self.turret) || (self.turret_time > time))
	{
		if (visibleinfront(self.enemy, 4096))
			self.think = afflicted_atk1;
		else
			self.think = afflicted_waiting1;
	}
};

void() afflicted_painb1 =[$painb1, afflicted_painb2] {};
void() afflicted_painb2 =[$painb2, afflicted_painb3] {};
void() afflicted_painb3 =[$painb3, afflicted_painb4] {};
void() afflicted_painb4 =[$painb4, afflicted_painb5] {};
void() afflicted_painb5 =[$painb5, afflicted_painb6] {};
void() afflicted_painb6 =[$painb6, afflicted_painb7] {};
void() afflicted_painb7 =[$painb7, afflicted_painb8] {};
void() afflicted_painb8 =[$painb8, afflicted_run1]
{
	if ((self.turret) || (self.turret_time > time))
	{
		if (visibleinfront(self.enemy, 4096))
			self.think = afflicted_atk1;
		else
			self.think = afflicted_waiting1;
	}
};

void() afflicted_painc1 =[$painc1, afflicted_painc2] {};
void() afflicted_painc2 =[$painc2, afflicted_painc3] {};
void() afflicted_painc3 =[$painc3, afflicted_painc4] {};
void() afflicted_painc4 =[$painc4, afflicted_painc5] {};
void() afflicted_painc5 =[$painc5, afflicted_painc6] {};
void() afflicted_painc6 =[$painc6, afflicted_painc7] {};
void() afflicted_painc7 =[$painc7, afflicted_painc8] {};
void() afflicted_painc8 =[$painc8, afflicted_run1]
{
	if ((self.turret) || (self.turret_time > time))
	{
		if (visibleinfront(self.enemy, 4096))
			self.think = afflicted_atk1;
		else
			self.think = afflicted_waiting1;
	}
};

void() afflicted_paind1 =[$paind1, afflicted_paind2] {};
void() afflicted_paind2 =[$paind2, afflicted_paind3] {};
void() afflicted_paind3 =[$paind3, afflicted_paind4] {};
void() afflicted_paind4 =[$paind4, afflicted_paind5] {};
void() afflicted_paind5 =[$paind5, afflicted_paind6] {};
void() afflicted_paind6 =[$paind6, afflicted_paind7] {};
void() afflicted_paind7 =[$paind7, afflicted_paind8] {};
void() afflicted_paind8 =[$paind8, afflicted_run1]
{
	if ((self.turret) || (self.turret_time > time))
	{
		if (visibleinfront(self.enemy, 4096))
			self.think = afflicted_atk1;
		else
			self.think = afflicted_waiting1;
	}
};

void() afflicted_rpain = { local string r, snd;
	r = ftos(floor(random() *3) + 1);
	snd = strcat("enemies/afflicted/pain", r, ".ogg");
	msound(self, CHAN_VOICE, snd, 1, 0.25);
	self.pain_finished = time + 1;
	local float rnd;
	rnd = random();

	if (rnd < 0.75)
		afflicted_paina1();
	else if (rnd < 0.5)
		afflicted_painb1();
	else if (rnd < 0.25)
		afflicted_painc1();
	else
		afflicted_paind1();
};

void(entity attacker, float damage) afflicted_pain = { if (self.pain_finished > time)
		return;
	if (self.nopain == 1)
		return;
	self.sustained_damage = 0;
	local float pp, rp;
	if (damage >= affph)
		pp = hpdmg;
	if ((damage <= affpm) && (damage > affpl))
		pp = mpdmg;
	if (damage <= affpl)
		pp = lpdmg;
	rp = random();
	if (rp > pp)
		return;

	afflicted_rpain();
};

void() precache_monster_afflicted = { precache_sound("enemies/afflicted/attack1.ogg");
	precache_sound("enemies/afflicted/attack2.ogg");
	precache_sound("enemies/afflicted/attack3.ogg");
	precache_sound("enemies/afflicted/chatter1.ogg");
	precache_sound("enemies/afflicted/chatter2.ogg");
	precache_sound("enemies/afflicted/chatter3.ogg");
	precache_sound("enemies/afflicted/cystpluck1.ogg");
	precache_sound("enemies/afflicted/cystpluck2.ogg");
	precache_sound("enemies/afflicted/cystpluck3.ogg");
	precache_sound("enemies/afflicted/cystpluck.ogg");
	precache_sound("enemies/afflicted/die1.ogg");
	precache_sound("enemies/afflicted/die2.ogg");
	precache_sound("enemies/afflicted/die3.ogg");
	precache_sound("enemies/afflicted/idle1.ogg");
	precache_sound("enemies/afflicted/idle2.ogg");
	precache_sound("enemies/afflicted/idle3.ogg");
	precache_sound("enemies/afflicted/pain1.ogg");
	precache_sound("enemies/afflicted/pain2.ogg");
	precache_sound("enemies/afflicted/pain3.ogg");
	precache_sound("enemies/afflicted/preattack1.ogg");
	precache_sound("enemies/afflicted/preattack2.ogg");
	precache_sound("enemies/afflicted/preattack3.ogg");
	precache_sound("enemies/afflicted/run1.ogg");
	precache_sound("enemies/afflicted/run2.ogg");
	precache_sound("enemies/afflicted/run3.ogg");
	precache_sound("enemies/afflicted/sight1.ogg");
	precache_sound("enemies/afflicted/sight2.ogg");
	precache_sound("enemies/afflicted/sight3.ogg");
	precache_sound("enemies/afflicted/step1.ogg");
	precache_sound("enemies/afflicted/step2.ogg");
	precache_sound("enemies/afflicted/step3.ogg");
	precache_sound("enemies/afflicted/explode.ogg");
	precache_model("models/enemies/afflicted/cyst_d.md3");
	precache_model("models/enemies/afflicted/cyst_c.md3");
	precache_model("models/enemies/afflicted/cyst_b.md3");
	precache_model("models/enemies/afflicted/cyst_a.md3");
	precache_model("models/enemies/afflicted/afflicted.md3");
	precache_model("models/enemies/afflicted/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/afflicted/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/afflicted/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/afflicted/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/afflicted/gibs/gib_leg_r_a.md3");
	precache_model("models/enemies/afflicted/gibs/gib_leg_r_b.md3");
	precache_model("models/enemies/afflicted/gibs/gib_leg_l_a.md3");
	precache_model("models/enemies/afflicted/gibs/gib_leg_l_b.md3");
	precache_model("models/enemies/afflicted/gibs/gib_head.md3");
	precache_model("particles/explo/explo_afflicted.md3");

};
void() monster_afflicted = { precache_monster_afflicted();
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.flags = self.flags | FL_MONSTER;
	setmodel(self, "models/enemies/afflicted/afflicted.md3");
	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/afflicted/sight3.ogg";	
	if (r < 2)
		self.noise = "enemies/afflicted/sight2.ogg";	
	if (r < 1)
		self.noise = "enemies/afflicted/sight1.ogg";	
	setsize(self, afflictednbbox, afflictedbbox);
	self.health = afflictedhealth;
	//self.damagetopain = opp_dtp;
	self.view_ofs = ' 0 0 64';
	self.classname = "monster_afflicted";
	self.th_stand = afflicted_stand1;
	self.th_walk = afflicted_walk1;
	if (!self.turret)
		self.th_run = afflicted_run1;
	else
		self.th_run = afflicted_atk1;
	self.turretable = 1;
	self.th_pain = afflicted_pain;
	self.th_die = afflicted_die;
	self.th_melee = afflicted_runb1;
	self.th_charge = afflicted_runb1;
	self.th_missile = afflicted_atk1;
	self.think = self.th_stand;
	self.nextthink = time;
	spawn_cysts(self);
	walkmonster_start();
};

////////////////end of qc file
////////////////end of qc file
