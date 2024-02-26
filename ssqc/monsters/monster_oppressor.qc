/*
==============================================================================

oppressor

==============================================================================
*/

/*
health
bbox (max)
bbox (min)
walk/run speed
attack damage
projectile vel
walk DICE ROLL
attacka/attackb DICE ROLL
damage needed to pain
pain chance
far
mid
near
zigzag chance
zigzag max deviance
zigzag min deviance 
*/

$frame opp_pose0

$frame opp_idle1 opp_idle2 opp_idle3 opp_idle4 opp_idle5 opp_idle6 opp_idle7 opp_idle8 opp_idle9 opp_idle10 opp_idle11 opp_idle12 opp_idle13 opp_idle14 opp_idle15 opp_idle16 opp_idle17 opp_idle18 opp_idle19 opp_idle20

$frame opp_warp1 opp_warp2 opp_warp3 opp_warp4 opp_warp5 opp_warp6 opp_warp7 opp_warp8 opp_warp9 opp_warp10

$frame opp_run1 opp_run2 opp_run3 opp_run4 opp_run5 opp_run6 opp_run7 opp_run8 opp_run9 opp_run10

$frame opp_runtattk1 opp_runtattk2 opp_runtattk3 opp_runtattk4 opp_runtattk5

$frame opp_atka1 opp_atka2 opp_atka3 opp_atka4 opp_atka5

$frame opp_atkb1 opp_atkb2 opp_atkb3 opp_atkb4 opp_atkb5

$frame opp_atktrun1 opp_atktrun2 opp_atktrun3 opp_atktrun4 opp_atktrun5

$frame opp_paina1 opp_paina2 opp_paina3 opp_paina4 opp_paina5

$frame opp_painb1 opp_painb2 opp_painb3 opp_painb4 opp_painb5

$frame opp_painc1 opp_painc2 opp_painc3 opp_painc4 opp_painc5 opp_painc6 opp_painc7 opp_painc8 opp_painc9 opp_painc10

$frame opp_deatha1 opp_deatha2 opp_deatha3 opp_deatha4 opp_deatha5 opp_deatha6 opp_deatha7 opp_deatha8 opp_deatha9 opp_deatha10

$frame opp_deathb1 opp_deathb2 opp_deathb3 opp_deathb4 opp_deathb5 opp_deathb6 opp_deathb7 opp_deathb8 opp_deathb9 opp_deathb10

$frame opp_deathc1 opp_deathc2 opp_deathc3 opp_deathc4 opp_deathc5 opp_deathc6 opp_deathc7 opp_deathc8 opp_deathc9 opp_deathc10

$frame opp_prefire1 opp_prefire2 opp_prefire3 opp_prefire4 opp_prefire5 opp_prefire6 opp_prefire7 opp_prefire8 opp_prefire9 opp_prefire10

$frame opp_atkd1 opp_atkd2 opp_atkd3 opp_atkd4 opp_atkd5

$frame opp_paind1 opp_paind2 opp_paind3 opp_paind4 opp_paind5 opp_paind6 opp_paind7 opp_paind8 opp_paind9 opp_paind10
$frame opp_paind11 opp_paind12 opp_paind13 opp_paind14 opp_paind15 opp_paind16 opp_paind17 opp_paind18 opp_paind19 opp_paind20
$frame opp_paind21 opp_paind22 


/////////////////////////////////////////////////////////////////////////////////////////////
void() oppressor_stand1 =[$opp_idle1, oppressor_stand2]{ai_stand();

float r = random();

if(( r < 0.3))
monstersounda("enemies/oppressor/idle", 3, CHAN_VOICE, 0.5);

};
void() oppressor_stand2 =[$opp_idle2, oppressor_stand3]{ai_stand();};
void() oppressor_stand3 =[$opp_idle3, oppressor_stand4]{ai_stand();};
void() oppressor_stand4 =[$opp_idle4, oppressor_stand5]{ai_stand();};
void() oppressor_stand5 =[$opp_idle5, oppressor_stand6]{ai_stand();};
void() oppressor_stand6 =[$opp_idle6, oppressor_stand7]{ai_stand();};
void() oppressor_stand7 =[$opp_idle7, oppressor_stand8]{ai_stand();};
void() oppressor_stand8 =[$opp_idle8, oppressor_stand9]{ai_stand();};
void() oppressor_stand9 =[$opp_idle9, oppressor_stand10]{ai_stand();};
void() oppressor_stand10 =[$opp_idle10, oppressor_stand11]{ai_stand();};
void() oppressor_stand11 =[$opp_idle11, oppressor_stand12]{ai_stand();};
void() oppressor_stand12 =[$opp_idle12, oppressor_stand13]{ai_stand();};
void() oppressor_stand13 =[$opp_idle13, oppressor_stand14]{ai_stand();};
void() oppressor_stand14 =[$opp_idle14, oppressor_stand15]{ai_stand();};
void() oppressor_stand15 =[$opp_idle15, oppressor_stand16]{ai_stand();};
void() oppressor_stand16 =[$opp_idle16, oppressor_stand17]{ai_stand();};
void() oppressor_stand17 =[$opp_idle17, oppressor_stand18]{ai_stand();};
void() oppressor_stand18 =[$opp_idle18, oppressor_stand19]{ai_stand();};
void() oppressor_stand19 =[$opp_idle19, oppressor_stand20]{ai_stand();};
void() oppressor_stand20 =[$opp_idle20, oppressor_stand1]{ai_stand();};


