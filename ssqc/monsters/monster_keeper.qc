
$frame base

$frame kpr_idle1 kpr_idle2 kpr_idle3 kpr_idle4 kpr_idle5 kpr_idle6 kpr_idle7 kpr_idle8 kpr_idle9 kpr_idle10 kpr_idle11

$frame kpr_slow1 kpr_slow2 kpr_slow3 kpr_slow4 kpr_slow5 kpr_slow6 kpr_slow7 kpr_slow8 kpr_slow9 kpr_slow10 kpr_slow11 kpr_slow12

$frame kpr_fast1 kpr_fast2 kpr_fast3 kpr_fast4 kpr_fast5 kpr_fast6 kpr_fast7 kpr_fast8 

$frame kpr_gnrt1 kpr_gnrt2 kpr_gnrt3 kpr_gnrt4 kpr_gnrt5 kpr_gnrt6 kpr_gnrt7 kpr_gnrt8 kpr_gnrt9 kpr_gnrt10 kpr_gnrt11 kpr_gnrt12 kpr_gnrt13 kpr_gnrt14 kpr_gnrt15 kpr_gnrt16 kpr_gnrt17

$frame kpr_descend1 kpr_descend2 kpr_descend3 kpr_descend4 kpr_descend5 kpr_descend6 kpr_descend7 kpr_descend8 kpr_descend9 

$frame kpr_clamp1 kpr_clamp2 kpr_clamp3 kpr_clamp4 kpr_clamp5  kpr_clamp6

$frame kpr_launch1 kpr_launch2 kpr_launch3 kpr_launch4 kpr_launch5 kpr_launch6 kpr_launch7 kpr_launch8 kpr_launch9 kpr_launch10 kpr_launch11 kpr_launch12 kpr_launch13 kpr_launch14

$frame kpr_paina1 kpr_paina2 kpr_paina3 kpr_paina4 kpr_paina5 kpr_paina6 kpr_paina7 kpr_paina8 kpr_paina9 kpr_paina10  kpr_paina11

$frame kpr_painb1 kpr_painb2 kpr_painb3 kpr_painb4 kpr_painb5 kpr_painb6 kpr_painb7 kpr_painb8 kpr_painb9 kpr_painb10  kpr_painb11

$frame kpr_painc1 kpr_painc2 kpr_painc3 kpr_painc4 kpr_painc5 

$frame kpr_paind1 kpr_paind2 kpr_paind3 kpr_paind4 kpr_paind5 

$frame kpr_idleb1 kpr_idleb2 kpr_idleb3 kpr_idleb4 kpr_idleb5 kpr_idleb6 kpr_idleb7 kpr_idleb8 kpr_idleb9 kpr_idleb10 kpr_idleb11


.float keeper_search_time;
.float keeper_wander_time;
.float following_monster;
float (entity targ) visible_keeper;

void()height_controller_think =
{


	if(self.owner.time_float == 0)
	{
		self.owner.velocity_z = self.owner.velocity_z * 0.95;
		float nextthink_time =  0.1;
	}

	if(self.owner.time_float == 2)
	{
		vector t_dest = self.owner.origin - '0 0 256';
		traceline((self.owner.origin), t_dest, MOVE_WORLDONLY, self);
		float distance_to_floor = vlen (self.owner.origin - trace_endpos);
		if (trace_fraction != 1.0)
		{
			if(distance_to_floor < 192)
				self.owner.velocity_z = distance_to_floor / (1/0.25);
			else
				self.owner.velocity_z = 0; 
		}
		else
		{
			if(distance_to_floor > 192 )
				self.owner.velocity_z =-1 * distance_to_floor / (1/0.25); 
			else
				self.owner.velocity_z = 0; 
		}
		nextthink_time =  random( 1, 2.5);
	}

	if(self.owner.time_float == 1)
	{
		setorigin (self, self.owner.origin);
		vector xy_selforigin, xy_targetorigin;

		xy_selforigin = self.origin;
		xy_targetorigin = self.enemy.origin;
		xy_selforigin_z = 0;
		xy_targetorigin_z = 0;
		

		if(((vlen(xy_targetorigin - xy_selforigin) < 128) && (xy_targetorigin_z > xy_selforigin_z)) &&  (self.owner.following_monster == 1))
		{
			self.owner.velocity_z = random (254,274); 
			return;
		}	
		else
			self.owner.velocity_z = 0; 
		makevectors(self.owner.angles);
		t_dest = self.owner.origin - '0 0 256';
		traceline((self.origin), t_dest, MOVE_WORLDONLY, self);
		
		distance_to_floor = vlen (self.origin - trace_endpos);

		nextthink_time =  random( 0.1, 0.5);

		if(self.owner.following_monster != 1)
		{
			if (trace_fraction != 1.0)
			{
				if(distance_to_floor < 192)
					self.owner.velocity_z = distance_to_floor / (1/nextthink_time);
				else
					self.owner.velocity_z = 0; 
			}
			else
			{
				if(distance_to_floor > 192 )
					self.owner.velocity_z =-1 * distance_to_floor / (1/nextthink_time); 
				else
					self.owner.velocity_z = 0; 
			}
		}
	}
	self.think = height_controller_think;
	self.nextthink = time + nextthink_time ; 	
};