void() oppressor_attack;
void() oppressor_waiting1 =[$opp_idle1, oppressor_waiting2]{ai_face();if (visible(self.enemy)&&(self.shotgun_clip >0)){self.think = oppressor_attack;self.nextthink = time + 0.1;}if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;

	if ((self.friendly_monster == 1) && (self.enemy.classname == "player")) 
		next_enemy();
	if(!self.enemy)
		next_enemy();

};
void() oppressor_waiting2 =[$opp_idle2, oppressor_waiting3]{ai_face();if (visible(self.enemy)&&(self.shotgun_clip >0)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting3 =[$opp_idle3, oppressor_waiting4]{ai_face();if (visible(self.enemy)&&(self.shotgun_clip >0)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting4 =[$opp_idle4, oppressor_waiting5]{ai_face();if (visible(self.enemy) &&(self.shotgun_clip >0) ){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting5 =[$opp_idle5, oppressor_waiting6]{ai_face();

if(self.shotgun_clip <0)
self.shotgun_clip = 4;	
if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting6 =[$opp_idle6, oppressor_waiting7]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting7 =[$opp_idle7, oppressor_waiting8]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting8 =[$opp_idle8, oppressor_waiting9]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting9 =[$opp_idle9, oppressor_waiting10]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting10 =[$opp_idle10, oppressor_waiting11]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;

if((!self.enemy.health) || (!self.enemy)) next_enemy();
	if ((self.friendly_monster == 1) && (self.enemy.classname == "player")) 
		next_enemy();
	if(!self.enemy)
		next_enemy();
};
void() oppressor_waiting11 =[$opp_idle11, oppressor_waiting12]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting12 =[$opp_idle12, oppressor_waiting13]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting13 =[$opp_idle13, oppressor_waiting14]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting14 =[$opp_idle14, oppressor_waiting15]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting15 =[$opp_idle15, oppressor_waiting16]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting16 =[$opp_idle16, oppressor_waiting17]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting17 =[$opp_idle17, oppressor_waiting18]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting18 =[$opp_idle18, oppressor_waiting19]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting19 =[$opp_idle19, oppressor_waiting20]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};
void() oppressor_waiting20 =[$opp_idle20, oppressor_waiting1]{ai_face();if (visible(self.enemy)){self.think = oppressor_attack;self.nextthink = time + 0.1;}};




/////////////////////////////////////////////////////////////////////////////////////////////
void() oppressor_walk1 =[$opp_run1, oppressor_walk2]{ai_walk(opp_wvel);};
void() oppressor_walk2 =[$opp_run2, oppressor_walk3]{ai_walk(opp_wvel);};
void() oppressor_walk3 =[$opp_run3, oppressor_walk4]{ai_walk(opp_wvel);monstersound4("enemies/oppressor/step", 5, CHAN_BODY);};
void() oppressor_walk4 =[$opp_run4, oppressor_walk5]{ai_walk(opp_wvel);
	monstersound1("enemies/oppressor/chatter", 5, CHAN_ITEM);
};
void() oppressor_walk5 =[$opp_run5, oppressor_walk6]{ai_walk(opp_wvel);};
void() oppressor_walk6 =[$opp_run6, oppressor_walk7]{ai_walk(opp_wvel);};
void() oppressor_walk7 =[$opp_run7, oppressor_walk8]{ai_walk(opp_wvel);};
void() oppressor_walk8 =[$opp_run8, oppressor_walk9]{ai_walk(opp_wvel);monstersound4("enemies/oppressor/step", 5, CHAN_BODY);};
void() oppressor_walk9 =[$opp_run9, oppressor_walk10]{ai_walk(opp_wvel);
	monstersound1("enemies/oppressor/chatter", 5, CHAN_ITEM);
};
void() oppressor_walk10 =[$opp_run10, oppressor_walk1]{ai_walk(opp_wvel);};

/////////////////////////////////////////////////////////////////////////////////////////////
void() oppressor_runtattck1;

void() oppressor_run1 =[$opp_run1, oppressor_run2]
{	
	ai_runwalk(opp_wvel);		
};
void() oppressor_run2 =[$opp_run2, oppressor_run3]{ai_runwalk(opp_wvel);

	if (visible(self.enemy))
	{
		enemy_range = range(self.enemy);
		if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
		{
			local float rp;
			rp = random() *100;
			if(opp_dr_run >= rp)
			self.think = oppressor_runtattck1;
		}
		if (enemy_range == RANGE_MELEE)		
			self.think = oppressor_runtattck1;
		self.nextthink = time + 0.1;
		return;
	}
};
void() oppressor_run3 =[$opp_run3, oppressor_run4]{ai_runwalk(opp_wvel);
	monstersound4("enemies/oppressor/step", 5, CHAN_BODY);
	if (self.zigzaging == 0)
	{
		local float r;
		r = random() *100;
		if (opp_zzc  >= r)
		{
			float zzmultiplier = random(opp_zzmd,opp_zzd) * crandom3();
			self.zigzagdeviance = zzmultiplier;
			self.zigzaging = 1;
		}
	}
	else
		self.zigzaging = 0;
};
void() oppressor_run4 =[$opp_run4, oppressor_run5]{ai_runwalk(opp_wvel);
	monstersound1("enemies/oppressor/chatter", 5, CHAN_ITEM);
};
void() oppressor_run5 =[$opp_run5, oppressor_run6]{ai_runwalk(opp_wvel);};
void() oppressor_run6 =[$opp_run6, oppressor_run7]{ai_runwalk(opp_wvel);};
void() oppressor_run7 =[$opp_run7, oppressor_run8]{ai_runwalk(opp_wvel);

	if (visible(self.enemy))
	{
		enemy_range = range(self.enemy);
		if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
		{
			local float rp;
			rp = random() *100;
			if(opp_dr_run >= rp)
			self.think = oppressor_runtattck1;
		}
		if (enemy_range == RANGE_MELEE)		
			self.think = oppressor_runtattck1;
		self.nextthink = time + 0.1;
		return;
	}

};
void() oppressor_run8 =[$opp_run8, oppressor_run9]{ai_runwalk(opp_wvel);monstersound4("enemies/oppressor/step", 5, CHAN_BODY);};
void() oppressor_run9 =[$opp_run9, oppressor_run10]{ai_runwalk(opp_wvel);
	monstersound1("enemies/oppressor/chatter", 5, CHAN_ITEM);
};
void() oppressor_run10 =[$opp_run10, oppressor_run1]
{	
	ai_runwalk(opp_wvel);
};
	

void()oppressor_impact =
{
	self.frame += 0.5;
	
	if (self.alpha <= 0.05)
	{
		self.alpha = -1;	
		self.think = SUB_Remove;	
	}
	else	
	{
	self.alpha -= 0.05;
	self.think = oppressor_impact;	
	}
	self.nextthink = time + 0.05;
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() oppressor_projectile_touch = { local float damg;
	if (other == self.owner)
		return;
	if(other.solid == SOLID_TRIGGER)
		return;
	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = opp_dmg;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}
	sound(self, CHAN_WEAPON, "misc/null.wav", 1, 1);
	randomsound2("enemies/oppressor/proj_impact", 3, 1, CHAN_WEAPON, 0, 0.25);
	self.traileffectnum = particleeffectnum("null");
	self.touch = SUB_Null;
	pointparticles(particleeffectnum("proj_oppressor_impact"), self.origin, '0 0 0', 1);
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	self.scale = 1;
	setmodel(self, "models/projectiles/proj_oppressor_explo.md3");
	self.alpha = 1;
	entity slag_explo = spawn();
	float skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	//makevectors(self.angles);
	slag_explo.origin = self.origin;// + v_forward *-12 + v_up *-5;
	slag_explo.skin = skinn * 10;
	setmodel(slag_explo, "particles/explo/explo_slag2.md3");
	slag_explo.think = slag2_explode1;
	slag_explo.nextthink = time + 0.1;	
	self.nextthink = time;
	self.think = oppressor_impact;

};
void()proj_oppressor_think =
{
	if(self.frame < 1)
	self.frame ++;
	
	if(self.enemy.health < 0)
	self.lifetime = 0;
	if(skill >= 3)
	{
	
		if((vlen (self.origin - self.enemy.origin) > 128) && (self.magnetized == 1))
		{
			local vector	dir, vtemp;
			vtemp = self.enemy.origin + '0 0 10';
			dir = normalize(vtemp - self.origin);	
			self.velocity =dir *(opp_projvel);
			self.angles= vectoangles(dir);
		}
		else
		self.magnetized = 0;	
	}
	if(self.origin ==  self.oldorigin)
	{
		self.think = oppressor_projectile_touch;
	}
	else
	{
		if(self.lifetime < time)
			self.think = oppressor_projectile_touch;
		else
			self.think = proj_oppressor_think;
	}
	self.oldorigin = self.origin;
	self.nextthink = time + 0.05;
};	

.float doubleattack;
void(entity e, string tagname, string muzzletagname) oppressor_missileattack = {
	local entity projectile;
	projectile = spawn();
	projectile.owner = e;
	local vector tagorg;
	tagorg = tag_origin(tagname, e);
	setorigin(projectile,tagorg);
	setmodel(projectile, "models/projectiles/proj_oppressor.md3");
	setsize (projectile, opp_proj_size * -0.5,opp_proj_size * 0.5);
	projectile.solid = SOLID_TRIGGER;
	projectile.enemy = e.enemy;
	projectile.colormod = '2 2 2';
	projectile.wrathflags += FL_PROJECTILE;
	projectile.classentity = "projectiles";
	projectile.traileffectnum = particleeffectnum("oppressor_proj_trail");
	projectile.movetype = MOVETYPE_FLYMISSILE;

	float playerspeed = (vlen (self.enemy.velocity));
	vector nextpos = (normalize (self.enemy.velocity)) * playerspeed;	

	if(self.doubleattack == 1)
		vector enemyorigin = self.enemy.origin + '0 0 12' + (nextpos * opp_projvelfactor);
	else
		enemyorigin = self.enemy.origin + '0 0 12';

	projectile.velocity = normalize(enemyorigin - tagorg);

	if(self.doubleattack == 1)
		projectile.velocity = projectile.velocity * opp_projvel2;
	else
		projectile.velocity = projectile.velocity * opp_projvel;

	projectile.angles = vectoangles(projectile.velocity);
	projectile.touch = oppressor_projectile_touch;
	projectile.lifetime  = time + 7.5;
	sound7(projectile, CHAN_WEAPON, "enemies/oppressor/proj_loop.wav", 1, 0.25, 80 + random() *30, 0);
	projectile.nextthink = time + 0.1;
	projectile.think = proj_oppressor_think;
	
	entity slag_explo = spawn();
	setattachment(slag_explo, e, muzzletagname);
	float skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	slag_explo.scale =  0.75;
	slag_explo.skin = skinn * 10;
	setmodel(slag_explo, "particles/explo/explo_slag2.md3");
	slag_explo.think = slag2_explode1;
	slag_explo.nextthink = time + 0.05;	
	self.shotgun_clip --;
	
};

void() oppressor_attacktw1 =[$opp_atktrun1, oppressor_attacktw2]{
monstersound2("enemies/oppressor/postattack", 5, CHAN_VOICE);
};
void() oppressor_attacktw2 =[$opp_atktrun2, oppressor_attacktw3]{ai_runwalk(8);};
void() oppressor_attacktw3 =[$opp_atktrun3, oppressor_attacktw4]{ai_runwalk(8);};
void() oppressor_attacktw4 =[$opp_atktrun4, oppressor_attacktw5]{ai_runwalk(8);};
void() oppressor_attacktw5 =[$opp_atktrun5, oppressor_run8]{ai_runwalk(8);};
void()oppressor_predoubleattack1;
void()oppressor_check_attack =
{
	if (self.flags &FL_ONGROUND)
	{	
		vector vdisttofloor;
		vdisttofloor_z = self.mins_z - 4;
		traceline (self.origin, self.origin + vdisttofloor, TRUE,self); 

		if(trace_fraction == 1)
		{
			makevectors(self.angles);
			self.flags -= FL_ONGROUND;
			self.velocity += v_forward * 1;	
			self.velocity += ' 0 0 1';
		}
	}
	float enemy_is_visible = visible(self.enemy);
	if ((self.friendly_monster == 1) && (self.turret))
	{
		if(!self.enemy)
			next_enemy();
		else
		{
			if(!enemy_is_visible)
				next_enemy();
			else
			{
			if((self.enemy.classname == "player") && (self.player_temp_enemy < time)) 
				next_enemy();
			}	
		}		
	}	
	if(!self.turret)
	{
		if (enemy_is_visible)
		{
			enemy_range = range(self.enemy);
			if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
			{
				local float rp;
				rp = random() *100;
				if((opp_dr_attack <= rp))
				self.think = oppressor_attacktw1;
			}	
		}
		else
			self.think = oppressor_attacktw1;
	}
	else
	{
		if (!enemy_is_visible)
			self.think = oppressor_waiting1;
	}


	if (self.shotgun_clip <= 0)	
	{
		if(self.turret != 1)
			self.think = oppressor_attacktw1;
		else
		{
			
			float r = random();
			if (r < 0.1)
			monstersound2("enemies/oppressor/preattack", 5, CHAN_VOICE);
			r = vlen(self.origin - self.enemy.origin);

			if (r > opp_mid)
				self.doubleattack = 1;
			else
				self.doubleattack = 0;

			self.think = oppressor_waiting1;

			if (self.doubleattack == 1)
			{
				self.think = oppressor_predoubleattack1;
				self.shotgun_clip = 4;
			}
			self.nextthink = time + 0.1;

		}			
	}

	self.nextthink = time + 0.1;

};

.float oppressor_attack_a;

void() oppressor_attackb1 =[$opp_atkb1, oppressor_attackb2]{ai_face();	monstersound2("enemies/oppressor/fire", 5, CHAN_WEAPON);
oppressor_missileattack(self,"tag_projb","tag_muzzleb");


};
void() oppressor_attackb2 =[$opp_atkb2, oppressor_attackb3]{ai_face();};
void() oppressor_attackb3 =[$opp_atkb3, oppressor_attackb4]{ai_face();};
void() oppressor_attackb4 =[$opp_atkb4, oppressor_attackb5]{ai_face();};
void() oppressor_attackb5 =[$opp_atkb5, oppressor_attacka1]{ai_face();
self.oppressor_attack_a = 0;
if(self.shotgun_clip <= 0)
oppressor_check_attack();
};

void() oppressor_attacka1 =[$opp_atka1, oppressor_attacka2]{ai_face();monstersound2("enemies/oppressor/fire", 5, CHAN_WEAPON);
oppressor_missileattack(self,"tag_proja","tag_muzzlea");

//self.shotgun_clip --;	
};
void() oppressor_attacka2 =[$opp_atka2, oppressor_attacka3]{ai_face();};
void() oppressor_attacka3 =[$opp_atka3, oppressor_attacka4]{ai_face();};
void() oppressor_attacka4 =[$opp_atka4, oppressor_attacka5]{ai_face();};
void() oppressor_attacka5 =[$opp_atka5, oppressor_attackb1]{ai_face();
self.oppressor_attack_a = 1;
if(self.shotgun_clip <= 0)
oppressor_check_attack();
};

void() oppressor_attack =
{
	if (self.flags &FL_ONGROUND)
	{	
		vector vdisttofloor;
		vdisttofloor_z = self.mins_z - 4;
		traceline (self.origin, self.origin + vdisttofloor, TRUE,self); 

		if(trace_fraction == 1)
		{
			makevectors(self.angles);
			self.flags -= FL_ONGROUND;
			self.velocity += v_forward * 1;	
			self.velocity += ' 0 0 1';
		}
	}
	if(self.oppressor_attack_a == 1)
		self.think = oppressor_attackb1;
	else
		self.think = oppressor_attacka1;
	self.nextthink = time;	

};

void() oppressor_doubleattack1 =[$opp_atkd1, oppressor_doubleattack2]{ai_face();monstersound2("enemies/oppressor/fire", 5, CHAN_WEAPON);
oppressor_missileattack(self,"tag_proja","tag_muzzlea");
oppressor_missileattack(self,"tag_projb","tag_muzzleb");
};
void() oppressor_doubleattack2 =[$opp_atkd2, oppressor_doubleattack3]{ai_face();};
void() oppressor_doubleattack3 =[$opp_atkd3, oppressor_doubleattack4]{ai_face();};
void() oppressor_doubleattack4 =[$opp_atkd4, oppressor_doubleattack5]{ai_face();};
void() oppressor_doubleattack5 =[$opp_atkd5, oppressor_doubleattack1]{ai_face();
if(self.shotgun_clip <= 0)
oppressor_check_attack();
};



void() oppressor_predoubleattack1 = [$opp_prefire1, oppressor_predoubleattack2]{ai_face();};
void() oppressor_predoubleattack2 = [$opp_prefire2, oppressor_predoubleattack3]{ai_face();};
void() oppressor_predoubleattack3 = [$opp_prefire3, oppressor_predoubleattack4]{ai_face();};
void() oppressor_predoubleattack4 = [$opp_prefire4, oppressor_predoubleattack5]{ai_face();};
void() oppressor_predoubleattack5 = [$opp_prefire5, oppressor_predoubleattack6]{ai_face();};
void() oppressor_predoubleattack6 = [$opp_prefire6, oppressor_predoubleattack7]{ai_face();};
void() oppressor_predoubleattack7 = [$opp_prefire7, oppressor_predoubleattack8]{ai_face();};
void() oppressor_predoubleattack8 = [$opp_prefire8, oppressor_predoubleattack9]{ai_face();};
void() oppressor_predoubleattack9 = [$opp_prefire9, oppressor_predoubleattack10]{ai_face();};
void() oppressor_predoubleattack10 = [$opp_prefire10, oppressor_doubleattack1]{ai_face();};

void() oppressor_runtattck1 =[$opp_runtattk1, oppressor_runtattck2]{
	ai_face();self.yaw_speed = 30;monstersound4("enemies/oppressor/step", 5, CHAN_BODY);
	monstersound2("enemies/oppressor/preattack", 5, CHAN_VOICE);
	float r = vlen(self.origin - self.enemy.origin);


	if (r > opp_mid)
		self.doubleattack = 1;
	else
		self.doubleattack = 0;

	self.shotgun_clip = 4;	
};
void() oppressor_runtattck2 =[$opp_runtattk2, oppressor_runtattck3]{ai_face();};
void() oppressor_runtattck3 =[$opp_runtattk3, oppressor_runtattck4]{ai_face();};
void() oppressor_runtattck4 =[$opp_runtattk4, oppressor_runtattck5]{ai_face();};
void() oppressor_runtattck5 =[$opp_runtattk5, oppressor_attacka1]{ai_face();self.yaw_speed = 20;

if (self.doubleattack == 1)
self.think = oppressor_predoubleattack1;
self.nextthink = time + 0.1;
	
};

/////////////////////////////////////////////////////////////////////////////////////////////
.float maxpainframe;
void() oppressor_postpain =
{ 
	if (self.painframe < self.maxpainframe) 
	{
	self.frame ++; 
	self.painframe ++; 
	}
	if((self.maxpainframe == 10) && (self.painframe == 3))
		monstersound4("enemies/oppressor/step", 5, CHAN_BODY);
	if (self.painframe == self.maxpainframe) 
	{
		ai_face();	
		enemy_range = range(self.enemy);
		
		if(visible(self.enemy))
		{
			if (visibleinfront (self.enemy, 2048))
			{
				if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MELEE) || (enemy_range == RANGE_MID))
				{
					self.think = oppressor_attacka1;
					self.nextthink = time + 0.1;
					return;
				}
			}
			else
			{
				self.think = oppressor_postpain;
				self.nextthink = time + 0.1;	
				return;				
			}	
		}
		else
		{
			if(!self.turret)
				self.think = oppressor_run1;
			else
				self.think = oppressor_waiting1;
			self.nextthink = time + 0.1;
			return;
		}
	}
	self.think = oppressor_postpain;
	self.nextthink = time + 0.1;	
};


/////////////////////////////////////////////////////////////////////////////////////////////
void(entity enemy, float dmg) oppressor_pain = 
{
	
	monstersound3("enemies/oppressor/pain", 3, CHAN_VOICE);
	local float rp;
	rp = random() *100;
	if (opp_rtp <= rp)
		return;
	self.painframe = 1;
	float r = random();
	if(r < 1)
	{self.frame = $opp_paina1;self.maxpainframe = 5;}
	if(r < 0.65)
	{self.frame = $opp_painb1;self.maxpainframe = 5;}
	if(r < 0.33)
	{self.frame = $opp_painc1;self.maxpainframe = 10;}
	ai_pain(4);
	//monstersound4("enemies/oppressor/pain", 5, CHAN_VOICE);
	self.think = oppressor_postpain;
	self.sustained_damage = 0;
	self.nextthink = time + 0.1;
};

void() oppressor_painb =
{
	monstersound3("enemies/oppressor/pain", 3, CHAN_VOICE);
	self.frame = $opp_paind1;
	self.painframe = 1;
	self.maxpainframe = 22;
	ai_pain(7);
	self.think = oppressor_postpain;
	self.sustained_damage = 0;
	self.nextthink = time + 0.1;
};

///////////////////////////////////////////////////////////////////////////////////////////
void()	oppressor_glow_fade =
{
	if (self.glowmod_x <= 0.1)
	{
		self.glowmod = '-1 -1 -1'; 
		self.think = SUB_Null;
		self.nextthink = time + 0.1; 
		return;
	}
	self.glowmod_x -= 0.025;
	self.glowmod_y -= 0.025;
	self.glowmod_z -= 0.025;
	self.nextthink = time + 0.05; 
};


.float lava_aoe_big;
void() lava_aoe_think = { local float vcnt, rdamage, radiusretcher;
	vcnt = self.cnt / self.oldcnt;
	rdamage = vcnt *retcheraoedamage *1.5 + 10;
	radiusretcher = vcnt *128;

	if (self.dmg == 0)
	{
		T_SplashDamage(self, world, rdamage *1.25* 0.25, world, radiusretcher);
		self.cnt -= 0.125;
	}
	else
	{
		T_SplashDamage(self, world, rdamage * 0.25, world, radiusretcher);
		self.cnt -= 0.125;
	}

	self.light_lev = self.light_lev *vcnt + 10;
	if (self.cnt > 0)
		self.think = lava_aoe_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.125;
};

void() lava_aoep_think = { if (self.owner.cnt > 0)
		self.think = lava_aoep_think;
	else
		self.think = SUB_Remove;
	self.origin = self.owner.origin - '0 0 48';
	self.effects = 1024;
	if (self.lava_aoe_big == 1)
	{
		if ((self.owner.cnt) < (self.cnt / 5))
			pointparticles(particleeffectnum("lava_aoebig5"), self.origin, v_forward *(-550), (3));
		else if ((self.owner.cnt) < (self.cnt / 4))
			pointparticles(particleeffectnum("lava_aoebig4"), self.origin, v_forward *(-550), (3));
		else if ((self.owner.cnt) < (self.cnt / 3))
			pointparticles(particleeffectnum("lava_aoebig3"), self.origin, v_forward *(-550), (3));
		else if ((self.owner.cnt) < (self.cnt / 2))
			pointparticles(particleeffectnum("lava_aoebig2"), self.origin, v_forward *(-550), (3));
		else
			pointparticles(particleeffectnum("lava_aoebig1"), self.origin, v_forward *(-550), (3));

	}
	else
		pointparticles(particleeffectnum("lava_aoe"), self.origin, v_forward *(-550), (2));
	self.nextthink = time + 0.15;
};

void(entity e, float ltime, float dmge) lava_aoe_spawn = { local entity lava_aoe, lava_aoep;
	lava_aoe = spawn();
	lava_aoep = spawn();
	lava_aoe.wrathflags += FL_GARBAGE;
	lava_aoep.wrathflags += FL_GARBAGE;
	//lava_aoe.owner = world;
	lava_aoe.origin = e.origin;
	//setmodel(lava_aoe,"asdasd");
	lava_aoep.origin = e.origin;	
	lava_aoe.classname = "lava_aoe";
	lava_aoep.classname = "lava_aoep";
	//lava_aoe.movetype = MOVETYPE_TOSS;
	lava_aoe.gravity = 0;	//.25;

	lava_aoe.cnt = ltime / 0.5;
	lava_aoe.oldcnt = lava_aoe.cnt;
	lava_aoep.cnt = lava_aoe.cnt;
	lava_aoep.oldcnt = lava_aoe.cnt;
	lava_aoep.owner = lava_aoe;
	lava_aoe.dmg = dmge;
	lava_aoep.lava_aoe_big = 1;
	lava_aoe.origin = e.origin + '0 0 12';
	lava_aoep.origin = e.origin - '0 0 36';
	lava_aoe.nextthink = time;
	lava_aoep.nextthink = time;
	//snd = strcat("impact/projectiles/cyst_lava_aoe", ftos(floor(random() *5) + 1), ".ogg");
	//sound(lava_aoe, CHAN_WEAPON, snd, 1, 0.5);
	lava_aoe.think = lava_aoe_think;
	lava_aoep.think = lava_aoep_think;
};

void() oppressor_postdie =
{ 
	self.frame += 1; 
	self.painframe += 1; 
	if(self.fakewatertype != CONTENT_LAVA)
	{
		self.glowmod_x -= 0.05;
		self.glowmod_y -= 0.05;
		self.glowmod_z -= 0.05;
	}
	if(self.painframe == 10)
	{
		checkburnable(self);
		if(self.fakewatertype != CONTENT_LAVA)
			self.think = oppressor_glow_fade;
		else
			self.think = SUB_Null;
	}	
	else
		self.think = oppressor_postdie;
	self.nextthink = time + 0.1;
};	

void() oppressor_gibdead =
{
	self.alpha = -1;
	local vector tagorg;


	float r = random();
	if (r > 0.5)
	{
		tagorg = tag_origin("tag_cannon_r", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/cannon_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib1, self), 0, 3);	// forward,right,up
	}
	else
	{
		tagorg = tag_origin("tag_cannon_l", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/cannon_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib2, self), 0, 3);	// forward,right,up
	}

	r = random();
	if (r > 0.5)
	{
		tagorg = tag_origin("tag_shoulder_r", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/shoulder_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib3, self), 0, 3);	// forward,right,up
	}
	else
	{
		tagorg = tag_origin("tag_shoulder_l", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/shoulder_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib4, self), 0, 3);	// forward,right,up
	}

	tagorg = tag_origin("tag_head_bot_r", self);
	ThrowGib3(self, "models/enemies/oppressor/gibs/head_bot_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib1, self), 0, 3);	// forward,right,up
	tagorg = tag_origin("tag_head_bot_l", self);
	ThrowGib3(self, "models/enemies/oppressor/gibs/head_bot_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib2, self), 0, 3);	// forward,right,up
	tagorg = tag_origin("tag_head_back", self);
	ThrowGib3(self, "models/enemies/oppressor/gibs/head_back.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-150 0 100', self), 0, 3);	// forward,right,up
	tagorg = tag_origin("tag_head_face", self);
	ThrowGib3(self, "models/enemies/oppressor/gibs/head_face.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('150 0 70', self), 0, 3);	// forward,right,up
	tagorg = tag_origin("tag_head_top", self);
	ThrowGib3(self, "models/enemies/oppressor/gibs/head_top.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-50 0 200', self), 0, 3);	// forward,right,up

	tagorg = tag_origin("tag_pelvis", self);
	ThrowGib3(self, "models/enemies/oppressor/gibs/pelvis.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib6, self), 0, 3);	// forward,right,up

	r = random();
	if (r > 0.5)
	{
		tagorg = tag_origin("tag_leg_l", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/leg_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib7, self), 0, 3);	// forward,right,up
	}
	else
	{
		tagorg = tag_origin("tag_leg_r", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/leg_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib8, self), 0, 3);	// forward,right,up
	}
	r = random();
	if (r > 0.5)
	{
		tagorg = tag_origin("tag_foota", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/foota.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib7, self), 0, 3);	// forward,right,up
	}
	else
	{
		tagorg = tag_origin("tag_footb", self);
		ThrowGib3(self, "models/enemies/oppressor/gibs/footb.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib8, self), 0, 3);	// forward,right,up
	}
	pointparticles(particleeffectnum("oppressor_gib"), self.origin, '0 0 0', 1);		


	entity	explo = spawn();
	explo.origin = self.origin + '0 0 24';
	setmodel(explo, "models/projectiles/proj_slag2_explo.md3");
	explo.alpha = 3;
	explo.colormod = '1 0.5 0.33';
	explo.scale = 0.7;
	explo.think = cannon_proj_touch_fade;
	explo.nextthink  =  time + 0.05;

	self.effects = EF_NODRAW;
	self.classname = "monster_oppressor_gibbed";
	drop_item(self.origin + '0 0 0', "ammo_cannon", 5, self);
	//decal_monster(self.origin + '0 0 12');
	self.solid = SOLID_NOT;
	self.solid = 0;
	self.takedamage = 0;
	self.flags = 0;
	self.movetype = 0;
	self.th_stand = null;
	self.th_walk = null;
	self.th_run = null;
	self.th_missile = null;
	self.th_melee = null;
	self.th_pain = nullpain;
	lava_aoe_spawn(self,2.5,0);
	T_SplashDamage(self, self, 96, world, 96);
	self.think = SUB_Remove;
	self.nextthink = time + 2;
};


void() oppressor_die = 
{ 
	//decal_monster(self.origin + '0 0 12');
	self.takedamage = 0;
	self.flags = 0;
	self.movetype = MOVETYPE_TOSS;
	self.th_stand = null;
	self.th_walk = null;
	self.th_run = null;
	self.th_missile = null;
	self.th_melee = null;
	self.th_pain = nullpain;
	self.solid = SOLID_TRIGGER;
	//drop_item(self.origin + '0 0 0', "shells_inv", 4, self);
	self.painframe = 1;
	self.glowmod = '1 1 1';
	float r = random();
	if(r < 1)
	{	
		self.frame = $opp_deatha1;
		sound(self, CHAN_AUTO, "enemies/oppressor/die1.ogg", 1, 0.25);
	}
	if(r < 0.67)
	{	
		self.frame = $opp_deathb1;
		sound(self, CHAN_AUTO, "enemies/oppressor/die2.ogg", 1, 0.25);
	}
	if(r < 0.33)
	{	
		self.frame = $opp_deathc1;
		sound(self, CHAN_AUTO, "enemies/oppressor/die3.ogg", 1, 0.25);
	}

	if(self.health < opp_dtg )
		self.think = oppressor_gibdead;
	else
	{
		self.think = oppressor_postdie;
		drop_item(self.origin + '0 0 0', "ammo_cannon", 5, self);
	}
	self.nextthink = time;
};


///////////////////////////////////////////////////////////////////////////////////////////
void() precache_monster_oppressor =
{
precache_model("models/enemies/oppressor/oppressor.md3");
precache_model("particles/oppressor/oppressor_fire1_1.md3");
precache_model("particles/oppressor/oppressor_fire1_2.md3");
precache_model("particles/oppressor/oppressor_fire1_3.md3");
precache_model("particles/oppressor/oppressor_fire1_4.md3");
precache_model("particles/oppressor/oppressor_fire1_5.md3");
precache_model("particles/oppressor/oppressor_fire2_1.md3");
precache_model("particles/oppressor/oppressor_fire2_2.md3");
precache_model("particles/oppressor/oppressor_fire2_3.md3");
precache_model("particles/oppressor/oppressor_fire2_4.md3");
precache_model("particles/oppressor/oppressor_fire2_5.md3");
precache_model("particles/impact/impact_oppressor1.md3");
precache_model("particles/impact/impact_oppressor2.md3");
precache_model("particles/impact/impact_oppressor3.md3");
precache_model("particles/impact/impact_oppressor4.md3");
precache_model("particles/impact/impact_oppressor5.md3");
precache_model("models/enemies/oppressor/gibs/cannon_l.md3");
precache_model("models/enemies/oppressor/gibs/cannon_r.md3");
precache_model("models/enemies/oppressor/gibs/foota.md3");
precache_model("models/enemies/oppressor/gibs/footb.md3");
precache_model("models/enemies/oppressor/gibs/head_back.md3");
precache_model("models/enemies/oppressor/gibs/head_bot_l.md3");
precache_model("models/enemies/oppressor/gibs/head_bot_r.md3");
precache_model("models/enemies/oppressor/gibs/head_face.md3");
precache_model("models/enemies/oppressor/gibs/head_top.md3");
precache_model("models/enemies/oppressor/gibs/leg_l.md3");
precache_model("models/enemies/oppressor/gibs/leg_r.md3");
precache_model("models/enemies/oppressor/gibs/pelvis.md3");
precache_model("models/enemies/oppressor/gibs/shoulder_l.md3");
precache_model("models/enemies/oppressor/gibs/shoulder_r.md3");
precache_sound("enemies/oppressor/chatter1.ogg");
precache_sound("enemies/oppressor/chatter2.ogg");
precache_sound("enemies/oppressor/chatter3.ogg");
precache_sound("enemies/oppressor/chatter4.ogg");
precache_sound("enemies/oppressor/chatter5.ogg");
precache_sound("enemies/oppressor/die1.ogg");
precache_sound("enemies/oppressor/die2.ogg");
precache_sound("enemies/oppressor/die3.ogg");
precache_sound("enemies/oppressor/fire1.ogg");
precache_sound("enemies/oppressor/fire2.ogg");
precache_sound("enemies/oppressor/fire3.ogg");
precache_sound("enemies/oppressor/fire4.ogg");
precache_sound("enemies/oppressor/fire5.ogg");
precache_sound("enemies/oppressor/idle1.ogg");
precache_sound("enemies/oppressor/idle2.ogg");
precache_sound("enemies/oppressor/idle3.ogg");
precache_sound("enemies/oppressor/pain1.ogg");
precache_sound("enemies/oppressor/pain2.ogg");
precache_sound("enemies/oppressor/pain3.ogg");
precache_sound("enemies/oppressor/preattack1.ogg");
precache_sound("enemies/oppressor/preattack2.ogg");
precache_sound("enemies/oppressor/preattack3.ogg");
precache_sound("enemies/oppressor/preattack4.ogg");
precache_sound("enemies/oppressor/preattack5.ogg");
precache_sound("enemies/oppressor/postattack1.ogg");
precache_sound("enemies/oppressor/postattack2.ogg");
precache_sound("enemies/oppressor/postattack3.ogg");
precache_sound("enemies/oppressor/postattack4.ogg");
precache_sound("enemies/oppressor/postattack5.ogg");
precache_sound("enemies/oppressor/sight.ogg");
precache_sound("enemies/oppressor/step1.ogg");
precache_sound("enemies/oppressor/step2.ogg");
precache_sound("enemies/oppressor/step3.ogg");
precache_sound("enemies/oppressor/step4.ogg");
precache_sound("enemies/oppressor/step5.ogg");
precache_sound("enemies/oppressor/proj_impact1.ogg");
precache_sound("enemies/oppressor/proj_impact2.ogg");
precache_sound("enemies/oppressor/proj_impact3.ogg");
precache_sound("enemies/oppressor/proj_loop.wav");
//precache_sound("enemies/oppressor/fire_loop.wav");
};

.string tagattached;
.float isplayingsound;


void() oppressor_emitter =
{
	// Reki (June 13 2023): if we're outside the PVS, just wait a bit before checking again
	if (!checkpvs(single_player.origin + single_player.view_ofs, self.owner))
	{
		self.think = oppressor_emitter;
		self.nextthink = time + 0.2;
		return;
	}

	self.think = oppressor_emitter;	
	self.nextthink = time + self.delay;

	if ((self.owner.classname != "crystallised"))
	{
		// Reki (June 13 2023): Moved oppressor fire over to particles instead of emitter entities
		pointparticles(particleeffectnum(self.particlename), self.origin, '0 0 0', 1);
		//spawn_model_emitter(self);
	}

	if (self.isplayingsound == 1)
	{
		self.isplayingsound = 0;
		sound(self, CHAN_WEAPON, "enemies/oppressor/fire_loop.wav", 1, 0.25);
	}
	
	if ((self.owner.health < 0) || (self.owner.classname == "crystallised") || (self.owner.classname != "monster_oppressor"))
	{	
		sound(self, CHAN_WEAPON, "misc/null.wav", 1, 1);
		self.think = SUB_Remove;
	}
	else
	{
		local vector tagorg;
		tagorg = tag_origin(self.tagattached, self.owner);
		setorigin(self, tagorg);
	}
};
void() oppressor_particles =
{
	if ((self.owner.classname != "crystallised"))
		pointparticles(particleeffectnum(self.particlename), self.origin, '0 0 0', 1);
	if((self.owner.health < 0)|| (self.owner.classname == "crystallised")||(self.classname != "monster_oppressor"))
	{
		self.think = SUB_Remove;
	}
	else
	{
		self.think = oppressor_particles;	
		local vector tagorg;
		tagorg = tag_origin(self.tagattached, self.owner);
		setorigin(self,tagorg);
	}
	self.nextthink = time + 0.5;
};

void(entity e) spawn_emitters =
{
	entity core = spawn();
	core.count = 1;
	core.tagattached = "tag_core";
	setmodel(core, "models/misc/null.md3");
	core.delay = 0.1;
	core.owner = e;
	core.origin = e.origin;
	core.min_size = 0.5;
	core.valpha = '0 1 1';
	core.particle_movetype =MOVETYPE_NOCLIP;
	core.max_size = 1;
	core.min_time = 0.15;
	core.max_time = 0.2;
	core.originjitter = '8 8 0';
	core.velocityjitter = '0 0 16';
	core.velocityoffset = '0 0 32';
	core.model_ammount = 5;
	core.model1 = "particles/oppressor/oppressor_fire1_1.md3";
	core.model2 = "particles/oppressor/oppressor_fire1_2.md3";
	core.model3 = "particles/oppressor/oppressor_fire1_3.md3";
	core.model4 =  "particles/oppressor/oppressor_fire1_4.md3";
	core.model5 = "particles/oppressor/oppressor_fire1_5.md3";
	core.particlename = "oppressor_fire_core";
	
	entity foot = spawn();
	foot.count = 1;
	setmodel(foot, "models/misc/null.md3");
	foot.tagattached = "tag_foota";
	foot.delay = 0.2;
	foot.owner = e;
	foot.origin = e.origin;
	foot.min_size = 0.5;
	foot.max_size = 1;
	foot.particle_movetype =MOVETYPE_NOCLIP;
	foot.valpha = '0 1 1';
	foot.min_time = 0.01;
	foot.max_time = 0.03;
	foot.originjitter = '4 4 0';
	foot.velocityjitter = '0 0 8';
	foot.model_ammount = 5;
	foot.velocityoffset = '0 0 16';
	foot.model1 = "particles/oppressor/oppressor_fire2_1.md3";
	foot.model2 = "particles/oppressor/oppressor_fire2_2.md3";
	foot.model3 = "particles/oppressor/oppressor_fire2_3.md3";
	foot.model4 = "particles/oppressor/oppressor_fire2_4.md3";
	foot.model5 = "particles/oppressor/oppressor_fire2_5.md3";
	foot.particlename = "oppressor_fire_foot";
	
	entity foot2 = spawn();
	foot2.count = 1;
	setmodel(foot2, "models/misc/null.md3");
	foot2.tagattached = "tag_footb";
	foot2.owner = e;
	foot2.origin = e.origin;
	foot2.delay = 0.2;
	foot2.min_size = 0.5;
	foot2.max_size = 1;
	foot2.valpha = '0 1 1';
	foot2.particle_movetype =MOVETYPE_NOCLIP;
	foot2.min_time = 0.01;
	foot2.max_time = 0.03;
	foot2.originjitter = '4 4 0';
	foot2.velocityjitter = '0 0 8';
	foot2.velocityoffset = '0 0 16';
	foot2.model_ammount = 5;
	foot2.model1 = "particles/oppressor/oppressor_fire2_1.md3";
	foot2.model2 = "particles/oppressor/oppressor_fire2_2.md3";
	foot2.model3 = "particles/oppressor/oppressor_fire2_3.md3";
	foot2.model4 = "particles/oppressor/oppressor_fire2_4.md3";
	foot2.model5 = "particles/oppressor/oppressor_fire2_5.md3";
	foot2.particlename = "oppressor_fire_foot";

	core.isplayingsound = 1;
	core.think = oppressor_emitter;
	foot.think = oppressor_emitter;
	foot2.think = oppressor_emitter;
	core.nextthink = time + (1 * random());
	foot.nextthink = time + (1 * random());
	foot2.nextthink = time + (1 * random());
	
	entity dripa = spawn();
	setmodel(dripa, "models/misc/null.md3");
	dripa.tagattached = "tag_dripa";
	entity dripb = spawn();
	setmodel(dripb, "models/misc/null.md3");
	dripb.tagattached = "tag_dripb";	
	dripa.owner = e;
	dripb.owner = e;
	dripa.origin = e.origin;
	dripb.origin = e.origin;
	dripa.particlename = "oppressor_slag_drops";
	dripb.particlename = "oppressor_slag_drops";
	dripa.think = oppressor_particles;
	dripb.think = oppressor_particles;
	dripa.nextthink = time + (1 * random());
	dripb.nextthink = time + (1 * random());
		
};	
/*WRATHED monster_oppressor (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() monster_oppressor = { precache_model("models/enemies/oppressor/oppressor.md3");
	if (deathmatch)
	{
		remove(self);
		return;
	}

	if (self.waypointed != 1)
		self.waypointed = 0;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/oppressor/oppressor.md3");
	setsize(self, opp_bboxn, opp_bbox);
	self.noise = "enemies/oppressor/sight.ogg";
	self.health = opp_health;
	self.damagetopain = opp_dtp;
 	self.classname = "monster_oppressor";
	self.th_stand = oppressor_stand1;
	self.th_walk = oppressor_walk1;
	if (!self.turret)
		self.th_run = oppressor_run1;
	else
		self.th_run = oppressor_runtattck1;
	self.stepheight_delta = 8;
	self.th_missile = oppressor_runtattck1;
	self.th_melee = oppressor_runtattck1;
	self.th_pain = oppressor_pain;
	self.th_die = oppressor_die;
	self.turretable = 1;
	self.heavymonster = 1;
	self.nextthink = time + 0.1;
	self.think = walkmonster_start;


};

////////////////end of qc file