void() check_alerted_monsters = 
{ 
	local entity head, near;
	local float dist, gdist, low, distanthealth;
	low = 99999;	
	head = find(world, classentity, "monsters");
	while (head)
	{
		gdist = vlen(head.origin - self.origin);
		dist = gdist;
		distanthealth = gdist + (3000 - head.health);
		if ((head != self) && (visiblebox(head)) && (head.enemy == single_player) && (dist <= 2048))
		{		
			if (head.health > 0)
			{
				if (distanthealth < low)
				{
					low = distanthealth;
					near = head;
				}
			}
		}
		head = find(head, classentity, "monsters");
	}

	if (near)
	self.enemy = near;


};


.float enemyonspot;
void(float dist, float isaligned)ai_keeper_fly =
{
	float enemy_is_visible = visible_keeper(self.enemy);
	if(enemy_is_visible)
	{
		self.lastplace_spoted = self.enemy.origin;
		self.enemyonspot = 1;
		self.velocity_z = self.velocity_z * 0.95;

	}
	
	if(self.enemyonspot == 1)
	{
		self.keeper_search_time = time + random(1,3);
		self.enemyonspot = 0;

		if (isaligned)
			self.lastplace_spoted += '0 0 192'; 
		else
			self.lastplace_spoted += '0 0 128'; 


		self.ideal_yaw = vectoyaw(self.lastplace_spoted - rorigin(self));
		ChangeYaw();

		self.velocity = normalize (self.lastplace_spoted - rorigin(self)) * dist * 12;

	}
};
void()keeper_fast1;
void()keeper_wander1;
void()keeper_stand1;


void() keeperparticlespawner =
{
	setorigin (self,self.owner.origin);
	self.cnt --;
	float ammount = self.cnt;

	if(ammount <= 0)
		ammount = 1;
	pointparticles(particleeffectnum("keeperlaunch3"), self.origin + ' 0 0 12', '0 0 0',ammount);
	if(self.lifetime < time)
		self.think = SUB_Remove;
	else
		self.think = keeperparticlespawner;
	self.nextthink =  time + random(0.1,0.5);

};
void() keeper_launch1 =[$kpr_launch1, keeper_launch]
{
	self.pipes.max_size = 0.35;
	self.pipes.min_size = 0.25;	
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20) * (1/0.5);
	self.time_float = 0;
	self.oldthink = keeper_launch1;

	if(self.timefootstep < time)
	{
		pointparticles(particleeffectnum("keeperdecal"), self.spriteorg, '0 0 0', 2);
		pointparticles(particleeffectnum("keeperdecalbase"), self.spriteorg, '0 0 0', 1);
	}	
	pointparticles(particleeffectnum("keeperlaunch"), self.origin +'0 0 32', '0 0 0', 2);
	pointparticles(particleeffectnum("keeperlaunch2"), self.origin +'0 0 32', '0 0 0', 2);
};
void() keeper_launch =
{

	if(self.frame == $kpr_launch8)
	{
		setorigin (self,self.origin + '0 0 37');
		self.velocity_z += 20;
		setsize(self, '-16 -16 0', '16 16 64');
	}
	if(self.frame > $kpr_launch8)
		self.velocity_z += 16;
	self.frame ++;
	self.time_float = 0;
	float enemy_is_visible = visible_keeper(self.enemy);
	if(self.frame < $kpr_launch14)
		self.think = keeper_launch;
	else
	{
		if(!enemy_is_visible)
		{ 
			if (time > self.keeper_search_time)
				self.following_monster = 0;
			else
				self.following_monster = 1;
		}

		if(enemy_is_visible)
			self.following_monster = 1;

		if(self.following_monster == 1)
			self.think = keeper_fast1;
		else
			self.think = keeper_wander1;
	}
	self.nextthink = time + 0.1; 

	entity particlespawner = spawn();
	particlespawner.owner = self;
	particlespawner.think = keeperparticlespawner;
	particlespawner.nextthink =  time;
	particlespawner.cnt = 5;
	particlespawner.lifetime =  time + random(1.5,3);
};

void() keeper_standb1 =[$kpr_idleb1, keeper_standb]
{
	self.pipes.max_size = 0.5;
	self.pipes.min_size = 0.25;
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);
	self.oldthink = keeper_standb1;
	self.time_float = -1;
	self.velocity = '0 0 0';
};
void()keeper_standb =
{
	self.frame ++;
	if(self.frame > $kpr_idleb11)
		self.frame = $kpr_idleb1;

	float alerted = FALSE;
	self.time_noturret2 = time + 0.5;
	if((self.enemy.flags & FL_MONSTER) && (self.enemy.health > 0)&& (self.enemy.enemy == single_player))
		alerted = TRUE;
	self.time_float = -1;
	
	if(alerted == FALSE)
		check_alerted_monsters();

	if(alerted == TRUE)
		self.think = keeper_launch1;
	else
		self.think = keeper_standb;

	self.nextthink = time + 0.1; 
};

void() keeper_clamp1 =[$kpr_clamp1, keeper_clamp]
{	
	self.oldthink = keeper_clamp1;
	self.pipes.max_size = 0.5;
	self.pipes.min_size = 0.25;
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);
};
void() keeper_clamp =
{
	self.frame ++;
	if(self.frame == $kpr_clamp2)
	{
		self.timefootstep = time + 20;
	}
    self.oldthink = keeper_clamp;
	if(self.frame >= $kpr_clamp6)
	{
		vector tagorg = tag_origin("tag_kneea",self) + '0 0 64'; traceline (tagorg ,tagorg - '0 0 128',MOVE_WORLDONLY,self);tagorg =trace_endpos;
		pointparticles(particleeffectnum("keeperdecal"), tagorg, '0 0 0', 1);
		tagorg = tag_origin("tag_kneeb",self) + '0 0 64'; traceline (tagorg,tagorg - '0 0 128',MOVE_WORLDONLY,self);tagorg =trace_endpos;
		pointparticles(particleeffectnum("keeperdecal"), tagorg, '0 0 0', 1);
		tagorg = tag_origin("tag_kneec",self) + '0 0 64'; traceline (tagorg,tagorg - '0 0 128',MOVE_WORLDONLY,self);tagorg =trace_endpos;
		pointparticles(particleeffectnum("keeperdecal"), tagorg, '0 0 0', 1);
		tagorg = tag_origin("tag_kneed",self) + '0 0 64'; traceline (tagorg,tagorg - '0 0 128',MOVE_WORLDONLY,self);tagorg =trace_endpos;
		pointparticles(particleeffectnum("keeperdecal"), tagorg, '0 0 0', 1);
		tagorg = tag_origin("tag_kneee",self) + '0 0 64'; traceline (tagorg,tagorg - '0 0 128',MOVE_WORLDONLY,self);tagorg =trace_endpos;
		pointparticles(particleeffectnum("keeperdecal"), tagorg, '0 0 0', 1);

		self.think = keeper_standb1;
		self.frame = $kpr_clamp6;
	}
	else
		self.think = keeper_clamp;
	self.nextthink = time + 0.1; 
};

void() keeper_descend1 =[$kpr_descend1, keeper_descend]
{ 
	self.velocity_z = 0;
	self.pipes.max_size = 0.35;
	self.pipes.min_size = 0.25;
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);
	setsize(self, '-16 -16 28', '16 16 62');
    self.oldthink = keeper_descend1;
};
void()keeper_descend =
{
	self.frame ++;
    self.oldthink = keeper_descend;
	if(self.frame > $kpr_descend9)
		self.frame = $kpr_descend9;
	self.time_float = 0;
	self.velocity_x =  self.velocity_x * 0.975;
	self.velocity_y =  self.velocity_y * 0.975;
	self.velocity_z -= 7;

	
	vector t_dest = (self.origin + '0 0 29') + '0 0 -16';
	traceline((self.origin + '0 0 29'), t_dest, TRUE, self);
	if (trace_fraction != 1.0)
	{
		self.spriteorg = trace_endpos +'0 0 2';
		if((trace_ent.solid == SOLID_BSP) || (trace_ent == world))
		float onground = 1;
	}
	if((onground == 1) && ((self.origin_z == self.oldorigin_z) || (self.flags & FL_ONGROUND)))
	{	
		self.think = keeper_clamp1;
		pointparticles(particleeffectnum("keeperlaunch2"), self.origin +'0 0 64', '0 0 0', 2);
		pointparticles(particleeffectnum("keeperdecalbase"), self.spriteorg, '0 0 0', 1);

	}
	else
		self.think = keeper_descend;		
	self.oldorigin = self.origin;

	if(self.frame >= $kpr_descend9)
		self.nextthink = time + 0.0125; 
	else
		self.nextthink = time + 0.1; 

};

void() keeper_wander1 =[$kpr_slow1, keeper_wander]
{

	self.pipes.max_size = 0.35;
	self.pipes.min_size = 0.25;
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);
	self.keeper_wander_time =  time + random(2,3);
	self.enemy = world;
    self.oldthink = keeper_wander1;
};
void()keeper_wander =
{
	self.frame ++;
    self.oldthink = keeper_wander;
	if(self.frame > $kpr_slow12)
		self.frame = $kpr_slow1;
	check_alerted_monsters();
	self.velocity_x =  self.velocity_x * 0.97;
	self.velocity_y =  self.velocity_y * 0.97;


	float enemy_is_visible = visible_keeper(self.enemy);
	if(!enemy_is_visible)
	self.time_float = 2;
	else
	self.time_float = 1;

	if((self.enemy != world) && (self.enemy.flags & FL_MONSTER) && (self.enemy.health > 0)&& (self.enemy.enemy == single_player))
		self.think = keeper_fast1;
	else
	{	

		if(self.keeper_wander_time > time)
			self.think = keeper_wander;
		else
		{
			tracebox(self.origin, '-16 -16 -0', '16 16 0', self.origin - '0 0 1024', 3, self);
			if (trace_fraction != 1.0)
				self.think = keeper_descend1;		
			else
			{
				self.keeper_wander_time = time + random(1,2);
				self.velocity_x = random(-512,512);
				self.velocity_y = random(-512,512);
				self.think = keeper_wander;
			}
		}		
	}
	self.nextthink = time + 0.1; 
};


.float spawned_shield;
void() scale_shield =
{
	if(self.alpha < 1)
	{
		self.light_lev += 12.8;
		self.alpha += 0.025;
		if(self.owner.classname == "func_crystal_boss")
			self.scale += martyr_radius / 7000;
		else
			self.scale += martyr_radius / 4267;

		self.owner.glowmod_x += 0.1;
		self.owner.glowmod_y += 0.075;
		self.owner.glowmod_z += 0.05;
	}

	if(self.owner.TrinketofRespite == 0)
	{
		self.glowmod = '0.05 0.05 0.05';
		chattersound("enemies/keeper/shield_end", 2, 1);
		self.think = lance_muzzle_think;
	}
	else
		self.think = scale_shield;

	if(self.alpha <= 1)
	{
		vector orbsize_n, orbsize;

		if(self.owner.classname == "func_crystal_boss")
		{
			orbsize_n_x = -martyr_radius * self.alpha * 0.58;
			orbsize_n_y = -martyr_radius * self.alpha * 0.58;
			orbsize_n_z = -martyr_radius * self.alpha * 0.58;

			orbsize_x = martyr_radius * self.alpha * 0.58;
			orbsize_y = martyr_radius * self.alpha * 0.58;
			orbsize_z = martyr_radius * self.alpha * 0.58;
		}
		else
		{
			orbsize_n_x = -martyr_radius * self.alpha* 0.8;
			orbsize_n_y = -martyr_radius * self.alpha* 0.8;
			orbsize_n_z = -martyr_radius * self.alpha* 0.8;

			orbsize_x = martyr_radius * self.alpha* 0.8;
			orbsize_y = martyr_radius * self.alpha* 0.8;
			orbsize_z = martyr_radius * self.alpha* 0.8;

		}

		setsize(self, orbsize_n, orbsize);
	}
	vector orb_offset;
	orb_offset_z = martyr_orb_offset;
	if(self.owner.classname != "func_crystal_boss")
		setorigin (self, self.owner.origin  + orb_offset);
	force_retouch = 2;
	self.nextthink = time + 0.05;
};
void() orb_touch =
{
	if(other.owner.classname == "boss_guardian2")
		return;
	other.orb_time = time + 0.5;
	if((other.wrathflags & FL_PROJECTILE)&&  (other.owner  != self.owner) && (other.trinket_touched != 1) && (other.owner.orb_time < time))
	{

		chattersound("enemies/keeper/shield_ricochet", 5, 1);
		if(other.classname == "projectile_shot")
			{float bparticle = particleeffectnum("forcefieldsmall"); string string_sound = "impact/projectiles/trinket_small.ogg";}
		else if((other.classname == "spleetcyst") || (other.classname == "ore2"))
			{bparticle = particleeffectnum("forcefieldbig"); string_sound = "impact/projectiles/trinket_med.ogg";}
		else
			{bparticle = particleeffectnum("forcefield"); string_sound = "impact/projectiles/trinket_med.ogg";}
		sound (other, CHAN_AUTO, string_sound, 1, 0.25);	// stop loop sound if present

		if(self.owner.classname == "func_crystal_boss")
			bparticle = particleeffectnum("forcefieldboss2");
		pointparticles(bparticle, other.origin,(other.velocity), 1);


		if(self.owner.classname == "func_crystal_boss")
		{
			pointparticles( particleeffectnum("forcefieldboss2"), other.origin,(other.velocity), 1);
			other.touch = SUB_Null;
			other.solid = 0;
			other.velocity = other.velocity * 0.25;
			other.movetype = MOVETYPE_FLY;
			other.alphatime = 0.2;
			other.think = alphafade;
			other.nextthink = time;
			return;

		}
		else
		{
			other.velocity_x = other.velocity_x * random (-1.5, -0.5);
			other.velocity_y = other.velocity_y * random (-1.5, -0.5);
			other.velocity_z = other.velocity_z * random (-1.5, -0.5);
			other.angles = vectoangles(other.velocity);
			other.owner = self.owner;
			other.trinket_touched = 1;
		}
	}
};

float (entity targ) visible_keeper =
{
	if(wasfreed(targ))
		return FALSE;
	if(visible(targ))
	{
		if((targ.health > 0) && (targ.classentity == "monsters") && (targ.flags & FL_MONSTER))
			return TRUE;
		else
			return FALSE;

	}
	else
		return FALSE;
};

void() keeper_generate1 =[$kpr_gnrt1, keeper_generate]{
    
	self.pipes.max_size = 0.75;
	self.pipes.min_size = 0.25;
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);
    self.oldthink = keeper_generate1;

};
void() keeper_generate =
{
    self.oldthink = keeper_generate;
	self.think = keeper_generate;
	self.frame ++;
	if(self.frame > $kpr_gnrt17)
		self.frame = $kpr_gnrt1;


	float enemy_is_visible = visible_keeper(self.enemy);
	if(!enemy_is_visible)
		self.time_float = 2;
	else
		self.time_float = 1;
	vector enorg, sforg;
	enorg_x = self.enemy.origin_x;
	enorg_y = self.enemy.origin_y;

	sforg_x = self.origin_x;
	sforg_y = self.origin_y;

	float hdist = vlen(enorg - sforg);


	if((self.TrinketofRespite != 1) && (self.frame >= $kpr_gnrt12))
	{
		chattersound("enemies/keeper/shield_start", 2, 1);
		string shieldmodel = "models/enemies/keeper/orb_keeper.md3";
		entity shield = spawn();
		shield.owner = self;
		shield.frame = 2;
		shield.alpha = 0.05;
		shield.pflags = 129;
		//shield.colormod = '2 0.2 0.1';
		shield.color = '1 0.3 0.3';
		shield.think = scale_shield;
		shield.touch = orb_touch;
		shield.scale = 0.1;
		shield.solid = SOLID_TRIGGER;
		shield.nextthink = time + 0.05;
		setmodel(shield, shieldmodel);
		shield.origin = self.origin + '0 0 160';
		self.TrinketofRespite = 1;
	}

	if(self.TrinketofRespite == 1) 
		self.radial_time =  time + 0.25;



	enemy_is_visible = visible_keeper(self.enemy);
	if(!enemy_is_visible)
	{ 
		if (time > self.keeper_search_time)
			self.following_monster = 0;
		else
			self.following_monster = 1;
	}

	if(enemy_is_visible)
		self.following_monster = 1;

	if(self.enemy.classentity != "monsters")
		self.following_monster = 0;

	if(self.enemy.health <= 0)
		self.following_monster = 0;

	if (self.following_monster == 1)
		self.think = keeper_generate;	
	else
	{
		self.TrinketofRespite = 0;
		self.think = keeper_stand1;	
	}

	if(hdist < 96)
	{

		float kpr_speed;
		kpr_speed = (hdist / 96) * 15; 
		ai_keeper_fly (kpr_speed,1);
	}
	else
	{
		if (self.pain_finished > time)
			ai_keeper_fly (27,1);
		else
			ai_keeper_fly (17,1);
	}

	self.nextthink = time + 0.1; 
};

void() keeper_fast1 =[$kpr_fast1, keeper_fast]
{
	self.pipes.max_size = 0.35;
	self.pipes.min_size = 0.25;
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);
	chattersound("enemies/keeper/sight", 3, 1);
    self.oldthink = keeper_fast1;

};
void() keeper_fast =
{
    self.oldthink = keeper_fast;
	self.frame ++;
	if(self.frame > $kpr_fast8)
		self.frame = $kpr_fast1;
	if (self.sight_time < time)
	{
		chattersound("enemies/keeper/chatter", 3, 1);
		self.sight_time = time + random(3,7);
	}
	float enemy_is_visible = visible_keeper(self.enemy);
	if(enemy_is_visible)
		self.following_monster = 1;


	if(!enemy_is_visible)
		self.time_float = 2;
	else
		self.time_float = 1;


	if(enemy_is_visible != 1) 
	{ 
		if (time > self.keeper_search_time)
			self.following_monster = 0;
		else
			self.following_monster = 1;
	}



	if(self.following_monster == 1)
	{	
		
		vector enorg, sforg;
		enorg_x = self.enemy.origin_x;
		enorg_y = self.enemy.origin_y;

		sforg_x = self.origin_x;
		sforg_y = self.origin_y;

		float hdist = vlen(enorg - sforg);

		if(hdist < 48)
			self.think = keeper_generate1;
		else
			self.think = keeper_fast;
	}
	else
	{
		self.velocity_x = self.velocity_x * random(1,2);
		self.velocity_y = self.velocity_y * random(1,2);
		self.think = keeper_wander1;
	}
	ai_keeper_fly (20,0);
	self.nextthink = time + 0.1; 
};


void() keeper_stand1 =[$kpr_idle1, keeper_stand]{
    
    self.oldthink = keeper_stand1;
	self.pipes.max_size = 0.35;
	self.pipes.min_size = 0.25;
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);

};
void()keeper_stand =
{
    self.oldthink = keeper_stand;
	self.frame ++;
	float alerted = FALSE;
	if((self.enemy.flags & FL_MONSTER) && (self.enemy.health > 0)&& (self.enemy.enemy == single_player))
		alerted = TRUE;
	self.time_float = 2;
	if(alerted == FALSE)
		check_alerted_monsters();

	if(self.frame > $kpr_idle11)
		self.frame = $kpr_idle1;

	if(alerted == TRUE)
		self.think = keeper_fast1;
	else
	{
		if((visible(single_player)) && (!(single_player.flags &FL_NOTARGET)))
			self.think = keeper_wander1;
		else
			self.think = keeper_stand;
	}


	if (self.sight_time < time)
	{
		chattersound("enemies/keeper/idle", 4, 1);
		self.sight_time = time + random(5,10);
	}
	self.nextthink = time + 0.1; 
};


void() keeper_paina1 =[$kpr_paina1, keeper_paina2] {
	
	vector dir = normalize (self.origin - self.execution_enemy.origin); 
	dir = dir * 64;
	dir_z = dir_z * 0.5;
	self.velocity += dir;


};
void() keeper_paina2 =[$kpr_paina2, keeper_paina3] {};
void() keeper_paina3 =[$kpr_paina3, keeper_paina4] {};
void() keeper_paina4 =[$kpr_paina4, keeper_paina5] {};
void() keeper_paina5 =[$kpr_paina5, keeper_paina6] {};
void() keeper_paina6 =[$kpr_paina6, keeper_paina7] {};
void() keeper_paina7 =[$kpr_paina7, keeper_paina8] {};
void() keeper_paina8 =[$kpr_paina8, keeper_paina9] {};
void() keeper_paina9 =[$kpr_paina9, keeper_paina10] {};
void() keeper_paina10 =[$kpr_paina10, keeper_paina11] {};
void() keeper_paina11 =[$kpr_paina11, keeper_generate] {};

void() keeper_painb1 =[$kpr_painb1, keeper_painb2] 
{
	vector dir = normalize (self.origin - self.execution_enemy.origin); 
	dir = dir * 32;
	dir_z = dir_z * 0.25;
	self.velocity += dir;
};
void() keeper_painb2 =[$kpr_painb2, keeper_painb3] {};
void() keeper_painb3 =[$kpr_painb3, keeper_painb4] {};
void() keeper_painb4 =[$kpr_painb4, keeper_painb5] {};
void() keeper_painb5 =[$kpr_painb5, keeper_painb6] {};
void() keeper_painb6 =[$kpr_painb6, keeper_painb7] {};
void() keeper_painb7 =[$kpr_painb7, keeper_painb8] {};
void() keeper_painb8 =[$kpr_painb8, keeper_painb9] {};
void() keeper_painb9 =[$kpr_painb9, keeper_painb10] {};
void() keeper_painb10 =[$kpr_painb10, keeper_painb11] {};
void() keeper_painb11 =[$kpr_painb11, self.oldthink] {};

void() keeper_painc1 =[$kpr_painc1, keeper_painc2] {};
void() keeper_painc2 =[$kpr_painc2, keeper_painc3] {};
void() keeper_painc3 =[$kpr_painc3, keeper_painc4] {};
void() keeper_painc4 =[$kpr_painc4, keeper_painc5] {};
void() keeper_painc5 =[$kpr_painc5, keeper_standb1] {};

void() keeper_paind1 =[$kpr_paind1, keeper_paind2] {};
void() keeper_paind2 =[$kpr_paind2, keeper_paind3] {};
void() keeper_paind3 =[$kpr_paind3, keeper_paind4] {};
void() keeper_paind4 =[$kpr_paind4, keeper_paind5] {};
void() keeper_paind5 =[$kpr_paind5, keeper_standb1] {};

void(entity a,float b) keeper_pain =
{
	if (self.pain_finished > time)
	{
		self.think = self.oldthink;
		self.nextthink = time;
		return;
	}
	self.pain_finished = time + random(2,3);
	chattersound("enemies/keeper/pain", 3, 1);

	self.pipes.max_size = 0.25;
	self.pipes.min_size = 0.0;
	self.pipes.glowmod ='0.01 0.01 0.01';
	self.glowmod ='0.01 0.01 0.01';
	self.pipes.count = ((self.pipes.max_size - self.pipes.min_size) / 20);

	if(	self.time_float == -1)
	{
		float r = random();	
		if(r < 0.5)
			self.think = keeper_painc1;
		else
			self.think = keeper_paind1;

	}
	else
	{
		if(self.radial_time < time)
			self.think = keeper_paina1;
		else
			self.think = keeper_painb1;
	}


	self.nextthink = time;
};


vector(vector a, vector b) centervel =
{

	if (a_z <= b_z)
		a_z = b_z;
	b_z -= 5;
	
	vector dir = normalize (a -b);
	return dir;
} 

void() keeper_die_gib =
{
	self.alpha = -1;
	decal_monster_gib(self.origin + '0 0 12');
	vector tagorg = tag_origin("tag_body", self);// relvel: forward, right, up
	pointparticles(particleeffectnum("wretch_bloodshower"), tagorg , '0 0 0', 1);
	explo_blood(2, tagorg);	
	explo_blood(9, tagorg);	
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib17, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib19, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib21, self), 0, 3);	// relvel: forward, right, up

	ThrowGib3(self, "models/enemies/keeper/gibs/body.md3", 0, 0.75, 1, 1, tagorg, relvel('64 0 128', self), 0, 3);	 
	tagorg = tag_origin("tag_brainb",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/braina.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin) * random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_brainb",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/brainb.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_brainc",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/brainc.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_lega",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/lega.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legb",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legb.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legc",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legc.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legd",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legd.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_lege",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/lege.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legf",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legf.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legg",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legg.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legh",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legh.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legi",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legi.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_legj",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/legj.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3);	 
	tagorg = tag_origin("tag_tail",self);
	ThrowGib3(self, "models/enemies/keeper/gibs/tail.md3", 0, 0.75, 1, 1, tagorg, centervel(tagorg , self.origin)* random(128,192), 0, 3); 
	monster_death_use();
	self.nextthink = time + 0.05;
	self.think = SUB_Remove;
};

void() keeper_die =
{
	remove(self.pipes);
	self.TrinketofRespite = 0;
	self.nextthink = time + 0.05;
	self.think = keeper_die_gib;
};

void() glow_controller_think =
{

	if((self.glowmod_x >= self.max_size) && (self.cnt == 1))
		self.cnt = -1;

	if((self.glowmod_x <= self.min_size) && (self.cnt == -1))
		self.cnt = 1;

	if(self.cnt == -1)
		self.glowmod_x -= self.count /2;
	if(self.cnt == 1)
		self.glowmod_x += self.count /2;

	if(self.glowmod_x <= 0)
		self.glowmod_x  = 0.1;

	self.owner.glowmod_x = self.glowmod_x;
	self.owner.glowmod_y = self.glowmod_x;
	self.owner.glowmod_z = self.glowmod_x;


	self.nextthink = time + 0.025;
	self.think = glow_controller_think;

};

void() precache_monster_keeper =
{
	precache_sound("enemies/keeper/chatter1.ogg");
	precache_sound("enemies/keeper/chatter2.ogg");
	precache_sound("enemies/keeper/chatter3.ogg");
	precache_sound("enemies/keeper/die1.ogg");
	precache_sound("enemies/keeper/die2.ogg");
	precache_sound("enemies/keeper/die3.ogg");
	precache_sound("enemies/keeper/idle1.ogg");
	precache_sound("enemies/keeper/idle2.ogg");
	precache_sound("enemies/keeper/idle3.ogg");
	precache_sound("enemies/keeper/idle4.ogg");
	precache_sound("enemies/keeper/pain1.ogg");
	precache_sound("enemies/keeper/pain2.ogg");
	precache_sound("enemies/keeper/pain3.ogg");
	precache_sound("enemies/keeper/sight1.ogg");
	precache_sound("enemies/keeper/sight2.ogg");
	precache_sound("enemies/keeper/sight3.ogg");
	precache_sound("enemies/keeper/shield_end1.ogg");
	precache_sound("enemies/keeper/shield_end2.ogg");
	precache_sound("enemies/keeper/shield_start1.ogg");
	precache_sound("enemies/keeper/shield_start2.ogg");
	precache_sound("enemies/keeper/shield_loop.ogg");
	precache_sound("enemies/keeper/shield_ricochet1.ogg");
	precache_sound("enemies/keeper/shield_ricochet2.ogg");
	precache_sound("enemies/keeper/shield_ricochet3.ogg");
	precache_sound("enemies/keeper/shield_ricochet4.ogg");
	precache_sound("enemies/keeper/shield_ricochet5.ogg");

	precache_model("models/enemies/keeper/gibs/body.md3");
	precache_model("models/enemies/keeper/gibs/braina.md3");
	precache_model("models/enemies/keeper/gibs/brainb.md3");
	precache_model("models/enemies/keeper/gibs/brainc.md3");
	precache_model("models/enemies/keeper/gibs/lega.md3");
	precache_model("models/enemies/keeper/gibs/legb.md3");
	precache_model("models/enemies/keeper/gibs/legc.md3");
	precache_model("models/enemies/keeper/gibs/legd.md3");
	precache_model("models/enemies/keeper/gibs/lege.md3");
	precache_model("models/enemies/keeper/gibs/legf.md3");
	precache_model("models/enemies/keeper/gibs/legg.md3");
	precache_model("models/enemies/keeper/gibs/legh.md3");
	precache_model("models/enemies/keeper/gibs/legi.md3");
	precache_model("models/enemies/keeper/gibs/legj.md3");
	precache_model("models/enemies/keeper/gibs/tail.md3");
	precache_model("models/enemies/keeper/keeper.md3");
	precache_model("models/enemies/keeper/orb_keeper.md3");
};
void() monster_keeper = 
{ 
	precache_monster_keeper();
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	setmodel(self, "models/enemies/keeper/keeper.md3");
	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 1500;
	self.classname = "monster_keeper";
	self.takedamage = DAMAGE_YES;
	self.flags = 0;
	self.th_pain = keeper_pain;
	self.th_die = keeper_die;
	self.yaw_speed = 5;
	self.bloody = 2;
	entity height_controller = spawn();
	height_controller.owner =self;
	height_controller.think = height_controller_think;
	height_controller.nextthink = time;

    if(self.warped == 1)
    {
		entity color_controller = spawn();
		setmodel	 (color_controller,"");
		color_controller.warpframe = 1;
		color_controller.owner = self;
		color_controller.colormod = self.colormod;
		color_controller.think = color_controller_think;
		color_controller.nextthink = time;
    }

	entity glow_controller = spawn();
	setmodel	 (glow_controller,"");
	glow_controller.owner = self;
	glow_controller.think = glow_controller_think;
	glow_controller.nextthink = time;
	glow_controller.max_size = 0.25;
	glow_controller.min_size = 0;
	glow_controller.cnt = 1;
	glow_controller.count = 0.05;

	self.pipes = glow_controller;

	self.use = keeper_stand1;
	self.think = keeper_stand1;
	self.th_stand = keeper_stand1;
	self.th_run = keeper_stand1;
	self.th_melee = keeper_stand1;

	self.nextthink = time + random(0.1,0.3);

};
